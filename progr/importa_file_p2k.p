
{pedidos_p2k.i}

def input param parquivo as char.
def input param ptipo    as int.
def output param vfincod as int.
vfincod = 0.
def var vtipo as int format "99".
def var vforma as int.   

def var vlinha as char format "x(167)".
input from value(parquivo).
repeat.
    import unformatted vlinha.
    vtipo = int(substring(vlinha,1,2)).
    if vtipo = 11
    then do:
        for each ttp2k_pedido01. delete ttp2k_pedido01. end.
        vfincod = ?.
        return.
    end.
    if vtipo = 1 and (ptipo = 1 or ptipo = ?)
    then do: 
        create ttp2k_pedido01.
        ttp2k_pedido01.Numero_Pedido    = int(substring(vlinha,8,10)).
        ttp2k_pedido01.codigo_loja    = int(substring(vlinha,3,5)).
        ttp2k_pedido01.Codigo_Cliente = int(substring(vlinha,38,20)).
        ttp2k_pedido01.nome_cliente   = substring(vlinha,78,40).

        ttp2k_pedido01.dataPedido     = date(int(substring(vlinha,28,2)),
                                             int(substring(vlinha,30,2)), 
                                             int(substring(vlinha,24,4))  ).
        
        if ttp2k_pedido01.Codigo_Cliente <> 0 and ttp2k_pedido01.Codigo_Cliente <> 1
        then do:
            find clien where clien.clicod = ttp2k_pedido01.Codigo_Cliente no-lock no-error.
            if avail clien
            then do:
                ttp2k_pedido01.nome_cliente = clien.clinom.
            end.
        end.            
    end.        
    if vtipo = 2 and (ptipo = 2 or ptipo = ?)
    then do:
        create ttp2k_pedido02.
        ttp2k_pedido02.Numero_Pedido    =  int(substring(vlinha,8,10)).
        ttp2k_pedido02.Seq_Item_Pedido  = int(substring(vlinha,18,6)).
        ttp2k_pedido02.Codigo_Vendedor  = int(substring(vlinha,29,6)).
        ttp2k_pedido02.Codigo_Produto   = int(substring(vlinha,35,20)).
        ttp2k_pedido02.Quant_Produto    = int(substring(vlinha,69,5)).
        ttp2k_pedido02.Valor_Unitario   = dec(substring(vlinha,79,13)) / 100.
        ttp2k_pedido02.Val_Total_Item   = dec(substring(vlinha,92,13)) / 100.
        ttp2k_pedido02.desconto         = dec(substring(vlinha,106,13)) / 100.
    end.
    if vtipo = 5 and (ptipo = 5 or ptipo = ?)
    then do:
        create ttp2k_pedido05.
        ttp2k_pedido05.Numero_Pedido    =   int(substring(vlinha,8,10)).
        ttp2k_pedido05.Codigo_Vendedor  =   int(substring(vlinha,23,6)).
        ttp2k_pedido05.Codigo_Produto   =   int(substring(vlinha,29,20)).
        ttp2k_pedido05.Codigo_Garantia  =   int(substring(vlinha,123,10)).
        ttp2k_pedido05.Valor_Garantia   =   dec(substring(vlinha,133,13)) / 100.
        ttp2k_pedido05.tempogar         =   int(substring(vlinha,159,3)).
        ttp2k_pedido05.meses            =   int(substring(vlinha,162,3)).
        ttp2k_pedido05.subtipo          =   substring(vlinha,165,1).
        ttp2k_pedido05.p2k-datahoraprodu =  substring(vlinha,176,8) + substring(vlinha,205,6).
        ttp2k_pedido05.p2k-datahoraplano =  substring(vlinha,211,14).
        ttp2k_pedido05.movseq           =   int(substring(vlinha,225,6)).
        ttp2k_pedido05.p2k-id_seguro    =   int(substring(vlinha,232,9)). /* helio 211024 - 1406 */
                    
    end.
    if vtipo = 7 and (ptipo = 7 or ptipo = ?)
    then do:
        vforma = int(substring(vlinha,3,2)).
        if vforma = 2
        then do:
            create ttp2k_pedido07.
            ttp2k_pedido07.Numero_Pedido    =   int(substring(vlinha,10,10)).
            ttp2k_pedido07.Codigo_Vendedor  =   int(substring(vlinha,25,6)).
            ttp2k_pedido07.Codigo_Produto   =   int(substring(vlinha,31,30)).
            ttp2k_pedido07.Valor_Total      =   dec(substring(vlinha,61,13)) / 100.
            
        end.            
    end.
    if vtipo = 3 and (ptipo = 3 or ptipo = ?)
    then do:
        vforma = int(substring(vlinha,8,5)).
        if vforma = 93
        then do:
            vfincod = int(substring(vlinha,13,5)).
        end.            
    end.
    if vtipo = 8 and (ptipo = 8 or ptipo = ?)
    then do:
        create ttp2k_pedido08.
        ttp2k_pedido08.observacoes = substring(vlinha,3).
    end.
    

end.
input close.


