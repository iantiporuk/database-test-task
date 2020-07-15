CREATE OR REPLACE VIEW books_ranking_view AS
SELECT row_number() over ()                     AS position,
       tb.title                                 AS title,
       CONCAT(tba.firstname, ' ', tba.lastname) AS author,
       COUNT(*)                                 AS sold_count
FROM t_bookstore_sold_books AS tbsb
         JOIN t_books AS tb ON tbsb.book_id = tb.id
         JOIN t_book_authors tba ON tb.user_id = tba.id
WHERE tb.publish_date >= '2013-01-01'
  AND tb.isbn NOT LIKE '97912%'
GROUP BY tbsb.book_id
HAVING SUM(tbsb.price) >= 768;