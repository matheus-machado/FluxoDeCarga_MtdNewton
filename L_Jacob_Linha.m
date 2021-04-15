function [L] = L_Jacob_Linha(Barras,linhas,conjK,G,B,V,Teta)

%Lógica do L: sempre que identifica uma PQ, indica uma função Q a ser derivada. Assim, o segundo for busca os V's, isso ocorre quando encontra uma PQ.

indicelinhaL = 1;
indicecolunaL = 1;
for i = 1:linhas;
    if(Barras(i,2)) == 2;
        for m = 1:linhas;
            if(Barras(m,2)) == 2;
                if (m == i);
                    L(indicelinhaL,indicecolunaL) = Lkk_Linha(i,conjK,G,B,V,Teta);
                    indicecolunaL = indicecolunaL + 1;
                    
                else
                    L(indicelinhaL,indicecolunaL) = Lkm_Linha(i,m,G,B,V,Teta);
                    indicecolunaL = indicecolunaL + 1;
                end
            end
        end
        indicelinhaL = indicelinhaL + 1;
        indicecolunaL = 1;
    end
end
