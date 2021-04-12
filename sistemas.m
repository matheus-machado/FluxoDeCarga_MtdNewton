close all
clear all

load('dados_linhas_exerc.mat')
load('Barras_exerc.mat')
prompt = 'Quantas barras temos no sistema? \n';
num_barras = input(prompt);
%valores iniciais
V0 = [1.03; 1; 1.02; 1];
Teta0 = [0; 0; 0; 0];

%% Cálculo da Matriz de Admitância
clear Matriz_Y
Matriz_Y = zeros(num_barras);
ent_int = [];
bshunt = zeros(num_barras);
Vetor = cell(1,num_barras);
conjK = cell(1,num_barras);
ligacoes = length(Dados_Linhas(:,1)) - 1;
for i = 2:length(Dados_Linhas(:,1))
    Terminal1 = Dados_Linhas{i,1};
    Terminal2 = Dados_Linhas{i,2};
    z = (Dados_Linhas{i,3} + j*Dados_Linhas{i,4});
    b = Dados_Linhas{i,5};
    
    %Laterais
    Matriz_Y(Terminal1,Terminal2) = (-1/z) +Matriz_Y(Terminal1,Terminal2);
    Matriz_Y(Terminal2, Terminal1) = (-1/z) + Matriz_Y(Terminal2, Terminal1);
    %Diagonal
   Matriz_Y(Terminal1,Terminal1) = (1/z) +((j/2)*b)+ Matriz_Y(Terminal1,Terminal1);
   Matriz_Y(Terminal2, Terminal2)  = (1/z) +((j/2)*b) + Matriz_Y(Terminal2, Terminal2);

   %Montando a matriz de b (susceptancia) que será usado futuramente
   bshunt(Terminal1,Terminal2) = b;
   
   
    %Montando o ConjK que será usado futuramente
    Vetor{Terminal1}=  [Vetor{Terminal1}; Terminal1; Terminal2];
    Vetor{Terminal2}=[Vetor{Terminal2}; Terminal1; Terminal2];

 
    ent_int = [ent_int; Terminal1 Terminal2 1/z b/2];
end
Matriz_Y

for barra = 1:4
    for conectores = 1:4
        busca = find(Vetor{barra} == conectores);
        if (length(busca)== 0)
            %fprintf('eu to aqui')
        else
            conjK{barra} = [conjK{barra}; conectores];
        end
    end
end
conjK = conjK';
bshunt = bshunt + bshunt';
%conjK{barra} = conjK{barra}';
%Y = [(2.6783-28.4590*i) (-0.8928+9.9197*i) 0 (-1.7855+19.8393*i); (-0.8928+9.9197*i) (8.1929-98.2386*i) (-3.7290+49.7203*i) (-3.5711+39.6786*i); 0 (-3.7290+49.7203*i) (3.7290-49.7203*i) 0; (-1.7855+19.8393*i) (-3.5711+39.6786*i) 0 (5.3566-58.8579*i)];

G = real(Matriz_Y);
B = imag(Matriz_Y);
%%
%Pk = Vk*som(Vm(Gkm*cos(tk - tm) + Bkm*sen(tk - tm))), som em m pertence a K
%Qk = Vk*som(Vm(Gkm*sen(tk - tm) - Bkm*cos(tk - tm))), som em m pertence a K

tolerancia = 1*10^-3;
%tabela de dados de barras
%Barras = [barra, tipo, Pg, Qg, Pc, Qc]
%tipo: 1 - slack, 2 - PQ, 3 - PV
%sem dado: 666
%Barras = [1 1 666 666 0 0; 2 2 0 0 0 0; 3 3 5.2 666 0.8 0.4; 4 2 0 0 4 1.2];
[linhas, colunas] = size(Barras);

indiceP = 1;
indiceQ = 1;
nPQ = 0;
nPV = 0;
for i = 1:linhas;
    if(Barras(i,2)) == 2;
        nPQ = nPQ + 1;
        EspP(indiceP,1) = Barras(i,3) - Barras(i,5);
        EspQ(indiceQ,1) = Barras(i,4) - Barras(i,6);
        indiceP = indiceP + 1;
        indiceQ = indiceQ + 1;
    elseif(Barras(i,2)) == 3;
        nPV = nPV + 1;
        EspP(indiceP,1) = Barras(i,3) - Barras(i,5);
        indiceP = indiceP + 1;
    end
end

%valores esperados para os Ps conhecidos, e Qs conhecidos
Esp = [EspP; EspQ]

%ligações da barra 1, 2, 3 e 4
%conjK = {[1;2;4]; [1; 2; 3; 4]; [2; 3]; [1; 2; 4]};

iT = 1;
iV = 1;
for i = 1:linhas;
    if(Barras(i,2)) == 2;
        TetaVet(iT,1) = Teta0(i);
        VVet(iV,1) = V0(i);
        iT = iT + 1;
        iV = iV + 1;
    elseif(Barras(i,2)) == 3;
        TetaVet(iT,1) = Teta0(i);
        iT = iT + 1;
    end
end
%vetor com as incógnitas        
Vetor_incog = [TetaVet; VVet]

indiceP = 1;
indiceQ = 1;
for i = 1:linhas;
    if(Barras(i,2)) == 2;
        CalcP(indiceP,1) = Pcalculado(i,conjK,G,B,V0,Teta0);
        CalcQ(indiceQ,1) = Qcalculado(i,conjK,G,B,V0,Teta0);
        indiceP = indiceP + 1;
        indiceQ = indiceQ + 1;
    elseif(Barras(i,2)) == 3;
        CalcP(indiceP,1) = Pcalculado(i,conjK,G,B,V0,Teta0);
        indiceP = indiceP + 1;
    end
end

%valores calculados para os Ps conhecidos, e Qs conhecidos
Calc = [CalcP; CalcQ]
%diferença
Delta = Esp - Calc

J = Jacobiana(Barras,linhas,conjK,G,B,V0,Teta0);


%% Metodo de Newton
status =0;
contador = 1;
V_iterado = V0;
Teta_iterado = Teta0;
Erro = 0.001;
while (status == 0)
Vetor_incog = Vetor_incog + inv(J)*Delta

%Atualizar vetor
varredura_teta = 1;
varredura_V = 1+nPQ+nPV;
for i = 1:linhas
    if(Barras(i,2)) == 2
        Teta_iterado(i) =Vetor_incog(varredura_teta); 
        V_iterado(i)=Vetor_incog(varredura_V);
        varredura_teta = varredura_teta +1;
        varredura_V = varredura_V +1;
    elseif(Barras(i,2)) == 3
        Teta_iterado(i) =Vetor_incog(varredura_teta); 
        varredura_teta = varredura_teta +1;
    end
end


%Teta_iterado = [0 Vetor_incog(1) Vetor_incog(2) Vetor_incog(3)];
%V_iterado = [1 Vetor_incog(4) 1.03 Vetor_incog(5)];

indiceP = 1;
indiceQ = 1;
for i = 1:linhas;
    if(Barras(i,2)) == 2;
        CalcP(indiceP,1) = Pcalculado(i,conjK,G,B,V_iterado,Teta_iterado);
        CalcQ(indiceQ,1) = Qcalculado(i,conjK,G,B,V_iterado,Teta_iterado);
        indiceP = indiceP + 1;
        indiceQ = indiceQ + 1;
    elseif(Barras(i,2)) == 3;
        CalcP(indiceP,1) = Pcalculado(i,conjK,G,B,V_iterado,Teta_iterado);
        indiceP = indiceP + 1;
    end
end

%valores calculados para os Ps conhecidos, e Qs conhecidos
Calc = [CalcP; CalcQ];
%diferença
Delta = Esp - Calc
    
%Verificação
status = max(abs(Delta))<= Erro;

J = Jacobiana(Barras,linhas,conjK,G,B,V_iterado,Teta_iterado);

contador = contador + 1;
end

%% The end
%PARTE FINAL    

for i = 1:linhas;
    PotAtiv(i,1) = Pcalculado(i,conjK,G,B,V_iterado,Teta_iterado);
    PotReat(i,1) = Qcalculado(i,conjK,G,B,V_iterado,Teta_iterado);
end

%Fluxo nas Linhas
for k = 1:linhas;
    TensaoFasor(k) = V_iterado(k)*exp(Teta_iterado(k)*j);
end


%ligacoes é o número de ligações (qntdd de linhas da tabela inicial)
for i = 1:ligacoes;
    Ek = TensaoFasor(round(real(ent_int(i,1))));    
    Em = TensaoFasor(round(real(ent_int(i,2))));
    ykm = ent_int(i,3);
    bkm = ent_int(i,4);
    Fluxos_e_perdas(i,1) = Ek*conj((ykm*(Ek - Em)) + bkm*Ek*j);
    Fluxos_e_perdas(i,2) = Em*conj((ykm*(Em - Ek)) + bkm*Em*j);
    Fluxos_e_perdas(i,3) = Fluxos_e_perdas(i,1) + Fluxos_e_perdas(i,2);
end
Fluxos_e_perdas