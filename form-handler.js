function setFeedback(element, message, type) {
  if (!element) return;
  element.textContent = message || '';
  element.style.color = type === 'error' ? '#b91c1c' : type === 'success' ? '#15803d' : '#92400e';
}

function getStoredUser() {
  try {
    return JSON.parse(sessionStorage.getItem('natural-user') || 'null');
  } catch (error) {
    return null;
  }
}

function saveStoredUser(user) {
  sessionStorage.setItem('natural-user', JSON.stringify(user));
}

async function handleLogin(event) {
  event.preventDefault();
  const statusElement = document.getElementById('login-status');
  const usuario = document.getElementById('login-usuario').value.trim();
  const clave = document.getElementById('login-clave').value.trim();
  const sucursal = document.getElementById('login-sucursal').value.trim();

  if (!usuario || !clave || !sucursal) {
    setFeedback(statusElement, 'Completa todos los campos del formulario.', 'error');
    return;
  }

  setFeedback(statusElement, 'Verificando credenciales...', 'info');

  try {
    const response = await fetch('/api/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ usuario, clave, sucursal })
    });

    const data = await response.json();
    if (!response.ok) {
      throw new Error(data.error || 'Error al iniciar sesión.');
    }

    saveStoredUser(data.user);
    setFeedback(statusElement, 'Inicio de sesión correcto. Redirigiendo...', 'success');
    window.location.href = 'formulario2.html';
  } catch (error) {
    setFeedback(statusElement, error.message || 'No se pudo contactar al servidor.', 'error');
  }
}

async function loadCatalogs() {
  const productSelect = document.getElementById('transfer-producto');
  const destinationSelect = document.getElementById('transfer-destino');
  const originInputId = document.getElementById('transfer-origen-id');

  if (!productSelect || !destinationSelect || !originInputId) return;

  try {
    const [productsRes, branchesRes] = await Promise.all([
      fetch('/api/products'),
      fetch('/api/branches')
    ]);

    const products = await productsRes.json();
    const branches = await branchesRes.json();

    productSelect.innerHTML = '<option value="" disabled selected>Seleccione un producto...</option>';
    products.forEach((product) => {
      const option = document.createElement('option');
      option.value = product.codigo_barras;
      option.textContent = product.nombre;
      productSelect.appendChild(option);
    });

    destinationSelect.innerHTML = '<option value="" disabled selected>Seleccione destino...</option>';
    const originBranchId = originInputId.value;
    branches.forEach((branch) => {
      if (String(branch.id_sucursal) !== String(originBranchId)) {
        const option = document.createElement('option');
        option.value = branch.id_sucursal;
        option.textContent = branch.nombre;
        destinationSelect.appendChild(option);
      }
    });
  } catch (error) {
    const statusElement = document.getElementById('transfer-status');
    setFeedback(statusElement, 'No se pudieron cargar productos o sucursales desde la base de datos.', 'error');
  }
}

async function fetchStockInfo() {
  const productCode = document.getElementById('transfer-producto').value;
  const sourceBranchId = document.getElementById('transfer-origen-id').value;
  const destinationBranchId = document.getElementById('transfer-destino').value;
  const stockOrigenDisplay = document.getElementById('stock-origen');
  const stockDestinoDisplay = document.getElementById('stock-destino');

  if (!productCode || !sourceBranchId) {
    return;
  }

  try {
    const originRes = await fetch(`/api/stock?product_code=${encodeURIComponent(productCode)}&branch_id=${encodeURIComponent(sourceBranchId)}`);
    const originData = await originRes.json();
    stockOrigenDisplay.value = originData.stock ?? 0;
  } catch (error) {
    stockOrigenDisplay.value = 'Error';
  }

  if (destinationBranchId) {
    try {
      const destRes = await fetch(`/api/stock?product_code=${encodeURIComponent(productCode)}&branch_id=${encodeURIComponent(destinationBranchId)}`);
      const destData = await destRes.json();
      stockDestinoDisplay.value = destData.stock ?? 0;
    } catch (error) {
      stockDestinoDisplay.value = 'Error';
    }
  } else {
    stockDestinoDisplay.value = '';
  }
}

async function handleTransfer(event) {
  event.preventDefault();
  const statusElement = document.getElementById('transfer-status');
  const productCode = document.getElementById('transfer-producto').value;
  const sourceBranchId = document.getElementById('transfer-origen-id').value;
  const destinationBranchId = document.getElementById('transfer-destino').value;
  const quantity = document.getElementById('transfer-cantidad').value.trim();

  if (!productCode || !destinationBranchId || !quantity) {
    setFeedback(statusElement, 'Completa producto, destino y cantidad para registrar la transferencia.', 'error');
    return;
  }

  setFeedback(statusElement, 'Guardando transferencia...', 'info');

  try {
    const response = await fetch('/api/transfer', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        product_code: productCode,
        source_branch: sourceBranchId,
        dest_branch: destinationBranchId,
        quantity
      })
    });

    const data = await response.json();
    if (!response.ok) {
      throw new Error(data.error || 'No se pudo guardar la transferencia.');
    }

    setFeedback(statusElement, `Transferencia registrada correctamente (ID: ${data.id_transferencia}).`, 'success');
    document.getElementById('transfer-cantidad').value = '';
    document.getElementById('transfer-destino').value = '';
    document.getElementById('stock-destino').value = '';
    document.getElementById('transfer-id').value = '';
    await fetchStockInfo();
  } catch (error) {
    setFeedback(statusElement, error.message || 'No se pudo contactar al servidor.', 'error');
  }
}

function initializeTransferPage() {
  const user = getStoredUser();
  const transferForm = document.getElementById('transfer-form');
  const transferStatus = document.getElementById('transfer-status');
  const originInput = document.getElementById('transfer-origen');
  const originInputId = document.getElementById('transfer-origen-id');

  if (!transferForm || !originInput || !originInputId) return;

  if (!user) {
    setFeedback(transferStatus, 'Debes iniciar sesión desde el formulario 1 para usar esta pantalla.', 'error');
    return;
  }

  originInput.value = user.nombre_sucursal || '';
  originInputId.value = user.id_sucursal || '';

  transferForm.addEventListener('submit', handleTransfer);
  document.getElementById('transfer-producto').addEventListener('change', fetchStockInfo);
  document.getElementById('transfer-destino').addEventListener('change', fetchStockInfo);
  document.getElementById('transfer-cantidad').addEventListener('input', fetchStockInfo);
  loadCatalogs();
}

document.addEventListener('DOMContentLoaded', () => {
  const loginForm = document.getElementById('login-form');
  if (loginForm) {
    loginForm.addEventListener('submit', handleLogin);
  }

  initializeTransferPage();
});
