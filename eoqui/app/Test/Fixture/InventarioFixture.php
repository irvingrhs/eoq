<?php
/**
 * InventarioFixture
 *
 */
class InventarioFixture extends CakeTestFixture {

/**
 * Table name
 *
 * @var string
 */
	public $table = 'inventario';

/**
 * Fields
 *
 * @var array
 */
	public $fields = array(
		'idInventario' => array('type' => 'integer', 'null' => false, 'default' => null, 'key' => 'primary'),
		'clave' => array('type' => 'string', 'null' => false, 'default' => null, 'length' => 45, 'collate' => 'utf8_general_ci', 'charset' => 'utf8'),
		'nombre' => array('type' => 'string', 'null' => false, 'default' => null, 'length' => 45, 'collate' => 'utf8_general_ci', 'charset' => 'utf8'),
		'cantidad' => array('type' => 'integer', 'null' => false, 'default' => null),
		'costoUnitario' => array('type' => 'float', 'null' => false, 'default' => null),
		'Proveedores_idProveedores' => array('type' => 'integer', 'null' => false, 'default' => null, 'key' => 'index'),
		'costoDeAlmacenamiento' => array('type' => 'float', 'null' => true, 'default' => null),
		'demanda' => array('type' => 'integer', 'null' => false, 'default' => null),
		'indexes' => array(
			'PRIMARY' => array('column' => 'idInventario', 'unique' => 1),
			'fk_Inventario_Proveedores_idx' => array('column' => 'Proveedores_idProveedores', 'unique' => 0)
		),
		'tableParameters' => array('charset' => 'utf8', 'collate' => 'utf8_general_ci', 'engine' => 'InnoDB')
	);

/**
 * Records
 *
 * @var array
 */
	public $records = array(
		array(
			'idInventario' => 1,
			'clave' => 'Lorem ipsum dolor sit amet',
			'nombre' => 'Lorem ipsum dolor sit amet',
			'cantidad' => 1,
			'costoUnitario' => 1,
			'Proveedores_idProveedores' => 1,
			'costoDeAlmacenamiento' => 1,
			'demanda' => 1
		),
	);

}
