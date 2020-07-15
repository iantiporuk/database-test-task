CREATE OR REPLACE VIEW need_to_pay_view AS
SELECT GROUP_CONCAT(title)                      AS title,
       CONCAT(tba.firstname, ' ', tba.lastname) AS author,
       tba.email                                AS email,
       tba.profit                               AS paid,
       (SUM(gbb.profit) - tba.profit)           AS to_pay
FROM t_book_authors AS tba
         JOIN (
    SELECT ctba.id                                        AS user_id,
           (tb.percent_of_profit / 100) * SUM(tbsb.price) AS profit,
           tb.title                                       AS title
    FROM t_bookstore_sold_books AS tbsb
             JOIN t_books tb ON tbsb.book_id = tb.id
             JOIN t_book_authors ctba ON tb.user_id = ctba.id
    WHERE tbsb.status = 1
    GROUP BY tbsb.book_id
) AS gbb on tba.id = gbb.user_id
GROUP BY tba.id;