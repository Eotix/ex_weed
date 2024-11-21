INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
	('pot', 'Саксия', 1, 0, 1),
	('fertilizer', 'Висококачествена тор', 1, 0, 1),
	('weedseeds', 'Семка за коноп', 1, 0, 1),
	('weedpot', 'Саксия с семка', 1, 0, 1),
    ('weed20g', 'Марихуана 20г', 1, 0, 1)
;
-- АКО ПОЛЗВАШ QB ИЗТРИЙ ВСИЧКО НАД ТОВА !
CREATE TABLE IF NOT EXISTS `plants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coords` longtext COLLATE utf8mb4_turkish_ci DEFAULT NULL,
  `plantgender` int(11) DEFAULT NULL,
  `water` int(11) DEFAULT NULL,
  `fertilizer` int(11) DEFAULT NULL,
  `timestamp` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=UTF8MB4_TURKISH_CI;
