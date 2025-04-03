#!/bin/bash

# Linux and SAP BASIS Interactive Cheatsheet
# Miguel Lopez - All rights reserved

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Global variables
language=""
topic=""
difficulty=""
correct_answers=0
total_questions=0

# Function to clear screen
clear_screen() {
    clear
}

# Function to display welcome message
display_welcome() {
    clear_screen
    echo -e "${BOLD}${CYAN}"
    echo "┌─────────────────────────────────────────────────────┐"
    echo "│                                                     │"
    echo "│   LINUX COMMANDS & SAP BASIS TRANSACTION TRAINER    │"
    echo "│                                                     │"
    echo "│              © Miguel Lopez - 2025                  │"
    echo "│                                                     │"
    echo "└─────────────────────────────────────────────────────┘"
    echo -e "${NC}"
    echo ""
}

# Function to select language
select_language() {
    echo -e "${BOLD}${YELLOW}Please select your language / Por favor seleccione su idioma:${NC}"
    echo -e "1) ${BLUE}English${NC}"
    echo -e "2) ${BLUE}Spanish${NC}"
    echo ""
    
    while true; do
        read -p "Enter your choice (1-2): " lang_choice
        case $lang_choice in
            1)
                language="english"
                break
                ;;
            2)
                language="spanish"
                break
                ;;
            *)
                echo -e "${RED}Invalid selection. Please try again.${NC}"
                ;;
        esac
    done
}

# Function to display topic selection
select_topic() {
    if [ "$language" == "english" ]; then
        echo -e "${BOLD}${YELLOW}Please select a topic:${NC}"
        echo -e "1) ${BLUE}Linux Basic Commands${NC}"
        echo -e "2) ${BLUE}SAP BASIS Transactions${NC}"
        echo -e "3) ${BLUE}Both (Mixed questions)${NC}"
    else
        echo -e "${BOLD}${YELLOW}Por favor seleccione un tema:${NC}"
        echo -e "1) ${BLUE}Comandos Básicos de Linux${NC}"
        echo -e "2) ${BLUE}Transacciones SAP BASIS${NC}"
        echo -e "3) ${BLUE}Ambos (Preguntas mezcladas)${NC}"
    fi
    echo ""
    
    while true; do
        if [ "$language" == "english" ]; then
            read -p "Enter your choice (1-3): " topic_choice
        else
            read -p "Ingrese su elección (1-3): " topic_choice
        fi
        
        case $topic_choice in
            1)
                topic="linux"
                break
                ;;
            2)
                topic="sap"
                break
                ;;
            3)
                topic="both"
                break
                ;;
            *)
                if [ "$language" == "english" ]; then
                    echo -e "${RED}Invalid selection. Please try again.${NC}"
                else
                    echo -e "${RED}Selección inválida. Por favor intente de nuevo.${NC}"
                fi
                ;;
        esac
    done
}

# Function to select difficulty
select_difficulty() {
    if [ "$language" == "english" ]; then
        echo -e "${BOLD}${YELLOW}Please select difficulty level:${NC}"
        echo -e "1) ${GREEN}Easy${NC} (5 questions)"
        echo -e "2) ${YELLOW}Hard${NC} (10 questions)"
        echo -e "3) ${RED}Very Hard${NC} (25 questions)"
    else
        echo -e "${BOLD}${YELLOW}Por favor seleccione el nivel de dificultad:${NC}"
        echo -e "1) ${GREEN}Fácil${NC} (5 preguntas)"
        echo -e "2) ${YELLOW}Difícil${NC} (10 preguntas)"
        echo -e "3) ${RED}Muy Difícil${NC} (25 preguntas)"
    fi
    echo ""
    
    while true; do
        if [ "$language" == "english" ]; then
            read -p "Enter your choice (1-3): " diff_choice
        else
            read -p "Ingrese su elección (1-3): " diff_choice
        fi
        
        case $diff_choice in
            1)
                difficulty="easy"
                total_questions=5
                break
                ;;
            2)
                difficulty="hard"
                total_questions=10
                break
                ;;
            3)
                difficulty="very_hard"
                total_questions=25
                break
                ;;
            *)
                if [ "$language" == "english" ]; then
                    echo -e "${RED}Invalid selection. Please try again.${NC}"
                else
                    echo -e "${RED}Selección inválida. Por favor intente de nuevo.${NC}"
                fi
                ;;
        esac
    done
}

# Generate a random order for questions
generate_question_order() {
    # Create an array of question indices
    question_order=()
    for ((i=0; i<25; i++)); do
        question_order+=($i)
    done
    
    # Shuffle the array using Fisher-Yates algorithm
    for ((i=24; i>0; i--)); do
        j=$(($RANDOM % (i+1)))
        # Swap elements
        temp=${question_order[$i]}
        question_order[$i]=${question_order[$j]}
        question_order[$j]=$temp
    done
}

# Function to shuffle options for a question
shuffle_options() {
    local original_options=("$1" "$2" "$3" "$4")
    local original_correct=$5
    
    # Create array for new order and correct answer position
    shuffled_order=(0 1 2 3)
    new_correct_pos=0
    
    # Shuffle the order array
    for ((i=3; i>0; i--)); do
        j=$(($RANDOM % (i+1)))
        # Track where the correct answer goes
        if [ $i -eq $((original_correct-1)) ]; then
            new_correct_pos=$j
        elif [ $j -eq $((original_correct-1)) ]; then
            new_correct_pos=$i
        fi
        # Swap elements
        temp=${shuffled_order[$i]}
        shuffled_order[$i]=${shuffled_order[$j]}
        shuffled_order[$j]=$temp
    done
    
    # Prepare shuffled options array
    shuffled_options=()
    for i in {0..3}; do
        shuffled_options+=(${original_options[${shuffled_order[$i]}]})
    done
    
    # Adjust the correct answer position (1-based)
    for i in {0..3}; do
        if [ ${shuffled_order[$i]} -eq $((original_correct-1)) ]; then
            new_correct_pos=$((i+1))
            break
        fi
    done
}

# Function to ask Linux questions
ask_linux_question() {
    local question_num=$1
    local question=""
    local options=()
    local correct_answer=0
    
    # Linux questions in English
    if [ "$language" == "english" ]; then
        case $question_num in
            0)
                question="What command is used to list files in a directory?"
                option1="ls"
                option2="dir"
                option3="list"
                option4="show"
                correct_answer=1
                ;;
            1)
                question="Which command changes directories?"
                option1="cd"
                option2="chdir"
                option3="move"
                option4="goto"
                correct_answer=1
                ;;
            2)
                question="How do you create a new directory?"
                option1="mkdir"
                option2="newdir"
                option3="createdir"
                option4="md"
                correct_answer=1
                ;;
            3)
                question="Which command removes a file?"
                option1="rm"
                option2="del"
                option3="erase"
                option4="delete"
                correct_answer=1
                ;;
            4)
                question="What command displays the current working directory?"
                option1="pwd"
                option2="cd"
                option3="cwd"
                option4="path"
                correct_answer=1
                ;;
            5)
                question="Which command is used to copy files?"
                option1="cp"
                option2="copy"
                option3="cpy"
                option4="duplicate"
                correct_answer=1
                ;;
            6)
                question="How do you move or rename a file?"
                option1="mv"
                option2="move"
                option3="rename"
                option4="rn"
                correct_answer=1
                ;;
            7)
                question="Which command displays the contents of a file on the screen?"
                option1="cat"
                option2="type"
                option3="show"
                option4="display"
                correct_answer=1
                ;;
            8)
                question="What command is used to find text patterns in files?"
                option1="grep"
                option2="find"
                option3="search"
                option4="locate"
                correct_answer=1
                ;;
            9)
                question="Which command changes file permissions?"
                option1="chmod"
                option2="perm"
                option3="chperm"
                option4="attrib"
                correct_answer=1
                ;;
            10)
                question="How do you check disk space usage?"
                option1="df"
                option2="disk"
                option3="space"
                option4="check"
                correct_answer=1
                ;;
            11)
                question="Which command creates an empty file?"
                option1="touch"
                option2="create"
                option3="new"
                option4="make"
                correct_answer=1
                ;;
            12)
                question="What command shows all running processes?"
                option1="ps"
                option2="proc"
                option3="list"
                option4="task"
                correct_answer=1
                ;;
            13)
                question="Which command kills a process?"
                option1="kill"
                option2="end"
                option3="terminate"
                option4="stop"
                correct_answer=1
                ;;
            14)
                question="What command shows system memory usage?"
                option1="free"
                option2="mem"
                option3="memory"
                option4="check"
                correct_answer=1
                ;;
            15)
                question="Which command do you use to change a user's password?"
                option1="passwd"
                option2="password"
                option3="changepass"
                option4="setpass"
                correct_answer=1
                ;;
            16)
                question="What command compresses files using gzip?"
                option1="gzip"
                option2="compress"
                option3="zip"
                option4="compact"
                correct_answer=1
                ;;
            17)
                question="Which command extracts files from a tar archive?"
                option1="tar -xf"
                option2="extract"
                option3="untar"
                option4="unpack"
                correct_answer=1
                ;;
            18)
                question="What command shows the end of a file?"
                option1="tail"
                option2="end"
                option3="last"
                option4="finish"
                correct_answer=1
                ;;
            19)
                question="Which command shows the beginning of a file?"
                option1="head"
                option2="start"
                option3="begin"
                option4="first"
                correct_answer=1
                ;;
            20)
                question="What command is used to edit text files in the terminal?"
                option1="nano"
                option2="edit"
                option3="modify"
                option4="change"
                correct_answer=1
                ;;
            21)
                question="Which command shows network configuration?"
                option1="ifconfig"
                option2="network"
                option3="netcfg"
                option4="netstat"
                correct_answer=1
                ;;
            22)
                question="What command is used to download files from the internet?"
                option1="wget"
                option2="download"
                option3="get"
                option4="fetch"
                correct_answer=1
                ;;
            23)
                question="Which command shows disk usage of directories?"
                option1="du"
                option2="dirsize"
                option3="diskuse"
                option4="diruse"
                correct_answer=1
                ;;
            24)
                question="What command schedules tasks to run later?"
                option1="cron"
                option2="schedule"
                option3="later"
                option4="task"
                correct_answer=1
                ;;
        esac
    # Linux questions in Spanish
    else
        case $question_num in
            0)
                question="¿Qué comando se usa para listar archivos en un directorio?"
                option1="ls"
                option2="dir"
                option3="lista"
                option4="mostrar"
                correct_answer=1
                ;;
            1)
                question="¿Qué comando cambia de directorio?"
                option1="cd"
                option2="chdir"
                option3="mover"
                option4="ir"
                correct_answer=1
                ;;
            2)
                question="¿Cómo se crea un nuevo directorio?"
                option1="mkdir"
                option2="nuevadir"
                option3="creardir"
                option4="md"
                correct_answer=1
                ;;
            3)
                question="¿Qué comando elimina un archivo?"
                option1="rm"
                option2="del"
                option3="borrar"
                option4="eliminar"
                correct_answer=1
                ;;
            4)
                question="¿Qué comando muestra el directorio de trabajo actual?"
                option1="pwd"
                option2="cd"
                option3="cwd"
                option4="ruta"
                correct_answer=1
                ;;
            5)
                question="¿Qué comando se usa para copiar archivos?"
                option1="cp"
                option2="copiar"
                option3="copia"
                option4="duplicar"
                correct_answer=1
                ;;
            6)
                question="¿Cómo se mueve o renombra un archivo?"
                option1="mv"
                option2="mover"
                option3="renombrar"
                option4="rn"
                correct_answer=1
                ;;
            7)
                question="¿Qué comando muestra el contenido de un archivo en pantalla?"
                option1="cat"
                option2="tipo"
                option3="mostrar"
                option4="ver"
                correct_answer=1
                ;;
            8)
                question="¿Qué comando se usa para buscar patrones de texto en archivos?"
                option1="grep"
                option2="buscar"
                option3="encontrar"
                option4="localizar"
                correct_answer=1
                ;;
            9)
                question="¿Qué comando cambia los permisos de los archivos?"
                option1="chmod"
                option2="perm"
                option3="chperm"
                option4="atributo"
                correct_answer=1
                ;;
            10)
                question="¿Cómo se verifica el uso del espacio en disco?"
                option1="df"
                option2="disco"
                option3="espacio"
                option4="revisar"
                correct_answer=1
                ;;
            11)
                question="¿Qué comando crea un archivo vacío?"
                option1="touch"
                option2="crear"
                option3="nuevo"
                option4="hacer"
                correct_answer=1
                ;;
            12)
                question="¿Qué comando muestra todos los procesos en ejecución?"
                option1="ps"
                option2="proc"
                option3="lista"
                option4="tarea"
                correct_answer=1
                ;;
            13)
                question="¿Qué comando termina un proceso?"
                option1="kill"
                option2="fin"
                option3="terminar"
                option4="detener"
                correct_answer=1
                ;;
            14)
                question="¿Qué comando muestra el uso de memoria del sistema?"
                option1="free"
                option2="mem"
                option3="memoria"
                option4="revisar"
                correct_answer=1
                ;;
            15)
                question="¿Qué comando se usa para cambiar la contraseña de un usuario?"
                option1="passwd"
                option2="password"
                option3="cambiarpass"
                option4="configurarpass"
                correct_answer=1
                ;;
            16)
                question="¿Qué comando comprime archivos usando gzip?"
                option1="gzip"
                option2="comprimir"
                option3="zip"
                option4="compactar"
                correct_answer=1
                ;;
            17)
                question="¿Qué comando extrae archivos de un archivo tar?"
                option1="tar -xf"
                option2="extraer"
                option3="untar"
                option4="desempaquetar"
                correct_answer=1
                ;;
            18)
                question="¿Qué comando muestra el final de un archivo?"
                option1="tail"
                option2="fin"
                option3="último"
                option4="final"
                correct_answer=1
                ;;
            19)
                question="¿Qué comando muestra el principio de un archivo?"
                option1="head"
                option2="inicio"
                option3="comenzar"
                option4="primero"
                correct_answer=1
                ;;
            20)
                question="¿Qué comando se usa para editar archivos de texto en la terminal?"
                option1="nano"
                option2="editar"
                option3="modificar"
                option4="cambiar"
                correct_answer=1
                ;;
            21)
                question="¿Qué comando muestra la configuración de red?"
                option1="ifconfig"
                option2="red"
                option3="netcfg"
                option4="netstat"
                correct_answer=1
                ;;
            22)
                question="¿Qué comando se usa para descargar archivos de Internet?"
                option1="wget"
                option2="descargar"
                option3="obtener"
                option4="bajar"
                correct_answer=1
                ;;
            23)
                question="¿Qué comando muestra el uso de disco por directorios?"
                option1="du"
                option2="tamañodir"
                option3="usodisco"
                option4="usodir"
                correct_answer=1
                ;;
            24)
                question="¿Qué comando programa tareas para ejecutarse más tarde?"
                option1="cron"
                option2="programar"
                option3="después"
                option4="tarea"
                correct_answer=1
                ;;
        esac
    fi
    
    # Shuffle options
    shuffle_options "$option1" "$option2" "$option3" "$option4" "$correct_answer"
    options=("${shuffled_options[@]}")
    correct_answer=$new_correct_pos
    
    # Display question
    echo -e "${BOLD}${BLUE}Question $((current_question+1)):${NC} $question"
    
    # Display options
    for i in {0..3}; do
        echo -e "$((i+1))) ${CYAN}${options[$i]}${NC}"
    done
    
    # Get user's answer
    local user_answer
    while true; do
        if [ "$language" == "english" ]; then
            read -p "Enter your answer (1-4): " user_answer
        else
            read -p "Ingrese su respuesta (1-4): " user_answer
        fi
        
        if [[ "$user_answer" =~ ^[1-4]$ ]]; then
            break
        else
            if [ "$language" == "english" ]; then
                echo -e "${RED}Invalid input. Please enter a number between 1 and 4.${NC}"
            else
                echo -e "${RED}Entrada inválida. Por favor ingrese un número entre 1 y 4.${NC}"
            fi
        fi
    done
    
    # Check if correct
    if [ "$user_answer" -eq "$correct_answer" ]; then
        if [ "$language" == "english" ]; then
            echo -e "${GREEN}Correct!${NC}"
        else
            echo -e "${GREEN}¡Correcto!${NC}"
        fi
        correct_answers=$((correct_answers+1))
    else
        if [ "$language" == "english" ]; then
            echo -e "${RED}Incorrect. The correct answer is ${options[$((correct_answer-1))]}.${NC}"
        else
            echo -e "${RED}Incorrecto. La respuesta correcta es ${options[$((correct_answer-1))]}.${NC}"
        fi
    fi
    
    echo ""
    if [ "$language" == "english" ]; then
        echo -e "Press Enter to continue to the next question..."
        read -t 1 dummy || true  # Wait for a keystroke with a timeout of 1 second
        sleep 1  # Additional pause to see the result before moving on
    else
        echo -e "Presione Enter para continuar a la siguiente pregunta..."
        read -t 1 dummy || true  # Wait for a keystroke with a timeout of 1 second
        sleep 1  # Additional pause to see the result before moving on
    fi
}

# Function to ask SAP BASIS questions
ask_sap_question() {
    local question_num=$1
    local question=""
    local options=()
    local correct_answer=0
    
    # SAP BASIS questions in English
    if [ "$language" == "english" ]; then
        case $question_num in
            0)
                question="Which transaction is used to monitor system logs?"
                option1="SM21"
                option2="ST22"
                option3="SM50"
                option4="SM66"
                correct_answer=1
                ;;
            1)
                question="What transaction is used for user management?"
                option1="SU01"
                option2="SM12"
                option3="SM36"
                option4="SM37"
                correct_answer=1
                ;;
            2)
                question="Which transaction is used to check for system errors?"
                option1="ST22"
                option2="SM21"
                option3="SM50"
                option4="SM51"
                correct_answer=1
                ;;
            3)
                question="What transaction is used to view work processes?"
                option1="SM50"
                option2="SM66"
                option3="ST22"
                option4="SM37"
                correct_answer=1
                ;;
            4)
                question="Which transaction monitors system performance?"
                option1="ST03"
                option2="SM50"
                option3="ST22"
                option4="SM21"
                correct_answer=1
                ;;
            5)
                question="What transaction is used to create transport requests?"
                option1="SE01"
                option2="SE10"
                option3="SE09"
                option4="SE11"
                correct_answer=2
                ;;
            6)
                question="Which transaction is used to view job logs?"
                option1="SM37"
                option2="SM36"
                option3="SM21"
                option4="ST22"
                correct_answer=1
                ;;
            7)
                question="What transaction is used to display system locks?"
                option1="SM12"
                option2="SM21"
                option3="SU01"
                option4="SM50"
                correct_answer=1
                ;;
            8)
                question="Which transaction is used for table maintenance?"
                option1="SE11"
                option2="SE16"
                option3="SE38"
                option4="SE80"
                correct_answer=1
                ;;
            9)
                question="What transaction is used to schedule background jobs?"
                option1="SM36"
                option2="SM37"
                option3="SM50"
                option4="SM66"
                correct_answer=1
                ;;
            10)
                question="Which transaction shows all SAP servers in the system?"
                option1="SM51"
                option2="SM50"
                option3="SM66"
                option4="ST03"
                correct_answer=1
                ;;
            11)
                question="What transaction is used for client administration?"
                option1="SCC4"
                option2="SE06"
                option3="SM59"
                option4="SE11"
                correct_answer=1
                ;;
            12)
                question="Which transaction is used to configure RFC connections?"
                option1="SM59"
                option2="ST01"
                option3="SCC4"
                option4="SM69"
                correct_answer=1
                ;;
            13)
                question="What transaction is used to view update records?"
                option1="SM13"
                option2="SM12"
                option3="SM21"
                option4="SM37"
                correct_answer=1
                ;;
            14)
                question="Which transaction is used to view ABAP dump analysis?"
                option1="ST22"
                option2="SM21"
                option3="SM50"
                option4="SM37"
                correct_answer=1
                ;;
            15)
                question="What transaction is used to check authorization objects?"
                option1="SU53"
                option2="SU01"
                option3="SE16"
                option4="SE11"
                correct_answer=1
                ;;
            16)
                question="Which transaction displays application server information?"
                option1="SM66"
                option2="SM50"
                option3="SM51"
                option4="ST03"
                correct_answer=1
                ;;
            17)
                question="What transaction is used for transport management?"
                option1="STMS"
                option2="SE01"
                option3="SE10"
                option4="SM59"
                correct_answer=1
                ;;
            18)
                question="Which transaction is used for global settings?"
                option1="SPRO"
                option2="SCC4"
                option3="SE06"
                option4="SM59"
                correct_answer=1
                ;;
            19)
                question="What transaction is used to view file system?"
                option1="AL11"
                option2="SM51"
                option3="SM37"
                option4="ST06"
                correct_answer=1
                ;;
            20)
                question="Which transaction is used to check operating system information?"
                option1="ST06"
                option2="ST03"
                option3="SM51"
                option4="AL11"
                correct_answer=1
                ;;
            21)
                question="What transaction is used for spool administration?"
                option1="SP01"
                option2="SM50"
                option3="SM36"
                option4="SE38"
                correct_answer=1
                ;;
            22)
                question="Which transaction is used to check database space?"
                option1="DB02"
                option2="ST04"
                option3="SM66"
                option4="AL11"
                correct_answer=1
                ;;
            23)
                question="What transaction is used to monitor database performance?"
                option1="ST04"
                option2="DB02"
                option3="AL11"
                option4="ST06"
                correct_answer=1
                ;;
            24)
                question="Which transaction is used to manage system profiles?"
                option1="RZ10"
                option2="SP01"
                option3="SM50"
                option4="ST04"
                correct_answer=1
                ;;
        esac
    # SAP BASIS questions in Spanish
    else
        case $question_num in
            0)
                question="¿Qué transacción se usa para monitorear los registros del sistema?"
                option1="SM21"
                option2="ST22"
                option3="SM50"
                option4="SM66"
                correct_answer=1
                ;;
            1)
                question="¿Qué transacción se usa para la gestión de usuarios?"
                option1="SU01"
                option2="SM12"
                option3="SM36"
                option4="SM37"
                correct_answer=1
                ;;
            2)
                question="¿Qué transacción se usa para verificar errores del sistema?"
                option1="ST22"
                option2="SM21"
                option3="SM50"
                option4="SM51"
                correct_answer=1
                ;;
            3)
                question="¿Qué transacción se usa para ver los procesos de trabajo?"
                option1="SM50"
                option2="SM66"
                option3="ST22"
                option4="SM37"
                correct_answer=1
                ;;
            4)
                question="¿Qué transacción monitorea el rendimiento del sistema?"
                option1="ST03"
                option2="SM50"
                option3="ST22"
                option4="SM21"
                correct_answer=1
                ;;
            5)
                question="¿Qué transacción se usa para crear solicitudes de transporte?"
                option1="SE01"
                option2="SE10"
                option3="SE09"
                option4="SE11"
                correct_answer=2
                ;;
            6)
                question="¿Qué transacción se usa para ver los registros de trabajos?"
                option1="SM37"
                option2="SM36"
                option3="SM21"
                option4="ST22"
                correct_answer=1
                ;;
            7)
                question="¿Qué transacción se utiliza para mostrar los bloqueos del sistema?"
                option1="SM12"
                option2="SM21"
                option3="SU01"
                option4="SM50"
                correct_answer=1
                ;;
            8)
                question="¿Qué transacción se usa para el mantenimiento de tablas?"
                option1="SE11"
                option2="SE16"
                option3="SE38"
                option4="SE80"
                correct_answer=1
                ;;
            9)
                question="¿Qué transacción se usa para programar trabajos en segundo plano?"
                option1="SM36"
                option2="SM37"
                option3="SM50"
                option4="SM66"
                correct_answer=1
                ;;
            10)
                question="¿Qué transacción muestra todos los servidores SAP en el sistema?"
                option1="SM51"
                option2="SM50"
                option3="SM66"
                option4="ST03"
                correct_answer=1
                ;;
            11)
                question="¿Qué transacción se usa para la administración de clientes?"
                option1="SCC4"
                option2="SE06"
                option3="SM59"
                option4="SE11"
                correct_answer=1
                ;;
            12)
                question="¿Qué transacción se usa para configurar conexiones RFC?"
                option1="SM59"
                option2="ST01"
                option3="SCC4"
                option4="SM69"
                correct_answer=1
                ;;
            13)
                question="¿Qué transacción se usa para ver registros de actualización?"
                option1="SM13"
                option2="SM12"
                option3="SM21"
                option4="SM37"
                correct_answer=1
                ;;
            14)
                question="¿Qué transacción se usa para ver el análisis de volcados ABAP?"
                option1="ST22"
                option2="SM21"
                option3="SM50"
                option4="SM37"
                correct_answer=1
                ;;
            15)
                question="¿Qué transacción se usa para verificar objetos de autorización?"
                option1="SU53"
                option2="SU01"
                option3="SE16"
                option4="SE11"
                correct_answer=1
                ;;
            16)
                question="¿Qué transacción muestra información del servidor de aplicaciones?"
                option1="SM66"
                option2="SM50"
                option3="SM51"
                option4="ST03"
                correct_answer=1
                ;;
            17)
                question="¿Qué transacción se usa para la gestión de transportes?"
                option1="STMS"
                option2="SE01"
                option3="SE10"
                option4="SM59"
                correct_answer=1
                ;;
            18)
                question="¿Qué transacción se usa para configuraciones globales?"
                option1="SPRO"
                option2="SCC4"
                option3="SE06"
                option4="SM59"
                correct_answer=1
                ;;
            19)
                question="¿Qué transacción se usa para ver el sistema de archivos?"
                option1="AL11"
                option2="SM51"
                option3="SM37"
                option4="ST06"
                correct_answer=1
                ;;
            20)
                question="¿Qué transacción se usa para verificar información del sistema operativo?"
                option1="ST06"
                option2="ST03"
                option3="SM51"
                option4="AL11"
                correct_answer=1
                ;;
            21)
                question="¿Qué transacción se usa para la administración de spool?"
                option1="SP01"
                option2="SM50"
                option3="SM36"
                option4="SE38"
                correct_answer=1
                ;;
            22)
                question="¿Qué transacción se usa para verificar el espacio de la base de datos?"
                option1="DB02"
                option2="ST04"
                option3="SM66"
                option4="AL11"
                correct_answer=1
                ;;
            23)
                question="¿Qué transacción se usa para monitorear el rendimiento de la base de datos?"
                option1="ST04"
                option2="DB02"
                option3="AL11"
                option4="ST06"
                correct_answer=1
                ;;
            24)
                question="¿Qué transacción se usa para gestionar los perfiles del sistema?"
                option1="RZ10"
                option2="SP01"
                option3="SM50"
                option4="ST04"
                correct_answer=1
                ;;
        esac
    fi
    
    # Shuffle options
    shuffle_options "$option1" "$option2" "$option3" "$option4" "$correct_answer"
    options=("${shuffled_options[@]}")
    correct_answer=$new_correct_pos
    
    # Display question
    echo -e "${BOLD}${BLUE}Question $((current_question+1)):${NC} $question"
    
    # Display options
    for i in {0..3}; do
        echo -e "$((i+1))) ${CYAN}${options[$i]}${NC}"
    done
    
    # Get user's answer
    local user_answer
    while true; do
        if [ "$language" == "english" ]; then
            read -p "Enter your answer (1-4): " user_answer
        else
            read -p "Ingrese su respuesta (1-4): " user_answer
        fi
        
        if [[ "$user_answer" =~ ^[1-4]$ ]]; then
            break
        else
            if [ "$language" == "english" ]; then
                echo -e "${RED}Invalid input. Please enter a number between 1 and 4.${NC}"
            else
                echo -e "${RED}Entrada inválida. Por favor ingrese un número entre 1 y 4.${NC}"
            fi
        fi
    done
    
    # Check if correct
    if [ "$user_answer" -eq "$correct_answer" ]; then
        if [ "$language" == "english" ]; then
            echo -e "${GREEN}Correct!${NC}"
        else
            echo -e "${GREEN}¡Correcto!${NC}"
        fi
        correct_answers=$((correct_answers+1))
    else
        if [ "$language" == "english" ]; then
            echo -e "${RED}Incorrect. The correct answer is ${options[$((correct_answer-1))]}.${NC}"
        else
            echo -e "${RED}Incorrecto. La respuesta correcta es ${options[$((correct_answer-1))]}.${NC}"
        fi
    fi
    
    echo ""
    if [ "$language" == "english" ]; then
        echo -e "Press Enter to continue to the next question..."
        read -t 1 dummy || true  # Wait for a keystroke with a timeout of 1 second
        sleep 1  # Additional pause to see the result before moving on
    else
        echo -e "Presione Enter para continuar a la siguiente pregunta..."
        read -t 1 dummy || true  # Wait for a keystroke with a timeout of 1 second
        sleep 1  # Additional pause to see the result before moving on
    fi
}

# Function to start quiz
start_quiz() {
    clear_screen
    correct_answers=0
    current_question=0
    
    # Generate random order of questions
    generate_question_order
    
    # Display header based on language
    if [ "$language" == "english" ]; then
        echo -e "${BOLD}${CYAN}Starting quiz - $total_questions questions${NC}"
        echo -e "Topic: $topic | Difficulty: $difficulty"
    else
        echo -e "${BOLD}${CYAN}Iniciando cuestionario - $total_questions preguntas${NC}"
        echo -e "Tema: $topic | Dificultad: $difficulty"
    fi
    echo ""
    
    # Ask questions based on topic
    while [ $current_question -lt $total_questions ]; do
        question_idx=${question_order[$current_question]}
        
        # Choose question type based on topic
        if [ "$topic" == "linux" ]; then
            ask_linux_question $question_idx
        elif [ "$topic" == "sap" ]; then
            ask_sap_question $question_idx
        else
            # 50-50 chance for either Linux or SAP question
            if [ $(($RANDOM % 2)) -eq 0 ]; then
                ask_linux_question $question_idx
            else
                ask_sap_question $question_idx
            fi
        fi
        
        current_question=$((current_question+1))
        clear_screen
    done
    
    # Show results
    show_results
}

# Function to show results
show_results() {
    clear_screen
    
    # Calculate percentage
    percentage=$((correct_answers * 100 / total_questions))
    
    # Display results
    if [ "$language" == "english" ]; then
        echo -e "${BOLD}${CYAN}Quiz Results${NC}"
        echo -e "Topic: $topic | Difficulty: $difficulty"
        echo -e "Correct answers: ${GREEN}$correct_answers${NC} out of ${YELLOW}$total_questions${NC}"
        echo -e "Score: ${PURPLE}$percentage%${NC}"
        
        # Performance assessment
        if [ $percentage -ge 90 ]; then
            echo -e "${GREEN}Excellent! You're a pro!${NC}"
        elif [ $percentage -ge 75 ]; then
            echo -e "${GREEN}Good job! You know your stuff!${NC}"
        elif [ $percentage -ge 60 ]; then
            echo -e "${YELLOW}Not bad! More practice will help.${NC}"
        else
            echo -e "${RED}You need more practice. Keep studying!${NC}"
        fi
    else
        echo -e "${BOLD}${CYAN}Resultados del Cuestionario${NC}"
        echo -e "Tema: $topic | Dificultad: $difficulty"
        echo -e "Respuestas correctas: ${GREEN}$correct_answers${NC} de ${YELLOW}$total_questions${NC}"
        echo -e "Puntuación: ${PURPLE}$percentage%${NC}"
        
        # Performance assessment
        if [ $percentage -ge 90 ]; then
            echo -e "${GREEN}¡Excelente! ¡Eres un profesional!${NC}"
        elif [ $percentage -ge 75 ]; then
            echo -e "${GREEN}¡Buen trabajo! ¡Sabes tu material!${NC}"
        elif [ $percentage -ge 60 ]; then
            echo -e "${YELLOW}¡No está mal! Más práctica te ayudará.${NC}"
        else
            echo -e "${RED}Necesitas más práctica. ¡Sigue estudiando!${NC}"
        fi
    fi
    
    echo ""
    if [ "$language" == "english" ]; then
        echo -e "Press Enter to return to the main menu..."
    else
        echo -e "Presione Enter para volver al menú principal..."
    fi
    read dummy
}

# Main function
main() {
    while true; do
        display_welcome
        select_language
        select_topic
        select_difficulty
        start_quiz
        
        # Ask if user wants to continue
        if [ "$language" == "english" ]; then
            echo -e "${YELLOW}Do you want to take another quiz? (y/n)${NC}"
        else
            echo -e "${YELLOW}¿Desea tomar otro cuestionario? (s/n)${NC}"
        fi
        
        read -p "> " continue_choice
        continue_choice=$(echo "$continue_choice" | tr '[:upper:]' '[:lower:]')
        
        if [ "$language" == "english" ]; then
            if [ "$continue_choice" != "y" ] && [ "$continue_choice" != "yes" ]; then
                clear_screen
                echo -e "${BOLD}${CYAN}Thank you for using the Linux & SAP BASIS Trainer!${NC}"
                echo -e "${CYAN}© Miguel Lopez - 2025${NC}"
                echo ""
                break
            fi
        else
            if [ "$continue_choice" != "s" ] && [ "$continue_choice" != "si" ]; then
                clear_screen
                echo -e "${BOLD}${CYAN}¡Gracias por utilizar el Entrenador de Linux y SAP BASIS!${NC}"
                echo -e "${CYAN}© Miguel Lopez - 2025${NC}"
                echo ""
                break
            fi
        fi
    done
}

# Start the program
main
