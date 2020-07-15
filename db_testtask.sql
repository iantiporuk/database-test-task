create table `t_book_authors`
(
	`id` int(11) not null auto_increment,
	`firstname` varchar(100) not null,
	`lastname` varchar(100) not null,
	`email` varchar(100) not null,
	`profit` decimal(11, 2) default 0,
	primary key (`id`),
	unique key `tb_id_unique` (`id`)
) engine=innodb auto_increment=1 default charset=utf8;


create table `t_books`
(
	`id` int(11) not null auto_increment,
	`user_id` int(11) not null,
	`title` varchar(100) not null,
	`isbn` varchar(13) not null,
	`percent_of_profit` decimal(3) not null default 60,
	`publish_date` date not null,
	primary key (`id`),
	unique key `tb_id_unique` (`id`)
) engine=innodb auto_increment=1 default charset=utf8;


create table `t_bookstores`
(
	`id` int(11) not null auto_increment,
	`name` varchar(100) not null,
	`profit` decimal(11, 2) default 0,
	primary key (`id`),
	unique key `tbs_id_unique` (`id`)
) engine=innodb auto_increment=1 default charset=utf8;


create table `t_bookstore_books`
(
	`id` int(11) not null auto_increment,
	`store_id` int(11) not null,
	`book_id` int(11) not null,
	`count` int(11) not null,
	`price` decimal(5, 2) not null default 0,
	primary key (`id`),
	unique key `tbs_id_unique` (`id`)
) engine=innodb auto_increment=1 default charset=utf8;


create table `t_bookstore_sold_books`
(
	`id` int(11) not null auto_increment,
	`store_id` int(11) not null,
	`book_id` int(11) not null,
	`price` decimal(5, 2) default 0,
	`status` bit(1) not null default 0, -- 0 not paid to author, 1 paid to author
	`insert_date` date not null,
	`update_date` date not null,
	primary key (`id`),
	unique key `tbs_id_unique` (`id`)
) engine=innodb auto_increment=1 default charset=utf8;


create table `t_report_sold_books`
(
	`id` int(11) not null auto_increment,
	`book_title` varchar(100) not null,
	`book_isbn` varchar(13) not null,
	`book_price` decimal(5, 2) default 0,
	`author_firstname` varchar(100) not null,
	`author_lastname` varchar(100) not null,
	`author_email` varchar(100) not null,
	`status` bit(1) not null default 0, -- 0 not paid to author, 1 paid to author
	`insert_date` date not null,
	`update_date` date not null,
	primary key (`id`),
	unique key `tbs_id_unique` (`id`)
) engine=innodb auto_increment=1 default charset=utf8;
