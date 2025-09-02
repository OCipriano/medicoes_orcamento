//====================================================
// medicoes.dcl - Painel de Medições e Orçamento
//====================================================

medicoes_panel : dialog {
    label = "Painel de Medições e Orçamento";
    : column {

        // Título Seção Medições
        : text {
            label = "=== Medições ===";
            alignment = center;
            width = 44;
            bold = true;
        }

        : row {
            : button {
                key = "btnArea";
                label = "[A] Medir Áreas";
                width = 22;
                tooltip = "Calcula a área de polilinhas fechadas selecionadas.";
            }
            : button {
                key = "btnLength";
                label = "[L] Medir Comprimentos";
                width = 22;
                tooltip = "Calcula o comprimento de linhas e polilinhas selecionadas.";
            }
        }

        // Título Seção Blocos
        : text {
            label = "=== Blocos e Atributos ===";
            alignment = center;
            width = 44;
            bold = true;
        }

        : row {
            : button {
                key = "btnCountBlocks";
                label = "[B] Contar Blocos";
                width = 22;
                tooltip = "Conta blocos selecionados e mantém contagem acumulada.";
            }
            : button {
                key = "btnExtractAttrs";
                label = "[T] Extrair Atributos";
                width = 22;
                tooltip = "Mostra todos os atributos dos blocos selecionados.";
            }
        }

        // Título Seção Volume e Dashboard
        : text {
            label = "=== Volume e Dashboard ===";
            alignment = center;
            width = 44;
            bold = true;
        }

        : row {
            : button {
                key = "btnCalcVolume";
                label = "[V] Calcular Volume";
                width = 22;
                tooltip = "Calcula volume de polilinhas fechadas com altura fornecida.";
            }
            : button {
                key = "btnDashboard";
                label = "[D] Painel Orçamento";
                width = 22;
                tooltip = "Mostra o dashboard com valores acumulados de medições e blocos.";
            }
        }
		
		// Título Seção Volume e Dashboard
        : text {
            label = "";
            alignment = center;
            width = 44;
            bold = true;
        }

        // Botão Fechar
        : row {
            : button {
                key = "btnReset";
                label = "[R] Reset";
                width = 22;
                tooltip = "Reinicia todos os acumuladores de medições.";
            }
            : button {
                key = "btnClose";
                label = "[X] Fechar";
                width = 22;
                is_default = true;
                is_cancel = true;
                tooltip = "Fecha o painel de medições.";
            }
        }

    }
}

//====================================================
// Dialogo de Resultados
//====================================================
resultados_dialog : dialog {
    label = "Resultados";

    : column {
        : text {
            key = "txtOut";
            value = "";
            width = 56;
            height = 14;   // número de linhas visíveis
            alignment = left;
        }

        : row {
            : button {
                key = "btnOk";
                label = "[OK] Fechar";
                is_default = true;
                is_cancel = true;
            }
        }
    }
}
