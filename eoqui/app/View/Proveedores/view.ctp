<div class="proveedores view">
<h2><?php echo __('Proveedores'); ?></h2>
	<dl>
		<dt><?php echo __('IdProveedores'); ?></dt>
		<dd>
			<?php echo h($proveedore['Proveedore']['idProveedores']); ?>
			&nbsp;
		</dd>
		<dt><?php echo __('Nombre'); ?></dt>
		<dd>
			<?php echo h($proveedore['Proveedore']['nombre']); ?>
			&nbsp;
		</dd>
		<dt><?php echo __('Direcci&oacute;n'); ?></dt>
		<dd>
			<?php echo h($proveedore['Proveedore']['direccion']); ?>
			&nbsp;
		</dd>
		<dt><?php echo __('Tel&eacute;fono'); ?></dt>
		<dd>
			<?php echo h($proveedore['Proveedore']['telefono']); ?>
			&nbsp;
		</dd>
		<dt><?php echo __('Costo de orden'); ?></dt>
		<dd>
			<?php echo h($proveedore['Proveedore']['costoDeOrden']); ?>
			&nbsp;
		</dd>
	</dl>
</div>
<div class="actions">
	<h3><?php echo __('Acciones'); ?></h3>
	<ul>
		<li><?php echo $this->Html->link(__('Modificar Proveedor'), array('action' => 'edit', $proveedore['Proveedore']['idProveedores'])); ?> </li>
		<li><?php echo $this->Form->postLink(__('Borrar Proveedor'), array('action' => 'delete', $proveedore['Proveedore']['idProveedores']), null, __('¿Quiere borrar # %s?', $proveedore['Proveedore']['idProveedores'])); ?> </li>
		<li><?php echo $this->Html->link(__('Lista de Proveedores'), array('action' => 'index')); ?> </li>
		<li><?php echo $this->Html->link(__('Agregar Proveedore'), array('action' => 'add')); ?> </li>
	</ul>
</div>
