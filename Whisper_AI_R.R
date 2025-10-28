# ========================================================
# 01_instalacao.R (REALIZAR UMA SÓ VEZ)
# CONFIGURAÇÃO COMPLETA PARA USAR O WHISPER NO RSTUDIO
# ========================================================

# ========================================================
# PASSO 1: INSTALAR PACOTES R NECESSÁRIOS
# ========================================================
# Verifica se os pacotes estão instalados e instala se necessário

required_packages <- c("reticulate", "officer")

for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

library(reticulate) # para trabalhar com o python por meio do RStudio
library(officer)    # para criar arquivos .docx das suas transcrições

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
# Se aparecer algo como "conda 25.xx.x", o Conda está funcionando corretamente.

# SE O COMANDO ACIMA NÃO FUNCIONAR, ADICIONE O CONDA AO PATH MANUALMENTE:
# 1️⃣ No Windows, abra o Menu Iniciar, pesquise por "Variáveis de Ambiente" e clique em "Editar as variáveis de ambiente do sistema".
# 2️⃣ Na aba "Avançado", clique em "Variáveis de Ambiente".
# 3️⃣ Na seção "Variáveis do Sistema", encontre "Path" e clique em "Editar".
# 4️⃣ Clique em "Novo" e adicione os seguintes caminhos (dependendo de onde o Anaconda foi instalado):
#    C:\Users\SEU_USUARIO\Anaconda3
#    C:\Users\SEU_USUARIO\Anaconda3\Scripts
#    C:\Users\SEU_USUARIO\Anaconda3\Library\bin
#    ATENÇÃO: você pode ter baixado o miniconda3, nesse caso basta adaptar o código acima com a interface do Python que utiliza.
# 5️⃣ Clique em "OK" e reinicie o computador.

# ========================================================
# PASSO 4: INSTALAR E CONFIGURAR O FFMPEG (OBRIGATÓRIO PARA O WHISPER)
# ========================================================
# 1️⃣ Baixe o FFmpeg para Windows (64-bit) neste link:
#    https://github.com/BtbN/FFmpeg-Builds/releases
# 2️⃣ Escolha uma versão "Windows 64-bit" e baixe o arquivo ZIP.
# 3️⃣ Extraia os arquivos para um local de fácil acesso, por exemplo:
#        - C:\ffmpeg; (ou)
#        - C:\Users\SEU_USUARIO\ffmpeg
# 4️⃣ Adicione ao PATH do Windows:
#    - Busque "Variáveis de ambiente" no Windows
#    - Vá para "Editar as variáveis de ambiente do sistema" no Windows
#    - Abrirá uma janela como "Propriedades do sistema", clique em "Variáveis do ambiente..."
#    - Na nova janela, em variáveis do usuário busque por PATH e dê dois cliques
#    - Edite a variável "Path" clicando em NOVO
#    - Adicione o caminho exato em que extraiu "ffmpeg" na sua unidade C, como ex.: C:\ffmpeg\bin
# 5️⃣ Teste no Prompt de Comando:
#    - Execute: ffmpeg -version
#    - Se aparecer informações do FFmpeg, está pronto para uso.

# ========================================================
# PASSO 5: CRIAR E ATIVAR O AMBIENTE CONDA NO RSTUDIO
# ========================================================

# descobrir o Miniconda e apontar para o conda.bat
user <- Sys.getenv("USERPROFILE")
miniconda_base <- file.path(user, "AppData/Local/miniconda3")
conda_bat <- file.path(miniconda_base, "condabin", "conda.bat")
if (!file.exists(conda_bat)) {
  stop("Conda não encontrado em: ", conda_bat,
       "\nInstale Miniconda (recomendado) ou ajuste 'miniconda_base'.")
}
Sys.setenv(RETICULATE_CONDA = conda_bat)

# garanta que o reticulate enxerga o conda
conda_bin <- reticulate::conda_binary()

# aceitar os termos de uso do Anaconda/Miniconda para os três canais defaults (apenas 1 vez)
system2(conda_bin, c("tos","accept","--override-channels","--channel","https://repo.anaconda.com/pkgs/main"))
system2(conda_bin, c("tos","accept","--override-channels","--channel","https://repo.anaconda.com/pkgs/r"))
system2(conda_bin, c("tos","accept","--override-channels","--channel","https://repo.anaconda.com/pkgs/msys2"))

# criar o ambiente 'whisper_env' com Python 3.10 (se não existir)
envs <- tryCatch(reticulate::conda_list(), error=function(e) data.frame(name=character()))
if (!"whisper_env" %in% envs$name) {
  reticulate::conda_create("whisper_env", python_version = "3.10")
}

# inicializar ESTE ambiente na sessão atual (antes de qualquer import)
use_python(file.path(miniconda_base, "envs", "whisper_env", "python.exe"), required=TRUE)
print(py_config())

# ========================================================
# PASSO 6: INSTALAR O WHISPER E SUAS DEPENDÊNCIAS
# ========================================================
py_install("openai-whisper", pip = TRUE)
py_install("ffmpeg-python", pip = TRUE)  # Instalar suporte ao FFmpeg

cat("\n✅ Instalação concluída! Passe para o próximo script para utilização: ``Whisper_AI_R_transcrever´´. 
    Lembre-se de reiniciar a sessão do RStudio sempre antes de utilizar o Whisper AI para 
    garantir a definição correta dos caminhos usados pelos aplicativos.\n")









