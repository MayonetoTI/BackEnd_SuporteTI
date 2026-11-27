/* ============================================================
   AV2 - BANCO DE DADOS
   TEMA: SISTEMA DE SUPORTE EM TI
   BANCO: ORACLE DATABASE
   ============================================================ */


/* ============================================================
   1. CRIACAO DAS SEQUENCES
   NEXTVAL sera utilizado para gerar os IDs
   ============================================================ */

CREATE SEQUENCE seq_tecnico
    START WITH 1
    INCREMENT BY 1;

CREATE SEQUENCE seq_cliente
    START WITH 1
    INCREMENT BY 1;

CREATE SEQUENCE seq_tipo_atendimento
    START WITH 1
    INCREMENT BY 1;

CREATE SEQUENCE seq_chamado
    START WITH 1
    INCREMENT BY 1;

CREATE SEQUENCE seq_atendimento
    START WITH 1
    INCREMENT BY 1;


/* ============================================================
   2. CRIACAO DAS ENTIDADES E TABELAS
   ============================================================ */

CREATE TABLE tecnico (
    id_tecnico      NUMBER PRIMARY KEY,
    nome            VARCHAR2(100) NOT NULL,
    especialidade  VARCHAR2(100),
    telefone        VARCHAR2(20)
);

CREATE TABLE cliente (
    id_cliente  NUMBER PRIMARY KEY,
    nome        VARCHAR2(100) NOT NULL,
    setor       VARCHAR2(50),
    telefone    VARCHAR2(20)
);

CREATE TABLE tipo_atendimento (
    id_tipo    NUMBER PRIMARY KEY,
    descricao VARCHAR2(50) NOT NULL UNIQUE
);

CREATE TABLE chamado (
    id_chamado          NUMBER PRIMARY KEY,
    id_cliente          NUMBER NOT NULL,
    id_tipo             NUMBER NOT NULL,
    defeito             VARCHAR2(300) NOT NULL,
    configuracao_maquina VARCHAR2(300),
    data_abertura       DATE DEFAULT SYSDATE,
    status_solucao      VARCHAR2(30) DEFAULT 'ABERTO' NOT NULL,

    CONSTRAINT fk_chamado_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente),

    CONSTRAINT fk_chamado_tipo
        FOREIGN KEY (id_tipo)
        REFERENCES tipo_atendimento(id_tipo),

    CONSTRAINT ck_status_chamado
        CHECK (
            status_solucao IN (
                'ABERTO',
                'EM ANDAMENTO',
                'AGUARDANDO PECA',
                'CONCLUIDO',
                'CANCELADO'
            )
        )
);

CREATE TABLE atendimento (
    id_atendimento  NUMBER PRIMARY KEY,
    id_chamado      NUMBER NOT NULL,
    id_tecnico      NUMBER NOT NULL,
    data_atendimento DATE DEFAULT SYSDATE,
    procedimento    VARCHAR2(500) NOT NULL,
    conclusao_entrega VARCHAR2(500),
    data_entrega    DATE,

    CONSTRAINT fk_atendimento_chamado
        FOREIGN KEY (id_chamado)
        REFERENCES chamado(id_chamado),

    CONSTRAINT fk_atendimento_tecnico
        FOREIGN KEY (id_tecnico)
        REFERENCES tecnico(id_tecnico)
);


/* ============================================================
   3. INSERCAO DE DADOS - INSERT INTO E NEXTVAL
   ============================================================ */

INSERT INTO tecnico (
    id_tecnico,
    nome,
    especialidade,
    telefone
)
VALUES (
    seq_tecnico.NEXTVAL,
    'Carlos Silva',
    'Computadores e redes',
    '(11) 99999-1111'
);

INSERT INTO tecnico (
    id_tecnico,
    nome,
    especialidade,
    telefone
)
VALUES (
    seq_tecnico.NEXTVAL,
    'Mariana Souza',
    'Impressoras',
    '(11) 99999-2222'
);

INSERT INTO cliente (
    id_cliente,
    nome,
    setor,
    telefone
)
VALUES (
    seq_cliente.NEXTVAL,
    'Ana Oliveira',
    'Financeiro',
    '(11) 98888-1111'
);

INSERT INTO cliente (
    id_cliente,
    nome,
    setor,
    telefone
)
VALUES (
    seq_cliente.NEXTVAL,
    'Pedro Santos',
    'Recursos Humanos',
    '(11) 98888-2222'
);

INSERT INTO tipo_atendimento (id_tipo, descricao)
VALUES (seq_tipo_atendimento.NEXTVAL, 'Computador');

INSERT INTO tipo_atendimento (id_tipo, descricao)
VALUES (seq_tipo_atendimento.NEXTVAL, 'Impressora');

INSERT INTO tipo_atendimento (id_tipo, descricao)
VALUES (seq_tipo_atendimento.NEXTVAL, 'Internet');

INSERT INTO chamado (
    id_chamado,
    id_cliente,
    id_tipo,
    defeito,
    configuracao_maquina,
    data_abertura,
    status_solucao
)
VALUES (
    seq_chamado.NEXTVAL,
    1,
    1,
    'Computador nao liga',
    'Intel Core i5, 8 GB de RAM e Windows 11',
    SYSDATE,
    'ABERTO'
);

INSERT INTO chamado (
    id_chamado,
    id_cliente,
    id_tipo,
    defeito,
    configuracao_maquina,
    data_abertura,
    status_solucao
)
VALUES (
    seq_chamado.NEXTVAL,
    2,
    2,
    'Impressora nao imprime',
    'Impressora laser conectada pela rede',
    SYSDATE,
    'EM ANDAMENTO'
);

INSERT INTO chamado (
    id_chamado,
    id_cliente,
    id_tipo,
    defeito,
    configuracao_maquina,
    data_abertura,
    status_solucao
)
VALUES (
    seq_chamado.NEXTVAL,
    1,
    3,
    'Computador sem acesso a internet',
    'Notebook com Windows 10 e conexao Wi-Fi',
    SYSDATE,
    'ABERTO'
);

INSERT INTO atendimento (
    id_atendimento,
    id_chamado,
    id_tecnico,
    data_atendimento,
    procedimento,
    conclusao_entrega,
    data_entrega
)
VALUES (
    seq_atendimento.NEXTVAL,
    1,
    1,
    SYSDATE,
    'Teste da fonte e limpeza dos componentes',
    NULL,
    NULL
);

INSERT INTO atendimento (
    id_atendimento,
    id_chamado,
    id_tecnico,
    data_atendimento,
    procedimento,
    conclusao_entrega,
    data_entrega
)
VALUES (
    seq_atendimento.NEXTVAL,
    2,
    2,
    SYSDATE,
    'Reinstalacao do driver da impressora',
    'Impressora configurada, testada e liberada para uso',
    SYSDATE
);

COMMIT;


/* ============================================================
   4. ATUALIZACAO DE DADOS - UPDATE
   ============================================================ */

UPDATE chamado
SET status_solucao = 'CONCLUIDO'
WHERE id_chamado = 1;

UPDATE atendimento
SET conclusao_entrega = 'Fonte substituida e computador testado',
    data_entrega = SYSDATE
WHERE id_atendimento = 1;

COMMIT;


/* ============================================================
   5. EXCLUSAO DE DADOS - DELETE
   Exclui somente um chamado sem atendimentos relacionados
   ============================================================ */

DELETE FROM chamado
WHERE id_chamado = 3
  AND status_solucao = 'ABERTO';

COMMIT;


/* ============================================================
   6. CONSULTA SIMPLES - SELECT
   ============================================================ */

SELECT *
FROM chamado
ORDER BY data_abertura;


/* ============================================================
   7. FILTRO COM WHERE E AND
   ============================================================ */

SELECT
    id_chamado,
    defeito,
    status_solucao
FROM chamado
WHERE status_solucao = 'CONCLUIDO'
  AND id_tipo = 1;


/* ============================================================
   8. FILTRO COM IN
   ============================================================ */

SELECT
    id_chamado,
    defeito,
    status_solucao
FROM chamado
WHERE status_solucao IN (
    'ABERTO',
    'EM ANDAMENTO',
    'AGUARDANDO PECA'
);


/* ============================================================
   9. VERIFICACAO COM IS NULL
   Lista atendimentos ainda sem conclusao
   ============================================================ */

SELECT
    id_atendimento,
    id_chamado,
    procedimento
FROM atendimento
WHERE conclusao_entrega IS NULL;


/* ============================================================
   10. RELACIONAMENTO ENTRE TABELAS COM JOIN
   ============================================================ */

SELECT
    c.id_chamado,
    cl.nome AS cliente,
    cl.setor,
    ta.descricao AS tipo_atendimento,
    c.defeito,
    c.configuracao_maquina,
    c.status_solucao,
    t.nome AS tecnico,
    a.procedimento,
    a.conclusao_entrega,
    a.data_entrega
FROM chamado c
INNER JOIN cliente cl
    ON cl.id_cliente = c.id_cliente
INNER JOIN tipo_atendimento ta
    ON ta.id_tipo = c.id_tipo
LEFT JOIN atendimento a
    ON a.id_chamado = c.id_chamado
LEFT JOIN tecnico t
    ON t.id_tecnico = a.id_tecnico
ORDER BY c.id_chamado;


/* ============================================================
   11. BLOCO PL/SQL COM BEGIN, IF, THEN, ELSE E COMMIT
   ============================================================ */

DECLARE
    v_status chamado.status_solucao%TYPE;
BEGIN
    SELECT status_solucao
    INTO v_status
    FROM chamado
    WHERE id_chamado = 1;

    IF v_status = 'CONCLUIDO' THEN
        DBMS_OUTPUT.PUT_LINE(
            'O chamado esta concluido e pode ser entregue.'
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE(
            'O chamado ainda nao esta pronto para entrega.'
        );
    END IF;

    COMMIT;
END;
/


/* ============================================================
   12. BLOCO PL/SQL COM LOOP
   Atualiza chamados abertos para em andamento
   ============================================================ */

DECLARE
    v_id_chamado chamado.id_chamado%TYPE;
BEGIN
    FOR registro IN (
        SELECT id_chamado
        FROM chamado
        WHERE status_solucao = 'ABERTO'
    )
    LOOP
        v_id_chamado := registro.id_chamado;

        UPDATE chamado
        SET status_solucao = 'EM ANDAMENTO'
        WHERE id_chamado = v_id_chamado;

        DBMS_OUTPUT.PUT_LINE(
            'Chamado atualizado: ' || v_id_chamado
        );
    END LOOP;

    COMMIT;
END;
/


/* ============================================================
   13. NOVA INSERCAO POR BLOCO PL/SQL
   ============================================================ */

BEGIN
    INSERT INTO chamado (
        id_chamado,
        id_cliente,
        id_tipo,
        defeito,
        configuracao_maquina,
        data_abertura,
        status_solucao
    )
    VALUES (
        seq_chamado.NEXTVAL,
        2,
        3,
        'Internet lenta e com quedas frequentes',
        'Computador desktop conectado por cabo de rede',
        SYSDATE,
        'ABERTO'
    );

    COMMIT;
END;
/


/* ============================================================
   14. CONSULTA FINAL DOS CHAMADOS
   ============================================================ */

SELECT
    c.id_chamado,
    cl.nome AS cliente,
    ta.descricao AS tipo_atendimento,
    c.defeito,
    c.status_solucao,
    c.data_abertura
FROM chamado c
INNER JOIN cliente cl
    ON cl.id_cliente = c.id_cliente
INNER JOIN tipo_atendimento ta
    ON ta.id_tipo = c.id_tipo
ORDER BY c.id_chamado;
