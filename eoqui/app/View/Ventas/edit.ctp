<div class="ventas form">
<?php echo $this->Form->create('Venta'); ?>
	<fieldset>
		<legend><?php echo __('Modificar Venta'); ?></legend>
	<?php
		echo $this->Form->input('idVentas');
		echo $this->Form->input('cantidad');
		echo $this->Form->input('importe');
		echo $this->Form->select('Inventario_idInventario', $listaInventarios, array('type'=>'select', 'empty' => 'Seleccione el producto'));
		echo $this->Form->input('fecha');
	?>
	</fieldset>
<?php echo $this->Form->end(__('Modificar')); ?>
</div>
<div class="actions">
	<h3><?php echo __('Acciones'); ?></h3>
	<ul>

		<li><?php echo $this->Form->postLink(__('Borrar'), array('action' => 'delete', $this->Form->value('Venta.idVentas')), null, __('�Quiere borrar # %s?', $this->Form->value('Venta.idVentas'))); ?></li>
		<li><?php echo $this->Html->link(__('Lista de Ventas'), array('action' => 'index')); ?></li>
		<li><?php echo $this->Html->link(__('Lista de Productos'), array('controller' => 'inventarios', 'action' => 'index')); ?> </li>
		<li><?php echo $this->Html->link(__('Nuevo Producto'), array('controller' => 'inventarios', 'action' => 'add')); ?> </li>
	</ul>
</div>
