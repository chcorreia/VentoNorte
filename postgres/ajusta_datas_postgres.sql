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

CREATE OR REPLACE PROCEDURE ajusta_datas(data_base DATE)
LANGUAGE plpgsql
AS $$
DECLARE
    max_data DATE;
    dias_dif INTEGER;
BEGIN

	IF data_base is null THEN
		data_base = CURRENT_DATE;
	END IF;


    -- Obtém a data do pedido mais recente
    SELECT MAX(data_pedido) 
    INTO max_data 
    FROM pedido;

    -- Calcula a diferença em dias entre a data mais recente e hoje
    IF max_data IS NOT NULL THEN
        dias_dif := CURRENT_DATE - max_data;

        -- Ajusta os pedidos pela diferença calculada
        UPDATE pedido
        SET data_pedido = data_pedido + dias_dif,
            data_prometido = data_prometido + dias_dif,
            data_enviado = data_enviado + dias_dif;
			
		-- Atualiza os vendedores
		UPDATE vendedor
		SET data_nasc = data_nasc + dias_dif,
		data_contrato = data_contrato + dias_dif;
		
		-- Uhul
        RAISE NOTICE 'Pedido mais recente ajustado para %. Todas as datas foram atualizadas.', data_base;
    ELSE
        RAISE NOTICE 'Nenhum pedido encontrado. Nenhuma atualização realizada.';
    END IF;
END;
$$;

-- AJUSTA AS DATAS PARA A DATA DA INSTALAÇÃO
call ajusta_datas(CURRENT_DATE);

--
-- FIM 
--