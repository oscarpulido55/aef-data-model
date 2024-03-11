CREATE TABLE products (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(255) NOT NULL
);
INSERT INTO products (name) VALUES ('product1');
INSERT INTO products (name) VALUES ('product2');