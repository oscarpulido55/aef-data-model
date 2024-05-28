CREATE TABLE suppliers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
INSERT INTO suppliers (name) VALUES ('supplier1');
INSERT INTO suppliers (name) VALUES ('supplier2');