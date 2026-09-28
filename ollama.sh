#!/bin/bash

# ============================================================
#           CENTRAL DE GERENCIAMENTO OLLAMA + IP-BOT
#           Otimizado para i5 • 15 GB RAM • Ubuntu 24.04
# ============================================================

# Cores
VERDE='\033[0;32m'
AZUL='\033[0;34m'
AMARELO='\033[1;33m'
VERMELHO='\033[0;31m'
CIANO='\033[0;36m'
ROXO='\033[0;35m'
SEM_COR='\033[0m'

# Função de pausa
pausar() {
    echo ""
    read -p "Pressione [Enter] para voltar ao menu..."
    echo ""
}

# ====================== CONFIGURAÇÃO INICIAL ======================
clear
echo -e "\( {AZUL}============================================================== \){SEM_COR}"
echo -e "${AZUL}          CONFIGURAÇÃO INICIAL - OLLAMA + IP-BOT             ${SEM_COR}"
echo -e "\( {AZUL}============================================================== \){SEM_COR}"
echo ""

echo -e "\( {AZUL}[1/3] Atualizando repositórios e instalando dependências... \){SEM_COR}"
sudo apt update && sudo apt install -y curl htop

echo -e "\n\( {AZUL}[2/3] Verificando instalação do Ollama... \){SEM_COR}"
if ! command -v ollama &> /dev/null; then
    echo -e "\( {AMARELO}Ollama não encontrado. Instalando agora... \){SEM_COR}"
    curl -fsSL https://ollama.com/install.sh | sh
else
    echo -e "\( {VERDE}Ollama já está instalado. \){SEM_COR}"
fi

echo -e "\n\( {AZUL}[3/3] Ativando o serviço do Ollama... \){SEM_COR}"
sudo systemctl enable ollama >/dev/null 2>&1
sudo systemctl start ollama >/dev/null 2>&1
sleep 1

echo -e "\n\( {VERDE}Configuração concluída com sucesso! \){SEM_COR}"
sleep 1.5

# ====================== MENU PRINCIPAL ======================
while true; do
    clear
    echo "========================================================================"
    echo "           CENTRAL DE GERENCIAMENTO OLLAMA & DEEPSEEK & QWEN            "
    echo "                    (i5 • 15 GB RAM • Ubuntu 24.04)                     "
    echo "========================================================================"
    echo -e "\( {ROXO} [ MODELOS RECOMENDADOS PARA SEU HARDWARE ] \){SEM_COR}"
    echo -e "  1) DeepSeek-R1 \( {VERDE}1.5B \){SEM_COR}      [\~1.5 GB]  → Super leve e rápido"
    echo -e "  2) Qwen2.5-Coder \( {VERDE}3B \){SEM_COR}     [\~2.2 GB]  → Especialista em código"
    echo -e "  3) Qwen2.5-Coder \( {AMARELO}7B \){SEM_COR}     [\~4.7 GB]  → \( {AMARELO}RECOMENDADO \){SEM_COR} (melhor equilíbrio)"
    echo -e "  4) DeepSeek-R1 \( {AMARELO}7B \){SEM_COR}      [\~5.0 GB]  → Raciocínio forte"
    echo -e "  5) DeepSeek-R1 \( {AMARELO}8B \){SEM_COR}      [\~5.2 GB]  → Raciocínio + base Llama"
    echo "------------------------------------------------------------------------"
    echo -e "\( {ROXO} [ FERRAMENTAS ] \){SEM_COR}"
    echo -e "  6) Monitorar CPU e Memória (\( {AZUL}htop \){SEM_COR})"
    echo -e "  7) Parar Ollama (\( {VERMELHO}Liberar toda a RAM \){SEM_COR})"
    echo -e "  8) Iniciar / Reativar Ollama"
    echo -e "  9) Remover modelo"
    echo -e " 10) Ver modelos instalados"
    echo "------------------------------------------------------------------------"
    echo " 11) Sair"
    echo "========================================================================"
    echo -e "\( {CIANO}Dica: Com Firefox + VS Code abertos, prefira as opções 1, 2 ou 3. \){SEM_COR}"
    echo -e "\( {CIANO}Para a prova, use o modelo e depois ative o \"Modo Prova\" no chat. \){SEM_COR}"
    echo "========================================================================"
    read -p "Digite o número da opção: " opcao

    case $opcao in
        1)
            echo -e "\n\( {VERDE}Iniciando DeepSeek-R1 1.5B... \){SEM_COR}"
            ollama run deepseek-r1:1.5b
            pausar
            ;;
        2)
            echo -e "\n\( {VERDE}Iniciando Qwen2.5-Coder 3B... \){SEM_COR}"
            ollama run qwen2.5-coder:3b
            pausar
            ;;
        3)
            echo -e "\n\( {AMARELO}Iniciando Qwen2.5-Coder 7B (recomendado)... \){SEM_COR}"
            echo -e "\( {CIANO}Ideal para desafios de I.P. e para a prova. \){SEM_COR}"
            ollama run qwen2.5-coder:7b
            pausar
            ;;
        4)
            echo -e "\n\( {AMARELO}Iniciando DeepSeek-R1 7B... \){SEM_COR}"
            echo -e "\( {VERMELHO}Atenção: Feche o Firefox para melhor desempenho. \){SEM_COR}"
            ollama run deepseek-r1:7b
            pausar
            ;;
        5)
            echo -e "\n\( {AMARELO}Iniciando DeepSeek-R1 8B... \){SEM_COR}"
            echo -e "\( {VERMELHO}Atenção: Feche o Firefox para melhor desempenho. \){SEM_COR}"
            ollama run deepseek-r1:8b
            pausar
            ;;
        6)
            echo -e "\n\( {AZUL}Abrindo htop... \){SEM_COR}"
            echo "Pressione [q] ou [F10] para sair do monitor."
            sleep 1.5
            htop
            ;;
        7)
            echo -e "\n\( {VERMELHO}Parando o serviço do Ollama... \){SEM_COR}"
            sudo systemctl stop ollama
            echo -e "\( {VERDE}Serviço parado. Memória liberada com sucesso. \){SEM_COR}"
            pausar
            ;;
        8)
            echo -e "\n\( {AZUL}Iniciando o serviço do Ollama... \){SEM_COR}"
            sudo systemctl start ollama
            echo -e "\( {VERDE}Serviço ativo e pronto para uso! \){SEM_COR}"
            pausar
            ;;
        9)
            echo -e "\n\( {AZUL}Modelos atualmente instalados: \){SEM_COR}"
            ollama list
            echo "--------------------------------------------------"
            read -p "Digite o nome exato do modelo para remover (ex: qwen2.5-coder:7b): " modelo_del
            if [ -n "$modelo_del" ]; then
                echo -e "${VERMELHO}Removendo \( modelo_del... \){SEM_COR}"
                ollama rm "$modelo_del"
                echo -e "\( {VERDE}Modelo removido com sucesso! \){SEM_COR}"
            else
                echo "Nenhum modelo foi digitado."
            fi
            pausar
            ;;
        10)
            echo -e "\n\( {AZUL}Modelos instalados no momento: \){SEM_COR}"
            ollama list
            pausar
            ;;
        11)
            echo -e "\n\( {VERDE}Encerrando a central. Bons códigos e boa prova! \){SEM_COR}"
            exit 0
            ;;
        *)
            echo -e "\n\( {VERMELHO}Opção inválida! Tente novamente. \){SEM_COR}"
            sleep 1.3
            ;;
    esac
done
