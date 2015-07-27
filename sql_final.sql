--CUNY MSDA Summer 2015 Bridge Workshop SQL Final Project

--Requirements: 1) translate a business requirement into a database design;
--              2) design a database using one-many and many-to-many relationships
--              3) know when to use LEFT and/or RIGHT JOINs to build result sets for reporting

--Overview of my project
--1) I designed a database for people who are self_managing their own investment accounts, 
--   which could be at different brokers;
--2) This database includes 6 tables: users,brokers,accounts,categories,actions,transactions
--                       and 1 Views (all_information), which includes all the information from 6 tables
--3) At the end, I show some queries to showcase how to use this database

--Processes
--1.users table
DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users (user_id INT PRIMARY KEY, user_name VARCHAR(255) NOT NULL);
INSERT INTO users (user_id, user_name) VALUES 
    (1, 'Youqing'),
    (2, 'Vincent');
SELECT * FROM users;

--2. brokers table
DROP TABLE IF EXISTS brokers CASCADE;
CREATE TABLE brokers (broker_id INT PRIMARY KEY, broker_name VARCHAR(255) NOT NULL);
INSERT INTO brokers (broker_id, broker_name) VALUES 
    (1, 'vanguard'),
    (2, 'fidelity');
SELECT * FROM brokers;
--3. accounts table
DROP TABLE IF EXISTS accounts CASCADE;
CREATE TABLE accounts (account_id INT PRIMARY KEY, account_name VARCHAR(255) NOT NULL);
INSERT INTO accounts (account_id, account_name) VALUES 
    (1, 'individual'),
    (2, 'IRA');
SELECT * FROM accounts;
--4. actions table
DROP TABLE IF EXISTS actions CASCADE;
CREATE TABLE actions (action_id INT PRIMARY KEY, action_name VARCHAR(255) NOT NULL);
INSERT INTO actions (action_id, action_name) VALUES 
    (1, 'buy'),
    (2, 'sell'),
    (3, 'transfer'),
    (4, 'withdraw');
SELECT * FROM actions;
--5. categories table
DROP TABLE IF EXISTS categories CASCADE;
CREATE TABLE categories (category_id INT PRIMARY KEY, category_name VARCHAR(255) NOT NULL);
INSERT INTO categories (category_id, category_name) VALUES 
    (1, 'cash'),
    (2, 'stock'),
    (3, 'ETFs'),
    (4, 'mutual fund');
SELECT * FROM categories;
--6. transactions table
DROP TABLE IF EXISTS transactions CASCADE;
CREATE TABLE transactions 
(
    transaction_id INT PRIMARY KEY,
    product VARCHAR(255) NOT NULL,
    user_id INT NOT NULL REFERENCES users(user_id),
    broker_id INT NOT NULL REFERENCES brokers(broker_id),
    account_id INT NOT NULL REFERENCES accounts(account_id),
    action_id INT NOT NULL REFERENCES actions(action_id),
    category_id INT NOT NULL REFERENCES categories(category_id),
    price REAL NOT NULL,
    volume INT NOT NULL,
    broker_fee REAL,
    transaction_date DATE
);
INSERT INTO transactions (transaction_id,product,user_id,broker_id,account_id,
action_id,category_id,price,volume,broker_fee,transaction_date) VALUES 
    (1,'cash',1,1,1,3,1,1,10000,0,'2015-01-01'),
    (2,'cash',1,1,2,3,1,1,5500,0,'2015-01-01'),
    (3,'cash',2,2,1,3,1,1,10000,0,'2015-02-01'),
    (4,'cash',2,2,2,3,1,1,5500,0,'2015-02-01'),
    (5,'AAPL',1,1,1,1,2,108.05,30,7.95,'2015-01-03'),
    (6,'C',1,1,1,1,2,54.23,45,7.95,'2015-02-04'),
    (7,'AMZN',2,2,1,1,2,382.12,20,8.05,'2015-03-15'),
    (8,'T',2,2,2,1,2,33.2,130,8.05,'2015-04-15'),
    (9,'FRIFX',1,1,1,1,3,11.5,300,0,'2015-04-16'),
    (10,'AAPL',1,1,1,2,2,124.11,30,7.95,'2015-07-14');
SELECT * FROM transactions;
--7. create view for all information from all the tables
DROP VIEW IF EXISTS all_information;
CREATE VIEW all_information AS
(
SELECT t.transaction_id, t.product,t.price,t.volume,t.broker_fee, t.transaction_date,
c.category_name,u.user_name,b.broker_name,a.action_name,ac.account_name
FROM transactions t
LEFT JOIN users u ON t.user_id = u.user_id
LEFT JOIN categories c ON t.category_id = c.category_id
LEFT JOIN brokers b ON t.broker_id = b.broker_id
LEFT JOIN actions a ON t.action_id = a.action_id
LEFT JOIN accounts ac ON t.account_id = ac.account_id
ORDER BY t.transaction_id
);
SELECT * FROM all_information;
--8.select information from view
SELECT * FROM all_information
WHERE user_name = 'Vincent';
SELECT * FROM all_information
WHERE broker_name = 'fidelity'
AND user_name = 'Vincent'
AND account_name = 'individual';
SELECT *, (price * volume) AS amount FROM all_information;