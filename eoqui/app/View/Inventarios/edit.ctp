<div class="inventarios form">
<?php echo $this->Form->create('Inventario'); ?>
	<fieldset>
		<legend><?php echo __('Modificar Producto'); ?></legend>
	<?php
		echo $this->Form->input('idInventario');
		echo $this->Form->input('clave');
		echo $this->Form->input('nombre');
		echo $this->Form->input('cantidad');
		echo $this->Form->input('costoUnitario');
		echo $this->Form->select('Proveedores_idProveedores', $listaProveedores, array('type'=>'select', 'empty' => 'Seleccione Proveedor'));
		echo $this->Form->input('costoDeAlmacenamiento');
		echo $this->Form->input('demanda');
	?>
	</fieldset>
<?php echo $this->Form->end(__('Modificar')); ?>
</div>
<div class="actions">
	<h3><?php echo __('Acciones'); ?></h3>
	<ul>

		<li><?php echo $this->Form->postLink(__('Borrar'), array('action' => 'delete', $this->Form->value('Inventario.idInventario')), null, __('¿Quiere borrar # %s?', $this->Form->value('Inventario.idInventario'))); ?></li>
		<li><?php echo $this->Html->link(__('Lista de Productos'), array('action' => 'index')); ?></li>
		<li><?php echo $this->Html->link(__('Lista de Proveedores'), array('controller' => 'proveedores', 'action' => 'index')); ?> </li>
		<li><?php echo $this->Html->link(__('Nuevo Proveedor'), array('controller' => 'proveedores', 'action' => 'add')); ?> </li>
	</ul>
</div>
