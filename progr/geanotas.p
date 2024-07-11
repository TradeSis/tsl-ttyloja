{admcab.i}
{apibusca-garantia.i}
def input param pcpf as dec.
def input param pclicod as int.
def output param precid as recid.

def var ctitle as char.
ctitle = "GARANTIA ESTENDIDA AVUILSA " + if pcpf = ? then "" else string(pcpf).

def var vhelp as char.
def var xtime as int.
def var vconta as int.
def var recatu1         as recid.
def var recatu2     as reci.
def var reccont         as int.
def var esqpos1         as int.
def var esqcom1         as char format "x(11)" extent 6
    initial ["detalhes","venda"," ",""].

form
    esqcom1
    with frame f-com1 row 5 no-box no-labels column 1 centered.

assign
    esqpos1  = 1.

form
        ttitensnota.codigoLoja column-label "fil" format "x(4)"
        ttitensnota.dataTransacao column-label "data" format "x(10)"
        ttitensnota.numeroNfe   column-label "nota" format "x(8)"
        ttitensnota.codigoProduto column-label "codigo" format "x(8)"
        ttitensnota.descricaoProduto column-label "produto" format "x(30)"
        with frame frame-a 9 down centered row 7
        no-box.

find clien where clien.clicod = pclicod no-lock no-error.
    disp 
        ctitle format "x(70)" no-label skip
        clien.clicod label "cliente" clien.clinom no-label

        with frame ftit
            side-labels
            row 3
            centered
            no-box
            color messages.


recatu1 = ?.

bl-princ:
repeat:
    

    disp esqcom1 with frame f-com1.
    if recatu1 = ?
    then run leitura (input "pri").
    else find ttitensnota where recid(ttitensnota) = recatu1 no-lock.
    if not available ttitensnota
    then do.        
        return.
    end.
    clear frame frame-a all no-pause.
    run frame-a.

    recatu1 = recid(ttitensnota).
    color display message esqcom1[esqpos1] with frame f-com1.
    repeat:
        run leitura (input "seg").
        if not available ttitensnota
        then leave.
        if frame-line(frame-a) = frame-down(frame-a)
        then leave.
        down with frame frame-a.
        run frame-a.
    end.
    up frame-line(frame-a) - 1 with frame frame-a.

    repeat with frame frame-a:

        find ttitensnota where recid(ttitensnota) = recatu1 no-lock.

        esqcom1[1] = "detalhes".
        esqcom1[5] = " ". 
        esqcom1[3] = "". 
/*        esqcom1[4] = "historico". */

        status default "".
        
                        
        /*             
        def var vx as int.
        def var va as int.
        va = 1.
        do vx = 1 to 6.
            if esqcom1[vx] = ""
            then next.
            esqcom1[va] = esqcom1[vx].
            va = va + 1.  
        end.
        vx = va.
        do vx = va to 6.
            esqcom1[vx] = "".
        end.     
        */
    hide message no-pause.
    /*    
    if ttitensnota.titdescjur <> 0
    then do:
        if ttitensnota.titdescjur > 0
        then do:
                message color normal 
            "juros calculado em" ttitensnota.dtinc "de R$" trim(string(ttitensnota.titvljur + ttitensnota.titdescjur,">>>>>>>>>>>>>>>>>9.99"))    
            " dispensa de juros de R$"  trim(string(ttitensnota.titdescjur,">>>>>>>>>>>>>>>>>9.99")).
        end.
        else do:
            message color normal 
            "juros calculado em" ttitensnota.dtinc "de R$" trim(string(ttitensnota.titvljur + ttitensnota.titdescjur,">>>>>>>>>>>>>>>>>9.99"))    

            " juros cobrados a maior R$"  trim(string(ttitensnota.titdescjur * -1 ,">>>>>>>>>>>>>>>>>9.99")).
        
        end.
        
    end.
    */    
        
        disp esqcom1 with frame f-com1.
        
        run color-message.
        vhelp = "".
        
        
        status default vhelp.
        choose field ttitensnota.codigoproduto
                      help ""
                go-on(cursor-down cursor-up
                      cursor-left cursor-right
                      page-down   page-up
                      L l
                      tab PF4 F4 ESC return).

        if keyfunction(lastkey) <> "return"
        then run color-normal.

        hide message no-pause.
                 
        pause 0. 

                                                                
            if keyfunction(lastkey) = "cursor-right"
            then do:
                color display normal esqcom1[esqpos1] with frame f-com1.
                esqpos1 = if esqpos1 = 6 then 6 else esqpos1 + 1.
                color display messages esqcom1[esqpos1] with frame f-com1.
                next.
            end.
            if keyfunction(lastkey) = "cursor-left"
            then do:
                color display normal esqcom1[esqpos1] with frame f-com1.
                esqpos1 = if esqpos1 = 1 then 1 else esqpos1 - 1.
                color display messages esqcom1[esqpos1] with frame f-com1.
                next.
            end.
            if keyfunction(lastkey) = "page-down"
            then do:
                do reccont = 1 to frame-down(frame-a):
                    run leitura (input "down").
                    if not avail ttitensnota
                    then leave.
                    recatu1 = recid(ttitensnota).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "page-up"
            then do:
                do reccont = 1 to frame-down(frame-a):
                    run leitura (input "up").
                    if not avail ttitensnota
                    then leave.
                    recatu1 = recid(ttitensnota).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "cursor-down"
            then do:
                run leitura (input "down").
                if not avail ttitensnota
                then next.
                if frame-line(frame-a) = frame-down(frame-a)
                then scroll with frame frame-a.
                else down with frame frame-a.
            end.
            if keyfunction(lastkey) = "cursor-up"
            then do:
                run leitura (input "up").
                if not avail ttitensnota
                then next.
                if frame-line(frame-a) = 1
                then scroll down with frame frame-a.
                else up with frame frame-a.
            end.
 
        if keyfunction(lastkey) = "end-error"
        then leave bl-princ.
                
                
        if keyfunction(lastkey) = "return"
        then do:
            
            
             /*if esqcom1[esqpos1] = "cancela"
             then do: 
                hide message no-pause.
                sresp = no.
                message "Confirma cancelamento adesao numero " ttitensnota.etbdest "?"
                    update sresp.
                if sresp
                then do:
                    run api/medcancelaadesao.p (recid(ttitensnota)).
                    leave.
                end.
            end.
            */
            
            
            if esqcom1[esqpos1] = "detalhes"
            then do:
                 run pdetalhes.
            end.
            if esqcom1[esqpos1] = "venda"
            then do:
                precid = recid(ttitensnota).
                hide frame f-com1  no-pause.
                hide frame frame-a no-pause.
                hide frame fcab no-pause.
                hide frame fdet no-pause.
                
                return.
            end.


        end.        
        run frame-a.
        display esqcom1[esqpos1] with frame f-com1.
        recatu1 = recid(ttitensnota).
    end.
    if keyfunction(lastkey) = "end-error"
    then do:
        view frame fc1.
        view frame fc2.
    end.
end.
hide frame f-com1  no-pause.
hide frame frame-a no-pause.
hide frame ftit no-pause.
hide frame ftot no-pause.
return.
 
procedure frame-a.
    def var vdataTransacao as date format "99/99/9999".
    vdataTransacao = date(
                                int(entry(2,ttitensnota.dataTransacao,"-")),
                                int(entry(3,ttitensnota.dataTransacao,"-")),
                                int(entry(1,ttitensnota.dataTransacao,"-"))
                            ).
    display  
        ttitensnota.codigoLoja 
        vdataTransacao @ ttitensnota.dataTransacao 
        ttitensnota.numeroNfe   
        ttitensnota.codigoProduto 
        ttitensnota.descricaoProduto 
        with frame frame-a.


end procedure.

procedure color-message.
    color display message
        ttitensnota.codigoLoja 
        ttitensnota.dataTransacao 
        ttitensnota.numeroNfe   
        ttitensnota.codigoProduto 
        ttitensnota.descricaoProduto 
        with frame frame-a.
end procedure.


procedure color-input.
    color display input
        ttitensnota.codigoLoja 
        ttitensnota.dataTransacao 
        ttitensnota.numeroNfe   
        ttitensnota.codigoProduto 
        ttitensnota.descricaoProduto 
        with frame frame-a.
end procedure.


procedure color-normal.
    color display normal
        ttitensnota.codigoLoja 
        ttitensnota.dataTransacao 
        ttitensnota.numeroNfe   
        ttitensnota.codigoProduto 
        ttitensnota.descricaoProduto 
 
        with frame frame-a.
end procedure.

procedure leitura . 
def input parameter par-tipo as char.

    if par-tipo = "pri" 
    then do:
        find last ttitensnota 
            no-lock no-error.
    end.    
                                             
    if par-tipo = "seg" or par-tipo = "down" 
    then do:
        find prev ttitensnota 
            no-lock no-error.
    end.    
             
    if par-tipo = "up" 
    then do:
        find next ttitensnota
            no-lock no-error.

    end.  
        
end procedure.

procedure pdetalhes.
    find current ttitensnota.
    def var vdataTransacao as date format "99/99/9999".
    vdataTransacao = date(
                                int(entry(2,ttitensnota.dataTransacao,"-")),
                                int(entry(3,ttitensnota.dataTransacao,"-")),
                                int(entry(1,ttitensnota.dataTransacao,"-"))
                            ).
     
    disp
     codigoLoja    label "Fil" colon 16 vdataTransacao @ dataTransacao label "data"  numeroComponente label "caixa"  nsuTransacao   label "nsu" 
     cpfCnpjNfe     label "cpf" format "x(14)" colon 16 codigoCliente  label "cliente" 
     numeroNfe      label "nota" colon 16 serieNfe       label "serie"  numeroCupom    label "cupom" 
     codigoProduto  label "produto" colon 16 descricaoProduto format "x(40)" no-label
     qtdVendidaProduto  label "qtd" colon 16 valorUnitarioProduto  label "Preco"  valorTotalProduto  label "total" 
     valorDescontoProduto  label "desconto" colon 16 prazoGarantiaFabricanteProduto  label "prazo" 
    with frame fdet
        row 5 side-labels.
    pause.        
end.
