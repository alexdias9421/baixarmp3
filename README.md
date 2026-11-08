# 🚀 BaixarMP3 - Termux YouTube Downloader (V3)

![Termux](https://img.shields.io/badge/Platform-Termux-orange.svg)
![Python](https://img.shields.io/badge/Python-3.x-blue.svg)
![yt-dlp](https://img.shields.io/badge/Tool-yt--dlp-red.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

Um script potente e interativo para Termux que facilita o download de vídeos e áudios do YouTube. Ele automatiza a instalação das dependências, memoriza suas preferências de qualidade e organiza seus downloads automaticamente na pasta do sistema.

## ✨ Novidades da V3

- **🧠 Memória de Preferências**: O script agora lembra a última qualidade de vídeo, formato e bitrate de áudio que você escolheu.
- **📁 Organização Inteligente**: Detecta automaticamente a pasta de downloads do seu Android (`/sdcard/Download/baixarmp3`).
- **🎬 Menu Interativo**: Escolha entre Vídeo ou MP3 logo no início.
- **📊 Qualidades Variadas**:
  - **Vídeo**: 480p, 720p (HD), 1080p (Full HD).
  - **Formatos**: MP4, AVI, FLV.
  - **Áudio**: MP3 em 128k, 192k, 256k ou 320k (Alta Fidelidade).

## 🛠️ Instalação Rápida

1. Abra o seu Termux.
2. Baixe o script de instalação (ou clone este repositório):
   ```bash
   bash baixarmp3.sh
   ```
3. O instalador cuidará de tudo: `ffmpeg`, `python` e `yt-dlp`.

## 🚀 Como Usar

Após a instalação, você pode usar o comando em qualquer lugar do terminal:

```bash
# Simplesmente digite:
baixarmp3
```

Ou passe a URL diretamente:
```bash
baixarmp3 "https://www.youtube.com/watch?v=XXXXXXXX"
```

### O que acontece quando você executa?
1. **Pergunta o Alvo**: Se não passou a URL, ele pede o link ou termo de busca.
2. **Tipo de Mídia**: Pergunta se você quer Vídeo ou Música.
3. **Qualidade**: Sugere a última qualidade usada (basta apertar `Enter`) ou permite escolher uma nova.
4. **Download**: Baixa e converte usando o `ffmpeg`.
5. **Sucesso**: Avisa o caminho exato onde o arquivo foi salvo.

## ⚙️ Configurações

As preferências são salvas em:
`~/.config/baixarmp3/prefs.conf`

Você pode apagar essa pasta se quiser resetar as configurações padrão.

## 📋 Requisitos

- Termux (Android)
- Acesso ao armazenamento (`termux-setup-storage`)
- Conexão com internet

## 🤝 Contribuição

Sinta-se à vontade para abrir Issues ou enviar Pull Requests para melhorar o script!

---
*Gerado por Claude Code no Termux*
