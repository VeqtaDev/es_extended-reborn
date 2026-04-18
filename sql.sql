CREATE DATABASE IF NOT EXISTS `esxreborn`;

ALTER DATABASE `esxreborn`
	DEFAULT CHARACTER SET UTF8MB4;
	
ALTER DATABASE `esxreborn`
	DEFAULT COLLATE UTF8MB4_UNICODE_CI;

USE `esxreborn`;

CREATE TABLE `users` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(60) NOT NULL,
	`ssn` VARCHAR(11) NOT NULL,
	`accounts` LONGTEXT NULL DEFAULT NULL,
	`group` VARCHAR(50) NULL DEFAULT 'user',
	`inventory` LONGTEXT NULL DEFAULT NULL,
	`job` VARCHAR(20) NULL DEFAULT 'unemployed',
	`job_grade` INT NULL DEFAULT 0,
	`loadout` LONGTEXT NULL DEFAULT NULL,
	`metadata` LONGTEXT NULL DEFAULT NULL,
	`position` longtext NULL DEFAULT NULL,

	PRIMARY KEY (`id`),
	UNIQUE KEY `unique_identifier` (`identifier`),
	UNIQUE KEY `unique_ssn` (`ssn`)
) ENGINE=InnoDB;

CREATE TABLE `items` (
	`name` VARCHAR(50) NOT NULL,
	`label` VARCHAR(50) NOT NULL,
	`weight` INT NOT NULL DEFAULT 1,
	`rare` TINYINT NOT NULL DEFAULT 0,
	`can_remove` TINYINT NOT NULL DEFAULT 1,

	PRIMARY KEY (`name`)
) ENGINE=InnoDB;

CREATE TABLE `job_grades` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`job_name` VARCHAR(50) DEFAULT NULL,
	`grade` INT NOT NULL,
	`name` VARCHAR(50) NOT NULL,
	`label` VARCHAR(50) NOT NULL,
	`salary` INT NOT NULL,
	`skin_male` LONGTEXT NOT NULL,
	`skin_female` LONGTEXT NOT NULL,

	PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `jobs` (
	`name` VARCHAR(50) NOT NULL,
	`label` VARCHAR(50) DEFAULT NULL,
	`type` VARCHAR(50) NOT NULL DEFAULT 'civ',
	`whitelisted` TINYINT(1) NOT NULL DEFAULT 0,

	PRIMARY KEY (`name`)
) ENGINE=InnoDB;

INSERT INTO `jobs` (`name`, `label`, `type`, `whitelisted`) VALUES
('ambulance', 'EMS', 'ems', 0),
('cardealer', 'Concessionnaire', 'civ', 0),
('fisherman', 'Pecheur', 'civ', 0),
('fueler', 'Livreur Carburant', 'civ', 0),
('lumberjack', 'Bucheron', 'civ', 0),
('mechanic', 'Mecanicien', 'mechanic', 0),
('miner', 'Mineur', 'civ', 0),
('police', 'LSPD', 'leo', 0),
('reporter', 'Journaliste', 'civ', 0),
('slaughterer', 'Boucher', 'civ', 0),
('tailor', 'Couturier', 'civ', 0),
('taxi', 'Taxi', 'civ', 0),
('unemployed', 'Sans Emplois', 'civ', 0);

INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(1, 'unemployed', 0, 'unemployed', 'Sans Emplois', 200, '{}', '{}'),
(2, 'police', 0, 'recruit', 'Recrue', 20, '{}', '{}'),
(3, 'police', 1, 'officer', 'Officier', 40, '{}', '{}'),
(4, 'police', 2, 'sergeant', 'Sergent', 60, '{}', '{}'),
(5, 'police', 3, 'lieutenant', 'Lieutenant', 85, '{}', '{}'),
(6, 'police', 4, 'boss', 'Capitaine', 100, '{}', '{}'),
(11, 'cardealer', 0, 'recruit', 'Recrue', 10, '{}', '{}'),
(12, 'cardealer', 1, 'novice', 'Novice', 25, '{}', '{}'),
(13, 'cardealer', 2, 'experienced', 'Experimente', 40, '{}', '{}'),
(14, 'cardealer', 3, 'boss', 'Patron', 0, '{}', '{}'),
(15, 'lumberjack', 0, 'employee', 'Employe', 0, '{}', '{}'),
(16, 'fisherman', 0, 'employee', 'Employe', 0, '{}', '{}'),
(17, 'fueler', 0, 'employee', 'Employe', 0, '{}', '{}'),
(18, 'reporter', 0, 'employee', 'Employe', 0, '{}', '{}'),
(19, 'tailor', 0, 'employee', 'Employe', 0, '{}', '{}'),
(20, 'miner', 0, 'employee', 'Employe', 0, '{}', '{}'),
(21, 'slaughterer', 0, 'employee', 'Employe', 0, '{}', '{}'),
(22, 'ambulance', 0, 'ambulance', 'Ambulancier Junior', 20, '{}', '{}'),
(23, 'ambulance', 1, 'doctor', 'Ambulancier', 40, '{}', '{}'),
(24, 'ambulance', 2, 'chief_doctor', 'Ambulancier Senior', 60, '{}', '{}'),
(25, 'ambulance', 3, 'boss', 'Superviseur EMS', 80, '{}', '{}'),
(26, 'mechanic', 0, 'recrue', 'Recrue', 12, '{}', '{}'),
(27, 'mechanic', 1, 'novice', 'Novice', 24, '{}', '{}'),
(28, 'mechanic', 2, 'experimente', 'Experimente', 36, '{}', '{}'),
(29, 'mechanic', 3, 'chief', 'Chef', 48, '{}', '{}'),
(30, 'mechanic', 4, 'boss', 'Patron', 0, '{}', '{}'),
(31, 'taxi', 0, 'recrue', 'Recrue', 12, '{}', '{}'),
(32, 'taxi', 1, 'novice', 'Chauffeur', 24, '{}', '{}'),
(33, 'taxi', 2, 'experimente', 'Experimente', 36, '{}', '{}'),
(34, 'taxi', 3, 'uber', 'Chauffeur Uber', 48, '{}', '{}'),
(35, 'taxi', 4, 'boss', 'Chauffeur Principal', 0, '{}', '{}');

ALTER TABLE `users`
	ADD COLUMN `firstname` VARCHAR(16) NULL DEFAULT NULL,
	ADD COLUMN `lastname` VARCHAR(16) NULL DEFAULT NULL,
	ADD COLUMN `dateofbirth` VARCHAR(10) NULL DEFAULT NULL,
	ADD COLUMN `sex` VARCHAR(1) NULL DEFAULT NULL,
	ADD COLUMN `height` INT NULL DEFAULT NULL
;

ALTER TABLE `users` ADD COLUMN `skin` LONGTEXT NULL DEFAULT NULL;


CREATE TABLE `multicharacter_slots` (
	`identifier` VARCHAR(60) NOT NULL,
	`slots` INT(11) NOT NULL,
	PRIMARY KEY (`identifier`) USING BTREE,
	INDEX `slots` (`slots`) USING BTREE
) ENGINE=InnoDB;

ALTER TABLE `users` ADD COLUMN
	`disabled` TINYINT(1) NULL DEFAULT '0';
