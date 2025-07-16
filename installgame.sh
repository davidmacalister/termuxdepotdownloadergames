#!/bin/bash

clear
echo "============================"
echo "    DEPOTDOWNLOADER MENU    "
echo "============================"
echo "1) Todos os jogos"
echo "2) Todos os jogos Source"
echo "3) Todos os jogos Goldsrc"
echo "4) Todos os jogos Goldsrc pré aniversário de 25 anos"
echo "5) Escolher jogos manualmente"
echo "============================"
read -p "Escolha uma opção (1-5): " opcao

read -p "Digite seu nome de usuário Steam: " usuario
read -s -p "Digite sua senha Steam: " senha
echo

comando_goldsrc="depotdownloader -username $usuario -password '$senha' -remember-password -validate -beta steam_legacy"
comando_source="depotdownloader -username $usuario -password '$senha' -remember-password -validate"
comandos=()

add_goldsrc_pre25() {
    comandos+=(
        "${comando_goldsrc} -app 70  -depot 1   -dir goldsrc_old"
        "${comando_goldsrc} -app 130 -depot 130 -dir goldsrc_old"
        "${comando_goldsrc} -app 50  -depot 51  -dir goldsrc_old"
        "${comando_goldsrc} -app 10  -depot 11  -dir goldsrc_old"
        "${comando_goldsrc} -app 20  -depot 21  -dir goldsrc_old"
    )
}


add_goldsrc() {
    add_goldsrc_pre25
    # Adicione outros jogos Goldsrc aqui se quiser
}

add_source() {
    comandos+=(
        "$comando_goldsrc -app 220 -depot 221 -dir source"
        "$comando_goldsrc -app 220 -depot 389 -dir source"
        "$comando_goldsrc -app 220 -depot 380 -dir source"
        "$comando_goldsrc -app 220 -depot 420 -dir source"
        "$comando_source -beta previous_build -app 240 -depot 241 -dir source"
    )
}

case $opcao in
    1)
        add_goldsrc
        add_source
        ;;
    2)
        add_source
        ;;
    3)
        add_goldsrc
        ;;
    4)
        add_goldsrc_pre25
        ;;
    5)
        echo
        echo "Digite os jogos manualmente no formato app:depot:dir:beta"
        echo "Exemplo: 220:221:source:steam_legacy,240:241:source:previous_build"
        read -p "Entradas separadas por vírgula: " entradas
        IFS=',' read -ra pares <<< "$entradas"
        for par in "${pares[@]}"; do
            IFS=':' read -r app depot dir beta <<< "$par"
            comandos+=("depotdownloader -username \"$usuario\" -password \"$senha\" -remember-password -validate -beta $beta -app $app -depot $depot -dir $dir")
        done
        ;;
    *)
        echo "Opção inválida."
        exit 1
        ;;
esac

for cmd in "${comandos[@]}"; do
    echo "Executando: $cmd"
    eval "$cmd" || { echo "Erro ao executar o comando acima."; exit 1; }
done
