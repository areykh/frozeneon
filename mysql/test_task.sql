-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Окт 27 2021 г., 20:36
-- Версия сервера: 8.0.15
-- Версия PHP: 7.3.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `test_task`
--

-- --------------------------------------------------------

--
-- Структура таблицы `analytics`
--

CREATE TABLE `analytics` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `object` enum('user','post','comment','boosterpack') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `action` enum('wallet_balance_accrual','wallet_balance_withdraw','likes_balance_accrual','likes_balance_withdraw') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `object_id` int(11) DEFAULT NULL,
  `amount` float DEFAULT NULL,
  `time_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `time_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `analytics`
--

INSERT INTO `analytics` (`id`, `user_id`, `object`, `action`, `object_id`, `amount`) VALUES
(1, 1, 'user', 'wallet_balance_accrual', 1, 10),
(2, 1, 'boosterpack', 'wallet_balance_withdraw', 1, 5),
(3, 1, 'boosterpack', 'likes_balance_accrual', 1, 3),
(4, 1, 'boosterpack', 'wallet_balance_withdraw', 1, 5),
(5, 1, 'boosterpack', 'likes_balance_accrual', 1, 2),
(6, 1, 'post', 'likes_balance_withdraw', 1, 1),
(7, 1, 'comment', 'likes_balance_withdraw', 14, 1),
(8, 1, 'comment', 'likes_balance_withdraw', 11, 1),
(9, 1, 'post', 'likes_balance_withdraw', 1, 1),
(10, 1, 'post', 'likes_balance_withdraw', 2, 1),
(11, 1, 'user', 'wallet_balance_accrual', 1, 20),
(12, 1, 'boosterpack', 'wallet_balance_withdraw', 2, 20),
(13, 1, 'boosterpack', 'likes_balance_accrual', 2, 15),
(14, 1, 'post', 'likes_balance_withdraw', 2, 1),
(15, 1, 'post', 'likes_balance_withdraw', 1, 1),
(16, 1, 'post', 'likes_balance_withdraw', 1, 1),
(17, 1, 'post', 'likes_balance_withdraw', 1, 1),
(18, 1, 'post', 'likes_balance_withdraw', 1, 1),
(19, 1, 'comment', 'likes_balance_withdraw', 15, 1),
(20, 1, 'comment', 'likes_balance_withdraw', 20, 1),
(21, 1, 'comment', 'likes_balance_withdraw', 10, 1),
(22, 1, 'comment', 'likes_balance_withdraw', 10, 1),
(23, 1, 'user', 'wallet_balance_accrual', 1, 10),
(24, 1, 'boosterpack', 'wallet_balance_withdraw', 1, 5),
(25, 1, 'boosterpack', 'likes_balance_accrual', 1, 2),
(26, 2, 'user', 'wallet_balance_accrual', 2, 100),
(27, 2, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(28, 2, 'boosterpack', 'likes_balance_accrual', 3, 20),
(29, 2, 'boosterpack', 'wallet_balance_withdraw', 2, 20),
(30, 2, 'boosterpack', 'likes_balance_accrual', 2, 5),
(31, 2, 'post', 'likes_balance_withdraw', 1, 1),
(32, 2, 'comment', 'likes_balance_withdraw', 6, 1),
(33, 2, 'comment', 'likes_balance_withdraw', 6, 1),
(34, 2, 'comment', 'likes_balance_withdraw', 6, 1),
(35, 2, 'comment', 'likes_balance_withdraw', 11, 1),
(36, 2, 'comment', 'likes_balance_withdraw', 11, 1),
(37, 2, 'comment', 'likes_balance_withdraw', 11, 1),
(38, 2, 'comment', 'likes_balance_withdraw', 11, 1),
(39, 2, 'comment', 'likes_balance_withdraw', 11, 1),
(40, 2, 'comment', 'likes_balance_withdraw', 11, 1),
(41, 2, 'comment', 'likes_balance_withdraw', 5, 1),
(42, 2, 'comment', 'likes_balance_withdraw', 20, 1),
(43, 2, 'comment', 'likes_balance_withdraw', 15, 1),
(44, 2, 'comment', 'likes_balance_withdraw', 19, 1),
(45, 1, 'comment', 'likes_balance_withdraw', 44, 1),
(46, 1, 'comment', 'likes_balance_withdraw', 44, 1),
(47, 1, 'comment', 'likes_balance_withdraw', 43, 1),
(48, 1, 'comment', 'likes_balance_withdraw', 5, 1),
(49, 1, 'post', 'likes_balance_withdraw', 2, 1),
(50, 2, 'user', 'wallet_balance_accrual', 2, 10.5),
(51, 2, 'user', 'wallet_balance_accrual', 2, 10.7),
(52, 2, 'user', 'wallet_balance_accrual', 2, 100),
(53, 2, 'comment', 'likes_balance_withdraw', 1, 1),
(54, 2, 'comment', 'likes_balance_withdraw', 22, 1),
(55, 2, 'post', 'likes_balance_withdraw', 1, 1),
(56, 2, 'post', 'likes_balance_withdraw', 1, 1),
(57, 2, 'comment', 'likes_balance_withdraw', 7, 1),
(58, 2, 'post', 'likes_balance_withdraw', 1, 1),
(59, 2, 'comment', 'likes_balance_withdraw', 1, 1),
(60, 2, 'comment', 'likes_balance_withdraw', 48, 1),
(61, 1, 'comment', 'likes_balance_withdraw', 49, 1),
(62, 1, 'post', 'likes_balance_withdraw', 2, 1),
(63, 1, 'boosterpack', 'wallet_balance_withdraw', 1, 5),
(64, 1, 'boosterpack', 'likes_balance_accrual', 1, 5),
(65, 2, 'user', 'wallet_balance_accrual', 2, 100.3),
(66, 2, 'comment', 'likes_balance_withdraw', 40, 1),
(67, 2, 'comment', 'likes_balance_withdraw', 41, 1),
(68, 2, 'comment', 'likes_balance_withdraw', 42, 1),
(69, 2, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(70, 2, 'boosterpack', 'likes_balance_accrual', 3, 50),
(71, 2, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(72, 2, 'boosterpack', 'likes_balance_accrual', 3, 20),
(73, 2, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(74, 2, 'boosterpack', 'likes_balance_accrual', 3, 20),
(75, 2, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(76, 2, 'boosterpack', 'likes_balance_accrual', 3, 20),
(77, 2, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(78, 2, 'boosterpack', 'likes_balance_accrual', 3, 20),
(79, 1, 'user', 'wallet_balance_accrual', 1, 10.8),
(80, 1, 'boosterpack', 'wallet_balance_withdraw', 1, 5),
(81, 1, 'boosterpack', 'likes_balance_accrual', 1, 3),
(82, 1, 'boosterpack', 'wallet_balance_withdraw', 1, 5),
(83, 1, 'boosterpack', 'likes_balance_accrual', 1, 1),
(84, 1, 'user', 'wallet_balance_accrual', 1, 50),
(85, 1, 'boosterpack', 'wallet_balance_withdraw', 1, 5),
(86, 1, 'boosterpack', 'likes_balance_accrual', 1, 1),
(87, 1, 'boosterpack', 'wallet_balance_withdraw', 1, 5),
(88, 1, 'boosterpack', 'likes_balance_accrual', 1, 2),
(89, 1, 'boosterpack', 'wallet_balance_withdraw', 1, 5),
(90, 1, 'boosterpack', 'likes_balance_accrual', 1, 5),
(91, 1, 'boosterpack', 'wallet_balance_withdraw', 1, 5),
(92, 1, 'boosterpack', 'likes_balance_accrual', 1, 2),
(93, 1, 'boosterpack', 'wallet_balance_withdraw', 1, 5),
(94, 1, 'boosterpack', 'likes_balance_accrual', 1, 10),
(95, 1, 'boosterpack', 'wallet_balance_withdraw', 1, 5),
(96, 1, 'boosterpack', 'likes_balance_accrual', 1, 1),
(97, 1, 'boosterpack', 'wallet_balance_withdraw', 1, 5),
(98, 1, 'boosterpack', 'likes_balance_accrual', 1, 2),
(99, 1, 'boosterpack', 'wallet_balance_withdraw', 1, 5),
(100, 1, 'boosterpack', 'likes_balance_accrual', 1, 10),
(101, 1, 'boosterpack', 'wallet_balance_withdraw', 1, 5),
(102, 1, 'boosterpack', 'likes_balance_accrual', 1, 3),
(103, 1, 'boosterpack', 'wallet_balance_withdraw', 1, 5),
(104, 1, 'boosterpack', 'likes_balance_accrual', 1, 10),
(105, 1, 'user', 'wallet_balance_accrual', 1, 1000),
(106, 1, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(107, 1, 'boosterpack', 'likes_balance_accrual', 3, 20),
(108, 1, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(109, 1, 'boosterpack', 'likes_balance_accrual', 3, 30),
(110, 1, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(111, 1, 'boosterpack', 'likes_balance_accrual', 3, 200),
(112, 1, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(113, 1, 'boosterpack', 'likes_balance_accrual', 3, 20),
(114, 1, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(115, 1, 'boosterpack', 'likes_balance_accrual', 3, 30),
(116, 1, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(117, 1, 'boosterpack', 'likes_balance_accrual', 3, 50),
(118, 1, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(119, 1, 'boosterpack', 'likes_balance_accrual', 3, 30),
(120, 1, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(121, 1, 'boosterpack', 'likes_balance_accrual', 3, 100),
(122, 1, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(123, 1, 'boosterpack', 'likes_balance_accrual', 3, 30),
(124, 1, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(125, 1, 'boosterpack', 'likes_balance_accrual', 3, 20),
(126, 1, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(127, 1, 'boosterpack', 'likes_balance_accrual', 3, 30),
(128, 1, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(129, 1, 'boosterpack', 'likes_balance_accrual', 3, 50),
(130, 1, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(131, 1, 'boosterpack', 'likes_balance_accrual', 3, 50),
(132, 1, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(133, 1, 'boosterpack', 'likes_balance_accrual', 3, 50),
(134, 1, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(135, 1, 'boosterpack', 'likes_balance_accrual', 3, 30),
(136, 1, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(137, 1, 'boosterpack', 'likes_balance_accrual', 3, 30),
(138, 1, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(139, 1, 'boosterpack', 'likes_balance_accrual', 3, 100),
(140, 1, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(141, 1, 'boosterpack', 'likes_balance_accrual', 3, 30),
(142, 1, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(143, 1, 'boosterpack', 'likes_balance_accrual', 3, 30),
(144, 1, 'boosterpack', 'wallet_balance_withdraw', 3, 50),
(145, 1, 'boosterpack', 'likes_balance_accrual', 3, 50),
(146, 1, 'post', 'likes_balance_withdraw', 1, 1),
(147, 1, 'comment', 'likes_balance_withdraw', 13, 1),
(148, 1, 'comment', 'likes_balance_withdraw', 14, 1),
(149, 1, 'comment', 'likes_balance_withdraw', 14, 1),
(150, 1, 'comment', 'likes_balance_withdraw', 14, 1),
(151, 1, 'comment', 'likes_balance_withdraw', 14, 1),
(152, 1, 'post', 'likes_balance_withdraw', 1, 1),
(153, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(154, 1, 'user', 'wallet_balance_accrual', 1, 100),
(155, 1, 'boosterpack', 'wallet_balance_withdraw', 1, 5),
(156, 1, 'boosterpack', 'likes_balance_accrual', 1, 5),
(157, 2, 'post', 'likes_balance_withdraw', 1, 1),
(158, 2, 'comment', 'likes_balance_withdraw', 1, 1),
(159, 2, 'user', 'wallet_balance_accrual', 2, 120),
(160, 2, 'boosterpack', 'wallet_balance_withdraw', 1, 5),
(161, 2, 'boosterpack', 'likes_balance_accrual', 1, 2),
(162, 1, 'post', 'likes_balance_withdraw', 1, 1),
(163, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(164, 1, 'comment', 'likes_balance_withdraw', 3, 1),
(165, 1, 'comment', 'likes_balance_withdraw', 22, 1),
(166, 1, 'comment', 'likes_balance_withdraw', 6, 1),
(167, 1, 'comment', 'likes_balance_withdraw', 23, 1),
(168, 1, 'post', 'likes_balance_withdraw', 2, 1),
(169, 1, 'comment', 'likes_balance_withdraw', 5, 1),
(170, 1, 'post', 'likes_balance_withdraw', 2, 1),
(171, 1, 'post', 'likes_balance_withdraw', 1, 1),
(172, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(173, 1, 'comment', 'likes_balance_withdraw', 50, 1),
(174, 1, 'comment', 'likes_balance_withdraw', 3, 1),
(175, 1, 'comment', 'likes_balance_withdraw', 50, 1),
(176, 1, 'comment', 'likes_balance_withdraw', 50, 1),
(177, 1, 'comment', 'likes_balance_withdraw', 50, 1),
(178, 1, 'comment', 'likes_balance_withdraw', 50, 1),
(179, 1, 'comment', 'likes_balance_withdraw', 50, 1),
(180, 1, 'comment', 'likes_balance_withdraw', 50, 1),
(181, 1, 'comment', 'likes_balance_withdraw', 50, 1),
(182, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(183, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(184, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(185, 1, 'post', 'likes_balance_withdraw', 1, 1),
(186, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(187, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(188, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(189, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(190, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(191, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(192, 1, 'post', 'likes_balance_withdraw', 1, 1),
(193, 1, 'comment', 'likes_balance_withdraw', 3, 1),
(194, 1, 'comment', 'likes_balance_withdraw', 4, 1),
(195, 1, 'comment', 'likes_balance_withdraw', 4, 1),
(196, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(197, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(198, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(199, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(200, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(201, 1, 'comment', 'likes_balance_withdraw', 4, 1),
(202, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(203, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(204, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(205, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(206, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(207, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(208, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(209, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(210, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(211, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(212, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(213, 1, 'comment', 'likes_balance_withdraw', 4, 1),
(214, 1, 'comment', 'likes_balance_withdraw', 4, 1),
(215, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(216, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(217, 1, 'comment', 'likes_balance_withdraw', 4, 1),
(218, 1, 'comment', 'likes_balance_withdraw', 4, 1),
(219, 1, 'comment', 'likes_balance_withdraw', 4, 1),
(220, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(221, 1, 'comment', 'likes_balance_withdraw', 4, 1),
(222, 1, 'comment', 'likes_balance_withdraw', 4, 1),
(223, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(224, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(225, 1, 'comment', 'likes_balance_withdraw', 4, 1),
(226, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(227, 1, 'comment', 'likes_balance_withdraw', 3, 1),
(228, 1, 'comment', 'likes_balance_withdraw', 22, 1),
(229, 1, 'comment', 'likes_balance_withdraw', 4, 1),
(230, 1, 'comment', 'likes_balance_withdraw', 50, 1),
(231, 1, 'comment', 'likes_balance_withdraw', 5, 1),
(232, 1, 'comment', 'likes_balance_withdraw', 4, 1),
(233, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(234, 1, 'post', 'likes_balance_withdraw', 1, 1),
(235, 1, 'comment', 'likes_balance_withdraw', 4, 1),
(236, 1, 'comment', 'likes_balance_withdraw', 50, 1),
(237, 1, 'user', 'wallet_balance_accrual', 1, 10),
(238, 1, 'user', 'wallet_balance_accrual', 1, 10),
(240, 1, 'user', 'wallet_balance_accrual', 1, 10),
(241, 1, 'user', 'wallet_balance_accrual', 1, 10),
(242, 1, 'user', 'wallet_balance_accrual', 1, 10),
(243, 1, 'user', 'wallet_balance_accrual', 1, 20),
(244, 1, 'boosterpack', 'wallet_balance_withdraw', 2, 20),
(245, 1, 'boosterpack', 'likes_balance_accrual', 2, 30),
(246, 1, 'post', 'likes_balance_withdraw', 2, 1),
(247, 1, 'comment', 'likes_balance_withdraw', 4, 1),
(248, 1, 'comment', 'likes_balance_withdraw', 50, 1),
(249, 1, 'post', 'likes_balance_withdraw', 1, 1),
(250, 1, 'comment', 'likes_balance_withdraw', 1, 1),
(251, 1, 'comment', 'likes_balance_withdraw', 3, 1),
(252, 1, 'comment', 'likes_balance_withdraw', 22, 1),
(253, 1, 'comment', 'likes_balance_withdraw', 6, 1),
(254, 1, 'comment', 'likes_balance_withdraw', 7, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `boosterpack`
--

CREATE TABLE `boosterpack` (
  `id` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `bank` decimal(10,2) NOT NULL DEFAULT '0.00',
  `us` int(11) NOT NULL,
  `time_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `time_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `boosterpack`
--

INSERT INTO `boosterpack` (`id`, `price`, `bank`, `us`) VALUES
(1, '5.00', '3.00', 1),
(2, '20.00', '4.00', 2),
(3, '50.00', '40.00', 5);

-- --------------------------------------------------------

--
-- Структура таблицы `boosterpack_info`
--

CREATE TABLE `boosterpack_info` (
  `id` int(11) NOT NULL,
  `boosterpack_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `boosterpack_info`
--

INSERT INTO `boosterpack_info` (`id`, `boosterpack_id`, `item_id`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 1, 4),
(5, 1, 5),
(6, 1, 6),
(7, 2, 3),
(8, 2, 4),
(9, 2, 5),
(10, 2, 6),
(11, 2, 7),
(12, 2, 8),
(13, 3, 7),
(14, 3, 8),
(15, 3, 9),
(16, 3, 10),
(17, 3, 11),
(18, 3, 12);

-- --------------------------------------------------------

--
-- Структура таблицы `comment`
--

CREATE TABLE `comment` (
  `id` int(11) NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `assign_id` int(10) UNSIGNED NOT NULL,
  `reply_id` int(11) NOT NULL DEFAULT '0',
  `text` text NOT NULL,
  `likes` int(11) NOT NULL DEFAULT '0',
  `time_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `time_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `comment`
--

INSERT INTO `comment` (`id`, `user_id`, `assign_id`, `reply_id`, `text`, `likes`) VALUES
(1, 1, 1, 0, 'Comment #1', 39),
(2, 1, 1, 0, 'Comment #2', 0),
(3, 2, 1, 1, 'Comment #3', 5),
(4, 2, 2, 0, 'Comment #4', 15),
(5, 2, 2, 0, 'Comment #5', 4),
(6, 2, 1, 1, 'Comment #6', 5),
(7, 2, 1, 6, 'Comment #7', 2),
(8, 2, 1, 0, 'Comment #8', 0),
(9, 2, 1, 0, 'Comment #9', 0),
(10, 2, 1, 1, 'Comment #10', 2),
(11, 1, 2, 5, 'Comment #11', 7),
(12, 1, 1, 6, 'Comment #12', 0),
(13, 1, 1, 6, 'Comment #13', 1),
(14, 1, 1, 6, 'Comment #14', 5),
(15, 1, 1, 6, 'Comment #15', 2),
(16, 1, 1, 0, 'Comment #16', 0),
(17, 1, 1, 0, 'Comment #17', 0),
(18, 1, 1, 0, 'Comment #18', 0),
(19, 1, 1, 1, 'Comment #19', 1),
(20, 1, 1, 15, 'Comment #20', 2),
(21, 1, 1, 20, 'Comment #21', 0),
(22, 1, 1, 3, 'Comment #22', 4),
(23, 1, 1, 16, 'Comment #23', 1),
(24, 1, 1, 23, 'Comment #24', 0),
(25, 1, 1, 0, 'Comment #25', 0),
(26, 1, 1, 0, 'Comment #26', 0),
(27, 1, 1, 26, 'Comment #27', 0),
(28, 1, 1, 27, 'Comment #28', 0),
(29, 1, 1, 0, 'Comment #29', 0),
(30, 1, 1, 27, 'Comment #30', 0),
(31, 1, 1, 0, 'Comment #31', 0),
(32, 1, 1, 0, 'Comment #32', 0),
(33, 1, 1, 14, 'Comment #33', 0),
(34, 1, 1, 0, '\'&lt;script&gt;alert(\\\'test\\\');&lt;/script&gt;\'', 0),
(35, 1, 1, 0, '&lt;script&gt;alert(&quot;test&quot;);&lt;/script&gt;', 0),
(36, 1, 1, 0, '&lt;script&gt;alert(&quot;test&quot;);&lt;/script&gt;', 0),
(37, 1, 1, 0, '&lt;script&gt;alert(&quot;test&quot;);&lt;/script&gt;', 0),
(38, 1, 1, 0, '&lt;h1&gt;test&lt;/h1&gt;', 0),
(39, 1, 1, 0, 'SELECT * FROM user;', 0),
(40, 1, 1, 0, 'TRUNCATE `test_task`.`user`;', 1),
(41, 1, 1, 0, 'Comment #41', 1),
(42, 1, 1, 0, 'Comment #42', 1),
(43, 2, 2, 0, 'Comment #43', 1),
(44, 2, 2, 43, 'Comment #44', 2),
(45, 2, 2, 44, 'Comment #45', 0),
(46, 1, 2, 44, 'Comment #46', 0),
(47, 1, 2, 43, 'Comment #47', 0),
(48, 2, 2, 0, 'Comment #48', 1),
(49, 1, 2, 0, 'Comment #49', 1),
(50, 1, 2, 4, 'Comment #50', 11);

-- --------------------------------------------------------

--
-- Структура таблицы `items`
--

CREATE TABLE `items` (
  `id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `items`
--

INSERT INTO `items` (`id`, `name`, `price`) VALUES
(1, '1 Likes', 1),
(2, '2 Likes', 2),
(3, '3 Likes', 3),
(4, '5 Likes', 5),
(5, '10 Likes', 10),
(6, '15 Likes', 15),
(7, '20 Likes', 20),
(8, '30 Likes', 30),
(9, '50 Likes', 50),
(10, '100 Likes', 100),
(11, '200 Likes', 200),
(12, '500 Likes', 500);

-- --------------------------------------------------------

--
-- Структура таблицы `post`
--

CREATE TABLE `post` (
  `id` int(11) NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `text` text NOT NULL,
  `img` varchar(1024) DEFAULT NULL,
  `likes` int(11) DEFAULT NULL,
  `time_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `time_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `post`
--

INSERT INTO `post` (`id`, `user_id`, `text`, `img`, `likes`) VALUES
(1, 1, 'Post 1', '/images/posts/1.png', 19),
(2, 1, 'Post 2', '/images/posts/2.png', 7);

-- --------------------------------------------------------

--
-- Структура таблицы `user`
--

CREATE TABLE `user` (
  `id` int(11) UNSIGNED NOT NULL,
  `email` varchar(60) DEFAULT NULL,
  `password` char(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `personaname` varchar(50) NOT NULL DEFAULT '',
  `avatarfull` varchar(150) NOT NULL DEFAULT '',
  `rights` tinyint(4) NOT NULL DEFAULT '0',
  `likes_balance` int(11) DEFAULT '0',
  `wallet_balance` decimal(10,2) NOT NULL DEFAULT '0.00',
  `wallet_total_refilled` decimal(10,2) NOT NULL DEFAULT '0.00',
  `wallet_total_withdrawn` decimal(10,2) NOT NULL DEFAULT '0.00',
  `time_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `time_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `user`
--

INSERT INTO `user` (`id`, `email`, `password`, `personaname`, `avatarfull`, `rights`, `likes_balance`, `wallet_balance`, `wallet_total_refilled`, `wallet_total_withdrawn`) VALUES
(1, 'admin@admin.pl', '01e4f21845d0b464522fbaffe5a3444f', 'Admin User', 'https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/96/967871835afdb29f131325125d4395d55386c07a_full.jpg', 0, 979, '145.80', '1270.80', '1125.00'),
(2, 'user@user.pl', '099f4bee2c21d472aa3e0d1bff23a581', 'User #1', 'https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/86/86a0c845038332896455a566a1f805660a13609b_full.jpg', 0, 130, '116.50', '441.50', '325.00');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `analytics`
--
ALTER TABLE `analytics`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `boosterpack`
--
ALTER TABLE `boosterpack`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `boosterpack_info`
--
ALTER TABLE `boosterpack_info`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `post`
--
ALTER TABLE `post`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `analytics`
--
ALTER TABLE `analytics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=255;

--
-- AUTO_INCREMENT для таблицы `boosterpack`
--
ALTER TABLE `boosterpack`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `boosterpack_info`
--
ALTER TABLE `boosterpack_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT для таблицы `comment`
--
ALTER TABLE `comment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT для таблицы `items`
--
ALTER TABLE `items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT для таблицы `post`
--
ALTER TABLE `post`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
