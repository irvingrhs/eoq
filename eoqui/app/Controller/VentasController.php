<?php
App::uses('AppController', 'Controller');
/**
 * Ventas Controller
 *
 * @property Venta $Venta
 * @property PaginatorComponent $Paginator
 */
class VentasController extends AppController {

/**
 * Components
 *
 * @var array
 */
  public $uses = array('Venta','Inventario');
	public $components = array('Paginator');

/**
 * index method
 *
 * @return void
 */
	public function index() {
		$this->Venta->recursive = 0;
		$this->set('ventas', $this->Paginator->paginate());
	}

/**
 * view method
 *
 * @throws NotFoundException
 * @param string $id
 * @return void
 */
	public function view($id = null) {
		if (!$this->Venta->exists($id)) {
			throw new NotFoundException(__('Invalid venta'));
		}
		$options = array('conditions' => array('Venta.' . $this->Venta->primaryKey => $id));
		$this->set('venta', $this->Venta->find('first', $options));
	}

/**
 * add method
 *
 * @return void
 */
	public function add() {
		if ($this->request->is('post')) {
			$this->Venta->create();
			if ($this->Venta->save($this->request->data)) {
				$this->Session->setFlash(__('The venta has been saved.'));
				return $this->redirect(array('action' => 'index'));
			} else {
				$this->Session->setFlash(__('The venta could not be saved. Please, try again.'));
			}
		}
		$inventarios = $this->Venta->Inventario->find('all');
		$arreglo = array();
		
		foreach($inventarios as $inventario)
		{
			$arreglo[$inventario['Inventario']['idInventario']] = $inventario['Inventario']['nombre'];
		}
		$this->set(compact('inventarios'));
		$this->set('listaInventarios',$arreglo);
	}

/**
 * edit method
 *
 * @throws NotFoundException
 * @param string $id
 * @return void
 */
	public function edit($id = null) {
		if (!$this->Venta->exists($id)) {
			throw new NotFoundException(__('Invalid venta'));
		}
		if ($this->request->is(array('post', 'put'))) {
			if ($this->Venta->save($this->request->data)) {
				$this->Session->setFlash(__('The venta has been saved.'));
				return $this->redirect(array('action' => 'index'));
			} else {
				$this->Session->setFlash(__('The venta could not be saved. Please, try again.'));
			}
		} else {
			$options = array('conditions' => array('Venta.' . $this->Venta->primaryKey => $id));
			$this->request->data = $this->Venta->find('first', $options);
		}
		$inventarios = $this->Venta->Inventario->find('all');
		$arreglo = array();
		
		foreach($inventarios as $inventario)
		{
			$arreglo[$inventario['Inventario']['idInventario']] = $inventario['Inventario']['nombre'];
		}
		$this->set(compact('inventarios'));
		$this->set('listaInventarios',$arreglo);
	}

/**
 * delete method
 *
 * @throws NotFoundException
 * @param string $id
 * @return void
 */
	public function delete($id = null) {
		$this->Venta->id = $id;
		if (!$this->Venta->exists()) {
			throw new NotFoundException(__('Invalid venta'));
		}
		$this->request->onlyAllow('post', 'delete');
		if ($this->Venta->delete()) {
			$this->Session->setFlash(__('The venta has been deleted.'));
		} else {
			$this->Session->setFlash(__('The venta could not be deleted. Please, try again.'));
		}
		return $this->redirect(array('action' => 'index'));
	}}
