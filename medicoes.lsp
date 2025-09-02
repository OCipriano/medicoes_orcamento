;;; ====================================================
;;; medicoes.lsp - Painel de Medições e Orçamento 
;;; Autor: Osvaldo Cipriano
;;; Versão: 1.0
;;; Funcionalidades
;;; - Medir áreas (polilinhas fechadas / círculos)
;;; - Medir comprimentos (lines / lwpolylines)
;;; - Contar blocos (acumulado por nome)
;;; - Extrair atributos de blocos
;;; - Calcular volume (área * altura)
;;; - Dashboard em modal
;;; - Reset dos acumuladores
;;; Comentários em Português de Portugal
;;; ====================================================

(vl-load-com)  ; garantir VLAX / VLA

;;; ------------------------
;;; Variáveis globais para acumular resultados
;;; ------------------------
(setq *lastButton* nil)        ; botão pressionado no DCL
(setq *accArea*    0.0)        ; área acumulada (m²)
(setq *accLength*  0.0)        ; comprimento acumulado (m)
(setq *accVolume*  0.0)        ; volume acumulado (m³)
(setq *accBlocks*  '())        ; lista de assoc: (nome . quantidade)

;;; ------------------------
;;; Handler de clique nos botões
;;; ------------------------
(defun DCLHandler (event /)
  ;; Guarda o identificador do botão e fecha o diálogo
  (setq *lastButton* event)
  (done_dialog)
)

;;; ------------------------------
;;; Função de exibição de resultados
;;; ------------------------------
(defun ShowResult (msg / dclPath dcl_id)
  ;; Procurar no Support Path
  (setq dclPath (findfile "medicoes.dcl"))
  (if (and dclPath (setq dcl_id (load_dialog dclPath)))
    (progn
      (if (new_dialog "resultados_dialog" dcl_id)
        (progn
          (set_tile "txtOut" msg)
          (action_tile "btnOk" "(done_dialog)")
          (start_dialog)
        )
        (prompt "\n[Erro] Não foi possível abrir 'resultados_dialog'.")
      )
      (unload_dialog dcl_id)
    )
    (prompt "\n[Erro] Ficheiro DCL 'medicoes.dcl' não encontrado no Support Path.")
  )
  (princ)
)

;;; ------------------------------
;;; Função principal do painel
;;; ------------------------------
(defun OpenPanel (/ dclPath dcl_id)
  ;; Procurar no Support Path
  (setq dclPath (findfile "medicoes.dcl"))
  (if (not dclPath)
      (prompt "\n[Erro] Ficheiro medicoes.dcl não encontrado no Support Path.")
    (progn
      ;; Carrega o DCL
      (setq dcl_id (load_dialog dclPath))
      (if (not dcl_id)
          (prompt "\n[Erro] Não foi possível carregar o DCL.")
        (progn
          ;; Abre o diálogo principal
          (if (not (new_dialog "medicoes_panel" dcl_id))
              (prompt "\n[Erro] Não foi possível abrir 'medicoes_panel'.")
            (progn
              ;; Liga explicitamente cada botão à função DCLHandler
              (action_tile "btnArea"         "(DCLHandler \"btnArea\")")
              (action_tile "btnLength"       "(DCLHandler \"btnLength\")")
              (action_tile "btnCountBlocks"  "(DCLHandler \"btnCountBlocks\")")
              (action_tile "btnExtractAttrs" "(DCLHandler \"btnExtractAttrs\")")
              (action_tile "btnCalcVolume"   "(DCLHandler \"btnCalcVolume\")")
              (action_tile "btnDashboard"    "(DCLHandler \"btnDashboard\")")
              (action_tile "btnReset"        "(DCLHandler \"btnReset\")")
              (action_tile "btnClose"        "(DCLHandler \"btnClose\")")
              ;; Inicia o diálogo
              (start_dialog)
              (unload_dialog dcl_id)
              ;; Executa ação com base no botão pressionado
              (cond
                ((= *lastButton* "btnArea")        (c:measureAreas))
                ((= *lastButton* "btnLength")      (c:measureLength))
                ((= *lastButton* "btnCountBlocks") (c:countBlocks))
                ((= *lastButton* "btnExtractAttrs")(c:extractAttrs))
                ((= *lastButton* "btnCalcVolume")  (c:calcVolume))
                ((= *lastButton* "btnDashboard")   (c:dashboard))
                ((= *lastButton* "btnReset")       (c:resetMedicoes))
                ((= *lastButton* "btnClose")       (prompt "\nPainel fechado."))
                (T (prompt "\nNenhuma ação seleccionada."))
              )
              ;; Limpa variável de último botão
              (setq *lastButton* nil)
            )
          )
        )
      )
    )
  )
  (princ)
)

;;; ------------------------
;;; Funções de medição / utilitários
;;; ------------------------

;;; ------------------------
;;; Medir áreas (polilinhas fechadas e círculos) e acumular
;;; ------------------------
(defun c:measureAreas (/ sel i obj total msg)
  (setq total 0.0)
  (prompt "\nSelecione polilinhas fechadas e/ou círculos: ")
  (setq sel (ssget '((-4 . "<OR") (0 . "LWPOLYLINE") (0 . "CIRCLE") (-4 . "OR>"))))
  (if sel
    (progn
      (setq i 0)
      (while (< i (sslength sel))
        (setq obj (vlax-ename->vla-object (ssname sel i)))
        (cond
          ((and (eq (vla-get-ObjectName obj) "AcDbPolyline")
                (=  (vla-get-Closed obj) :vlax-true))
           (setq total (+ total (vla-get-Area obj))))
          ((eq (vla-get-ObjectName obj) "AcDbCircle")
           (setq total (+ total (vla-get-Area obj))))
        )
        (setq i (1+ i))
      )
	  ;; atualiza acumulado
      (setq *accArea* (+ *accArea* total))
	  ;; mostra seleção + acumulado
      (setq msg (strcat "Área desta seleção = " (rtos total 2 2) " m²"
                        "\nÁrea acumulada = " (rtos *accArea* 2 2) " m²"))
      (ShowResult msg)
    )
    (ShowResult "Nenhum objeto válido seleccionado.")
  )
  (princ)
)

;;; ------------------------
;;; Medir comprimentos (LINES, LWPOLYLINE) e acumular
;;; ------------------------
(defun c:measureLength (/ sel i obj total msg)
  (setq total 0.0)
  (prompt "\nSelecione linhas e/ou polilinhas: ")
  (setq sel (ssget '((-4 . "<OR") (0 . "LINE") (0 . "LWPOLYLINE") (-4 . "OR>"))))
  (if sel
    (progn
      (setq i 0)
      (while (< i (sslength sel))
        (setq obj (vlax-ename->vla-object (ssname sel i)))
        (if (vlax-property-available-p obj 'Length)
          (setq total (+ total (vla-get-Length obj)))
        )
        (setq i (1+ i))
      )
	  ;; atualiza acumulado
      (setq *accLength* (+ *accLength* total))
	  ;; mostra seleção + acumulado
      (setq msg (strcat "Comprimento desta seleção = " (rtos total 2 2) " m"
                        "\nComprimento acumulado = " (rtos *accLength* 2 2) " m"))
      (ShowResult msg)
    )
    (ShowResult "Nenhuma entidade seleccionada.")
  )
  (princ)
)

;;; ------------------------
;;; Contar blocos por nome (acumulado)
;;; ------------------------
(defun c:countBlocks (/ sel i obj bname pair msg)
  (prompt "\nSelecione blocos (INSERT): ")
  (setq sel (ssget '((0 . "INSERT"))))
  (if sel
    (progn
      (setq i 0)
      (while (< i (sslength sel))
        (setq obj (vlax-ename->vla-object (ssname sel i)))
        (setq bname (cond
                      ((and (vlax-property-available-p obj 'EffectiveName)
                            (not (equal "" (vla-get-EffectiveName obj))))
                       (vla-get-EffectiveName obj))
                      ((vlax-property-available-p obj 'Name) (vla-get-Name obj))
                      (T "UnknownBlock")))
        (setq pair (assoc bname *accBlocks*))
        (if pair
          (setq *accBlocks* (subst (cons bname (1+ (cdr pair))) pair *accBlocks*))
          (setq *accBlocks* (cons (cons bname 1) *accBlocks*))
        )
        (setq i (1+ i))
      )
      ; gerar mensagem com contagem acumulada
      (setq msg "Contagem acumulada de blocos:\n")
      (foreach x *accBlocks*
        (setq msg (strcat msg (car x) " — " (itoa (cdr x)) " unidade(s)\n"))
      )
      (ShowResult msg)
    )
    (ShowResult "Nenhum bloco seleccionado.")
  )
  (princ)
)

;;; ------------------------
;;; Extrair atributos de blocos seleccionados
;;; ------------------------
(defun c:extractAttrs (/ sel i obj lst att msg)
  (prompt "\nSelecione blocos (INSERT) com atributos: ")
  (setq sel (ssget '((0 . "INSERT"))))
  (if sel
    (progn
      (setq i 0 lst '())
      (while (< i (sslength sel))
        (setq obj (vlax-ename->vla-object (ssname sel i)))
        (if (and (vlax-property-available-p obj 'HasAttributes)
                 (= :vlax-true (vla-get-HasAttributes obj)))
          (foreach att (vlax-invoke obj 'GetAttributes)
            (setq lst (cons (cons (vla-get-TagString att) (vla-get-TextString att)) lst))
          )
        )
        (setq i (1+ i))
      )
      (setq msg "")
      (foreach x (reverse lst)
        (setq msg (strcat msg (car x) " = " (cdr x) "\n"))
      )
      (if (= msg "") (setq msg "Nenhum atributo encontrado."))
      (ShowResult msg)
    )
    (ShowResult "Nenhum bloco seleccionado.")
  )
  (princ)
)

;;; ------------------------
;;; Calcular volume (área * altura) e acumular
;;; ------------------------
(defun c:calcVolume (/ sel i obj h total msg)
  (setq total 0.0)
  (prompt "\nSelecione polilinhas fechadas e/ou círculos: ")
  (setq sel (ssget '((-4 . "<OR") (0 . "LWPOLYLINE") (0 . "CIRCLE") (-4 . "OR>"))))
  (if sel
    (progn
      (setq h (getreal "\nDigite a altura (m): "))
      (if (not h)
        (ShowResult "Altura não fornecida. Operação cancelada.")
        (progn
          (setq i 0)
          (while (< i (sslength sel))
            (setq obj (vlax-ename->vla-object (ssname sel i)))
            (cond
              ((and (eq (vla-get-ObjectName obj) "AcDbPolyline")
                    (=  (vla-get-Closed obj) :vlax-true))
               (setq total (+ total (* (vla-get-Area obj) h))))
              ((eq (vla-get-ObjectName obj) "AcDbCircle")
               (setq total (+ total (* (vla-get-Area obj) h))))
            )
            (setq i (1+ i))
          )
		  ;; atualiza acumulado
          (setq *accVolume* (+ *accVolume* total))
		  ;; mostra seleção + acumulado
          (setq msg (strcat "Volume desta seleção = " (rtos total 2 2) " m³"
                            "\nVolume acumulado = " (rtos *accVolume* 2 2) " m³"))
          (ShowResult msg)
        )
      )
    )
    (ShowResult "Nenhum objeto válido seleccionado.")
  )
  (princ)
)

;;; ------------------------
;;; Dashboard (mostra totais acumulados) e Reset
;;; ------------------------
(defun c:dashboard (/ msg)
  (setq msg "=== Dashboard — Resumo Acumulado ===\n")
  (if (and (= *accArea* 0.0) (= *accLength* 0.0)
           (= *accVolume* 0.0) (= *accBlocks* '()))
    (setq msg (strcat msg "Nenhum valor registado ainda.\n"))
    (progn
      (setq msg (strcat msg
        "- Área total acumulada: " (rtos *accArea* 2 2) " m²\n"
        "- Comprimento total acumulado: " (rtos *accLength* 2 2) " m\n"
        "- Volume total acumulado: " (rtos *accVolume* 2 2) " m³\n"
        "- Contagem de blocos:\n"))
      (foreach x *accBlocks*
        (setq msg (strcat msg "  · " (car x) " — " (itoa (cdr x)) " unidade(s)\n")))
    )
  )
  (ShowResult msg)
)

;;; ------------------------
;;; Reset aos acumulados
;;; ------------------------
(defun c:resetMedicoes ()
  (setq *accArea*   0.0
        *accLength* 0.0
        *accVolume* 0.0
        *accBlocks* '())
  (ShowResult "Acumuladores reiniciados.")
)

;;; ------------------------
;;; Comandos públicos
;;; ------------------------
(defun c:MEDICOES () (OpenPanel))
(defun c:OPENPANEL () (OpenPanel))

(princ "\nMódulo medicoes.lsp carregado. Use MEDICOES para abrir o painel.")
(princ)