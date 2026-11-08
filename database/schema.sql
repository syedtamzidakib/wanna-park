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
CREATE TABLE IF NOT EXISTS vehicles (
  id                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id           INT UNSIGNED NOT NULL,
  registration_no   VARCHAR(30)  NOT NULL UNIQUE,
  vehicle_type      ENUM('car', 'motorcycle', 'suv', 'microbus', 'other') NOT NULL DEFAULT 'car',
  brand             VARCHAR(50),
  model             VARCHAR(50),
  color             VARCHAR(30),
  created_at        TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS facilities (
  id                  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  partner_id          INT UNSIGNED NOT NULL,
  name                VARCHAR(100) NOT NULL,
  address             VARCHAR(255) NOT NULL,
  contact_phone       VARCHAR(20),
  opening_time        TIME         NOT NULL DEFAULT '00:00:00',
  closing_time        TIME         NOT NULL DEFAULT '23:59:00',
  total_capacity      INT UNSIGNED NOT NULL DEFAULT 0,
  reservable_capacity INT UNSIGNED NOT NULL DEFAULT 0,
  status              ENUM('pending', 'active', 'inactive') NOT NULL DEFAULT 'pending',
  created_at          TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (partner_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS slots (
  id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  facility_id   INT UNSIGNED NOT NULL,
  slot_code     VARCHAR(20)  NOT NULL,
  slot_type     ENUM('normal', 'accessible', 'ev', 'motorcycle', 'family', 'vip', 'staff', 'emergency') NOT NULL DEFAULT 'normal',
  is_reservable TINYINT(1)   NOT NULL DEFAULT 1,
  UNIQUE KEY uq_facility_slot (facility_id, slot_code),
  FOREIGN KEY (facility_id) REFERENCES facilities(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS bookings (
  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id         INT UNSIGNED NOT NULL,
  vehicle_id      INT UNSIGNED NOT NULL,
  slot_id         INT UNSIGNED NOT NULL,
  start_time      DATETIME     NOT NULL,
  end_time        DATETIME     NOT NULL,
  status          ENUM('pending', 'confirmed', 'active', 'completed', 'cancelled', 'expired', 'no_show') NOT NULL DEFAULT 'pending',
  check_in_time   DATETIME     NULL,
  check_out_time  DATETIME     NULL,
  created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id)    REFERENCES users(id)    ON DELETE CASCADE,
  FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE,
  FOREIGN KEY (slot_id)    REFERENCES slots(id)    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS payments (
  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  booking_id      INT UNSIGNED NOT NULL,
  amount          DECIMAL(10, 2) NOT NULL,
  payment_method  VARCHAR(30)  NOT NULL DEFAULT 'demo',
  transaction_id  VARCHAR(100) NOT NULL UNIQUE,
  status          ENUM('pending', 'paid', 'failed', 'refunded') NOT NULL DEFAULT 'pending',
  paid_at         DATETIME     NULL,
  FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
) ENGINE=InnoDB;