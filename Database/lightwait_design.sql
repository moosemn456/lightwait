# Create the lighwait database
DROP DATABASE IF EXISTS lightwait;

CREATE DATABASE lightwait;
use lightwait;

CREATE TABLE Users (
	user_id INT(30) NOT NULL AUTO_INCREMENT,
	userType INT(1) NOT NULL DEFAULT 1,
	fName VARCHAR(255),
	lName VARCHAR(255),
	email VARCHAR(255),
	password VARCHAR(255),
	device_token varchar(64),
	Primary Key (user_id)
) ENGINE=InnoDB;

CREATE TABLE Fries (
	id INT(30) NOT NULL AUTO_INCREMENT,
	name VARCHAR(30),
	available BOOLEAN DEFAULT 1,
	isActive BOOLEAN DEFAULT 1,
	Primary Key(id)
) ENGINE=InnoDB;

CREATE TABLE Breads (
	id INT(30) NOT NULL AUTO_INCREMENT,
	name VARCHAR(30),
	available BOOLEAN DEFAULT 1,
	isActive BOOLEAN DEFAULT 1,
	Primary Key(id)
) Engine=InnoDB;

CREATE TABLE Bases (
	id INT(30) NOT NULL AUTO_INCREMENT,
	name VARCHAR(30),
	available BOOLEAN DEFAULT 1,
	isActive BOOLEAN DEFAULT 1,
	Primary Key (id)
) Engine=InnoDB;

CREATE TABLE Cheeses (
	id INT(30) NOT NULL AUTO_INCREMENT,
	name VARCHAR(30),
	available BOOLEAN DEFAULT 1,
	isActive BOOLEAN DEFAULT 1,
	Primary Key (id)
) Engine=InnoDB;

CREATE TABLE Toppings (
	id INT(30) NOT NULL AUTO_INCREMENT,
	name VARCHAR(30),
	available BOOLEAN DEFAULT 1,
	isActive BOOLEAN DEFAULT 1,
	Primary Key (id)
) Engine=InnoDB;

CREATE TABLE OrderToppings (
	order_id INT(30),
	topping_id INT(30),
	Primary Key (order_id, topping_id)
) Engine=InnoDB;

CREATE TABLE Orders (
	order_id INT(30) NOT NULL AUTO_INCREMENT,
	user_id INT(30) NOT NULL,
	bread_id INT(30) NOT NULL,
	base_id INT(30) NOT NULL,
	cheese_id INT(30) DEFAULT 0,
	fry_id INT(30) DEFAULT 0,
	timePlaced TIMESTAMP NOT NULL DEFAULT 0,
	timeFinished TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	isActive BOOLEAN DEFAULT 1,
	Primary Key (order_id),
	Foreign Key (user_id) REFERENCES Users(user_id),
	Foreign Key (bread_id) REFERENCES Breads(id),
	Foreign Key (base_id) REFERENCES Bases(id),
	Foreign Key (cheese_id) REFERENCES Cheeses(id),
	Foreign Key (fry_id) REFERENCES Fries(id)
) Engine=InnoDB;

CREATE TABLE PushQueue (
  message_id int(11) NOT NULL AUTO_INCREMENT,
  device_token varchar(64) NOT NULL,
  payload varchar(256) NOT NULL,
  time_queued datetime NOT NULL,
  time_sent datetime DEFAULT NULL,
  PRIMARY KEY (`message_id`)
) ENGINE=InnoDB;

# Procedures
DELIMITER $$

CREATE PROCEDURE recallOrder()
BEGIN

UPDATE Orders SET isActive = 1 
WHERE timeFinished = (SELECT timeFinished FROM (SELECT timeFinished FROM Orders WHERE isActive=0 ORDER BY timeFinished DESC LIMIT 1) AS TimeFinished) LIMIT 1;

END $$

DELIMITER ;

# INSERT some ingredients and Users
INSERT INTO `Breads` (`name`) VALUES
('White'),
('Wheat'),
('Texas Toast');

INSERT INTO `Bases` (`name`) VALUES
('Grilled Cheese'),
('Hamburger'),
('Turkey'),
('Chicken'),
('Veggie'),
('Black Bean');

INSERT INTO `Cheeses` (`name`) VALUES
('American'),
('Pepper Jack'),
('Swiss'),
('No Cheese');

INSERT INTO `Fries` (`name`) VALUES
('Regular'),
('Sweet Potato'),
('No Fries');

INSERT INTO `Toppings` (`name`) VALUES
('Lettuce'),
('Jalapeno'),
('Tomato'),
('Bacon'),
('Pico de Gallo'),
('Pineapple'),
('Pickle'),
('Onion'),
('Avocado Mayo'),
('Bistro Sauce'),
('Chipotle Ranch'),
('No Toppings');


INSERT INTO `Users` (`userType`, `fName`, `lName`, `email`, `password`, `device_token`) VALUES
(2, 'Charlie', 'Chef', 'charlie@smu.edu', '320f3d06fc64b15dc19201eb1504ecc4f886fc57abba23ff07c82a803b5559926b43ca354337d4dbeaf46e5f9b338c7a050a8cfa10e0a8660267817fbe94f9c1', NULL),
(2, 'Charise', 'Chef', 'charise@smu.edu', '320f3d06fc64b15dc19201eb1504ecc4f886fc57abba23ff07c82a803b5559926b43ca354337d4dbeaf46e5f9b338c7a050a8cfa10e0a8660267817fbe94f9c1', NULL),
(3, 'Adam', 'Admin', 'adam@smu.edu', '320f3d06fc64b15dc19201eb1504ecc4f886fc57abba23ff07c82a803b5559926b43ca354337d4dbeaf46e5f9b338c7a050a8cfa10e0a8660267817fbe94f9c1', NULL),
(3, 'Adele', 'Admin', 'adele@smu.edu', '320f3d06fc64b15dc19201eb1504ecc4f886fc57abba23ff07c82a803b5559926b43ca354337d4dbeaf46e5f9b338c7a050a8cfa10e0a8660267817fbe94f9c1', NULL),
(1, 'Andy', 'Nagar', 'profNagar@smu.edu', '708ba3195d297a5e721a865e565c54776fae2685f9e9295d9028687ec526c5185dd6d81e1ed6c7cfbbc0757575f2385ca10d907b5af35ea2c9bbf72294e8b75b', NULL),
(1, 'Christopher', 'Raley', 'profRaley@smu.edu', '4bfef0102474eb210fd57f73b4bc0e217602e27311eb97b310613e4e48bf791f0d0ea19be279765b809a3cef88216c7937111b912928f1e9f2033ffb8eeb165d', NULL);



INSERT INTO Orders (user_id, bread_id, base_id, cheese_id, fry_id, timePlaced) 
				VALUES	(1, 1, 1, 1, 1, '2014-03-30 12:04:03'),
						(2, 1, 2, 2, 2, '2014-03-30 12:04:04'),
						(3, 2, 3, 2, 2, '2014-03-30 12:04:05'),
						(4, 3, 4, 3, 2, '2014-03-30 12:04:06'),
						(5, 3, 4, 2, 3, '2014-03-30 12:04:07');

INSERT INTO OrderToppings(order_id, topping_id) VALUES
(1, 12),
(2, 12),
(3, 12),
(4, 12),
(5, 12);