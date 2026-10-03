/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: branches
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `branches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `address` text DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `manager_name` varchar(100) DEFAULT NULL,
  `is_active` int(11) DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 3 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: categories
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: customers
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `customers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_code` varchar(100) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `nic` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `customer_type` varchar(50) DEFAULT 'retail',
  `credit_limit` double DEFAULT 0,
  `outstanding_balance` double DEFAULT 0,
  `branch_id` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `is_active` int(11) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `customer_code` (`customer_code`),
  KEY `branch_id` (`branch_id`),
  CONSTRAINT `customers_ibfk_1` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE
  SET
  NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: grn
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `grn` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `grn_number` varchar(100) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `branch_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `grn_date` date DEFAULT curdate(),
  `total_amount` double DEFAULT 0,
  `notes` text DEFAULT NULL,
  `status` varchar(50) DEFAULT 'completed',
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `grn_number` (`grn_number`),
  KEY `supplier_id` (`supplier_id`),
  KEY `branch_id` (`branch_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `grn_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE
  SET
  NULL,
  CONSTRAINT `grn_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `grn_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE
  SET
  NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: grn_items
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `grn_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `grn_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_cost` double DEFAULT 0,
  `serial_numbers` text DEFAULT NULL,
  `total_cost` double DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `grn_id` (`grn_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `grn_items_ibfk_1` FOREIGN KEY (`grn_id`) REFERENCES `grn` (`id`) ON DELETE CASCADE,
  CONSTRAINT `grn_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: invoice_items
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `invoice_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` double DEFAULT 0,
  `discount_percent` double DEFAULT 0,
  `discount_amount` double DEFAULT 0,
  `vat_amount` double DEFAULT 0,
  `line_total` double DEFAULT 0,
  `serial_numbers` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_id` (`invoice_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `invoice_items_ibfk_1` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE,
  CONSTRAINT `invoice_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 14 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: invoices
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `invoices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_number` varchar(100) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `branch_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `invoice_date` date DEFAULT curdate(),
  `subtotal` double DEFAULT 0,
  `discount_percent` double DEFAULT 0,
  `discount_amount` double DEFAULT 0,
  `vat_rate` double DEFAULT 18,
  `vat_amount` double DEFAULT 0,
  `total` double DEFAULT 0,
  `payment_method` varchar(50) DEFAULT 'cash',
  `payment_status` varchar(50) DEFAULT 'paid',
  `amount_paid` double DEFAULT 0,
  `balance` double DEFAULT 0,
  `notes` text DEFAULT NULL,
  `invoice_status` varchar(50) DEFAULT 'confirmed',
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoice_number` (`invoice_number`),
  KEY `customer_id` (`customer_id`),
  KEY `branch_id` (`branch_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `invoices_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE
  SET
  NULL,
  CONSTRAINT `invoices_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `invoices_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE
  SET
  NULL
) ENGINE = InnoDB AUTO_INCREMENT = 12 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: job_cards
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `job_cards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_number` varchar(100) NOT NULL,
  `customer_name` varchar(255) NOT NULL,
  `customer_phone` varchar(50) NOT NULL,
  `device_details` text NOT NULL,
  `serial_number` varchar(100) DEFAULT NULL,
  `issue_description` text NOT NULL,
  `estimated_cost` double DEFAULT 0,
  `advance_paid` double DEFAULT 0,
  `final_cost` double DEFAULT 0,
  `assigned_to` int(11) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'pending',
  `spare_parts` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `resolved_date` datetime DEFAULT NULL,
  `delivered_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `job_number` (`job_number`),
  KEY `assigned_to` (`assigned_to`),
  KEY `branch_id` (`branch_id`),
  CONSTRAINT `job_cards_ibfk_1` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`) ON DELETE
  SET
  NULL,
  CONSTRAINT `job_cards_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: job_sheets
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `job_sheets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_sheet_number` varchar(100) NOT NULL,
  `technician_id` int(11) DEFAULT NULL,
  `technician_names` text DEFAULT NULL,
  `job_date` date DEFAULT curdate(),
  `customer_name` varchar(255) DEFAULT NULL,
  `customer_address` text DEFAULT NULL,
  `customer_phone` varchar(50) DEFAULT NULL,
  `quotation_number` varchar(100) DEFAULT NULL,
  `items_data` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `job_sheet_number` (`job_sheet_number`),
  KEY `technician_id` (`technician_id`),
  CONSTRAINT `job_sheets_ibfk_1` FOREIGN KEY (`technician_id`) REFERENCES `users` (`id`) ON DELETE
  SET
  NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: product_serials
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `product_serials` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `serial_number` varchar(100) NOT NULL,
  `status` varchar(50) DEFAULT 'available',
  `branch_id` int(11) DEFAULT NULL,
  `grn_id` int(11) DEFAULT NULL,
  `invoice_id` int(11) DEFAULT NULL,
  `transfer_id` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `serial_number` (`serial_number`),
  KEY `product_id` (`product_id`),
  KEY `branch_id` (`branch_id`),
  CONSTRAINT `product_serials_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_serials_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE
  SET
  NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: product_stock
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `product_stock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT 0,
  `min_quantity` int(11) DEFAULT 5,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_id` (`product_id`, `branch_id`),
  KEY `branch_id` (`branch_id`),
  CONSTRAINT `product_stock_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_stock_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: products
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `model` varchar(100) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `sku` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `warranty_months` int(11) DEFAULT 12,
  `vat_applicable` int(11) DEFAULT 0,
  `retail_price` double DEFAULT 0,
  `wholesale_price` double DEFAULT 0,
  `cost_price` double DEFAULT 0,
  `is_active` int(11) DEFAULT 1,
  `is_quick_add` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `sku` (`sku`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE
  SET
  NULL
) ENGINE = InnoDB AUTO_INCREMENT = 58 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: quotation_items
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `quotation_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quotation_id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_name` varchar(255) NOT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `model` varchar(100) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `unit_price` double DEFAULT 0,
  `discount_percent` double DEFAULT 0,
  `discount_amount` double DEFAULT 0,
  `vat_amount` double DEFAULT 0,
  `line_total` double DEFAULT 0,
  `warranty_months` int(11) DEFAULT 0,
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `quotation_id` (`quotation_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `quotation_items_ibfk_1` FOREIGN KEY (`quotation_id`) REFERENCES `quotations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `quotation_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE
  SET
  NULL
) ENGINE = InnoDB AUTO_INCREMENT = 4 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: quotations
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `quotations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quotation_number` varchar(100) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `branch_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `quotation_date` date DEFAULT curdate(),
  `valid_until` date DEFAULT NULL,
  `subtotal` double DEFAULT 0,
  `discount_percent` double DEFAULT 0,
  `discount_amount` double DEFAULT 0,
  `vat_rate` double DEFAULT 18,
  `vat_amount` double DEFAULT 0,
  `total` double DEFAULT 0,
  `status` varchar(50) DEFAULT 'draft',
  `notes` text DEFAULT NULL,
  `customer_name` varchar(255) DEFAULT NULL,
  `customer_phone` varchar(50) DEFAULT NULL,
  `customer_address` text DEFAULT NULL,
  `converted_invoice_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `quotation_number` (`quotation_number`),
  KEY `customer_id` (`customer_id`),
  KEY `branch_id` (`branch_id`),
  KEY `user_id` (`user_id`),
  KEY `converted_invoice_id` (`converted_invoice_id`),
  CONSTRAINT `quotations_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE
  SET
  NULL,
  CONSTRAINT `quotations_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `quotations_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE
  SET
  NULL,
  CONSTRAINT `quotations_ibfk_4` FOREIGN KEY (`converted_invoice_id`) REFERENCES `invoices` (`id`) ON DELETE
  SET
  NULL
) ENGINE = InnoDB AUTO_INCREMENT = 4 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: settings
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `value` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`)
) ENGINE = InnoDB AUTO_INCREMENT = 15 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: suppliers
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `suppliers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `is_active` int(11) DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: transfer_items
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `transfer_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transfer_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `serial_numbers` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `transfer_id` (`transfer_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `transfer_items_ibfk_1` FOREIGN KEY (`transfer_id`) REFERENCES `transfers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `transfer_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: transfers
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `transfers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transfer_number` varchar(100) DEFAULT NULL,
  `from_branch_id` int(11) NOT NULL,
  `to_branch_id` int(11) NOT NULL,
  `requested_by` int(11) DEFAULT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'pending',
  `transfer_date` date DEFAULT curdate(),
  `approved_date` datetime DEFAULT NULL,
  `completed_date` datetime DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `transfer_number` (`transfer_number`),
  KEY `from_branch_id` (`from_branch_id`),
  KEY `to_branch_id` (`to_branch_id`),
  KEY `requested_by` (`requested_by`),
  KEY `approved_by` (`approved_by`),
  CONSTRAINT `transfers_ibfk_1` FOREIGN KEY (`from_branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `transfers_ibfk_2` FOREIGN KEY (`to_branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `transfers_ibfk_3` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`) ON DELETE
  SET
  NULL,
  CONSTRAINT `transfers_ibfk_4` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE
  SET
  NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: users
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` varchar(50) DEFAULT 'cashier',
  `branch_id` int(11) DEFAULT NULL,
  `is_active` int(11) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `last_login` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `branch_id` (`branch_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE
  SET
  NULL
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: warranty_claims
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `warranty_claims` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `claim_number` varchar(100) DEFAULT NULL,
  `serial_number` varchar(100) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `invoice_id` int(11) DEFAULT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `claim_date` date DEFAULT curdate(),
  `issue_description` text DEFAULT NULL,
  `status` varchar(50) DEFAULT 'pending',
  `resolution_notes` text DEFAULT NULL,
  `resolved_date` datetime DEFAULT NULL,
  `replacement_serial` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `claim_number` (`claim_number`),
  KEY `product_id` (`product_id`),
  KEY `customer_id` (`customer_id`),
  KEY `invoice_id` (`invoice_id`),
  KEY `branch_id` (`branch_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `warranty_claims_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE
  SET
  NULL,
  CONSTRAINT `warranty_claims_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE
  SET
  NULL,
  CONSTRAINT `warranty_claims_ibfk_3` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE
  SET
  NULL,
  CONSTRAINT `warranty_claims_ibfk_4` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE
  SET
  NULL,
  CONSTRAINT `warranty_claims_ibfk_5` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE
  SET
  NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: branches
# ------------------------------------------------------------

INSERT INTO
  `branches` (
    `id`,
    `name`,
    `address`,
    `phone`,
    `email`,
    `manager_name`,
    `is_active`
  )
VALUES
  (
    1,
    'Mahabage',
    'Mahabage',
    '011-1234567',
    NULL,
    NULL,
    1
  );
INSERT INTO
  `branches` (
    `id`,
    `name`,
    `address`,
    `phone`,
    `email`,
    `manager_name`,
    `is_active`
  )
VALUES
  (
    2,
    'Kelaniya',
    'Kelaniya',
    '081-1234567',
    NULL,
    NULL,
    1
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: categories
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: customers
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: grn
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: grn_items
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: invoice_items
# ------------------------------------------------------------

INSERT INTO
  `invoice_items` (
    `id`,
    `invoice_id`,
    `product_id`,
    `quantity`,
    `unit_price`,
    `discount_percent`,
    `discount_amount`,
    `vat_amount`,
    `line_total`,
    `serial_numbers`
  )
VALUES
  (
    1,
    1,
    17,
    1,
    15709,
    15.971735947545993,
    2509,
    0,
    13200,
    '[\"22312\"]'
  );
INSERT INTO
  `invoice_items` (
    `id`,
    `invoice_id`,
    `product_id`,
    `quantity`,
    `unit_price`,
    `discount_percent`,
    `discount_amount`,
    `vat_amount`,
    `line_total`,
    `serial_numbers`
  )
VALUES
  (
    2,
    2,
    17,
    1,
    15709,
    15.971735947545993,
    2509,
    0,
    13200,
    '[\"22312\"]'
  );
INSERT INTO
  `invoice_items` (
    `id`,
    `invoice_id`,
    `product_id`,
    `quantity`,
    `unit_price`,
    `discount_percent`,
    `discount_amount`,
    `vat_amount`,
    `line_total`,
    `serial_numbers`
  )
VALUES
  (
    3,
    3,
    17,
    1,
    15709,
    15.971735947545993,
    2509,
    0,
    13200,
    '[]'
  );
INSERT INTO
  `invoice_items` (
    `id`,
    `invoice_id`,
    `product_id`,
    `quantity`,
    `unit_price`,
    `discount_percent`,
    `discount_amount`,
    `vat_amount`,
    `line_total`,
    `serial_numbers`
  )
VALUES
  (
    4,
    4,
    17,
    1,
    15709,
    15.971735947545993,
    2509,
    0,
    13200,
    '[]'
  );
INSERT INTO
  `invoice_items` (
    `id`,
    `invoice_id`,
    `product_id`,
    `quantity`,
    `unit_price`,
    `discount_percent`,
    `discount_amount`,
    `vat_amount`,
    `line_total`,
    `serial_numbers`
  )
VALUES
  (
    5,
    5,
    17,
    1,
    15709,
    15.971735947545993,
    2509,
    0,
    13200,
    '[]'
  );
INSERT INTO
  `invoice_items` (
    `id`,
    `invoice_id`,
    `product_id`,
    `quantity`,
    `unit_price`,
    `discount_percent`,
    `discount_amount`,
    `vat_amount`,
    `line_total`,
    `serial_numbers`
  )
VALUES
  (
    6,
    6,
    17,
    2,
    15709,
    15.971735947545993,
    5018,
    0,
    26400,
    '[]'
  );
INSERT INTO
  `invoice_items` (
    `id`,
    `invoice_id`,
    `product_id`,
    `quantity`,
    `unit_price`,
    `discount_percent`,
    `discount_amount`,
    `vat_amount`,
    `line_total`,
    `serial_numbers`
  )
VALUES
  (
    9,
    9,
    17,
    3,
    15709,
    15.971735947545993,
    7527,
    0,
    39600,
    '[]'
  );
INSERT INTO
  `invoice_items` (
    `id`,
    `invoice_id`,
    `product_id`,
    `quantity`,
    `unit_price`,
    `discount_percent`,
    `discount_amount`,
    `vat_amount`,
    `line_total`,
    `serial_numbers`
  )
VALUES
  (
    10,
    8,
    17,
    3,
    15709,
    16.18392853353704,
    7627.000000000001,
    0,
    39500,
    '[]'
  );
INSERT INTO
  `invoice_items` (
    `id`,
    `invoice_id`,
    `product_id`,
    `quantity`,
    `unit_price`,
    `discount_percent`,
    `discount_amount`,
    `vat_amount`,
    `line_total`,
    `serial_numbers`
  )
VALUES
  (
    11,
    10,
    17,
    2,
    15709,
    15.971735947545993,
    5018,
    0,
    26400,
    '[]'
  );
INSERT INTO
  `invoice_items` (
    `id`,
    `invoice_id`,
    `product_id`,
    `quantity`,
    `unit_price`,
    `discount_percent`,
    `discount_amount`,
    `vat_amount`,
    `line_total`,
    `serial_numbers`
  )
VALUES
  (
    13,
    11,
    17,
    1,
    15709,
    15.971735947545993,
    2509,
    0,
    13200,
    '[\"sdfdsfds\"]'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: invoices
# ------------------------------------------------------------

INSERT INTO
  `invoices` (
    `id`,
    `invoice_number`,
    `customer_id`,
    `branch_id`,
    `user_id`,
    `invoice_date`,
    `subtotal`,
    `discount_percent`,
    `discount_amount`,
    `vat_rate`,
    `vat_amount`,
    `total`,
    `payment_method`,
    `payment_status`,
    `amount_paid`,
    `balance`,
    `notes`,
    `invoice_status`,
    `created_at`
  )
VALUES
  (
    1,
    'INV-20260625-001',
    NULL,
    1,
    1,
    '2026-06-25',
    13200,
    0,
    0,
    0,
    0,
    13200,
    'cash',
    'credit',
    0,
    13200,
    NULL,
    'confirmed',
    '2026-06-25 18:34:23'
  );
INSERT INTO
  `invoices` (
    `id`,
    `invoice_number`,
    `customer_id`,
    `branch_id`,
    `user_id`,
    `invoice_date`,
    `subtotal`,
    `discount_percent`,
    `discount_amount`,
    `vat_rate`,
    `vat_amount`,
    `total`,
    `payment_method`,
    `payment_status`,
    `amount_paid`,
    `balance`,
    `notes`,
    `invoice_status`,
    `created_at`
  )
VALUES
  (
    2,
    'INV-20260625-002',
    NULL,
    1,
    1,
    '2026-06-25',
    13200,
    0,
    0,
    0,
    0,
    13200,
    'cash',
    'credit',
    0,
    13200,
    NULL,
    'confirmed',
    '2026-06-25 18:34:32'
  );
INSERT INTO
  `invoices` (
    `id`,
    `invoice_number`,
    `customer_id`,
    `branch_id`,
    `user_id`,
    `invoice_date`,
    `subtotal`,
    `discount_percent`,
    `discount_amount`,
    `vat_rate`,
    `vat_amount`,
    `total`,
    `payment_method`,
    `payment_status`,
    `amount_paid`,
    `balance`,
    `notes`,
    `invoice_status`,
    `created_at`
  )
VALUES
  (
    3,
    'INV-20260625-003',
    NULL,
    1,
    1,
    '2026-06-25',
    13200,
    0,
    0,
    0,
    0,
    13200,
    'cash',
    'credit',
    0,
    13200,
    NULL,
    'confirmed',
    '2026-06-25 18:39:53'
  );
INSERT INTO
  `invoices` (
    `id`,
    `invoice_number`,
    `customer_id`,
    `branch_id`,
    `user_id`,
    `invoice_date`,
    `subtotal`,
    `discount_percent`,
    `discount_amount`,
    `vat_rate`,
    `vat_amount`,
    `total`,
    `payment_method`,
    `payment_status`,
    `amount_paid`,
    `balance`,
    `notes`,
    `invoice_status`,
    `created_at`
  )
VALUES
  (
    4,
    'INV-20260625-004',
    NULL,
    1,
    1,
    '2026-06-25',
    13200,
    0,
    0,
    0,
    0,
    13200,
    'cash',
    'credit',
    0,
    13200,
    NULL,
    'confirmed',
    '2026-06-25 18:40:29'
  );
INSERT INTO
  `invoices` (
    `id`,
    `invoice_number`,
    `customer_id`,
    `branch_id`,
    `user_id`,
    `invoice_date`,
    `subtotal`,
    `discount_percent`,
    `discount_amount`,
    `vat_rate`,
    `vat_amount`,
    `total`,
    `payment_method`,
    `payment_status`,
    `amount_paid`,
    `balance`,
    `notes`,
    `invoice_status`,
    `created_at`
  )
VALUES
  (
    5,
    'INV-20260625-005',
    NULL,
    1,
    1,
    '2026-06-25',
    13200,
    0,
    0,
    0,
    0,
    13200,
    'cash',
    'credit',
    0,
    13200,
    NULL,
    'confirmed',
    '2026-06-25 18:40:37'
  );
INSERT INTO
  `invoices` (
    `id`,
    `invoice_number`,
    `customer_id`,
    `branch_id`,
    `user_id`,
    `invoice_date`,
    `subtotal`,
    `discount_percent`,
    `discount_amount`,
    `vat_rate`,
    `vat_amount`,
    `total`,
    `payment_method`,
    `payment_status`,
    `amount_paid`,
    `balance`,
    `notes`,
    `invoice_status`,
    `created_at`
  )
VALUES
  (
    6,
    'INV-20260625-006',
    NULL,
    1,
    1,
    '2026-06-25',
    26400,
    0,
    0,
    0,
    0,
    26400,
    'cash',
    'credit',
    0,
    26400,
    NULL,
    'confirmed',
    '2026-06-25 18:47:10'
  );
INSERT INTO
  `invoices` (
    `id`,
    `invoice_number`,
    `customer_id`,
    `branch_id`,
    `user_id`,
    `invoice_date`,
    `subtotal`,
    `discount_percent`,
    `discount_amount`,
    `vat_rate`,
    `vat_amount`,
    `total`,
    `payment_method`,
    `payment_status`,
    `amount_paid`,
    `balance`,
    `notes`,
    `invoice_status`,
    `created_at`
  )
VALUES
  (
    8,
    'INV-20260625-007',
    NULL,
    1,
    1,
    '2026-06-25',
    39500,
    0,
    0,
    0,
    0,
    39500,
    'cash',
    'paid',
    39600,
    0,
    'Converted from QUO-20260625-002',
    'confirmed',
    '2026-06-25 18:49:50'
  );
INSERT INTO
  `invoices` (
    `id`,
    `invoice_number`,
    `customer_id`,
    `branch_id`,
    `user_id`,
    `invoice_date`,
    `subtotal`,
    `discount_percent`,
    `discount_amount`,
    `vat_rate`,
    `vat_amount`,
    `total`,
    `payment_method`,
    `payment_status`,
    `amount_paid`,
    `balance`,
    `notes`,
    `invoice_status`,
    `created_at`
  )
VALUES
  (
    9,
    'INV-20260625-008',
    NULL,
    1,
    1,
    '2026-06-25',
    39600,
    0,
    0,
    0,
    0,
    39600,
    'cash',
    'paid',
    39600,
    0,
    'Converted from QUO-20260625-002',
    'confirmed',
    '2026-06-25 18:49:50'
  );
INSERT INTO
  `invoices` (
    `id`,
    `invoice_number`,
    `customer_id`,
    `branch_id`,
    `user_id`,
    `invoice_date`,
    `subtotal`,
    `discount_percent`,
    `discount_amount`,
    `vat_rate`,
    `vat_amount`,
    `total`,
    `payment_method`,
    `payment_status`,
    `amount_paid`,
    `balance`,
    `notes`,
    `invoice_status`,
    `created_at`
  )
VALUES
  (
    10,
    'INV-20260630-001',
    NULL,
    1,
    1,
    '2026-06-30',
    26400,
    0,
    0,
    0,
    0,
    26400,
    'cash',
    'credit',
    0,
    26400,
    NULL,
    'confirmed',
    '2026-06-30 11:57:47'
  );
INSERT INTO
  `invoices` (
    `id`,
    `invoice_number`,
    `customer_id`,
    `branch_id`,
    `user_id`,
    `invoice_date`,
    `subtotal`,
    `discount_percent`,
    `discount_amount`,
    `vat_rate`,
    `vat_amount`,
    `total`,
    `payment_method`,
    `payment_status`,
    `amount_paid`,
    `balance`,
    `notes`,
    `invoice_status`,
    `created_at`
  )
VALUES
  (
    11,
    'INV-20260630-002',
    NULL,
    1,
    1,
    '2026-06-30',
    13200,
    0,
    0,
    0,
    0,
    13200,
    'cash',
    'paid',
    13200,
    0,
    'Converted from QUO-20260630-001',
    'confirmed',
    '2026-06-30 12:13:37'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: job_cards
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: job_sheets
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: product_serials
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: product_stock
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: products
# ------------------------------------------------------------

INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    1,
    'EZVIZ H1C (2MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H1C-R101-1G2WR',
    '1080P Full HD Indoor Camera | 2-way Audio | 108° Wide Angle Lens | Magnetic Base | Three Sound-Alert Modes | Motion Detection | IR Night Vision Up to 10 m | Sleep Mode | 2 Years Warranty',
    NULL,
    12,
    0,
    8609,
    7174,
    6456.6,
    1,
    0,
    '2026-06-25 17:44:06',
    '2026-06-25 17:47:44'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    2,
    'EZVIZ TY1 1080P (2MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-TY1-B0-1G2WF',
    '1080P Full HD Indoor Wifi Camera | 360 Pan / Tilt Rotatable | Auto-Tracking | Motion Detection | 2-way Audio | Sleep Mode | Loud Noise Detection | Smart Color Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    7855,
    6546,
    5891.4,
    1,
    0,
    '2026-06-25 17:44:06',
    '2026-06-25 17:47:44'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    3,
    'EZVIZ H6C PRO 2K (3MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H6c-R105-1L3WF',
    '2K Resolution Indoor Wifi Camera | ez360 Pan / Tilt Rotatable | Patrol Mode | 2-way Calling Button | Auto-Tracking | Smart Human Shape Detection | Sleep Mode | Loud Noise Detection | Smart Color Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    8552,
    7126,
    6413.4,
    1,
    0,
    '2026-06-25 17:44:06',
    '2026-06-25 17:47:44'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    4,
    'EZVIZ H6C PRO 3K (5MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H6c-R105-1J5WF',
    '3K Resolution Indoor Wifi Camera | ez360 Pan / Tilt Rotatable | Patrol Mode | 2-way Calling Button | Auto-Tracking | Smart Human Shape Detection | Sleep Mode | Loud Noise Detection | Smart Color Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    11402,
    9502,
    8551.8,
    1,
    0,
    '2026-06-25 17:44:06',
    '2026-06-25 17:47:44'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    5,
    'EZVIZ H6C G2 4K (8MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H6c-R200-8H8WF',
    '4K Resolution Indoor Wifi Camera | ez360 Pan / Tilt Rotatable | Patrol Mode | 2-way Calling Button | Auto-Tracking | Smart Human Shape Detection | Sleep Mode | Smart Color Night Vision | Dual-Band Wifi | Loud Noise Detection | 2 Years Warranty',
    NULL,
    12,
    0,
    18307,
    15256,
    13730.4,
    1,
    0,
    '2026-06-25 17:44:06',
    '2026-06-25 17:47:44'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    6,
    'EZVIZ H7C (4MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H7C-R100-8G44WF',
    '2K+ Resolution Indoor Camera | 2K⁺ & 2K⁺ Dual Lenses | Pan / Tilt Rotatable | Two-Way Calling | Human Shape Detection | Two Patrol Modes | Dual-Band Wifi | Sleep Mode | Smart Color Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    16153,
    13461,
    12114.9,
    1,
    0,
    '2026-06-25 17:44:06',
    '2026-06-25 17:47:44'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    7,
    'EZVIZ BM-1 (2MP) Blue',
    'EZVIZ',
    NULL,
    NULL,
    'CS-BM1-R100-2D2WF-BE',
    '1080P Full HD Indoor Baby Monitor Camera | Rechargeble Battery | Out of Crib Alerts | Crying Detection | Soothing Music | Night Vision | 2-way Audio | non-Toxic Matirials | 2 Years Warranty',
    NULL,
    12,
    0,
    35597,
    29664,
    26697.6,
    1,
    0,
    '2026-06-25 17:44:06',
    '2026-06-25 17:47:44'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    8,
    'EZVIZ BM-1 (2MP) Pink',
    'EZVIZ',
    NULL,
    NULL,
    'CS-BM1-R100-2D2WF-RA',
    '1080P Full HD Indoor Baby Monitor Camera | Rechargeble Battery | Out of Crib Alerts | Crying Detection | Soothing Music | Night Vision | 2-way Audio | non-Toxic Matirials | 2 Years Warranty',
    NULL,
    12,
    0,
    35597,
    29664,
    26697.6,
    1,
    0,
    '2026-06-25 17:44:06',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    9,
    'EZVIZ CB2 (2MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-CB2-R100-2D2WF-BK',
    '1080P Full HD Indoor Camera | 2000mAh built-in rechargeable battery | Magnetic Base | 2- Way Audio | Smart Human Motion Detection | H256 | 8m IR Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    29638,
    24698,
    22228.2,
    1,
    0,
    '2026-06-25 17:44:06',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    10,
    'EZVIZ E4P (6MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-E4p-R100-8C6WKF',
    '3K+ UHD Fisheye Camera | Panoramic View | Multiple Split-Screen | Loud Noise Detection | AI-Powered Human Detection | Two-Way Talk | Sleep Mode | IR Night Vision up to 10M | 2 Years Warranty',
    NULL,
    12,
    0,
    41542,
    34619,
    31157.1,
    1,
    0,
    '2026-06-25 17:44:06',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    11,
    'EZVIZ S10 (4MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-S10-R100-1M4WFK',
    '2K+ Smart Video Calling Camera | 4-Inch Touch Screen | Electronic Album | Two-Way Talk | IR Night Vision up to 10m | Bluetooth Speaker | Privacy Shutter | AI-Powered Human Detection | WDR | Crying Detection | Fabric-wrapped design | AI-Powered Pet Detection | Dual-Band Wi-Fi | 2 Years Warranty',
    NULL,
    12,
    0,
    39336,
    32780,
    29502,
    1,
    0,
    '2026-06-25 17:44:06',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    12,
    'EZVIZ H3C (2MP) IR',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H3C-R100-1K2WF',
    '1080P Full HD Outdoor Wi-Fi Smart Camera | Human Shape Detection | Audio Pick-Up | H265 | IR Night Vision up to 30m | IP67 | 2 Years Warrant',
    NULL,
    12,
    0,
    11970,
    9975,
    8977.5,
    1,
    0,
    '2026-06-25 17:44:06',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    13,
    'EZVIZ H3C (2MP) Color',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H3C-R100-1K2WFL',
    '1080P Full HD Outdoor Wi-Fi Smart Camera | Human Shape Detection| Audio Pick-Up | Active Defense Spotlights* | Color Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    12936,
    10780,
    9702,
    1,
    0,
    '2026-06-25 17:44:06',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    14,
    'EZVIZ H3C (4MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H3C-R100-1J4KFL',
    '2K+ Resolution Outdoor Wi-Fi Smart Camera | Active Defense Spotlights & Siren | Human Shape Detection | 2-way Audio | Customizable Detection Zones | H.265 | Waving a hand & Control | Color Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    18560,
    15466,
    13919.4,
    1,
    0,
    '2026-06-25 17:44:06',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    15,
    'EZVIZ H3C (5MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H3C-R100-1J5WKFL',
    '3K Resolution Outdoor Wi-Fi Smart Camera | Active Defense Spotlights & Siren | Human Shape Detection | 2-way Audio | Customizable Detection Zones | H.265 | Waving a hand & Control | Color Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    19841,
    16534,
    14880.6,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    16,
    'EZVIZ C3X (2MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-CV310-C3-6B22WFR',
    '1080P Full HD Outdoor Wi-Fi Smart Camera | Dual Lens | Human Detection | Active Defense Strobe Light Siren | Customizable Voice Alerts | 2-way Audio | Color Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    34217,
    28514,
    25662.6,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    17,
    'EZVIZ H8C Pro 2K (3MP)',
    'EZVIZ',
    'EZVIZ',
    NULL,
    'CS-H8C-R100-1K2WKFL',
    '2K Resolution Outdoor Pan/ Tilt Rotatable Wi-Fi Smart Camera | AI Human Detection | 2-way Audio | Smart Auto Tracking | Active Defense Strobe Light Siren | One-Click Return to Pre-set Directions | Color Night Vision | 2 Years Warranty',
    '/uploads/img_1782391780021.png',
    12,
    0,
    15709,
    13200,
    11781.9,
    1,
    1,
    '2026-06-25 17:44:07',
    '2026-06-25 18:21:43'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    18,
    'EZVIZ H8C Pro 3K (5MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H8C-R200-1J5WKFL',
    '3K Resolution Outdoor Pan/ Tilt Wi-Fi Smart Camera | Human Detection | 2-way Audio | Active Defense Strobe Light Siren | Auto Zoom Tracking | Color Night Vision | One-Click Return to Pre-set Directions | 2 Years Warranty',
    '/uploads/img_1782391818535.png',
    12,
    0,
    17737,
    14800,
    13302.9,
    1,
    1,
    '2026-06-25 17:44:07',
    '2026-06-30 12:15:39'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    19,
    'EZVIZ H8C Pro 4K (8MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H8C-R100-1J4WKFL',
    '4K Resolution Outdoor Pan/ Tilt Wi-Fi Smart Camera | Human Detection | 2-way Audio | Active Defense Strobe Light Siren | Auto Zoom Tracking | Color Night Vision | One-Click Return to Pre-set Directions | 2 Years Warranty',
    '/uploads/img_1782391898122.png',
    12,
    0,
    25058,
    20900,
    18793.8,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 18:21:38'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    20,
    'EZVIZ H9C (3MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H9C-R100-8H33WKFL',
    '2K Resolution Outdoor Pan/ Tilt Wi-Fi Smart Camera | 2K & 2K Dual Lenses | Human/ Vehicle Detection | 2-way Audio | Active Defense Strobe Light Siren | Auto Smart Tracking | Two Patrol Modes | Color Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    23914,
    19928,
    17935.2,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    21,
    'EZVIZ H9C (5MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H9C-R100-8H55WKFL',
    '3K Resolution Pan/ Tilt Rotatable Wi-Fi Smart Camera | 3K & 3K Dual Lenses | Human/ Vehicle Detection | 2-way Audio | Active Defense Strobe Light Siren | Auto Smart Tracking | Two Patrol Modes | Color Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    28706,
    23922,
    21529.8,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    22,
    'EZVIZ H90 (4MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H90-R100-8H44WKFL',
    '2K+ Resolution Outdoor Dual Pan/ Tilt Wi-Fi Smart Camera | 2K & 2K Dual Lenses | Co-Detection for Auto Smart Tracking | Human/ Vehicle Detection | 2-way Audio | Active Defense Strobe Light Siren | Auto Smart Tracking | Two Patrol Modes | Enhanced Dual Wi-Fi Antennas | Color Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    30206,
    25172,
    22654.8,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    23,
    'EZVIZ H80f 2K+ (4MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H80f-R100-8G444WKFL',
    '2K+ Resolution Outdoor Pan/ Tilt Wi-Fi Triple-Lens Smart Camera | Human Detection | 2-way Audio | Active Defense Strobe Light | Auto Zoom Tracking | 12× Mixed Zoom | Alarm Siren | One-Click Return to Pre-set Color Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    35204,
    29337,
    26403.3,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    24,
    'EZVIZ H80X 4K (8MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H80x-R100-8G82WKFL',
    '2K+ Resolution Outdoor Pan/ Tilt Wi-Fi Intelligent Dual Lenses Smart Camera | AI-Powered Human / Vehicle Shape Detection | F1.0 Large Aperture | Auto Zoom Tracking | Two Patrol Modes for Auto-Security | 2-way Audio | Active Defense Strobe Light | Alarm Siren | One-Click Return to Pre-set | Color Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    31212,
    26010,
    23409,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    25,
    'EZVIZ HB8c 2K+ (4MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-HB8c-R100-1N4WFL',
    '2K+ Resolution Pan/ Tilt Smart WiFi Camera | 5200mAh built-in rechargeable battery | Always-On Video Mode | 2- Way Audio | IP67 | Smart Lights | Supports Wi-Fi 6 | H265 | Active Defense with Siren and Strobe Light | Smart Human Detection | Color Night Vision | Customizable Voice Alerts | Smart Tracking | 2 Years Warranty',
    NULL,
    12,
    0,
    32309,
    26924,
    24231.6,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    26,
    'EZVIZ CB8c 2K+ (4MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-CB8c-R100-1N4WFL',
    '2K+ Resolution Pan/ Tilt Smart WiFi Camera | 5200mAh built-in rechargeable battery | Always-On Video Mode | 2- Way Audio | IP67 | Smart Lights | Supports Wi-Fi 6 | H265 | Active Defense with Siren and Strobe Light | Smart Human Detection | Color Night Vision | Customizable Voice Alerts | Smart Tracking | 2 Years Warranty',
    NULL,
    12,
    0,
    32390,
    26992,
    24292.8,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    27,
    'EZVIZ H5 (3MP) 4G',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H5-R201-1H3KFL4GA',
    '2K Resolution | 4G Connectivity | Outdoor Camera | Human & Vehicle Shape Detection | 2-way Audio | Active Defense Strobe Light Siren | Up to 512GB SD Card Support | Color Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    13860,
    11550,
    10395,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    28,
    'EZVIZ H8C (3MP) 4G',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H8C-R200-1K3KFL4GA',
    '2K Resolution | 4G Connectivity | Outdoor Pan/ Tilt Rotatable Camera | Human & Vehicle Shape Detection | 2-way Audio | Active Defense Strobe Light Siren | Auto Tracking | Color Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    18566,
    15472,
    13924.8,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    29,
    'EZVIZ H9C (5MP) 4G',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H9C-R105-8H55WFL4GA',
    '3K Resolution Pan/ Tilt Rotatable 4G / Wi-Fi Smart Camera | 3K & 3K Dual Lenses | Human/ Vehicle Detection | 2-way Audio | Active Defense Strobe Light Siren | Auto Smart Tracking | Two Patrol Modes | Color Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    29573,
    24644,
    22179.6,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    30,
    'EZVIZ EB8-4G + SOLAR (3MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-EB8/SP',
    '2K Resolution Outdoor Pan/ Tilt Rotatable Camera | 4G Connectivity | GPS Location | 10,400mah Battery | 4.2W Solar Panel with 4Mtr power cable | Smart Human Motion Detection | 2-way Audio | Color Night Vision | Active Defense | 2 Years Warranty',
    NULL,
    12,
    0,
    63370,
    52808,
    47527.2,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    31,
    'EZVIZ HB8-4G + SOLAR (3MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-HB8/SP',
    '2K Resolution Outdoor Pan/ Tilt Rotatable Camera | 4G Connectivity | 5,400mah Battery | Auto Tracking | 4.2W Solar Panel with 4Mtr power cable | Smart Human Motion Detection | Customizable Voice Alerts | Active Defense | 2-way Audio | Color Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    40703,
    33919,
    30527.1,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    32,
    'EZVIZ HB90x 4G + SOLAR (4MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-HB90x/SP-R100',
    '2K+ & 2K+ Resolution Pan/ Tilt Camera | 4G and Wi-Fi Connectivity | Dual Lenses | All-Day Recording | Always-On Video Mode | 8W Solar Panel | 10,400 mAh Battery | Smart Tracking | Dual Rotations | AI-Powered Human / Vehicle Detection | One-Tap Control | Smart Lights | IP65 | ColorFULL Night Vision | Two-Way Talk | Active Defense with Siren & Strobe Light | 2 Years Warranty',
    NULL,
    12,
    0,
    72404,
    60337,
    54303.3,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    33,
    'EZVIZ SOLAR PANEL E (Type-C)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-CMT-Solar Panel-E',
    'Solar Charging Panel | Up to 6.18 W Energy-saving and Eco-friendly | IP65 | Monocrystalline Silicon Cell | 6V ± 5% | 4-Meter Cable for Mounting Flexibility | Type-C Charging Ports | 1030 mA ± 5% | 2 Years Warranty',
    NULL,
    12,
    0,
    12999,
    10832,
    9748.8,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    34,
    'EZVIZ H4 PoE',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H4-R201-1H3EKFL',
    '2K Resolution Smart PoE Camera | Power Over Ethernet | Two-Way Talk | AI-Powered Human / Vehicle Detection | Customizable Detection Zone | IP67 | H.265 | Color Night Vision | Enhanced Audio Pickup | Active Defense with Siren and Strobe Light | 2 Years Warranty',
    NULL,
    12,
    0,
    15843,
    13202,
    11881.8,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    35,
    'EZVIZ H5 PoE',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H4-R201-1H3EKFL-H5',
    '2K Smart PoE Security Camera | 2K Resolution | Power Over Ethernet | Two-Way Talk | Weatherproof Design | Adjustable Sound and Light Alarm | AI-Powered Human / Vehicle Detection | Customizable Detection Zone | IP67 | H.265 | Active Defense with Siren and Strobe Light | Color Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    15490,
    12909,
    11618.1,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    36,
    'EZVIZ H8c PoE',
    'EZVIZ',
    NULL,
    NULL,
    'CS-H8c PoE (2K)',
    '2K Pan & Tilt PoE Security Camera | 2K Resolution | Power Over Ethernet | Two-Way Talk | Auto-Tracking | AI-Powered Human / Vehicle Detection | Active Defense with Siren and Strobe Light | Weatherproof Design | H.265 | Color Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    17603,
    14669,
    13202.1,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    37,
    'EZVIZ X5S (3K) 4CH NVR',
    'EZVIZ',
    NULL,
    NULL,
    'CS-X5S-R100-4W',
    '3K Wireless 4CH NVR | HDMI & VGA Outputs | Supports High-Resolution Cameras | Up to 3K Video Quality | Supports ONVIF Conformant Camera | Wi-Fi Range Up to 100M | Up to 8TB Storage | H.265 Video Technology | 2 Years Warranty',
    NULL,
    12,
    0,
    14882,
    12402,
    11161.8,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    38,
    'EZVIZ X5S (3K) 8CH NVR',
    'EZVIZ',
    NULL,
    NULL,
    'CS-X5S-R100-8W',
    '3K Wireless 8CH NVR | HDMI & VGA Outputs | Supports High-Resolution Cameras | Up to 3K Video Quality | Supports ONVIF Conformant Camera | Wi-Fi Range Up to 100M | Up to 8TB Storage | H.265 Video Technology | 2 Years Warranty',
    NULL,
    12,
    0,
    16867,
    14056,
    12650.4,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:45'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    39,
    'EZVIZ CloudPlay 7 Days 1 Year',
    'EZVIZ',
    NULL,
    NULL,
    'EZCLOUD7D1Y',
    'EZVIZ Cloud CloudPlay Storage | 7 Days 1 Year Subscription | No more video loss caused by storage card failure or camera theft. | No more frustrating storage limits with local storage tools.',
    NULL,
    12,
    0,
    23500,
    12500,
    11250,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:46'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    40,
    'EZVIZ EL3 (3MP)',
    'EZVIZ',
    NULL,
    NULL,
    'CS-EL3-R100-8C3WFL',
    '3MP 2K Outdoor Wall Light Wi-Fi Camera | Adjustable Horizontal Rotation | Human/ Vehicle Detection | Weatherproof | Active Defense Strobe Light with Siren | License Plate Recognition | Auto-Tracking | 780-Lumen Brightness | Dual-Band Wi-Fi | 2-way Audio | 15M Color Night Vision | 2 Years Warranty',
    NULL,
    12,
    0,
    40135,
    33446,
    30101.4,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:46'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    41,
    'EZVIZ DL05 Smart Lock',
    'EZVIZ',
    NULL,
    NULL,
    'CS-DL05-WBCP-M',
    'Smart Fingerprint Battery Powered Door Lock | Multiple Unlock Methods | Anti-Tamper Alarm | Easy Control via EZVIZ App | Weatherproof Design | Real-Time Mobile Alerts | Supports Temporary Access Codes | Supports Child Safety Lock | Low-Battery Warning Signal | Supports Anti-Peeping Codes | Supports Emergency Power Supply | 2 Years Warranty',
    NULL,
    12,
    0,
    44001,
    36667,
    33000.3,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:46'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    42,
    'EZVIZ DL03 Pro Smart Lock',
    'EZVIZ',
    NULL,
    NULL,
    'CS-DL03 Pro',
    'Fingerprint Battery Powered Smart Door Lock | Multiple Unlock Methods | Anti-Tamper Alarm | Easy Control via EZVIZ App | Sturdy Lock Body | Real-Time Lock Status Check & Mobile Alerts | Smart Integration with EZVIZ Cameras | Supports Emergency Power Supply | 2 Years Warranty',
    NULL,
    12,
    0,
    28165,
    23471,
    21123.9,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:46'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    43,
    'EZVIZ DL50FVS Smart Lock',
    'EZVIZ',
    NULL,
    NULL,
    'CS-DL50FVS',
    '3D Face Recognition Smart Lock | Dual-Lens 3D Structured Light | 5000 mAh Rechargeable Lithium Battery | 4-Inch IPS Color Screen | Safe Design | Live View with Two-Way Video Call | Built-In Smart Door Viewer | Face IDs | Fingerprints | Passcodes | Remote Unlock | Temporary Visitor Codes | Bluetooth Keys | Mechanical Emergency Keys | Anti-Tamper Alarm | Supports Emergency Power Supply | Built-in 8GB storage space | IR night vision up to 2M | 2 Years Warranty',
    NULL,
    12,
    0,
    119699,
    99749,
    89774.1,
    1,
    0,
    '2026-06-25 17:44:07',
    '2026-06-25 17:47:46'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    44,
    'EZVIZ HP7 (3MP) Doorbell',
    'EZVIZ',
    NULL,
    NULL,
    'CS-HP7-R101-1W2TFC',
    '2K Resolution Smart Wifi Video Doorphone | 7-Inch Color Touch Screen | 2-Wire | Support Dual Band 2.4 or 5 GHz | Remote Door/Gate Unlock | Weatherproof | Smart Human Motion Detection | MicroSD Card support Up to 512 GB | Two-Way Talk (Supports voice changer feature) | Built-In Doorbell with Multiple Ringtones | Smart RFID Unlock (2 tags included) | 2 Years Warranty',
    NULL,
    12,
    0,
    51605,
    43004,
    38703.6,
    1,
    0,
    '2026-06-25 17:44:08',
    '2026-06-25 17:47:46'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    45,
    'EZVIZ HP5 (2MP) Doorbell',
    'EZVIZ',
    NULL,
    NULL,
    'CS-HP5-R100-1W2TFC',
    '1080P Full HD Smart Wifi Video Doorphone | 7-Inch Color Touch Screen | 2-Wire | Support Dual Band 2.4 or 5 GHz | Remote Door/Gate Unlock | Weatherproof | Smart Human Motion Detection | MicroSD Card support Up to 512 GB | Two-Way Talk (Supports voice changer feature) | Built-In Doorbell with Multiple Ringtones | Smart RFID Unlock (2 tags included) | 2 Years Warranty',
    NULL,
    12,
    0,
    48379,
    40316,
    36284.4,
    1,
    0,
    '2026-06-25 17:44:08',
    '2026-06-25 17:47:46'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    46,
    'EZVIZ EP7 (3MP) Doorbell',
    'EZVIZ',
    NULL,
    NULL,
    'CS-EP7-R100-1W2TFC',
    '2K Resolution Smart Home Video Doorphone | No Wiring Between Outdoor & Indoor Devices | Built-In Doorbell with Multiple Ringtones | Solar-Powered with Included Charging Panel | 7-Inch Color Touch Screen | Two-Way Talk | Remote Door/Gate Unlock | Passcode Unlock | Remote Control via the EZVIZ App | High-Performance Wi-Fi Halow | Weatherproof Design | 2 Years Warranty',
    NULL,
    12,
    0,
    80263,
    66886,
    60197.4,
    1,
    0,
    '2026-06-25 17:44:08',
    '2026-06-25 17:47:46'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    47,
    'Xiaomi R-03 Wifi Extender',
    'Xiaomi',
    NULL,
    NULL,
    'MI-PRO-R-03',
    'Xiaomi 300Mbps Speed wifi Extender| 2.4 GHz | CPU: MT7628K | RAM: 8MB DDR1 | 1 Year Warranty',
    NULL,
    12,
    0,
    6900,
    5500,
    4950,
    1,
    0,
    '2026-06-25 17:44:08',
    '2026-06-25 17:47:46'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    48,
    'Hikvision AC1200 Extender',
    'Hikvision',
    NULL,
    NULL,
    'DS-3WRE12C',
    'AC1200 Dual Band Wi-Fi Extender | 3dBi Dual-Band | 2*2 MIMO supported | 2.4 GHz: 300 Mbps | 5 GHz: 867 Mbps | WiFi Repeater Mode | Access Point Mode | Hide SSID | Web Management | RJ45 1 Port | WPA-PSK/WPA2-PSK | WPA algorithm: TKIP | 2 Years Warranty',
    NULL,
    12,
    0,
    11070,
    8856,
    7970.4,
    1,
    0,
    '2026-06-25 17:44:08',
    '2026-06-25 17:47:46'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    49,
    'TP-Link N300 Extender',
    'TP-Link',
    NULL,
    NULL,
    'TL-WA850RE',
    'TP-Link 300Mbps Speed wifi Extender | 2.4 GHz | Single Ethernet port wired devices | WPS | Smart Signal Indicator Light | 2 Years Warranty',
    NULL,
    12,
    0,
    10500,
    8400,
    7560,
    1,
    0,
    '2026-06-25 17:44:08',
    '2026-06-25 17:47:46'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    50,
    'Hikvision N300 4G Router',
    'Hikvision',
    NULL,
    NULL,
    'DS-3WR4G3N',
    '4G LTE Boost 300Mbps Wi-Fi Router | 3G/4G Route Mode | Wireless Router Mode | Access Point Mode | 2*2 MIMO supported | Mobile Network With a 4G SIM Card Support | DL: 150 Mbps | Upload: 50 Mbps | 10/100 Mbps RJ45 2 Ethernet Ports | 2 Years Warranty',
    NULL,
    12,
    0,
    16562,
    13250,
    11925,
    1,
    0,
    '2026-06-25 17:44:08',
    '2026-06-25 17:47:46'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    51,
    'LB-LINK AX300 4G Router',
    'LB-LINK',
    NULL,
    NULL,
    'BL-CPE300M',
    'LB-LINK AX300 4G LTE Router | Wi-Fi 4 & 6 | Dual Power supply | Plug & Play SIM Card | Wifi speed Up to 1200 Mbps | 1 Ehernet port | Wired LAN speed up to 100Mbps | 12V / 5V | 1 Year Warranty',
    NULL,
    12,
    0,
    12109,
    9688,
    8719.2,
    1,
    0,
    '2026-06-25 17:44:08',
    '2026-06-25 17:47:46'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    52,
    'Red-Link 12V UPS',
    'Red-Link',
    NULL,
    NULL,
    'RL-611-UPS',
    'Red-Link 12 Volts 2.1A UPS | Short Circuit Protection | Waterproof Outdoor Use | Over Voltage and Over Current Protection | Power Supply with Battery Backup | 1 Year Warranty',
    NULL,
    12,
    0,
    3200,
    2300,
    2070,
    1,
    0,
    '2026-06-25 17:44:08',
    '2026-06-25 17:47:46'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    53,
    'Pelco 12V 2A PSU',
    'Pelco',
    NULL,
    NULL,
    '12V-PSU-PELCO',
    'Pelco 12 Volts 2A | Short Circuit Protection | Waterproof Outdoor Use Power Supply | Over Voltage and Over Current Protection | 3 Months Warranty',
    NULL,
    12,
    0,
    900,
    500,
    450,
    1,
    0,
    '2026-06-25 17:44:08',
    '2026-06-25 17:47:46'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    54,
    'Hikvision 12V 2.1A PSU',
    'Hikvision',
    NULL,
    NULL,
    'DS-2PA1201-WRD',
    'Hikvision 12 Volts 2.1A | Short Circuit Protection | Waterproof Outdoor | Over Voltage and Over Current Protection | 2 Years Warranty',
    NULL,
    12,
    0,
    1900,
    1300,
    1170,
    1,
    0,
    '2026-06-25 17:44:08',
    '2026-06-25 17:47:46'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    55,
    'Dome Camera Wall Mount Bracket',
    'Generic',
    NULL,
    NULL,
    'PDS-01',
    'L Shaped Wall Bracket | ABS Plastic | White | Compatible with the EZVIZ C6 / H6 Series | And Hikvision Dome Camera Stand',
    NULL,
    12,
    0,
    1200,
    960,
    864,
    1,
    0,
    '2026-06-25 17:44:08',
    '2026-06-25 17:47:46'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    56,
    'Wall Mounting Camera Protective Cover',
    'Generic',
    NULL,
    NULL,
    'RAINCOV001',
    'Wall Mounting Camera Protective Covers | Rain Shield Smart Outdoor Camera Protection | High quality ABS Plastic | White Color | Size 29 * 20.5 * 20.5CM | 1 x Cushion | 3 x Screw',
    NULL,
    12,
    0,
    1125,
    900,
    810,
    1,
    0,
    '2026-06-25 17:44:08',
    '2026-06-25 17:47:46'
  );
INSERT INTO
  `products` (
    `id`,
    `name`,
    `brand`,
    `model`,
    `category_id`,
    `sku`,
    `description`,
    `image_path`,
    `warranty_months`,
    `vat_applicable`,
    `retail_price`,
    `wholesale_price`,
    `cost_price`,
    `is_active`,
    `is_quick_add`,
    `created_at`,
    `updated_at`
  )
VALUES
  (
    57,
    'Hikvision Web Camera (1080P)',
    'Hikvision',
    NULL,
    NULL,
    'DS-U02',
    '1080P FHD Web Camera | 1920 × 1080 resolution | Min. illumination: 0.1 Lux @ (F1.2, AGC ON) | Built-in microphone | USB 2.0 protocol | Plug-and-play | 2 Years Warranty',
    NULL,
    12,
    0,
    9000,
    7200,
    6480,
    1,
    0,
    '2026-06-25 17:44:08',
    '2026-06-25 17:47:46'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: quotation_items
# ------------------------------------------------------------

INSERT INTO
  `quotation_items` (
    `id`,
    `quotation_id`,
    `product_id`,
    `product_name`,
    `brand`,
    `model`,
    `quantity`,
    `unit_price`,
    `discount_percent`,
    `discount_amount`,
    `vat_amount`,
    `line_total`,
    `warranty_months`,
    `notes`
  )
VALUES
  (
    1,
    1,
    17,
    'EZVIZ H8C Pro 2K (3MP)',
    'EZVIZ',
    NULL,
    1,
    15709,
    15.971735947545993,
    2509,
    0,
    13200,
    12,
    NULL
  );
INSERT INTO
  `quotation_items` (
    `id`,
    `quotation_id`,
    `product_id`,
    `product_name`,
    `brand`,
    `model`,
    `quantity`,
    `unit_price`,
    `discount_percent`,
    `discount_amount`,
    `vat_amount`,
    `line_total`,
    `warranty_months`,
    `notes`
  )
VALUES
  (
    2,
    2,
    17,
    'EZVIZ H8C Pro 2K (3MP)',
    'EZVIZ',
    NULL,
    3,
    15709,
    15.971735947545993,
    7527,
    0,
    39600,
    12,
    NULL
  );
INSERT INTO
  `quotation_items` (
    `id`,
    `quotation_id`,
    `product_id`,
    `product_name`,
    `brand`,
    `model`,
    `quantity`,
    `unit_price`,
    `discount_percent`,
    `discount_amount`,
    `vat_amount`,
    `line_total`,
    `warranty_months`,
    `notes`
  )
VALUES
  (
    3,
    3,
    17,
    'EZVIZ H8C Pro 2K (3MP)',
    'EZVIZ',
    NULL,
    1,
    15709,
    15.971735947545993,
    2509,
    0,
    13200,
    12,
    NULL
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: quotations
# ------------------------------------------------------------

INSERT INTO
  `quotations` (
    `id`,
    `quotation_number`,
    `customer_id`,
    `branch_id`,
    `user_id`,
    `quotation_date`,
    `valid_until`,
    `subtotal`,
    `discount_percent`,
    `discount_amount`,
    `vat_rate`,
    `vat_amount`,
    `total`,
    `status`,
    `notes`,
    `customer_name`,
    `customer_phone`,
    `customer_address`,
    `converted_invoice_id`,
    `created_at`
  )
VALUES
  (
    1,
    'QUO-20260625-001',
    NULL,
    1,
    1,
    '2026-06-25',
    '2026-07-25',
    13200,
    0,
    0,
    0,
    0,
    13200,
    'draft',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    '2026-06-25 18:48:58'
  );
INSERT INTO
  `quotations` (
    `id`,
    `quotation_number`,
    `customer_id`,
    `branch_id`,
    `user_id`,
    `quotation_date`,
    `valid_until`,
    `subtotal`,
    `discount_percent`,
    `discount_amount`,
    `vat_rate`,
    `vat_amount`,
    `total`,
    `status`,
    `notes`,
    `customer_name`,
    `customer_phone`,
    `customer_address`,
    `converted_invoice_id`,
    `created_at`
  )
VALUES
  (
    2,
    'QUO-20260625-002',
    NULL,
    1,
    1,
    '2026-06-25',
    '2026-07-25',
    39600,
    0,
    0,
    0,
    0,
    39600,
    'converted',
    NULL,
    NULL,
    NULL,
    NULL,
    9,
    '2026-06-25 18:49:34'
  );
INSERT INTO
  `quotations` (
    `id`,
    `quotation_number`,
    `customer_id`,
    `branch_id`,
    `user_id`,
    `quotation_date`,
    `valid_until`,
    `subtotal`,
    `discount_percent`,
    `discount_amount`,
    `vat_rate`,
    `vat_amount`,
    `total`,
    `status`,
    `notes`,
    `customer_name`,
    `customer_phone`,
    `customer_address`,
    `converted_invoice_id`,
    `created_at`
  )
VALUES
  (
    3,
    'QUO-20260630-001',
    NULL,
    1,
    1,
    '2026-06-30',
    '2026-07-30',
    13200,
    0,
    0,
    0,
    0,
    13200,
    'converted',
    NULL,
    NULL,
    NULL,
    NULL,
    11,
    '2026-06-30 12:13:28'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: settings
# ------------------------------------------------------------

INSERT INTO
  `settings` (`id`, `key`, `value`)
VALUES
  (1, 'company_name', 'ENQOVA');
INSERT INTO
  `settings` (`id`, `key`, `value`)
VALUES
  (2, 'vat_rate', '0');
INSERT INTO
  `settings` (`id`, `key`, `value`)
VALUES
  (3, 'currency', 'Rs.');
INSERT INTO
  `settings` (`id`, `key`, `value`)
VALUES
  (
    4,
    'gemini_api_key',
    'AQ.Ab8RN6JR4HC3mBAVLemOYHYzV90YqFOgsZ4a495UB0DQFgCnuw'
  );
INSERT INTO
  `settings` (`id`, `key`, `value`)
VALUES
  (6, 'company_phone', '0778377990');
INSERT INTO
  `settings` (`id`, `key`, `value`)
VALUES
  (7, 'company_address', '530/1 Negombo Rd, Ragama');
INSERT INTO
  `settings` (`id`, `key`, `value`)
VALUES
  (8, 'company_email', 'sales@ecslk.com');
INSERT INTO
  `settings` (`id`, `key`, `value`)
VALUES
  (9, 'footer_text', 'Thank you for your business!');

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: suppliers
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: transfer_items
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: transfers
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: users
# ------------------------------------------------------------

INSERT INTO
  `users` (
    `id`,
    `username`,
    `full_name`,
    `email`,
    `password_hash`,
    `role`,
    `branch_id`,
    `is_active`,
    `created_at`,
    `last_login`
  )
VALUES
  (
    1,
    'admin',
    'System Admin',
    NULL,
    '$2a$10$wzHG1h0Btzz9/ha1wXe5r.ms4fflidTJQdzPsdMA1h4nQaIYMApbe',
    'admin',
    1,
    1,
    '2026-06-25 16:45:51',
    '2026-06-30 11:52:07'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: warranty_claims
# ------------------------------------------------------------


/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
