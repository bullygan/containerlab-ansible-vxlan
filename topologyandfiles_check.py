import glob
import os

# Agregá archivos importantes de la estructura a chequear
files_required_estructural = ["lab3.yaml", 
"clab-lab3/ansible/ansible-inventory.yml",
 "clab-lab3/ansible/ansible.cfg"
 ]

# Verificación
missing = [f for f in files_required_estructural if not os.path.exists(f)]

if missing:
    print("❌ Faltan archivos clave:")
    for f in missing:
        print("   -", f)
    exit(1)
else:
    print("✅ Todos los archivos estructurales están presentes.")

# Playbooks necesarios para automatizar

playbooks_required = glob.glob("clab-lab3/ansible/nodos/**/*.yml", recursive=True)

# Agregá  archivos de funcionamiento a chequear
playbooks_required += [
"clab-lab3/ansible/orquestador.yml",
"clab-lab3/ansible/instalar_python3.yml",
"clab-lab3/ansible/pruebas_lab3.yml"
 ]

# Verificación 2
missing2 = [f for f in playbooks_required if not os.path.exists(f)]

if missing2:
    print("❌ Faltan playbooks para automatizar:")
    for f in missing2:
        print("   -", f)
    exit(1)
else:
    print("✅ Todos los playbooks necesarios para automatizar están presentes.")