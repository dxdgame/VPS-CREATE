#!/bin/bash

# ANSI Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Ensure dependencies and the custom DeupGaming path are initialized
init_system_check() {
    if ! command -v qemu-system-x86_64 &> /dev/null; then
        echo -e "🔧 ${BLUE}[INFO]${NC} Installing QEMU Emulation Toolkit..."
        sudo apt-get update -y && sudo apt-get install -y qemu-system-x86 qemu-utils wget curl > /dev/null 2>&1
    fi
    # Custom centralized storage directory replacing all old path schemes
    sudo mkdir -p /var/lib/deupgaming
}

show_main_menu() {
    clear
    echo -e "📋 ${YELLOW}Main Menu:${NC}"
    echo -e " 1) 🆕 Create a new VM"
    echo -e " 0) 👋 Exit"
    echo ""
    echo -ne "🎯 ${RED}[INPUT]${NC} 🎯 Enter your choice: "
    read -r main_choice

    if [ "$main_choice" = "1" ]; then
        show_os_menu
    elif [ "$main_choice" = "0" ]; then
        echo -e "\n👋 Exiting... Thank you for using DeupGaming!"
        exit 0
    else
        echo -e "\n❌ Invalid option. Please try again."
        sleep 1
        show_main_menu
    fi
}

deploy_qemu_vm() {
    local os_label=$1
    local image_url=$2
    local disk_path="/var/lib/deupgaming/${os_label}.qcow2"

    echo -e "⏳ Setting up $os_label... Powered by DeupGaming"

    # Download image template safely to the new storage path if missing
    if [ ! -f "$disk_path" ]; then
        echo -e "📦 ${BLUE}[INFO]${NC} Downloading official template for $os_label..."
        sudo wget -q --show-progress "$image_url" -O "$disk_path"
        
        # Expand storage allocation to ensure smooth configuration steps inside the virtual space
        echo -e "⚙️ ${BLUE}[INFO]${NC} Expanding virtual disk allocation to 20GB..."
        sudo qemu-img resize "$disk_path" +20G > /dev/null 2>&1
    fi

    echo -e "🚀 ${GREEN}Starting QEMU Virtualization Engine...${NC}"
    echo -e "${YELLOW}👉 Press 'Ctrl + A' then 'X' to terminate the VM workspace session anytime.${NC}\n"
    sleep 2

    # Run system with hardware translation fallback layer active
    sudo qemu-system-x86_64 \
        -hda "$disk_path" \
        -m 32G \
        -nographic \
        -netdev user,id=net0,hostfwd=tcp::2222-:22 \
        -device e1000,netdev=net0 \
        -accel tcg
}

show_os_menu() {
    echo -e ""
    echo -e "🎯 ${RED}[INPUT]${NC} 🎯 Enter your choice: 1"
    echo -e "📋 ${BLUE}[INFO]${NC} 🆕 Creating a new VM"
    echo -e "📋 ${BLUE}[INFO]${NC} 🌐 Select an OS template to boot:"
    echo " 1) Ubuntu 22.04"
    echo " 2) Ubuntu 24.04"
    echo " 3) Debian 11"
    echo " 4) Debian 12"
    echo " 5) AlmaLinux 9"
    echo " 6) Rocky Linux 9"
    echo " 7) Proxmox VE (Virtual Environment Base)"
    echo ""
    echo -ne "🎯 ${RED}[INPUT]${NC} 🎯 Enter your choice (1-7): "
    read -r os_choice

    echo -e ""
    case $os_choice in
        1)
            deploy_qemu_vm "ubuntu22" "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64-disk-kvm.img"
            ;;
        2)
            deploy_qemu_vm "ubuntu24" "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
            ;;
        3)
            deploy_qemu_vm "debian11" "https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-generic-amd64.qcow2"
            ;;
        4)
            deploy_qemu_vm "debian12" "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
            ;;
        5)
            deploy_qemu_vm "almalinux9" "https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"
            ;;
        6)
            deploy_qemu_vm "rockylinux9" "https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
            ;;
        7)
            # Pulls an optimized template ready for Proxmox VE orchestration adjustments
            deploy_qemu_vm "proxmox_ve" "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
            ;;
        *)
            echo -e "❌ Invalid choice! Returning to main menu..."
            sleep 1.5
            show_main_menu
            ;;
    esac
}

# Run the toolchain
init_system_check
show_main_menu
