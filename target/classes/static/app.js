// Sistema de Gestão de Pátios e Motos - Frontend JavaScript

// Configuração da API
const API_BASE_URL = '/api';
const ENDPOINTS = {
    patios: `${API_BASE_URL}/patios`,
    motos: `${API_BASE_URL}/motos`
};

// Estado da aplicação
let currentSection = 'dashboard';
let patios = [];
let motos = [];
let editingPatioId = null;
let editingMotoId = null;

// Inicialização da aplicação
document.addEventListener('DOMContentLoaded', function() {
    console.log('Sistema de Pátios iniciado');
    loadDashboardData();
    showSection('dashboard');
});

// Funções de navegação
function showSection(sectionName) {
    // Esconder todas as seções
    document.querySelectorAll('.section').forEach(section => {
        section.style.display = 'none';
    });
    
    // Mostrar a seção selecionada
    const targetSection = document.getElementById(sectionName);
    if (targetSection) {
        targetSection.style.display = 'block';
        targetSection.classList.add('fade-in');
    }
    
    // Atualizar navbar
    document.querySelectorAll('.nav-link').forEach(link => {
        link.classList.remove('active');
    });
    
    const activeLink = document.querySelector(`[href="#${sectionName}"]`);
    if (activeLink) {
        activeLink.classList.add('active');
    }
    
    currentSection = sectionName;
    
    // Carregar dados específicos da seção
    switch(sectionName) {
        case 'dashboard':
            loadDashboardData();
            break;
        case 'patios':
            loadPatios();
            break;
        case 'motos':
            loadMotos();
            loadPatiosForSelect();
            break;
    }
}

// Funções de loading
function showLoading() {
    document.getElementById('loadingSpinner').classList.remove('d-none');
}

function hideLoading() {
    document.getElementById('loadingSpinner').classList.add('d-none');
}

// Funções de notificação
function showNotification(message, type = 'success') {
    // Criar elemento de notificação
    const notification = document.createElement('div');
    notification.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
    notification.style.cssText = 'top: 20px; right: 20px; z-index: 10000; min-width: 300px;';
    notification.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    document.body.appendChild(notification);
    
    // Remover após 5 segundos
    setTimeout(() => {
        if (notification.parentNode) {
            notification.parentNode.removeChild(notification);
        }
    }, 5000);
}

// Funções da API
async function apiRequest(url, options = {}) {
    try {
        showLoading();
        const response = await fetch(url, {
            headers: {
                'Content-Type': 'application/json',
                ...options.headers
            },
            ...options
        });
        
        if (!response.ok) {
            throw new Error(`Erro HTTP: ${response.status}`);
        }
        
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Erro na requisição:', error);
        showNotification(`Erro: ${error.message}`, 'danger');
        throw error;
    } finally {
        hideLoading();
    }
}

// Dashboard Functions
async function loadDashboardData() {
    try {
        const [patiosData, motosData] = await Promise.all([
            apiRequest(ENDPOINTS.patios),
            apiRequest(ENDPOINTS.motos)
        ]);
        
        document.getElementById('totalPatios').textContent = patiosData.length;
        document.getElementById('totalMotos').textContent = motosData.length;
        
        patios = patiosData;
        motos = motosData;
    } catch (error) {
        document.getElementById('totalPatios').textContent = 'Erro';
        document.getElementById('totalMotos').textContent = 'Erro';
    }
}

// Pátios Functions
async function loadPatios() {
    try {
        const data = await apiRequest(ENDPOINTS.patios);
        patios = data;
        renderPatiosTable();
    } catch (error) {
        console.error('Erro ao carregar pátios:', error);
    }
}

function renderPatiosTable() {
    const tbody = document.getElementById('patiosTableBody');
    
    if (patios.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="5" class="text-center py-4">
                    <div class="empty-state">
                        <i class="fas fa-building"></i>
                        <h4>Nenhum pátio encontrado</h4>
                        <p>Clique em "Novo Pátio" para adicionar o primeiro pátio.</p>
                    </div>
                </td>
            </tr>
        `;
        return;
    }
    
    tbody.innerHTML = patios.map(patio => `
        <tr>
            <td>${patio.id}</td>
            <td>${patio.nome}</td>
            <td>${patio.endereco}</td>
            <td>${patio.capacidade}</td>
            <td>
                <button class="btn btn-warning btn-action btn-edit" onclick="editPatio(${patio.id})" title="Editar">
                    <i class="fas fa-edit"></i>
                </button>
                <button class="btn btn-danger btn-action btn-delete" onclick="deletePatio(${patio.id})" title="Excluir">
                    <i class="fas fa-trash"></i>
                </button>
            </td>
        </tr>
    `).join('');
}

function openPatioModal(patioId = null) {
    editingPatioId = patioId;
    const modal = document.getElementById('patioModal');
    const title = document.getElementById('patioModalTitle');
    const form = document.getElementById('patioForm');
    
    if (patioId) {
        // Modo edição
        const patio = patios.find(p => p.id === patioId);
        if (patio) {
            title.textContent = 'Editar Pátio';
            document.getElementById('patioId').value = patio.id;
            document.getElementById('patioNome').value = patio.nome;
            document.getElementById('patioEndereco').value = patio.endereco;
            document.getElementById('patioCapacidade').value = patio.capacidade;
        }
    } else {
        // Modo criação
        title.textContent = 'Novo Pátio';
        form.reset();
        document.getElementById('patioId').value = '';
    }
}

async function savePatio() {
    const form = document.getElementById('patioForm');
    
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }
    
    const patioData = {
        nome: document.getElementById('patioNome').value,
        endereco: document.getElementById('patioEndereco').value,
        capacidade: parseInt(document.getElementById('patioCapacidade').value)
    };
    
    try {
        if (editingPatioId) {
            // Atualizar pátio existente
            await apiRequest(`${ENDPOINTS.patios}/${editingPatioId}`, {
                method: 'PUT',
                body: JSON.stringify(patioData)
            });
            showNotification('Pátio atualizado com sucesso!');
        } else {
            // Criar novo pátio
            await apiRequest(ENDPOINTS.patios, {
                method: 'POST',
                body: JSON.stringify(patioData)
            });
            showNotification('Pátio criado com sucesso!');
        }
        
        // Fechar modal e recarregar dados
        const modal = bootstrap.Modal.getInstance(document.getElementById('patioModal'));
        modal.hide();
        loadPatios();
        loadDashboardData();
        
    } catch (error) {
        console.error('Erro ao salvar pátio:', error);
    }
}

function editPatio(patioId) {
    openPatioModal(patioId);
    const modal = new bootstrap.Modal(document.getElementById('patioModal'));
    modal.show();
}

async function deletePatio(patioId) {
    const patio = patios.find(p => p.id === patioId);
    if (!patio) return;
    
    if (confirm(`Tem certeza que deseja excluir o pátio "${patio.nome}"?`)) {
        try {
            await apiRequest(`${ENDPOINTS.patios}/${patioId}`, {
                method: 'DELETE'
            });
            showNotification('Pátio excluído com sucesso!');
            loadPatios();
            loadDashboardData();
        } catch (error) {
            console.error('Erro ao excluir pátio:', error);
        }
    }
}

// Motos Functions
async function loadMotos() {
    try {
        const data = await apiRequest(ENDPOINTS.motos);
        motos = data;
        renderMotosTable();
    } catch (error) {
        console.error('Erro ao carregar motos:', error);
    }
}

function renderMotosTable() {
    const tbody = document.getElementById('motosTableBody');
    
    if (motos.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="6" class="text-center py-4">
                    <div class="empty-state">
                        <i class="fas fa-motorcycle"></i>
                        <h4>Nenhuma moto encontrada</h4>
                        <p>Clique em "Nova Moto" para adicionar a primeira moto.</p>
                    </div>
                </td>
            </tr>
        `;
        return;
    }
    
    tbody.innerHTML = motos.map(moto => {
        const patio = patios.find(p => p.id === moto.patioId);
        const patioNome = patio ? patio.nome : 'N/A';
        
        return `
            <tr>
                <td>${moto.id}</td>
                <td>${moto.placa}</td>
                <td>${moto.modelo}</td>
                <td>${moto.ano}</td>
                <td>${patioNome}</td>
                <td>
                    <button class="btn btn-warning btn-action btn-edit" onclick="editMoto(${moto.id})" title="Editar">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-danger btn-action btn-delete" onclick="deleteMoto(${moto.id})" title="Excluir">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            </tr>
        `;
    }).join('');
}

async function loadPatiosForSelect() {
    try {
        if (patios.length === 0) {
            const data = await apiRequest(ENDPOINTS.patios);
            patios = data;
        }
        
        const select = document.getElementById('motoPatioId');
        select.innerHTML = '<option value="">Selecione um pátio</option>';
        
        patios.forEach(patio => {
            const option = document.createElement('option');
            option.value = patio.id;
            option.textContent = patio.nome;
            select.appendChild(option);
        });
    } catch (error) {
        console.error('Erro ao carregar pátios para select:', error);
    }
}

function openMotoModal(motoId = null) {
    editingMotoId = motoId;
    const modal = document.getElementById('motoModal');
    const title = document.getElementById('motoModalTitle');
    const form = document.getElementById('motoForm');
    
    if (motoId) {
        // Modo edição
        const moto = motos.find(m => m.id === motoId);
        if (moto) {
            title.textContent = 'Editar Moto';
            document.getElementById('motoId').value = moto.id;
            document.getElementById('motoPlaca').value = moto.placa;
            document.getElementById('motoModelo').value = moto.modelo;
            document.getElementById('motoAno').value = moto.ano;
            document.getElementById('motoPatioId').value = moto.patioId;
        }
    } else {
        // Modo criação
        title.textContent = 'Nova Moto';
        form.reset();
        document.getElementById('motoId').value = '';
    }
}

async function saveMoto() {
    const form = document.getElementById('motoForm');
    
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }
    
    const motoData = {
        placa: document.getElementById('motoPlaca').value,
        modelo: document.getElementById('motoModelo').value,
        ano: parseInt(document.getElementById('motoAno').value),
        patioId: parseInt(document.getElementById('motoPatioId').value)
    };
    
    try {
        if (editingMotoId) {
            // Atualizar moto existente
            await apiRequest(`${ENDPOINTS.motos}/${editingMotoId}`, {
                method: 'PUT',
                body: JSON.stringify(motoData)
            });
            showNotification('Moto atualizada com sucesso!');
        } else {
            // Criar nova moto
            await apiRequest(ENDPOINTS.motos, {
                method: 'POST',
                body: JSON.stringify(motoData)
            });
            showNotification('Moto criada com sucesso!');
        }
        
        // Fechar modal e recarregar dados
        const modal = bootstrap.Modal.getInstance(document.getElementById('motoModal'));
        modal.hide();
        loadMotos();
        loadDashboardData();
        
    } catch (error) {
        console.error('Erro ao salvar moto:', error);
    }
}

function editMoto(motoId) {
    openMotoModal(motoId);
    const modal = new bootstrap.Modal(document.getElementById('motoModal'));
    modal.show();
}

async function deleteMoto(motoId) {
    const moto = motos.find(m => m.id === motoId);
    if (!moto) return;
    
    if (confirm(`Tem certeza que deseja excluir a moto "${moto.placa}"?`)) {
        try {
            await apiRequest(`${ENDPOINTS.motos}/${motoId}`, {
                method: 'DELETE'
            });
            showNotification('Moto excluída com sucesso!');
            loadMotos();
            loadDashboardData();
        } catch (error) {
            console.error('Erro ao excluir moto:', error);
        }
    }
}

// Funções utilitárias
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('pt-BR');
}

function formatCurrency(value) {
    return new Intl.NumberFormat('pt-BR', {
        style: 'currency',
        currency: 'BRL'
    }).format(value);
}

// Event listeners para formulários
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        // Fechar modais com ESC
        const modals = document.querySelectorAll('.modal.show');
        modals.forEach(modal => {
            const modalInstance = bootstrap.Modal.getInstance(modal);
            if (modalInstance) {
                modalInstance.hide();
            }
        });
    }
});

// Interceptar submissão de formulários
document.getElementById('patioForm').addEventListener('submit', function(event) {
    event.preventDefault();
    savePatio();
});

document.getElementById('motoForm').addEventListener('submit', function(event) {
    event.preventDefault();
    saveMoto();
});

console.log('Sistema de Pátios carregado com sucesso!');