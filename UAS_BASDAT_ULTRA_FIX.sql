-- Membuat tabel User
CREATE TABLE Users (
    user_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    userName VARCHAR2(50) NOT NULL,
    password_hash VARCHAR2(256) NOT NULL,
    telephone VARCHAR2(15) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL
);

-- Membuat tabel Menu
CREATE TABLE Menu (
    menu_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    menuName VARCHAR2(100) NOT NULL,
    Price NUMBER NOT NULL,
    image VARCHAR2(200)
);

-- Membuat tabel Order
CREATE TABLE Orders (
    order_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    user_id NUMBER NOT NULL,
    menu_id NUMBER NOT NULL,
    order_type VARCHAR2(50) CHECK (order_type IN ('Delivery', 'PickUp')),
    total_price NUMBER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (menu_id) REFERENCES Menu(menu_id)
);

-- Membuat tabel Delivery
CREATE TABLE Delivery (
    delivery_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    order_id NUMBER NOT NULL,
    delivery_address VARCHAR2(200) NOT NULL, 
    status VARCHAR2(50) CHECK (status IN ('Delivered', 'in Delivery')),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Membuat tabel PickUp
CREATE TABLE PickUp (
    pickup_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    order_id NUMBER NOT NULL,
    pickup_date DATE, 
    status VARCHAR2(50) CHECK (status IN ('Taken', 'WaitingCustomers')),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Membuat tabel Inbox
CREATE TABLE Inbox (
    email varchar(50) NOT NULL,
    message VARCHAR2(1000) NOT NULL,
    FOREIGN KEY (email) REFERENCES Users(email)
);

-- Memasukkan data ke tabel Users dengan password hash (contoh saja, gunakan hash algoritma sebenarnya di aplikasi nyata)
INSERT INTO Users (userName, password_hash, telephone, email) VALUES ('john_doe', 'hashed_password123', '1234567890', 'john.doe@example.com');
INSERT INTO Users (userName, password_hash, telephone, email) VALUES ('jane_smith', 'hashed_securepass', '2345678901', 'jane.smith@example.com');
INSERT INTO Users (userName, password_hash, telephone, email) VALUES ('alice_jones', 'hashed_mypassword', '3456789012', 'alice.jones@example.com');
INSERT INTO Users (userName, password_hash, telephone, email) VALUES ('bob_brown', 'hashed_bobspassword', '4567890123', 'bob.brown@example.com');

-- Memasukkan data ke tabel Menu
INSERT INTO Menu (menuName, Price, image) VALUES ('Cheeseburger', 50, 'cheeseburger.jpg');
INSERT INTO Menu (menuName, Price, image) VALUES ('Veggie Pizza', 100, 'veggie_pizza.jpg');
INSERT INTO Menu (menuName, Price, image) VALUES ('Caesar Salad', 40, 'caesar_salad.jpg');
INSERT INTO Menu (menuName, Price, image) VALUES ('Spaghetti Carbonara', 75, 'spaghetti_carbonara.jpg');

-- Memasukkan data ke tabel Orders
INSERT INTO Orders (user_id, menu_id, order_type, total_price) VALUES (1, 1, 'Delivery', 55);
INSERT INTO Orders (user_id, menu_id, order_type, total_price) VALUES (2, 2, 'PickUp', 110);
INSERT INTO Orders (user_id, menu_id, order_type, total_price) VALUES (3, 3, 'Delivery', 45);
INSERT INTO Orders (user_id, menu_id, order_type, total_price) VALUES (4, 4, 'PickUp', 80);

-- Memasukkan data ke tabel Delivery
INSERT INTO Delivery (order_id, delivery_address, status) VALUES (1, '123 Elm Street', 'in Delivery');
INSERT INTO Delivery (order_id, delivery_address, status) VALUES (3, '789 Pine Road', 'Delivered');

-- Memasukkan data ke tabel PickUp
INSERT INTO PickUp (order_id, pickup_date, status) VALUES (2, TO_DATE('2024-06-15', 'YYYY-MM-DD'), 'WaitingCustomers');
INSERT INTO PickUp (order_id, pickup_date, status) VALUES (4, TO_DATE('2024-06-16', 'YYYY-MM-DD'), 'Taken');

-- Memasukkan data ke tabel Inbox dengan referensi user_id
INSERT INTO Inbox (email, message) VALUES ('john.doe@example.com', 'Apakah saya bisa memesan makanan vegan?');
INSERT INTO Inbox (email, message) VALUES ('jane.smith@example.com', 'Apakah ada diskon untuk pesanan besar?');
INSERT INTO Inbox (email, message) VALUES ('alice.jones@example.com', 'Bisakah saya mengubah pesanan saya menjadi pengiriman?');
INSERT INTO Inbox (email, message) VALUES ('bob.brown@example.com', 'Tolong tambahkan saus ekstra ke pesanan saya.');

select * from  users;
select * from  orders;
select * from  menu;
select * from  delivery;
select * from  pickup;
select * from  inbox;

-- QUERY COMPLEX 1 JOIN 
-- MENAMPILKAN INFORMASI PESANAN USER DAN MENU
SELECT 
    o.order_id,
    u.userName,
    u.email,
    m.menuName,
    o.order_type,
    o.total_price
FROM 
    Orders o
JOIN 
    Users u ON o.user_id = u.user_id
JOIN 
    Menu m ON o.menu_id = m.menu_id;



-- QUERY COMPLEX 2 JOIN
-- MENAMPILKAN USER YANG MEMASUKAN PESAN PADA INBOX
SELECT 
    u.userName,
    u.email,
    i.message
FROM 
    Users u
JOIN 
    Inbox i ON u.email = i.email;

-- QUERY COMPLEX 3 SUBQUERY
-- MENAMPILKAN MENU DENGAN HARGA TERTINGGI
SELECT menu_id, menuName, price
FROM Menu
WHERE price = (SELECT MAX(price) FROM Menu);


--VIEW 1
-- MENAMPILKAN DETAIL USER DAN PESANANNYA
CREATE OR REPLACE VIEW UserOrders AS
SELECT 
    o.order_id,
    u.userName,
    u.email,
    m.menuName,
    o.order_type,
    o.total_price
FROM 
    Orders o
JOIN 
    Users u ON o.user_id = u.user_id
JOIN 
    Menu m ON o.menu_id = m.menu_id;
-- MENGGUNAKAN VIEW 1
select * from UserOrders;

-- VIEW  2
-- MENAMPILKAN DETAIL PELANGGNA YANG PESANANNYA DIANTAR DAN STATUS PESANANNYA
CREATE OR REPLACE VIEW InfoDeliveryOrders AS
SELECT 
    o.order_id,
    u.userName,
    u.email,
    m.menuName,
    o.total_price,
    o.order_type,
    d.delivery_address,
    d.status AS delivery_status
FROM 
    Orders o
JOIN 
    Users u ON o.user_id = u.user_id
JOIN 
    Menu m ON o.menu_id = m.menu_id
JOIN 
    Delivery d ON o.order_id = d.order_id
WHERE 
    o.order_type = 'Delivery';
-- MMENGGUNAKAN VIEW 2
select * from InfoDeliveryOrders;

--FUNGSI 1
-- MENGHITUNG BERAPA KALI USER MELAKUKAN TRANSAKSI
CREATE OR REPLACE FUNCTION GetUserOrderCount (
    p_user_id IN NUMBER
) RETURN NUMBER IS
    v_order_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_order_count
    FROM Orders
    WHERE user_id = p_user_id;

    RETURN v_order_count;
END;
/
--MENGGUNAKAN FUNGSI 1
SELECT GetUserOrderCount(1) AS OrderCount FROM dual;

-- FUNGSI 2
-- MENGHITUNG TOTA HARGA PEMBELIAN OLEH USER
CREATE OR REPLACE FUNCTION CalculateTotalPrice (
    p_user_id IN NUMBER
) RETURN NUMBER IS
    v_total_price NUMBER;
BEGIN
    -- Menjumlahkan semua total_price untuk user_id yang diberikan
    SELECT SUM(total_price)
    INTO v_total_price
    FROM Orders
    WHERE user_id = p_user_id;

    -- Jika tidak ada pesanan, total_price akan menjadi NULL, maka kita set ke 0
    RETURN NVL(v_total_price, 0);
END;
/
-- MENGGUNAKAN FUNGSI 2
SELECT CalculateTotalPrice(1) AS TotalPrice FROM dual;
drop PROCEDURE CalculateTotalPrice;

-- PROCEDURE 1
-- Menambahkan User Baru
CREATE OR REPLACE PROCEDURE AddUser (
    p_userName IN VARCHAR2,
    p_password IN VARCHAR2,
    p_telephone IN VARCHAR2,
    p_email IN VARCHAR2
) AS
BEGIN
    INSERT INTO Users (userName, password_hash, telephone, email)
    VALUES (p_userName, p_password, p_telephone, p_email);
END;
/

-- MENGGUNAKAN PROCEDURE 1 
EXECUTE AddUser('poniran', 'poniran123', '642786332424', 'poniran@example.com');

--PROSEDUR 2
-- MENAMBAHKAN PESANAN BARU PADA USER
CREATE OR REPLACE PROCEDURE add_order (
    p_user_id IN NUMBER,
    p_menu_id IN NUMBER,
    p_order_type IN VARCHAR2,
    p_delivery_address IN VARCHAR2 DEFAULT NULL,
    p_pickup_date IN DATE DEFAULT NULL
) AS
    v_order_id NUMBER;
BEGIN
    -- Menambahkan pesanan ke tabel Orders
    INSERT INTO Orders (user_id, menu_id, order_type)
    VALUES (p_user_id, p_menu_id, p_order_type)
    RETURNING order_id INTO v_order_id;
    
    -- Menambahkan entri ke tabel Delivery atau PickUp berdasarkan tipe pesanan
    IF p_order_type = 'Delivery' THEN
        INSERT INTO Delivery (order_id, delivery_address, status)
        VALUES (v_order_id, p_delivery_address, 'in Delivery');
    ELSIF p_order_type = 'PickUp' THEN
        INSERT INTO PickUp (order_id, pickup_date, status)
        VALUES (v_order_id, p_pickup_date, 'WaitingCustomers');
    END IF;
    
    COMMIT; -- Menyimpan transaksi
END add_order;
/
-- MENGGUNAKAN PROSEDUR 2
EXEC add_order(1, 3, 'Delivery', '456 Maple Street');

-- TRIGER 1
-- MENYAMAKAN HARGA MAKANAN PADA TABEL ORDER DENGAN TABEL MENU
CREATE OR REPLACE TRIGGER SetOrderTotalPrice
BEFORE INSERT OR UPDATE OF menu_id ON Orders
FOR EACH ROW
BEGIN
    -- Set total_price to the price of the menu item from the Menu table
    SELECT Price
    INTO :NEW.total_price
    FROM Menu
    WHERE menu_id = :NEW.menu_id;
END;
/

-- TRIGER 2
-- MEMASTIKAN ORDER_TYPE HANYA DELIVERY DAN PICKUP
CREATE OR REPLACE TRIGGER ValidateOrderType
BEFORE INSERT OR UPDATE OF order_type ON Orders
FOR EACH ROW
BEGIN
    IF :NEW.order_type NOT IN ('Delivery', 'PickUp') THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid order type: ' || :NEW.order_type);
    END IF;
END;
/

select * from orders;

-- Memperbarui pesanan dengan order_id = 1 menjadi 'PickUp'
UPDATE Orders
SET order_type = 'PickUp'
WHERE order_id = 1;

-- Mencoba memperbarui pesanan dengan order_id = 1 menjadi 'Courier'
UPDATE Orders
SET order_type = 'Courier'
WHERE order_id = 1;