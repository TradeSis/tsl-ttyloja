def var v-conecta as log.
def input parameter vprocod like produ.procod.
v-conecta = yes.
run le_link.p(output v-conecta).

if v-conecta
then do:

    message "Conectando, aguarde......".
    
    if connected ("commatriz")
    then disconnect commatriz.
    
    
    connect com -H erp.lebes.com.br -S sdrebcom -N tcp -ld commatriz
      no-error.

    run manda_produ1.p(input vprocod).

    disconnect commatriz.

end.