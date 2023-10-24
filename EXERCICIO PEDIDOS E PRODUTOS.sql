-- EXERCICIO COMERCIO ELETRONICO 

SET foreign_key_checks = 0;


CREATE TABLE produtos (
id_produto int primary key auto_increment,
nome_produto varchar(100) not null, 
descricao_produto text,
estoque_produto int unsigned default 0,
preco_produto decimal (10,2) unsigned not null
);

INSERT INTO produtos (nome_produto,descricao_produto,estoque_produto,preco_produto) 
values 
( 'Caneta BIC Azul', 'Caneta azul com tampa', '20', '1.99'),
( 'Lapis Faber Castell', 'Lapis Colorido Faber Castell', '15', '16.99'),
( 'Lapiseira Fina', 'Lapiseira para grafite 0.5', '30', '12.99'),
( 'Lapiseira Grossa', 'Lapiseira para grafite 0.7', '30', '14.99'),
( 'Caneta BIC Preta', 'Caneta preta com tampa', '20', '1.99'),
( 'Caneta BIC Vermelha', 'Caneta vermelha com tampa', '20', '1.99'),
( 'Caneta BIC marca-texto', 'Marca Texto com tampa', '20', '1.99'),
( 'Caneta MultiCor', 'Caneta de tres cores sem tampa', '20', '3.99'),
( 'Lapis Desenho 6B', 'Lapis de Desenho 6B', '20', '4.50'),
( 'Lapis Desenho 3B', 'Lapis de Desenho 6B', '20', '3.99'),
( 'Lapis escolar HB', 'Lapis escolar HB', '20', '1.79'),
('Borracha Escolar', 'Borracha para lápis', '25', '0.99'),
('Régua Transparente', 'Régua de plástico transparente', '40', '1.49'),
('Apontador de lápis', 'Apontador para lápis com depósito', '30', '2.29'),
('Caderno Pautado', 'Caderno com folhas pautadas', '50', '5.99'),
('Agenda Semanal', 'Agenda semanal com capa dura', '35', '7.49'),
('Pasta Arquivo', 'Pasta para organizar documentos', '28', '3.99'),
('Grampeador Pequeno', 'Grampeador de papel pequeno', '15', '4.79'),
('Clips de Papel', 'Clips de papel sortidos', '50', '0.89'),
('Tesoura Escolar', 'Tesoura escolar de ponta redonda', '20', '2.49');




CREATE TABLE clientes (
id_cliente int primary key auto_increment,
nome_cliente varchar(100) not null,
endereco_cliente text not null,
email_cliente varchar(100) not null unique
);

INSERT INTO clientes (nome_cliente, endereco_cliente, email_cliente) VALUES 
('Ana Silva', 'Rua das Flores, 123, Cidade A', 'ana.silva@email.com'),
('Carlos Oliveira', 'Avenida Principal, 45, Cidade B', 'carlos.oliveira@email.com'),
('Mariana Santos', 'Rua do Comércio, 78, Cidade C', 'mariana.santos@email.com'),
('João Pereira', 'Avenida Central, 56, Cidade D', 'joao.pereira@email.com'),
('Camila Lima', 'Rua das Árvores, 37, Cidade E', 'camila.lima@email.com'),
('Rafael Souza', 'Avenida dos Esportes, 92, Cidade F', 'rafael.souza@email.com'),
('Fernanda Almeida', 'Rua da Paz, 14, Cidade G', 'fernanda.almeida@email.com'),
('Rodrigo Oliveira', 'Avenida dos Girassóis, 71, Cidade H', 'rodrigo.oliveira@email.com'),
('Juliana Costa', 'Rua da Esperança, 99, Cidade I', 'juliana.costa@email.com'),
('Gabriel Santos', 'Avenida das Estrelas, 23, Cidade J', 'gabriel.santos@email.com'),
('Patrícia Lima', 'Rua das Pedras, 68, Cidade K', 'patricia.lima@email.com'),
('Lucas Alves', 'Avenida da Liberdade, 72, Cidade L', 'lucas.alves@email.com'),
('Isabela Oliveira', 'Rua dos Sonhos, 84, Cidade M', 'isabela.oliveira@email.com'),
('Daniel Silva', 'Avenida dos Ventos, 32, Cidade N', 'daniel.silva@email.com'),
('Carolina Mendes', 'Rua das Ondas, 51, Cidade O', 'carolina.mendes@email.com'),
('Eduardo Santos', 'Avenida das Águas, 67, Cidade P', 'eduardo.santos@email.com'),
('Amanda Costa', 'Rua das Marés, 78, Cidade Q', 'amanda.costa@email.com'),
('Ricardo Almeida', 'Avenida das Montanhas, 44, Cidade R', 'ricardo.almeida@email.com'),
('Larissa Pereira', 'Rua das Colinas, 19, Cidade S', 'larissa.pereira@email.com'),
('Bruno Lima', 'Avenida dos Lagos, 62, Cidade T', 'bruno.lima@email.com');

CREATE TABLE carrinho (
id_carrinho int primary key auto_increment,
id_cliente_pedido int not null,
id_produto_carrinho int not null,
quantidade_produto_carrinho int not null default 1,
foreign key (id_cliente_pedido) references clientes(id_cliente)
);

CREATE TABLE pedidos(
id_pedido int primary key auto_increment,
data_pedido timestamp default current_timestamp ,
id_cliente_pedido int not null,
foreign key (id_cliente_pedido) references clientes(id_cliente)
);


CREATE TABLE itens_pedido(
id_item int primary key auto_increment,
id_pedido int not null,
id_produto int not null,
quantidade_itens int not null,
foreign key (id_pedido) references pedidos(id_pedido),
foreign key (id_produto) references produto(id_produto)
);


DELIMITER $

CREATE PROCEDURE adicionar_carrinho (id_cliente int, id_produto int, quantidade_produto int)
BEGIN
    INSERT INTO carrinho (id_cliente_pedido, id_produto_carrinho, quantidade_produto_carrinho) VALUES (id_cliente, id_produto, quantidade_produto);
END$



DELIMITER $

CREATE PROCEDURE fechar_pedido(IN cliente_id INT)
BEGIN
    DECLARE pedido_id INT;

    
    INSERT INTO pedidos (id_cliente_pedido, data_pedido)
    SELECT id_cliente_pedido, CURRENT_TIMESTAMP FROM carrinho WHERE id_cliente_pedido = cliente_id;
    
    SET pedido_id = LAST_INSERT_ID();
    
   
    INSERT INTO itens_pedido (id_pedido, id_produto, quantidade_itens)
    SELECT pedido_id, id_produto_carrinho, quantidade_produto_carrinho
    FROM carrinho
    WHERE id_cliente_pedido = cliente_id;

    UPDATE produtos p
    INNER JOIN itens_pedido ip ON p.id_produto = ip.id_produto
    SET p.estoque_produto = p.estoque_produto - ip.quantidade_itens
    WHERE ip.id_pedido = pedido_id;
    
    
    DELETE FROM carrinho WHERE id_cliente_pedido = cliente_id;
END$

DELIMITER ;


-- ----------------------------------------------- CALCULAR TOTAL PEDIDO
DELIMITER $
CREATE PROCEDURE calcular_total_pedido(IN pedido_id INT, OUT total DECIMAL(10,2))
BEGIN
   
    SELECT SUM(p.preco_produto * ip.quantidade_itens) INTO total
    FROM produtos p
    JOIN itens_pedido ip ON p.id_produto = ip.id_produto
    WHERE ip.id_pedido = pedido_id;
END$





-- ------------------------------------------------ HISTORICO PEDIDOS
CREATE VIEW historicoPedidoClientes AS
SELECT p.id_pedido, p.data_pedido, ip.id_produto, pr.nome_produto, ip.quantidade_itens
FROM pedidos p
JOIN itens_pedido ip ON p.id_pedido = ip.id_pedido
JOIN produtos pr ON ip.id_produto = pr.id_produto;


call adicionar_carrinho ('1','10','2');
call adicionar_carrinho (3, 10,5);

call fechar_pedido(3);

CALL calcular_total_pedido(1, @total);
SELECT @total;


CREATE VIEW verProdutosDisponiveis AS
Select * from produtos where estoque_produto > 0;

SELECT * from verProdutosDisponiveis;

select * from historicopedidoclientes;
