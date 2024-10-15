def var vdir as char.
def var ptoday as date.
def var pfull  as log.
def var varquivo as char.
def var vi as int.
def var setbcod as int.
def var funcao as char.
def var parametro as char.

vdir = "/tmp/".
ptoday = today.
pfull = no.

def temp-table tt-produ no-undo like produ.
def temp-table tt-estoq no-undo like estoq.
def temp-table tt-produaux no-undo like produaux.
def temp-table tt-clafis no-undo like clafis.
def temp-table tt-func no-undo like func.
def var vtime as int.
vtime = time.

input from ./admcom.ini.
repeat:
    import delimiter " " funcao parametro.
    if funcao = "ESTAB"
    then setbcod = int(parametro).
end.
input close.

if search(vdir + "rodando." + string(ptoday,"99999999") + ".lk") <> ?
then do:
    message today string(time,"HH:MM:SS") "PROCESSAO SENDO EXECUTADO".
    quit.
end.

if search(vdir + "carga." + string(ptoday,"99999999") + ".zip") = ?
then do:
    message today string(time,"HH:MM:SS") "ARQUIVO INEXISTENTE".
    quit.
end.
message setbcod ptoday string(time,"HH:MM:SS") "INICIO".

unix silent 
value("cd " + vdir + "; unzip -q carga." + string(ptoday,"99999999") + ".zip ").

output to value(vdir + "rodando." + string(ptoday,"99999999") + ".lk").
put "RODANDO".
output close.


varquivo = vdir + "operadoras" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of operadoras.
    for each operadoras .
        delete operadoras.
    end.    
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create operadoras.
        import operadoras.
        vi = vi + 1.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

varquivo = vdir + "promoviv" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of promoviv.
    for each promoviv .
        delete promoviv.
    end.    
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create promoviv.
        import promoviv.
        vi = vi + 1.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

varquivo = vdir + "planoviv" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of planoviv.
    for each planoviv .
        delete planoviv.
    end.    
    vi - 0.
    input from value(varquivo).
    repeat transaction.
        create planoviv.
        import planoviv.
        vi = vi + 1.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

varquivo = vdir + "proplaviv" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of proplaviv.
    for each proplaviv .
        delete proplaviv.
    end.    
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create proplaviv.
        import proplaviv.
        vi = vi + 1.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

varquivo = vdir + "bonusviv" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of bonusviv.
    for each bonusviv .
        delete bonusviv.
    end.    
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create bonusviv.
        import bonusviv.
        vi = vi + 1.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

varquivo = vdir + "plaviv" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of plaviv.
    for each plaviv .
        delete plaviv.
    end.    
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create plaviv.
        import plaviv.
        vi = vi + 1.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

varquivo = vdir + "plaviv_filial" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of plaviv_filial.
    for each plaviv_filial .
        delete plaviv_filial.
    end.    
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create plaviv_filial.
        import plaviv_filial.
        vi = vi + 1.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

varquivo = vdir + "fincla" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of fincla.
    for each fincla .
        delete fincla.
    end.    
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create fincla.
        import fincla.
        vi = vi + 1.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

varquivo = vdir + "finesp" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of finesp.
    for each finesp .
        delete finesp.
    end.    
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create finesp.
        import finesp.
        vi = vi + 1.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

varquivo = vdir + "finfab" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of finfab.
    for each finfab .
        delete finfab.
    end.    
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create finfab.
        import finfab.
        vi = vi + 1.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

varquivo = vdir + "finpro" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of finpro.
    for each finpro .
        delete finpro.
    end.    
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create finpro.
        import finpro.
        vi = vi + 1.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

varquivo = vdir + "ctpromoc" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of ctpromoc.
    for each ctpromoc .
        delete ctpromoc.
    end.    
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create ctpromoc.
        import ctpromoc.
        vi = vi + 1.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

varquivo = vdir + "produ" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of produ.
    if pfull
    then do:
        for each produ .
            delete produ.
        end.    
    end.
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create tt-produ.
        import {/usr/admcom/progr/crgprodu.i tt-produ}.
        find produ where produ.proindice = tt-produ.proindice no-error.
        if avail produ
        then do:
            delete produ.
        end.
        find produ where produ.procod = tt-produ.procod no-error.
        if not avail produ then do:
            create produ.
            produ.procod = tt-produ.procod.
        end.
        buffer-copy tt-produ except procod to produ.    
        vi = vi + 1.
        delete tt-produ.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

varquivo = vdir + "clase" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of clase.
    for each clase .
        delete clase validate(true,"").
    end.    
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create clase.
        import clase.
        vi = vi + 1.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

varquivo = vdir + "unida" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of unida.
    for each unida .
        delete unida.
    end.    
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create unida.
        import unida.
        vi = vi + 1.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

varquivo = vdir + "estoq" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of estoq.
    if pfull
    then do:
        for each estoq .
            delete estoq.
        end.    
    end.
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create tt-estoq.
        import {/usr/admcom/progr/crgestoq.i tt-estoq}.
        if tt-estoq.etbcod <> setbcod
        then do:
            delete tt-estoq.
            next.
        end.
        find estoq where estoq.procod = tt-estoq.procod and 
                         estoq.etbcod = tt-estoq.etbcod no-error.
        if not avail estoq then do:
            create estoq.
            estoq.procod = tt-estoq.procod.
            estoq.etbcod = tt-estoq.etbcod.
        end.
        buffer-copy tt-estoq except etbcod procod to estoq.    
        vi = vi  + 1.
        delete tt-estoq.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

varquivo = vdir + "produaux" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of produaux.
    if pfull
    then do:
        for each produaux .
            delete produaux.
        end.    
    end.
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create tt-produaux.
        import tt-produaux.
        find first produaux where produaux.procod     = tt-produaux.procod and
                            produaux.nome_campo = tt-produaux.nome_campo
                            no-error.
        if not avail produaux then do:
            create produaux.
            produaux.procod = tt-produaux.procod.
            produaux.nome_campo = tt-produaux.nome_campo.
        end.
        buffer-copy tt-produaux except procod nome_campo to produaux.    
        vi = vi + 1.
        delete tt-produaux.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

varquivo = vdir + "clafis" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of clafis.
    if pfull
    then do:
        for each clafis .
            delete clafis.
        end.    
    end.
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create tt-clafis.
        import tt-clafis.
        find clafis where clafis.codfis = tt-clafis.codfis no-error.
        if not avail clafis then do:
            create clafis.
            clafis.codfis = tt-clafis.codfis.
        end.
        buffer-copy tt-clafis except codfis to clafis.    
        vi = vi + 1.
        delete tt-clafis.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    



varquivo = vdir + "cpag" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of cpag.
    for each cpag .
        delete cpag.
    end.    
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create cpag.
        import cpag.
        vi = vi + 1.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

varquivo = vdir + "finan" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of finan.
    for each finan .
        delete finan.
    end.    
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create finan.
        import finan.fincod  
             finan.finnom 
             finan.finent 
             finan.finnpc 
             finan.finfat 
             finan.datexp.
        vi = vi + 1.     
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

varquivo = vdir + "func" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of func.
    if pfull
    then do:
        for each func .
            delete func.
        end.    
    end.
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create tt-func.
        import {/usr/admcom/progr/crgfunc.i tt-func}.
        find func where func.funcod = tt-func.funcod and
                        func.etbcod = tt-func.etbcod no-error.
        if not avail func then do:
            create func.
            func.funcod = tt-func.funcod.
            func.etbcod = tt-func.etbcod.
        end.
        buffer-copy tt-func except funcod etbcod to func.    
        vi = vi + 1.
        delete tt-func.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

varquivo = vdir + "estab" + "." + string(ptoday,"99999999") + ".d".
if search(varquivo) <> ?
then do: 
    message setbcod ptoday string(time,"HH:MM:SS") varquivo "INICIO".
    disable triggers for load of estab.
    for each estab .
        delete estab.
    end.    
    vi = 0.
    input from value(varquivo).
    repeat transaction.
        create estab.
        import {/usr/admcom/progr/crgestab.i estab}.
        vi = vi + 1.
    end.    
    output close.
    message setbcod ptoday string(time,"HH:MM:SS") varquivo vi.
    unix silent value("rm -f " + varquivo).
end.    

unix silent value("rm -f " + vdir + "rodando." + string(ptoday,"99999999") + ".lk").

message setbcod ptoday string(time,"HH:MM:SS") string(time - vtime,"HH:MM:SS") "FIM".

