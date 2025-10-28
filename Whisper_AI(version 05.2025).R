# ========================================================
# CONFIGURAÇÃO COMPLETA PARA USAR O WHISPER NO RSTUDIO
# ========================================================

# PASSO 1: INSTALAR PACOTES R NECESSÁRIOS
# Verifica se os pacotes estão instalados e instala se necessário
required_packages <- c("reticulate", "officer")

for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

library(reticulate)
library(officer)

# ========================================================
# PASSO 2: INSTALAR O ANACONDA (SE AINDA NÃO TIVER)
# ========================================================
# 1️⃣ Acesse: https://www.anaconda.com/download/
# 2️⃣ Baixe a versão para Windows (64-bit).
# 3️⃣ Durante a instalação, marque a opção "Add Anaconda to PATH" (IMPORTANTE!).
# 4️⃣ Finalize a instalação e reinicie o computador.

# PASSO 3: VERIFICAR SE O CONDA ESTÁ FUNCIONANDO
# No Prompt de Comando (cmd), digite:
#   conda --version
# Se aparecer algo como "conda 4.xx.x", o Conda está funcionando corretamente.

# SE O COMANDO ACIMA NÃO FUNCIONAR, ADICIONE O CONDA AO PATH MANUALMENTE:
# 1️⃣ No Windows, abra o Menu Iniciar, pesquise por "Variáveis de Ambiente" e clique em "Editar as variáveis de ambiente do sistema".
# 2️⃣ Na aba "Avançado", clique em "Variáveis de Ambiente".
# 3️⃣ Na seção "Variáveis do Sistema", encontre "Path" e clique em "Editar".
# 4️⃣ Clique em "Novo" e adicione os seguintes caminhos (dependendo de onde o Anaconda foi instalado):
#    C:\Users\SEU_USUARIO\Anaconda3
#    C:\Users\SEU_USUARIO\Anaconda3\Scripts
#    C:\Users\SEU_USUARIO\Anaconda3\Library\bin
# 5️⃣ Clique em "OK" e reinicie o computador.

# ========================================================
# PASSO 4: INSTALAR E CONFIGURAR O FFMPEG (OBRIGATÓRIO PARA O WHISPER)
# ========================================================
# 1️⃣ Baixe o FFmpeg para Windows (64-bit) neste link:
#    https://github.com/BtbN/FFmpeg-Builds/releases
# 2️⃣ Escolha uma versão "Windows 64-bit" e baixe o arquivo ZIP.
# 3️⃣ Extraia os arquivos para um local de fácil acesso, por exemplo: C:\ffmpeg
# 4️⃣ Adicione ao PATH do Windows:
#    - Vá para "Variáveis de Ambiente" no Windows
#    - Edite a variável "Path"
#    - Adicione: C:\ffmpeg\bin
# 5️⃣ Teste no Prompt de Comando:
#    - Execute: ffmpeg -version
#    - Se aparecer informações do FFmpeg, está pronto para uso.

# ========================================================
# PASSO 5: CRIAR E ATIVAR O AMBIENTE CONDA NO RSTUDIO
# ========================================================

# Definir um caminho genérico para o Conda (substituir pelo caminho real se necessário)
conda_path <- "C:/Users/SEU_USUARIO/anaconda3/envs/whisper_env/python.exe"
Sys.setenv(RETICULATE_PYTHON = conda_path)

# Criar um ambiente Conda chamado "whisper_env" (somente na primeira vez)
if (!conda_list()$name %in% "whisper_env") {
  conda_create("whisper_env")
}

# Ativar o ambiente Conda
use_condaenv("whisper_env", required = TRUE)

# ========================================================
# PASSO 6: INSTALAR O WHISPER E SUAS DEPENDÊNCIAS
# ========================================================
py_install("openai-whisper", pip = TRUE)
py_install("ffmpeg-python", pip = TRUE)  # Instalar suporte ao FFmpeg

# ========================================================
# PASSO 7: TESTAR SE O WHISPER FOI INSTALADO CORRETAMENTE
# ========================================================
whisper <- import("whisper")

# Ativar o ambiente Conda SEMPRE QUE REINICIAR O RSTUDIO
#.rs.restartR()
#library(reticulate)
#use_condaenv("whisper_env", required = TRUE)
#whisper <- import("whisper")

# ========================================================
# PASSO 8: ESCOLHER O MODELO DO WHISPER PARA TRANSCRIÇÃO
# ========================================================
# Modelos disponíveis: "tiny", "base", "small", "medium", "large"
modelo_whisper <- "medium"  # Pode mudar para "small" se quiser mais velocidade

# Carregar o modelo escolhido
model <- whisper$load_model(modelo_whisper)

# ========================================================
# PASSO 9: DEFINIR O ARQUIVO DE ÁUDIO A SER TRANSCRITO
# ========================================================
# Substitua "SEU_USUARIO" pelo nome do usuário do Windows ao compartilhar este script
audio_path <- "C:/Users/SEU_USUARIO/Documentos/entrevista_audio.wav"

# Testar se o arquivo existe antes de transcrever
if (file.exists(audio_path)) {
  print("✅ Arquivo encontrado!")
} else {
  stop("❌ ERRO: Arquivo NÃO encontrado! Verifique o caminho.")
}

# ========================================================
# PASSO 10: TRANSCRIÇÃO DO ÁUDIO
# ========================================================
start_time <- Sys.time()  # Iniciar contagem do tempo
result <- model$transcribe(audio_path, language="pt")
end_time <- Sys.time()  # Finalizar contagem do tempo

# Exibir a transcrição no console
print(result$text)

# Mostrar o tempo total de processamento
print(paste("Tempo total de transcrição:", round(difftime(end_time, start_time, units = "mins"), 2), "minutos"))

# ========================================================
# PASSO 11: SALVAR A TRANSCRIÇÃO EM ARQUIVO TXT E DOCX
# ========================================================
output_path <- "C:/Users/SEU_USUARIO/Documentos/transcricao"

writeLines(result$text, paste0(output_path, ".txt"))

# Para salvar como DOCX (Word)
doc <- read_docx()
doc <- body_add_par(doc, result$text)
print(doc, target = paste0(output_path, ".docx"))

print("✅ Transcrição salva com sucesso como .docx!")

# ========================================================
# FIM DO SCRIPT - O WHISPER ESTÁ PRONTO PARA USO 🚀
# ========================================================
