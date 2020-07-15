DROP PROCEDURE IF EXISTS update_author_profit;
DELIMITER $$

CREATE PROCEDURE update_author_profit()
BEGIN
    DECLARE cur_user_id INT;
    DECLARE cur_profit DECIMAL(11, 2);
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT user_id,
                                  SUM(gbb.profit) AS profit
                           FROM t_book_authors AS tba
                                    JOIN (
                               SELECT ctba.id                                        AS user_id,
                                      (tb.percent_of_profit / 100) * SUM(tbsb.price) AS profit
                               FROM t_bookstore_sold_books AS tbsb
                                        JOIN t_books tb ON tbsb.book_id = tb.id
                                        JOIN t_book_authors ctba ON tb.user_id = ctba.id
                               WHERE tbsb.status = 1
                               GROUP BY tbsb.book_id
                           ) AS gbb ON tba.id = gbb.user_id
                           GROUP BY tba.id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cur;
    read_loop:
    LOOP
        FETCH cur INTO cur_user_id, cur_profit;
        IF done THEN
            LEAVE read_loop;
        END IF;
        UPDATE t_book_authors AS tba SET tba.profit = cur_profit WHERE tba.id = cur_user_id;
    END LOOP;
    CLOSE cur;
END;
$$
DELIMITER ;