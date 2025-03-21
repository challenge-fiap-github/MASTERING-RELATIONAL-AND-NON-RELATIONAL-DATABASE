/*
ODONTOPREV CHALLENGE - ODONTOVISION
LUIS HENRIQUE RM552692
SABRINA CAFÉ RM553568
MATHEUS DUARTE RM554199
*/

SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- DROP DAS TABELAS
DROP TABLE validacao_checklist CASCADE CONSTRAINTS;
DROP TABLE historico_pontuacao CASCADE CONSTRAINTS;
DROP TABLE usuario_conquista CASCADE CONSTRAINTS;
DROP TABLE conquista CASCADE CONSTRAINTS;
DROP TABLE usuario_nivel CASCADE CONSTRAINTS;
DROP TABLE nivel CASCADE CONSTRAINTS;
DROP TABLE usuario_recompensa CASCADE CONSTRAINTS;
DROP TABLE recompensa CASCADE CONSTRAINTS;
DROP TABLE checklist_diario CASCADE CONSTRAINTS;
DROP TABLE diagnostico CASCADE CONSTRAINTS;
DROP TABLE pontuacao CASCADE CONSTRAINTS;
DROP TABLE sinistro CASCADE CONSTRAINTS;
DROP TABLE historico_tratamento CASCADE CONSTRAINTS;
DROP TABLE notificacao CASCADE CONSTRAINTS;
DROP TABLE consulta_procedimento CASCADE CONSTRAINTS;
DROP TABLE plano_procedimento CASCADE CONSTRAINTS;
DROP TABLE procedimento CASCADE CONSTRAINTS;
DROP TABLE consulta CASCADE CONSTRAINTS;
DROP TABLE status_consulta CASCADE CONSTRAINTS;
DROP TABLE tipo_consulta CASCADE CONSTRAINTS;
DROP TABLE endereco_clinica CASCADE CONSTRAINTS;
DROP TABLE dentista CASCADE CONSTRAINTS;
DROP TABLE plano_cobertura CASCADE CONSTRAINTS;
DROP TABLE plano_odontologico CASCADE CONSTRAINTS;
DROP TABLE endereco_usuario CASCADE CONSTRAINTS;
DROP TABLE usuario CASCADE CONSTRAINTS;

/**********************************************************/

/*CRIAÇÃO DE TABELAS*/

CREATE TABLE usuario (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    senha VARCHAR2(100) NOT NULL,
    data_nascimento DATE,
    cpf VARCHAR2(11) UNIQUE NOT NULL,
    telefone VARCHAR2(15)
);

CREATE TABLE endereco_usuario (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    usuario_id NUMBER NOT NULL,
    logradouro VARCHAR2(150),
    numero VARCHAR2(10),
    cidade VARCHAR2(100),
    estado VARCHAR2(50),
    cep VARCHAR2(10),
    complemento VARCHAR2(100),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

CREATE TABLE plano_odontologico (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    nome_plano VARCHAR2(100) NOT NULL,
    descricao VARCHAR2(255),
    preco NUMBER(10, 2),
    validade DATE
);

CREATE TABLE usuario_plano (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    usuario_id NUMBER NOT NULL,
    plano_id NUMBER NOT NULL,
    data_adesao DATE DEFAULT SYSDATE,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    FOREIGN KEY (plano_id) REFERENCES plano_odontologico(id)
);

CREATE TABLE plano_cobertura (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    plano_id NUMBER NOT NULL,
    descricao VARCHAR2(255) NOT NULL,
    FOREIGN KEY (plano_id) REFERENCES plano_odontologico(id)
);

CREATE TABLE dentista (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    cro VARCHAR2(20) UNIQUE NOT NULL,
    especialidade VARCHAR2(100),
    telefone VARCHAR2(15),
    email VARCHAR2(100) UNIQUE NOT NULL
);

CREATE TABLE endereco_clinica (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    dentista_id NUMBER NOT NULL,
    logradouro VARCHAR2(150),
    numero VARCHAR2(10),
    cidade VARCHAR2(100),
    estado VARCHAR2(50),
    cep VARCHAR2(10),
    complemento VARCHAR2(100),
    FOREIGN KEY (dentista_id) REFERENCES dentista(id)
);

CREATE TABLE tipo_consulta (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    descricao VARCHAR2(50) UNIQUE NOT NULL
);

CREATE TABLE status_consulta (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    descricao VARCHAR2(20) UNIQUE NOT NULL
);

CREATE TABLE consulta (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    data_hora TIMESTAMP NOT NULL,
    usuario_id NUMBER NOT NULL,
    dentista_id NUMBER NOT NULL,
    status_id NUMBER NOT NULL,
    tipo_consulta_id NUMBER NOT NULL,
    observacoes VARCHAR2(255),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    FOREIGN KEY (dentista_id) REFERENCES dentista(id),
    FOREIGN KEY (status_id) REFERENCES status_consulta(id),
    FOREIGN KEY (tipo_consulta_id) REFERENCES tipo_consulta(id)
);

CREATE TABLE procedimento (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    nome_procedimento VARCHAR2(100) NOT NULL,
    descricao VARCHAR2(255),
    custo NUMBER(10, 2)
);

CREATE TABLE consulta_procedimento (
    consulta_id NUMBER NOT NULL,
    procedimento_id NUMBER NOT NULL,
    PRIMARY KEY (consulta_id, procedimento_id),
    FOREIGN KEY (consulta_id) REFERENCES consulta(id),
    FOREIGN KEY (procedimento_id) REFERENCES procedimento(id)
);

CREATE TABLE plano_procedimento (
    plano_id NUMBER NOT NULL,
    procedimento_id NUMBER NOT NULL,
    PRIMARY KEY (plano_id, procedimento_id),
    FOREIGN KEY (plano_id) REFERENCES plano_odontologico(id),
    FOREIGN KEY (procedimento_id) REFERENCES procedimento(id)
);


CREATE TABLE notificacao (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    titulo VARCHAR2(100) NOT NULL,
    conteudo VARCHAR2(255) NOT NULL,
    data_envio TIMESTAMP NOT NULL,
    usuario_id NUMBER NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

CREATE TABLE historico_tratamento (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    usuario_id NUMBER NOT NULL,
    procedimento_id NUMBER NOT NULL,
    dentista_id NUMBER NOT NULL,
    data DATE NOT NULL,
    observacoes VARCHAR2(255),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    FOREIGN KEY (procedimento_id) REFERENCES procedimento(id),
    FOREIGN KEY (dentista_id) REFERENCES dentista(id)
);

CREATE TABLE sinistro (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    paciente_id NUMBER,
    procedimento_id NUMBER,
    data_sinistro DATE,
    risco_fraude CHAR(1) CHECK (risco_fraude IN ('S', 'N')),
    descricao_risco VARCHAR2(255),
    FOREIGN KEY (paciente_id) REFERENCES usuario(id),
    FOREIGN KEY (procedimento_id) REFERENCES procedimento(id)
);

CREATE TABLE pontuacao (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    usuario_id NUMBER NOT NULL,
    pontos INTEGER NOT NULL,
    data_registro DATE NOT NULL,
    ciclo_inicial DATE,
    ciclo_final DATE,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

CREATE TABLE historico_pontuacao (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    usuario_id NUMBER NOT NULL,
    data_consulta DATE,
    pontos_ganhos INTEGER,
    pontos_totais INTEGER,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

CREATE TABLE diagnostico (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    consulta_id NUMBER NOT NULL,
    descricao VARCHAR2(255) NOT NULL,
    data DATE NOT NULL,
    FOREIGN KEY (consulta_id) REFERENCES consulta(id)
);


CREATE TABLE checklist_diario (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    usuario_id NUMBER NOT NULL,
    data DATE NOT NULL,
    escovacao CHAR(1) CHECK (escovacao IN ('S', 'N')),
    fio_dental CHAR(1) CHECK (fio_dental IN ('S', 'N')),
    consulta_validacao_id NUMBER,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    FOREIGN KEY (consulta_validacao_id) REFERENCES consulta(id)
);

CREATE TABLE recompensa (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    descricao VARCHAR2(255) NOT NULL,
    pontos_necessarios INTEGER NOT NULL,
    quantidade_disponivel INTEGER,
    data_expiracao DATE
);


CREATE TABLE usuario_recompensa (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    usuario_id NUMBER NOT NULL,
    recompensa_id NUMBER NOT NULL,
    data_resgate DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    FOREIGN KEY (recompensa_id) REFERENCES recompensa(id)
);

CREATE TABLE nivel (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    descricao VARCHAR2(100) NOT NULL,
    pontos_necessarios INTEGER NOT NULL
);

CREATE TABLE usuario_nivel (
    usuario_id NUMBER NOT NULL,
    nivel_id NUMBER NOT NULL,
    pontos_atuais INTEGER NOT NULL,
    data_ultima_atualizacao DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (usuario_id, nivel_id),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    FOREIGN KEY (nivel_id) REFERENCES nivel(id)
);


CREATE TABLE conquista (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    descricao VARCHAR2(255) NOT NULL,
    pontos_bonus INTEGER,
    data_expiracao DATE
);

CREATE TABLE usuario_conquista (
    usuario_id NUMBER NOT NULL,
    conquista_id NUMBER NOT NULL,
    data_obtencao DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (usuario_id, conquista_id),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    FOREIGN KEY (conquista_id) REFERENCES conquista(id)
);

CREATE TABLE validacao_checklist (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    usuario_id NUMBER NOT NULL,
    consulta_id NUMBER NOT NULL,
    data_validacao DATE DEFAULT CURRENT_DATE,
    status_validacao CHAR(1) CHECK (status_validacao IN ('S', 'N')),
    pontos_bonus INTEGER,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    FOREIGN KEY (consulta_id) REFERENCES consulta(id)
);

/******************************************************/
/*VISUALIZAÇÃO DAS TABELAS*/

SELECT * FROM validacao_checklist;
SELECT * FROM historico_pontuacao;
SELECT * FROM usuario_conquista;
SELECT * FROM conquista;
SELECT * FROM usuario_nivel;
SELECT * FROM nivel;
SELECT * FROM usuario_recompensa;
SELECT * FROM recompensa;
SELECT * FROM checklist_diario;
SELECT * FROM diagnostico;
SELECT * FROM pontuacao;
SELECT * FROM sinistro;
SELECT * FROM historico_tratamento;
SELECT * FROM notificacao;
SELECT * FROM consulta_procedimento;
SELECT * FROM plano_procedimento;
SELECT * FROM procedimento;
SELECT * FROM consulta;
SELECT * FROM status_consulta;
SELECT * FROM tipo_consulta;
SELECT * FROM endereco_clinica;
SELECT * FROM dentista;
SELECT * FROM plano_cobertura;
SELECT * FROM plano_odontologico;
SELECT * FROM endereco_usuario;
SELECT * FROM usuario;


/******************************************************/
/* -- SPRINT 2 -- */

-- FUNÇÃO QUE VALIDA ENTRADA DE DADOS
CREATE OR REPLACE FUNCTION validar_email(email_input VARCHAR2) RETURN BOOLEAN IS
BEGIN
    RETURN REGEXP_LIKE(email_input, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
END;
/

CREATE OR REPLACE FUNCTION validar_cpf(cpf_input VARCHAR2) RETURN BOOLEAN IS
BEGIN
    RETURN LENGTH(cpf_input) = 11 AND REGEXP_LIKE(cpf_input, '^\d+$');
END;
/
'


-- PROCEDURE PARA INSERIR USUÁRIO
CREATE OR REPLACE PROCEDURE inserir_usuario(
    p_nome VARCHAR2, 
    p_email VARCHAR2, 
    p_senha VARCHAR2, 
    p_data_nascimento DATE, 
    p_cpf VARCHAR2, 
    p_telefone VARCHAR2,
    p_logradouro VARCHAR2, 
    p_numero VARCHAR2, 
    p_cidade VARCHAR2, 
    p_estado VARCHAR2, 
    p_cep VARCHAR2, 
    p_complemento VARCHAR2
) IS
    v_usuario_id NUMBER;
BEGIN
   /** VALIDAR E INSERIR USUÁRIO */
    IF validar_email(p_email) AND validar_cpf(p_cpf) THEN
        INSERT INTO usuario (nome, email, senha, data_nascimento, cpf, telefone)
        VALUES (p_nome, p_email, p_senha, p_data_nascimento, p_cpf, p_telefone)
        RETURNING id INTO v_usuario_id;
        
        /* INSERIR ENDEREÇO ASSOCIADO AO USUÁRIO*/
        INSERT INTO endereco_usuario (usuario_id, logradouro, numero, cidade, estado, cep, complemento)
        VALUES (v_usuario_id, p_logradouro, p_numero, p_cidade, p_estado, p_cep, p_complemento);
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Dados inválidos: email ou CPF não estão no formato correto.');
    END IF;
END;

--ATUALIZAR O USUÁRIO
CREATE OR REPLACE PROCEDURE atualizar_usuario(
    p_id NUMBER,
    p_nome VARCHAR2, 
    p_email VARCHAR2, 
    p_senha VARCHAR2, 
    p_data_nascimento DATE, 
    p_cpf VARCHAR2, 
    p_telefone VARCHAR2,
    p_logradouro VARCHAR2, 
    p_numero VARCHAR2, 
    p_cidade VARCHAR2, 
    p_estado VARCHAR2, 
    p_cep VARCHAR2, 
    p_complemento VARCHAR2
) IS
BEGIN
    --VALIDAÇÃO DE E-MAIL E CPF
    IF validar_email(p_email) AND validar_cpf(p_cpf) THEN
        -- ATUALIZA OS DADOS
        UPDATE usuario
        SET nome = p_nome, email = p_email, senha = p_senha,
            data_nascimento = p_data_nascimento, cpf = p_cpf, telefone = p_telefone
        WHERE id = p_id;
        
        --ATUALIZA O ENDEREÇO
        UPDATE endereco_usuario
        SET logradouro = p_logradouro, numero = p_numero, cidade = p_cidade, 
            estado = p_estado, cep = p_cep, complemento = p_complemento
        WHERE usuario_id = p_id;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Dados inválidos: email ou CPF não estão no formato correto.');
    END IF;
END;

--PROCEDURE PARA DELETAR
CREATE OR REPLACE PROCEDURE deletar_usuario(p_id NUMBER) IS
BEGIN
    DELETE FROM usuario WHERE id = p_id;
END;
/



/*********************************************/

/* FUNÇÃO COM CURSOR E JOINS - RELATÓRIO FORMATADO */

--FUNÇÃO PARA RELATÓRIO DE USUÁRIO E PLANO ODONTOLOGICO
CREATE OR REPLACE FUNCTION relatorio_usuario_plano 
RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
    SELECT 
        u.id AS usuario_id, 
        u.nome AS usuario_nome, 
        u.email AS usuario_email, 
        p.nome_plano AS plano_nome, 
        p.preco AS plano_preco
    FROM usuario u
    JOIN usuario_plano up ON u.id = up.usuario_id
    JOIN plano_odontologico p ON up.plano_id = p.id;
    
    RETURN v_cursor;
END;
/


--FUNÇÃO PARA REGRA DE NEGOCIO
CREATE OR REPLACE FUNCTION relatorio_usuario_plano RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
    SELECT up.id AS usuario_plano_id,
           up.usuario_id,
           up.plano_id,
           up.data_adesao
    FROM usuario_plano up;
    
    RETURN v_cursor;
END;
/

--FUNÇÃO PARA RELATÓRIO DE PONTUAÇÃO
CREATE OR REPLACE FUNCTION relatorio_pontuacao_usuario RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
    SELECT u.nome AS usuario_nome, 
           COALESCE(SUM(p.pontos), 0) AS total_pontos
    FROM usuario u
    LEFT JOIN pontuacao p ON u.id = p.usuario_id
    GROUP BY u.nome
    ORDER BY total_pontos DESC;
    
    RETURN v_cursor;
END;
/

/**/
VAR v_cursor REFCURSOR;
EXEC :v_cursor := relatorio_usuario_plano;
PRINT v_cursor;
/**/


/*******************/
/* -- SPRINT 3 -- */

/*CRIAÇÃO DE PACKAGES*/

--ESPECIFICAÇÃO DA PACKAGE
CREATE OR REPLACE PACKAGE usuario_pkg AS
    --VALIDAÇÃO
    FUNCTION validar_email(email_input VARCHAR2) RETURN BOOLEAN;
    FUNCTION validar_cpf(cpf_input VARCHAR2) RETURN BOOLEAN;
    
    --PROCEDURE PARA MANIPULAÇÃO DE USER
    PROCEDURE inserir_usuario(
        p_nome VARCHAR2, 
        p_email VARCHAR2, 
        p_senha VARCHAR2, 
        p_data_nascimento DATE, 
        p_cpf VARCHAR2, 
        p_telefone VARCHAR2,
        p_logradouro VARCHAR2, 
        p_numero VARCHAR2, 
        p_cidade VARCHAR2, 
        p_estado VARCHAR2, 
        p_cep VARCHAR2, 
        p_complemento VARCHAR2
    );
    
    PROCEDURE atualizar_usuario(
        p_id NUMBER,
        p_nome VARCHAR2, 
        p_email VARCHAR2, 
        p_senha VARCHAR2, 
        p_data_nascimento DATE, 
        p_cpf VARCHAR2, 
        p_telefone VARCHAR2,
        p_logradouro VARCHAR2, 
        p_numero VARCHAR2, 
        p_cidade VARCHAR2, 
        p_estado VARCHAR2, 
        p_cep VARCHAR2, 
        p_complemento VARCHAR2
    );
    
    PROCEDURE deletar_usuario(p_id NUMBER);
    
    --RELATÓRIO
    FUNCTION relatorio_usuario_plano RETURN SYS_REFCURSOR;
    FUNCTION relatorio_pontuacao_usuario RETURN SYS_REFCURSOR;
END usuario_pkg;
/



--PACKAGE
CREATE OR REPLACE PACKAGE BODY usuario_pkg AS

    --IMPLEMENTAÇÃO DE VALIDAÇÃO POR E-MAIL
    FUNCTION validar_email(email_input VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN REGEXP_LIKE(email_input, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
    END;

    --CPF
    FUNCTION validar_cpf(cpf_input VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN LENGTH(cpf_input) = 11 AND REGEXP_LIKE(cpf_input, '^\d+$');
    END;

    --USUARIO
    PROCEDURE inserir_usuario(
        p_nome VARCHAR2, 
        p_email VARCHAR2, 
        p_senha VARCHAR2, 
        p_data_nascimento DATE, 
        p_cpf VARCHAR2, 
        p_telefone VARCHAR2,
        p_logradouro VARCHAR2, 
        p_numero VARCHAR2, 
        p_cidade VARCHAR2, 
        p_estado VARCHAR2, 
        p_cep VARCHAR2, 
        p_complemento VARCHAR2
    ) IS
        v_usuario_id NUMBER;
    BEGIN
        IF validar_email(p_email) AND validar_cpf(p_cpf) THEN
            INSERT INTO usuario (nome, email, senha, data_nascimento, cpf, telefone)
            VALUES (p_nome, p_email, p_senha, p_data_nascimento, p_cpf, p_telefone)
            RETURNING id INTO v_usuario_id;
            
            INSERT INTO endereco_usuario (usuario_id, logradouro, numero, cidade, estado, cep, complemento)
            VALUES (v_usuario_id, p_logradouro, p_numero, p_cidade, p_estado, p_cep, p_complemento);
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'Dados inválidos: email ou CPF não estão no formato correto.');
        END IF;
    END;

    --ATUALIZAÇÃO DE USUÁRIO
    PROCEDURE atualizar_usuario(
        p_id NUMBER,
        p_nome VARCHAR2, 
        p_email VARCHAR2, 
        p_senha VARCHAR2, 
        p_data_nascimento DATE, 
        p_cpf VARCHAR2, 
        p_telefone VARCHAR2,
        p_logradouro VARCHAR2, 
        p_numero VARCHAR2, 
        p_cidade VARCHAR2, 
        p_estado VARCHAR2, 
        p_cep VARCHAR2, 
        p_complemento VARCHAR2
    ) IS
    BEGIN
        IF validar_email(p_email) AND validar_cpf(p_cpf) THEN
            UPDATE usuario
            SET nome = p_nome, email = p_email, senha = p_senha,
                data_nascimento = p_data_nascimento, cpf = p_cpf, telefone = p_telefone
            WHERE id = p_id;
            
            UPDATE endereco_usuario
            SET logradouro = p_logradouro, numero = p_numero, cidade = p_cidade, 
                estado = p_estado, cep = p_cep, complemento = p_complemento
            WHERE usuario_id = p_id;
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'Dados inválidos: email ou CPF não estão no formato correto.');
        END IF;
    END;

    --DELETAR USUÁRIO
    PROCEDURE deletar_usuario(p_id NUMBER) IS
    BEGIN
        DELETE FROM usuario WHERE id = p_id;
    END;

    --USUÁRIO E PLANO ODONTOLOGICO
    FUNCTION relatorio_usuario_plano RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
        SELECT 
            u.id AS usuario_id, 
            u.nome AS usuario_nome, 
            u.email AS usuario_email, 
            p.nome_plano AS plano_nome, 
            p.preco AS plano_preco
        FROM usuario u
        JOIN usuario_plano up ON u.id = up.usuario_id
        JOIN plano_odontologico p ON up.plano_id = p.id;
        
        RETURN v_cursor;
    END;

    --RELATÓRIO DE PONTUAÇÃO DE USUÁRIO
    FUNCTION relatorio_pontuacao_usuario RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
        SELECT u.nome AS usuario_nome, 
               COALESCE(SUM(p.pontos), 0) AS total_pontos
        FROM usuario u
        LEFT JOIN pontuacao p ON u.id = p.usuario_id
        GROUP BY u.nome
        ORDER BY total_pontos DESC;
        
        RETURN v_cursor;
    END;

END usuario_pkg;
/

BEGIN
    usuario_pkg.inserir_usuario('João', 'joao@email.com', 'senha123', TO_DATE('1990-05-10', 'YYYY-MM-DD'),
                                '56489526405', '11999999999', 'Rua A', '100', 'São Paulo', 'SP', '01010101', 'Apto 2');
END;
/

select * from usuario;

/************************************************/

 --CRIAÇÃO DA TRIGGER PARA AUDITORIAS
CREATE TABLE auditoria (
    id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    tabela_afetada VARCHAR2(50) NOT NULL,
    tipo_operacao VARCHAR2(10) NOT NULL,
    usuario_id NUMBER,
    data_operacao TIMESTAMP DEFAULT SYSTIMESTAMP,
    valores_antigos CLOB,
    valores_novos CLOB
);





--TRIGGER PARA USUÁRIO

CREATE OR REPLACE TRIGGER trg_auditoria_usuario
AFTER INSERT OR UPDATE OR DELETE
ON usuario
FOR EACH ROW
DECLARE
    v_valores_antigos CLOB;
    v_valores_novos CLOB;
    v_tipo_operacao VARCHAR2(10);
BEGIN
    -- Determina o tipo de operação
    IF INSERTING THEN
        v_tipo_operacao := 'INSERT';
        v_valores_novos := '{ "id": ' || :NEW.id || 
                           ', "nome": "' || :NEW.nome || 
                           '", "email": "' || :NEW.email || 
                           '", "cpf": "' || :NEW.cpf || 
                           '", "telefone": "' || :NEW.telefone || '" }';
    ELSIF UPDATING THEN
        v_tipo_operacao := 'UPDATE';
        v_valores_antigos := '{ "id": ' || :OLD.id || 
                             ', "nome": "' || :OLD.nome || 
                             '", "email": "' || :OLD.email || 
                             '", "cpf": "' || :OLD.cpf || 
                             '", "telefone": "' || :OLD.telefone || '" }';
                             
        v_valores_novos := '{ "id": ' || :NEW.id || 
                           ', "nome": "' || :NEW.nome || 
                           '", "email": "' || :NEW.email || 
                           '", "cpf": "' || :NEW.cpf || 
                           '", "telefone": "' || :NEW.telefone || '" }';
    ELSIF DELETING THEN
        v_tipo_operacao := 'DELETE';
        v_valores_antigos := '{ "id": ' || :OLD.id || 
                             ', "nome": "' || :OLD.nome || 
                             '", "email": "' || :OLD.email || 
                             '", "cpf": "' || :OLD.cpf || 
                             '", "telefone": "' || :OLD.telefone || '" }';
    END IF;

    --INSERE O REGISTRO NA TABELA
    INSERT INTO auditoria (tabela_afetada, tipo_operacao, usuario_id, valores_antigos, valores_novos)
    VALUES ('usuario', v_tipo_operacao, :OLD.id, v_valores_antigos, v_valores_novos);
END;
/





-- TRIGGER PARA CONSULTA
CREATE OR REPLACE TRIGGER trg_auditoria_consulta
AFTER INSERT OR UPDATE OR DELETE
ON consulta
FOR EACH ROW
DECLARE
    v_valores_antigos CLOB;
    v_valores_novos CLOB;
    v_tipo_operacao VARCHAR2(10);
BEGIN
    --DETERMINA O TIPO DE OPERAÇÃO
    IF INSERTING THEN
        v_tipo_operacao := 'INSERT';
        v_valores_novos := '{ "id": ' || :NEW.id || 
                           ', "data_hora": "' || TO_CHAR(:NEW.data_hora, 'YYYY-MM-DD HH24:MI:SS') || 
                           '", "usuario_id": ' || :NEW.usuario_id || 
                           ', "dentista_id": ' || :NEW.dentista_id || ' }';
    ELSIF UPDATING THEN
        v_tipo_operacao := 'UPDATE';
        v_valores_antigos := '{ "id": ' || :OLD.id || 
                             ', "data_hora": "' || TO_CHAR(:OLD.data_hora, 'YYYY-MM-DD HH24:MI:SS') || 
                             '", "usuario_id": ' || :OLD.usuario_id || 
                             ', "dentista_id": ' || :OLD.dentista_id || ' }';
        v_valores_novos := '{ "id": ' || :NEW.id || 
                           ', "data_hora": "' || TO_CHAR(:NEW.data_hora, 'YYYY-MM-DD HH24:MI:SS') || 
                           '", "usuario_id": ' || :NEW.usuario_id || 
                           ', "dentista_id": ' || :NEW.dentista_id || ' }';
    ELSIF DELETING THEN
        v_tipo_operacao := 'DELETE';
        v_valores_antigos := '{ "id": ' || :OLD.id || 
                             ', "data_hora": "' || TO_CHAR(:OLD.data_hora, 'YYYY-MM-DD HH24:MI:SS') || 
                             '", "usuario_id": ' || :OLD.usuario_id || 
                             ', "dentista_id": ' || :OLD.dentista_id || ' }';
    END IF;

    -- INSERE O REGISTRO NA TABELA
    INSERT INTO auditoria (tabela_afetada, tipo_operacao, usuario_id, valores_antigos, valores_novos)
    VALUES ('consulta', v_tipo_operacao, :OLD.usuario_id, v_valores_antigos, v_valores_novos);
END;
/





--TRIGGER PARA PROCEDIMENTO
CREATE OR REPLACE TRIGGER trg_auditoria_procedimento
AFTER INSERT OR UPDATE OR DELETE
ON procedimento
FOR EACH ROW
DECLARE
    v_valores_antigos CLOB;
    v_valores_novos CLOB;
    v_tipo_operacao VARCHAR2(10);
BEGIN
    --DETERMINA O TIPO DE OPERAÇÃO
    IF INSERTING THEN
        v_tipo_operacao := 'INSERT';
        v_valores_novos := '{ "id": ' || :NEW.id || 
                           ', "nome_procedimento": "' || :NEW.nome_procedimento || 
                           '", "custo": ' || :NEW.custo || ' }';
    ELSIF UPDATING THEN
        v_tipo_operacao := 'UPDATE';
        v_valores_antigos := '{ "id": ' || :OLD.id || 
                             ', "nome_procedimento": "' || :OLD.nome_procedimento || 
                             '", "custo": ' || :OLD.custo || ' }';
        v_valores_novos := '{ "id": ' || :NEW.id || 
                           ', "nome_procedimento": "' || :NEW.nome_procedimento || 
                           '", "custo": ' || :NEW.custo || ' }';
    ELSIF DELETING THEN
        v_tipo_operacao := 'DELETE';
        v_valores_antigos := '{ "id": ' || :OLD.id || 
                             ', "nome_procedimento": "' || :OLD.nome_procedimento || 
                             '", "custo": ' || :OLD.custo || ' }';
    END IF;

    -- INSERÇÃO DO REGISTRO NA TABELA AUDITORIA
    INSERT INTO auditoria (tabela_afetada, tipo_operacao, usuario_id, valores_antigos, valores_novos)
    VALUES ('procedimento', v_tipo_operacao, NULL, v_valores_antigos, v_valores_novos);
END;
/

/*TESTE DAS TRIGGERS*/

--INSERINDO REGISTRO
INSERT INTO usuario (nome, email, senha, data_nascimento, cpf, telefone) 
VALUES ('Teste2', 'teste2@email.com', '123456', TO_DATE('1995-01-01', 'YYYY-MM-DD'), '01010101010', '11987655321');

INSERT INTO consulta (data_hora, usuario_id, dentista_id, status_id, tipo_consulta_id, observacoes)
VALUES (SYSTIMESTAMP, 1, 1, 1, 1, 'Consulta de rotina');

INSERT INTO procedimento (nome_procedimento, descricao, custo) 
VALUES ('Extração de Dente', 'Remoção de dente danificado', 250.00);

SELECT * FROM usuario WHERE email = '';

--ATUALIZANDO UM REGISTRO
UPDATE usuario SET nome = 'Teste Atualizado' WHERE id = 1;
UPDATE consulta SET observacoes = 'Consulta adiada' WHERE id = 1;
UPDATE procedimento SET custo = 300.00 WHERE id = 1;

--DELETANDO UM REGISTRO
DELETE FROM usuario WHERE id = 1;
DELETE FROM consulta WHERE id = 1;
DELETE FROM procedimento WHERE id = 1;


SELECT * FROM auditoria;










