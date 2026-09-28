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
    echo -e "\( {ROXO} [ MODELOS RECOMENDADOS ] \){SEM_COR}"
    echo -e "  1) DeepSeek-R1 \( {VERDE}1.5B \){SEM_COR}      [\~1.5 GB]  → Super leve e rápido"
    echo -e "  2) Qwen2.5-Coder \( {VERDE}3B \){SEM_COR}     [\~2.2 GB]  → Especialista em código"
    echo -e "  3) Qwen2.5-Coder \( {AMARELO}7B \){SEM_COR}     [\~4.7 GB]  → \( {AMARELO}RECOMENDADO \){SEM_COR}"
    echo -e "  4) DeepSeek-R1 \( {AMARELO}7B \){SEM_COR}      [\~5.0 GB]  → Raciocínio forte"
    echo -e "  5) DeepSeek-R1 \( {AMARELO}8B \){SEM_COR}      [\~5.2 GB]  → Raciocínio + base Llama"
    echo "------------------------------------------------------------------------"
    echo -e "\( {ROXO} [ IP-BOT (PROMPT + REGRAS DO .MD INJETADOS) ] \){SEM_COR}"
    echo -e "  6) Criar / Atualizar o IP-BOT (carrega o arquivo .md de regras)"
    echo -e "  7) Rodar IP-BOT \( {AMARELO}(Modo Desafio + Modo Prova prontos) \){SEM_COR}"
    echo "------------------------------------------------------------------------"
    echo -e "\( {ROXO} [ FERRAMENTAS ] \){SEM_COR}"
    echo -e "  8) Monitorar CPU e Memória (\( {AZUL}htop \){SEM_COR})"
    echo -e "  9) Parar Ollama (\( {VERMELHO}Liberar toda a RAM \){SEM_COR})"
    echo -e " 10) Iniciar / Reativar Ollama"
    echo -e " 11) Remover modelo"
    echo -e " 12) Ver modelos instalados"
    echo "------------------------------------------------------------------------"
    echo " 13) Sair"
    echo "========================================================================"
    echo -e "\( {CIANO}Dica: Com Firefox + VS Code abertos, prefira opções 1, 2 ou 3. \){SEM_COR}"
    echo -e "\( {CIANO}Para a prova: opção 6 (carrega .md) → opção 7 → digite \"Modo Prova\" \){SEM_COR}"
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
            echo -e "\n\( {AZUL}=== CRIAR / ATUALIZAR IP-BOT === \){SEM_COR}"
            echo -e "\( {CIANO}O arquivo .md deve conter APENAS as Regras, Proibições e Permissões. \){SEM_COR}"
            echo -e "\( {CIANO}O enunciado da questão você cola manualmente no chat depois. \){SEM_COR}"
            echo ""
            read -p "Digite o caminho completo ou o nome do arquivo .md (ex: regras.md): " arquivo_md

            # Verifica se o arquivo existe
            if [ ! -f "$arquivo_md" ]; then
                echo -e "\n${VERMELHO}Erro: Arquivo '\( arquivo_md' não encontrado! \){SEM_COR}"
                pausar
                continue
            fi

            echo -e "\n${AZUL}Lendo o arquivo de regras: \( arquivo_md \){SEM_COR}"
            regras_conteudo=$(cat "$arquivo_md")

            echo -e "\( {AZUL}Criando o modelo personalizado IP-BOT... \){SEM_COR}"

            # Cria o Modelfile com o prompt fixo + conteúdo do .md
            cat > /tmp/Modelfile-ip-bot << MODELEOF
FROM qwen2.5-coder:7b

SYSTEM """
# IP-BOT — Assistente de Programação

Você é o **IP-BOT**, um assistente especializado em programação para a disciplina de Introdução à Programação.

Você possui **dois modos de operação**. O usuário vai informar qual modo deseja usar.

---

## MODO 1: Resolução de Desafios de I.P.
(Ativado quando o usuário disser: "Modo Desafio" ou "Modo 1")

- Use este modo para resolver as listas e desafios normais.
- Explique o raciocínio de forma clara e didática.
- Apresente o código completo e comentado.
- Pode usar qualquer recurso permitido no enunciado (listas, tuplas, etc.).
- Foque em soluções corretas, legíveis e bem estruturadas.

**Formato de resposta:**
1. Análise do Problema
2. Raciocínio passo a passo
3. Código completo
4. Observações (se necessário)

---

## MODO 2: Resolução de Prova
(Ativado quando o usuário disser: "Modo Prova" ou "Modo 2")

**Regras obrigatórias da prova:**
- A prova tem **duas questões**:
  1. Condicionais e laços de repetição → **É PROIBIDO usar listas ou tuplas**
  2. Listas e tuplas → Pode usar listas e tuplas normalmente
- Dificuldade mais simples que as questões fáceis das listas
- Siga **rigorosamente** as regras e permissões do arquivo de regras abaixo

**Formato de resposta (obrigatório):**
1. Análise do Problema (com as restrições)
2. Raciocínio passo a passo
3. Código completo e limpo
4. Confirmação de que as restrições foram respeitadas

**Conduta no Modo Prova:**
- Nunca sugira listas ou tuplas na questão de condicionais e laços
- Prefira soluções simples e corretas
- Se houver dúvida no enunciado, avise antes de resolver

---

## REGRAS, PROIBIÇÕES E PERMISSÕES (arquivo .md carregado)

$regras_conteudo

---

## Instruções Gerais
- Sempre confirme o modo ativo no início da resposta (ex: “Modo Prova ativado”)
- Baseie-se apenas no enunciado colado pelo usuário e nas regras acima
- Seja claro, objetivo e didático
- Nunca invente regras que não estejam listadas acima
"""
MODELEOF

            ollama create ip-bot -f /tmp/Modelfile-ip-bot
            rm -f /tmp/Modelfile-ip-bot

            echo -e "\n\( {VERDE}IP-BOT criado/atualizado com sucesso! \){SEM_COR}"
            echo -e "${CIANO}As regras do arquivo '\( arquivo_md' foram gravadas na memória do modelo. \){SEM_COR}"
            echo -e "\( {CIANO}Agora use a opção 7 para rodar o IP-BOT. \){SEM_COR}"
            pausar
            ;;
        7)
            # Verifica se o modelo ip-bot existe
            if ! ollama list | grep -q "ip-bot"; then
                echo -e "\n\( {VERMELHO}O modelo IP-BOT ainda não foi criado. \){SEM_COR}"
                echo -e "\( {AMARELO}Use primeiro a opção 6 para criar o IP-BOT carregando o arquivo .md. \){SEM_COR}"
                pausar
                continue
            fi

            echo -e "\n\( {AMARELO}Iniciando IP-BOT (regras já injetadas)... \){SEM_COR}"
            echo -e "\( {CIANO}Digite \"Modo Desafio\" ou \"Modo Prova\" para ativar o modo desejado. \){SEM_COR}"
            echo -e "\( {CIANO}Depois cole o enunciado da questão manualmente. \){SEM_COR}"
            echo ""
            ollama run ip-bot
            pausar
            ;;
        8)
            echo -e "\n\( {AZUL}Abrindo htop... \){SEM_COR}"
            echo "Pressione [q] ou [F10] para sair do monitor."
            sleep 1.5
            htop
            ;;
        9)
            echo -e "\n\( {VERMELHO}Parando o serviço do Ollama... \){SEM_COR}"
            sudo systemctl stop ollama
            echo -e "\( {VERDE}Serviço parado. Memória liberada com sucesso. \){SEM_COR}"
            pausar
            ;;
        10)
            echo -e "\n\( {AZUL}Iniciando o serviço do Ollama... \){SEM_COR}"
            sudo systemctl start ollama
            echo -e "\( {VERDE}Serviço ativo e pronto para uso! \){SEM_COR}"
            pausar
            ;;
        11)
            echo -e "\n\( {AZUL}Modelos atualmente instalados: \){SEM_COR}"
            ollama list
            echo "--------------------------------------------------"
            read -p "Digite o nome exato do modelo para remover (ex: ip-bot ou qwen2.5-coder:7b): " modelo_del
            if [ -n "$modelo_del" ]; then
                echo -e "${VERMELHO}Removendo \( modelo_del... \){SEM_COR}"
                ollama rm "$modelo_del"
                echo -e "\( {VERDE}Modelo removido com sucesso! \){SEM_COR}"
            else
                echo "Nenhum modelo foi digitado."
            fi
            pausar
            ;;
        12)
            echo -e "\n\( {AZUL}Modelos instalados no momento: \){SEM_COR}"
            ollama list
            pausar
            ;;
        13)
            echo -e "\n\( {VERDE}Encerrando a central. Bons códigos e boa prova! \){SEM_COR}"
            exit 0
            ;;
        *)
            echo -e "\n\( {VERMELHO}Opção inválida! Tente novamente. \){SEM_COR}"
            sleep 1.3
            ;;
    esac
done
