-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 03, 2025 at 06:43 AM
-- Server version: 8.4.3
-- PHP Version: 8.3.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `data_vhf`
--

-- --------------------------------------------------------

--
-- Table structure for table `alembic_version`
--

CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `alembic_version`
--

INSERT INTO `alembic_version` (`version_num`) VALUES
('61785a23818b');

-- --------------------------------------------------------

--
-- Table structure for table `ground_check`
--

CREATE TABLE `ground_check` (
  `id` int NOT NULL,
  `lokasi` varchar(50) NOT NULL,
  `tanggal` date NOT NULL,
  `teknisi` text,
  `catatan` text,
  `manager_tujuan` varchar(50) NOT NULL,
  `status` varchar(20) DEFAULT NULL,
  `manager` varchar(100) DEFAULT NULL,
  `barcode_path` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `ground_check`
--

INSERT INTO `ground_check` (`id`, `lokasi`, `tanggal`, `teknisi`, `catatan`, `manager_tujuan`, `status`, `manager`, `barcode_path`) VALUES
(2, 'AirNav Surabaya', '2025-08-26', 'TRIA SABDA U, YOURDAN CHRISTIAN P, DWIJA', 'Ground Check LLZ 26 Agustus 2025 - Mopiens 510, ISBY - 110.10 MHz, Jarak dari ANT : 300 M. Data pengukuran sisi 90 Hz dan 150 Hz telah sesuai spesifikasi.', 'Manager Teknik 2', 'Selesai', 'ANDI WIBOWO', 'barcode/m2.png'),
(3, 'AirNav Surabaya', '2025-08-02', 'ADITYA, RENDY, ELVITA, DWIJA', 'Ground Check LLZ 02 Agustus 2025 - Normac 7000B, ISBR - 110.10 MHz. Jarak dari ANT : 300 M. Pengukuran dilakukan pada sisi 90 Hz dan 150 Hz dengan hasil sesuai spesifikasi performa sistem.', 'Manager Teknik 5', 'Selesai', 'NETTY SEPTA C', 'barcode/m1.png'),
(4, 'AirNav Surabaya', '2025-09-03', 'MOCH.SYAMSUDIN, YOURDAN CHRISTIAN P, SAFIRA', 'Ground Check LLZ 03 September 2025 - Mopiens 510, ISBY - 110.10 MHz. Jarak dari ANT : 300 M. Pengukuran dilakukan pada sisi 90 Hz dan 150 Hz dengan hasil sesuai spesifikasi performa sistem.', 'Manager Teknik 1', 'Selesai', 'ADMIN', 'barcode/m1.png'),
(17, 'AirNav Surabaya', '2024-10-30', 'MOCH. ICHSAN, KHOIRUL M. A., TRIA S. U., AMIRZAN R. W.', '30 Oktober 2024\r\nNormac 7000B\r\nISBR - 110.10 MHz\r\n', 'Manager Teknik 5 ', 'Selesai', 'NETTY SEPTA C', 'barcode/m5.png');

-- --------------------------------------------------------

--
-- Table structure for table `ground_check_row`
--

CREATE TABLE `ground_check_row` (
  `id` int NOT NULL,
  `groundcheck_id` int NOT NULL,
  `freq` varchar(10) DEFAULT NULL,
  `jarak` float DEFAULT NULL,
  `degree` varchar(20) DEFAULT NULL,
  `tx1_ddm_persen` float DEFAULT NULL,
  `tx1_ddm_ua` float DEFAULT NULL,
  `tx1_sum` float DEFAULT NULL,
  `tx1_mod90` float DEFAULT NULL,
  `tx1_mod150` float DEFAULT NULL,
  `tx1_rf` float DEFAULT NULL,
  `tx2_ddm_persen` float DEFAULT NULL,
  `tx2_ddm_ua` float DEFAULT NULL,
  `tx2_sum` float DEFAULT NULL,
  `tx2_mod90` float DEFAULT NULL,
  `tx2_mod150` float DEFAULT NULL,
  `tx2_rf` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `ground_check_row`
--

INSERT INTO `ground_check_row` (`id`, `groundcheck_id`, `freq`, `jarak`, `degree`, `tx1_ddm_persen`, `tx1_ddm_ua`, `tx1_sum`, `tx1_mod90`, `tx1_mod150`, `tx1_rf`, `tx2_ddm_persen`, `tx2_ddm_ua`, `tx2_sum`, `tx2_mod90`, `tx2_mod150`, `tx2_rf`) VALUES
(290, 17, '90 Hz', 210.1, '35°', -37.19, -359.9, 42.23, 38.35, 4.64, -39.51, -36.88, -356.9, 39.76, 38.24, 1.1, -41.3),
(291, 17, '90 Hz', 173.2, '30°', -33, -319.4, 42.7, 37.9, 4.8, -64.9, -35.3, -341.61, 39.1, 37.2, 1.9, -60.9),
(292, 17, '90 Hz', 139.9, '25°', -36.1, -349.4, 42.6, 39.4, 3.3, -57.2, -39.1, -378.39, 39.7, 39.5, 0.3, -55.7),
(293, 17, '90 Hz', 109.2, '20°', -33.07, -320, 42.6, 37.8, 4.8, -54.5, -33.4, -323.23, 39.2, 37.6, 1.7, -54.4),
(294, 17, '90 Hz', 80.4, '15°', -27.6, -267.1, 42.1, 34.9, 7.2, -53.4, -31.6, -305.81, 39.1, 35.4, 3.7, -55.8),
(295, 17, '90 Hz', 52.9, '10°', -31.8, -307.7, 42.2, 37, 5.2, -53.5, -35.7, -345.48, 39.9, 37.4, 1.7, -53.8),
(296, 17, '90 Hz', 26.2, '5°', -40.9, -395.8, 41.8, 37.9, 4.9, -49.9, -40.6, -392.9, 41.6, 37.1, 4.4, -53.6),
(297, 17, '90 Hz', 9.7, '1.85°', -15.8, -152.9, 41, 28.4, 12.6, -43.7, -15.6, -150.97, 41.1, 28.4, 12.7, -50.4),
(298, 17, 'Center', 0, '0°', 0.08, 0.8, 40.9, 20.4, 20.5, -45.1, 0.19, 1.84, 40.9, 20.4, 20.6, -43.9),
(299, 17, '150 Hz', 9.7, '1.85°', 15.9, 153.9, 41, 12.5, 28.5, -43.9, 16.1, 155.81, 40.3, 12.6, 28.5, -45.7),
(300, 17, '150 Hz', 26.2, '5°', 40.7, 393.9, 42.3, 1.8, 39.6, -58, 40.3, 390, 39.2, 1.6, 42.3, -44.7),
(301, 17, '150 Hz', 52.9, '10°', 33.63, 325.5, 42.7, 4.6, 38.2, -54.2, 37.4, 361.94, 40.9, 0.9, 38.4, -54.8),
(302, 17, '150 Hz', 80.4, '15°', 31.5, 304.8, 42.7, 5.6, 37.2, -54.2, 33.1, 320.32, 39.5, 2.1, 37.3, -54.3),
(303, 17, '150 Hz', 109.2, '20°', 33.7, 326.1, 42.8, 4.6, 38.3, -55.9, 36.5, 353.23, 40.8, 1.4, 38, -54.5),
(304, 17, '150 Hz', 139.9, '25°', 37.2, 360, 42.9, 2.9, 40.1, -53.7, 39.5, 382.26, 39.4, 0.7, 40.2, -56),
(305, 17, '150 Hz', 173.2, '30°', 32.4, 313.5, 42, 5.2, 37.6, -50.6, 35.4, 342.58, 41, 2, 37.4, -53),
(306, 17, '150 Hz', 210.1, '35°', 33.7, 364.8, 42, 2.6, 40.3, -53.3, 39.36, 380.9, 41, 1.2, 40.5, -56.7),
(388, 2, '90 Hz', 210.1, '35°', -27.85, -269.5, 39.99, 33.92, 6.01, -49.15, -27.45, -265.65, 40.1, 33.69, 6.45, -49.59),
(389, 2, '90 Hz', 173.2, '30°', -25.75, -249.2, 39.99, 32.91, 7.01, -58.05, -26.6, -257.42, 40.09, 33.29, 6.7, -49.29),
(390, 2, '90 Hz', 139.9, '25°', -30.81, -298.2, 39.99, 35.66, 4.55, -45.35, -30.21, -292.35, 40.1, 35.13, 4.85, -47.31),
(391, 2, '90 Hz', 109.2, '20°', -30.62, -296.3, 39.98, 35.28, 4.7, -46.42, -29.55, -285.97, 40.1, 34.91, 5.2, -46.51),
(392, 2, '90 Hz', 80.4, '15°', -26.01, -251.7, 39.99, 33, 6.99, -43.17, -25.31, -244.94, 40.11, 32.71, 7.42, -43.67),
(393, 2, '90 Hz', 52.9, '10°', -24.93, -241.3, 39.99, 32.46, 7.53, -39.5, -24.49, -237, 40.1, 32.3, 7.81, -32.43),
(394, 2, '90 Hz', 26.2, '5°', -34.87, -337.5, 40.85, 37.86, 2.99, -32.92, -34.24, -331.35, 40.88, 37.56, 3.32, -32.42),
(395, 2, '90 Hz', 9.7, '1.85°', -15.93, -154.2, 40.91, 28.42, 12.49, -28.81, -15.92, -154.06, 40.96, 28.39, 12.57, -28.12),
(396, 2, 'Center', 0, '0°', -0.03, -0.3, 40.91, 20.48, 20.44, -28.01, 0.05, 0.48, 40.97, 20.44, 20.53, -27.69),
(397, 2, '150 Hz', 9.7, '1.85°', 15.78, 152.7, 40.9, 12.56, 28.34, -28.59, 15.45, 149.52, 40.98, 12.76, 28.22, -29.14),
(398, 2, '150 Hz', 26.2, '5°', 34.94, 338.1, 40.82, 2.94, 37.88, -32.99, 34.37, 332.61, 40.92, 3.28, 37.64, -32.95),
(399, 2, '150 Hz', 52.9, '10°', 24.79, 239.9, 40.02, 7.61, 32.41, -39.88, 24.12, 233.42, 39.99, 7.93, 32.05, -40.7),
(400, 2, '150 Hz', 80.4, '15°', 24.69, 238.9, 40.02, 7.67, 32.35, -42.5, 23.91, 231.39, 39.99, 8.04, 31.95, -41.91),
(401, 2, '150 Hz', 109.2, '20°', 29.14, 282, 40.01, 5.43, 34.57, -45.64, 28.57, 276.48, 40, 5.71, 34.29, -45.36),
(402, 2, '150 Hz', 139.9, '25°', 29.29, 283.5, 40.02, 5.41, 34.52, -44.22, 28.56, 276.39, 39.99, 5.63, 34.01, -43.73),
(403, 2, '150 Hz', 173.2, '30°', 29.7, 287.4, 40.01, 5.21, 34.61, -42.2, 27.22, 263.42, 40, 5.49, 33.52, -43.95),
(404, 2, '150 Hz', 210.1, '35°', 34.56, 334.5, 40.02, 2.88, 37.46, -48.11, 33.81, 327.19, 40.01, 3.01, 36.81, -50.4),
(405, 3, '90 Hz', 210.1, '35°', -27.87, -269.7, 39.99, 33.93, 6.06, -49.17, -27.3, -264.19, 40.12, 33.71, 6.14, -49.65),
(406, 3, '90 Hz', 173.2, '30°', -28.67, -276.9, 39.93, 34.12, 7.06, -48.7, -26.62, -263.27, 40.12, 33.42, 6.75, -49.32),
(407, 3, '90 Hz', 139.9, '25°', -30.93, -299.3, 39.96, 35.44, 4.53, -45.35, -30.32, -293.42, 40.16, 35.36, 4.89, -47.36),
(408, 3, '90 Hz', 109.9, '20°', -30.81, -298.9, 39.95, 35.28, 4.7, -46.45, -30.15, -291.67, 40.15, 35.27, 5.01, -46.58),
(409, 3, '90 Hz', 80.4, '15°', -26.01, -251.7, 39.93, 33.27, 6.79, -43.17, -25.59, -247.45, 40.48, 33.72, 7.38, -43.68),
(410, 3, '90 Hz', 52.9, '10°', -24.6, -238.9, 39.99, 32.57, 7.39, -38.41, -24.35, -236.06, 40.15, 32.67, 7.48, -38.52),
(411, 3, '90 Hz', 26.2, '5°', -34.93, -339.8, 40.9, 37.57, 2.53, -32.89, -34.45, -334.15, 40.93, 37.25, 2.79, -32.53),
(412, 3, '90 Hz', 9.7, '1.85°', -15.7, -151.9, 40.9, 28.3, 12.56, -28.62, -15.98, -154.65, 40.98, 28.3, 12.64, -28.18),
(413, 3, 'Center', 0, '0°', -0.03, -0.3, 40.91, 20.44, 20.46, -28.01, 0.05, 0.48, 40.97, 20.46, 20.54, -27.78),
(414, 3, '150 Hz', 9.7, '1.85°', 15.7, 151.9, 40.9, 12.56, 28.3, -28.62, 15.98, 154.65, 40.98, 12.64, 28.3, -28.18),
(415, 3, '150 Hz', 26.2, '5°', 24.67, 237.8, 40.01, 7.76, 32.3, -39.78, 23.99, 231.39, 40.1, 8.01, 32.09, -40.21),
(416, 3, '150 Hz', 52.9, '10°', 24.69, 238.7, 40.01, 7.76, 32.36, -39.78, 23.99, 231.39, 40.1, 8.01, 32.09, -40.21),
(417, 3, '150 Hz', 80.4, '15°', 24.67, 238.7, 40.02, 7.75, 32.32, -42.5, 23.99, 231.39, 40.1, 8, 32.06, -42.19),
(418, 3, '150 Hz', 109.9, '20°', 29.18, 282.4, 40.01, 5.42, 34.6, -45.65, 28.58, 276.16, 40.1, 5.71, 34.29, -45.35),
(419, 3, '150 Hz', 139.9, '25°', 29.18, 282.4, 40.01, 5.42, 34.6, -45.65, 28.58, 276.16, 40.1, 5.71, 34.29, -45.35),
(420, 3, '150 Hz', 173.2, '30°', 29.18, 282.4, 40.01, 5.42, 34.6, -45.65, 28.58, 276.16, 40.1, 5.71, 34.29, -45.35),
(421, 3, '150 Hz', 210.1, '35°', 34.55, 334.4, 40, 2.72, 37.27, -48.15, 33.79, 327.09, 39.96, 3.09, 36.86, -50.69),
(422, 4, '90 Hz', 210.1, '35°', -27.9, -270, 40, 33.9, 6.04, -49.16, -27.76, -268.65, 40.1, 33.86, 6.67, -49.74),
(423, 4, '90 Hz', 173.2, '30°', -25.7, -270, 39.98, 33.94, 6.79, -49.37, -26.24, -257.44, 40.12, 33.25, 6.79, -49.37),
(424, 4, '90 Hz', 139.9, '25°', -30.8, -298.5, 39.99, 35.75, 4.5, -45.3, -30.24, -292.65, 40.12, 35.11, 4.86, -48.36),
(425, 4, '90 Hz', 109.2, '20°', -30.3, -293.7, 40.02, 35.1, 4.84, -49.03, -30.06, -290.6, 40.13, 35.1, 5.02, -48.45),
(426, 4, '90 Hz', 80.4, '15°', -28.6, -281.9, 40, 33.9, 6.94, -45.17, -25.54, -247.16, 40.14, 32.84, 7.3, -44.87),
(427, 4, '90 Hz', 52.9, '10°', -24.8, -240.1, 39.96, 32.43, 7.56, -41.47, -24.66, -238.65, 40.11, 32.39, 7.73, -42.43),
(428, 4, '90 Hz', 26.2, '5°', -34.8, -341, 40, 37.84, 3.1, -35.41, -34.16, -330.58, 40.89, 37.52, 3.56, -35.54),
(429, 4, '90 Hz', 9.7, '1.85°', -15.9, -154, 40, 28.41, 12.09, -32.16, -15.39, -148.94, 40.96, 28.18, 12.79, -30.56),
(430, 4, 'Center', 0, '0°', 0, 0, 40, 20.4, 20.4, -31.26, 0, 0, 40, 20.47, 19.8, -31.85),
(431, 4, '150 Hz', 9.7, '1.85°', 15.8, 152.7, 40, 12.48, 28.49, -31.04, 15.53, 150.29, 40.2, 12.48, 28.26, -31.55),
(432, 4, '150 Hz', 26.2, '5°', 35.1, 337.5, 40, 3, 38, -31.26, 34.68, 334.65, 40.09, 3.18, 37.8, -35.21),
(433, 4, '150 Hz', 52.9, '10°', 24.9, 238.9, 40, 7.62, 32.44, -39.11, 24.26, 234.77, 40.07, 7.81, 32.15, -40.49),
(434, 4, '150 Hz', 80.4, '15°', 24.6, 236.8, 40, 7.54, 32.46, -42.79, 23.79, 230.23, 40.01, 8.11, 31.9, -42.41),
(435, 4, '150 Hz', 109.2, '20°', 29.6, 281.1, 40, 5.44, 34.39, -47.81, 28.56, 276.39, 40.09, 5.72, 34.29, -48.12),
(436, 4, '150 Hz', 139.9, '25°', 29.3, 283.4, 40, 5.44, 34.33, -47.64, 28.28, 273.68, 39.98, 5.67, 34.28, -44.21),
(437, 4, '150 Hz', 173.2, '30°', 29.8, 288.2, 40, 5.22, 34.36, -48.51, 28.53, 273.63, 40.01, 5.39, 33.22, -43.82),
(438, 4, '150 Hz', 210.1, '35°', 33, 316.9, 40.02, 2.92, 37.4, -48.02, 33.53, 324.48, 40.02, 3.23, 36.65, -49.62);

-- --------------------------------------------------------

--
-- Table structure for table `station`
--

CREATE TABLE `station` (
  `id` int NOT NULL,
  `nama_stasiun` varchar(100) NOT NULL,
  `frekuensi` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `station`
--

INSERT INTO `station` (`id`, `nama_stasiun`, `frekuensi`) VALUES
(1, 'KKJ', '678'),
(2, 'KKJ', '678'),
(3, 'gp', '110');

-- --------------------------------------------------------

--
-- Table structure for table `station_dme`
--

CREATE TABLE `station_dme` (
  `id` int NOT NULL,
  `nama_stasiun_dme` varchar(100) NOT NULL,
  `frekuensi_dme` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `station_dvor`
--

CREATE TABLE `station_dvor` (
  `id` int NOT NULL,
  `nama_stasiun_dvor` varchar(100) NOT NULL,
  `frekuensi_dvor` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `station_dvor`
--

INSERT INTO `station_dvor` (`id`, `nama_stasiun_dvor`, `frekuensi_dvor`) VALUES
(1, 'qq', '113'),
(2, 'qq', '13'),
(3, 'qq', '120');

-- --------------------------------------------------------

--
-- Table structure for table `station_ils`
--

CREATE TABLE `station_ils` (
  `id` int NOT NULL,
  `lokasi_stasiun_ils` varchar(50) NOT NULL,
  `tanggal` date NOT NULL,
  `pic` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `station_radar`
--

CREATE TABLE `station_radar` (
  `id` int NOT NULL,
  `nama_stasiun_radar` varchar(100) NOT NULL,
  `frekuensi_radar` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `station_radar`
--

INSERT INTO `station_radar` (`id`, `nama_stasiun_radar`, `frekuensi_radar`) VALUES
(1, 'HUFBUV', '567');

-- --------------------------------------------------------

--
-- Table structure for table `transmission`
--

CREATE TABLE `transmission` (
  `id` int NOT NULL,
  `station_id` int NOT NULL,
  `tx1_power` float DEFAULT NULL,
  `tx1_swr` varchar(20) DEFAULT NULL,
  `tx1_mod` float DEFAULT NULL,
  `tx2_power` float DEFAULT NULL,
  `tx2_swr` varchar(20) DEFAULT NULL,
  `tx2_mod` float DEFAULT NULL,
  `tanggal` date NOT NULL,
  `pic` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transmissions_gp`
--

CREATE TABLE `transmissions_gp` (
  `id` int NOT NULL,
  `station_ils_id` int DEFAULT NULL,
  `csb_power` float DEFAULT NULL,
  `sbo_power` float DEFAULT NULL,
  `sdm_80` float DEFAULT NULL,
  `course_ddm` float DEFAULT NULL,
  `ds_ddm` float DEFAULT NULL,
  `clr_ddm` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transmissions_localizer`
--

CREATE TABLE `transmissions_localizer` (
  `id` int NOT NULL,
  `station_ils_id` int DEFAULT NULL,
  `csb_power` float DEFAULT NULL,
  `sbo_power` float DEFAULT NULL,
  `sdm_40` float DEFAULT NULL,
  `course_ddm` float DEFAULT NULL,
  `ds_ddm` float DEFAULT NULL,
  `clr_ddm` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transmissions_tdme`
--

CREATE TABLE `transmissions_tdme` (
  `id` int NOT NULL,
  `station_ils_id` int DEFAULT NULL,
  `tx1_power` float DEFAULT NULL,
  `spacing1` varchar(20) DEFAULT NULL,
  `delay1` varchar(20) DEFAULT NULL,
  `tx2_power` float DEFAULT NULL,
  `spacing2` varchar(20) DEFAULT NULL,
  `delay2` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transmission_dme`
--

CREATE TABLE `transmission_dme` (
  `id` int NOT NULL,
  `station_dme_id` int NOT NULL,
  `tx1_power` float DEFAULT NULL,
  `tx1_spacing` float DEFAULT NULL,
  `tx1_delay` float DEFAULT NULL,
  `tx2_power` float DEFAULT NULL,
  `tx2_spacing` float DEFAULT NULL,
  `tx2_delay` float DEFAULT NULL,
  `tanggal` date NOT NULL,
  `pic` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transmission_dvor`
--

CREATE TABLE `transmission_dvor` (
  `id` int NOT NULL,
  `station_dvor_id` int NOT NULL,
  `tx1_power` float DEFAULT NULL,
  `tx1_bearing` float DEFAULT NULL,
  `tx1_modulasi` float DEFAULT NULL,
  `tx2_power` float DEFAULT NULL,
  `tx2_bearing` float DEFAULT NULL,
  `tx2_modulasi` float DEFAULT NULL,
  `tanggal` date NOT NULL,
  `pic` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `transmission_dvor`
--

INSERT INTO `transmission_dvor` (`id`, `station_dvor_id`, `tx1_power`, `tx1_bearing`, `tx1_modulasi`, `tx2_power`, `tx2_bearing`, `tx2_modulasi`, `tanggal`, `pic`) VALUES
(1, 1, 11, -0.06, 7, 9, -0.07, 9, '2025-08-21', 'husni'),
(2, 1, 90, 40, 50, 80, 40, 50, '2025-10-03', 'netty');

-- --------------------------------------------------------

--
-- Table structure for table `transmission_radar`
--

CREATE TABLE `transmission_radar` (
  `id` int NOT NULL,
  `station_radar_id` int NOT NULL,
  `power_forward` float DEFAULT NULL,
  `azimuth_ilan` float DEFAULT NULL,
  `power_reflected` float DEFAULT NULL,
  `integration_mod_a` float DEFAULT NULL,
  `integration_mod_c` float DEFAULT NULL,
  `mod_s_p1` float DEFAULT NULL,
  `mod_s_p2` float DEFAULT NULL,
  `mod_s_pg` float DEFAULT NULL,
  `tanggal` date NOT NULL,
  `pic` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `transmission_radar`
--

INSERT INTO `transmission_radar` (`id`, `station_radar_id`, `power_forward`, `azimuth_ilan`, `power_reflected`, `integration_mod_a`, `integration_mod_c`, `mod_s_p1`, `mod_s_p2`, `mod_s_pg`, `tanggal`, `pic`) VALUES
(1, 1, 13, 9, 9, 6, 7, 7, 8, 8, '2025-08-21', 'HHH');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int NOT NULL,
  `username` varchar(150) NOT NULL,
  `password` varchar(200) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `email` varchar(120) DEFAULT NULL,
  `nip` varchar(50) DEFAULT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `jenis_kelamin` varchar(20) DEFAULT NULL,
  `jabatan` varchar(50) DEFAULT NULL,
  `lokasi_penempatan` varchar(100) DEFAULT NULL,
  `photo_path` varchar(255) DEFAULT NULL,
  `role` varchar(50) NOT NULL DEFAULT 'teknisi'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `password`, `nama`, `email`, `nip`, `no_hp`, `tanggal_lahir`, `jenis_kelamin`, `jabatan`, `lokasi_penempatan`, `photo_path`, `role`) VALUES
(1, 'admin', 'scrypt:32768:8:1$0Mecb2cX6nf5aeBk$f45ae136aba75a6d84ac51318d50b8034d897e8f181909b5df6cdc2ae5ae6dc31cd5168f24e66da9c5a71be493f8b97d7e1f20235703ae695b917c3b5a0fda97', 'Husni', 'husnisyamsi8@gmail.com', 'None', 'None', '2000-08-14', 'Laki-laki', 'Manager', '', 'uploads/profile/18E3DD4C-1779-45CF-8259-6CC140E1F193.jpeg', 'admin'),
(2, 'husni', 'scrypt:32768:8:1$V3KiHmGLb8vbBylu$00a2c267c1c53ff9218fdaff27cb9f04f7dec56babfbaf4781fe443be299b7cd7dd76c992f7535e6b18b735604d68fd8b5cdf5498c79cd9c4eeb3650b232a568', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'teknisi'),
(3, 'fifi', 'scrypt:32768:8:1$Ziwi5dRHMEQ1lLZr$2e6cdbc56978f3bf91f04fbfcb96e5b91789b95b65ef2b46c1dd33260bbb099d9342103cc2564892510fb2e621e3735b5363bcadcb638a0fb2eeaa68ddc58fb4', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'teknisi'),
(4, 'Andi Wibowo', 'scrypt:32768:8:1$q2A5KVDMVVZ7tU6e$a529dd2e4255df388aa861252272ec72bf81b00fc7bca2aac4350df177b9922435c525b7821d4d40e8aa48a0dfda9c38a91a4fb6258004e07d2132beeab47964', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'teknisi'),
(6, 'Efried N.P', 'scrypt:32768:8:1$inO6fBYKDMJuFB2X$8c7da44999ce76c4ce2a6f83de2f74304a56cf5b7897c1f1aee99fa224464ab5ec5a9a3d264d3ba946fdcf98e354ba8273f20a6d5754ffcab039f1ef80ebd004', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'teknisi'),
(9, 'andin', 'scrypt:32768:8:1$i3MUbNQXWOnk8m6l$f0cc8443d77b24c06dbf2af3b1c553d5f758ca245ce71b2ab1180bcae2179dbdf89e38e3530408ad73519016b95dd1ac69115874a107a2f79124f12979eb0474', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'teknisi'),
(10, 'Netty Septa C', 'scrypt:32768:8:1$gQennaC7tXVs1qrA$fa877dc9c14a5eea6ccc94f37664618a0a4c95fd71a4122c4026ef2e618ef248ebe6579673a0fc0311a0300960c330b27f14a955fae1b8ee8437ad0e8b0c8679', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'teknisi'),
(12, 'Moch Ichsan', 'scrypt:32768:8:1$Vr39LfT9H4OvNwbK$f78094d7af467e223436b432098663a02a98271c39ca03b22268f9f14dcede5f13c56e04b7c1225f7cd79912fbe4b8ccec61edf77ce8660ae646cab3d2fbaf6a', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'teknisi'),
(13, 'sela', 'scrypt:32768:8:1$H2rzMvaRFbei5EHs$fcfc83a396d951e0b9090fad11a2a6b3a7f9802cff1196db5306cf1536a058d8765968384323a8cce54574c8330a6da1199a67c7191ddf250151192d012a9730', 'sela', 'sela@gmail.com', '1000986623805', '1989202093', '2025-09-11', 'Perempuan', 'Manager', NULL, NULL, 'teknisi'),
(14, 'dev', 'scrypt:32768:8:1$tSljNhydTK34mBlB$4c98593ce0a6eebc7e7449adf3a3e157d7da003c4d131fffd5df24d0aeb7a3ed8487781778ee7acf3eebb41cc20e4fa1aa89b6ee142606c64fa8cfcb0abb2323', 'None', 'devandasyaputra99@gmail.com', '69', 'None', '2025-09-15', 'Laki-laki', '', NULL, 'uploads/profile/IMG_2332.jpeg', 'teknisi'),
(32, 'managerteknik1', 'scrypt:32768:8:1$gH4FMYoNlXQDxnn9$03a636471ba115a5879ec34ab71e72e4c78702e30edf7c5fd10e098913764db20c1222ada7fa0f51b03cda71bbbd41daaf4ead4f9f5a0b7875a91ad9acf8c1ea', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Manager Teknik 1'),
(33, 'managerteknik2', 'scrypt:32768:8:1$YgY9qTMwStokCSTZ$b25db8f19f7ae771a8fa8238a19f1f229f6d169af44326c527dfb587a057f2c8df348f7ba4c69055e213436366f864a4e8c973c8bdfedf607e0ac1129b97cffa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Manager Teknik 2'),
(34, 'managerteknik3', 'scrypt:32768:8:1$FFociQf8bTLXKZbR$9a6a56526afa97a56e4f12670434f114420fe6f0386481f7175b015ccd324eece3145176e46d53a71c083606a2ddd6d2f0512d5042722298c0dbf37ce24d5811', 'None', NULL, 'None', 'None', NULL, 'Laki-laki', '', NULL, NULL, 'Manager Teknik 3'),
(35, 'managerteknik4', 'scrypt:32768:8:1$wwzo6tdqiWLtG2KN$bd2d1927b2bdace47caa141139d9587899961c9ee8b415eb320ccdd9b2fbe31022c5bc0759ce446d576ce430b00269220ecfd412e80375413168e2cddee8d8ca', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Manager Teknik 4'),
(36, 'managerteknik5', 'scrypt:32768:8:1$MgJ7V0c1KlpYHuhQ$03cd7fb816052a9574f554cefd1d126a0e49ffb8c55243de9712864b1ef78d4c682e7d60af3e3438d1c66e5224fa457d6a4a5b23c6624391320377733639bb53', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Manager Teknik 5');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alembic_version`
--
ALTER TABLE `alembic_version`
  ADD PRIMARY KEY (`version_num`);

--
-- Indexes for table `ground_check`
--
ALTER TABLE `ground_check`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ground_check_row`
--
ALTER TABLE `ground_check_row`
  ADD PRIMARY KEY (`id`),
  ADD KEY `groundcheck_id` (`groundcheck_id`);

--
-- Indexes for table `station`
--
ALTER TABLE `station`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `station_dme`
--
ALTER TABLE `station_dme`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `station_dvor`
--
ALTER TABLE `station_dvor`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `station_ils`
--
ALTER TABLE `station_ils`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `station_radar`
--
ALTER TABLE `station_radar`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transmission`
--
ALTER TABLE `transmission`
  ADD PRIMARY KEY (`id`),
  ADD KEY `station_id` (`station_id`);

--
-- Indexes for table `transmissions_gp`
--
ALTER TABLE `transmissions_gp`
  ADD PRIMARY KEY (`id`),
  ADD KEY `station_ils_id` (`station_ils_id`);

--
-- Indexes for table `transmissions_localizer`
--
ALTER TABLE `transmissions_localizer`
  ADD PRIMARY KEY (`id`),
  ADD KEY `station_ils_id` (`station_ils_id`);

--
-- Indexes for table `transmissions_tdme`
--
ALTER TABLE `transmissions_tdme`
  ADD PRIMARY KEY (`id`),
  ADD KEY `station_ils_id` (`station_ils_id`);

--
-- Indexes for table `transmission_dme`
--
ALTER TABLE `transmission_dme`
  ADD PRIMARY KEY (`id`),
  ADD KEY `station_dme_id` (`station_dme_id`);

--
-- Indexes for table `transmission_dvor`
--
ALTER TABLE `transmission_dvor`
  ADD PRIMARY KEY (`id`),
  ADD KEY `station_dvor_id` (`station_dvor_id`);

--
-- Indexes for table `transmission_radar`
--
ALTER TABLE `transmission_radar`
  ADD PRIMARY KEY (`id`),
  ADD KEY `station_radar_id` (`station_radar_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ground_check`
--
ALTER TABLE `ground_check`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `ground_check_row`
--
ALTER TABLE `ground_check_row`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=456;

--
-- AUTO_INCREMENT for table `station`
--
ALTER TABLE `station`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `station_dme`
--
ALTER TABLE `station_dme`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `station_dvor`
--
ALTER TABLE `station_dvor`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `station_ils`
--
ALTER TABLE `station_ils`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `station_radar`
--
ALTER TABLE `station_radar`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `transmission`
--
ALTER TABLE `transmission`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transmissions_gp`
--
ALTER TABLE `transmissions_gp`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transmissions_localizer`
--
ALTER TABLE `transmissions_localizer`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transmissions_tdme`
--
ALTER TABLE `transmissions_tdme`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transmission_dme`
--
ALTER TABLE `transmission_dme`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transmission_dvor`
--
ALTER TABLE `transmission_dvor`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `transmission_radar`
--
ALTER TABLE `transmission_radar`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `ground_check_row`
--
ALTER TABLE `ground_check_row`
  ADD CONSTRAINT `ground_check_row_ibfk_1` FOREIGN KEY (`groundcheck_id`) REFERENCES `ground_check` (`id`);

--
-- Constraints for table `transmission`
--
ALTER TABLE `transmission`
  ADD CONSTRAINT `transmission_ibfk_1` FOREIGN KEY (`station_id`) REFERENCES `station` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transmissions_gp`
--
ALTER TABLE `transmissions_gp`
  ADD CONSTRAINT `transmissions_gp_ibfk_1` FOREIGN KEY (`station_ils_id`) REFERENCES `station_ils` (`id`);

--
-- Constraints for table `transmissions_localizer`
--
ALTER TABLE `transmissions_localizer`
  ADD CONSTRAINT `transmissions_localizer_ibfk_1` FOREIGN KEY (`station_ils_id`) REFERENCES `station_ils` (`id`);

--
-- Constraints for table `transmissions_tdme`
--
ALTER TABLE `transmissions_tdme`
  ADD CONSTRAINT `transmissions_tdme_ibfk_1` FOREIGN KEY (`station_ils_id`) REFERENCES `station_ils` (`id`);

--
-- Constraints for table `transmission_dme`
--
ALTER TABLE `transmission_dme`
  ADD CONSTRAINT `transmission_dme_ibfk_1` FOREIGN KEY (`station_dme_id`) REFERENCES `station_dme` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transmission_dvor`
--
ALTER TABLE `transmission_dvor`
  ADD CONSTRAINT `transmission_dvor_ibfk_1` FOREIGN KEY (`station_dvor_id`) REFERENCES `station_dvor` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transmission_radar`
--
ALTER TABLE `transmission_radar`
  ADD CONSTRAINT `transmission_radar_ibfk_1` FOREIGN KEY (`station_radar_id`) REFERENCES `station_radar` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
