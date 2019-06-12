-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 10, 2019 at 04:49 AM
-- Server version: 10.1.36-MariaDB
-- PHP Version: 7.2.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `py_con`
--

-- --------------------------------------------------------

--
-- Table structure for table `buys`
--

CREATE TABLE `buys` (
  `buys_id` int(11) NOT NULL,
  `bill_id` int(11) NOT NULL,
  `sell_id` int(11) NOT NULL,
  `date_buy` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `username` varchar(10) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT 'ผู้ซื้อ',
  `number_buy` int(11) NOT NULL,
  `buys_status` varchar(2) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'R' COMMENT 'R=จอง B=ซื้อ',
  `buys_address` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `buys_expired_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `buys`
--

INSERT INTO `buys` (`buys_id`, `bill_id`, `sell_id`, `date_buy`, `username`, `number_buy`, `buys_status`, `buys_address`, `buys_expired_date`) VALUES
(91, 1, 14, '2019-06-01 08:40:44', 'rain', 1, 'B', '36 ซอย แสนสบาย6 ถ.บ้านบึงแกลง\nตำบล บ้านบึง อำเภอ บ้านบึง จ.ชลบุรี', '2019-06-06 15:40:23'),
(96, 2, 23, '2019-06-05 02:35:04', 'admin', 1, 'B', 'บ้านบึง', '2019-06-09 09:03:19'),
(97, 2, 14, '2019-06-05 02:35:04', 'admin', 2, 'B', 'บ้านบึง', '2019-06-10 09:34:44'),
(98, 3, 14, '2019-06-05 02:36:44', 'admin', 1, 'B', 'บ้านบึง', '2019-06-10 09:35:37'),
(99, 3, 15, '2019-06-05 02:36:44', 'admin', 1, 'B', 'บ้านบึง', '2019-06-10 09:35:44'),
(105, 4, 13, '2019-06-05 10:35:36', 'admin', 1, 'B', 'บ้านบึง', '2019-06-10 17:35:22'),
(107, 5, 17, '2019-06-07 04:06:06', 'KK', 1, 'B', '134 phuket', '2019-06-12 11:05:13');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `cat_id` int(11) NOT NULL,
  `cat_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `cat_icon` varchar(500) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`cat_id`, `cat_name`, `cat_icon`) VALUES
(1, 'มือถือ แท็บแล็ต', 'ec204cf5-8110-4dcb-9d5d-a4ccd9d7cd74.jpg'),
(2, 'คอมพิวเตอร์', '2.png'),
(3, 'เครื่องดนตรี', '3.png'),
(4, 'กีฬา', '4.png'),
(5, 'จักรยาน', '5.png'),
(6, 'แม่และเด็ก', '6.png'),
(7, 'กระเป๋า', '7.png'),
(8, 'นาฬิกา', '8.jpg'),
(9, 'รองเท้า', '9.png'),
(10, 'เสื้อผ้า เครื่องแต่งกาย', '10.png'),
(11, 'สุขภาพและความงาม', '11.png'),
(12, 'บ้านและสวน', '12.png'),
(13, 'พระเครื่อง', '13.jpg'),
(14, 'ของสะสม', '14.gif'),
(15, 'อสังหาิมทรัพย์', '15.png'),
(16, 'รถมือสอง', '16.png'),
(17, 'รถบรรทุก และเครื่องจักรกล', '17.png'),
(18, 'ยานพาหนะอื่นๆ', '18.png'),
(19, 'อะไหล่รถ ประดับยนต์', '19.png'),
(20, 'มอเตอร์ไซค์', '20.png'),
(21, 'กล้อง', '21.png'),
(22, 'เครื่องใช้ไฟฟ้า', '22.png'),
(23, 'เกม', '23.png'),
(24, 'สัตว์เลี้ยง', '24.png'),
(25, 'งานอดิเรก', '25_5.gif'),
(26, 'ธุรกิจ', '26.jpg'),
(27, 'บริการ', '27.png'),
(28, 'ฟาร์ม', '28.png'),
(29, 'ท่องเที่ยว', '29.jpg'),
(30, 'การศึกษา', '30.png'),
(31, 'บริจาค', '31.png');

-- --------------------------------------------------------

--
-- Table structure for table `groups`
--

CREATE TABLE `groups` (
  `groups_id` int(11) NOT NULL,
  `groups_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `cat_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `groups`
--

INSERT INTO `groups` (`groups_id`, `groups_name`, `cat_id`) VALUES
(1, 'แท็บแล็ต', 1),
(2, 'โทรศัพท์', 1),
(3, 'อุปกรณ์สื่อสาร', 1),
(4, 'กีต้าร์', 3),
(5, 'อคูลเลเล่', 3),
(6, 'คอมพิวเตอร์ตั้งโต๊ะ', 2),
(7, 'โน๊ตบุ๊ค', 2),
(8, 'Printer Scanner', 2),
(9, 'อุปกรณ์คอมพิวเตอร์อื่นๆ', 2),
(10, 'กีต้าร์ไฟฟ้า', 3),
(11, 'อุตสาหกรรม', 26),
(12, 'แฟรนไชส์', 26),
(13, 'อุปกรณ์ร้านอาหาร', 26),
(14, 'ขายเซ้งกิจการ', 26),
(15, 'ธุรกิจอื่นๆ', 27),
(16, 'อุปกรณ์สำนักงาน', 27),
(17, 'งาน', 27),
(18, 'จักรยานเสือหมอบ', 5),
(19, 'จักรยานเสือภูเขา', 5),
(20, 'เปียโน', 3),
(21, 'คีย์บอร์ด', 3),
(22, 'กลอง', 3),
(23, 'เครื่องดนตรีไทย', 3),
(24, 'เครื่องดนตรีอื่นๆ', 3),
(25, 'อุปกรณ์เครื่องดนตรี', 3),
(26, 'เครื่องออกกำลังกาย', 4),
(27, 'อุปกรณ์กีฬา', 4),
(28, 'ชุดกีฬา', 4),
(29, 'รองเท้ากีฬา', 4),
(30, 'จักรยานไฮบริด', 5),
(31, 'จักรยานฟิกเกียร์', 5),
(32, 'จักรยานฺBMX', 5),
(33, 'จักรยานทัวร์ริ่ง', 5),
(34, 'จักรยานพับ', 5),
(35, 'จักรยานแม่บ้าน', 5),
(36, 'จักรยานโบราณ', 5),
(37, 'จักรยานไฟฟ้า', 5),
(38, 'จักรยานอื่นๆ', 5),
(39, 'อุปกรณ์นักปั่น', 5),
(40, 'อะไหล่ และอุปกรณ์ตกแต่ง', 5),
(41, 'เสื้อผ้าเด็ก', 6),
(42, 'รองเท้าเด็ก', 6),
(43, 'เสื้อผ้าคนท้อง', 6),
(44, 'ของใช้แม่และเด็ก', 6),
(45, 'ของเล่นเด็ก', 6),
(46, 'กระเป๋าสะพาย', 7),
(47, 'กระเป๋าถือ', 7),
(48, 'กระเป๋าสตางค์', 7),
(49, 'กระเป๋าเป้ เดินทาง', 7),
(50, 'กระเป๋าอื่นๆ', 7),
(51, 'อุปกรณ์และอะไหล่กระเป๋า', 7),
(52, 'นาฬิกาผู้หญิง', 8),
(53, 'นาฬิกาผู้ชาย', 8),
(54, 'นาฬิกาอื่นๆ', 8),
(55, 'อุปกรณ์และอะไหล่นาฬิกา', 8),
(56, 'รองเท้าผู้ชาย', 9),
(57, 'รองเท้าผู้หญิง', 9),
(58, 'อุปกรณ์และอะไหล่รองเท้า', 9),
(59, 'เสื้อผ้า', 10),
(60, 'เครื่องแต่งกาย', 10),
(61, 'แว่นตา', 10),
(62, 'เครื่องประดับ', 10),
(66, 'เฟอร์นิเจอร์', 12),
(67, 'ของใช้ในบ้าน', 12),
(68, 'ของแต่งบ้าน', 12),
(69, 'วัสดุก่อสร้าง', 12),
(70, 'ตกแต่งสวน', 12),
(71, 'อุปกรณ์และเครื่องมือช่าง', 12),
(72, 'พระเหรียญ', 13),
(73, 'พระเบญจภาคี', 13),
(74, 'พระกริ่ง', 13),
(75, 'พระกรุ', 13),
(76, 'พระบูชา', 13),
(77, 'พระเกจิ', 13),
(78, 'พระปิตตา', 13),
(79, 'จคุคามรามเทพ', 13),
(80, 'พระปิดตา', 13),
(81, 'พระเครื่องอื่น', 13),
(82, 'เครื่องราง ของมงคล', 13),
(83, 'สังฆภัณฑ์ งานพิธี', 13),
(84, 'สแตมป์', 14),
(85, 'เหรียญ ธนบัตร', 14),
(86, 'ของเก่า ของโบราณ', 14),
(87, 'งานศิลปะ โมเดล', 14),
(88, 'ของสะสมอื่นๆ', 14),
(89, 'บ้าน', 15),
(90, 'ทาวเฮ้าส์', 15),
(91, 'คอนโดมิเนียม', 15),
(92, 'หอพัก อพาร์ทเม้นต์', 15),
(93, 'ตึกแถว', 15),
(94, 'ที่ดิน', 15),
(95, 'อสังหา อื่นๆ', 15),
(96, 'บริจาคเสื้อผ้า', 31),
(97, 'บริจาคเครื่องใช้ไฟฟ้า', 31),
(98, 'บริจาคเฟอร์นิเจอร์', 31),
(99, 'บริจาคอื่นๆ', 31),
(100, 'กวดวิชา', 30),
(101, 'สอนภาษา', 30),
(102, 'อบรม', 30),
(103, 'เรียนต่อต่างประเทศ', 30),
(104, 'อุปกรณืการเรียนการสอน', 30),
(105, 'หนังสือ', 30),
(106, 'ทัวร์ในประเทศ', 29),
(107, 'ทัวร์ต่างประเทศ', 29),
(108, 'ที่พัก', 29),
(109, 'ตั๋วเดินทาง', 29),
(110, 'อุปกรณ์การท่องเที่ยว', 29),
(111, 'บริการ เดินทาง', 29),
(112, 'ร้านอาหาร', 29),
(113, 'ตลาดสด', 28),
(114, 'ตลาดเกษตร', 28),
(115, 'บริการด้านเกษตร', 28),
(116, 'หนังสือ', 25),
(117, 'หนังและเพลง', 25),
(118, 'กิ๊ปช็อบ งานฝีมือ', 25),
(119, 'ของเล่น', 25),
(120, 'บัตรเข้าชม คูปอง', 25),
(121, 'สุนัข', 24),
(122, 'แมว', 24),
(123, 'ปลา', 24),
(124, 'หนู', 24),
(125, 'นก', 24),
(126, 'ไก่', 24),
(127, 'กระต่าย', 24),
(128, 'สัตว์เลี้ยงอื่นๆ', 24),
(129, 'อุปกรณ์สำหรัลสัตว์เลี้ยง', 24),
(130, 'อาหารสัตว์', 24),
(131, 'เครื่องเกมส์', 23),
(132, 'อุปกรณ์เกมส์อื่นๆ', 23),
(133, 'บอร์ดเกมส์', 23),
(134, 'แอร์', 22),
(135, 'ตู้เย็น', 22),
(136, 'ทีวี โฮมเธียเตอร์', 22),
(137, 'เครื่องซักผ้า', 22),
(138, 'เคเบิ้ล จานดาวเทียม', 22),
(139, 'เครื่องใช้ไฟฟ้าอื่นๆ', 22),
(140, 'กล้องดิจิตอล', 21),
(141, 'กล้องวีดีโอ', 21),
(142, 'กล้องอื่นๆ', 21),
(143, 'เลนส์', 21),
(144, 'เลนส์', 21),
(145, 'อุปกรณ์เสริมกล้อง อื่นๆ', 21),
(146, 'เรือ และเจ็ทสกี', 18),
(147, 'ATV / โกคาร์ท', 18),
(148, 'รถกอล์ฟ', 18),
(149, 'ยานพาหนะประเภทอื่นๆ', 18),
(150, 'ล้อแม๊ก', 19),
(151, 'ยางรถยนต์', 19),
(152, 'ไฟหน้า ไฟท้าย', 19),
(153, 'โช๊ค', 19),
(154, 'สปริง', 19),
(155, 'อุปกรณ์เสริมในรถยนต์', 19),
(156, 'เครื่องเสียง', 19),
(157, 'ป้ายทะเบียนรถยนต์', 19),
(158, 'ผลิตภัณฑ์ดูแลรถยนต์', 19),
(159, 'อะไหล่ ประดับยนต์อื่นๆ', 19),
(160, 'อะไหล่ รถรถบรรทุก และอะไหล่เครื่องจักรกล', 19),
(161, 'รองเท้ากีฬา', 9),
(162, 'อุปกรณ์เกี่ยวกับสุขภาพ', 11),
(163, 'น้ำหอม', 11),
(164, 'อุปกรณ์เสริมสวย', 11);

-- --------------------------------------------------------

--
-- Table structure for table `image`
--

CREATE TABLE `image` (
  `img_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `image` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `address` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(500) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `login_id` int(11) NOT NULL,
  `username` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `login_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status_login` varchar(2) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`login_id`, `username`, `login_date`, `status_login`) VALUES
(1, 'admin', '2019-06-07 04:01:08', 'Y'),
(2, 'admin', '2019-06-07 04:01:16', 'N'),
(3, 'rain', '2019-06-07 04:01:48', 'Y'),
(4, 'rain', '2019-06-07 04:01:56', 'N'),
(5, 'KK', '2019-06-07 04:04:06', 'Y'),
(6, 'KK', '2019-06-07 05:27:57', 'N'),
(7, 'admin', '2019-06-07 05:28:04', 'Y'),
(8, 'admin', '2019-06-07 07:29:15', 'N'),
(9, 'kiddee', '2019-06-07 07:30:31', 'Y'),
(10, 'kiddee', '2019-06-07 07:46:22', 'N'),
(11, 'admin', '2019-06-07 07:46:30', 'Y'),
(12, 'admin', '2019-06-07 09:36:57', 'N'),
(13, 'admin', '2019-06-07 09:37:07', 'Y'),
(14, 'admin', '2019-06-07 09:51:25', 'N'),
(15, 'admin', '2019-06-07 09:51:35', 'Y'),
(16, 'admin', '2019-06-07 09:54:35', 'N'),
(17, 'KK', '2019-06-07 09:54:49', 'Y'),
(18, 'admin', '2019-06-07 10:03:52', 'Y'),
(19, 'admin', '2019-06-07 10:04:08', 'Y'),
(20, 'admin', '2019-06-07 10:05:07', 'N'),
(21, 'admin', '2019-06-07 10:09:00', 'Y'),
(22, 'KK', '2019-06-07 10:22:41', 'N'),
(23, 'admin', '2019-06-07 10:22:52', 'Y'),
(24, 'admin', '2019-06-09 11:32:57', 'Y'),
(25, 'admin', '2019-06-09 11:56:29', 'N'),
(26, 'admin', '2019-06-09 15:09:34', 'Y'),
(27, 'admin', '2019-06-09 15:57:00', 'Y'),
(28, 'admin', '2019-06-09 15:59:47', 'Y'),
(29, 'admin', '2019-06-09 16:01:50', 'Y'),
(30, 'admin', '2019-06-09 16:03:11', 'Y'),
(31, 'admin', '2019-06-09 16:03:26', 'Y'),
(32, 'admin', '2019-06-09 16:07:37', 'Y'),
(33, 'admin', '2019-06-09 16:07:51', 'Y'),
(34, 'admin', '2019-06-09 16:14:12', 'Y'),
(35, 'admin', '2019-06-09 16:23:52', 'Y'),
(36, 'admin', '2019-06-09 16:24:09', 'Y'),
(37, 'admin', '2019-06-09 16:25:26', 'Y'),
(38, 'admin', '2019-06-09 16:25:43', 'Y'),
(39, 'admin', '2019-06-09 16:27:55', 'Y'),
(40, 'admin', '2019-06-09 16:28:26', 'Y'),
(41, 'admin', '2019-06-09 16:28:40', 'Y'),
(42, 'admin', '2019-06-09 16:30:33', 'Y'),
(43, 'admin', '2019-06-09 16:35:44', 'Y'),
(44, 'admin', '2019-06-09 16:36:08', 'Y'),
(45, 'admin', '2019-06-09 16:36:50', 'Y'),
(46, 'admin', '2019-06-09 16:37:35', 'Y'),
(47, 'admin', '2019-06-09 16:38:34', 'Y'),
(48, 'admin', '2019-06-09 16:39:46', 'Y'),
(49, 'admin', '2019-06-09 16:41:48', 'Y'),
(50, 'admin', '2019-06-09 16:43:01', 'Y'),
(51, 'admin', '2019-06-09 16:48:28', 'Y'),
(52, 'admin', '2019-06-09 16:48:44', 'Y'),
(53, 'admin', '2019-06-09 16:51:09', 'Y'),
(54, 'admin', '2019-06-09 16:54:10', 'Y'),
(55, 'admin', '2019-06-09 16:54:24', 'Y'),
(56, 'admin', '2019-06-09 16:58:24', 'Y'),
(57, 'admin', '2019-06-09 16:58:37', 'Y'),
(58, 'admin', '2019-06-09 16:58:39', 'Y'),
(59, 'admin', '2019-06-09 17:00:55', 'Y'),
(60, 'admin', '2019-06-09 17:01:49', 'Y'),
(61, 'admin', '2019-06-09 17:01:54', 'Y'),
(62, 'admin', '2019-06-09 17:02:10', 'Y'),
(63, 'admin', '2019-06-09 17:02:12', 'Y'),
(64, 'kiddee', '2019-06-10 02:32:03', 'Y'),
(65, 'kiddee', '2019-06-10 02:32:26', 'Y'),
(66, 'kiddee', '2019-06-10 02:32:28', 'Y'),
(67, 'kiddee', '2019-06-10 02:33:25', 'Y'),
(68, 'kiddee', '2019-06-10 02:33:27', 'Y'),
(69, 'kiddee', '2019-06-10 02:33:36', 'Y'),
(70, 'kiddee', '2019-06-10 02:33:38', 'Y'),
(71, 'kiddee', '2019-06-10 02:34:03', 'Y'),
(72, 'kiddee', '2019-06-10 02:34:05', 'Y'),
(73, 'kiddee', '2019-06-10 02:38:08', 'Y'),
(74, 'kiddee', '2019-06-10 02:38:10', 'Y'),
(75, 'kiddee', '2019-06-10 02:38:28', 'N'),
(76, 'kk', '2019-06-10 02:38:40', 'Y'),
(77, 'KK', '2019-06-10 02:47:49', 'Y'),
(78, 'KK', '2019-06-10 02:47:51', 'Y');

-- --------------------------------------------------------

--
-- Table structure for table `sell`
--

CREATE TABLE `sell` (
  `sell_id` int(11) NOT NULL,
  `username` varchar(100) COLLATE utf8_unicode_ci NOT NULL COMMENT 'ผู้ขาย',
  `groups_id` int(11) NOT NULL,
  `sell_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `sell_image` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `sell_address` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `sell_price` int(11) NOT NULL,
  `description` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `date_start` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `sell_number` int(11) NOT NULL DEFAULT '1',
  `sell_expired_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sell`
--

INSERT INTO `sell` (`sell_id`, `username`, `groups_id`, `sell_name`, `sell_image`, `sell_address`, `sell_price`, `description`, `date_start`, `sell_number`, `sell_expired_date`) VALUES
(13, 'admin', 2, 'iphone6s', '0341e9eb-c133-4c80-9e75-f242ce83da5b.jpg', 'สุพรรบุรี', 6500, 'ไม่ค่อยได่เล่นเลยอยากขาย', '2019-06-07 07:59:56', 94, '2019-05-02 00:00:00'),
(14, 'admin', 1, 'Ipad', '4b6edcd4-6f87-4d1d-8950-70298f56db62.jpg', 'ปราจีนบุรี', 14500, 'ไม่ค่อยได้เล่นอยากให้คนอื่นที่จำเป็นได้ใช้', '2019-06-05 07:10:52', 66, '0000-00-00 00:00:00'),
(15, 'admin', 3, 'หูฟัง Bluetooth', 'e9f4a675-d919-42d4-a5b8-f9f7a2b2a252.jpg', 'กรุงเทพมหานคร', 3500, 'เป็นตัวแทนจำหน่ายจากต่างประเทศ สินค้ามีจำกัด', '2019-06-05 09:16:01', 98, '2019-05-20 00:00:00'),
(16, 'admin', 3, 'วอสื่อสาร', 'f616161c-b179-4ad3-892a-d2dd634d6ab0.jpg', 'สุโททัย', 500, 'ขายเพราะ ปิดงานเลี้ยงแล้วไม่ได้ใช้', '2019-06-05 10:06:26', 99, '0000-00-00 00:00:00'),
(17, 'admin', 4, 'กีต้าร์ YAMAHA', '5ff0f2fd-2559-4bb4-9316-ddbada3716e3.jpg', 'ชลบุรี', 2500, 'ขายเพราะไม่มีเวลาเล่น ', '2019-06-07 04:05:13', 99, '0000-00-00 00:00:00'),
(18, 'admin', 5, 'อคูลเลเล่ สภาพนางฟ้า', 'bdbe7adc-7ce4-49ca-abb8-809dad8e5c16.jpg', 'นครราชสีมา', 15, 'สภาพนางฟ้า ไม่ค่อยได้เล่น', '2019-05-29 03:03:47', 100, '0000-00-00 00:00:00'),
(19, 'admin', 10, 'กีต้าร์ไฟฟ้า เล่นโครตมัน', 'bec40e65-039c-4dc6-a963-1ceac03b79ee.jpg', 'ระยอง', 18000, 'ขายเพราะ จำเป็นต้องใช้เงิน ด่วน !!!!', '2019-05-29 03:03:48', 100, '0000-00-00 00:00:00'),
(20, 'rain', 13, 'น้ำดื่มคริสตัล', 'ae62c5b2-9a7c-4955-8ecd-11f9745d3025.jpg', 'ร้านอาหาร กลางแม่น้ำ เจ้าพระยา', 65, 'ขายเป็นแพค แพคใหญ่', '2019-05-31 05:34:55', 100, '0000-00-00 00:00:00'),
(21, 'admin', 18, 'จักรยานเสือหมอบโครตแรง', '4a45be17-4461-4d82-aa44-d1c69d4563cd.jpg', 'กรุงเทพมหานคร แถว ลาดพร้าว', 15000, 'เนื่องจากไม่ได้ขี่แล้ว', '2019-05-29 03:03:50', 100, '0000-00-00 00:00:00'),
(22, 'admin', 19, 'จักรยานเสือภูเขาเร็วแรง', '32d38e1a-95c1-40b9-8762-3bb302808c0b.jpg', 'กรุงเทพมหานคร แถวอโศก', 7500, 'อยากได้เสือหมอบ', '2019-05-29 03:03:55', 100, '0000-00-00 00:00:00'),
(23, 'admin', 6, 'คอมตั้งโต๊ะ', '8d391035-e492-4da1-a4be-ee9c9a3167f3.jpg', 'ปราจีนบุรี', 16000, 'ขาย เพราะ อยากได้ max book', '2019-06-04 02:03:19', 99, '0000-00-00 00:00:00'),
(29, 'KK', 59, 'เสื้อยืด', '8dd841d7-ba31-400f-a5c1-08e467e2dbbe.jpg', '124 phuket', 3500, '-', '2019-06-07 04:11:51', 2, '0000-00-00 00:00:00'),
(30, 'KK', 131, 'Xbox one', 'b098bdfc-7156-42fb-a937-5420db607cb4.jpg', '13 phuket', 15000, 'Xbox one มือสอง สภาพ 90% ราคาถูก', '2019-06-07 04:19:41', 1, '0000-00-00 00:00:00'),
(31, 'KK', 28, 'ชุดสำหรับออกกำลังกายครบเซต adidas', '31f8f0dd-2575-4023-bdb4-21b4bb8dadd6.jpg', '1234 phuket', 5300, 'ชุดสำหรับออกกำลังกายครบเซต adidas ขายออกเป็นเซตไม่แบ่งขาย', '2019-06-07 04:23:35', 1, '0000-00-00 00:00:00'),
(32, 'KK', 48, 'กระเป๋าตัง louis vitton', '0a4c089c-66c3-4c87-bff3-44803d457886.jpg', '1234 Phuket', 21000, 'กระเป๋าตังมือสองสภาพดี', '2019-06-07 04:26:37', 1, '0000-00-00 00:00:00'),
(33, 'KK', 6, 'คอมพิวเตอร์ตั้งโต๊ะ', 'c6d04697-59b2-4871-aab2-fef54055daca.jpg', '1234 phuket', 32000, 'คอมพิวเตอร์ตั้งโต๊ะสภาพดี สอบถามเพิ่งเติมได้', '2019-06-07 04:28:50', 1, '0000-00-00 00:00:00'),
(37, 'KK', 39, 'หมวกกันน็อกสำหรับปั่นจักรยาน', 'a3b31b7c-78dc-4d8e-b0ed-a7cd484dc91a.jpg', '1234 phuket', 2500, 'หมวกกันน็อกสำหรับปั่นจักรยาน ', '2019-06-07 04:33:07', 2, '0000-00-00 00:00:00'),
(38, 'KK', 161, 'Nike sneaker', '4592b1dd-39c6-4d19-9114-058c6919648e.jpg', 'phuket 1234', 5000, 'Nike sneaker', '2019-06-07 10:06:52', 2, '0000-00-00 00:00:00'),
(39, 'KK', 22, 'กลองชุด yamaha', '8370d2be-93fa-4747-bc2f-f343d7608037.jpg', 'phukrt 132', 65000, 'กลองชุด yamaha มือหนิ่ง', '2019-06-10 02:40:03', 1, '0000-00-00 00:00:00'),
(40, 'KK', 41, 'เสื้อเซิ้ตเด็ก', '8f978f92-4346-40b6-af8d-01b3e94e96e9.jpg', 'phuket', 500, 'เสื้อเซิ้ตเด็กผู้ชาย', '2019-06-07 04:42:51', 1, '0000-00-00 00:00:00'),
(41, 'KK', 54, 'fitbit smart watch', 'd61f1eec-1477-4a1b-87c2-cdbaf8040874.jpg', 'phuket 1234', 7500, 'fitbit charge 3 smart watch', '2019-06-07 04:46:13', 1, '0000-00-00 00:00:00'),
(42, 'KK', 45, 'Lego', '341d0cef-7d11-4785-a07a-cb74fd99eb64.jpg', 'phuket 1234', 1500, 'Military SWAT Team Helicopter lego', '2019-06-07 04:49:30', 1, '0000-00-00 00:00:00'),
(43, 'KK', 91, 'Condominium', '2b93522b-f77f-4e42-8ddb-328e1bc073da.jpg', 'Kata Phuket Thailand', 1200000, 'VIP KATA Condominium has 388 apartments in total within 5 buildings. Phase 1 is going be launched in June, 2018, Phase 2 in May, 2020. There are 5 swimming pools, family park with kids playgrounds, 3 restaurants, SPA, gym, roof gardens, infinity pool and bar on roof. And the complex located only 500 meters from Kata beach.', '2019-06-07 04:53:18', 2, '0000-00-00 00:00:00'),
(53, 'KK', 56, 'รองเท้าหนัง', '3b1cb19d-6106-49fe-ae8f-559823ae5285.jpg', '123 phuket', 1500, 'รองเท้าหนังสีน้ำตาล ผู้ชาย', '2019-06-07 10:07:14', 1, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `username` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `fname` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `lname` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `status` varchar(2) COLLATE utf8_unicode_ci NOT NULL,
  `phone` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `user_image` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `user_address` varchar(500) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `username`, `password`, `fname`, `lname`, `status`, `phone`, `user_image`, `user_address`) VALUES
(8650, 'admin', 'admin', 'แอดมิน', 'โว้ย', 'A', '0831101923', '35fabec0-2029-4872-ad18-2df44424bfde.jpg', 'บ้านบึง'),
(8651, 'kidakarn', 'kidakarn', 'กิดาการ', 'อินทปัญญา', 'U', '123456789', '12.jpg', 'ปราจีนบุรี'),
(8666, '23q1', '23', '23', '23', 'U', '123456786', '12.jpg', 'asd'),
(8667, 'rain', 'rain', 'Patomporn', 'Rungruangrutai', 'U', '0927486210', 'cae7247f-5e04-4cbf-a865-8b38fcbce428.jpg', '36 ซอย แสนสบาย6 ถ.บ้านบึงแกลง\nตำบล บ้านบึง อำเภอ บ้านบึง จ.ชลบุรี'),
(8668, 'test', 'test', 'test', 'test', 'U', '123456789', 'default.png', 'test'),
(8676, 'KK', '1234', 'Gunyawee', 'K', 'U', '0998603053', 'default.png', '131 Phuket '),
(8677, 'kiddee', 'kiddee', 'kidakarn', 'Intapanya', 'U', '0831101923', '9d7f1ba6-0420-4712-981d-8786327e00a8.jpg', 'บ้านบึง');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `buys`
--
ALTER TABLE `buys`
  ADD PRIMARY KEY (`buys_id`),
  ADD KEY `sell_id` (`sell_id`),
  ADD KEY `username` (`username`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`cat_id`);

--
-- Indexes for table `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`groups_id`),
  ADD KEY `cat_id` (`cat_id`);

--
-- Indexes for table `image`
--
ALTER TABLE `image`
  ADD PRIMARY KEY (`img_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`login_id`),
  ADD KEY `user_id` (`username`);

--
-- Indexes for table `sell`
--
ALTER TABLE `sell`
  ADD PRIMARY KEY (`sell_id`),
  ADD KEY `username` (`username`),
  ADD KEY `groups_id` (`groups_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `buys`
--
ALTER TABLE `buys`
  MODIFY `buys_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=109;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `cat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `groups`
--
ALTER TABLE `groups`
  MODIFY `groups_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=165;

--
-- AUTO_INCREMENT for table `image`
--
ALTER TABLE `image`
  MODIFY `img_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `login`
--
ALTER TABLE `login`
  MODIFY `login_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;

--
-- AUTO_INCREMENT for table `sell`
--
ALTER TABLE `sell`
  MODIFY `sell_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8678;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `buys`
--
ALTER TABLE `buys`
  ADD CONSTRAINT `buys_ibfk_1` FOREIGN KEY (`sell_id`) REFERENCES `sell` (`sell_id`),
  ADD CONSTRAINT `buys_ibfk_2` FOREIGN KEY (`username`) REFERENCES `user` (`username`);

--
-- Constraints for table `groups`
--
ALTER TABLE `groups`
  ADD CONSTRAINT `groups_ibfk_1` FOREIGN KEY (`cat_id`) REFERENCES `category` (`cat_id`);

--
-- Constraints for table `image`
--
ALTER TABLE `image`
  ADD CONSTRAINT `image_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `login_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`);

--
-- Constraints for table `sell`
--
ALTER TABLE `sell`
  ADD CONSTRAINT `sell_ibfk_1` FOREIGN KEY (`groups_id`) REFERENCES `groups` (`groups_id`),
  ADD CONSTRAINT `sell_ibfk_2` FOREIGN KEY (`username`) REFERENCES `user` (`username`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
