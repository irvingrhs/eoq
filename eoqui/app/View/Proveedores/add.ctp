<div class="proveedores form">
<?php echo $this->Form->create('Proveedore'); ?>
	<fieldset>
		<legend><?php echo __('Agregar Proveedor'); ?></legend>
	<?php
		echo $this->Form->input('nombre');
		echo $this->Form->input('direccion');
		echo $this->Form->input('telefono');
		echo $this->Form->input('costoDeOrden');
	?>
	</fieldset>
<?php echo $this->Form->end(__('Agregar')); ?>
</div>
<div class="actions">
	<h3><?php echo __('Acciones'); ?></h3>
	<ul>

		<li><?php echo $this->Html->link(__('Lista de Proveedores'), array('action' => 'index')); ?></li>
	</ul>
</div>
