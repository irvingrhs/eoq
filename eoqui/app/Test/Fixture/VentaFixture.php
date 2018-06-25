<?php
/**
 * VentaFixture
 *
 */
class VentaFixture extends CakeTestFixture {

/**
 * Fields
 *
 * @var array
 */
	public $fields = array(
		'idVentas' => array('type' => 'integer', 'null' => false, 'default' => null, 'key' => 'primary'),
		'cantidad' => array('type' => 'integer', 'null' => true, 'default' => null),
		'importe' => array('type' => 'float', 'null' => true, 'default' => null),
		'Inventario_idInventario' => array('type' => 'integer', 'null' => false, 'default' => null, 'key' => 'index'),
		'fecha' => array('type' => 'date', 'null' => true, 'default' => null),
		'indexes' => array(
			'PRIMARY' => array('column' => 'idVentas', 'unique' => 1),
			'fk_Ventas_Inventario1_idx' => array('column' => 'Inventario_idInventario', 'unique' => 0)
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
			'idVentas' => 1,
			'cantidad' => 1,
			'importe' => 1,
			'Inventario_idInventario' => 1,
			'fecha' => '2013-11-25'
		),
	);

}
