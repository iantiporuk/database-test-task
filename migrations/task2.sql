CREATE UNIQUE INDEX t_book_authors_email_uindex
    ON t_book_authors (email);

CREATE UNIQUE INDEX t_books_isbn_uindex
    ON t_books (isbn);

CREATE UNIQUE INDEX t_bookstore_books_store_id_book_id_uindex
    ON t_bookstore_books (store_id, book_id);

CREATE INDEX t_books_publish_date_index
    on t_books (publish_date);

CREATE INDEX t_bookstore_sold_books_status_index
    ON t_bookstore_sold_books (status);

CREATE INDEX t_book_authors_firstname_lastname_index
    ON t_book_authors (firstname, lastname);

CREATE INDEX t_bookstore_sold_books_update_date_index
    ON t_bookstore_sold_books (update_date);
