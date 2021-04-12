function [J] = Jacobiana(Barras,linhas,conjK,G,B,V,Teta)


%Lógica do H: sempre que identifica uma PQ ou PV, indica uma função P a ser dervidada. Assim, o segundo for busca os tetas, isso ocorre quando encontra uma PQ ou uma PV
%Lógica do N: sempre que identifica uma PQ ou PV, indica uma função P a ser derivada. Assim, o segundo for busca os Vs, isso ocorre quando encontra uma PQ.
%Lógica do M: sempre que identifica uma PQ, indica uma função Q a ser derivada. Assim, o segundo for busca os tetas, isso ocorre quando encontra uma PQ ou PV.
%Lógica do L: sempre que identifica uma PQ, indica uma função Q a ser derivada. Assim, o segundo for busca os V's, isso ocorre quando encontra uma PQ.


indicelinhaH = 1;
indicecolunaH = 1;
indicelinhaN = 1;
indicecolunaN = 1;
indicelinhaM = 1;
indicecolunaM = 1;
indicelinhaL = 1;
indicecolunaL = 1;
for i = 1:linhas;
    if(Barras(i,2)) == 2;
        for m = 1:linhas;
            if(Barras(m,2)) == 2;
                if (m == i);
                    H(indicelinhaH,indicecolunaH) = Hkk(i,conjK,G,B,V,Teta);
                    N(indicelinhaN,indicecolunaN) = Nkk(i,conjK,G,B,V,Teta);
                    M(indicelinhaM,indicecolunaM) = Mkk(i,conjK,G,B,V,Teta);
                    L(indicelinhaL,indicecolunaL) = Lkk(i,conjK,G,B,V,Teta);
                    indicecolunaH = indicecolunaH + 1;
                    indicecolunaN = indicecolunaN + 1;
                    indicecolunaM = indicecolunaM + 1;
                    indicecolunaL = indicecolunaL + 1;
                    
                else
                    H(indicelinhaH,indicecolunaH) = Hkm(i,m,G,B,V,Teta);
                    N(indicelinhaN,indicecolunaN) = Nkm(i,m,G,B,V,Teta);
                    M(indicelinhaM,indicecolunaM) = Mkm(i,m,G,B,V,Teta);
                    L(indicelinhaL,indicecolunaL) = Lkm(i,m,G,B,V,Teta);
                    indicecolunaH = indicecolunaH + 1;
                    indicecolunaN = indicecolunaN + 1;
                    indicecolunaM = indicecolunaM + 1;
                    indicecolunaL = indicecolunaL + 1;
                end
            elseif(Barras(m,2)) == 3;
                    H(indicelinhaH,indicecolunaH) = Hkm(i,m,G,B,V,Teta);
                    M(indicelinhaM,indicecolunaM) = Mkm(i,m,G,B,V,Teta);
                    indicecolunaH = indicecolunaH + 1;
                    indicecolunaM = indicecolunaM + 1;
            end
        end
        indicelinhaH = indicelinhaH + 1;
        indicecolunaH = 1;
        indicelinhaN = indicelinhaN + 1;
        indicecolunaN = 1;
        indicelinhaM = indicelinhaM + 1;
        indicecolunaM = 1;
        indicelinhaL = indicelinhaL + 1;
        indicecolunaL = 1;
    elseif(Barras(i,2)) == 3;
        for m = 1:linhas;
            if(Barras(m,2)) == 2;
                    H(indicelinhaH,indicecolunaH) = Hkm(i,m,G,B,V,Teta);
                    N(indicelinhaN,indicecolunaN) = Nkm(i,m,G,B,V,Teta);
                    indicecolunaH = indicecolunaH + 1;
                    indicecolunaN = indicecolunaN + 1;
            elseif(Barras(m,2) == 3);
                if (m == i);
                    H(indicelinhaH,indicecolunaH) = Hkk(i,conjK,G,B,V,Teta); 
                    indicecolunaH = indicecolunaH + 1;
                else
                    H(indicelinhaH,indicecolunaH) = Hkm(i,m,G,B,V,Teta);
                    indicecolunaH = indicecolunaH + 1;
                end
            end
        end
        indicelinhaH = indicelinhaH + 1;
        indicecolunaH = 1;
        indicelinhaN = indicelinhaN + 1;
        indicecolunaN = 1;
    end
end

J = [H N; M L]