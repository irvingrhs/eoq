<?php
App::uses('AppController', 'Controller');
/**
 * Descuentos Controller
 *
 * @property Descuento $Descuento
 * @property PaginatorComponent $Paginator
 */
class DescuentosController extends AppController {

/**
 * Components
 *
 * @var array
 */
 public $uses = array('Descuento','Proveedore','Inventario');
	public $components = array('Paginator');

/**
 * index method
 *
 * @return void
 */
	public function index() {
		$this->Descuento->recursive = 0;
		$this->set('descuentos', $this->Paginator->paginate());
	}

/**
 * view method
 *
 * @throws NotFoundException
 * @param string $id
 * @return void
 */
	public function view($id = null) {
		if (!$this->Descuento->exists($id)) {
			throw new NotFoundException(__('Invalid descuento'));
		}
		$options = array('conditions' => array('Descuento.' . $this->Descuento->primaryKey => $id));
		$this->set('descuento', $this->Descuento->find('first', $options));
	}

/**
 * add method
 *
 * @return void
 */
	public function add() {
		if ($this->request->is('post')) {
			$this->Descuento->create();
			if ($this->Descuento->save($this->request->data)) {
				$this->Session->setFlash(__('The descuento has been saved.'));
				return $this->redirect(array('action' => 'index'));
			} else {
				$this->Session->setFlash(__('The descuento could not be saved. Please, try again.'));
			}
		}
		$proveedores = $this->Descuento->Proveedore->find('all');
		$inventarios = $this->Descuento->Inventario->find('all');
		$arreglo1 = array();
		$arreglo2 = array();
		foreach($proveedores as $proveedor)
		{
			$arreglo1[$proveedor['Proveedore']['idProveedores']] = $proveedor['Proveedore']['nombre'];
		}
		foreach($inventarios as $inventario)
		{
			$arreglo2[$inventario['Inventario']['idInventario']] = $inventario['Inventario']['nombre'];
		}
		$this->set(compact('proveedores', 'inventarios'));
		$this->set('listaProveedores',$arreglo1);
		$this->set('listaInventarios',$arreglo2);
	}

/**
 * edit method
 *
 * @throws NotFoundException
 * @param string $id
 * @return void
 */
	public function edit($id = null) {
		if (!$this->Descuento->exists($id)) {
			throw new NotFoundException(__('Invalid descuento'));
		}
		if ($this->request->is(array('post', 'put'))) {
			if ($this->Descuento->save($this->request->data)) {
				$this->Session->setFlash(__('The descuento has been saved.'));
				return $this->redirect(array('action' => 'index'));
			} else {
				$this->Session->setFlash(__('The descuento could not be saved. Please, try again.'));
			}
		} else {
			$options = array('conditions' => array('Descuento.' . $this->Descuento->primaryKey => $id));
			$this->request->data = $this->Descuento->find('first', $options);
		}
		$proveedores = $this->Descuento->Proveedore->find('all');
		$inventarios = $this->Descuento->Inventario->find('all');
		$arreglo1 = array();
		$arreglo2 = array();
		foreach($proveedores as $proveedor)
		{
			$arreglo1[$proveedor['Proveedore']['idProveedores']] = $proveedor['Proveedore']['nombre'];
		}
		foreach($inventarios as $inventario)
		{
			$arreglo2[$inventario['Inventario']['idInventario']] = $inventario['Inventario']['nombre'];
		}
		$this->set(compact('proveedores', 'inventarios'));
		$this->set('listaProveedores',$arreglo1);
		$this->set('listaInventarios',$arreglo2);
	}

/**
 * delete method
 *
 * @throws NotFoundException
 * @param string $id
 * @return void
 */
	public function delete($id = null) {
		$this->Descuento->id = $id;
		if (!$this->Descuento->exists()) {
			throw new NotFoundException(__('Invalid descuento'));
		}
		$this->request->onlyAllow('post', 'delete');
		if ($this->Descuento->delete()) {
			$this->Session->setFlash(__('The descuento has been deleted.'));
		} else {
			$this->Session->setFlash(__('The descuento could not be deleted. Please, try again.'));
		}
		return $this->redirect(array('action' => 'index'));
	}}
