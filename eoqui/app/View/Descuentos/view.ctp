<div class="descuentos view">
<h2><?php echo __('Descuento'); ?></h2>
	<dl>
		<dt><?php echo __('IdDescuento'); ?></dt>
		<dd>
			<?php echo h($descuento['Descuento']['idDescuento']); ?>
			&nbsp;
		</dd>
		<dt><?php echo __('Descuento'); ?></dt>
		<dd>
			<?php echo h($descuento['Descuento']['descuento']); ?>
			&nbsp;
		</dd>
		<dt><?php echo __('Lote m&iacute;nimo'); ?></dt>
		<dd>
			<?php echo h($descuento['Descuento']['loteMin']); ?>
			&nbsp;
		</dd>
		<dt><?php echo __('Lote m&aacute;ximo'); ?></dt>
		<dd>
			<?php echo h($descuento['Descuento']['loteMax']); ?>
			&nbsp;
		</dd>
		<dt><?php echo __('Proveedor'); ?></dt>
		<dd>
			<?php echo $this->Html->link($descuento['Proveedore']['nombre'], array('controller' => 'proveedores', 'action' => 'view', $descuento['Proveedore']['idProveedores'])); ?>
			&nbsp;
		</dd>
		<dt><?php echo __('Producto'); ?></dt>
		<dd>
			<?php echo $this->Html->link($descuento['Inventario']['nombre'], array('controller' => 'inventarios', 'action' => 'view', $descuento['Inventario']['idInventario'])); ?>
			&nbsp;
		</dd>
	</dl>
</div>
<div class="actions">
	<h3><?php echo __('Acciones'); ?></h3>
	<ul>
		<li><?php echo $this->Html->link(__('Modificar Descuento'), array('action' => 'edit', $descuento['Descuento']['idDescuento'])); ?> </li>
		<li><?php echo $this->Form->postLink(__('Borrar Descuento'), array('action' => 'delete', $descuento['Descuento']['idDescuento']), null, __('¿Quiere borrar # %s?', $descuento['Descuento']['idDescuento'])); ?> </li>
		<li><?php echo $this->Html->link(__('Lista de Descuentos'), array('action' => 'index')); ?> </li>
		<li><?php echo $this->Html->link(__('Nuevo Descuento'), array('action' => 'add')); ?> </li>
		<li><?php echo $this->Html->link(__('Lista de Proveedores'), array('controller' => 'proveedores', 'action' => 'index')); ?> </li>
		<li><?php echo $this->Html->link(__('Nuevo Proveedor'), array('controller' => 'proveedores', 'action' => 'add')); ?> </li>
		<li><?php echo $this->Html->link(__('Lista de Productos'), array('controller' => 'inventarios', 'action' => 'index')); ?> </li>
		<li><?php echo $this->Html->link(__('Nuevo Producto'), array('controller' => 'inventarios', 'action' => 'add')); ?> </li>
	</ul>
</div>
