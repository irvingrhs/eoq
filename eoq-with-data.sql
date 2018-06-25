-- phpMyAdmin SQL Dump
-- version 4.0.4.1
-- http://www.phpmyadmin.net
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 27-11-2013 a las 03:49:28
-- Versión del servidor: 5.5.32
-- Versión de PHP: 5.4.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `eoq`
--
CREATE DATABASE IF NOT EXISTS `eoq` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `eoq`;

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarDemanda`()
    NO SQL
UPDATE inventario SET demanda = (
SELECT SUM( cantidad ) 
FROM (

SELECT * 
FROM ventas
WHERE fecha
BETWEEN DATE_ADD( CURRENT_DATE( ) , INTERVAL -1
YEAR ) 
AND CURRENT_DATE( )
) AS tmp
WHERE Inventario.idInventario = tmp.Inventario_idInventario
)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkSum`()
    NO SQL
call preCheckSum(cantidadTotalInventario(),costoTotalInventario())$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `frenteDePareto`(IN `proveedor` VARCHAR(45))
    NO SQL
call preFrenteDePareto(cantidadTotalInventario() ,costoTotalInventario(), proveedor)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `frenteDeParetoOrdenado`()
    NO SQL
call preProductosEstrella(cantidadTotalInventario(), costoTotalInventario(), 2.0)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `preCheckSum`(IN `totalDePiezas` DOUBLE UNSIGNED, IN `costoDelInventario` DOUBLE UNSIGNED)
    NO SQL
SELECT SUM(porcentajeDeCostoTotal) AS pc, SUM(porcentajeDeInventario) AS pi FROM (SELECT clave, Inventario.nombre, cantidad, costoUnitario, (cantidad*costoUnitario) AS costoDeLote, ((cantidad*costoUnitario)/costoDelInventario) AS porcentajeDeCostoTotal ,(cantidad/totalDePiezas) AS porcentajeDeInventario , Proveedores.nombre AS proveedor FROM Inventario, Proveedores WHERE Proveedores.nombre = 'Samsung' ORDER BY porcentajeDeCostoTotal DESC) as tmp$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `preFrenteDePareto`(IN `totalDePiezas` DOUBLE UNSIGNED, IN `costoDelInventario` DOUBLE UNSIGNED, IN `prov` VARCHAR(45))
    NO SQL
BEGIN
SET @pos=0;
SELECT (@pos:=@pos+1) as pos, clave, nombre, cantidad, costoUnitario, costoDeLote, demanda, porcentajeDeCostoTotal, porcentajeDeInventario, proveedor FROM 
(SELECT clave, Inventario.nombre, cantidad, costoUnitario, (cantidad*costoUnitario) AS costoDeLote, demanda,((cantidad*costoUnitario)/costoDelInventario) AS porcentajeDeCostoTotal ,(cantidad/totalDePiezas) AS porcentajeDeInventario , Proveedores.nombre AS proveedor FROM Inventario, Proveedores WHERE Proveedores.nombre = prov ORDER BY porcentajeDeCostoTotal DESC) AS tmptable;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `preProductosEstrella`(IN `totalDePiezas` DOUBLE UNSIGNED, IN `costoDelInventario` DOUBLE UNSIGNED, IN `porcentaje` DOUBLE UNSIGNED)
    NO SQL
BEGIN
SET @posI=0;
SET @posC=0;
SET @pos2=0;
SELECT * FROM
(SELECT (@pos2:=@pos2+1) as pos,
(SELECT SUM(porcentajeDeCostoTotal) FROM
(SELECT (@posC:=@posC+1) as pos, clave, nombre, cantidad, costoUnitario, costoDeLote, demanda, porcentajeDeCostoTotal, porcentajeDeInventario, proveedor FROM 
(SELECT clave, Inventario.nombre, cantidad, costoUnitario, (cantidad*costoUnitario) AS costoDeLote, demanda, ((cantidad*costoUnitario)/costoDelInventario) AS porcentajeDeCostoTotal ,(cantidad/totalDePiezas) AS porcentajeDeInventario , Proveedores.nombre AS proveedor FROM Inventario, Proveedores WHERE Proveedores.nombre = 'Samsung' ORDER BY porcentajeDeCostoTotal DESC) AS tmptable) AS inception
WHERE inception.pos <= @pos2) as porcentajeDeCostoAcumulado,
(SELECT SUM(porcentajeDeInventario) FROM
(SELECT (@posI:=@posI+1) as pos, clave, nombre, cantidad, costoUnitario, costoDeLote, demanda, porcentajeDeCostoTotal, porcentajeDeInventario, proveedor FROM 
(SELECT clave, Inventario.nombre, cantidad, costoUnitario, (cantidad*costoUnitario) AS costoDeLote, demanda, ((cantidad*costoUnitario)/costoDelInventario) AS porcentajeDeCostoTotal ,(cantidad/totalDePiezas) AS porcentajeDeInventario , Proveedores.nombre AS proveedor FROM Inventario, Proveedores WHERE Proveedores.nombre = 'Samsung' ORDER BY porcentajeDeCostoTotal DESC) AS tmptable) AS inception
WHERE inception.pos <= @pos2) as porcentajeDeInventarioAcumulado, clave, nombre, cantidad, costoUnitario, costoDeLote, demanda, porcentajeDeCostoTotal, porcentajeDeInventario, proveedor, (SELECT costoDeOrden FROM Proveedores WHERE final.Proveedores_idProveedores = Proveedores.idProveedores) AS costoDeOrden, costoDeAlmacenamiento, idInventario FROM 
(SELECT clave, Inventario.nombre, cantidad, costoUnitario, (cantidad*costoUnitario) AS costoDeLote, demanda, ((cantidad*costoUnitario)/costoDelInventario) AS porcentajeDeCostoTotal ,(cantidad/totalDePiezas) AS porcentajeDeInventario , Proveedores.nombre AS proveedor, Proveedores_idProveedores, costoDeAlmacenamiento, idInventario FROM Inventario, Proveedores WHERE Proveedores.nombre = 'Samsung' ORDER BY porcentajeDeCostoTotal DESC) AS final
) AS really 
WHERE porcentajeDeInventarioAcumulado <= porcentaje;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `productosEstrella`()
    NO SQL
call preProductosEstrella(cantidadTotalInventario(), costoTotalInventario(), 0.21)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `uberConsulta`()
    NO SQL
SELECT clave, Inventario.nombre, cantidad, costoUnitario, (cantidad*costoUnitario) AS costoDeLote, ((cantidad*costoUnitario)/(SELECT SUM( valorEnInventario ) FROM ( SELECT (cantidad * costoUnitario) AS valorEnInventario FROM Inventario, Proveedores WHERE Proveedores.nombre =  'Samsung') AS TablaDeValoresEnInventario)) AS porcentajeDeCostoTotal ,(cantidad/(SELECT SUM(cantidad) FROM Inventario)) AS porcentajeDeInventario , Proveedores.nombre AS proveedor FROM Inventario, Proveedores WHERE Proveedores.nombre = 'Samsung' ORDER BY porcentajeDeCostoTotal DESC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `verDemanda`()
    NO SQL
select idInventario, (select sum(cantidad)  from (SELECT * FROM ventas where fecha between date_add(current_date(), interval -1 YEAR) and current_date()) as tmp where Inventario.idInventario = tmp.Inventario_idInventario) as demanda from Inventario$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `cantidadTotalInventario`() RETURNS double unsigned
    NO SQL
BEGIN
DECLARE total DOUBLE;
SELECT SUM(cantidad) INTO total FROM Inventario;
RETURN total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `costoTotalInventario`() RETURNS double unsigned
    NO SQL
BEGIN
DECLARE total DOUBLE;
SELECT SUM( valorEnInventario ) INTO total FROM ( SELECT (cantidad * costoUnitario) AS valorEnInventario FROM Inventario, Proveedores WHERE Proveedores.nombre =  'Samsung') AS TablaDeValoresEnInventario;
RETURN total;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `descuento`
--

CREATE TABLE IF NOT EXISTS `descuento` (
  `idDescuento` int(11) NOT NULL AUTO_INCREMENT,
  `descuento` double DEFAULT NULL,
  `loteMin` int(11) NOT NULL,
  `loteMax` int(11) DEFAULT NULL,
  `Proveedores_idProveedores` int(11) NOT NULL,
  `Inventario_id` int(11) NOT NULL,
  PRIMARY KEY (`idDescuento`),
  KEY `fk_Descuento_Proveedores1_idx` (`Proveedores_idProveedores`),
  KEY `fk_Descuento_Inventario1_idx` (`Inventario_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=145 ;

--
-- Volcado de datos para la tabla `descuento`
--

INSERT INTO `descuento` (`idDescuento`, `descuento`, `loteMin`, `loteMax`, `Proveedores_idProveedores`, `Inventario_id`) VALUES
(1, 0, 1, 999999, 2, 822),
(2, 0, 1, 999999, 2, 823),
(3, 0, 1, 999999, 2, 824),
(4, 0, 1, 999999, 2, 825),
(5, 0, 1, 999999, 2, 826),
(6, 0, 1, 999999, 2, 827),
(7, 0, 1, 999999, 2, 828),
(8, 0, 1, 999999, 2, 829),
(9, 0, 1, 999999, 2, 830),
(10, 0, 1, 999999, 2, 831),
(11, 0, 1, 999999, 2, 832),
(12, 0, 1, 999999, 2, 833),
(13, 0, 1, 999999, 2, 834),
(14, 0, 1, 999999, 2, 835),
(15, 0, 1, 999999, 2, 836),
(16, 0, 1, 999999, 2, 837),
(17, 0, 1, 999999, 2, 838),
(18, 0, 1, 999999, 2, 839),
(19, 0, 1, 999999, 2, 840),
(20, 0, 1, 999999, 2, 841),
(21, 0, 1, 999999, 2, 842),
(22, 0, 1, 999999, 2, 843),
(23, 0, 1, 999999, 2, 844),
(24, 0, 1, 999999, 2, 845),
(25, 0, 1, 999999, 2, 846),
(26, 0, 1, 999999, 2, 847),
(27, 0, 1, 999999, 2, 848),
(28, 0, 1, 999999, 2, 849),
(29, 0, 1, 999999, 2, 850),
(30, 0, 1, 999999, 2, 851),
(31, 0, 1, 999999, 2, 852),
(32, 0, 1, 999999, 2, 853),
(33, 0, 1, 999999, 2, 854),
(34, 0, 1, 999999, 2, 855),
(35, 0, 1, 999999, 2, 856),
(36, 0, 1, 999999, 2, 857),
(37, 0, 1, 999999, 2, 858),
(38, 0, 1, 999999, 2, 859),
(39, 0, 1, 999999, 2, 860),
(40, 0, 1, 999999, 2, 861),
(41, 0, 1, 999999, 2, 862),
(42, 0, 1, 999999, 2, 863),
(43, 0, 1, 999999, 2, 864),
(44, 0, 1, 999999, 2, 865),
(45, 0, 1, 999999, 2, 866),
(46, 0, 1, 999999, 2, 867),
(47, 0, 1, 999999, 2, 868),
(48, 0, 1, 999999, 2, 869),
(49, 0, 1, 999999, 2, 870),
(50, 0, 1, 999999, 2, 871),
(51, 0, 1, 999999, 2, 872),
(52, 0, 1, 999999, 2, 873),
(53, 0, 1, 999999, 2, 874),
(54, 0, 1, 999999, 2, 875),
(55, 0, 1, 999999, 2, 876),
(56, 0, 1, 999999, 2, 877),
(57, 0, 1, 999999, 2, 878),
(58, 0, 1, 999999, 2, 879),
(59, 0, 1, 999999, 2, 880),
(60, 0, 1, 999999, 2, 881),
(61, 0, 1, 999999, 2, 882),
(62, 0, 1, 999999, 2, 883),
(63, 0, 1, 999999, 2, 884),
(64, 0, 1, 999999, 2, 885),
(65, 0, 1, 999999, 2, 886),
(66, 0, 1, 999999, 2, 887),
(67, 0, 1, 999999, 2, 888),
(68, 0, 1, 999999, 2, 889),
(69, 0, 1, 999999, 2, 890),
(70, 0, 1, 19, 2, 891),
(71, 0, 1, 999999, 2, 892),
(72, 0, 1, 999999, 2, 893),
(73, 0, 1, 999999, 2, 894),
(74, 0, 1, 999999, 2, 895),
(75, 0, 1, 999999, 2, 896),
(76, 0, 1, 999999, 2, 897),
(77, 0, 1, 999999, 2, 898),
(78, 0, 1, 999999, 2, 899),
(79, 0, 1, 999999, 2, 900),
(80, 0, 1, 999999, 2, 901),
(81, 0, 1, 999999, 2, 902),
(82, 0, 1, 999999, 2, 903),
(83, 0, 1, 999999, 2, 904),
(84, 0, 1, 9, 2, 905),
(85, 0, 1, 999999, 2, 906),
(86, 0, 1, 999999, 2, 907),
(87, 0, 1, 999999, 2, 908),
(88, 0, 1, 999999, 2, 909),
(89, 0, 1, 999999, 2, 910),
(90, 0, 1, 999999, 2, 911),
(91, 0, 1, 999999, 2, 912),
(92, 0, 1, 999999, 2, 913),
(93, 0, 1, 999999, 2, 914),
(94, 0, 1, 999999, 2, 915),
(95, 0, 1, 999999, 2, 916),
(96, 0, 1, 999999, 2, 917),
(97, 0, 1, 999999, 2, 918),
(98, 0, 1, 9, 2, 919),
(99, 0, 1, 999999, 2, 920),
(100, 0, 1, 999999, 2, 921),
(101, 0, 1, 999999, 2, 922),
(102, 0, 1, 999999, 2, 923),
(103, 0, 1, 9, 2, 924),
(104, 0, 1, 999999, 2, 925),
(105, 0, 1, 999999, 2, 926),
(106, 0, 1, 999999, 2, 927),
(107, 0, 1, 6, 2, 928),
(108, 0, 1, 999999, 2, 929),
(109, 0, 1, 999999, 2, 930),
(110, 0, 1, 999999, 2, 931),
(111, 0, 1, 7, 2, 932),
(112, 0, 1, 7, 2, 933),
(113, 0, 1, 999999, 2, 934),
(114, 0, 1, 4, 2, 935),
(115, 0, 1, 9, 2, 936),
(116, 0, 1, 4, 2, 937),
(117, 0, 1, 4, 2, 938),
(118, 0, 1, 4, 2, 939),
(119, 0, 1, 4, 2, 940),
(120, 0, 1, 9, 2, 941),
(121, 0, 1, 4, 2, 942),
(122, 0, 1, 4, 2, 943),
(123, 0, 1, 9, 2, 944),
(124, 0, 1, 2, 2, 945),
(125, 0, 1, 2, 2, 946),
(126, 0.1, 10, 9, 2, 944),
(127, 0.1, 10, 9, 2, 941),
(128, 0.1, 3, 2, 2, 946),
(129, 0.1, 3, 2, 2, 945),
(130, 0.1, 5, 4, 2, 938),
(131, 0.1, 5, 4, 2, 943),
(132, 0.1, 5, 4, 2, 942),
(133, 0.1, 5, 4, 2, 940),
(134, 0.1, 5, 4, 2, 939),
(135, 0.1, 20, 19, 2, 891),
(136, 0.1, 5, 4, 2, 937),
(137, 0.1, 7, 6, 2, 928),
(138, 0.1, 10, 9, 2, 936),
(139, 0.1, 10, 9, 2, 919),
(140, 0.1, 5, 4, 2, 935),
(141, 0.1, 8, 7, 2, 933),
(142, 0.1, 8, 7, 2, 932),
(143, 0.1, 10, 9, 2, 924),
(144, 0.1, 10, 9, 2, 905);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventario`
--

CREATE TABLE IF NOT EXISTS `inventario` (
  `idInventario` int(11) NOT NULL AUTO_INCREMENT,
  `clave` varchar(45) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `costoUnitario` double NOT NULL,
  `Proveedores_idProveedores` int(11) NOT NULL,
  `costoDeAlmacenamiento` double DEFAULT NULL,
  `demanda` int(11) NOT NULL,
  PRIMARY KEY (`idInventario`),
  KEY `fk_Inventario_Proveedores_idx` (`Proveedores_idProveedores`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=947 ;

--
-- Volcado de datos para la tabla `inventario`
--

INSERT INTO `inventario` (`idInventario`, `clave`, `nombre`, `cantidad`, `costoUnitario`, `Proveedores_idProveedores`, `costoDeAlmacenamiento`, `demanda`) VALUES
(822, 'DA34-00050A', 'SWITCH DOOR-WATER RESISTANT - 1 BUTTON P', 2, 21.25, 2, 0.22, 8),
(823, 'DA32-00006R', 'SENSOR TEMP-PANTRY PX-41C  502AT AW-PJT', 1, 33.84, 2, 0.22, 4),
(824, 'DA47-10160L', 'THERMO BIMETAL TGV2-PJT 125/250V 10/5A 4', 2, 42.17, 2, 0.22, 8),
(825, 'DA32-00006D', 'SENSOR TEMP-DEFROST-SENSOR(SVC) PX-41C', 2, 45.4, 2, 0.22, 8),
(826, 'DA32-00027B', 'SENSOR TEMP 502AT AW-PJT -40-110? 5V - -', 2, 56.99, 2, 0.22, 8),
(827, 'DA32-00027D', 'SENSOR TEMP 502AT AW-PJT -40-110? 5V - -', 3, 64.46, 2, 0.22, 12),
(828, 'DA47-00243S', 'THERMO BIMETAL-PROTECTOR AW-PJT(R) BT-12', 1, 72.29, 2, 0.22, 4),
(829, 'JC66-02709A', 'ROLLER-TRANSFER Bluejay 12.5 (mm) NBR+EC', 2, 76.73, 2, 0.22, 8),
(830, 'DE94-01732B', 'ASSY CONTROL PANEL AMW8113W WHITE ABS LA', 2, 84.91, 2, 0.22, 8),
(831, 'BN96-21741A', 'ASSY GUIDE P-STAND UE5000 32 UO ABS HB B', 2, 103.66, 2, 0.22, 8),
(832, 'BN39-01475B', 'LEAD CONNECTOR UN40C6400 Falt Connector', 2, 109.13, 2, 0.22, 8),
(833, 'AH59-01662E', 'REMOCON-ASSY HT-DT79 NOEUR - - 60 - - -', 2, 122.68, 2, 0.22, 8),
(834, 'BN39-01475C', 'LEAD CONNECTOR UN46C6500 Falt Connector', 2, 123.18, 2, 0.22, 8),
(835, 'AK94-00404K', 'ASSY PCB MAIN DVD-D360K ZX ASSY MAIN SEI', 1, 132.95, 2, 0.22, 4),
(836, 'AH59-02298A', 'REMOCON TM1051 MULTI 24P 49 3V C5500-1', 4, 133.06, 2, 0.22, 16),
(837, 'JC93-00530A', 'DRIVE-MOTOR STEP ML-2160 SEC XAA', 2, 135.56, 2, 0.22, 8),
(838, 'BN39-01475H', 'LEAD CONNECTOR-POWER CABLE E6K/7K/8K_55pulgad', 2, 140.6, 2, 0.22, 8),
(839, 'DE82-01051A', 'A/S ASSY-PCB AMW73F 0.7CUFT', 1, 155.15, 2, 0.22, 4),
(840, 'DA45-10003P', 'TIMER DEFROST TMDE807TD1 - 110-120V - 50', 4, 176.81, 2, 0.22, 16),
(841, 'AA59-00463A', 'REMOCON TM1050 49 3.0V NORTH AMERICA ALL', 2, 190.24, 2, 0.22, 8),
(842, 'BN96-25376A', 'ASSY BOARD P-RF-MODULE Bluetooth Module', 2, 209.24, 2, 0.22, 8),
(843, 'AH96-01457B', 'ASSY DECK P DP-30B', 1, 211.41, 2, 0.22, 4),
(844, 'AK97-02037C', 'ASSY PICK UP-DECK CMS-S78RFL', 1, 212.06, 2, 0.22, 4),
(845, 'BN96-18314E', 'ASSY BOARD P-TOUCH FUNCTION&IR LA32D400_', 1, 212.12, 2, 0.22, 4),
(846, 'DA92-00440A', 'ASSY PCB MAIN-E-TIMER SEM MAX3 AC 127V 6', 2, 219.53, 2, 0.22, 8),
(847, 'BN59-01148C', 'NETWORK WIDT-20R Internal WiFi USB IEEE8', 2, 220.54, 2, 0.22, 8),
(848, 'AH97-02261C', 'ASSY DECK MM-DX7 MEA - -', 2, 290.16, 2, 0.22, 8),
(849, 'AH59-01592A', 'DECK-CD CMS-S75RB MAGNET 23.2mm 3V SOH-D', 2, 305.21, 2, 0.22, 8),
(850, 'AK96-01785A', 'ASSY DECK P-DVD DP-31', 1, 313.2, 2, 0.22, 4),
(851, 'AH96-02267A', 'ASSY DECK P-CD DP-31A', 2, 317.21, 2, 0.22, 8),
(852, 'AH96-00892G', 'ASSY DECK P-DVD DP-31MX', 2, 343.37, 2, 0.22, 8),
(853, 'BN44-00506A', 'DC VSS-LED TV PD BD PD27A0Q_CDY AC/DC AC', 2, 349.38, 2, 0.22, 8),
(854, 'DA92-00066A', 'ASSY PCB MAIN MAX4-PJT Rotary TWIN PCB B', 4, 349.58, 2, 0.22, 16),
(855, 'BA44-00242A', 'ADAPTOR 0335A1960 AD-6019R 19VDC 3.16A -', 4, 363.47, 2, 0.22, 16),
(856, 'DA97-08059A', 'ASSY ICE MAKER-MECH SSEDA HIT VALUE', 2, 390.26, 2, 0.22, 8),
(857, 'BN96-26401E', 'ASSY BOARD P-JOG SWITCH & IR UE40F6400 F', 2, 392.65, 2, 0.22, 8),
(858, 'BN44-00448A', 'DC VSS-LED TV PD BD PD22A0_BDY AC/DC AC1', 2, 417.63, 2, 0.22, 8),
(859, 'AD97-23327A', 'ASSY LCD WB30F WHITE', 2, 438.78, 2, 0.22, 8),
(860, 'DA92-00440A', 'ASSY PCB MAIN-E-TIMER SEM MAX3 AC 127V 6', 2, 439.06, 2, 0.22, 8),
(861, 'BN44-00593A', 'DC VSS(A) A4514-DSM TC750 14 3.21A Exter', 2, 439.86, 2, 0.22, 8),
(862, 'AD97-21562A', 'ASSY STROBO-BK W/W BLACK', 2, 440.01, 2, 0.22, 8),
(863, 'AH59-02289A', 'DECK-MECHA ASSY(CKD) BD-E1 MX-C630 / MX-', 2, 465.57, 2, 0.22, 8),
(864, 'AK94-00439C', 'ASSY PCB SMPS BD-D5300/ZD', 2, 470.79, 2, 0.22, 8),
(865, 'JC92-02397G', 'PBA-MAIN ML-2160W MAIN MEXICO / XAX 64.2', 1, 495.32, 2, 0.22, 4),
(866, 'AH96-01628B', 'ASSY DECK P-HTS PLAYER BD-P8 Insouring S', 1, 503.38, 2, 0.22, 4),
(867, 'BN44-00554B', 'DC VSS-LED TV PD BD PD32GV0_CHS PD32GV0_', 5, 552.37, 2, 0.22, 20),
(868, 'DA97-07190J', 'ASSY COVER-EVAP REF AW-SEM(266 265) Wate', 3, 555.01, 2, 0.22, 12),
(869, 'BN44-00472B', 'DC VSS-LED TV PD BD PD32G0S_BSM PSLF800A', 2, 555.88, 2, 0.22, 8),
(870, 'AH94-02449E', 'ASSY PCB SMPS HT-C5500_Manual BD HTS 1', 2, 559.19, 2, 0.22, 8),
(871, 'BN96-22413Q', 'ASSY BOARD P-JOG SWITCH & IR UN40EH5300F', 5, 567.94, 2, 0.22, 20),
(872, 'BN44-00605A', 'DC VSS-LED TV PD BD L32SF_DSM PSLF770S05', 1, 583.74, 2, 0.22, 4),
(873, 'BN44-00369A', 'AC VSS(I)-TV PSIV121510A I32HD_ASM 11mA', 1, 586.03, 2, 0.22, 4),
(874, 'BN96-23838D', 'ASSY BOARD P-JOG SWITCH & IR UN46EH6030', 2, 590.7, 2, 0.22, 8),
(875, 'JC92-02393C', 'PBA-MAIN ML-2160 SEC MAIN DOM 64.25mmX90', 4, 644.62, 2, 0.22, 16),
(876, 'BN44-00505A', 'DC VSS-LED TV PD BD PD23A0Q_CSM AC/DC AC', 2, 645.76, 2, 0.22, 8),
(877, 'BN96-22413R', 'ASSY BOARD P-JOG SWITCH & IR UN46EH5300F', 4, 651.79, 2, 0.22, 16),
(878, 'BN44-00192A', 'DC VSS-LCD TV MK32P3 DYREL AC/DC -20 to', 2, 665.21, 2, 0.22, 8),
(879, 'AH94-02838A', 'ASSY PCB SMPS-PBA HT-E3500E4500E5500 ZA', 1, 676.73, 2, 0.22, 4),
(880, 'AD97-23321A', 'ASSY BARREL-DV150F_SV DV150F NON CCD SIL', 3, 701.68, 2, 0.22, 12),
(881, 'BN44-00496B', 'DC VSS-LED TV PD BD PD40AVF_CDY PD40AVF_', 2, 714.26, 2, 0.22, 8),
(882, 'AD97-22091A', 'ASSY BARREL-NON_OIS_LSILVER_D5 D5 NON CC', 1, 714.87, 2, 0.22, 4),
(883, 'BN44-00439A', 'AC VSS(I)-TV PSIV181411A I37F1_BSM 63kHz', 1, 716.59, 2, 0.22, 4),
(884, 'BN44-00493A', 'DC VSS-LED TV PD BD PD32AVF_CSM PSLF570A', 2, 721.67, 2, 0.22, 8),
(885, 'BN96-22413P', 'ASSY BOARD P-JOG SWITCH & IR UN32EH5300F', 2, 735.94, 2, 0.22, 8),
(886, 'AD92-01945A', 'ASSY PCB MAIN-ST66 VE ASSY PCB MAIN DSC', 2, 757.34, 2, 0.22, 8),
(887, 'DC92-00317B', 'ASSY PCB MAIN Latin Max 120V/60HZ LED DC', 2, 777.61, 2, 0.22, 8),
(888, 'BN44-00645A', 'DC VSS-LED TV PD BD L42S1_DSM PSLF121S05', 2, 826.64, 2, 0.22, 8),
(889, 'AD92-02055A', 'ASSY PCB MAIN-ST150F ST150F MAIN PCB ASS', 1, 888.44, 2, 0.22, 4),
(890, 'BN44-00261A', 'AC VSS(I) PSIV161C01A H32F1_9SS 0.12mA 1', 1, 901.26, 2, 0.22, 4),
(891, 'JC91-01076A', 'FUSER ML-2160 SEC 110V', 15, 903.87, 2, 0.22, 60),
(892, 'BN44-00498B', 'DC VSS-LED TV PD BD PD46AV1_CHS PD46AV1_', 6, 914.95, 2, 0.22, 24),
(893, 'BN44-00499A', 'DC VSS-LED TV PD BD PD55AV1_CHS PD55AV1_', 1, 926.31, 2, 0.22, 4),
(894, 'AD92-01784A', 'ASSY PCB MAIN DSC ST77 ASSY PCB MAIN', 2, 927.78, 2, 0.22, 8),
(895, 'BN44-00473A', 'DC VSS-LED TV PD BD PD46G0_BSM PSLF121A0', 2, 930.25, 2, 0.22, 8),
(896, 'BN94-05971W', 'ASSY PCB MAIN UN39EH5003FXZX', 2, 982.88, 2, 0.22, 8),
(897, 'JC92-02483H', 'PBA-MAIN CLP-365W XAX MAIN 71.75X130mm F', 5, 984.52, 2, 0.22, 20),
(898, 'JC96-05133A', 'ELA UNIT-FUSER SCX-4828FN SEC - 110V - -', 2, 1017.92, 2, 0.22, 8),
(899, 'BN44-00338B', 'DC VSS-LCD TV P2632HD_ADY P2632HD_ADY AC', 2, 1049.43, 2, 0.22, 8),
(900, 'BN96-25782A', 'ASSY PCB P-MAIN TS-UN32EH5000FXZX BN94-0', 1, 1055.7, 2, 0.22, 4),
(901, 'DA41-00219A', 'ASSY PCB MAIN AD CABI FR-1 197*148 VALUE', 2, 1061.42, 2, 0.22, 8),
(902, 'BN96-09336A', 'ASSY PDP P-Y-MAIN BOARD S42AX-YB05 PL42A', 1, 1071.76, 2, 0.22, 4),
(903, 'BN94-05978Z', 'ASSY PCB MAIN UN32EH4000FXZX', 1, 1121.91, 2, 0.22, 4),
(904, 'DA97-10847B', 'ASSY COVER-EVAP FRE MAX4 No-LED  V/M/C-o', 4, 1125.54, 2, 0.22, 16),
(905, 'BN44-00552A', 'DC VSS-LED TV PD BD PD46CV1_CSM PSLF930C', 5, 1152, 2, 0.22, 20),
(906, 'JC92-02433A', 'PBA-MAIN SCX-3400 SEC MAIN XAA 71.75mmX1', 1, 1173.76, 2, 0.22, 4),
(907, 'BN44-00440B', 'AC VSS(I)-TV PSIV231411A I40F1_BSM 45kHz', 2, 1187.4, 2, 0.22, 8),
(908, 'AH82-00199Q', 'A/S ASSY-(MAIN PCB) MM-C430D Latin Ameri', 2, 1337.12, 2, 0.22, 8),
(909, 'BN63-10320A', 'COVER-FRAME TOP UF8000 55pulgadas  AL EXTRUSI', 2, 1398.76, 2, 0.22, 8),
(910, 'BN94-05897N', 'ASSY PCB MAIN UN55EH6030FXZX', 2, 1428.53, 2, 0.22, 8),
(911, 'BN94-06230P', 'ASSY PCB MISC-MAIN ATSC F4900 NVATSCF-00', 2, 1443.63, 2, 0.22, 8),
(912, 'BP96-01579A', 'ASSY COLOR WHEEL P K220 SVC', 2, 1529.58, 2, 0.22, 8),
(913, 'AH94-02946A', 'ASSY PCB MAIN HT-E3500', 1, 1530.89, 2, 0.22, 4),
(914, 'BN94-05897B', 'ASSY PCB MAIN UN46EH6030FXZX', 2, 1544.25, 2, 0.22, 8),
(915, 'BN94-05897A', 'ASSY PCB MAIN UN40EH6030FXZX', 3, 1569.45, 2, 0.22, 12),
(916, 'AD97-21845A', 'ASSY BARREL-WB150 WB150 NON BLACK', 2, 1603.21, 2, 0.22, 8),
(917, 'BN44-00440B', 'AC VSS(I)-TV I40F1_BHS I40F1_BHS 45kHz 1', 2, 1617.67, 2, 0.22, 8),
(918, 'BN96-16390A', 'ASSY PCB P-MAIN BN94-03983T LN40C530F1FX', 1, 1686.63, 2, 0.22, 4),
(919, 'BN44-00522A', 'DC VSS-LED TV PD BD PD46B2Q_CSM PSLF131Q', 4, 1879.23, 2, 0.22, 16),
(920, 'BN96-22617A', 'ASSY PDP P-Y-BUFFER(UP) 43EV Y-BUFFER(UP', 1, 1899.23, 2, 0.22, 4),
(921, 'AH94-03043A', 'ASSY PCB MAIN MX-FS9000 MINI COMPONENT X', 2, 1948.67, 2, 0.22, 8),
(922, 'BN44-00523A', 'DC VSS-LED TV PD BD PD55B2Q_CSM PSLF151Q', 1, 1981.56, 2, 0.22, 4),
(923, 'BN96-22084A', 'ASSY PDP P-LOGIC MAIN 43EH LOGIC MAIN', 2, 2002.5, 2, 0.22, 8),
(924, 'BN94-05917T', 'ASSY PCB MAIN UN40EH5300FXZX', 3, 2076.03, 2, 0.22, 12),
(925, 'BN94-05750R', 'ASSY PCB MAIN UN46EH5300FXZX', 2, 2113.98, 2, 0.22, 8),
(926, 'BN94-06175E', 'ASSY PCB MAIN F5000', 1, 2173.62, 2, 0.22, 4),
(927, 'BN94-06169E', 'ASSY PCB MAIN F6400 60 ZA', 2, 2199.29, 2, 0.22, 8),
(928, 'BN94-05559S', 'ASSY PCB MAIN UN32EH5300FXZX', 5, 2277.14, 2, 0.22, 20),
(929, 'BN96-22615A', 'ASSY PDP P-Y-MAIN 43EV Y-MAIN', 1, 2402.61, 2, 0.22, 4),
(930, 'BN94-05144A', 'ASSY PCB MAIN BN94-05038L UN40D6400UFXZX', 1, 2766, 2, 0.22, 4),
(931, 'BN07-01043A', 'LCD-PANEL LTM185AT05-V SS8YTUV 6bit Hi-F', 1, 2836.51, 2, 0.22, 4),
(932, 'BN94-05586U', 'ASSY PCB MAIN 55 ES8000 ZX', 2, 3536.21, 2, 0.22, 8),
(933, 'BN96-09738A', 'ASSY PDP P-Y-MAIN BOARD S50HW-YB04 PL50H', 2, 3643.06, 2, 0.22, 8),
(934, 'BN07-01076A', 'LCD-PANEL M215HGE-L21 CML5E21A 6bit Hi-F', 1, 3968.6, 2, 0.22, 4),
(935, 'BN07-01231A', 'LCD-PANEL DE320AGH-C1 CED4AH1 8bit 32 IN', 1, 7502.23, 2, 0.22, 4),
(936, 'BN95-00707A', 'PRODUCT LCD-BOE 4k 32pulgadas  LED DE320AGE-V', 1, 7613.3, 2, 0.22, 4),
(937, 'BN95-00586A', 'PRODUCT LCD-AMLCD 5k 32pulgadas  Direct-LED L', 1, 11536.23, 2, 0.22, 4),
(938, 'BN95-00887A', 'PRODUCT LCD-AMLCD LSF400HM02 CY-HF400BGL', 2, 12227.41, 2, 0.22, 8),
(939, 'BN95-00698A', 'PRODUCT LCD-AMLCD E6030  40pulgadas 3D  Direc', 1, 14152.63, 2, 0.22, 4),
(940, 'BN95-00587A', 'PRODUCT LCD-AMLCD 5k 40pulgadas  Direct-LED L', 1, 16045.05, 2, 0.22, 4),
(941, 'BN95-00611A', 'PRODUCT LCD-AMLCD 6.5K  LTJ400HV05-V 3D', 2, 16833.21, 2, 0.22, 8),
(942, 'BN07-01140A', 'LCD-PANEL DE500BGM-C1 CEDBBM1 8bit 50 IN', 1, 17919.15, 2, 0.22, 4),
(943, 'BN95-00839A', 'PRODUCT LCD-AUO CY-DE500BGAV1V DE500BGA-', 1, 18072.24, 2, 0.22, 4),
(944, 'BN95-00589A', 'PRODUCT LCD-AMLCD 5k 46pulgadas  Direct-LED L', 4, 19130.42, 2, 0.22, 16),
(945, 'BN95-00900A', 'PRODUCT LCD-AMLCD LSF460HQ01 CY-KF460DSL', 1, 24764.17, 2, 0.22, 4),
(946, 'BN95-00901A', 'PRODUCT LCD-AMLCD LSF550HQ01 CY-SF550DSL', 1, 30908.79, 2, 0.22, 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE IF NOT EXISTS `proveedores` (
  `idProveedores` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `direccion` varchar(45) DEFAULT NULL,
  `telefono` varchar(45) DEFAULT NULL,
  `costoDeOrden` double DEFAULT NULL,
  PRIMARY KEY (`idProveedores`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`idProveedores`, `nombre`, `direccion`, `telefono`, `costoDeOrden`) VALUES
(2, 'Samsung', 'Calle Monte Alban No. 310, Col. Benito Juarez', '01 800 726-7864', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE IF NOT EXISTS `ventas` (
  `idVentas` int(11) NOT NULL AUTO_INCREMENT,
  `cantidad` int(11) DEFAULT NULL,
  `importe` double DEFAULT NULL,
  `Inventario_idInventario` int(11) NOT NULL,
  `fecha` date DEFAULT NULL,
  PRIMARY KEY (`idVentas`),
  KEY `fk_Ventas_Inventario1_idx` (`Inventario_idInventario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Disparadores `ventas`
--
DROP TRIGGER IF EXISTS `acDemanda`;
DELIMITER //
CREATE TRIGGER `acDemanda` AFTER INSERT ON `ventas`
 FOR EACH ROW call actualizarDemanda()
//
DELIMITER ;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `descuento`
--
ALTER TABLE `descuento`
  ADD CONSTRAINT `fk_Descuento_Inventario1` FOREIGN KEY (`Inventario_id`) REFERENCES `inventario` (`idInventario`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Descuento_Proveedores1` FOREIGN KEY (`Proveedores_idProveedores`) REFERENCES `proveedores` (`idProveedores`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD CONSTRAINT `fk_Inventario_Proveedores` FOREIGN KEY (`Proveedores_idProveedores`) REFERENCES `proveedores` (`idProveedores`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `fk_Ventas_Inventario1` FOREIGN KEY (`Inventario_idInventario`) REFERENCES `inventario` (`idInventario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
