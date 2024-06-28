
do on error undo, retry  on endkey undo, leave with frame f-desti:
    clear frame f-condi all.
    hide frame f-condi no-pause.        
    repeat on endkey undo, leave bl-plano: 

        if vclicod = 1 then vclicod = 0.

        if keyfunction(lastkey) = "end-error"
        then do:  
            vfincod = 0.
        end.       
        
        do:
            find finan where finan.fincod = vfincod no-lock no-error.
            if avail finan
            then disp finan.fincod @ vfincod 
                      finan.finnom with frame f-desti.
            update vfincod go-on (F7 f7) with frame f-desti.  

            if lastkey = keycode("F7") or
               lastkey = keycode("f7")
            then do:

                run simula_parcela.p(input vprotot, 
                                     input vdevval, 
                                     input vbonus,
                                     input no /*BAGparcela-especial*/, 
                                     input no,
                                     output vfincod).
                if vfincod = ?
                then do:
                    vfincod = vplano-ori.
                    undo, retry.                     
                end.
            end.
            disp vfincod with frame f-desti.
            pause 0.

            find finan where finan.fincod = vfincod no-lock no-error.  
            if not avail finan  
            then do:  
                message "Plano nao cadastrado".  
                pause.
                vfincod = 0.
                next. 
            end. 

            disp finan.fincod @ vfincod 
                 finan.finnom with frame f-desti.
            hide frame f-condi no-pause.
            clear frame f-condi all.
            
        end.
        
        
        assign
            libera-plano = no
            block-plano  = no.
                /* coloquei calcular o seguro assim que digita o plano */        
                
                    run seguroprestamista (finan.finnpc, vparce, v-vencod,
                                           output vsegtipo,
                                           output vsegprest,
                                           output vsegvalor).
        
        
            parametro-in = "LIBERA-PLANO=S|CASADINHA=S|GERA-CPG=S|"
                        + "PLANO=" + string(finan.fincod) + "|"
                        + "ALTERA-PRECO=S|".
            
            run promo-venda.p(input parametro-in ,
                              output parametro-out).

            if acha("LIBERA-PLANO",parametro-out) <> ?
            then do:
                if acha("LIBERA-PLANO",parametro-out) = "S"
                then libera-plano = yes. 
                else block-plano = yes.
            end.
            
            if acha("ARREDONDA-PARCELA",parametro-out) <> ?
            then sparam = "ARREDONDA=" + 
                        acha("ARREDONDA-PARCELA",parametro-out) + "|".

            parametro-in = "PRECO-ESPECIAL=S|PRODUTO=|"
                           + "PLANO=" + string(finan.fincod) + "|".
            run promo-venda.p(input parametro-in, output parametro-out).
            
            if acha("PROMOCAO",parametro-out) <> ? 
            then vpromoc = acha("promocao",parametro-out).
            else vpromoc = "".

        if libera-plano  = no and
           block-plano = yes
        then do:
            message color red/with
              "Plano bloqueado para produto(s) incluido(s)." view-as alert-box.
            undo, retry.
        end.

        vpassa = yes.

        if vfincod <> 0   
        then do:
            run gercpg.
            pause 0.
            
            display ventra
                    vparce
                    with frame f-condi.
        end.
        

        view frame f-desti.  
        view frame f-produ.   
        view frame f-opcom.
        
        leave.
    end.  /* repeat */

    vpassa = yes.   

    if avail finan and vende-seguro and
       vfincod > 0
    then do:
        
        run p-atu-frame.
        
        run gercpg.
        
        pause 0.
        view frame f-desti.
        display ventra at 20 label "Entrada" 
                vparce at 20 label "Parcela"
                with frame f-condi.
        pause 0.         

        if vsegtipo = 31
        then message 
      "Manter vantagens da PARCELA PROTEGIDA LEBES e ainda concorrer a 5000"
      "mensais?"
                            update sresp.
        else if vsegtipo = 41
            then message
      "Quer concorrer a 5000 mensais e ainda ter sua parcela protegida Lebes?"
                            update sresp.
        if not sresp
        then do.
            run seguroprestamista (0, 0, 0,
                                               output vsegtipo,
                                               output vsegprest,
                                               output vsegvalor).
            run p-atu-frame.
            run gercpg.
            pause 0.
            disp ventra
                 vparce with frame f-condi.
            pause 0.
        end.

    end.

    /*****/
    
    sresp = yes. 
    do /*on error undo*/:  
        identificador = "".  
        if vfincod = 0  and vclicod = 0
        then vclicod = 1.
        /**    
        else do: 
            vclicod = 0. 
        end.     
        **/
        if vfincod <> 0 and vclicod = 1 
        then do: 
            message "Cliente Invalido". 
            undo, retry.
        end. 
        
        find clien where clien.clicod = vclicod no-lock no-error. 
        
        if identificador <> "" 
        then display identificador with frame f-desti.                
    end.
    v-vendedor = pconsultor.

    do on error undo: 
        v-vencod = v-vendedor.
        update v-vendedor with  frame f-desti. 
        if v-vencod > 0 and v-vendedor <> v-vencod
        then do:
            message " Vendedor nao pode ser alterado.".
            v-vendedor = v-vencod.
            undo.
        end.
        find func where func.funcod = v-vendedor and 
                        func.etbcod = setbcod no-lock no-error.
        if not avail func 
        then do: 
            message "Codigo do Funcionario invalido". 
            undo, retry.
        end.
    
        disp v-vendedor 
             func.funnom with frame f-desti. 
    
        v-vencod = v-vendedor. 
    
        for each wf-movim. 
            wf-movim.vencod = func.funcod. 
        end.
    end. 
end.

if not avail finan 
then undo, leave bl-plano.


sparam = "".
run baggerpre.p (input recid(finan), 
              input recid(clien), 
              input vbonus, 
              input v-numero, 
              input vprotot, 
              input ( if vdevval > vprotot 
                      then vprotot 
                      else vdevval ),
              input vdevval, 
              input v-serie, 
              output rec-plani, 
              input  identificador, 
              input (if ventra-ori > 0 and
                        ventra-ori <> ventra
                     then ventra else 0) /* Entrada diferenciada */,
              input vmoecod,
              input "" /*BAGvinfo-VIVO*/).
    
if keyfunction(lastkey) = "END-ERROR"
then do:
    for each ant-movim no-lock:
        find first wf-movim where wf-movim.wrec = ant-movim.wrec
                   no-error.
        if avail wf-movim
        then do:
            buffer-copy ant-movim to wf-movim.
        end.
    end.
    run p-atu-frame.
    undo.              
end.

if sparam = "voltar"
then undo.
        
find plani where recid(plani) = rec-plani no-lock no-error. 

if plani.notass > 0
then do:
    vpassa = yes.
    /*BAG
    if etb-entrega <> 0 and
       etb-entrega <> setbcod and
       (setbcod = 140 or /* P2K Entrega em outra loja */
        setbcod = 162)    /* LOJA SC */
    then vpassa = no.
    */
    
    if vpassa
    then do. 
        /* programa para gerar prevenda para o P2K  */ 
        run bagpedido.p (pidbag, rec-plani, par-campanha, par-valordescontocupom). 
        vok = yes.
        
        message color red/with
            skip
            "PREVENDA GERADA:" string(plani.notass,">>>>9")
            skip
            "RESGATE P2K:" string(plani.numero)
            skip(1)
            "BAG" pidbag 
            view-as alert-box title "".
    end.
    else message color red/with
            skip
            "PREVENDA GERADA : " string(plani.notass,">>>>9")
            skip(1)
            view-as alert-box title "".
end.
for each wf-movim. 
    delete wf-movim. 
end.
for each ant-movim.
    delete ant-movim.
end.            
v-vendedor = 0. 
v-vencod   = 0. 
identificador    = "". 
clear frame f-desti  no-pause. 
clear frame f-produ  no-pause. 
clear frame f-produ1 no-pause.


