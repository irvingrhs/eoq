-- phpMyAdmin SQL Dump
-- version 4.0.4.1
-- http://www.phpmyadmin.net
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 26-11-2013 a las 18:48:12
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=61 ;

--
-- Volcado de datos para la tabla `descuento`
--



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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=821 ;

--
-- Volcado de datos para la tabla `inventario`
--



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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Volcado de datos para la tabla `proveedores`
--


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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=102 ;

--
-- Volcado de datos para la tabla `ventas`
--



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
