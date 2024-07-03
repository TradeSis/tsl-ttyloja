{admcab.i}

{apibusca-garantia.i new}
def new shared temp-table wf-movim no-undo
    field wrec      as   recid
    field movqtm    like movim.movqtm
    field lipcor    like liped.lipcor
    field movalicms like movim.movalicms
    field desconto  like movim.movdes
    field movpc     like movim.movpc
    field precoori  like movim.movpc
    field vencod    like func.funcod
    field KITproagr   like produ.procod.

def new shared temp-table ttentrada serialize-name "dadosEntrada" 
    field codigoFilial   as int 
    field cpfCnpj        as char 
    field nomeCliente         as char  
    field dataNascimento         as date 
    field telefone       as char.

def var pclicod as int.
def var pretorno as char.
def var precid as recid.
def var plojaVenda  as int format "9999".
def var pdataVenda  as date format "99/99/9999".
def var pnumeroNota as int format ">>>>>>>>>>9".
def var pserieNota  as char format "x(3)".

def var pcpf    as dec format "99999999999" label "CPF".
def var pconsultor like func.funcod.
 
form
    setbcod label "filial" colon 15
    pconsultor label "consultor"    func.funnom no-label
    pcpf colon 15 
    clien.clinom format "x(30)" no-labels
    
    with frame fcab
    row 4
     side-labels centered  width 80
     title " GARANTIA ESTENDIDA AVULSA ".
disp setbcod with frame fcab.
 
pconsultor = sfuncod.     
repeat.
    update 
        pconsultor 
            with frame fcab.

    find func where func.etbcod = setbcod and func.funcod = pconsultor no-lock no-error.
    if not avail fun
    then do:
        pconsultor = sfuncod.
        message "consultor nao valido".
        undo.
    end.
    disp func.funnom with frame fcab.
    update pcpf
        help "cpf do cliente ou zeros para pesquisa por nota"
        with frame fcab.

    
    if pcpf = 0 or pcpf = ?
    then do:
        message "informe dados da nota".
            plojavenda = setbcod.
        update plojaVenda label "loja Venda"  colon 16
                pdataVenda label "data Venda" colon 46
                    pnumeroNota label "Numero Nota" colon 16
                    
                    pserieNota label "serie Nota" colon 46
            with frame fnota side-labels
            row 7 overlay centered width 60
            title "digite dados da nota".
            run apibusca-garantia-nota.p (input plojaVenda, input pdataVenda, input pnumeroNota, input pserieNota,
                             output pretorno).

    end. 
    else do:

        find clien where clien.ciccgc = string(pcpf) no-lock no-error.
        if not avail clien
        then
            find clien where clien.ciccgc = string(pcpf,"99999999999") no-lock no-error.
        if not avail clien
        then do:
            empty temp-table ttentrada.            
            create ttentrada.
            ttentrada.codigoFilial = setbcod.
            ttentrada.cpfCnpj      = string(pcpf,"9999999999").
            run lojapi-clienteconsultar.p (output pclicod).
            
            if pclicod <> ? and pclicod > 1
            then find clien where clien.clicod = pclicod no-lock no-error.
            if pclicod = ? or not avail clien
            then do: 
                message "cliente nao cadastrado" view-as alert-box.
                undo.
            end.
        end.
  
        run apibusca-garantia-cpf.p (input pcpf,
                             output pretorno).

    end.
    
    if pretorno <> ""
    then do: 
        message pretorno view-as alert-box.
        undo.
    end.    
    leave.
end.

    precid = ?.
    find first ttitensnota no-error.
    if avail ttitensnota
    then run geanotas.p (input pcpf,
                     output precid).
                     
    if precid <> ?                     
    then do:
        run geavenda.p (
                        input pcpf, 
                        input pconsultor,    
                        input precid).
    end.
    
