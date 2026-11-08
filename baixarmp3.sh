#!/data/data/com.termux/files/usr/bin/bash

# Script Instalador do baixarmp3 para Termux (Atualizado - V3 com memória de preferências)

VERDE='\033[1;32m'
AMARELO='\033[1;33m'
VERMELHO='\033[1;31m'
AZUL='\033[1;34m'
CYAN='\033[1;36m'
RESET='\033[0m'

echo -e "${AZUL}--------------------------------------------${RESET}"
echo -e "${AZUL}    INSTALADOR ATUALIZADO DO BAIXARMP3      ${RESET}"
echo -e "${AZUL}--------------------------------------------${RESET}"

echo -e "${AMARELO}[1/3] Verificando dependências (ffmpeg, python, yt-dlp)...${RESET}"
pkg update -y && pkg install -y ffmpeg python
pip install -U yt-dlp mutagen

echo -e "${AMARELO}[3/3] Criando o comando 'baixarmp3' em $PREFIX/bin/...${RESET}"

cat << 'EOF' > "$PREFIX/bin/baixarmp3"
#!/data/data/com.termux/files/usr/bin/bash

VERDE='\033[1;32m'
AMARELO='\033[1;33m'
VERMELHO='\033[1;31m'
AZUL='\033[1;34m'
CYAN='\033[1;36m'
RESET='\033[0m'

# Arquivo de memória de preferências
PREF_DIR="$HOME/.config/baixarmp3"
PREF_FILE="$PREF_DIR/prefs.conf"
mkdir -p "$PREF_DIR"

# Carregar preferências salvas se existirem
if [ -f "$PREF_FILE" ]; then
    . "$PREF_FILE"
fi

# Valores padrão
QUALIDADE_VIDEO="${QUAL_VIDEO:-720p}"
FORMATO_VIDEO="${FORMATO_VIDEO:-mp4}"
BITRATE_MUSICA="${BITRATE_MUSICA:-320k}"
USE_LAST_QUALITY="${USE_LAST_QUALITY:-true}"

echo -e "${AZUL}============================================${RESET}"
echo -e "${AZUL}       BAIXAR MP3 & VÍDEO - TERMUX          ${RESET}"
echo -e "${AZUL}============================================${RESET}"

# Definir pasta de saída
DESTINO="/sdcard/Download/baixarmp3"
[ ! -d "/sdcard/Download" ] && DESTINO="$HOME/storage/downloads/baixarmp3"
[ ! -d "$HOME/storage/downloads" ] && [ ! -d "/sdcard/Download" ] && DESTINO="$HOME/Downloads/baixarmp3"
mkdir -p "$DESTINO"

echo -e ""
echo -e "${CYAN}O que você deseja baixar?${RESET}"
echo -e "  ${AMARELO}1)${RESET} Vídeo (MP4, AVI ou FLV)"
echo -e "  ${AMARELO}2)${RESET} MP3 (áudio)"
echo -ne "${CYAN}Opção [1-2]${RESET}: "
read TIPO_OPCAO

# Função para salvar preferências
salvar_prefs() {
    cat > "$PREF_FILE" << PREFS
QUAL_VIDEO="$QUALIDADE_VIDEO"
FORMATO_VIDEO="$FORMATO_VIDEO"
BITRATE_MUSICA="$BITRATE_MUSICA"
USE_LAST_QUALITY="$USE_LAST_QUALITY"
PREFS
}

# Função para escolher qualidade do vídeo
escolher_qualidade_video() {
    if [ "$USE_LAST_QUALITY" = "true" ] && [ -n "$QUALIDADE_VIDEO_ANTERIOR" ]; then
        echo -e "${CYAN}Usando qualidade anterior: $QUALIDADE_VIDEO_ANTERIOR${RESET}"
        QUALIDADE=$QUALIDADE_VIDEO_ANTERIOR
    else
        echo -e "${CYAN}Qualidade do vídeo:${RESET} 1)480p 2)720p 3)1080p"
        read -p "Escolha [1-3] (Default 720p): " V_QUAL
        case "$V_QUAL" in
            1) QUALIDADE="bestvideo[height<=480]+bestaudio/best[height<=480]";;
            3) QUALIDADE="bestvideo[height<=1080]+bestaudio/best[height<=1080]";;
            *) QUALIDADE="bestvideo[height<=720]+bestaudio/best[height<=720]";;
        esac
    fi
    QUALIDADE_VIDEO_ANTERIOR="$QUALIDADE"

    echo -e "${CYAN}Formato:${RESET} 1)MP4 2)AVI 3)FLV"
    read -p "Escolha [1-3] (Default MP4): " V_FORM
    case "$V_FORM" in
        2) EXT="avi"; RECODE="--recode-video avi"; FORMATO_VIDEO="avi";;
        3) EXT="flv"; RECODE="--recode-video flv"; FORMATO_VIDEO="flv";;
        *) EXT="mp4"; RECODE="--merge-output-format mp4"; FORMATO_VIDEO="mp4";;
    esac
}

# Função para escolher bitrate do áudio
escolher_bitrate_audio() {
    if [ "$USE_LAST_BITRATE" = "true" ] && [ -n "$BITRATE_MUSICA_ANTERIOR" ]; then
        echo -e "${CYAN}Usando bitrate anterior: $BITRATE_MUSICA_ANTERIOR${RESET}"
        BIT="$BITRATE_MUSICA_ANTERIOR"
    else
        echo -e "${CYAN}Bitrate do MP3:${RESET} 1)128k 2)192k 3)256k 4)320k"
        read -p "Escolha [1-4] (Default 320k): " A_BIT
        case "$A_BIT" in
            1) BIT="128k";;
            2) BIT="192k";;
            3) BIT="256k";;
            *) BIT="320k";;
        esac
    fi
    BITRATE_MUSICA_ANTERIOR="$BIT"
}

ALVO="$*"
if [ -z "$ALVO" ]; then
    echo -ne "${AMARELO}Digite a URL ou termo de busca: ${RESET}"
    read ALVO
fi

[[ "$ALVO" =~ ^https?:// ]] || [[ "$ALVO" =~ ^youtu\.be/ ]] && ALVO="$ALVO" || ALVO="ytsearch1:$ALVO"

if [ "$TIPO_OPCAO" = "1" ]; then
    escolher_qualidade_video
    yt-dlp -f "$QUALIDADE" $RECODE --embed-metadata -o "$DESTINO/%(title)s.%(ext)s" "$ALVO"

elif [ "$TIPO_OPCAO" = "2" ]; then
    escolher_bitrate_audio
    # Usar --progress para mostrar apenas a barra/porcentagem, nome da música e tipo do arquivo
    yt-dlp -x --audio-format mp3 --audio-quality "$BIT" --embed-metadata --progress --newline --progress-template 'Baixando: %(info.title)s [%(ext)s] - %(progress._percent_str)s' -o "$DESTINO/%(title)s.%(ext)s" "$ALVO"

else
    echo "Opção inválida."
    exit 1
fi

[ $? -eq 0 ] && echo -e "${VERDE}Sucesso! Salvo em: $DESTINO${RESET}" || echo -e "${VERMELHO}Erro no download.${RESET}"

# Salvar preferências após download bem-sucedido
if [ $? -eq 0 ]; then
    salvar_prefs
fi
EOF

chmod +x "$PREFIX/bin/baixarmp3"
echo -e "${VERDE}INSTALAÇÃO/ATUALIZAÇÃO CONCLUÍDA!${RESET}"
