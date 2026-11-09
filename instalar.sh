#!/data/data/com.termux/files/usr/bin/bash
# Instalador Do Baixador De CD - Projeto Termux (ATUALIZADO - com busca por ano)

# Cores
VERDE='\033[1;32m'
AMARELO='\033[1;33m'
VERMELHO='\033[1;31m'
AZUL='\033[1;34m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
RESET='\033[0m'

echo -e "${AZUL}============================================${RESET}"
echo -e "${AZUL}    INSTALADOR DO BAIXADOR DE CD            ${RESET}"
echo -e "${AZUL}============================================${RESET}"
echo ""

# Passo 1: Verificar instalar storage
echo -e "${AMARELO}[1/5] Configurando armazenamento...${RESET}"
if [ ! -d "$HOME/storage" ]; then
    termux-setup-storage
    echo -e "${VERDE}[✓] Armazenamento configurado${RESET}"
else
    echo -e "${VERDE}[✓] Armazenamento ja configurado${RESET}"
fi

# Passo 2: Instalar dependencias
echo ""
echo -e "${AMARELO}[2/5] Instalando dependencias (ffmpeg, figlet, python)...${RESET}"
pkg install -y ffmpeg figlet python curl > /dev/null 2>&1
echo -e "${VERDE}[✓] Dependencias instaladas${RESET}"

# Passo 3: Instalar bibliotecas Python
echo ""
echo -e "${AMARELO}[3/5] Instalando bibliotecas Python (yt-dlp, mutagen)...${RESET}"
pip install -U yt-dlp mutagen > /dev/null 2>&1
echo -e "${VERDE}[✓] Bibliotecas Python instaladas${RESET}"

# Passo 4: Criar diretorio bin
echo ""
echo -e "${AMARELO}[4/5] Criando diretorio de comandos...${RESET}"
mkdir -p "$HOME/.local/bin"

# Passo 5: Criar o script principal
echo -e "${AMARELO}[5/5] Criando comando 'baixador-cd'...${RESET}"

cat > "$HOME/.local/bin/baixador-cd" << 'ENDSCRIPT'
#!/data/data/com.termux/files/usr/bin/bash
clear

# Cores
VERDE='\033[1;32m'
AMARELO='\033[1;33m'
VERMELHO='\033[1;31m'
AZUL='\033[1;34m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
RESET='\033[0m'

# Pasta de downloads - detecta automaticamente
DOWNLOAD_BASE="/sdcard/Download/CDs_BAIXADOS"
[ ! -d "$DOWNLOAD_BASE" ] && DOWNLOAD_BASE="$HOME/storage/downloads/CDs_BAIXADOS"
[ ! -d "$DOWNLOAD_BASE" ] && DOWNLOAD_BASE="$HOME/Download/CDs_BAIXADOS"
mkdir -p "$DOWNLOAD_BASE"

# Arquivo de preferencias
PREFS="$HOME/.config/baixador_cd/prefs.conf"
mkdir -p "$HOME/.config/baixador_cd"

# Carregar preferencias (bittarate padrao)
BITRATE="320k"
[ -f "$PREFS" ] && source "$PREFS"

# Banner com figlet
echo ""
figlet -f slant "BAIXADOR CD" 2>/dev/null || echo "   _____ _____   ____  _   _ ______ _____   _____ _   _ ______ _____ "
echo -e "${MAGENTA}============================================${RESET}"
echo -e "${MAGENTA}    Download de CDs por Genero Musical      ${RESET}"
echo -e "${MAGENTA}============================================${RESET}"
echo ""

# Funcao: Listar generos
listar_generos() {
    echo "  1) Sertanejo  | 2) Hip Hop  | 3) Pop  | 4) Rock"
    echo "  5) Funk       | 6) Pagode   | 7) Dance| 8) Jazz"
    echo "  9) Classico   | 10) MPB     | 11) Eletronica"
    echo "  12) Outro"
}

# Funcao: Configurar bitrate
configurar_bitrate() {
    echo -e "${CYAN}Bitrate MP3:${RESET}"
    echo "  1) 128k | 2) 192k | 3) 256k | 4) 320k"
    read -p "Escolha [1-4]: " b
    case $b in
        1) BITRATE="128k" ;;
        2) BITRATE="192k" ;;
        3) BITRATE="256k" ;;
        *) BITRATE="320k" ;;
    esac
    echo "BITRATE='$BITRATE'" > "$PREFS"
    echo -e "${VERDE}Bitrate alterado para: $BITRATE${RESET}"
}

# Funcao: Baixar musicas (com ano)
baixar_musicas() {
    local query="$1"
    local genero="$2"
    local output="$DOWNLOAD_BASE/$genero"
    mkdir -p "$output"

    echo ""
    echo -e "${AZUL}Preparando download...${RESET}"
    echo -e "  Query:   $query"
    echo -e "  Genero:  $genero"
    echo -e "  Pasta:   $output"
    echo ""

    # Adiciona "music" ou "song" dependendo do query
    yt-dlp -f "bestaudio" --extract-audio --audio-format mp3 --audio-quality "$BITRATE" --embed-thumbnail --add-metadata --progress -o "$output/%(title)s.%(ext)s" "ytsearch50:$query music" 2>&1 | grep -E "(Downloading|Destination|aria2|Analyzing)" || true

    echo ""
    echo -e "${VERDE}Download concluido!${RESET}"
    echo -e "${CYAN}Caminho: $output${RESET}"
    echo ""
}

# Funcao: Mostrar status
mostrar_status() {
    echo ""
    echo -e "${CYAN}Status dos Downloads:${RESET}"
    echo -e "  Pasta principal: $DOWNLOAD_BASE"
    for d in "$DOWNLOAD_BASE"/*/; do
        [ -d "$d" ] && nome=$(basename "$d") && count=$(find "$d" -name "*.mp3" 2>/dev/null | wc -l) && echo -e "  ${MAGENTA}$nome:${RESET} $count musicas"
    done
    total=$(find "$DOWNLOAD_BASE" -name "*.mp3" 2>/dev/null | wc -l)
    echo -e "  ${VERDE}Total:${RESET} $total arquivos MP3"
    echo ""
}

# Funcao: Mostrar caminho
mostrar_caminho() {
    echo ""
    echo -e "${AZUL}Caminho dos Arquivos:${RESET}"
    echo -e "  ${CYAN}$DOWNLOAD_BASE${RESET}"
    echo ""
    ls -la "$DOWNLOAD_BASE" 2>/dev/null || echo -e "  ${AMARELO}Pasta vazia${RESET}"
    echo ""
}

# Funcao: Buscar por ano
buscar_por_ano() {
    echo ""
    read -p "Digite o ano (ex: 2023 ou 2024): " ano
    read -p "Digite artista (ou Enter para 'Top hits'): " artista

    # Se artista vazio, usar search genérico
    if [ -z "$artista" ]; then
        artista="Top hits"
    fi

    # Montar query com ano
    query="$artista $ano"

    # Perguntar gênero
    listar_generos
    read -p "Genero (1-12): " g
    case $g in
        1) genero="Sertanejo" ;;
        2) genero="Hip Hop" ;;
        3) genero="Pop" ;;
        4) genero="Rock" ;;
        5) genero="Funk" ;;
        6) genero="Pagode" ;;
        7) genero="Dance" ;;
        8) genero="Jazz" ;;
        9) genero="Classico" ;;
        10) genero="MPB" ;;
        11) genero="Eletronica" ;;
        *) genero="Outros" ;;
    esac

    baixar_musicas "$query" "$genero"
}

# Loop principal do menu
while true; do
    echo ""
    echo -e "${CYAN}Menu:${RESET}"
    echo -e "  ${AMARELO}1)${RESET} Pesquisar por artista"
    echo -e "  ${AMARELO}2)${RESET} Download rapido (URL)"
    echo -e "  ${AMARELO}3)${RESET} Baixar por genero"
    echo -e "  ${AMARELO}4)${RESET} Buscar por ano"
    echo -e "  ${AMARELO}5)${RESET} Mostrar status"
    echo -e "  ${AMARELO}6)${RESET} Mostrar caminho"
    echo -e "  ${AMARELO}7)${RESET} Configurar opcoes"
    echo -e "  ${AMARELO}0)${RESET} Sair"
    echo ""

    read -p "Escolha> " op

    case $op in
        1)
            echo ""
            read -p "Digite artista ou DJ: " artista
            listar_generos
            read -p "Genero (1-12): " g
            case $g in
                1) genero="Sertanejo" ;;
                2) genero="Hip Hop" ;;
                3) genero="Pop" ;;
                4) genero="Rock" ;;
                5) genero="Funk" ;;
                6) genero="Pagode" ;;
                7) genero="Dance" ;;
                8) genero="Jazz" ;;
                9) genero="Classico" ;;
                10) genero="MPB" ;;
                11) genero="Eletronica" ;;
                *) read -p "Genero personalizado: " genero ;;
            esac
            baixar_musicas "$artista" "$genero"
            ;;

        2)
            echo ""
            read -p "URL YouTube ou busca: " url
            listar_generos
            read -p "Genero (1-12): " g
            case $g in
                1) genero="Sertanejo" ;;
                2) genero="Hip Hop" ;;
                3) genero="Pop" ;;
                4) genero="Rock" ;;
                5) genero="Funk" ;;
                6) genero="Pagode" ;;
                7) genero="Dance" ;;
                8) genero="Jazz" ;;
                9) genero="Classico" ;;
                10) genero="MPB" ;;
                11) genero="Eletronica" ;;
                *) genero="Outros" ;;
            esac
            baixar_musicas "$url" "$genero"
            ;;

        3)
            echo ""
            listar_generos
            read -p "Escolha o genero (1-12): " g
            case $g in
                1) baixar_musicas "Top Sertanejo" "Sertanejo" ;;
                2) baixar_musicas "Top Hip Hop Hits" "Hip Hop" ;;
                3) baixar_musicas "Top Pop Hits" "Pop" ;;
                4) baixar_musicas "Top Rock Hits" "Rock" ;;
                5) baixar_musicas "Top Funk Hits" "Funk" ;;
                6) baixar_musicas "Top Pagode" "Pagode" ;;
                7) baixar_musicas "Top Dance Hits" "Dance" ;;
                8) baixar_musicas "Jazz Classics" "Jazz" ;;
                9) baixar_musicas "Classical Music" "Classico" ;;
                10) baixar_musicas "Top MPB" "MPB" ;;
                11) baixar_musicas "Top Electronic" "Eletronica" ;;
                *) read -p "Genero personalizado: " gen; baixar_musicas "$gen" "Outros" ;;
            esac
            ;;

        4)
            buscar_por_ano
            ;;

        5) mostrar_status ;;
        6) mostrar_caminho ;;
        7) configurar_bitrate ;;

        0)
            echo ""
            echo -e "${VERDE}Obrigado por usar o BAIXADOR DE CD!${RESET}"
            echo -e "${CYAN}Arquivos salvos em: $DOWNLOAD_BASE${RESET}"
            echo ""
            exit 0
            ;;

        *)
            echo -e "${VERMELHO}Opcao invalida${RESET}"
            ;;
    esac
done
ENDSCRIPT

# Tornar executavel
chmod +x "$HOME/.local/bin/baixador-cd"

# Garantir permissao tambem no diretorio do PREFIX se existir
if [ -n "$PREFIX" ] && [ -d "$PREFIX/bin" ]; then
    cp "$HOME/.local/bin/baixador-cd" "$PREFIX/bin/baixador-cd"
    chmod +x "$PREFIX/bin/baixador-cd"
fi

# Adicionar ao PATH do .bashrc
if ! grep -q ".local/bin" "$HOME/.bashrc" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

# Mensagem final
echo ""
echo -e "${VERDE}============================================${RESET}"
echo -e "${VERDE}    INSTALACAO CONCLUIDA COM SUCESSO!       ${RESET}"
echo -e "${VERDE}============================================${RESET}"
echo ""
echo -e "${CYAN}Para usar:${RESET}"
echo -e "  1. Feche este terminal"
echo -e "  2. Abra o Termux novamente"
echo -e "  3. Digite: ${AMARELO}baixador-cd${RESET}"
echo ""
echo -e "${CYAN}Caminho dos downloads:${RESET}"
echo -e "  ${AMARELO}/sdcard/Download/CDs_BAIXADOS${RESET}"
echo -e "  Ou: ${AMARELO}$HOME/storage/downloads/CDs_BAIXADOS${RESET}"
echo ""