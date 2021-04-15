function [Teta_iterado,V_iterado,DeltaP,DeltaQ,contadorP,contadorQ] = NewtonNormalizado(Barras,linhas,conjK,G,B,V0,Teta0,EspP,EspQ,TetaVet,V_Vet,Erro)

%% Metodo de Newton Desacoplado Normalizado
contadorP = 0
contadorQ = 0
statusP = 0;
statusQ = 0;
V_iterado = V0;
Teta_iterado = Teta0;
while ((statusP == 0) || (statusQ == 0));
    
    indiceP = 1;
    for i = 1:linhas;
        if(Barras(i,2)) == 2;
            CalcP(indiceP,1) = Pcalculado(i,conjK,G,B,V_iterado,Teta_iterado);
            indiceP = indiceP + 1;
        elseif(Barras(i,2)) == 3;
            CalcP(indiceP,1) = Pcalculado(i,conjK,G,B,V_iterado,Teta_iterado);
            indiceP = indiceP + 1;
        end
    end
    %diferença para P
    DeltaP = EspP - CalcP
    
    indiceP = 1;
    for i = 1:linhas;
        if(Barras(i,2)) == 2;
            DeltaP_divi(indiceP,1) = DeltaP(indiceP,1)/V_iterado(i);
            indiceP = indiceP + 1;
        elseif(Barras(i,2)) == 3;
            DeltaP_divi(indiceP,1) = DeltaP(indiceP,1)/V_iterado(i);
            indiceP = indiceP + 1;
        end
    end
    
    
    statusP = max(abs(DeltaP_divi))<= Erro;
    if (statusP == 1);
        display('P convergiu :)')
        if (statusQ == 1)
            display('Q convergiu também :)')
            break
        else
            display(' Q não convergiu :( ')
        end
    else
        
        H = H_Jacob_Linha(Barras,linhas,conjK,G,B,V_iterado,Teta_iterado)
        TetaVet = TetaVet + inv(H)*DeltaP_divi
        contadorP = contadorP + 1;
        statusQ = 0;
        
        %Atualizar vetores de Teta
        varredura_teta = 1;
        for i = 1:linhas
            if(Barras(i,2)) == 2
                Teta_iterado(i) = TetaVet(varredura_teta); 
                varredura_teta = varredura_teta +1;
            elseif(Barras(i,2)) == 3
                Teta_iterado(i) = TetaVet(varredura_teta); 
                varredura_teta = varredura_teta +1;
            end
        end
    end
    
    
    indiceQ = 1;
    for i = 1:linhas;
        if(Barras(i,2)) == 2;
            CalcQ(indiceQ,1) = Qcalculado(i,conjK,G,B,V_iterado,Teta_iterado);
            indiceQ = indiceQ + 1;
        end
    end

    DeltaQ = EspQ - CalcQ
    
    indiceQ = 1;
    for i = 1:linhas;
        if(Barras(i,2)) == 2;
            DeltaQ_divi(indiceQ,1) = DeltaQ(indiceQ,1)/V_iterado(i);
            indiceQ = indiceQ + 1;
        end
    end
    
    statusQ = max(abs(DeltaQ_divi))<= Erro;
    if (statusQ == 1)
        display('Q convergiu :)')
        if (statusP == 1)
            display('P convergiu também :)')
            break
        else
            display(' P não convergiu :( ')
        end
    else
        L = L_Jacob_Linha(Barras,linhas,conjK,G,B,V_iterado,Teta_iterado)
        V_Vet = V_Vet + inv(L)*DeltaQ_divi
        contadorQ = contadorQ + 1;
        statusP = 0;
    
        %Atualizar vetores de V
        varredura_V = 1;
        for i = 1:linhas
            if(Barras(i,2)) == 2
                V_iterado(i)= V_Vet(varredura_V);
                varredura_V = varredura_V +1;
            end
        end
    end

  
end

   