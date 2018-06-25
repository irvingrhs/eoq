<div class="descuentos index">
	<h2><?php echo __('Descuentos'); ?></h2>
	<table cellpadding="0" cellspacing="0">
	<tr>
			<th><?php echo $this->Paginator->sort('idDescuento'); ?></th>
			<th><?php echo $this->Paginator->sort('Descuento'); ?></th>
			<th><?php echo $this->Paginator->sort('LoteMin'); ?></th>
			<th><?php echo $this->Paginator->sort('LoteMax'); ?></th>
			<th><?php echo $this->Paginator->sort('Proveedor'); ?></th>
			<th><?php echo $this->Paginator->sort('Producto'); ?></th>
			<th class="actions"><?php echo __('Acciones'); ?></th>
	</tr>
	<?php foreach ($descuentos as $descuento): ?>
	<tr>
		<td><?php echo h($descuento['Descuento']['idDescuento']); ?>&nbsp;</td>
		<td><?php echo h($descuento['Descuento']['descuento']); ?>&nbsp;</td>
		<td><?php echo h($descuento['Descuento']['loteMin']); ?>&nbsp;</td>
		<td><?php echo h($descuento['Descuento']['loteMax']); ?>&nbsp;</td>
		<td>
			<?php echo $this->Html->link($descuento['Proveedore']['nombre'], array('controller' => 'proveedores', 'action' => 'view', $descuento['Proveedore']['idProveedores'])); ?>
		</td>
		<td>
			<?php echo $this->Html->link($descuento['Inventario']['nombre'], array('controller' => 'inventarios', 'action' => 'view', $descuento['Inventario']['idInventario'])); ?>
		</td>
		<td class="actions">
			<?php echo $this->Html->link(__('Ver'), array('action' => 'view', $descuento['Descuento']['idDescuento'])); ?>
			<?php echo $this->Html->link(__('Modificar'), array('action' => 'edit', $descuento['Descuento']['idDescuento'])); ?>
			<?php echo $this->Form->postLink(__('Borrar'), array('action' => 'delete', $descuento['Descuento']['idDescuento']), null, __('¿Quiere borrar # %s?', $descuento['Descuento']['idDescuento'])); ?>
		</td>
	</tr>
<?php endforeach; ?>
	</table>
	<p>
	<?php
	echo $this->Paginator->counter(array(
	'format' => __('Page {:page} of {:pages}, showing {:current} records out of {:count} total, starting on record {:start}, ending on {:end}')
	));
	?>	</p>
	<div class="paging">
	<?php
		echo $this->Paginator->prev('< ' . __('Anterior'), array(), null, array('class' => 'prev disabled'));
		echo $this->Paginator->numbers(array('separator' => ''));
		echo $this->Paginator->next(__('Siguiente') . ' >', array(), null, array('class' => 'next disabled'));
	?>
	</div>
</div>
<div class="actions">
	<h3><?php echo __('Acciones'); ?></h3>
	<ul>
		<li><?php echo $this->Html->link(__('Nuevo Descuento'), array('action' => 'add')); ?></li>
		<li><?php echo $this->Html->link(__('Lista de Proveedores'), array('controller' => 'proveedores', 'action' => 'index')); ?> </li>
		<li><?php echo $this->Html->link(__('Nuevo Proveedor'), array('controller' => 'proveedores', 'action' => 'add')); ?> </li>
		<li><?php echo $this->Html->link(__('Lista de Productos'), array('controller' => 'inventarios', 'action' => 'index')); ?> </li>
		<li><?php echo $this->Html->link(__('Nuevo Producto'), array('controller' => 'inventarios', 'action' => 'add')); ?> </li>
	</ul>
</div>
