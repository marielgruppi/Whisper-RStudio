# Whisper com RStudio 🚀

Este repositório contém um **script R** para transcrever áudios usando o **Whisper AI da OpenAI**, com suporte ao **FFmpeg** e **Conda** no Windows.

## 📌 Requisitos
- **Windows 64-bit**
- **R + RStudio**
- **Anaconda** ([Download](https://www.anaconda.com/download/))
- **FFmpeg** ([Baixar aqui](https://github.com/BtbN/FFmpeg-Builds/releases))

## 🔧 Instalação
1. Instale o **Anaconda** e adicione ao `PATH`.
2. Instale o **FFmpeg** e adicione `C:\ffmpeg\bin` ao `PATH` do Windows.
3. Baixe o script `whisper_transcribe.R` deste repositório.
4. Abra o RStudio e execute o script.

## 🎤 Como Usar
1. Defina o **caminho do arquivo de áudio** (`audio_path`).
2. Escolha o **modelo Whisper** (`"tiny"`, `"base"`, `"small"`, `"medium"`, `"large"`).
3. O script transcreve e salva o texto em `.txt` e `.docx`.

## ⚡ Exemplo de Execução
```r
source("whisper_transcribe.R")
