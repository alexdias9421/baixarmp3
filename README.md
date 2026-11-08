# 🎧 BaixarMP3 - Termux YouTube Downloader (V3)

**🎨 Script visual e completo para baixar vídeos e músicas do YouTube no Termux!**

---

## 📱 Pre-requisitos (Instale no Termux)

```bash
# 1. Atualize o Termux
pkg update && pkg upgrade -y

# 2. Instale as ferramentas de texto e cores
pkg install -y figlet toilet

# 3. Configurar armazenamento do Android
termux-setup-storage

# 4. Baixar e clonar o script
git clone https://github.com/alexdias9421/baixarmp3.git
cd baixarmp3
```

---

## 🔧 Instalação Automática (Recomendado)

Execute o instalador com todos os permissões necessárias:

```bash
bash baixarmp3.sh
```

> ⏳ **O que o instalador faz?**  
Ele instala automaticamente:
> - `ffmpeg` (codificação de áudio/vídeo)  
> - `python`  
> - `yt-dlp` (baixador de vídeos)  
> - `mutagen` (embed de metadados)

---

## 🏃 Como Usar

### Opção 1 - Interativo (Recomendado)
```bash
baixarmp3
```
Será perguntado:
1. **Vídeo ou MP3** → `1` ou `2`  
2. **Qualidade** → `480p`, `720p`, `1080p`  
3. **Formato** (vídeo) → `mp4`, `avi`, `flv`  
4. **Bitrate** (MP3) → `128k`, `192k`, `256k`, `320k`

### Opção 2 - Passe a URL diretamente
```bash
baixarmp3 "https://youtube.com/watch?v=SEU_VIDEO"
```

---

## 📐 Qualidades e Formatos Suportados

### Vídeos
| Qualidade | Resolução | Opção |
|---|---|---|
| 480p | 854×480 | Escolha `1` |
| 720p | 1280×720 | Escolha `2` (HD) |
| 1080p | 1920×1080 | Escolha `3` (Full HD) |

### Formatos de Vídeo
| Código | Formato | Extensão |
|---|---|---|
| 1 | MP4 | `.mp4` (recomendado) |
| 2 | AVI | `.avi` |
| 3 | FLV | `.flv` |

> **Nota:** A opção `3` (FLV) está disponível, mas o **MP4** (opção `1`) é o mais recomendado por ter melhor compatibilidade e menor tamanho de arquivo.

### MP3 (Áudio)
| Bitrate | Qualidade | Opção |
|---|---|---|
| 128k | Padrão | Escolha `1` |
| 192k | Alto | Escolha `2` |
| 256k | Médio-Alto | Escolha `3` |
| 320k | Alta Fidelidade (CD) | Escolha `4` |

---

## 📁 Onde os Arquivos São Salvos

**Pasta padrão:** `~/Download/baixarmp3`

O script detecta automaticamente:
1. `/sdcard/Download/` ✓
2. `~/storage/downloads/` ✓  
3. `~/Downloads/` ✓

---

## 💾 Persistência de Preferências

> O script **salva** suas últimas escolhas!

- **Salvo em:** `~/.config/baixarmp3/prefs.conf`
- **Próxima vez**, pressione `Enter` para usar o mesmo:
  - Qualidade do vídeo
  - Formato escolhido
  - Bitrate do MP3

Para **resetar** as preferências:
```bash
rm -rf ~/.config/baixarmp3
```

---

## 🎨 Interface Colorida (ASCII Art)

> **Sobre o `figlet`:** O script utiliza o `figlet` para gerar o ASCII art grande e bonito na inicialização. Se não estiver instalado, o script continua funcionando normalmente com o texto padrão.

```
============================================
    BAIXAR MP3 & VÍDEO - TERMUX          
============================================

O que você deseja baixar?
  1) Vídeo (MP4, AVI ou FLV)
  2) MP3 (áudio)
  3) Sair
Opção [1-3]: 
```

Com `figlet` instalado, a mensagem de boas-vindas aparece em **ASCII art colorido**!

---

## 🛡️ Permissões Concedidas

Para que tudo funcione perfeitamente, dê estas permissões:

| Permissão | Para quê |
|---|---|
| Armazenamento (`termux-setup-storage`) | Salvar arquivos |
| Python | Executar `yt-dlp` e `mutagen` |
| `ffmpeg` | Transcodificar áudio/vídeo |

---

## 🚾 Como Sair / How to Exit

### No terminal Python:

Pressione **`Ctrl + C`** para interromper a execução imediatamente.

Ou digite **`sair`** ou **`exit`** para encerrar o programa limposamente.

### No shell (bash):

Pressione **`Ctrl + C`** ou **`Ctrl + D`** (EOF) para sair do script.

---

## 🐛 Solução de Problemas

| Problema | Solução |
|---|---|
| **Comando não encontrado** | Execute `bash baixarmp3.sh` novamente |
| **Erro de download** | Verifique a URL no navegador do Android |
| **Não salva arquivos** | Rode `termux-setup-storage` no Termux |
| **Formato errado** | Verifique preferências em `~/.config/baixarmp3/prefs.conf` |

---

## 📝 Estrutura do Projeto

```
baixarmp3/
├── baixarmp3.sh      # Script instalador
├── README.md         # Este arquivo
└── .gitignore        # Arquivos a ignorar
```

---

## 🤝 Contribuições

Aberto para issues e pull requests!  
Use a issue tracker do GitHub para bugs ou sugestões.

---

## 📜 Licença

MIT License - Livre para uso e modificação.

---

## 🚀 Quick Links

- **GitHub**: <https://github.com/alexdias9421/baixarmp3>
- **Repositório Termux**: Instale no Android

---

*Desenvolvido com ❤️ no Termux usando o assistente Claude Code*