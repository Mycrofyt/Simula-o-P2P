Roteiro de simulação do projeto de P2P utilizando Freechains puro:

tendo o Freechains instalado e funcionando...


1. Iniciar o host no background com por exemplo:

freechains-host start /tmp/freechains


2. Gerar e iniciar as chaves dos participantes através de (Considerando 3 usuários):

echo " Gerando chaves dos participantes (alice, bob, carol) ..."

PUB_ALICE=$(freechains keys pubpvt "alice pass" | head -n 1)
PVT_ALICE=$(freechains keys pubpvt "alice pass" | tail -n 1)

PUB_BOB=$(freechains keys pubpvt "bob pass" | head -n 1)
PVT_BOB=$(freechains keys pubpvt "bob pass" | tail -n 1)

PUB_CAROL=$(freechains keys pubpvt "carol pass" | head -n 1)
PVT_CAROL=$(freechains keys pubpvt "carol pass" | tail -n 1)

echo " PUB_ALICE: $PUB_ALICE"
echo " PUB_BOB:   $PUB_BOB"
echo " PUB_CAROL: $PUB_CAROL"


3. tendo separado e salvo as chaves individuais, crie o canal #artigo usando uma das chaves publicas, copie manualmente(usarei a da Alice no exemplo):

freechains chains join "#artigos" **$PUB_ALICE**


4. crie e obtenha o hash do bloco genesis do #artigo:


HASH_GENESIS=$(freechains chain "#artigos" genesis)
echo " Hash do bloco genesis: $HASH_GENESIS"


5.Faça bob submeter um artigo(sempre pondo manualmente a chave, nesse caso privada):

echo " Bob submete artigo ..."
HASH_ARTIGO=$(freechains chain "#artigos" post inline "Artigo sobre Redes P2P Acadêmicas" --sign= **$PVT_BOB**)
echo " HASH_ARTIGO: $HASH_ARTIGO"


6. Alice e Carol aprovam o artigo(ambas precisando usar suas chaves privadas):

echo " Alice e Carol aprovam (like) o artigo ...	
freechains chain "#artigos" like "$HASH_ARTIGO" --sign= **PVT_ALICE** --why="Bem escrito"
freechains chain "#artigos" like "$HASH_ARTIGO" --sign= **PVT_CAROL** --why="Contribuição relevante"


7. verificação de reputação do bob com sua chave publica:

echo " Reputação de Bob após aprovação:"
freechains chain "#artigos" reps **PUB_BOB**


8. Alice sugere melhorias usando chave privada:

echo " Alice envia sugestão de revisão ..."
HASH_SUGESTAO=$(freechains chain "#artigos" post inline "Sugiro incluir referências no final." --sign= **PVT_ALICE**
echo " HASH_SUGESTAO: $HASH_SUGESTAO"


9. Carol propõe inclusão de novo revisor usando chave privada:

echo " Carol propõe inclusão de novo revisor PUB_NOVO ..."
PUB_NOVO="ABCDEF1234567890"  # Simulação
HASH_PROPOSTA=$(freechains chain "#artigos" post inline "Proponho inclusão de @$PUB_NOVO como revisor." --sign=**PVT_CAROL**
echo " HASH_PROPOSTA: $HASH_PROPOSTA"


10. Alice vota a favor da inclusão usando chave privada da Alice:

echo " Alice aprova (like) a proposta de Carol ..."
freechains chain "#artigos" like "$HASH_PROPOSTA" --sign=**PVT_ALICE** --why="Concordo com inclusão"


11. Ver consenso atual:

echo " Consenso atual do canal #artigos:"
freechains chain "#artigos" consensus


echo " Simulação concluída."

