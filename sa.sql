DROP PROCEDURE IF EXISTS `drop_all_tables`;

DELIMITER $$
CREATE PROCEDURE `drop_all_tables`()
BEGIN
    DECLARE _done INT DEFAULT FALSE;
    DECLARE _tableName VARCHAR(255);
    DECLARE _cursor CURSOR FOR
        SELECT table_name 
        FROM information_schema.TABLES
        WHERE table_schema = SCHEMA();
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET _done = TRUE;

    SET FOREIGN_KEY_CHECKS = 0;

    OPEN _cursor;

    REPEAT FETCH _cursor INTO _tableName;

    IF NOT _done THEN
        SET @stmt_sql = CONCAT('DROP TABLE ', _tableName);
        PREPARE stmt1 FROM @stmt_sql;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;
    END IF;

    UNTIL _done END REPEAT;

    CLOSE _cursor;
    SET FOREIGN_KEY_CHECKS = 1;
END$$

DELIMITER ;

call drop_all_tables(); 

DROP PROCEDURE IF EXISTS `drop_all_tables`;

#department
CREATE TABLE `department` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `abbr` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',

  PRIMARY KEY (`id`),

  UNIQUE KEY `department_unique_name` (`name`),
  UNIQUE KEY `department_unique_abbr` (`abbr`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `department_on_insert` BEFORE INSERT ON `department`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `department_on_update` BEFORE UPDATE ON `department`
    FOR EACH ROW SET NEW.last_modified = NOW();

#user
CREATE TABLE `user` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `onyen` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `unc_pid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `first_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `department_id` int(10) unsigned DEFAULT NULL,
  
  PRIMARY KEY (`id`),
  
  UNIQUE KEY `user_unique_email` (`email`),
  UNIQUE KEY `user_unique_onyen` (`onyen`),
  UNIQUE KEY `user_unique_unc_pid` (`unc_pid`),
  KEY `user_idx_department_id` (`department_id`),
  
  CONSTRAINT `user_fk_department_id`
    FOREIGN KEY (`department_id`)
    REFERENCES `department` (`id`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `user_on_insert` BEFORE INSERT ON `user`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `user_on_update` BEFORE UPDATE ON `user`
    FOR EACH ROW SET NEW.last_modified = NOW();
#emailtype

CREATE TABLE `emailtype` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',

  PRIMARY KEY (`id`),

  UNIQUE KEY `emailtype_unique_type` (`type`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `emailtype_on_insert` BEFORE INSERT ON `emailtype`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `emailtype_on_update` BEFORE UPDATE ON `emailtype`
    FOR EACH ROW SET NEW.last_modified = NOW();

#emailrecipienttype
CREATE TABLE `emailrecipienttype` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',

  PRIMARY KEY (`id`),

  UNIQUE KEY `emailrecipienttype_unique_type` (`type`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `emailrecipienttype_on_insert` BEFORE INSERT ON `emailrecipienttype`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `emailrecipienttype_on_update` BEFORE UPDATE ON `emailrecipienttype`
    FOR EACH ROW SET NEW.last_modified = NOW();

#email
CREATE TABLE `email` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `emailtype_id` int(11) unsigned NOT NULL,
  `subject` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `body` mediumtext COLLATE utf8_unicode_ci,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',

  PRIMARY KEY (`id`),

  KEY `email_idx_emailtype_id` (`emailtype_id`),
  
  CONSTRAINT `email_fk_emailtype_id`
    FOREIGN KEY (`emailtype_id`)
    REFERENCES `emailtype` (`id`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `email_on_insert` BEFORE INSERT ON `email`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `email_on_update` BEFORE UPDATE ON `email`
    FOR EACH ROW SET NEW.last_modified = NOW();

#emailrecipient
CREATE TABLE `emailrecipient` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `email_id` int(11) unsigned NOT NULL,
  `emailrecipienttype_id` int(11) unsigned NOT NULL,
  `user_email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',

  PRIMARY KEY (`id`),

  KEY `emailrecipient_idx_email_id` (`email_id`),
  KEY `emailrecipient_idx_emailrecipienttype_id` (`emailrecipienttype_id`),
  KEY `emailrecipient_idx_user_email` (`user_email`),
  UNIQUE KEY `emailrecipient_unique_recipient_once_per_email` (`email_id`,`user_email`),
  
  CONSTRAINT `emailrecipient_fk_email_id`
    FOREIGN KEY (`email_id`)
    REFERENCES `email` (`id`),

  CONSTRAINT `emailrecipient_fk_user_email`
    FOREIGN KEY (`user_email`)
    REFERENCES `user` (`email`),

  CONSTRAINT `emailrecipient_fk_emailrecipienttype_id`
    FOREIGN KEY (`emailrecipienttype_id`)
    REFERENCES `emailrecipienttype` (`id`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `emailrecipient_on_insert` BEFORE INSERT ON `emailrecipient`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `emailrecipient_on_update` BEFORE UPDATE ON `emailrecipient`
    FOR EACH ROW SET NEW.last_modified = NOW();

#emailsendattempt
CREATE TABLE `emailsendattempt` (

  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `email_id` int(11) unsigned NOT NULL,
  `succeeded` tinyint(1) DEFAULT '0',
  `attempted` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',

  PRIMARY KEY (`id`),

  KEY `emailsendattempt_idx_email_id` (`email_id`),

  CONSTRAINT `emailsendattempt_fk_email_id`
    FOREIGN KEY (`email_id`)
    REFERENCES `email` (`id`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `emailsendattempt_on_insert` BEFORE INSERT ON `emailsendattempt`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `emailsendattempt_on_update` BEFORE UPDATE ON `emailsendattempt`
    FOR EACH ROW SET NEW.last_modified = NOW();

#upload
CREATE TABLE `upload` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `file_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `file_size` int(11) NOT NULL,
  `file_content` mediumblob NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',

  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `upload_on_insert` BEFORE INSERT ON `upload`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `upload_on_update` BEFORE UPDATE ON `upload`
    FOR EACH ROW SET NEW.last_modified = NOW();

#hispaniclatino
CREATE TABLE `hispaniclatino` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `option` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',

  PRIMARY KEY (`id`),

  UNIQUE KEY `hispaniclatino_unique_option` (`option`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `hispaniclatino_on_insert` BEFORE INSERT ON `hispaniclatino`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `hispaniclatino_on_update` BEFORE UPDATE ON `hispaniclatino`
    FOR EACH ROW SET NEW.last_modified = NOW();

#raceselfid
CREATE TABLE `raceselfid` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `option` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',

  PRIMARY KEY (`id`),

  UNIQUE KEY `raceselfid_unique_option` (`option`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `raceselfid_on_insert` BEFORE INSERT ON `raceselfid`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `raceselfid_on_update` BEFORE UPDATE ON `raceselfid`
    FOR EACH ROW SET NEW.last_modified = NOW();

#frracceptdecline
CREATE TABLE `frracceptdecline` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `option` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',

  PRIMARY KEY (`id`),

  UNIQUE KEY `frracceptdecline_unique_option` (`option`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `frracceptdecline_on_insert` BEFORE INSERT ON `frracceptdecline`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `frracceptdecline_on_update` BEFORE UPDATE ON `frracceptdecline`
    FOR EACH ROW SET NEW.last_modified = NOW();

#awardcycle
CREATE TABLE `awardcycle` (
 
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `begin_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  
  PRIMARY KEY (`id`),
  
  UNIQUE KEY `awardcycle_unique_name` (`name`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `awardcycle_on_insert` BEFORE INSERT ON `awardcycle`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `awardcycle_on_update` BEFORE UPDATE ON `awardcycle`
    FOR EACH ROW SET NEW.last_modified = NOW();

#nominationtype
CREATE TABLE `nominationtype` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `nom_class_table` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `item_label` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `item_label_plural` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `max_offers_per_nomination` int(11) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1,
  
  PRIMARY KEY (`id`),
  UNIQUE KEY `nomtype_unique_name` (`name`),
  UNIQUE KEY `nomtype_unique_nom_class_table` (`nom_class_table`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `nominationtype_on_insert` BEFORE INSERT ON `nominationtype`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `nominationtype_on_update` BEFORE UPDATE ON `nominationtype`
    FOR EACH ROW SET NEW.last_modified = NOW();

#awardcycle_nominationtype
CREATE TABLE `awardcycle_nominationtype` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `awardcycle_id` int(11) unsigned NOT NULL,
  `nominationtype_id` int(11) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  
  PRIMARY KEY (`awardcycle_id`,`nominationtype_id`),
  
  UNIQUE KEY `acnt_serial` (`id`),
  KEY `acnt_idx_nominationtype_id` (`nominationtype_id`),
  KEY `acnt_idx_awardcycle_id` (`awardcycle_id`),
  
  CONSTRAINT `acnt_fk_awardcycle_id`
    FOREIGN KEY (`awardcycle_id`)
    REFERENCES `awardcycle` (`id`),
  
  CONSTRAINT `acnt_fk_nominationtype_id`
    FOREIGN KEY (`nominationtype_id`)
    REFERENCES `nominationtype` (`id`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `awardcycle_nominationtype_on_insert` BEFORE INSERT ON `awardcycle_nominationtype`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `awardcycle_nominationtype_on_update` BEFORE UPDATE ON `awardcycle_nominationtype`
    FOR EACH ROW SET NEW.last_modified = NOW();

#awardprofile
CREATE TABLE `awardprofile` (

  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `formal_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci NOT NULL,
  `criteria_requirements` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `designation_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `has_custom_notification_email` tinyint(1) DEFAULT 0,
  `profile_class_table` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `about_donors` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `about_scholarship` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `thankyou_addressee` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `donor_contact_info` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `osa_criteria` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1,

  PRIMARY KEY (`id`),

  UNIQUE KEY `awardprofile_unique_name` (`name`),
  UNIQUE KEY `awardprofile_unique_formal_name` (`formal_name`),
  UNIQUE KEY `awardprofile_unique_designation_number` (`designation_number`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `awardprofile_on_insert` BEFORE INSERT ON `awardprofile`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `awardprofile_on_update` BEFORE UPDATE ON `awardprofile`
    FOR EACH ROW SET NEW.last_modified = NOW();

#awardoffer
CREATE TABLE `awardoffer` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `awardcycle_id` int(11) unsigned NOT NULL,
  `nominationtype_id` int(11) unsigned NOT NULL,
  `awardprofile_id` int(11) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1,
  
  PRIMARY KEY (`awardcycle_id`,`awardprofile_id`),
  
  UNIQUE KEY `awardoffer_serial` (`id`),
  KEY `awardoffer_idx_awardcycle_id` (`awardcycle_id`),
  KEY `awardoffer_idx_nominationtype_id` (`nominationtype_id`),
  KEY `awardoffer_idx_awardprofile_id` (`awardprofile_id`),
  KEY `ao_for_nao_ao_exists_and_same_nomtype_and_ac` (`awardcycle_id`,`nominationtype_id`,`awardprofile_id`),
  
  CONSTRAINT `awardoffer_fk_awardcycle_id`
    FOREIGN KEY (`awardcycle_id`)
    REFERENCES `awardcycle` (`id`),
  
  CONSTRAINT `awardoffer_fk_awardprofile_id`
    FOREIGN KEY (`awardprofile_id`)
    REFERENCES `awardprofile` (`id`),
  
  CONSTRAINT `awardoffer_fk_nominationtype_id`
    FOREIGN KEY (`nominationtype_id`)
    REFERENCES `nominationtype` (`id`),
  
  CONSTRAINT `awardoffer_unique_acnt_pair_exists`
    FOREIGN KEY (`awardcycle_id`, `nominationtype_id`)
    REFERENCES `awardcycle_nominationtype` (`awardcycle_id`, `nominationtype_id`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `awardoffer_on_insert` BEFORE INSERT ON `awardoffer`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `awardoffer_on_update` BEFORE UPDATE ON `awardoffer`
    FOR EACH ROW SET NEW.last_modified = NOW();

#nomination
CREATE TABLE `nomination` (

  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `nominee_id` int(11) unsigned NOT NULL,
  `awardcycle_id` int(11) unsigned NOT NULL,
  `nominationtype_id` int(11) unsigned NOT NULL,
  `nom_class_table` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `nominator_id` int(11) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1,

  PRIMARY KEY (`nominee_id`,`awardcycle_id`,`nom_class_table`),
  
  UNIQUE KEY `nomination_serial` (`id`),
  KEY `nomination_idx_nominee_id` (`nominee_id`),
  KEY `nomination_idx_nominator_id` (`nominator_id`),
  KEY `nomination_idx_awardcycle_id` (`awardcycle_id`),
  KEY `nomination_idx_nom_class_table` (`nom_class_table`),
  KEY `nomination_idx_nominationtype_id` (`nominationtype_id`),
  KEY `nom_for_nao_nom_exists_and_same_nomtype_and_cycle` (`nominee_id`,`awardcycle_id`,`nominationtype_id`),
  
  CONSTRAINT `nomination_fk_awardcycle_id`
    FOREIGN KEY (`awardcycle_id`)
    REFERENCES `awardcycle` (`id`),
  
  CONSTRAINT `nomination_fk_nom_class_table`
    FOREIGN KEY (`nom_class_table`)
    REFERENCES `nominationtype` (`nom_class_table`),
  
  CONSTRAINT `nomination_fk_nominee_id`
    FOREIGN KEY (`nominee_id`)
    REFERENCES `user` (`id`),
  
  CONSTRAINT `nomination_fk_nominator_id`
    FOREIGN KEY (`nominator_id`)
    REFERENCES `user` (`id`),

  CONSTRAINT `nomination_unique_acnt_pair_exists`
    FOREIGN KEY (`awardcycle_id`, `nominationtype_id`)
    REFERENCES `awardcycle_nominationtype` (`awardcycle_id`, `nominationtype_id`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `nomination_on_insert` BEFORE INSERT ON `nomination`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `nomination_on_update` BEFORE UPDATE ON `nomination`
    FOR EACH ROW SET NEW.last_modified = NOW();

#selfnom
CREATE TABLE `selfnom` (

  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `nomination_id` int(11) unsigned NOT NULL,
  
  `department_id` int(11) unsigned DEFAULT NULL,
  `degree_program` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `undergrad_institution` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `undergrad_gpa` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `graduate_institution` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `hispaniclatino_id` int(11) unsigned DEFAULT NULL,
  
  `personal_statement` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `cv` int(11) unsigned DEFAULT NULL,
  
  `frr_requestee_id` int(11) unsigned DEFAULT NULL,
  `frr_email_id` int(11) unsigned DEFAULT NULL,
  `frr_email_sent` tinyint(1) DEFAULT 0,
  `frracceptdecline` int(11) unsigned DEFAULT NULL,
  `frr_recommendation_text` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `frr_text_created` datetime DEFAULT NULL,
  `frr_text_last_modified` datetime DEFAULT NULL,

  `reject_email_id` int(11) unsigned DEFAULT NULL,
  `reject_email_sent` tinyint(1) DEFAULT 0,

  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1,

  PRIMARY KEY (`nomination_id`),

  UNIQUE KEY `selfnom_serial` (`id`),

  CONSTRAINT `selfnom_fk_nomination_id`
    FOREIGN KEY (`nomination_id`)
    REFERENCES `nomination` (`id`),

  CONSTRAINT `selfnom_fk_frr_email_id`
    FOREIGN KEY (`frr_email_id`)
    REFERENCES `email` (`id`),

  CONSTRAINT `selfnom_fk_reject_email_id`
    FOREIGN KEY (`reject_email_id`)
    REFERENCES `email` (`id`),
  
  CONSTRAINT `selfnom_fk_department_id`
    FOREIGN KEY (`department_id`)
    REFERENCES `department` (`id`),

  CONSTRAINT `selfnom_fk_cv_upload_id`
    FOREIGN KEY (`cv`)
    REFERENCES `upload` (`id`),

  CONSTRAINT `selfnom_fk_frr_user_id`
    FOREIGN KEY (`frr_requestee_id`)
    REFERENCES `user` (`id`),

  CONSTRAINT `selfnom_fk_frr_acceptdecline`
    FOREIGN KEY (`frracceptdecline`)
    REFERENCES `frracceptdecline` (`id`),

  CONSTRAINT `selfnom_fk_hispaniclatino_id`
    FOREIGN KEY (`hispaniclatino_id`)
    REFERENCES `hispaniclatino` (`id`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

#selfnom_raceselfid
CREATE TABLE `selfnom_raceselfid` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `selfnom_id` int(11) unsigned NOT NULL,
  `raceselfid_id` int(11) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  
  PRIMARY KEY (`selfnom_id`,`raceselfid_id`),
  
  UNIQUE KEY `snrsi_serial` (`id`),
  KEY `snrsi_idx_raceselfid_id` (`raceselfid_id`),
  KEY `snrsi_idx_selfnom_id` (`selfnom_id`),
  
  CONSTRAINT `snrsi_fk_selfnom_id`
    FOREIGN KEY (`selfnom_id`)
    REFERENCES `selfnom` (`id`),
  
  CONSTRAINT `snrsi_fk_raceselfid_id`
    FOREIGN KEY (`raceselfid_id`)
    REFERENCES `raceselfid` (`id`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `selfnom_raceselfid_on_insert` BEFORE INSERT ON `selfnom_raceselfid`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `selfnom_raceselfid_on_update` BEFORE UPDATE ON `selfnom_raceselfid`
    FOR EACH ROW SET NEW.last_modified = NOW();

#nomination_awardoffer
CREATE TABLE `nomination_awardoffer` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `nomination_id` int(11) unsigned NOT NULL,
  `awardoffer_id` int(11) unsigned NOT NULL,
  `nominee_id` int(11) unsigned NOT NULL,
  `awardcycle_id` int(11) unsigned NOT NULL,
  `nominationtype_id` int(11) unsigned NOT NULL,
  `awardprofile_id` int(11) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1,
  
  PRIMARY KEY (`nominee_id`,`awardcycle_id`,`awardprofile_id`),

  UNIQUE KEY `nao_serial` (`id`),
  KEY `nao_idx_awardcycle_id` (`awardcycle_id`),
  KEY `nao_idx_awardoffer_id` (`awardoffer_id`),
  KEY `nao_idx_awardprofile_id` (`awardprofile_id`),
  KEY `nao_idx_nomination_id` (`nomination_id`),
  KEY `nao_idx_nominationtype_id` (`nominationtype_id`),
  KEY `nao_idx_nominee_id` (`nominee_id`),
  
  CONSTRAINT `nao_fk_awardcycle_id`
    FOREIGN KEY (`awardcycle_id`)
    REFERENCES `awardcycle` (`id`),
  
  CONSTRAINT `nao_fk_awardprofile_id`
    FOREIGN KEY (`awardprofile_id`)
    REFERENCES `awardprofile` (`id`),
  
  CONSTRAINT `nao_fk_nominationtype_id`
    FOREIGN KEY (`nominationtype_id`)
    REFERENCES `nominationtype` (`id`),
  
  CONSTRAINT `nao_fk_nominee_id`
    FOREIGN KEY (`nominee_id`)
    REFERENCES `user` (`id`),
  
  CONSTRAINT `nao_fk_nomination_id`
    FOREIGN KEY (`nomination_id`)
    REFERENCES `nomination` (`id`),
  
  CONSTRAINT `nao_fk_awardoffer_id`
    FOREIGN KEY (`awardoffer_id`)
    REFERENCES `awardoffer` (`id`),


  CONSTRAINT `nao_unique_acnt_pair_exists`
    FOREIGN KEY (
      `awardcycle_id`,
      `nominationtype_id`
    ) REFERENCES `awardcycle_nominationtype` (
      `awardcycle_id`,
      `nominationtype_id`
    ),

  CONSTRAINT `nao_nomination_exists_and_same_nomtype_and_cycle`
    FOREIGN KEY (
      `nominee_id`,
      `awardcycle_id`,
      `nominationtype_id`
    ) REFERENCES `nomination` (
      `nominee_id`,
      `awardcycle_id`,
      `nominationtype_id`
    ),

  CONSTRAINT `nao_awardoffer_exists_and_same_nomtype_and_cycle`
    FOREIGN KEY (
      `awardcycle_id`,
      `nominationtype_id`,
      `awardprofile_id`
    ) REFERENCES `awardoffer` (
      `awardcycle_id`,
      `nominationtype_id`,
      `awardprofile_id`
    )
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `nomination_awardoffer_on_insert` BEFORE INSERT ON `nomination_awardoffer`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `nomination_awardoffer_on_update` BEFORE UPDATE ON `nomination_awardoffer`
    FOR EACH ROW SET NEW.last_modified = NOW();

#milestonetype
CREATE TABLE `milestonetype` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `order` int(11) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1,
  
  PRIMARY KEY `milestonetype_unique_slug` (`slug`),

  UNIQUE KEY `milestonetype_serial` (`id`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `milestonetype_on_insert` BEFORE INSERT ON `milestonetype`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `milestonetype_on_update` BEFORE UPDATE ON `milestonetype`
    FOR EACH ROW SET NEW.last_modified = NOW();

#milestonetype_nominationtype
CREATE TABLE `milestonetype_nominationtype` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `milestonetype_slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `nominationtype_id` int(11) unsigned NOT NULL,
  `alt_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1,
  
  PRIMARY KEY `mstnt_unique_mstnt_pair` (`milestonetype_slug`,`nominationtype_id`),
  
  UNIQUE KEY `mstnt_serial` (`id`),
  KEY `mstnt_idx_milestonetype_slug` (`milestonetype_slug`),
  KEY `mstnt_idx_nominationtype_id` (`nominationtype_id`),
  
  CONSTRAINT `mstnt_fk_milestonetype_slug`
    FOREIGN KEY (`milestonetype_slug`)
    REFERENCES `milestonetype` (`slug`),
  
  CONSTRAINT `mstnt_fk_nominationtype_id`
    FOREIGN KEY (`nominationtype_id`)
    REFERENCES `nominationtype` (`id`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `milestonetype_nominationtype_on_insert` BEFORE INSERT ON `milestonetype_nominationtype`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `milestonetype_nominationtype_on_update` BEFORE UPDATE ON `milestonetype_nominationtype`
    FOR EACH ROW SET NEW.last_modified = NOW();

CREATE TABLE `milestone` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `milestonetype_slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `nominationtype_id` int(11) unsigned NOT NULL,
  `awardcycle_id` int(11) unsigned NOT NULL,
  `date` date NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1,

  PRIMARY KEY `milestone_mstype_once_per_nomtype_per_cycle` (`milestonetype_slug`, `nominationtype_id`, `awardcycle_id`),
  
  UNIQUE KEY `milestone_serial` (`id`),  
  KEY `milestone_idx_nominationtype_id` (`nominationtype_id`),
  KEY `milestone_idx_milestonetype_id` (`milestonetype_slug`),
  KEY `milestone_idx_awardcycle_id` (`awardcycle_id`),

  CONSTRAINT `milestone_fk_awardcycle_id`
    FOREIGN KEY (`awardcycle_id`)
    REFERENCES `awardcycle` (`id`),
  
  CONSTRAINT `milestone_fk_milestonetype_slug`
    FOREIGN KEY (`milestonetype_slug`)
    REFERENCES `milestonetype` (`slug`),
  
  CONSTRAINT `milestone_fk_nominationtype_id`
    FOREIGN KEY (`nominationtype_id`)
    REFERENCES `nominationtype` (`id`),

  CONSTRAINT `ms_unique_mstnt_pair_exists`
    FOREIGN KEY (
      `milestonetype_slug`,
      `nominationtype_id`
    ) REFERENCES `milestonetype_nominationtype` (
      `milestonetype_slug`,
      `nominationtype_id`
    ),

  CONSTRAINT `ms_unique_acnt_pair_exists`
    FOREIGN KEY (
      `awardcycle_id`,
      `nominationtype_id`
    ) REFERENCES `awardcycle_nominationtype` (
      `awardcycle_id`,
      `nominationtype_id`
    )

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

#role
CREATE TABLE `role` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1,
  
  PRIMARY KEY `role_unique_slug` (`slug`),

  UNIQUE KEY `role_serial` (`id`),
  UNIQUE KEY `role_name` (`name`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `role_on_insert` BEFORE INSERT ON `role`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `role_on_update` BEFORE UPDATE ON `role`
    FOR EACH ROW SET NEW.last_modified = NOW();

#capability
CREATE TABLE `capability` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1,
  
  PRIMARY KEY `capability_unique_slug` (`slug`),

  UNIQUE KEY `capability_serial` (`id`),
  UNIQUE KEY `capability_name` (`name`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `capability_on_insert` BEFORE INSERT ON `capability`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `capability_on_update` BEFORE UPDATE ON `capability`
    FOR EACH ROW SET NEW.last_modified = NOW();

#role_capability
CREATE TABLE `role_capability` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `role_slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `capability_slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1,
  
  PRIMARY KEY `rolcap_unique_rolcap_pair` (`role_slug`,`capability_slug`),
  
  UNIQUE KEY `rolcap_serial` (`id`),
  KEY `rolcap_idx_role_slug` (`role_slug`),
  KEY `rolcap_idx_capability_slug` (`capability_slug`),
  
  CONSTRAINT `rolcap_fk_role_slug`
    FOREIGN KEY (`role_slug`)
    REFERENCES `role` (`slug`),
  
  CONSTRAINT `rolcap_fk_capability_slug`
    FOREIGN KEY (`capability_slug`)
    REFERENCES `capability` (`slug`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `role_capability_on_insert` BEFORE INSERT ON `role_capability`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `role_capability_on_update` BEFORE UPDATE ON `role_capability`
    FOR EACH ROW SET NEW.last_modified = NOW();

#user_role
CREATE TABLE `user_role` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL,
  `role_id` int(11) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1,
  
  PRIMARY KEY `user_role_unique_user_role_pair` (`user_id`,`role_id`),
  
  UNIQUE KEY `user_role_serial` (`id`),
  KEY `user_role_idx_user_id` (`user_id`),
  KEY `user_role_idx_role_id` (`role_id`),
  
  CONSTRAINT `user_role_fk_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`),
  
  CONSTRAINT `user_role_fk_role_id`
    FOREIGN KEY (`role_id`)
    REFERENCES `role` (`id`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `user_role_on_insert` BEFORE INSERT ON `user_role`
    FOR EACH ROW BEGIN
      SET NEW.created = IFNULL(NEW.created, NOW());
      SET NEW.last_modified = IFNULL(NEW.last_modified, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `user_role_on_update` BEFORE UPDATE ON `user_role`
    FOR EACH ROW SET NEW.last_modified = NOW();

SHOW ENGINE INNODB STATUS;
