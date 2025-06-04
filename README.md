# Containerlab + Ansible: Laboratorio de Red Empresarial con VxLAN, DNS y Servidor Web

Este proyecto simula la infraestructura de red de una empresa con una sede central y una sucursal, conectadas mediante una red VxLAN. El laboratorio está orquestado con [Containerlab](https://containerlab.dev/) y completamente automatizado con [Ansible](https://www.ansible.com/).

---

## 🧠 Objetivo del proyecto

El objetivo es diseñar, implementar y automatizar una red empresarial que incluya:

- Conectividad entre sedes a través de **VxLAN**
- Implementación de **DNS primario y secundario** con Bind9
- **Servidor Web Apache** con dos sitios (sitio1.com y sitio2.com) y sus respectivos alias
- Automatización total con **Ansible** de todos los nodos y servicios

---

## 🛠️ Tecnologías utilizadas

- 🐳 **Containerlab**: despliegue de la topología de red en contenedores
- ⚙️ **Ansible**: automatización de configuración y servicios
- 🌐 **Bind9**: servidores DNS primario y secundario
- 🕸️ **Apache2**: servidor web con múltiples sitios virtuales
- 🛜 **FRRouting**: enrutamiento dinámico y soporte VxLAN

---

## 🔄 Dos enfoques de configuración

Este laboratorio fue evolucionando desde una configuración basada en scripts `.sh` hacia una solución completamente automatizada con Ansible. Ambos enfoques están disponibles en el repositorio para comparación y aprendizaje:

### 🧪 Versión 1 – Configuración manual por scripts

Ubicados en `configs/`, estos scripts eran ejecutados manualmente o se podian ejecutar todos juntos desde `todoconfig.sh` que se encarga de entrar a cada contenedor para ejecutar la configuración de cada nodo.

> ⚠️ Este enfoque está **deprecated** y se mantiene con fines educativos e históricos.

### 🤖 Versión 2 – Automatización completa con Ansible

Ubicada en `clab-lab3/ansible/`, esta versión reemplaza completamente la configuración manual, permitiendo aplicar toda la lógica del laboratorio con un solo playbook orquestador automatizando no solo las configuraciones sino tambien el despliegue del laboratorio en containerlab. Usa las ventajas de las tags para aprovechar la modularizacion y ejecutar las partes del playbook que se requiera segun las tareas que se necesiten correr.

> ✅ Este es el enfoque recomendado y actual.

---

## 🗺️ Topología de red

La red simula una planta industrial con:

- 📍 Casa Central
- 🏢 Sucursal
- 🔄 Interconexión mediante VxLAN
- 📡 Servidores DNS
- 🌐 Web server con dos sitios: `sitio1.com` y `sitio2.com` (con alias `alias1.com` y `alias2.com`)

---

## ▶️ Cómo usar este laboratorio

1. Cloná el repositorio:
En una consola ejecutar:
- git clone https://github.com/bullygancontainerlab-ansible-vxlan-lab.git

2. Ir al repositorio local donde se clonó el laboratorio:   
- cd containerlab-ansible-vxlan-lab

3. Desplegá la topología con Containerlab (opcional, ya que el playbook de ansible tambien desplega la topologia):
- sudo containerlab deploy -t lab3.yaml

4. Ejecutá la automatización completa con Ansible:
- cd clab-lab3/ansible
- ansible-playbook orquestador.yml

🚀 ¡Listo! Ya tenés toda la red configurada automáticamente.

📂 Estructura del repositorio

├── lab3.yaml                # Topología Containerlab
├── configs/                 # Configs base por nodo
├── clab-lab3/
│   └── ansible/             # Playbooks y roles de Ansible
│       ├── nodos/           # Config individual por nodo
│       ├── orquestador.yml  # Playbook principal
|       └── pruebas_lab3.yml # Playbook para pruebas de red.
├── todoconfig.sh            # Script inicial (deprecated por Ansible)
└── README.md

👤 Autor
Juan Pablo Geuna 
Estudiante de Ingeniería en Telecomunicaciones

💼 Proyecto académico - MAteria: Redes de Información
🔗 GitHub: @bullygan