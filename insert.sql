CREATE TABLE IF NOT EXISTS `discord_verifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fivem_identifier` varchar(255) NOT NULL,
  `verify_code` varchar(255) NOT NULL,
  `discord_id` varchar(255),
  `verified_at` timestamp,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;