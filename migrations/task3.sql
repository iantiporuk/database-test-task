CREATE TRIGGER t_bookstore_sold_books_before_insert
    BEFORE INSERT
    ON t_bookstore_sold_books
    FOR EACH ROW SET NEW.insert_date = NOW(), NEW.update_date = NOW();

CREATE TRIGGER t_bookstore_sold_books_before_update
    BEFORE UPDATE
    ON t_bookstore_sold_books
    FOR EACH ROW SET NEW.insert_date = OLD.insert_date, NEW.update_date = NOW();