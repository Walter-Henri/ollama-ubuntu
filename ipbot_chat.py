#!/usr/bin/env python3
"""
IP-BOT Chat com Memória Persistente
Usado junto com o ollama.sh
"""

import json
import os
import sys
from datetime import datetime
from pathlib import Path

try:
    import ollama
except ImportError:
    print("Erro: biblioteca 'ollama' não encontrada.")
    print("Instale com: pip3 install --user ollama")
    sys.exit(1)

# ====================== CONFIGURAÇÕES ======================
DIR_MEMORIA = Path.home() / ".ip-bot"
DIR_SOLUCOES = DIR_MEMORIA / "solucoes"
DIR_SESSOES = DIR_MEMORIA / "sessoes"

DIR_SOLUCOES.mkdir(parents=True, exist_ok=True)
DIR_SESSOES.mkdir(parents=True, exist_ok=True)

ARQUIVO_SESSAO = DIR_SESSOES / "ultima_sessao.json"

# ====================== FUNÇÕES ======================

def carregar_historico():
    """Carrega o histórico da última sessão"""
    if ARQUIVO_SESSAO.exists():
        try:
            with open(ARQUIVO_SESSAO, "r", encoding="utf-8") as f:
                data = json.load(f)
                if isinstance(data, list):
                    return data
        except (json.JSONDecodeError, Exception):
            pass
    return []

def salvar_historico(mensagens):
    """Salva o histórico da sessão atual"""
    try:
        with open(ARQUIVO_SESSAO, "w", encoding="utf-8") as f:
            json.dump(mensagens, f, ensure_ascii=False, indent=2)
    except Exception as e:
        print(f"Aviso: não foi possível salvar o histórico ({e})")

def salvar_solucao(conteudo):
    """Salva a última resposta como uma solução em arquivo .md"""
    print()
    nome = input("Nome para a solução (ex: questao01.md): ").strip()

    if not nome:
        nome = f"solucao_{datetime.now().strftime('%Y%m%d_%H%M%S')}.md"

    if not nome.endswith(".md"):
        nome += ".md"

    caminho = DIR_SOLUCOES / nome

    try:
        with open(caminho, "w", encoding="utf-8") as f:
            f.write(conteudo)
        print(f"\n✓ Solução salva com sucesso em:\n  {caminho}")
    except Exception as e:
        print(f"\nErro ao salvar solução: {e}")

def mostrar_ajuda():
    print()
    print("=" * 60)
    print("           COMANDOS DISPONÍVEIS")
    print("=" * 60)
    print("  /modo desafio   ou  /modo 1     → Ativa Modo Desafio")
    print("  /modo prova     ou  /modo 2     → Ativa Modo Prova")
    print("  /salvar                         → Salva a última resposta como solução")
    print("  /limpar                         → Limpa o histórico da sessão atual")
    print("  /ajuda                          → Mostra esta ajuda")
    print("  /sair                           → Sai e salva a sessão")
    print("=" * 60)
    print()

def main():
    print()
    print("=" * 60)
    print("           IP-BOT  •  Memória Persistente Ativada")
    print("=" * 60)
    print("Comandos especiais:")
    print("  /modo desafio     → Ativa Modo Desafio")
    print("  /modo prova       → Ativa Modo Prova")
    print("  /salvar           → Salva a última resposta como solução")
    print("  /limpar           → Limpa o histórico da sessão atual")
    print("  /ajuda            → Mostra todos os comandos")
    print("  /sair             → Sai e salva a sessão")
    print("=" * 60)
    print()

    mensagens = carregar_historico()

    if mensagens:
        print(f"✓ Histórico anterior carregado ({len(mensagens)} mensagens)")
        print("  (Use /limpar se quiser começar do zero)\n")
    else:
        print("Nenhum histórico anterior encontrado. Nova sessão iniciada.\n")

    while True:
        try:
            user_input = input("Você: ").strip()
        except (KeyboardInterrupt, EOFError):
            print("\n\nSaindo e salvando sessão...")
            salvar_historico(mensagens)
            print("Sessão salva. Até logo!")
            break

        if not user_input:
            continue

        # ===== Comandos especiais =====
        comando = user_input.lower()

        if comando in ["/sair", "sair", "exit", "quit"]:
            salvar_historico(mensagens)
            print("\nSessão salva. Até logo!")
            break

        if comando in ["/ajuda", "/help", "ajuda"]:
            mostrar_ajuda()
            continue

        if comando == "/limpar":
            mensagens = []
            salvar_historico(mensagens)
            print("✓ Histórico da sessão limpo.\n")
            continue

        if comando == "/salvar":
            if mensagens and mensagens[-1]["role"] == "assistant":
                salvar_solucao(mensagens[-1]["content"])
            else:
                print("Nenhuma resposta recente para salvar.\n")
            continue

        # Atalhos de modo
        if comando in ["/modo desafio", "/modo 1"]:
            user_input = "Modo Desafio"
        elif comando in ["/modo prova", "/modo 2"]:
            user_input = "Modo Prova"

        # ===== Envia para o modelo =====
        mensagens.append({"role": "user", "content": user_input})

        print("\nIP-BOT: ", end="", flush=True)
        resposta_completa = ""

        try:
            stream = ollama.chat(
                model="ip-bot",
                messages=mensagens,
                stream=True
            )

            for chunk in stream:
                texto = chunk.get("message", {}).get("content", "")
                print(texto, end="", flush=True)
                resposta_completa += texto

            print("\n")

        except Exception as e:
            print(f"\n\nErro ao comunicar com o modelo: {e}")
            print("Verifique se o Ollama está rodando e se o modelo 'ip-bot' existe.\n")
            mensagens.pop()  # remove a mensagem que falhou
            continue

        # Salva a resposta no histórico
        mensagens.append({"role": "assistant", "content": resposta_completa})
        salvar_historico(mensagens)

if __name__ == "__main__":
    main()
