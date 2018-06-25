<div class="ventas view">
<h2><?php echo __('Venta'); ?></h2>
	<dl>
		<dt><?php echo __('IdVentas'); ?></dt>
		<dd>
			<?php echo h($venta['Venta']['idVentas']); ?>
			&nbsp;
		</dd>
		<dt><?php echo __('Cantidad'); ?></dt>
		<dd>
			<?php echo h($venta['Venta']['cantidad']); ?>
			&nbsp;
		</dd>
		<dt><?php echo __('Importe'); ?></dt>
		<dd>
			<?php echo h($venta['Venta']['importe']); ?>
			&nbsp;
		</dd>
		<dt><?php echo __('Producto'); ?></dt>
		<dd>
			<?php echo $this->Html->link($venta['Inventario']['nombre'], array('controller' => 'inventarios', 'action' => 'view', $venta['Inventario']['idInventario'])); ?>
			&nbsp;
		</dd>
		<dt><?php echo __('Fecha'); ?></dt>
		<dd>
			<?php echo h($venta['Venta']['fecha']); ?>
			&nbsp;
		</dd>
	</dl>
</div>
<div class="actions">
	<h3><?php echo __('Acciones'); ?></h3>
	<ul>
		<li><?php echo $this->Html->link(__('Modificar Venta'), array('action' => 'edit', $venta['Venta']['idVentas'])); ?> </li>
		<li><?php echo $this->Form->postLink(__('Borrar Venta'), array('action' => 'delete', $venta['Venta']['idVentas']), null, __('¿Quiere borrar # %s?', $venta['Venta']['idVentas'])); ?> </li>
		<li><?php echo $this->Html->link(__('Lista de Ventas'), array('action' => 'index')); ?> </li>
		<li><?php echo $this->Html->link(__('Nueva Venta'), array('action' => 'add')); ?> </li>
		<li><?php echo $this->Html->link(__('Lista de Productos'), array('controller' => 'inventarios', 'action' => 'index')); ?> </li>
		<li><?php echo $this->Html->link(__('Nuevo Producto'), array('controller' => 'inventarios', 'action' => 'add')); ?> </li>
	</ul>
</div>
