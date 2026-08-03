// VARIABLES DE ESTADO LOCAL
let session = null;
let products = [];
let branches = [];
let currentOrigenStock = 0;
let currentDestStock = 0;

// SELECTORES DOM
const loginForm = document.getElementById('login-form');
const authCard = document.getElementById('auth-card');
const transferCard = document.getElementById('transfer-card');
const lockOverlay = document.getElementById('lock-overlay');
const loginStatus = document.getElementById('login-status');
const userProfileTitle = document.getElementById('user-profile-title');
const profileBar = document.getElementById('profile-bar');

// Campos de Formulario 2
const transferForm = document.getElementById('transfer-form');
const selectProducto = document.getElementById('transfer-producto');
const inputOrigen = document.getElementById('transfer-origen');
const inputOrigenId = document.getElementById('transfer-origen-id');
const selectDestino = document.getElementById('transfer-destino');
const inputTransferId = document.getElementById('transfer-id');
const inputCantidad = document.getElementById('transfer-cantidad');
const stockOrigenDisplay = document.getElementById('stock-origen');
const stockDestinoDisplay = document.getElementById('stock-destino');
const qtyWarning = document.getElementById('qty-warning');

// Botones de Formulario 2
const btnGuardar = document.getElementById('btn-guardar');
const btnCancelar = document.getElementById('btn-cancelar');
const btnRefresh = document.getElementById('btn-refresh');

// Tabla
const historyTbody = document.getElementById('history-tbody');
const toastContainer = document.getElementById('toast-container');

// INICIALIZACIÓN
document.addEventListener('DOMContentLoaded', () => {
  // Manejador del Login
  loginForm.addEventListener('submit', handleLogin);
  
  // Manejador de cambios en Producto y Sucursal Destino para consultar stock
  selectProducto.addEventListener('change', fetchStockInfo);
  selectDestino.addEventListener('change', fetchStockInfo);
  
  // Validación de cantidad en tiempo real
  inputCantidad.addEventListener('input', validateQuantity);
  
  // Cancelación de transferencia
  btnCancelar.addEventListener('click', resetTransferForm);
  
  // Envío de transferencia
  transferForm.addEventListener('submit', handleTransferSubmit);
  
  // Refresh del historial
  btnRefresh.addEventListener('click', loadTransfersHistory);
});

// FUNCIÓN: LOGIN
async function handleLogin(e) {
  e.preventDefault();
  
  const usuario = document.getElementById('login-usuario').value;
  const clave = document.getElementById('login-clave').value;
  const sucursal = document.getElementById('login-sucursal').value;
  
  showLoginStatus('Verificando credenciales en la base de datos...', 'info');
  
  try {
    const response = await fetch('/api/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ usuario, clave, sucursal })
    });
    
    const data = await response.json();
    
    if (!response.ok) {
      showLoginStatus(data.error || 'Error al iniciar sesión.', 'error');
      showToast(data.error || 'Error al iniciar sesión', 'error');
      return;
    }
    
    // Login exitoso
    session = data.user;
    showLoginStatus('¡Sesión iniciada correctamente!', 'success');
    showToast(`Bienvenido(a), ${session.nombres} ${session.apellidos}`, 'success');
    
    // Desbloquear Formulario 2
    unlockTransferForm();
    
  } catch (error) {
    console.error('Error:', error);
    showLoginStatus('Error de conexión con el servidor.', 'error');
    showToast('Error de conexión con el servidor', 'error');
  }
}

// DESBLOQUEAR FORMULARIO 2
async function unlockTransferForm() {
  // Cambiar clases visuales
  transferCard.classList.remove('locked');
  profileBar.classList.add('profile-active');
  
  // Actualizar Título con el Perfil
  userProfileTitle.innerHTML = `👤 ${session.nombres} ${session.apellidos} <span class="badge badge-success" style="margin-left:10px;">${session.perfil}</span>`;
  
  // Asignar Sucursal de Origen
  inputOrigen.value = session.nombre_sucursal;
  inputOrigenId.value = session.id_sucursal;
  
  // Generar número de transferencia aleatorio
  generateTransferNumber();
  
  // Cargar Productos y Sucursales desde el servidor
  await loadFormData();
  
  // Habilitar campos
  selectProducto.removeAttribute('disabled');
  selectDestino.removeAttribute('disabled');
  inputCantidad.removeAttribute('disabled');
  btnCancelar.removeAttribute('disabled');
  btnGuardar.removeAttribute('disabled');
  
  // Cargar historial inicial
  loadTransfersHistory();
}

// CARGAR PRODUCTOS Y SUCURSALES
async function loadFormData() {
  try {
    // Cargar productos
    const prodRes = await fetch('/api/products');
    products = await prodRes.json();
    
    selectProducto.innerHTML = '<option value="" disabled selected>Seleccione un producto...</option>';
    products.forEach(p => {
      const option = document.createElement('option');
      option.value = p.codigo_barras;
      option.textContent = p.nombre;
      selectProducto.appendChild(option);
    });
    
    // Cargar sucursales
    const branchRes = await fetch('/api/branches');
    branches = await branchRes.json();
    
    selectDestino.innerHTML = '<option value="" disabled selected>Seleccione destino...</option>';
    branches.forEach(b => {
      // Excluir sucursal de origen
      if (parseInt(b.id_sucursal) !== parseInt(session.id_sucursal)) {
        const option = document.createElement('option');
        option.value = b.id_sucursal;
        option.textContent = b.nombre;
        selectDestino.appendChild(option);
      }
    });
    
  } catch (error) {
    console.error('Error al cargar datos del formulario:', error);
    showToast('Error al cargar productos/sucursales', 'error');
  }
}

// CONSULTAR STOCK EN TIEMPO REAL
async function fetchStockInfo() {
  const productCode = selectProducto.value;
  const sourceBranchId = inputOrigenId.value;
  const destBranchId = selectDestino.value;
  
  if (!productCode) return;
  
  // Consultar stock origen
  try {
    const origRes = await fetch(`/api/stock?product_code=${productCode}&branch_id=${sourceBranchId}`);
    const origData = await origRes.json();
    currentOrigenStock = origData.stock;
    
    stockOrigenDisplay.textContent = currentOrigenStock;
    stockOrigenDisplay.className = 'stock-display ' + (currentOrigenStock > 0 ? 'ok' : 'low');
    
    // Validar cantidad ingresada con el nuevo stock
    validateQuantity();
  } catch (error) {
    console.error('Error stock origen:', error);
  }
  
  // Consultar stock destino si está seleccionado
  if (destBranchId) {
    try {
      const destRes = await fetch(`/api/stock?product_code=${productCode}&branch_id=${destBranchId}`);
      const destData = await destRes.json();
      currentDestStock = destData.stock;
      
      stockDestinoDisplay.textContent = currentDestStock;
      stockDestinoDisplay.className = 'stock-display ' + (currentDestStock > 0 ? 'ok' : 'low');
    } catch (error) {
      console.error('Error stock destino:', error);
    }
  } else {
    stockDestinoDisplay.textContent = '--';
    stockDestinoDisplay.className = 'stock-display';
  }
}

// VALIDAR CANTIDAD A TRANSFERIR
function validateQuantity() {
  const qty = parseInt(inputCantidad.value, 10);
  
  if (isNaN(qty) || qty <= 0) {
    qtyWarning.classList.add('hide');
    btnGuardar.removeAttribute('disabled');
    return;
  }
  
  if (qty > currentOrigenStock) {
    qtyWarning.classList.remove('hide');
    qtyWarning.textContent = `Supera el stock disponible (${currentOrigenStock})`;
    btnGuardar.setAttribute('disabled', 'true');
  } else {
    qtyWarning.classList.add('hide');
    btnGuardar.removeAttribute('disabled');
  }
}

// GUARDAR TRANSFERENCIA
async function handleTransferSubmit(e) {
  e.preventDefault();
  
  const productCode = selectProducto.value;
  const sourceBranchId = inputOrigenId.value;
  const destBranchId = selectDestino.value;
  const quantity = inputCantidad.value;
  
  if (!productCode || !destBranchId || !quantity) {
    showToast('Por favor complete todos los campos.', 'error');
    return;
  }
  
  btnGuardar.setAttribute('disabled', 'true');
  btnGuardar.textContent = 'Guardando...';
  
  try {
    const response = await fetch('/api/transfer', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        product_code: productCode,
        source_branch: sourceBranchId,
        dest_branch: destBranchId,
        quantity: quantity
      })
    });
    
    const data = await response.json();
    
    if (!response.ok) {
      showToast(data.error || 'Error al procesar la transferencia.', 'error');
      btnGuardar.removeAttribute('disabled');
      btnGuardar.textContent = 'Guardar';
      return;
    }
    
    // Transferencia exitosa
    showToast(`Transferencia registrada con éxito (ID: ${data.id_transferencia})`, 'success');
    
    // Actualizar stocks en pantalla en tiempo real
    await fetchStockInfo();
    
    // Recargar historial de transferencias
    await loadTransfersHistory();
    
    // Limpiar cantidad y destino
    inputCantidad.value = '';
    selectDestino.value = '';
    stockDestinoDisplay.textContent = '--';
    stockDestinoDisplay.className = 'stock-display';
    
    // Regenerar número de transferencia
    generateTransferNumber();
    
  } catch (error) {
    console.error('Error al guardar transferencia:', error);
    showToast('Error al conectar con la base de datos.', 'error');
  } finally {
    btnGuardar.removeAttribute('disabled');
    btnGuardar.textContent = 'Guardar';
  }
}

// CARGAR HISTORIAL DE TRANSFERENCIAS
async function loadTransfersHistory() {
  if (!session) return;
  
  try {
    const res = await fetch('/api/transfers');
    const transfers = await res.json();
    
    if (transfers.length === 0) {
      historyTbody.innerHTML = '<tr><td colspan="7" class="empty-table">No se han registrado transferencias aún.</td></tr>';
      return;
    }
    
    historyTbody.innerHTML = '';
    transfers.forEach(t => {
      const tr = document.createElement('tr');
      
      const date = new Date(t.fecha_transferencia);
      const formattedDate = date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
      
      const stateClass = t.estado.toLowerCase();
      
      tr.innerHTML = `
        <td><strong>#${t.id_transferencia}</strong></td>
        <td>${formattedDate}</td>
        <td>${t.producto_nombre} <br><small style="color:var(--color-text-secondary);">${t.codigo_barras}</small></td>
        <td>${t.sucursal_origen_nombre}</td>
        <td>${t.sucursal_destino_nombre}</td>
        <td><span style="font-weight:600;">${t.cantidad}</span></td>
        <td><span class="status-badge ${stateClass}">${t.estado}</span></td>
      `;
      
      historyTbody.appendChild(tr);
    });
  } catch (error) {
    console.error('Error al cargar historial:', error);
  }
}

// RE-INICIAR FORMULARIO DE TRANSFERENCIA
function resetTransferForm() {
  selectProducto.value = '';
  selectDestino.value = '';
  inputCantidad.value = '';
  stockOrigenDisplay.textContent = '--';
  stockOrigenDisplay.className = 'stock-display';
  stockDestinoDisplay.textContent = '--';
  stockDestinoDisplay.className = 'stock-display';
  qtyWarning.classList.add('hide');
  generateTransferNumber();
  showToast('Formulario limpiado', 'info');
}

// AUXILIARES
function generateTransferNumber() {
  // Genera un código tipo TRF-83748
  const randNum = Math.floor(10000 + Math.random() * 90000);
  inputTransferId.value = `TRF-${randNum}`;
}

function showLoginStatus(msg, type) {
  loginStatus.classList.remove('hide', 'error', 'success', 'info');
  loginStatus.classList.add(type);
  loginStatus.textContent = msg;
}

function showToast(message, type = 'success') {
  const toast = document.createElement('div');
  toast.className = `toast ${type === 'error' ? 'toast-error' : ''}`;
  toast.innerHTML = `
    <span>${type === 'success' ? '✅' : type === 'error' ? '❌' : 'ℹ️'}</span>
    <span>${message}</span>
  `;
  
  toastContainer.appendChild(toast);
  
  setTimeout(() => {
    toast.classList.add('fade-out');
    setTimeout(() => toast.remove(), 400);
  }, 4000);
}
