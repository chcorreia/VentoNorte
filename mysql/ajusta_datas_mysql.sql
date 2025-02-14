/*-----------------------------------------------------------------------------
PROCEDURE AJUSTAR_DATAS(data_base)

Ajusta as datas do banco de dados para um dia específico.
É executada com o valor CURRENT_DATE no script de criação do banco.
Faz com que a data do último pedido seja a fornecida em data_base,
e todas as datas na tabela de pedidos e vendedores são ajustadas junto.

Permite que o professor ou o estudante faça o banco de dados parecer como
estivesse sendo utilizado naquele dia, permitindo usar CURRENT_DATE para 
testar quais pedidos ainda faltam enviar, etc.

O parâmetro permite que o professor peça para os alunos ajustarem
seu banco para uma data específica de modo a todo obterem os mesmos resultados.

autor: Carlos H Correia - SENAI Pato Branco
fonte: https://github.com/profcarlos-senai/VentoNorte/
-----------------------------------------------------------------------------*/

DELIMITER // -- Define o delimitador para evitar conflito com o ponto e vírgula dentro da procedure

CREATE PROCEDURE ajusta_datas(data_base DATE)
BEGIN
    DECLARE max_data DATE;
    DECLARE dias_dif INT; 
    IF data_base IS NULL THEN
        SET data_base = CURRENT_DATE(); 
    END IF;

    -- Obtém a data do pedido mais recente
    SELECT MAX(data_pedido) INTO max_data FROM pedido;

    -- Calcula a diferença em dias entre a data mais recente e a data escolhida
    IF max_data IS NOT NULL THEN
        SET dias_dif = DATEDIFF(data_base, max_data); 

        -- Ajusta os pedidos pela diferença calculada
        UPDATE pedido
        SET data_pedido = DATE_ADD(data_pedido, INTERVAL dias_dif DAY),
            data_prometido = DATE_ADD(data_prometido, INTERVAL dias_dif DAY),
            data_enviado = DATE_ADD(data_enviado, INTERVAL dias_dif DAY);

        -- Atualiza os vendedores
        UPDATE vendedor
        SET data_nasc = DATE_ADD(data_nasc, INTERVAL dias_dif DAY),
            data_contrato = DATE_ADD(data_contrato, INTERVAL dias_dif DAY);

        -- Uhul
        SELECT CONCAT('Pedido mais recente ajustado para ', data_base, '. Todas as datas foram atualizadas.') as SUCESSO;
    ELSE
        SELECT 'Nenhum pedido encontrado. Nenhuma atualização realizada.' as ERRO;
    END IF;
END // -- Fim da procedure

DELIMITER ; -- Volta ao delimitador padrão

-- AJUSTA AS DATAS PARA A DATA DA INSTALAÇÃO
CALL ajusta_datas(CURRENT_DATE()); 

--
-- FIM
--
