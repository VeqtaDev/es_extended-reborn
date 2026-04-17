CREATE DATABASE IF NOT EXISTS `es_extended`;

ALTER DATABASE `es_extended`
	DEFAULT CHARACTER SET UTF8MB4;
	
ALTER DATABASE `es_extended`
	DEFAULT COLLATE UTF8MB4_UNICODE_CI;

USE `es_extended`;

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

INSERT INTO `job_grades` VALUES (1,'unemployed',0,'unemployed','Sans Emplois',200,'{}','{}');

CREATE TABLE `jobs` (
	`name` VARCHAR(50) NOT NULL,
	`label` VARCHAR(50) DEFAULT NULL,

	PRIMARY KEY (`name`)
) ENGINE=InnoDB;

INSERT INTO `jobs` VALUES ('unemployed','Sans Emplois');

-- Nettoyage / traduction labels jobs
-- Supprime le job banker s'il existe dans une base déjà peuplée
DELETE FROM `job_grades` WHERE `job_name` = 'banker';
DELETE FROM `jobs` WHERE `name` = 'banker';

-- Traductions et renommages demandés
UPDATE `jobs` SET `label` = 'Sans Emplois' WHERE `name` = 'unemployed';
UPDATE `job_grades` SET `label` = 'Sans Emplois' WHERE `job_name` = 'unemployed';
UPDATE `jobs` SET `label` = 'LSPD' WHERE `name` = 'police';
UPDATE `job_grades` SET `label` = 'LSPD' WHERE `job_name` = 'police';
UPDATE `jobs` SET `label` = 'EMS' WHERE `name` = 'ambulance';
UPDATE `job_grades` SET `label` = 'EMS' WHERE `job_name` = 'ambulance';
