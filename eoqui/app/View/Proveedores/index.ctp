<div class="proveedores index">
	<h2><?php echo __('Proveedores'); ?></h2>
	<table cellpadding="0" cellspacing="0">
	<tr>
			<th><?php echo $this->Paginator->sort('idProveedores'); ?></th>
			<th><?php echo $this->Paginator->sort('Nombre'); ?></th>
			<th><?php echo $this->Paginator->sort('Direccion'); ?></th>
			<th><?php echo $this->Paginator->sort('Telefono'); ?></th>
			<th><?php echo $this->Paginator->sort('Costo de orden'); ?></th>
			<th class="actions"><?php echo __('Acciones'); ?></th>
	</tr>
	<?php foreach ($proveedores as $proveedore): ?>
	<tr>
		<td><?php echo h($proveedore['Proveedore']['idProveedores']); ?>&nbsp;</td>
		<td><?php echo h($proveedore['Proveedore']['nombre']); ?>&nbsp;</td>
		<td><?php echo h($proveedore['Proveedore']['direccion']); ?>&nbsp;</td>
		<td><?php echo h($proveedore['Proveedore']['telefono']); ?>&nbsp;</td>
		<td><?php echo h($proveedore['Proveedore']['costoDeOrden']); ?>&nbsp;</td>
		<td class="actions">
			<?php echo $this->Html->link(__('Ver'), array('action' => 'view', $proveedore['Proveedore']['idProveedores'])); ?>
			<?php echo $this->Html->link(__('Modificar'), array('action' => 'edit', $proveedore['Proveedore']['idProveedores'])); ?>
			<?php echo $this->Form->postLink(__('Borrar'), array('action' => 'delete', $proveedore['Proveedore']['idProveedores']), null, __('¿Quiere borrar # %s?', $proveedore['Proveedore']['idProveedores'])); ?>
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
		<li><?php echo $this->Html->link(__('Agregar Proveedor'), array('action' => 'add')); ?></li>
	</ul>
</div>
