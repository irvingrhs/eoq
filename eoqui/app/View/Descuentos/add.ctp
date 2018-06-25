<div class="descuentos form">
<?php echo $this->Form->create('Descuento'); ?>
	<fieldset>
		<legend><?php echo __('Agregar Descuento'); ?></legend>
	<?php
		echo $this->Form->input('descuento');
		echo $this->Form->input('loteMin');
		echo $this->Form->input('loteMax');
		echo $this->Form->select('Proveedores_idProveedores', $listaProveedores, array('type'=>'select', 'empty' => 'Seleccione Proveedor'));
		echo $this->Form->select('Inventario_id', $listaInventarios, array('type'=>'select', 'empty' => 'Seleccione el producto'));
	?>
	</fieldset>
<?php echo $this->Form->end(__('Agregar')); ?>
</div>
<div class="actions">
	<h3><?php echo __('Acciones'); ?></h3>
	<ul>

		<li><?php echo $this->Html->link(__('Lista de Descuentos'), array('action' => 'index')); ?></li>
		<li><?php echo $this->Html->link(__('Lista de Proveedores'), array('controller' => 'proveedores', 'action' => 'index')); ?> </li>
		<li><?php echo $this->Html->link(__('Nuevo Proveedor'), array('controller' => 'proveedores', 'action' => 'add')); ?> </li>
		<li><?php echo $this->Html->link(__('Lista de Productos'), array('controller' => 'inventarios', 'action' => 'index')); ?> </li>
		<li><?php echo $this->Html->link(__('Nuevo Producto'), array('controller' => 'inventarios', 'action' => 'add')); ?> </li>
	</ul>
</div>
