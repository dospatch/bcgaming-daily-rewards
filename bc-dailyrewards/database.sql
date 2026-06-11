CREATE TABLE IF NOT EXISTS `daily_rewards` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(60) NOT NULL UNIQUE,
    `streak` INT NOT NULL DEFAULT 0,
    `last_claim` INT(11) NOT NULL DEFAULT 0,
    INDEX `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
