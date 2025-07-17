#!/bin/bash

# ANSI Colors
BOLD="\033[1m"
RESET="\033[0m"
YELLOW="\033[33m"
ORANGE="\033[38;5;208m"
BLUE="\033[34m"
RED="\033[38;5;196m"
GREEN="\033[32m"

go_back_menu() {
    echo -e "${YELLOW}Returning to the previous menu...${RESET}"
    sleep 1
    clear
}

# Main menu selection
while true; do
    clear
    echo
    echo "Which games do you want to download?"
    echo
    echo "1) All games"
    echo "2) Select manually"
    echo "${RED}e) Exit${RESET}"
    echo "============================"
    read -p "Choose an option (1-2): " main_menu

    if [[ "$main_menu" == "e" ]]; then
        echo -e "${YELLOW}Exiting the application...${RESET}"
        exit 0
    fi

    commands=()

    read -p "Enter your Steam username: " username
    read -p "Enter your Steam password: " password

    base_command="depotdownloader -username $username -password '$password' -remember-password -validate"

    if [[ "$main_menu" == "1" ]]; then
        while true; do
            clear
            echo
            echo "Which games do you want to download?"
            echo
            echo "1) All games"
            echo "2) All Source games"
            echo "3) All Goldsrc games"
            echo "b) Go back"
            echo "============================"
            read -p "Choose an option (1-3): " all_games_option

            if [[ "$all_games_option" == "b" ]]; then
                go_back_menu
                break
            fi

            if [[ "$all_games_option" == "1" || "$all_games_option" == "3" ]]; then
                while true; do
                    clear
                    echo
                    echo "Which version of Goldsrc games do you want?"
                    echo
                    echo "1) 25th Anniversary version"
                    echo -e "${YELLOW}! Warning: this is the latest version, better for use with Xash (new engine)${RESET}"
                    echo "2) Pre-25th Anniversary version"
                    echo -e "${YELLOW}! Warning: this is the older version, more compatible with mods, better for use with Xash (old engine)${RESET}"
                    echo "3) Both"
                    echo "b) Go back"
                    echo "============================"
                    read -p "Choose an option (1-3): " goldsrc_version

                    if [[ "$goldsrc_version" == "b" ]]; then
                        go_back_menu
                        break
                    fi

                    [[ "$goldsrc_version" == "1" || "$goldsrc_version" == "3" ]] && add_goldsrc_25
                    [[ "$goldsrc_version" == "2" || "$goldsrc_version" == "3" ]] && add_goldsrc_pre25
                done
            fi

            [[ "$all_games_option" == "1" || "$all_games_option" == "2" ]] && add_source
            break
        done

    elif [[ "$main_menu" == "2" ]]; then
        while true; do
            clear
            echo
            echo "Which games do you want to download?"
            echo
            echo -e "${BOLD}Source Games:${RESET}"
            echo -e "${ORANGE}1) Half-Life 2${RESET}"
            echo -e "${ORANGE}2) Half-Life 2: Episode 1${RESET}"
            echo -e "${ORANGE}3) Half-Life 2: Episode 2${RESET}"
            echo -e "${ORANGE}4) Half-Life 2: Deathmatch${RESET}"
            echo -e "${ORANGE}5) Half-Life: Source${RESET}"
            echo "6) Counter-Strike: Source"
            echo "7) Day of Defeat: Source"
            echo -e "${BLUE}8) Portal${RESET}"
            echo
            echo -e "${BOLD}Goldsrc Games:${RESET}"
            echo -e "${ORANGE}9) Half-Life${RESET}"
            echo -e "${BLUE}10) Half-Life: Blue Shift${RESET}"
            echo -e "${GREEN}11) Half-Life: Opposing Force${RESET}"
            echo "12) Counter-Strike"
            echo -e "${YELLOW}13) Team Fortress Classic${RESET}"
            echo "b) Go back"
            echo "============================"
            read -p "Choose one or more options, separated by commas (1-13): " selections

            if [[ "$selections" == "b" ]]; then
                go_back_menu
                break
            fi

            IFS=',' read -ra options <<< "$selections"

            goldsrc_options=()

            for option in "${options[@]}"; do
                case "$option" in
                    1) commands+=("$base_command -app 220 -depot 221 -dir source") ;; # HL2
                    2) commands+=("$base_command -app 220 -depot 389 -dir source") ;; # EP1
                    3) commands+=("$base_command -app 220 -depot 380 -dir source") ;; # EP2
                    4) commands+=("$base_command -app 220 -depot 420 -dir source") ;; # Deathmatch
                    5) commands+=("$base_command -app 220 -depot 380 -dir source") ;; # HL:Source
                    6) commands+=("$base_command -app 240 -depot 241 -dir source -beta previous_build") ;; # CS:S
                    7) commands+=("$base_command -app 300 -depot 301 -dir source") ;; # DoD:S
                    8) commands+=("$base_command -app 400 -depot 401 -dir source") ;; # Portal
                    9|10|11|12|13) goldsrc_options+=("$option") ;; # Store Goldsrc options
                esac
            done

            if [[ "${#goldsrc_options[@]}" -gt 0 ]]; then
                while true; do
                    clear
                    echo
                    echo "Which version of Goldsrc games do you want?"
                    echo
                    echo "1) 25th Anniversary version"
                    echo -e "${YELLOW}! Warning: this is the latest version, better for use with Xash (new engine)${RESET}"
                    echo "2) Pre-25th Anniversary version"
                    echo -e "${YELLOW}! Warning: this is the older version, more compatible with mods, better for use with Xash (old engine)${RESET}"
                    echo "3) Both"
                    echo "b) Go back"
                    echo "============================"
                    read -p "Choose an option (1-3): " manual_version

                    if [[ "$manual_version" == "b" ]]; then
                        go_back_menu
                        break
                    fi

                    for option in "${goldsrc_options[@]}"; do
                        if [[ "$manual_version" == "1" || "$manual_version" == "3" ]]; then
                            case "$option" in
                                9)  commands+=("$base_command -app 70  -depot 1   -dir goldsrc_new") ;;  # HL
                                10) commands+=("$base_command -app 130 -depot 130 -dir goldsrc_new") ;;  # Blue Shift
                                11) commands+=("$base_command -app 50  -depot 51  -dir goldsrc_new") ;;  # Opposing Force
                                12) commands+=("$base_command -app 10  -depot 11  -dir goldsrc_new") ;;  # CS
                                13) commands+=("$base_command -app 20  -depot 21  -dir goldsrc_new") ;;  # TFC
                            esac
                        fi

                        if [[ "$manual_version" == "2" || "$manual_version" == "3" ]]; then
                            case "$option" in
                                9)  commands+=("$base_command -beta steam_legacy -app 70  -depot 1   -dir goldsrc_old") ;;
                                10) commands+=("$base_command -beta steam_legacy -app 130 -depot 130 -dir goldsrc_old") ;;
                                11) commands+=("$base_command -beta steam_legacy -app 50  -depot 51  -dir goldsrc_old") ;;
                                12) commands+=("$base_command -beta steam_legacy -app 10  -depot 11  -dir goldsrc_old") ;;
                                13) commands+=("$base_command -beta steam_legacy -app 20  -depot 21  -dir goldsrc_old") ;;
                            esac
                        fi
                    done
                done
            fi
        done
    else
        echo "Invalid option."
        sleep 1
    fi
done

# Final execution
echo
for cmd in "${commands[@]}"; do
    echo -e "${BOLD}Executing:${RESET} $cmd"
    eval "$cmd" || { echo "Error executing the command above."; exit 1; }
done
