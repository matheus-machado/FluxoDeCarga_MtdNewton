function [H] = H_Jacob_Linha(Barras,linhas,conjK,G,B,V,Teta)


%Lógica do H: sempre que identifica uma PQ ou PV, indica uma função P a ser dervidada. Assim, o segundo for busca os tetas, isso ocorre quando encontra uma PQ ou uma PV

indicelinhaH = 1;
indicecolunaH = 1;
for i = 1:linhas;
    if(Barras(i,2)) == 2;
        for m = 1:linhas;
            if(Barras(m,2)) == 2;
                if (m == i);
                    H(indicelinhaH,indicecolunaH) = Hkk_Linha(i,conjK,G,B,V,Teta);
                    indicecolunaH = indicecolunaH + 1;
                    
                else
                    H(indicelinhaH,indicecolunaH) = Hkm_Linha(i,m,G,B,V,Teta);
                    indicecolunaH = indicecolunaH + 1;
                end
            elseif(Barras(m,2)) == 3;
                    H(indicelinhaH,indicecolunaH) = Hkm_Linha(i,m,G,B,V,Teta);
                    indicecolunaH = indicecolunaH + 1;
            end
        end
        indicelinhaH = indicelinhaH + 1;
        indicecolunaH = 1;
    elseif(Barras(i,2)) == 3;
        for m = 1:linhas;
            if(Barras(m,2)) == 2;
                    H(indicelinhaH,indicecolunaH) = Hkm_Linha(i,m,G,B,V,Teta);
                    indicecolunaH = indicecolunaH + 1;
            elseif(Barras(m,2) == 3);
                if (m == i);
                    H(indicelinhaH,indicecolunaH) = Hkk_Linha(i,conjK,G,B,V,Teta); 
                    indicecolunaH = indicecolunaH + 1;
                else
                    H(indicelinhaH,indicecolunaH) = Hkm_Linha(i,m,G,B,V,Teta);
                    indicecolunaH = indicecolunaH + 1;
                end
            end
        end
        indicelinhaH = indicelinhaH + 1;
        indicecolunaH = 1;
    end
end

