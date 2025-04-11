# Northwind Stock Analysis 📊

Este projeto apresenta uma análise exploratória do estoque da base de dados Northwind, utilizando SQL para extrair insights sobre lucratividade, sazonalidade, reposição e otimização do estoque.

## 🔍 Objetivo 

O objetivo é compreender a situação atual do estoque da empresa fictícia Northwind, identificar os produtos mais lucrativos, apontar desequilíbrios entre demanda e estoque, e propor melhorias para a gestão.

## 🛠️ Ferramentas utilizadas

- SQL (PostgreSQL)
- Base de dados Northwind

## 📌 Análises realizadas

### 1. Informações Gerais do Estoque
- Total de produtos distintos
- Produtos descontinuados
- Total de unidades em estoque (ativos e descontinuados)

### 2. Produtos Mais Lucrativos (Análise de Pareto)
- Identificação dos produtos que geram 80% da receita
- Destaque para os 5 principais produtos responsáveis por 30% do faturamento

### 3. Estoque Insuficiente vs. Demanda
- Produtos com estoque abaixo da demanda do ano anterior
- Sugestões de reposição e otimização de espaço

### 4. Sazonalidade
- Distribuição mensal das vendas
- Identificação de períodos de maior demanda para melhor planejamento do estoque

## 📈 Principais Insights

- **20 produtos** representam a maior parte da receita.
- **28 produtos ativos** estão com estoque insuficiente para atender à demanda do mesmo período do ano anterior.
- Alguns produtos têm **excesso de estoque** sem relevância para o faturamento.
- A demanda é **mais alta entre janeiro e abril**, o que exige atenção no planejamento.

## 🗂️ Organização

- Pasta `data/`: arquivos `.csv` da base Northwind
- Arquivo `.sql`: comandos utilizados para a análise

## ✅ Conclusão

Com base nos dados, é possível otimizar a gestão de estoque focando na reposição de produtos mais lucrativos, ajustando o volume de produtos com baixa demanda e se preparando melhor para períodos de alta demanda.

---

📬 **Contato**: 
Linkedin: [](https://www.linkedin.com/in/mfeferman/)
Email: marcelfefer@gmail.com
