/* helio 29/11/2021 - substituicao do rest-barramento.p pelo curl */ 

{admcab.i}
             
/* CHAMADA AO BARRAMENTO */
{wc-consultaestoque.i new}

def var vprocod as dec format ">>>>>>>>>>>>9".
    def var vdisponivel like estoq.estatual.
    def var vest-filial like estoq.estatual.

def temp-table wpro no-undo
    field etbcod like estab.etbcod column-label "Fil" format ">>9"
    field munic  like estab.munic format "x(20)" column-label "Cidade"
    field qtdDisponivel as int  format "->>>>>9" 
                         column-label  " Dispon"
    field qtdBloqueado as int   format "->>>>>9" 
                         column-label  " Bloque"

    field qtdTransito   as int  format "->>>>>9" 
                         column-label  "Transit"
    field qtdTransferencia as int format "->>>>>9" 
                         column-label    "Transf"
    field qtdDisponivelConsignado as int format "->>>>>9" 
                                  column-label  " Consig"
    field total as int          format "->>>>>9" 
                         column-label  "  Total"
    index idx is unique primary etbcod desc.


def var v-imagem as char.

def var recatu1         as recid.
def var recatu2         as recid.
def var reccont         as int.
def var esqpos1         as int.
def var esqpos2         as int.
def var esqregua        as log.
def var esqvazio        as log.
def var esqascend     as log initial yes.
def var esqcom1         as char format "x(12)" extent 5
    initial [" "," "," "," "," "].
def var esqcom2         as char format "x(12)" extent 5
            initial [" "," ","","",""].
def var esqhel1         as char format "x(80)" extent 5
    initial [" ",
             " ",
             " ",
             " ",
             " "].
def var esqhel2         as char format "x(12)" extent 5
   initial ["  ",
            " ",
            " ",
            " ",
            " "].

def buffer bwpro       for wpro.
def var vwpro         like wpro.etbcod.


form
    esqcom1
    with frame f-com1
                 /*row 4*/ no-box no-labels side-labels column 1 centered.
form
    esqcom2
    with frame f-com2
                 row screen-lines no-box no-labels side-labels column 1
                 centered.



def buffer bestoq for estoq.

define variable wcod as integer format "999999".
form
    with frame frame-a.
    
repeat:

    for each wpro:
        delete wpro.
    end.
    clear frame f1 no-pause.
    vprocod = 0.
    
    update vprocod  label "Produto" 
           with side-labels width 80 
                frame f1 title " Produto " row 4 no-validate.

    find produ where produ.procod = int(vprocod) no-lock no-error.
    if not avail produ
    then do:
        find first produ where produ.proindice = string(vprocod) 
                    no-lock no-error.
        if not avail produ
        then do:
            message "Produto nao Cadastrado".
            undo, retry.
        end.
        else display produ.procod @ vprocod with frame f1.
    end.  
                        

    display produ.pronom no-label format "x(35)" 
            produ.prodtcad  format "99/99/9999" label "Dt.Cad"
                with frame f1.
                                  

    find categoria where categoria.catcod = produ.catcod no-lock.
    disp produ.catcod label "Dep...." 
         categoria.catnom  format "x(12)" no-label with frame f1.
    
    disp produ.datexp format "99/99/9999" 
            label "DatExp" colon 66 with frame f1.
         
    find first bestoq where bestoq.procod = produ.procod no-lock.
    
    display 
            bestoq.estvenda label "P.Venda"
                with frame f1.

    run pesquisa.

    disp 

                vest-filial label "Estoque Filial" format "->>>,>>9"
            vdisponivel colon 66 label "Disponivel Dep"     format "->>>,>>9"
                with frame f1.
    color disp messages vest-filial with frame f1.
    
    find first wpro no-error.
    if avail wpro
    then run esquema.
    
end.

procedure pesquisa.


    for each wpro.
        delete wpro.
    end.        
    /* CHAMADA AO BARRAMENTO */
    run wc-consultaestoque.p (0, int(vprocod)).

    find first ttestoque no-error.
    if not avail ttestoque
    then do:
        find first ttretorno no-error.
        if avail ttretorno
        then do:
            hide message no-pause.
            message " barramento consultaestoque" ttretorno.tstatus ttretorno.descricao.
            pause 2 no-message.
        end.
        return.
    end.

 for each ttestoque.
    create wpro.
    wpro.etbcod = int(ttestoque.codigoEstabelecimento).
    find estab where estab.etbcod = wpro.etbcod no-lock. 
    wpro.munic = estab.munic.

    wpro.qtdDisponivel  = int(ttestoque.qtdDisponivel).
    wpro.qtdBloqueado   = int(ttestoque.qtdBloqueado).
    wpro.qtdTransito    = int(ttestoque.qtdTransito).
    wpro.qtdTransferencia = int(ttestoque.qtdTransferencia).
    wpro.qtdDisponivelConsignado = int(ttestoque.qtdDisponivelConsignado).
    wpro.total  = int(ttestoque.total).        

 end.
 
        vdisponivel = 0.
        for each ttestoque where int(codigoEstabelecimento) <> setbcod and
                                 int(codigoEstabelecimento) > 900.
            vdisponivel = vdisponivel + int(ttestoque.qtdDisponivel).
        end.            
        find first ttestoque where int(codigoEstabelecimento) = setbcod no-error.
        vest-filial = if avail ttestoque
                      then int(ttestoque.qtdDisponivel)
                      else 0.

                      
end procedure.


procedure esquema.

assign
    esqregua = yes
    esqpos1  = 1
    esqpos2  = 1.
recatu1 = ?.

bl-princ:
repeat:

/*    disp esqcom1 with frame f-com1.
    disp esqcom2 with frame f-com2. */
    if recatu1 = ?
    then
        run leitura (input "pri").
    else
        find wpro where recid(wpro) = recatu1 no-lock.
    if not available wpro
    then esqvazio = yes.
    else esqvazio = no.
    clear frame frame-a all no-pause.
    if not esqvazio
    then do:
        run frame-a.
    end.

    recatu1 = recid(wpro).
    if esqregua
    then color display message esqcom1[esqpos1] with frame f-com1.
    else color display message esqcom2[esqpos2] with frame f-com2.
    if not esqvazio
    then repeat:
        run leitura (input "seg").
        if not available wpro
        then leave.
        if frame-line(frame-a) = frame-down(frame-a)
        then leave.
        down
            with frame frame-a.
        run frame-a.
    end.
    if not esqvazio
    then up frame-line(frame-a) - 1 with frame frame-a.

    repeat with frame frame-a:

        if not esqvazio
        then do:
            find wpro where recid(wpro) = recatu1 no-lock.

            status default
                if esqregua
                then esqhel1[esqpos1] + if esqpos1 > 1 and
                                           esqhel1[esqpos1] <> ""
                                        then  string(wpro.munic)
                                        else ""
                else esqhel2[esqpos2] + if esqhel2[esqpos2] <> ""
                                        then string(wpro.munic)
                                        else "".
            run color-message.
            choose field wpro.etbcod help ""
                go-on(cursor-down cursor-up
                      cursor-left cursor-right
                      page-down   page-up
                      tab PF4 F4 ESC return) color white/black.
            run color-normal.
            status default "".

        end.
            if keyfunction(lastkey) = "TAB"
            then do:
                if esqregua
                then do:
                    color display normal esqcom1[esqpos1] with frame f-com1.
                    color display message esqcom2[esqpos2] with frame f-com2.
                end.
                else do:
                    color display normal esqcom2[esqpos2] with frame f-com2.
                    color display message esqcom1[esqpos1] with frame f-com1.
                end.
                esqregua = not esqregua.
            end.
            if keyfunction(lastkey) = "cursor-right"
            then do:
                if esqregua
                then do:
                    color display normal esqcom1[esqpos1] with frame f-com1.
                    esqpos1 = if esqpos1 = 5 then 5 else esqpos1 + 1.
                    color display messages esqcom1[esqpos1] with frame f-com1.
                end.
                else do:
                    color display normal esqcom2[esqpos2] with frame f-com2.
                    esqpos2 = if esqpos2 = 5 then 5 else esqpos2 + 1.
                    color display messages esqcom2[esqpos2] with frame f-com2.
                end.
                next.
            end.
            if keyfunction(lastkey) = "cursor-left"
            then do:
                if esqregua
                then do:
                    color display normal esqcom1[esqpos1] with frame f-com1.
                    esqpos1 = if esqpos1 = 1 then 1 else esqpos1 - 1.
                    color display messages esqcom1[esqpos1] with frame f-com1.
                end.
                else do:
                    color display normal esqcom2[esqpos2] with frame f-com2.
                    esqpos2 = if esqpos2 = 1 then 1 else esqpos2 - 1.
                    color display messages esqcom2[esqpos2] with frame f-com2.
                end.
                next.
            end.
            if keyfunction(lastkey) = "page-down"
            then do:
                do reccont = 1 to frame-down(frame-a):
                    run leitura (input "down").
                    if not avail wpro
                    then leave.
                    recatu1 = recid(wpro).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "page-up"
            then do:
                do reccont = 1 to frame-down(frame-a):
                    run leitura (input "up").
                    if not avail wpro
                    then leave.
                    recatu1 = recid(wpro).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "cursor-down"
            then do:
                run leitura (input "down").
                if not avail wpro
                then next.
                color display white/red 
                        wpro.etbcod 
                        wpro.munic with frame frame-a.
                if frame-line(frame-a) = frame-down(frame-a)
                then scroll with frame frame-a.
                else down with frame frame-a.
            end.
            if keyfunction(lastkey) = "cursor-up"
            then do:
                run leitura (input "up").
                if not avail wpro
                then next.
                color display white/red 
                    wpro.etbcod
                    wpro.munic with frame frame-a.
                if frame-line(frame-a) = 1
                then scroll down with frame frame-a.
                else up with frame frame-a.
            end.
 
        if keyfunction(lastkey) = "end-error"
        then leave bl-princ.

        if keyfunction(lastkey) = "return" or esqvazio
        then do:
            form wpro
                 with frame f-wpro color black/cyan
                      centered side-label row 5 .
            hide frame frame-a no-pause.
            if esqregua
            then do:
                display caps(esqcom1[esqpos1]) @ esqcom1[esqpos1]
                        with frame f-com1.
            end.
            else do:
                display caps(esqcom2[esqpos2]) @ esqcom2[esqpos2]
                        with frame f-com2.
                if esqcom2[esqpos2] = "  "
                then do:
                    hide frame f-com1  no-pause.
                    hide frame f-com2  no-pause.
                    /* run programa de relacionamento.p (input ). */
                    view frame f-com1.
                    view frame f-com2.
                end.
                leave.
            end.
        end.
        if not esqvazio
        then do:
            run frame-a.
        end.
        if esqregua
        then display esqcom1[esqpos1] with frame f-com1.
        else display esqcom2[esqpos2] with frame f-com2.
        recatu1 = recid(wpro).
    end.
    if keyfunction(lastkey) = "end-error"
    then do:
        view frame fc1.
        view frame fc2.
    end.
end.
hide frame f-com1  no-pause.
hide frame f-com2  no-pause.
hide frame frame-a no-pause.

end procedure.

procedure frame-a.
display 
        wpro
        with frame frame-a 6 down centered.

end procedure.

procedure color-message.
color display message
        wpro.etbcod
        wpro.munic
        with frame frame-a.
    hide message no-pause.


end procedure.

procedure color-normal.
color display normal
        wpro.etbcod
        wpro.munic
        with frame frame-a.
end procedure.




procedure leitura . 
def input parameter par-tipo as char.
        
if par-tipo = "pri" 
then  
    if esqascend  
    then  
        find first wpro where true
                                                no-lock no-error.
    else  
        find last wpro  where true
                                                 no-lock no-error.
                                             
if par-tipo = "seg" or par-tipo = "down" 
then  
    if esqascend  
    then  
        find next wpro  where true
                                                no-lock no-error.
    else  
        find prev wpro   where true
                                                no-lock no-error.
             
if par-tipo = "up" 
then                  
    if esqascend   
    then   
        find prev wpro where true  
                                        no-lock no-error.
    else   
        find next wpro where true 
                                        no-lock no-error.
        
end procedure.
         


