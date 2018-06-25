<div class="inventarios view">
<h2><?php echo __('Inventario'); ?></h2>
	<dl>
		<dt><?php echo __('IdInventario'); ?></dt>
		<dd>
			<?php echo h($inventario['Inventario']['idInventario']); ?>
			&nbsp;
		</dd>
		<dt><?php echo __('Clave'); ?></dt>
		<dd>
			<?php echo h($inventario['Inventario']['clave']); ?>
			&nbsp;
		</dd>
		<dt><?php echo __('Nombre'); ?></dt>
		<dd>
			<?php echo h($inventario['Inventario']['nombre']); ?>
			&nbsp;
		</dd>
		<dt><?php echo __('Cantidad'); ?></dt>
		<dd>
			<?php echo h($inventario['Inventario']['cantidad']); ?>
			&nbsp;
		</dd>
		<dt><?php echo __('Costo unitario'); ?></dt>
		<dd>
			<?php echo h($inventario['Inventario']['costoUnitario']); ?>
			&nbsp;
		</dd>
		<dt><?php echo __('Proveedor'); ?></dt>
		<dd>
			<?php echo $this->Html->link($inventario['Proveedore']['nombre'], array('controller' => 'proveedores', 'action' => 'view', $inventario['Proveedore']['idProveedores'])); ?>
			&nbsp;
		</dd>
		<dt><?php echo __('Costo de almacenamiento'); ?></dt>
		<dd>
			<?php echo h($inventario['Inventario']['costoDeAlmacenamiento']); ?>
			&nbsp;
		</dd>
		<dt><?php echo __('Demanda'); ?></dt>
		<dd>
			<?php echo h($inventario['Inventario']['demanda']); ?>
			&nbsp;
		</dd>
	</dl>
</div>
<div class="actions">
	<h3><?php echo __('Acciones'); ?></h3>
	<ul>
		<li><?php echo $this->Html->link(__('Modificar Producto'), array('action' => 'edit', $inventario['Inventario']['idInventario'])); ?> </li>
		<li><?php echo $this->Form->postLink(__('Borrar Producto'), array('action' => 'delete', $inventario['Inventario']['idInventario']), null, __('¿Quiere borrar # %s?', $inventario['Inventario']['idInventario'])); ?> </li>
		<li><?php echo $this->Html->link(__('Lista de Productos'), array('action' => 'index')); ?> </li>
		<li><?php echo $this->Html->link(__('Nuevo Producto'), array('action' => 'add')); ?> </li>
		<li><?php echo $this->Html->link(__('Lista de Proveedores'), array('controller' => 'proveedores', 'action' => 'index')); ?> </li>
		<li><?php echo $this->Html->link(__('Nuevo Proveedor'), array('controller' => 'proveedores', 'action' => 'add')); ?> </li>
	</ul>
</div>
