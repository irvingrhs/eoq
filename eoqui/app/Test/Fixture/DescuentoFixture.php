<?php
/**
 * DescuentoFixture
 *
 */
class DescuentoFixture extends CakeTestFixture {

/**
 * Table name
 *
 * @var string
 */
	public $table = 'descuento';

/**
 * Fields
 *
 * @var array
 */
	public $fields = array(
		'idDescuento' => array('type' => 'integer', 'null' => false, 'default' => null, 'key' => 'primary'),
		'descuento' => array('type' => 'float', 'null' => true, 'default' => null),
		'loteMin' => array('type' => 'integer', 'null' => false, 'default' => null),
		'loteMax' => array('type' => 'integer', 'null' => true, 'default' => null),
		'Proveedores_idProveedores' => array('type' => 'integer', 'null' => false, 'default' => null, 'key' => 'index'),
		'Inventario_id' => array('type' => 'integer', 'null' => false, 'default' => null, 'key' => 'index'),
		'indexes' => array(
			'PRIMARY' => array('column' => 'idDescuento', 'unique' => 1),
			'fk_Descuento_Proveedores1_idx' => array('column' => 'Proveedores_idProveedores', 'unique' => 0),
			'fk_Descuento_Inventario1_idx' => array('column' => 'Inventario_id', 'unique' => 0)
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
			'idDescuento' => 1,
			'descuento' => 1,
			'loteMin' => 1,
			'loteMax' => 1,
			'Proveedores_idProveedores' => 1,
			'Inventario_id' => 1
		),
	);

}
