#!/bin/bash

# Define colors for styling
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function for Main Menu
show_main_menu() {
    clear
    echo -e "${CYAN}┌────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│                                        │${NC}"
    echo -e "${CYAN}│               ${WHITE}JISHNU${CYAN}                   │${NC}"
    echo -e "${CYAN}│               ${GRAY}N E T W O R K${CYAN}            │${NC}"
    echo -e "${CYAN}│                                        │${NC}"
    echo -e "${CYAN}└────────────────────────────────────────┘${NC}"
    echo -e "       ${GRAY}Made by Jishnu, B1 , Modife - nobita${NC}\n"

    echo -e "📋 ${YELLOW}Main Menu:${NC}"
    echo -e " 1) 🆕 Create a new VM"
    echo -e " 0) 👋 Exit"
    echo ""
    echo -ne "🎯 ${RED}[INPUT]${NC} 🎯 Enter your choice: "
    read -r main_choice

    case $main_choice in
        1)
            show_os_menu
            ;;
        0)
            echo -e "\n👋 Exiting... Goodbye!"
            exit 0
            ;;
        *)
            echo -e "\n❌ Invalid option! Returning to menu..."
            sleep 2
            show_main_menu
            ;;
    esac
}

# Function for OS Selection Menu
show_os_menu() {
    # Keep the header on top as seen in image_a3ab5c.png
    echo -e "\n🎯 ${RED}[INPUT]${NC} 🎯 Enter your choice: 1"
    echo -e "📋 ${BLUE}[INFO]${NC} 🆕 Creating a new VM"
    echo -e "📋 ${BLUE}[INFO]${NC} 🌐 Select an OS to set up:"
    echo " 1) Ubuntu 22.04"
    echo " 2) AlmaLinux 9"
    echo " 3) CentOS Stream 9"
    echo " 4) Ubuntu 24.04"
    echo " 5) Rocky Linux 9"
    echo " 6) Fedora 40"
    echo " 7) Debian 11"
    echo " 8) Debian 13"
    echo " 9) Debian 12"
    echo ""
    echo -ne "🎯 ${RED}[INPUT]${NC} 🎯 Enter your choice (1-9): "
    read -r os_choice

    case $os_choice in
        1) echo -e "\n⏳ Setting up Ubuntu 22.04...";;
        2) echo -e "\n⏳ Setting up AlmaLinux 9...";;
        3) echo -e "\n⏳ Setting up CentOS Stream 9...";;
        4) echo -e "\n⏳ Setting up Ubuntu 24.04...";;
        5) echo -e "\n⏳ Setting up Rocky Linux 9...";;
        6) echo -e "\n⏳ Setting up Fedora 40...";;
        7) echo -e "\n⏳ Setting up Debian 11...";;
        8) echo -e "\n⏳ Setting up Debian 13...";;
        9) echo -e "\n⏳ Setting up Debian 12...";;
        *) 
            echo -e "\n❌ Invalid choice! Going back to main menu."
            sleep 2
            show_main_menu
            ;;
    esac
}

# Start the script loop
show_main_menu
