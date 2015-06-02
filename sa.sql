CREATE TABLE `awardcycle_nominationtype` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT, #Redundant, for RedBean use
  
  `awardcycle_id` int(11) unsigned NOT NULL,
  `nominationtype_id` int(11) unsigned NOT NULL,
  
  CONSTRAINT `acnt_serial` PRIMARY KEY (`id`),

  #Use this as composite primary key. Any given award cycle can be paired with a nomination type zero or one times.
  UNIQUE KEY `acnt_unique_acnt_pair` (`awardcycle_id`,`nominationtype_id`), 
  
  KEY `acnt_nominationtype_id` (`nominationtype_id`),
  KEY `acnt_awardcycle_id` (`awardcycle_id`),
  
  CONSTRAINT `acnt_awardcycle_exists`
    FOREIGN KEY (`awardcycle_id`) REFERENCES `awardcycle` (`id`),
  CONSTRAINT `acnt_nominationtype_exists`
    FOREIGN KEY (`nominationtype_id`) REFERENCES `nominationtype` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE `awardoffer` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT, #Redundant, for RedBean use

  `awardcycle_id` int(11) unsigned NOT NULL,
  `nominationtype_id` int(11) unsigned NOT NULL,
  `awardprofile_id` int(11) unsigned NOT NULL,
  
  CONSTRAINT `awardoffer_serial` PRIMARY KEY (`id`),

  #Use this as composite primary key. Any given award profile can be offered during an award cycle zero or one times.
  UNIQUE KEY `awardoffer_offer_profile_once_per_cycle` (`awardcycle_id`,`awardprofile_id`),
  
  KEY `awardoffer_awardcycle_id` (`awardcycle_id`),
  KEY `awardoffer_nominationtype_id` (`nominationtype_id`),
  KEY `awardoffer_awardprofile_id` (`awardprofile_id`),

  KEY `ao_for_nao_awardoffer_exists_and_same_nomtype_and_cycle` (`awardcycle_id`,`nominationtype_id`,`awardprofile_id`),
  
  CONSTRAINT `awardoffer_awardcycle_exists` 
    FOREIGN KEY (`awardcycle_id`) REFERENCES `awardcycle` (`id`),
  CONSTRAINT `awardoffer_awardprofile_exists` 
    FOREIGN KEY (`awardprofile_id`) REFERENCES `awardprofile` (`id`),
  CONSTRAINT `awardoffer_nominationtype_exists` 
    FOREIGN KEY (`nominationtype_id`) REFERENCES `nominationtype` (`id`),

  #Award profiles can only be offered via a nomination type paired to the given award cycle.
  CONSTRAINT `awardoffer_unique_acnt_pair_exists`
    FOREIGN KEY (`awardcycle_id`, `nominationtype_id`) REFERENCES `awardcycle_nominationtype` (`awardcycle_id`, `nominationtype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `nomination` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT, #Redundant, for RedBean use

  `nominee_id` int(11) unsigned NOT NULL,
  `awardcycle_id` int(11) unsigned NOT NULL,
  `nominationtype_id` int(11) unsigned NOT NULL,
  `nominator_id` int(11) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,

  CONSTRAINT `nomination_serial` PRIMARY KEY (`id`),

  #Use this as composite primary key.
  #Any given given user can have zero or one nominations for each nomination type paired to the given award cycle.
  UNIQUE KEY `nomination_one_nom_per_user_per_nomtype_per_cycle` (
    `nominee_id`,
    `awardcycle_id`,
    `nominationtype_id`
  ),

  KEY `nomination_nominee` (`nominee_id`),
  KEY `nomination_awardcycle` (`awardcycle_id`),
  KEY `nomination_nominationtype` (`nominationtype_id`),
  
  CONSTRAINT `nomination_awardcycle_exists`
    FOREIGN KEY (`awardcycle_id`) REFERENCES `awardcycle` (`id`),
  CONSTRAINT `nomination_nominationtype_exists`
    FOREIGN KEY (`nominationtype_id`) REFERENCES `nominationtype` (`id`),
  CONSTRAINT `nomination_nominee_exists`
    FOREIGN KEY (`nominee_id`) REFERENCES `user` (`id`),
  CONSTRAINT `nomination_nominator_exists`
    FOREIGN KEY (`nominator_id`) REFERENCES `user` (`id`),
  #Nominations can only have a nomination type paired to the given award cycle.
  CONSTRAINT `nomination_unique_acnt_pair_exists`
    FOREIGN KEY (`awardcycle_id`, `nominationtype_id`) REFERENCES `awardcycle_nominationtype` (`awardcycle_id`, `nominationtype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `selfnom` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  
  `nomination_id` int(11) unsigned NOT NULL,

  `department_id` int(11) unsigned NOT NULL,
  `degree_program` varchar(100) NOT NULL,
  `undergrad_institution` varchar(255) NOT NULL,
  `undergrad_gpa` varchar(255) NOT NULL,
  `graduate_institution` varchar(255) DEFAULT NULL,
  `hispanic_latino_option_id` int(11) unsigned DEFAULT NULL,
  #TODO add pivot table for race identity options

  CONSTRAINT `selfnom_serial` PRIMARY KEY (`id`),

  CONSTRAINT `selfnom_nomination_exists`
    FOREIGN KEY (`nomination_id`) REFERENCES `nomination` (`id`),
  #CONSTRAINT `selfnom_department_exists` //TODO restore when deptartment table is added, hispanic_latino also
    #FOREIGN KEY (`department_id`) REFERENCES `department` (`id`),
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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

CREATE TABLE `nominationtype` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  
  `name` varchar(255) NOT NULL,
  `item_label` varchar(255) NOT NULL, #i.e., Nomination, Application, Selection
  `item_label_plural` varchar(255) DEFAULT NULL, #i.e., Nominations, Applications, Selections
  `max_offers_per_nomination` int(11) DEFAULT NULL
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,

  CONSTRAINT `nomtype_serial` PRIMARY KEY (`id`),

  UNIQUE KEY `nomtype_unique_name` (`name`),

) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELIMITER //#todo not working?
CREATE TRIGGER `nominationtype_on_insert` BEFORE INSERT ON `nominationtype`
    FOR EACH ROW BEGIN
      SET NEW.created_at = IFNULL(NEW.created_at, NOW());
      SET NEW.updated_at = IFNULL(NEW.updated_at, NOW());
    END//
DELIMITER ;

CREATE TRIGGER `nominationtype_on_update` BEFORE UPDATE ON `nominationtype`
    FOR EACH ROW SET NEW.updated_at = IFNULL(NEW.updated_at, NOW());

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