<div class="inventarios index">
	<h2><?php echo __('Inventarios'); ?></h2>
	<table cellpadding="0" cellspacing="0">
	<tr>
			<th><?php echo $this->Paginator->sort('idInventario'); ?></th>
			<th><?php echo $this->Paginator->sort('Clave'); ?></th>
			<th><?php echo $this->Paginator->sort('Nombre'); ?></th>
			<th><?php echo $this->Paginator->sort('Cantidad'); ?></th>
			<th><?php echo $this->Paginator->sort('Costo unitario'); ?></th>
			<th><?php echo $this->Paginator->sort('Proveedor'); ?></th>
			<th><?php echo $this->Paginator->sort('Costo de almacenamiento'); ?></th>
			<th><?php echo $this->Paginator->sort('Demanda'); ?></th>
			<th class="actions"><?php echo __('Actions'); ?></th>
	</tr>
	<?php foreach ($inventarios as $inventario): ?>
	<tr>
		<td><?php echo h($inventario['Inventario']['idInventario']); ?>&nbsp;</td>
		<td><?php echo h($inventario['Inventario']['clave']); ?>&nbsp;</td>
		<td><?php echo h($inventario['Inventario']['nombre']); ?>&nbsp;</td>
		<td><?php echo h($inventario['Inventario']['cantidad']); ?>&nbsp;</td>
		<td><?php echo h($inventario['Inventario']['costoUnitario']); ?>&nbsp;</td>
		<td>
			<?php echo $this->Html->link($inventario['Proveedore']['nombre'], array('controller' => 'proveedores', 'action' => 'view', $inventario['Proveedore']['idProveedores'])); ?>
		</td>
		<td><?php echo h($inventario['Inventario']['costoDeAlmacenamiento']); ?>&nbsp;</td>
		<td><?php echo h($inventario['Inventario']['demanda']); ?>&nbsp;</td>
		<td class="actions">
			<?php echo $this->Html->link(__('Ver'), array('action' => 'view', $inventario['Inventario']['idInventario'])); ?>
			<?php echo $this->Html->link(__('Modificar'), array('action' => 'edit', $inventario['Inventario']['idInventario'])); ?>
			<?php echo $this->Form->postLink(__('Borrar'), array('action' => 'delete', $inventario['Inventario']['idInventario']), null, __('¿Quiere borrar # %s?', $inventario['Inventario']['idInventario'])); ?>
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
		<li><?php echo $this->Html->link(__('Nuevo Producto'), array('action' => 'add')); ?></li>
		<li><?php echo $this->Html->link(__('Lista de Proveedores'), array('controller' => 'proveedores', 'action' => 'index')); ?> </li>
		<li><?php echo $this->Html->link(__('Nuevo Proveedor'), array('controller' => 'proveedores', 'action' => 'add')); ?> </li>
	</ul>
</div>
