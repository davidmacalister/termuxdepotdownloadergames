#!/bin/bash

# Cores ANSI
NEGRITO="\033[1m"
RESET="\033[0m"
AMARELO="\033[33m"
LARANJA="\033[38;5;208m"
AZUL="\033[34m"
VERDE="\033[32m"

voltar_menu() {
    echo -e "${AMARELO}Voltando ao menu anterior...${RESET}"
    sleep 1
    clear
}

# Escolha da opção principal
while true; do
    clear
    echo
    echo "Quais jogos você deseja baixar?"
    echo
    echo "1) Todos os jogos"
    echo "2) Escolher manualmente"
    echo "b) Voltar"
    echo "============================"
    read -p "Escolha uma opção (1-2 ou b): " tela_inicial

    if [[ "$tela_inicial" == "b" ]]; then
        voltar_menu
        continue
    fi

    comandos=()

    read -p "Digite seu nome de usuário Steam: " usuario
    read -p "Digite sua senha Steam: " senha

    comando_base="depotdownloader -username $usuario -password '$senha' -remember-password -validate"

    if [[ "$tela_inicial" == "1" ]]; then
        while true; do
            clear
            echo
            echo "Quais jogos você deseja baixar?"
            echo
            echo "1) Todos os jogos"
            echo "2) Todos os jogos Source"
            echo "3) Todos os jogos Goldsrc"
            echo "b) Voltar"
            echo "============================"
            read -p "Escolha uma opção (1-3 ou b): " todos_opcao

            if [[ "$todos_opcao" == "b" ]]; then
                voltar_menu
                break
            fi

            if [[ "$todos_opcao" == "1" || "$todos_opcao" == "3" ]]; then
                while true; do
                    clear
                    echo
                    echo "Qual versão você deseja dos jogos Goldsrc?"
                    echo
                    echo "1) Versão aniversário de 25 anos"
                    echo -e "${AMARELO}! Aviso: essa é a versão mais recente, melhor para se usar no Xash (new engine)${RESET}"
                    echo "2) Versão pré aniversário de 25 anos"
                    echo -e "${AMARELO}! Aviso: essa é a versão antiga, mais compatível com mods, melhor para se usar no Xash (old engine)${RESET}"
                    echo "3) Ambos"
                    echo "b) Voltar"
                    echo "============================"
                    read -p "Escolha uma opção (1-3 ou b): " versao_goldsrc

                    if [[ "$versao_goldsrc" == "b" ]]; then
                        voltar_menu
                        break
                    fi

                    [[ "$versao_goldsrc" == "1" || "$versao_goldsrc" == "3" ]] && add_goldsrc_25
                    [[ "$versao_goldsrc" == "2" || "$versao_goldsrc" == "3" ]] && add_goldsrc_pre25
                done
            fi

            [[ "$todos_opcao" == "1" || "$todos_opcao" == "2" ]] && add_source
            break
        done

    elif [[ "$tela_inicial" == "2" ]]; then
        while true; do
            clear
            echo
            echo "Quais jogos você deseja baixar?"
            echo
            echo -e "${NEGRITO}Jogos Source:${RESET}"
            echo -e "${LARANJA}1) Half-Life 2${RESET}"
            echo -e "${LARANJA}2) Half-Life 2: Episode 1${RESET}"
            echo -e "${LARANJA}3) Half-Life 2: Episode 2${RESET}"
            echo -e "${LARANJA}4) Half-Life 2: Deathmatch${RESET}"
            echo -e "${LARANJA}5) Half-Life: Source${RESET}"
            echo "6) Counter-Strike: Source"
            echo "7) Day of Defeat: Source"
            echo -e "${AZUL}8) Portal${RESET}"
            echo
            echo -e "${NEGRITO}Jogos Goldsrc:${RESET}"
            echo -e "${LARANJA}9) Half-Life${RESET}"
            echo -e "${AZUL}10) Half-Life: Blue Shift${RESET}"
            echo -e "${VERDE}11) Half-Life: Opposing Force${RESET}"
            echo "12) Counter-Strike"
            echo -e "${AMARELO}13) Team Fortress Classic${RESET}"
            echo "b) Voltar"
            echo "============================"
            read -p "Escolha uma ou mais opções, separando por vírgulas (1-13 ou b): " selecoes

            if [[ "$selecoes" == "b" ]]; then
                voltar_menu
                break
            fi

            IFS=',' read -ra opcoes <<< "$selecoes"

            goldsrc_opcoes=()

            for opcao in "${opcoes[@]}"; do
                case "$opcao" in
                    1) comandos+=("$comando_base -app 220 -depot 221 -dir source") ;; # HL2
                    2) comandos+=("$comando_base -app 220 -depot 389 -dir source") ;; # EP1
                    3) comandos+=("$comando_base -app 220 -depot 380 -dir source") ;; # EP2
                    4) comandos+=("$comando_base -app 220 -depot 420 -dir source") ;; # Deathmatch
                    5) comandos+=("$comando_base -app 220 -depot 380 -dir source") ;; # HL:Source
                    6) comandos+=("$comando_base -app 240 -depot 241 -dir source -beta previous_build") ;; # CS:S
                    7) comandos+=("$comando_base -app 300 -depot 301 -dir source") ;; # DoD:S
                    8) comandos+=("$comando_base -app 400 -depot 401 -dir source") ;; # Portal
                    9|10|11|12|13) goldsrc_opcoes+=("$opcao") ;; # Guardar opções Goldsrc
                esac
            done

            if [[ "${#goldsrc_opcoes[@]}" -gt 0 ]]; then
                while true; do
                    clear
                    echo
                    echo "Qual versão você deseja dos jogos Goldsrc?"
                    echo
                    echo "1) Versão aniversário de 25 anos"
                    echo -e "${AMARELO}! Aviso: essa é a versão mais recente, melhor para se usar no Xash (new engine)${RESET}"
                    echo "2) Versão pré aniversário de 25 anos"
                    echo -e "${AMARELO}! Aviso: essa é a versão antiga, mais compatível com mods, melhor para se usar no Xash (old engine)${RESET}"
                    echo "3) Ambos"
                    echo "b) Voltar"
                    echo "============================"
                    read -p "Escolha uma opção (1-3 ou b): " versao_manual

                    if [[ "$versao_manual" == "b" ]]; then
                        voltar_menu
                        break
                    fi

                    for opcao in "${goldsrc_opcoes[@]}"; do
                        if [[ "$versao_manual" == "1" || "$versao_manual" == "3" ]]; then
                            case "$opcao" in
                                9)  comandos+=("$comando_base -app 70  -depot 1   -dir goldsrc_new") ;;  # HL
                                10) comandos+=("$comando_base -app 130 -depot 130 -dir goldsrc_new") ;;  # Blue Shift
                                11) comandos+=("$comando_base -app 50  -depot 51  -dir goldsrc_new") ;;  # Opposing Force
                                12) comandos+=("$comando_base -app 10  -depot 11  -dir goldsrc_new") ;;  # CS
                                13) comandos+=("$comando_base -app 20  -depot 21  -dir goldsrc_new") ;;  # TFC
                            esac
                        fi

                        if [[ "$versao_manual" == "2" || "$versao_manual" == "3" ]]; then
                            case "$opcao" in
                                9)  comandos+=("$comando_base -beta steam_legacy -app 70  -depot 1   -dir goldsrc_old") ;;
                                10) comandos+=("$comando_base -beta steam_legacy -app 130 -depot 130 -dir goldsrc_old") ;;
                                11) comandos+=("$comando_base -beta steam_legacy -app 50  -depot 51  -dir goldsrc_old") ;;
                                12) comandos+=("$comando_base -beta steam_legacy -app 10  -depot 11  -dir goldsrc_old") ;;
                                13) comandos+=("$comando_base -beta steam_legacy -app 20  -depot 21  -dir goldsrc_old") ;;
                            esac
                        fi
                    done
                done
            fi
        done
    else
        echo "Opção inválida."
        sleep 1
    fi
done

# Execução final
echo
for cmd in "${comandos[@]}"; do
    echo -e "${NEGRITO}Executando:${RESET} $cmd"
    eval "$cmd" || { echo "Erro ao executar o comando acima."; exit 1; }
done
