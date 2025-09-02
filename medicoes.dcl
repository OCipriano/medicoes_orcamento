//====================================================
// medicoes.dcl - Painel de Medi��es e Or�amento
//====================================================

medicoes_panel : dialog {
    label = "Painel de Medi��es e Or�amento";
    : column {

        // T�tulo Se��o Medi��es
        : text {
            label = "=== Medi��es ===";
            alignment = center;
            width = 44;
            bold = true;
        }

        : row {
            : button {
                key = "btnArea";
                label = "[A] Medir �reas";
                width = 22;
                tooltip = "Calcula a �rea de polilinhas fechadas selecionadas.";
            }
            : button {
                key = "btnLength";
                label = "[L] Medir Comprimentos";
                width = 22;
                tooltip = "Calcula o comprimento de linhas e polilinhas selecionadas.";
            }
        }

        // T�tulo Se��o Blocos
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
                tooltip = "Conta blocos selecionados e mant�m contagem acumulada.";
            }
            : button {
                key = "btnExtractAttrs";
                label = "[T] Extrair Atributos";
                width = 22;
                tooltip = "Mostra todos os atributos dos blocos selecionados.";
            }
        }

        // T�tulo Se��o Volume e Dashboard
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
                label = "[D] Painel Or�amento";
                width = 22;
                tooltip = "Mostra o dashboard com valores acumulados de medi��es e blocos.";
            }
        }
		
		// T�tulo Se��o Volume e Dashboard
        : text {
            label = "";
            alignment = center;
            width = 44;
            bold = true;
        }

        // Bot�o Fechar
        : row {
            : button {
                key = "btnReset";
                label = "[R] Reset";
                width = 22;
                tooltip = "Reinicia todos os acumuladores de medi��es.";
            }
            : button {
                key = "btnClose";
                label = "[X] Fechar";
                width = 22;
                is_default = true;
                is_cancel = true;
                tooltip = "Fecha o painel de medi��es.";
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
            height = 14;   // n�mero de linhas vis�veis
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
