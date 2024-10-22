def var vplanobloqueio as int.
def var vplanobloqueiomensagem as char format "x(70)". 
def var ptoken as char .
    run lojapi-cotasplanoverifica.p (input {1}, output vplanobloqueio, output vplanobloqueiomensagem,
        output psupcod,
        output pidtoken).
        if vplanobloqueio = 1
        then do: 
            if psupcod = 0
            then
            disp
                skip(1)
                    substring(vplanobloqueiomensagem,1,50) format "x(52)" skip
                    substring(vplanobloqueiomensagem,51)  format "x(52)"
                skip(1)  
                with frame favisocotas1 
                                centered no-labels
                                row 7 overlay
                                color messages.

            vok = no.
            if psupcod <> 0
            then do:
                    run message.p
                        (input-output vok,  
                        input     "          COTAS        "  + chr(10) +
                        "                                                           " + 
                         trim(substring(vplanobloqueiomensagem,1,50)) +
                         substring(vplanobloqueiomensagem,51)  + 
                        "                                        "  , 
                        input "").          
                
                if vok
                then do:
                
                                if pidtoken = ""
                                then do:
                                    run tokenuser.p (output pidtoken).
                                end.    
                                if pidtoken = "" then vok = no.
                                else do:
                                    disp pidtoken label "USUARIO" format "x(20)" colon 20 with frame ftoken .

                                    update ptoken format "x(8)" label "DIGITE O TOKEN" colon 20
                                            with row 15 overlay width 60 color messages centered
                                            title "TOKEN" side-labels frame ftoken.

                                        hide frame ftoken no-pause.
                                    run lojapi-tokenverifica.p (input pidtoken,
                                                  input ptoken,
                                          output vok).
                                if vok then do:
                                              vplanoCota = vfincod.
                                end.
                                end.


                end.
                                
            end.
            if vok = no
            then  do on endkey undo, retry : 
                hide message no-pause. 
                message "nao autorizado".
                pause 2 no-message.  
                hide frame favisocotas1 no-pause.
                vfincod = 0.
                disp vfincod  
                    "" @ finan.finnom with frame f-desti.
                undo, retry.
              end.
            
        end . 
        if vplanobloqueio = 2    
        then do: 
            disp  
                skip(1)               
                    substring(vplanobloqueiomensagem,1,50) format "x(52)" skip
                    substring(vplanobloqueiomensagem,51)  format "x(52)"
                    skip(1)    
               with frame favisocotas2 
                                centered no-labels
                                row 8 overlay.
                        
              message "(11) solicite senha do gerente".
              run senha_gerente (output vgerentelibera).  
              hide frame f-senha no-pause.
              hide frame favisocotas2 no-pause.                
              
              if not vgerentelibera 
              then do on endkey undo, retry : 
                hide message no-pause. 
                message "plano nao autorizado pelo gerente.". 
                pause 1 no-message.  
                undo, retry.
              end.
              
              vplanoCota = vfincod.
              
              
        end.
        
