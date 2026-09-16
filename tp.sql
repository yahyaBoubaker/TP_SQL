-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : mer. 16 sep. 2026 à 21:28
-- Version du serveur : 12.2.2-MariaDB
-- Version de PHP : 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `tp`
--

-- --------------------------------------------------------

--
-- Structure de la table `client`
--

DROP TABLE IF EXISTS `client`;
CREATE TABLE IF NOT EXISTS `client` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `telephone` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Déchargement des données de la table `client`
--

INSERT INTO `client` (`id`, `nom`, `email`, `telephone`) VALUES
(1, 'Mounir Prof', 'mounir.prof@mail.com', '0611111111'),
(2, 'Steph Mon Gars', 'steph.mongars@mail.com', '0622222222'),
(3, 'Yahya Le Goat', 'yahya.legoat@mail.com', '0633333333'),
(4, 'Yanis', 'yanis@mail.com', '0644444444'),
(5, 'Leo', 'leo@mail.com', '0655555555'),
(6, 'Alternant', 'alternant@mail.com', '0666666666');

-- --------------------------------------------------------

--
-- Structure de la table `location`
--

DROP TABLE IF EXISTS `location`;
CREATE TABLE IF NOT EXISTS `location` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `voiture_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `date_location` date NOT NULL,
  `date_retour` date NOT NULL,
  `prix_total` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `client_id` (`client_id`),
  KEY `fk_voiture` (`voiture_id`)
) ;

--
-- Déchargement des données de la table `location`
--

INSERT INTO `location` (`id`, `voiture_id`, `client_id`, `date_location`, `date_retour`, `prix_total`) VALUES
(2, 3, 1, '2026-08-01', '2026-10-15', 6000.00),
(3, 5, 2, '2024-03-10', '2024-03-12', 60.00),
(5, 5, 2, '2026-08-01', '2026-10-15', 10000.00),
(6, 12, 3, '2026-08-01', '2027-10-15', 25000.00),
(7, 11, 6, '2026-08-01', '2027-10-15', 9999.00),
(8, 13, 4, '2023-08-01', '2024-10-15', 45.00),
(9, 4, 4, '2025-08-01', '2026-10-15', 465453.00);

--
-- Déclencheurs `location`
--
DROP TRIGGER IF EXISTS `avant_location_voiture`;
DELIMITER $$
CREATE TRIGGER `avant_location_voiture` BEFORE INSERT ON `location` FOR EACH ROW BEGIN
    DECLARE dispo INT;

    SELECT disponibilite INTO dispo
    FROM voiture
    WHERE id = NEW.voiture_id;

    IF dispo = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cette voiture n est pas disponible';
    END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `avant_nouvelle_location`;
DELIMITER $$
CREATE TRIGGER `avant_nouvelle_location` BEFORE INSERT ON `location` FOR EACH ROW BEGIN
    DECLARE nb_locations_en_cours INT;

    SELECT COUNT(*) INTO nb_locations_en_cours
    FROM location
    WHERE client_id = NEW.client_id
      AND date_retour >= CURDATE();

    IF nb_locations_en_cours > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ce client a deja une location en cours';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `voiture`
--

DROP TABLE IF EXISTS `voiture`;
CREATE TABLE IF NOT EXISTS `voiture` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `marque` varchar(50) NOT NULL,
  `modele` varchar(50) NOT NULL,
  `annee` int(11) NOT NULL,
  `kilometrage` int(11) NOT NULL DEFAULT 0,
  `couleur` varchar(30) DEFAULT NULL,
  `prix_achat` decimal(10,2) NOT NULL,
  `prix_location_jour` decimal(8,2) NOT NULL,
  `disponibilite` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Déchargement des données de la table `voiture`
--

INSERT INTO `voiture` (`id`, `marque`, `modele`, `annee`, `kilometrage`, `couleur`, `prix_achat`, `prix_location_jour`, `disponibilite`) VALUES
(3, 'Lamborghini', 'Gallardo', 2010, 20500, 'bleu', 150000.00, 551.10, 1),
(4, 'Bajaj', 'TookTouk', 2015, 5000, 'Vert', 3000.00, 22.00, 1),
(5, 'NoName', 'Voiture15', 2020, 10000, 'Gris', 10000.00, 33.00, 1),
(7, 'Renault', 'Clio tunée', 2016, 60000, 'Rouge', 9000.00, 38.50, 1),
(9, 'Peugeot', '208 rayée', 2018, 45000, 'Noir', 11000.00, 35.20, 1),
(10, 'Renault', 'Kangoo du plombier', 2012, 180000, 'Blanc', 6000.00, 27.50, 1),
(11, 'Smart', 'Smart écrabouillée', 2009, 90000, 'Orange', 3500.00, 19.80, 0),
(12, 'Toyota', 'Hilux increvable', 2005, 9999, 'Gris', 15000.00, 49.50, 1),
(13, 'Dacia', 'Logan fatiguée', 2011, 200000, 'Beige', 4000.00, 22.00, 1);

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `location`
--
ALTER TABLE `location`
  ADD CONSTRAINT `2` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`),
  ADD CONSTRAINT `fk_voiture` FOREIGN KEY (`voiture_id`) REFERENCES `voiture` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
