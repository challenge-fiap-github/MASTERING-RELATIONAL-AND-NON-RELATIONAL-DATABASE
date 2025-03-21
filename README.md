# 🗄️ OdontoVision - Banco de Dados

--

## 📌 Link  
**MIRO IDEIAS E ORGANIZAÇÃO:** [Clique aqui para acessar o board](https://miro.com/app/board/uXjVLwX7Ul0=/?share_link_id=229877203937)

--

## 👨‍💻 Equipe de Desenvolvimento

| Nome              | RM       |
|-------------------|----------|
| Luis Henrique     | RM552692 |
| Sabrina Café      | RM553568 |
| Matheus Duarte    | RM554199 |

---

## 🧾 Sobre o Projeto

O banco de dados da plataforma **OdontoVision** foi desenvolvido em **Oracle SQL**, com o objetivo de fornecer uma base sólida, segura e escalável para suportar todas as funcionalidades do ecossistema OdontoPrev — incluindo o app mobile, sistema web e back-end.

---

## 🎯 Objetivo

Construir uma estrutura relacional robusta que atenda às necessidades de **consultas odontológicas**, **recompensas**, **gamificação**, **validação de ações**, **auditorias** e **relatórios**, com foco em integridade de dados e performance.

---

## 🧩 Tabelas

- `usuario`
- `endereco_usuario`
- `plano_odontologico`
- `usuario_plano`
- `plano_cobertura`
- `dentista`
- `endereco_clinica`
- `tipo_consulta`
- `status_consulta`
- `consulta`
- `procedimento`
- `consulta_procedimento`
- `plano_procedimento`
- `notificacao`
- `historico_tratamento`
- `sinistro`
- `pontuacao`
- `historico_pontuacao`
- `diagnostico`
- `checklist_diario`
- `recompensa`
- `usuario_recompensa`
- `nivel`
- `usuario_nivel`
- `conquista`
- `usuario_conquista`
- `validacao_checklist`
- `auditoria` *(log de alterações via triggers)*
  
---

## 🔄 Funcionalidades de Banco

### ✅ Criação e Relacionamento de Tabelas

- Tabelas com **chaves primárias e estrangeiras** bem definidas  
- **Relacionamentos muitos-para-muitos** utilizando tabelas intermediárias  
- **Validações de integridade** com `CHECK`, `NOT NULL` e `UNIQUE`

### 🛠️ Procedures e Functions

- Procedures:  
  - `inserir_usuario`  
  - `atualizar_usuario`  
  - `deletar_usuario`

- Funções de validação:  
  - `validar_email`  
  - `validar_cpf`

- Relatórios:  
  - `relatorio_usuario_plano`  
  - `relatorio_pontuacao_usuario`

### 📦 Packages

- **`usuario_pkg`**  
  - Agrupa validações, manipulações e relatórios relacionados ao usuário  
  - Facilita manutenção e reaproveitamento do código

### 🔔 Triggers de Auditoria

- Tabela `auditoria` armazena:
  - Nome da tabela afetada
  - Tipo de operação (INSERT, UPDATE, DELETE)
  - Dados antigos e novos (formato JSON-like)
  - Data e hora da operação

- Triggers implementadas:
  - `trg_auditoria_usuario`
  - `trg_auditoria_consulta`
  - `trg_auditoria_procedimento`

---
