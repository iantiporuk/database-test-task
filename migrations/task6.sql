# add column bookstore_id to t_report_sold_books table to determine the store where a book was sold.
ALTER TABLE t_report_sold_books
    ADD bookstore_id INT NOT NULL;

# add column is_processed to t_report_sold_books
ALTER TABLE t_report_sold_books
    ADD is_processed BIT(1) DEFAULT b'0';

CREATE INDEX t_report_sold_books_is_processed_insert_date_index
    ON t_report_sold_books (is_processed, insert_date);

DROP PROCEDURE IF EXISTS insert_sold_books;
DELIMITER $$

CREATE PROCEDURE insert_sold_books()
BEGIN
    DECLARE cur_report_id INT;
    DECLARE cur_book_price FLOAT(5, 2);
    DECLARE cur_book_isbn VARCHAR(13);
    DECLARE cur_author_email VARCHAR(100);
    DECLARE cur_book_id INT;
    DECLARE cur_bookstore_id INT;
    DECLARE cur_bookstore_book_id INT;
    DECLARE cur_status BIT(1) DEFAULT b'0';
    DECLARE done INT DEFAULT FALSE;
    # get unprocessed report data
    DECLARE cur CURSOR FOR SELECT id,
                                  book_isbn,
                                  book_price,
                                  author_email,
                                  status,
                                  bookstore_id
                           FROM t_report_sold_books as trsb
                           WHERE trsb.insert_date >= (
                               SELECT update_date
                               FROM tickmill.t_bookstore_sold_books
                               ORDER BY update_date DESC
                               LIMIT 1
                           )
                             AND is_processed = b'0';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION ROLLBACK;
    DECLARE CONTINUE HANDLER FOR SQLWARNING ROLLBACK;

    CREATE TEMPORARY TABLE IF NOT EXISTS result
    (
        report_id         INT,
        book_id           INT,
        book_isbn         VARCHAR(13),
        book_price        FLOAT(5, 2),
        author_email      VARCHAR(100),
        bookstore_id INT
    );

    SET autocommit = 0;

    OPEN cur;
    read_loop:
    LOOP
        FETCH cur INTO cur_report_id, cur_book_isbn, cur_book_price, cur_author_email, cur_status, cur_bookstore_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        START TRANSACTION;
            # get bookstore_book_id, book_id if match conditions
            SELECT tbb.id, tb.id
            INTO cur_bookstore_book_id, cur_book_id
            FROM t_bookstore_books AS tbb
                     JOIN t_books AS tb on tbb.book_id = tb.id AND tb.isbn = cur_book_isbn
                     JOIN t_book_authors tba on tb.user_id = tba.id AND tba.email = cur_author_email
            WHERE tbb.store_id = cur_bookstore_id
              AND tbb.count > 0
            LIMIT 1;

            IF (cur_bookstore_book_id IS NOT NULL) THEN
                # reduce book count in store
                UPDATE t_bookstore_books AS tbb
                SET count = count - 1
                WHERE tbb.id = cur_bookstore_book_id;
                # insert record about new sold book
                INSERT INTO t_bookstore_sold_books(store_id, book_id, price, status)
                VALUES (cur_bookstore_id, cur_book_id, cur_book_price, cur_status);
                # save result
                INSERT INTO result
                VALUES (cur_report_id, cur_book_id, cur_book_isbn, cur_book_price, cur_author_email, cur_bookstore_id);
                # update processed report records
                UPDATE t_report_sold_books SET is_processed = b'1' WHERE id = cur_report_id;
            ELSE
                SET done = FALSE;
            END IF;
        COMMIT;

        SET cur_bookstore_book_id = null;
        SET cur_book_id = null;
    END LOOP;
    CLOSE cur;

    # show all inserted records
    SELECT * FROM result;
    DROP TABLE result;

END;
$$
DELIMITER ;