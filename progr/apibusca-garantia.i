
def {1} shared temp-table ttitensNota no-undo serialize-name "itensNota"
    field codigoLoja    as char /*": "188",*/
    field dataTransacao as char /*": "2024-02-26",*/
    field numeroComponente  as char /*": "31",*/ 
    field nsuTransacao  as char /*": "7",*/
    field cpfCnpjNfe    as char /*": "03582947033",*/ 
    field codigoCliente as char /*": "41111740",*/ 
    field numeroNfe     as char /*": "31073",*/
    field serieNfe      as char /*": "31",*/ 
    field numeroCupom   as char /*": "2967",*/
    field codigoProduto as char /*": "567143",*/ 
    field descricaoProduto  as char /*": "SANDUICHEIRA MOND S12 ELET 2",*/ 
    field qtdVendidaProduto as char /*": "1",*/ 
    field valorUnitarioProduto as char  /* ": "129.9",*/ 
    field valorTotalProduto as char /*": "129.9",*/ 
    field valorDescontoProduto as char /*": "0",*/ 
    field prazoGarantiaFabricanteProduto as char /*": "12"*/
    index itens is unique primary codigoLoja asc dataTransacao asc numeroComponente asc nsuTransacao asc codigoCliente asc numeroCupom asc codigoProduto asc.

