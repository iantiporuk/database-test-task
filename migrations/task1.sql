ALTER TABLE t_books
    ADD CONSTRAINT t_books_user_id_fk
        FOREIGN KEY (user_id) REFERENCES t_book_authors (id)
            ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE t_bookstore_books
    ADD CONSTRAINT t_bookstore_books_store_id_fk
        FOREIGN KEY (store_id) REFERENCES t_bookstores (id)
            ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE t_bookstore_books
    ADD CONSTRAINT t_bookstore_books_book_id_fk
        FOREIGN KEY (book_id) REFERENCES t_books (id)
            ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE t_bookstore_sold_books
    ADD CONSTRAINT t_bookstore_sold_store_id_fk
        FOREIGN KEY (store_id) REFERENCES t_bookstores (id);

ALTER TABLE t_bookstore_sold_books
    ADD CONSTRAINT t_bookstore_sold_store_id_books_id_fk
        FOREIGN KEY (book_id) REFERENCES t_books (id);