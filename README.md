# Painel de Medições e Orçamento para AutoCAD

- **Versão:** 1.0
- **Linguagem:** AutoLISP / DCL
- **Descrição:** Este módulo fornece um painel interativo no AutoCAD para realizar medições, contagem de blocos, extração de atributos, cálculo de volume e visualização de um dashboard acumulado.

![ScreenShot](https://raw.githubusercontent.com/OCipriano/medicoes_orcamento/refs/heads/main/Screenshot%202025-09-04%20170123.png)

---

## 🚀 Funcionalidades

O painel oferece as seguintes funcionalidades:

- **Medições**
  - [A] Medir Áreas:
    - Calcula a área de polilinhas fechadas ou círculos selecionados. Acumula valores em total acumulado.

  - [L] Medir Comprimentos:
    - Calcula o comprimento de linhas e polilinhas selecionadas. Acumula valores em total acumulado.

- **Blocos e Atributos**
  - [B] Contar Blocos:
    - Conta blocos do tipo INSERT selecionados, mantendo contagem acumulada por nome do bloco.

  - [T] Extrair Atributos:
    - Mostra todos os atributos dos blocos selecionados (Tag e Valor).

- **Volume e Dashboard**
  - [V] Calcular Volume:
    - Calcula o volume de áreas selecionadas multiplicando pela altura fornecida. Acumula total de volume.

  - [D] Painel Orçamento (Dashboard):
    - Mostra todos os valores acumulados (área, comprimento, volume, contagem de blocos) num resumo fácil de ler.

- **Utilitários**
  - [R] Reset:
    - Reinicia todos os acumuladores de medições e contagem de blocos.

  - [X] Fechar:
    - Fecha o painel de medições.

---

## 🛠️ Instalação

1. Copiar os ficheiros para a pasta de suporte do AutoCAD (Support Path):

- `medicoes.lsp`
- `medicoes.dcl`

2. Carregar o módulo no AutoCAD:

   ```lisp
   AUTOLOAD
   carregar "medicoes.lsp"
   ```

3. Abrir o painel de medições:

   ```lisp
   MEDICOES
   ```

ou

   ```lisp
   OPENPANEL
   ```

---

## 📋 Fluxo de Uso

1. **Abrir painel:**
  - O painel principal mostra todas as seções e botões.

2. **Selecionar objetos para medição ou contagem:**
  - Selecionar polilinhas, linhas ou blocos conforme o botão escolhido.

3. **Visualizar resultados:**
  - Cada ação mostra um modal com os resultados e acumulados.

4. **Dashboard:**
  - Exibe resumo de todas as medições e contagens acumuladas.

5. **Reset:**
  - Reinicia todos os acumuladores para começar novo trabalho.

---

## 📁 Estrutura do Código

`medicoes.dcl`

- Define a interface gráfica do painel.
- Contém botões e textos organizados em seções:
  - Medições
  - Blocos e Atributos
  - Volume e Dashboard
  - Reset / Fechar

`medicoes.lsp`

- Funções AutoLISP que realizam todas as operações.
- Principais funções:
  - `c:measureAreas` – Mede áreas e acumula.
  - `c:measureLength` – Mede comprimentos e acumula.
  - `c:countBlocks` – Conta blocos e acumula.
  - `c:extractAttrs` – Extrai atributos de blocos.
  - `c:calcVolume` – Calcula volumes e acumula.
  - `c:dashboard` – Mostra resumo acumulado.
  - `c:resetMedicoes` – Reseta acumuladores.
- **Função principal:** `OpenPanel` abre o painel DCL e chama funções com base no botão pressionado.
- Handlers DCL:
  - `DCLHandler` – Captura clique de botão.
  - `ShowResult` – Mostra resultados em diálogo modal.

---

## ℹ️ Observações

- Todos os comentários e mensagens estão em **Português de Portugal**.
- Suporta seleção múltipla de objetos.
- Mantém valores acumulados até que seja feito **Reset**.
- Funções de medição consideram apenas polilinhas fechadas e círculos.
- Contagem de blocos funciona mesmo com blocos dinâmicos (`EffectiveName`).

---

## 🔧 Requisitos

- AutoCAD versão **2010 ou superior** com suporte a AutoLISP e DCL.
- Sistema operativo **Windows**.
- Permissões para carregar scripts LISP no AutoCAD.

---

## 🧪 Testado em

- AutoCAD 2018, 2020 e 2023 (Windows 10/11).
- Funcionalidades verificadas: medições, contagem de blocos, extração de atributos, cálculo de volumes, dashboard e reset.

---

## 📬 Contribuição

- Contribuições são bem-vindas! Se encontrares bugs ou tiveres sugestões, abre um issue ou faz um pull request.

---

## 📬 Contato

- Desenvolvido por **Cipriano**
- Email: redealfa.password440@passmail.com

---

## 🛡️ Licença

- Este projeto é open-source sob a licença MIT.
