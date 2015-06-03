#added declined reason to awards?

#department
CREATE TABLE `department` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `abbr` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',

  PRIMARY KEY (`id`),

  UNIQUE KEY `department_unique_name` (`name`),
  UNIQUE KEY `department_unique_abbr` (`abbr`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `department_on_insert` BEFORE INSERT ON `department`
    FOR EACH ROW BEGIN
      SET NEW.created_at = IFNULL(NEW.created_at, NOW());
      SET NEW.updated_at = IFNULL(NEW.updated_at, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `department_on_update` BEFORE UPDATE ON `department`
    FOR EACH ROW SET NEW.updated_at = NOW();

#user
CREATE TABLE `user` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `onyen` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `unc_pid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
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
      SET NEW.created_at = IFNULL(NEW.created_at, NOW());
      SET NEW.updated_at = IFNULL(NEW.updated_at, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `user_on_update` BEFORE UPDATE ON `user`
    FOR EACH ROW SET NEW.updated_at = NOW();

#hispaniclatino
CREATE TABLE `hispaniclatino` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `option` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',

  PRIMARY KEY (`id`),

  UNIQUE KEY `hispaniclatino_unique_option` (`option`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `hispaniclatino_on_insert` BEFORE INSERT ON `hispaniclatino`
    FOR EACH ROW BEGIN
      SET NEW.created_at = IFNULL(NEW.created_at, NOW());
      SET NEW.updated_at = IFNULL(NEW.updated_at, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `hispaniclatino_on_update` BEFORE UPDATE ON `hispaniclatino`
    FOR EACH ROW SET NEW.updated_at = NOW();

#raceselfid
CREATE TABLE `raceselfid` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `option` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',

  PRIMARY KEY (`id`),

  UNIQUE KEY `raceselfid_unique_option` (`option`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `raceselfid_on_insert` BEFORE INSERT ON `raceselfid`
    FOR EACH ROW BEGIN
      SET NEW.created_at = IFNULL(NEW.created_at, NOW());
      SET NEW.updated_at = IFNULL(NEW.updated_at, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `raceselfid_on_update` BEFORE UPDATE ON `raceselfid`
    FOR EACH ROW SET NEW.updated_at = NOW();


#awardcycle
CREATE TABLE `awardcycle` (
 
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `begin_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  
  PRIMARY KEY (`id`),
  
  UNIQUE KEY `awardcycle_unique_name` (`name`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `awardcycle_on_insert` BEFORE INSERT ON `awardcycle`
    FOR EACH ROW BEGIN
      SET NEW.created_at = IFNULL(NEW.created_at, NOW());
      SET NEW.updated_at = IFNULL(NEW.updated_at, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `awardcycle_on_update` BEFORE UPDATE ON `awardcycle`
    FOR EACH ROW SET NEW.updated_at = NOW();

#nominationtype
CREATE TABLE `nominationtype` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `nom_class_table` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `item_label` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `item_label_plural` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `max_offers_per_nomination` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` tinyint DEFAULT 1,
  
  PRIMARY KEY (`id`),
  UNIQUE KEY `nomtype_unique_name` (`name`),
  UNIQUE KEY `nomtype_unique_nom_class_table` (`nom_class_table`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `nominationtype_on_insert` BEFORE INSERT ON `nominationtype`
    FOR EACH ROW BEGIN
      SET NEW.created_at = IFNULL(NEW.created_at, NOW());
      SET NEW.updated_at = IFNULL(NEW.updated_at, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `nominationtype_on_update` BEFORE UPDATE ON `nominationtype`
    FOR EACH ROW SET NEW.updated_at = NOW();

#awardcycle_nominationtype
CREATE TABLE `awardcycle_nominationtype` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `awardcycle_id` int(11) unsigned NOT NULL,
  `nominationtype_id` int(11) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
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
      SET NEW.created_at = IFNULL(NEW.created_at, NOW());
      SET NEW.updated_at = IFNULL(NEW.updated_at, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `awardcycle_nominationtype_on_update` BEFORE UPDATE ON `awardcycle_nominationtype`
    FOR EACH ROW SET NEW.updated_at = NOW();

#awardprofile
CREATE TABLE `awardprofile` (

  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `formal_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci NOT NULL,
  `criteria_requirements` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `designation_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `about_donors` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `about_scholarship` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `thankyou_addressee` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `donor_contact_info` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `osa_criteria` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` tinyint DEFAULT 1,

  PRIMARY KEY (`id`),

  UNIQUE KEY `awardprofile_unique_name` (`name`),
  UNIQUE KEY `awardprofile_unique_formal_name` (`formal_name`),
  UNIQUE KEY `awardprofile_unique_designation_number` (`designation_number`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //
CREATE TRIGGER `awardprofile_on_insert` BEFORE INSERT ON `awardprofile`
    FOR EACH ROW BEGIN
      SET NEW.created_at = IFNULL(NEW.created_at, NOW());
      SET NEW.updated_at = IFNULL(NEW.updated_at, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `awardprofile_on_update` BEFORE UPDATE ON `awardprofile`
    FOR EACH ROW SET NEW.updated_at = NOW();

#awardoffer
CREATE TABLE `awardoffer` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `awardcycle_id` int(11) unsigned NOT NULL,
  `nominationtype_id` int(11) unsigned NOT NULL,
  `awardprofile_id` int(11) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` tinyint DEFAULT 1,
  
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
      SET NEW.created_at = IFNULL(NEW.created_at, NOW());
      SET NEW.updated_at = IFNULL(NEW.updated_at, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `awardoffer_on_update` BEFORE UPDATE ON `awardoffer`
    FOR EACH ROW SET NEW.updated_at = NOW();

#nomination
CREATE TABLE `nomination` (

  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `nominee_id` int(11) unsigned NOT NULL,
  `awardcycle_id` int(11) unsigned NOT NULL,
  `nominationtype_id` int(11) unsigned NOT NULL,
  `nom_class_table` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `nominator_id` int(11) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` tinyint DEFAULT 1,

  PRIMARY KEY (`nominee_id`,`awardcycle_id`,`nom_class_table`),
  
  UNIQUE KEY `nomination_serial` (`id`),
  KEY `nomination_idx_nominee_id` (`nominee_id`),
  KEY `nomination_idx_nominator_id` (`nominator_id`),
  KEY `nomination_idx_awardcycle_id` (`awardcycle_id`),
  KEY `nomination_idx_nom_class_table` (`nom_class_table`),
  KEY `nomination_idx_nominationtype_id` (`nominationtype_id`),
  
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
      SET NEW.created_at = IFNULL(NEW.created_at, NOW());
      SET NEW.updated_at = IFNULL(NEW.updated_at, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `nomination_on_update` BEFORE UPDATE ON `nomination`
    FOR EACH ROW SET NEW.updated_at = NOW();

#selfnom
CREATE TABLE `selfnom` (

  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `nomination_id` int(11) unsigned NOT NULL,
  `department_id` int(11) unsigned NOT NULL,
  `degree_program` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `undergrad_institution` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `undergrad_gpa` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `graduate_institution` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `hispaniclatino_id` int(11) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` tinyint DEFAULT 1,

   #TODO add pivot table for race identity options

  PRIMARY KEY (`nomination_id`),

  UNIQUE KEY `selfnom_serial` (`id`),

  CONSTRAINT `selfnom_fk_nomination_id`
    FOREIGN KEY (`nomination_id`)
    REFERENCES `nomination` (`id`),
  
  CONSTRAINT `selfnom_fk_department_id`
    FOREIGN KEY (`department_id`)
    REFERENCES `department` (`id`),

  CONSTRAINT `selfnom_fk_hispaniclatino_id`
    FOREIGN KEY (`hispaniclatino_id`)
    REFERENCES `hispaniclatino` (`id`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

#selfnom_raceselfid
CREATE TABLE `selfnom_raceselfid` (
  
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `selfnom_id` int(11) unsigned NOT NULL,
  `raceselfid_id` int(11) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
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
      SET NEW.created_at = IFNULL(NEW.created_at, NOW());
      SET NEW.updated_at = IFNULL(NEW.updated_at, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `selfnom_raceselfid_on_update` BEFORE UPDATE ON `selfnom_raceselfid`
    FOR EACH ROW SET NEW.updated_at = NOW();























CREATE TABLE `nomination_awardoffer` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT, #Redundant, for RedBean use
  `nomination_id` int(11) unsigned NOT NULL, #Redundant, for RedBean use
  `awardoffer_id` int(11) unsigned NOT NULL, #Redundant, for RedBean use

  `nominee_id` int(11) unsigned NOT NULL,
  `awardcycle_id` int(11) unsigned NOT NULL,
  `nominationtype_id` int(11) unsigned NOT NULL,
  `awardprofile_id` int(11) unsigned NOT NULL,
  
  CONSTRAINT `nao_serial` PRIMARY KEY (`id`),

  #Use this as composite primary key.
  UNIQUE KEY `nao_one_profile_per_nominee_per_cycle` (
    `nominee_id`,
    `awardcycle_id`,
    `awardprofile_id`
  ),

  KEY `nao_nominee` (`nominee_id`),
  KEY `nao_awardcycle` (`awardcycle_id`),
  KEY `nao_nominationtype` (`nominationtype_id`),
  KEY `nao_awardprofile` (`awardprofile_id`),
  
  CONSTRAINT `nao_awardcycle_exists`
    FOREIGN KEY (`awardcycle_id`) REFERENCES `awardcycle` (`id`),
  CONSTRAINT `nao_awardprofile_exists`
    FOREIGN KEY (`awardprofile_id`) REFERENCES `awardprofile` (`id`),
  CONSTRAINT `nao_nominationtype_exists`
    FOREIGN KEY (`nominationtype_id`) REFERENCES `nominationtype` (`id`),
  CONSTRAINT `nao_nominee_exists`
    FOREIGN KEY (`nominee_id`) REFERENCES `user` (`id`),
  CONSTRAINT `nao_nomination_exists`
    FOREIGN KEY (`nomination_id`) REFERENCES `nomination` (`id`),
  CONSTRAINT `nao_awardoffer_exists`
    FOREIGN KEY (`awardoffer_id`) REFERENCES `awardoffer` (`id`),

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



DROP TABLE IF EXISTS `milestonetype`;
CREATE TABLE `milestonetype` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT, #Redundant, for RedBean use
  `slug` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `order` int(11) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  
  CONSTRAINT `milestonetype_serial` PRIMARY KEY (`id`),

  #Use this as primary key.
  UNIQUE KEY `milestonetype_unique_slug` (`slug`)

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `milestonetype_nominationtype`;
CREATE TABLE `milestonetype_nominationtype` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT, #Redundant, for RedBean use
  
  `milestonetype_slug` varchar(255) NOT NULL,
  `nominationtype_id` int(11) unsigned NOT NULL,
  
  `alt_name` varchar(255) DEFAULT NULL,
  
  CONSTRAINT `mstnt_serial` PRIMARY KEY (`id`),

  UNIQUE KEY `mstnt_unique_mstnt_pair` (`milestonetype_slug`,`nominationtype_id`),
  KEY `mstnt_milestonetype_slug` (`milestonetype_slug`),
  KEY `mstnt_nominationtype_id` (`nominationtype_id`),
  CONSTRAINT `mstnt_milestonetype_slug` FOREIGN KEY (`milestonetype_slug`) REFERENCES `milestonetype` (`slug`),
  CONSTRAINT `mstnt_nominationtype_id` FOREIGN KEY (`nominationtype_id`) REFERENCES `nominationtype` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `milestone`;
CREATE TABLE `milestone` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT, #Redundant, for RedBean use

  `milestonetype_slug` varchar(255) NOT NULL,
  `nominationtype_id` int(11) unsigned NOT NULL,
  `awardcycle_id` int(11) unsigned NOT NULL,
  
  `date` date NOT NULL,
  
  `deleted_at` datetime DEFAULT NULL,

  CONSTRAINT `milestone_serial` PRIMARY KEY (`id`),
  
  #Use this as composite primary key.
  #Any given nomination type can use a milestonetype once in the given award cycle.
  UNIQUE KEY `milestone_mstype_once_per_nomtype_per_cycle` (
    `milestonetype_slug`,
    `nominationtype_id`,
    `awardcycle_id`
  ),
    
  KEY `milestone_nominationtype` (`nominationtype_id`),
  KEY `milestone_milestonetype` (`milestonetype_slug`),
  KEY `milestone_awardcycle` (`awardcycle_id`),

  CONSTRAINT `milestone_awardcycle_exists` FOREIGN KEY (`awardcycle_id`) REFERENCES `awardcycle` (`id`),
  CONSTRAINT `milestone_milestonetype_slug` FOREIGN KEY (`milestonetype_slug`) REFERENCES `milestonetype` (`slug`),
  CONSTRAINT `milestone_nominationtype_exists` FOREIGN KEY (`nominationtype_id`) REFERENCES `nominationtype` (`id`),

  #The milestone type must be valid for the nomination type
  CONSTRAINT `ms_unique_mstnt_pair_exists`
    FOREIGN KEY (
      `milestonetype_slug`,
      `nominationtype_id`
    ) REFERENCES `milestonetype_nominationtype` (
      `milestonetype_slug`,
      `nominationtype_id`
    ),

  #The nomination type must be valid for the award cycle
  CONSTRAINT `ms_unique_acnt_pair_exists`
    FOREIGN KEY (
      `awardcycle_id`,
      `nominationtype_id`
    ) REFERENCES `awardcycle_nominationtype` (
      `awardcycle_id`,
      `nominationtype_id`
    )

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `upload`;
CREATE TABLE `upload` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `type` enum('application/pdf') NOT NULL,
  `size` int(11) NOT NULL,
  `content` mediumblob NOT NULL,

  CONSTRAINT `pdf_serial` PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
