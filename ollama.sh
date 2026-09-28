#!/bin/bash

# Cores para o terminal
VERDE='\033[0;32m'
AZUL='\033[0;34m'
AMARELO='\033[1;33m'
VERMELHO='\033[0;31m'
SEM_COR='\033[0m'

# Função para pausar a tela até que o usuário aperte Enter
pausar() {
    echo ""
    read -p "Pressione [Enter] para voltar ao menu..."
    echo ""
}

# Início do Script - Configuração Inicial Automatizada
echo -e "${AZUL}[1/2] Atualizando repositórios e garantindo dependências (curl, htop)...${SEM_COR}"
sudo apt update && sudo apt install -y curl htop

echo -e "${AZUL}[2/2] Verificando e instalando/atualizando o Ollama...${SEM_COR}"
curl -fsSL https://ollama.com | sh

# Loop principal do menu interativo
while true; do
    clear
    echo "========================================================================"
    echo "           CENTRAL DE GERENCIAMENTO OLLAMA & DEEPSEEK & QWEN            "
    echo "========================================================================"
    echo -e " [ MODELOS DE PROGRAMAÇÃO & RACIOCÍNIO (Até 15GB RAM) ]"
    echo -e "  1) Executar DeepSeek-R1 ${VERDE}1.5B${SEM_COR}  [Consome: ${VERDE}~1.5 GB RAM${SEM_COR}] (Super leve - Raciocínio)"
    echo -e "  2) Executar Qwen2.5-Coder ${VERDE}3B${SEM_COR}   [Consome: ${VERDE}~2.2 GB RAM${SEM_COR}] (Leve - Especialista Python)"
    echo -e "  3) Executar Qwen2.5-Coder ${AMARELO}7B${SEM_COR}   [Consome: ${AMARELO}~4.7 GB RAM${SEM_COR}] (O MELHOR para I.P. e Maratonas)"
    echo -e "  4) Executar DeepSeek-R1 ${AMARELO}7B${SEM_COR}    [Consome: ${AMARELO}~5.0 GB RAM${SEM_COR}] (Médio - Raciocínio pesado)"
    echo -e "  5) Executar DeepSeek-R1 ${AMARELO}8B${SEM_COR}    [Consome: ${AMARELO}~5.2 GB RAM${SEM_COR}] (Médio - Base Llama-3)"
    echo "------------------------------------------------------------------------"
    echo -e " [ 🛠️ FERRAMENTAS DE GERENCIAMENTO & MONITORAMENTO ]"
    echo -e "  6) Verificar consumo de memória e CPU em tempo real (${AZUL}htop${SEM_COR})"
    echo -e "  7) Parar o serviço do Ollama (${VERMELHO}Liberar Memória RAM total${SEM_COR})"
    echo -e "  8) Iniciar/Reativar o serviço do Ollama (Para voltar a programar)"
    echo -e "  9) Remover modelo do computador (Liberar espaço em disco)"
    echo "------------------------------------------------------------------------"
    echo "  10) Sair do script"
    echo "========================================================================"
    read -p "Digite o número da opção desejada: " opcao

    case $opcao in
        1)
            echo -e "\n${VERDE}Iniciando DeepSeek-R1 1.5B... Se for a primeira vez, aguarde o download.${SEM_COR}"
            ollama run deepseek-r1:1.5b
            pausar
            ;;
        2)
            echo -e "\n${VERDE}Iniciando Qwen2.5-Coder 3B... Se for a primeira vez, aguarde o download.${SEM_COR}"
            ollama run qwen2.5-coder:3b
            pausar
            ;;
        3)
            echo -e "\n${AMARELO}Iniciando Qwen2.5-Coder 7B... Se for a primeira vez, aguarde o download.${SEM_COR}"
            echo "Dica: Este é o modelo ideal para decifrar as regras e lógicas complexas de I.P.!"
            ollama run qwen2.5-coder:7b
            pausar
            ;;
        4)
            echo -e "\n${AMARELO}Iniciando DeepSeek-R1 7B... Se for a primeira vez, aguarde o download.${SEM_COR}"
            echo "Dica: Feche abas pesadas do navegador para garantir estabilidade."
            ollama run deepseek-r1:7b
            pausar
            ;;
        5)
            echo -e "\n${AMARELO}Iniciando DeepSeek-R1 8B... Se for a primeira vez, aguarde o download.${SEM_COR}"
            echo "Dica: Feche abas pesadas do navegador para garantir estabilidade."
            ollama run deepseek-r1:8b
            pausar
            ;;
        6)
            echo -e "\n${AZUL}Abrindo o htop...${SEM_COR}"
            echo "Olhe as colunas de MEM/CPU. Para sair do monitor e voltar aqui, aperte a tecla [F10] ou [q]."
            sleep 2
            htop
            ;;
        7)
            echo -e "\n${VERMELHO}Parando o serviço do Ollama para liberar toda a memória RAM...${SEM_COR}"
            sudo systemctl stop ollama
            echo -e "${VERDE}Serviço interrompido com sucesso.${SEM_COR}"
            pausar
            ;;
        8)
            echo -e "\n${AZUL}Iniciando o serviço do Ollama...${SEM_COR}"
            sudo systemctl start ollama
            echo -e "${VERDE}Serviço ativo e pronto para uso!${SEM_COR}"
            pausar
            ;;
        9)
            echo -e "\n[ Modelos atualmente baixados no seu PC: ]"
            ollama list
            echo "--------------------------------------------------"
            read -p "Digite o nome exato do modelo que deseja apagar (ex: qwen2.5-coder:7b): " modelo_del
            if [ ! -z "$modelo_del" ]; then
                echo -e "${VERMELHO}Removendo $modelo_del...${SEM_COR}"
                ollama rm "$modelo_del"
                echo -e "${VERDE}Concluído!${SEM_COR}"
            else
                echo "Nenhum modelo foi digitado."
            fi
            pausar
            ;;
        10)
            echo -e "\nEncerrando a central. Bons códigos no Ubuntu 24.04!"
            exit 0
            ;;
        *)
            echo -e "\n${VERMELHO}Opção inválida! Tente novamente.${SEM_COR}"
            sleep 1.5
            ;;
    esac
done
