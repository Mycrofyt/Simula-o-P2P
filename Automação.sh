#!/usr/bin/env bash

##############################################
# Simulação de Rede Acadêmica P2P com Freechains
# Autor: João Pedro, adaptado de um pre-existente
# Data: 2025-07-07
# Requisitos: freechains-host e freechains v0.10.x
##############################################

set -e

echo "🚀 Preparando ambiente..."

echo "🔹 Finalizando qualquer host existente..."
pkill -f freechains-host || true
sleep 1

echo "🔹 Limpando /tmp/freechains..."
rm -rf /tmp/freechains

echo "🔹 Iniciando host em /tmp/freechains ..."
freechains-host start /tmp/freechains &

echo "🔹 Aguardando host inicializar..."
sleep 2

echo "🔹 Verificando se o host está funcional..."
freechains chains list >/dev/null
echo "✅ Host ativo."

echo "🔹 Gerando chaves dos participantes..."
# Gerar chave apenas uma vez e armazenar# Gerar chave de Alice e usar como pioneer
read PUB_ALICE PVT_ALICE < <(freechains keys pubpvt "alice pass")

# Gerar chave de Bob
read PUB_BOB PVT_BOB < <(freechains keys pubpvt "bob pass")

# Gerar chave de Carol
read PUB_CAROL PVT_CAROL < <(freechains keys pubpvt "carol pass")

echo "🔹 PUB_ALICE: $PUB_ALICE"
echo "🔹 PUB_BOB:   $PUB_BOB"
echo "🔹 PUB_CAROL: $PUB_CAROL"
echo "🔹 PVT_ALICE: $PVT_ALICE"
echo "🔹 PVT_BOB:   $PVT_BOB"
echo "🔹 PVT_CAROL: $PVT_CAROL"
echo "🔹 Criando e entrando no canal #artigos ..."
freechains chains join '#artigos' "$PUB_ALICE"

echo "🔹 Criando genesis explicitamente..."
GENESIS_HASH=$(freechains chain '#artigos' genesis)
echo "🔹 Hash do bloco genesis: $GENESIS_HASH"

echo "🔹 Alice faz post inicial para criar o back ..."
HASH_BACK=$(freechains chain '#artigos' post inline "Post inicial de Alice para criar o back no canal." --sign="$PVT_ALICE")
echo "🔹 HASH_BACK: $HASH_BACK"

echo "🔹 Bob submete artigo ..."
HASH_ARTIGO=$(freechains chain '#artigos' post inline "Artigo sobre Redes P2P Acadêmicas por Bob." --sign="$PVT_BOB")
echo "🔹 HASH_ARTIGO: $HASH_ARTIGO"

echo "🔹 Alice e Carol aprovam o artigo de Bob..."
freechains chain '#artigos' like "$HASH_ARTIGO" --sign=$PVT_ALICE
freechains chain '#artigos' like "$HASH_ARTIGO" --sign=$PVT_CAROL

echo "🔹 Verificando reputação de Bob..."
freechains chain '#artigos' reps "$PUB_BOB"

echo "🔹 Alice sugere uma revisão..."
HASH_REVISAO=$(freechains chain '#artigos' post inline "Sugestão: Adicionar referências" --sign=$PVT_ALICE)
echo "🔹 HASH_REVISAO: $HASH_REVISAO"

echo "🔹 Carol propõe inclusão de novo revisor PUB_NOVO..."
PUB_NOVO="ABCDEF1234567890" # simulação de um novo participante
HASH_PROPOSTA=$(freechains chain '#artigos' post inline "Proponho inclusão de @$PUB_NOVO como revisor." --sign=$PVT_CAROL)
echo "🔹 HASH_PROPOSTA: $HASH_PROPOSTA"

echo "🔹 Alice aprova a proposta de inclusão de novo revisor..."
freechains chain '#artigos' like "$HASH_PROPOSTA" --sign=$PVT_ALICE

echo "🔹 Exibindo consenso atual do canal #artigos..."
freechains chain '#artigos' consensus

echo "✅ Simulação concluída com sucesso."
