{admcab.i}
def input param pcpf as dec.
def input param pclicod as int.
def input param pconsultor as int.
def input param precid as recid.
def output param pok as log.
pok = no.
def new shared var vdata-teste-promo as date init ?.

{apibusca-garantia.i}
{inc-def-pre-gea.i new}
{dftempWG.i new}
def new shared var etb-entrega like setbcod.
def new shared var dat-entrega as date.
def new shared var dat-entrega1 as date.
def new shared var p-dtentra as date.
def new shared var p-dtparcela as date.
def new shared var nome-retirada as char format "x(30)".
def new shared var fone-retirada as char format "x(15)".

def new shared var pmoeda as char format "x(30)".
def new shared var vplanocota as int. /* helio 02082023 */
def new shared var p-supervisor as char.
def new shared temp-table tt-liped like liped.
def new shared temp-table tt-senauto
    field procod     like produ.procod
    field preco-ori  like movim.movpc
    field desco      as   log init no
    field senauto    as   dec format ">>>>>>>>>>"
    index i-pro is primary unique procod.
def new shared temp-table tt-prodesc
    field procod     like produ.procod
    field preco      like movim.movpc
    field preco-ven  like movim.movpc
    field desco  as   log.

def new shared temp-table Black_Friday
    field numero as int
    field valor as dec
    field desconto as log init no
    field pctdes as dec.    
/**** fim parametros BLACK FRIDAY  ****/

def new shared temp-table tt-cartpre
    field seq    as int
    field numero as int
    field valor  as dec.

def new shared temp-table tt-planos-vivo
    field procod like produ.procod
    field tipviv as   int
    field codviv as   int
    field pretab as   dec
    field prepro as   dec.

def new shared temp-table wf-imei
    field wrec      as recid
    field imei      as char.



{garan-rfq.i new} /* garantia rfq */
def new shared temp-table tt-seguroPrestamista no-undo
    field wrec          as recid
    field procod        as int.

def buffer bseg-produ for produ.

find first ttitensnota where recid(ttitensnota) = precid.
def var ctitle as char.
ctitle = "GARANTIA ESTENDIDA AVUILSA " + if pcpf = ? then "" else string(pcpf).
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
    pause 0.    

    def var vdataTransacao as date format "99/99/9999".
    vdataTransacao = date(
                                int(entry(2,ttitensnota.dataTransacao,"-")),
                                int(entry(3,ttitensnota.dataTransacao,"-")),
                                int(entry(1,ttitensnota.dataTransacao,"-"))
                            ).
/*     
    disp
     codigoLoja    label "Fil" colon 16 vdataTransacao @ dataTransacao label "data"  numeroComponente label "caixa"  nsuTransacao   label "nsu" 
     cpfCnpjNfe     label "cpf" format "x(14)" colon 16 codigoCliente  label "cliente" 
     numeroNfe      label "nota" colon 16 serieNfe       label "serie"  numeroCupom    label "cupom" 
     codigoProduto  label "produto" colon 16 descricaoProduto format "x(40)" no-label
     qtdVendidaProduto  label "qtd" colon 16 valorUnitarioProduto  label "Preco"  valorTotalProduto  label "total" 
     valorDescontoProduto  label "desconto" colon 16 prazoGarantiaFabricanteProduto  label "prazo" 
    with frame fdet
        row 6 side-labels overlay.
    pause 0.        
  */
run vende-segprod (input int(ttitensnota.codigoproduto), 
                   input dec(ttitensnota.valorUnitarioProduto),
                   input dec(ttitensnota.valorUnitarioProduto)). 


def var recatu1         as recid.
def var recatu2         as recid.
def var reccont         as int.
def var esqvazio        as log.
def var esqpos1         as int.
def var esqcom1         as char format "x(12)" extent 5
    initial [" Fecha ", " ", " ", "",""].

form
    esqcom1
    with frame f-com1 row 5 no-box no-labels column 1 centered.
assign
    esqpos1  = 1.

for each tt-seg-movim.
    if tt-seg-movim.seg-procod = 8011 or 
       tt-seg-movim.seg-procod = 8012
    then next.
    find first wf-movim where recid(wf-movim) = tt-seg-movim.recid-wf-movim.
    delete wf-movim.
    delete tt-seg-movim.
end.


bl-princ:
repeat:
    disp esqcom1 with frame f-com1.
    if recatu1 = ?
    then run leitura (input "pri").
    else find tt-seg-movim where recid(tt-seg-movim) = recatu1 no-lock.
    if not available tt-seg-movim
    then do.
        message "Produto nao Disponivel para venda de Garantia Avulsa" view-as alert-box.
        
        return.
    end.
    else esqvazio = no.
    clear frame frame-a all no-pause.
    if not esqvazio
    then run frame-a.

    recatu1 = recid(tt-seg-movim).
    color display message esqcom1[esqpos1] with frame f-com1.
    if not esqvazio
    then repeat:
        run leitura (input "seg").
        if not available tt-seg-movim
        then leave.
        if frame-line(frame-a) = frame-down(frame-a)
        then leave.
        down with frame frame-a.
        run frame-a.
    end.
    if not esqvazio
    then up frame-line(frame-a) - 1 with frame frame-a.

    repeat with frame frame-a:

        if not esqvazio
        then do:
            find tt-seg-movim where recid(tt-seg-movim) = recatu1 no-lock.
            find bseg-produ where bseg-produ.procod = tt-seg-movim.seg-procod
                            no-lock.

            status default "".
            run color-message.
            choose field bseg-produ.procod help ""
                go-on(cursor-down cursor-up
                      cursor-left cursor-right
                      page-down   page-up
                      PF4 F4 ESC return).
            run color-normal.
            status default "".
        end.

            if keyfunction(lastkey) = "cursor-right"
            then do:
                color display normal esqcom1[esqpos1] with frame f-com1.
                esqpos1 = if esqpos1 = 5 then 5 else esqpos1 + 1.
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
                    if not avail tt-seg-movim
                    then leave.
                    recatu1 = recid(tt-seg-movim).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "page-up"
            then do:
                do reccont = 1 to frame-down(frame-a):
                    run leitura (input "up").
                    if not avail tt-seg-movim
                    then leave.
                    recatu1 = recid(tt-seg-movim).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "cursor-down"
            then do:
                run leitura (input "down").
                if not avail tt-seg-movim
                then next.
                color display white/red bseg-produ.procod with frame frame-a.
                if frame-line(frame-a) = frame-down(frame-a)
                then scroll with frame frame-a.
                else down with frame frame-a.
            end.
            if keyfunction(lastkey) = "cursor-up"
            then do:
                run leitura (input "up").
                if not avail tt-seg-movim
                then next.
                color display white/red bseg-produ.procod with frame frame-a.
                if frame-line(frame-a) = 1
                then scroll down with frame frame-a.
                else up with frame frame-a.
            end.
 
        if keyfunction(lastkey) = "end-error"
        then leave bl-princ.

        if keyfunction(lastkey) = "return" or esqvazio
        then do:
            form
                bseg-produ.procod   colon 15 label "Seguro"
                bseg-produ.pronom   no-label
                skip(1)
                tt-seg-movim.procod colon 15
                produ.pronom        no-label
                skip(1)
                tt-seg-movim.movpc  colon 15 format ">,>>9.99" label "Preco"
                with frame f-tt-seg-movim color black/cyan 
                        centered side-label row 5 overlay.

            /* hide frame frame-a no-pause. */

            display caps(esqcom1[esqpos1]) @ esqcom1[esqpos1]
                        with frame f-com1.

            if esqcom1[esqpos1] = " Fecha "
            then do:
                run pfecha.                  
                hide frame f-com1  no-pause.
                hide frame frame-a no-pause.
                hide frame f-desti no-pause.
                return. 
            end.


        end.
        if not esqvazio
        then run frame-a.
        display esqcom1[esqpos1] with frame f-com1.
        recatu1 = recid(tt-seg-movim).
    end.
    if keyfunction(lastkey) = "end-error"
    then do:
        view frame fc1.
        view frame fc2.
    end.
end.
hide frame f-com1  no-pause.
hide frame frame-a no-pause.


procedure frame-a.
    find bseg-produ where bseg-produ.procod = tt-seg-movim.seg-procod no-lock.
    find produ of tt-seg-movim no-lock.
    
        find first wf-movim where recid(wf-movim) = tt-seg-movim.recid-wf-movim.

    display
        bseg-produ.procod  column-label "Seguro"
        bseg-produ.pronom  format "x(23)" column-label "Descricao Seguro"
        tt-seg-movim.procod
        produ.pronom       format "x(28)"
        tt-seg-movim.movpc format ">>>9.99" column-label "Preco"
        wf-movim.movqtm    column-label "Qtd" format ">9"    
        with frame frame-a 3 down width 80 color white/red row 6
                title " Garantia Estendida / Roubo, Furto e Quebra " overlay.

end procedure.


procedure color-message.
    color display message
        bseg-produ.procod
        bseg-produ.pronom
        tt-seg-movim.procod
        produ.pronom
        with frame frame-a.
end procedure.


procedure color-normal.
    color display normal
        bseg-produ.procod
        bseg-produ.pronom
        tt-seg-movim.procod
        produ.pronom
        with frame frame-a.
end procedure.


procedure leitura.
def input parameter par-tipo as char.
        
if par-tipo = "pri" 
then find first tt-seg-movim no-lock no-error.
                                             
if par-tipo = "seg" or par-tipo = "down" 
then find next tt-seg-movim no-lock no-error.
             
if par-tipo = "up" 
then find prev tt-seg-movim no-lock no-error.

end procedure.






procedure pfecha.
def var parametro-in as char.
def var parametro-out as char.
def var vpassa as log.
def var vf5 as log.
def var vliqui as dec.
def var ventra-ori as dec.
def var vplano-ori as int.
def var ventra as dec.
def var vparce as dec.
def var vmen-pla as char.
def var block-plano as log init no.


bl-plano:
do:
    pause 0.
            update vfincod go-on (F7 f7) with frame f-desti.  

            if lastkey = keycode("F7") or
               lastkey = keycode("f7")
            then do:

                run simula_parcela_gea.p(input vprotot, 
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
            find finan where finan.fincod = vfincod no-lock.
            disp finan.fincod @ vfincod 
                 finan.finnom with frame f-desti.
            
    identificador = "GAR - " + clien.clinom.  
    disp identificador with frame f-desti.
    v-vendedor = pconsultor.
    find func where func.etbcod = setbcod and func.funcod = pconsultor no-lock.
        disp v-vendedor 
             func.funnom with frame f-desti. 
    message "confirma venda da garantia avulsa?" update sresp.
    v-serie = "P". 
    
    pok = sresp.
    if sresp
    then do on error undo, return:
        sparam = "".
        run gerpre.p (input recid(finan), 
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
              input "",
              input "").

        find plani where recid(plani) = rec-plani no-lock no-error. 
        if plani.notass > 0
        then do:
            run p2k_geraped_gea.p (rec-plani, "", 0, recid(ttitensnota)). 
        
            message color red/with
                skip
                "PREVENDA GERADA:" string(plani.notass,">>>>9")
                skip
                "RESGATE P2K:" string(plani.numero)
                view-as alert-box title "".
        end.
        else message color red/with
                skip
                "PREVENDA GERADA : " string(plani.notass,">>>>9")
                skip(1)
                view-as alert-box title "".
        pok = yes.
    end.
        
end.


end procedure.
