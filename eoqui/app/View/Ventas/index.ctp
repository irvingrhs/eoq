<div class="ventas index">
	<h2><?php echo __('Ventas'); ?></h2>
	<table cellpadding="0" cellspacing="0">
	<tr>
			<th><?php echo $this->Paginator->sort('idVentas'); ?></th>
			<th><?php echo $this->Paginator->sort('Cantidad'); ?></th>
			<th><?php echo $this->Paginator->sort('Importe'); ?></th>
			<th><?php echo $this->Paginator->sort('Producto'); ?></th>
			<th><?php echo $this->Paginator->sort('Fecha'); ?></th>
			<th class="actions"><?php echo __('Actions'); ?></th>
	</tr>
	<?php foreach ($ventas as $venta): ?>
	<tr>
		<td><?php echo h($venta['Venta']['idVentas']); ?>&nbsp;</td>
		<td><?php echo h($venta['Venta']['cantidad']); ?>&nbsp;</td>
		<td><?php echo h($venta['Venta']['importe']); ?>&nbsp;</td>
		<td>
			<?php echo $this->Html->link($venta['Inventario']['nombre'], array('controller' => 'inventarios', 'action' => 'view', $venta['Inventario']['idInventario'])); ?>
		</td>
		<td><?php echo h($venta['Venta']['fecha']); ?>&nbsp;</td>
		<td class="actions">
			<?php echo $this->Html->link(__('Ver'), array('action' => 'view', $venta['Venta']['idVentas'])); ?>
			<?php echo $this->Html->link(__('Modificar'), array('action' => 'edit', $venta['Venta']['idVentas'])); ?>
			<?php echo $this->Form->postLink(__('Borrar'), array('action' => 'delete', $venta['Venta']['idVentas']), null, __('¿Quiere borrar # %s?', $venta['Venta']['idVentas'])); ?>
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
		<li><?php echo $this->Html->link(__('Nueva Venta'), array('action' => 'add')); ?></li>
		<li><?php echo $this->Html->link(__('Lista de Productos'), array('controller' => 'inventarios', 'action' => 'index')); ?> </li>
		<li><?php echo $this->Html->link(__('Nuevo Producto'), array('controller' => 'inventarios', 'action' => 'add')); ?> </li>
	</ul>
</div>
