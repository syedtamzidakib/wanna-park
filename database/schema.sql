CREATE DATABASE IF NOT EXISTS wanna_park
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE wanna_park;

CREATE TABLE IF NOT EXISTS users (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  full_name   VARCHAR(100)  NOT NULL,
  email       VARCHAR(150)  NOT NULL UNIQUE,
  phone       VARCHAR(20)   NOT NULL,
  password    VARCHAR(255)  NOT NULL,
  role        ENUM('customer', 'partner', 'admin') NOT NULL DEFAULT 'customer',
  created_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;