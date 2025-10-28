# =========================================================
# 02_transcrever.R — Usar Whisper no dia a dia (Windows)
# =========================================================

# ativar as bibliotecas necessárias
library(reticulate)
library(officer)

# 1) Selecionar o Python do whisper_env ANTES de qualquer import no dia de uso do Whisper
user <- Sys.getenv("USERPROFILE")
use_python(file.path(user, "AppData/Local/miniconda3", "envs", "whisper_env", "python.exe"),
           required = TRUE)
print(py_config())

# 2) Garantir ffmpeg no PATH (ajuste o caminho se instalou em outro lugar)
Sys.setenv(PATH = paste(file.path(user, "ffmpeg", "bin"), Sys.getenv("PATH"), sep=";"))

# 3) Importar Whisper e escolher modelo
whisper <- import("whisper")
modelo  <- "small"  # troque para "base" / "medium" / "large" conforme necessidade
model   <- whisper$load_model(modelo)

# 4) Escolher arquivo de áudio definindo o caminho de 'audio_path')

audio_path <- "caminho_do_seu_áudio.formato"

audio_path <- "AtendimentoEducacionalEspecializado.mp3"

# 5) Transcrever (forçando pt; remova 'language' para detecção automática)
start_time <- Sys.time()
res <- model$transcribe(audio_path, # caminho para o áudio definido no passo anterior
                        language="pt", # garante o idioma do áudio (pode ser mudado)
                        task="transcribe", # executa a ação de transcrever (também traduz)
                        verbose=TRUE)
end_time <- Sys.time()

# 6) Salvar saídas no mesmo diretório do áudio
out_txt <- sub("\\.(mp3|wav|m4a|flac)$", "_whisper.txt", audio_path, ignore.case = TRUE)
out_doc <- sub("\\.(mp3|wav|m4a|flac)$", "_whisper.docx", audio_path, ignore.case = TRUE)

# DOCX simples (texto corrido)
doc <- read_docx() |>
  body_add_par("Transcrição (Whisper)", style = "heading 1") |>
  body_add_par(format(Sys.time(), "Data: %d/%m/%Y %H:%M"), style = "Normal") |>
  body_add_par("") |>
  body_add_par(res$text, style = "Normal")
print(doc, target = out_doc)

# (Opcional) DOCX por segmentos com timestamps
doc2 <- read_docx()
for (seg in res$segments) {
  t0 <- sprintf("%02d:%02d:%02.0f", seg$start %/% 3600, (seg$start %% 3600) %/% 60, seg$start %% 60)
  t1 <- sprintf("%02d:%02d:%02.0f", seg$end   %/% 3600, (seg$end   %% 3600) %/% 60, seg$end   %% 60)
  doc2 <- body_add_par(doc2, paste0("[", t0, "–", t1, "] ", seg$text))
}
print(doc2, target = sub("\\.(mp3|wav|m4a|flac)$", "_whisper_segmentado.docx", audio_path, TRUE))

cat("\n✅ Concluído!\n",
    "Tempo total: ", round(difftime(end_time, start_time, units="mins"), 2), "min\n", # tempo total para transcrição
    "TXT: ", out_txt, "\nDOCX: ", out_doc, "\n", sep="")
