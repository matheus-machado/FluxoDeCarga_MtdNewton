clear all

%O QUE É NECESSÁRIO USAR COMO ENTRADA?
%PARA O OCTAVE ONLINE: precisa inserir o Barras, Dados_Linha, V0, Teta0 e conjK, na ordem indicada para cada tipo de matriz
%PARA O MATLAB: precisa inserir o arquivo .mat com os dados, o Barras, V0 e Teta0, também na ordem certa

prompt = 'Quantas barras temos no sistema? \n';
num_barras = input(prompt);

%Tolerância:

Erro = 1*10^-4;
%Erro = 1*10^-3;

%tabela de dados de barras
%Barras = [barra, tipo, Pg, Qg, Pc, Qc]
%tipo: 1 - slack, 2 - PQ, 3 - PV
%sem dado: 666
%ATENÇÃO: NÃO TER DADO É DIFERENTE DE ZERO, E SE A SUA BARRA É PV PRECISA TER OS VALORES DE PG E PV, SE FOR PQ, ALÉM DISSO PRECISA TER DE QG E QC

Barras = [1 1 666 666 0 0; 2 2 0 0 1 0.5; 3 3 4.5 666 0.9 0.3; 4 2 0 0 5 1];
%Barras = [1 1 666 666 0 0; 2 2 0 0 0 0; 3 3 5.2 666 0.8 0.4; 4 2 0 0 4 1.2];

[linhas, colunas] = size(Barras);


%valores iniciais

V0 = [1.03; 1; 1.02; 1];
Teta0 = [0; 0; 0; 0];
%V0 = [1; 1; 1.03; 1];
%Teta0 = [0; 0; 0; 0];


%conjunto K para cada barra
%importante: o conjK deve conter todas as barras. A ordem das ligações não precisa ser correta, por exemplo, se a barra 3 liga-se com as barras 1 e 2, o vetor pode estar como [1; 2; 3] ou [3; 1; 2]. A única ordem que NÃO PODE MUDAAAAAAR é a ordem dos vetores na célula por causa da sua ligação com o Barras. Por exemplo, se a ordem dos dados em Barras é: Barra 1, Barra 2, Barra 3, o primeiro vetor dentro da céula deve ter as ligações da barra 1, o segundo, da 2 e o terceiro da 3

conjK = {[1;2;3]; [1; 2; 3]; [1; 2; 3; 4]; [3; 4]};
%conjK = {[1;2;4]; [1; 2; 3; 4]; [2; 3]; [1; 2; 4]};


normalizado = 1;

%%Para o OCTAVE ONLINE:
%%Entrada: terminal 1 terminal 2  r  x  bsh(TOTAL)
%%num_barras = 4;


Dados_Linhas = [1 2 0.0050 0.200 0.54; 1 3 0.0090 0.100 0.82; 1 3 0.0030 0.060 0.22; 2 3 0.00225 0.100 0.88; 3 4 0.0010 0.05 0.44];
%Dados_Linhas = [1 2 0.0090 0.100 1.72; 1 4 0.0045 0.050 0.88; 2 4 0.00225 0.025 0.44; 2 3 0.00150 0.02 0];

ligacoes = length(Dados_Linhas(:,1));
                    

Matriz_Y = zeros(num_barras);
ent_int = zeros(ligacoes,4);
bshunt = zeros(num_barras);
ent_int(:,1) = Dados_Linhas(:,1);
ent_int(:,2) = Dados_Linhas(:,2);
for i = 1:ligacoes;
    Terminal1 = Dados_Linhas(i,1);
    Terminal2 = Dados_Linhas(i,2);
    z = Dados_Linhas(i,3) + (j*Dados_Linhas(i,4));
    ent_int(i,3) = (1/z);
    b = Dados_Linhas(i,5);
    ent_int(i,4) = (b/2);
    %Laterais
    Matriz_Y(Terminal1,Terminal2) = (-1/z) + Matriz_Y(Terminal1,Terminal2);
    Matriz_Y(Terminal2, Terminal1) = (-1/z) + Matriz_Y(Terminal2, Terminal1);
    %Diagonal
    Matriz_Y(Terminal1,Terminal1) = (1/z) +((j/2)*b)+ Matriz_Y(Terminal1,Terminal1);
    Matriz_Y(Terminal2, Terminal2)  = (1/z) +((j/2)*b) + Matriz_Y(Terminal2, Terminal2);
end
Matriz_Y

%{
%%PARA O MATLAB (Tbm funciona no OCTAVE ONLINE, mas não dá pra acessar os dados)
%%AS PARTES RELACIONADAS AO conjK daqui NÃO FUNCIONAM NO OCTAVE ONLINE, precisa adicionar o conjK manualmente LÁ EM CIMA, se for usar isso
load('dados_linhas_exerc.mat')


%% Cálculo da Matriz de Admitância
clear Matriz_Y
Matriz_Y = zeros(num_barras);
ent_int = [];
bshunt = zeros(num_barras);
%%Vetor = cell(1,num_barras);
%%conjK = cell(1,num_barras);
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
    %%Vetor{Terminal1}=  [Vetor{Terminal1}; Terminal1; Terminal2];
    %%Vetor{Terminal2}=[Vetor{Terminal2}; Terminal1; Terminal2];
 
    ent_int = [ent_int; Terminal1 Terminal2 (1/z) b/2];
end
Matriz_Y
%}


%%Matriz_Y = [(2.6783-28.4590*i) (-0.8928+9.9197*i) 0 (-1.7855+19.8393*i); (-0.8928+9.9197*i) (8.1929-98.2386*i) (-3.7290+49.7203*i) (-3.5711+39.6786*i); 0 (-3.7290+49.7203*i) (3.7290-49.7203*i) 0; (-1.7855+19.8393*i) (-3.5711+39.6786*i) 0 (5.3566-58.8579*i)]

G = real(Matriz_Y);
B = imag(Matriz_Y);

%Pk = Vk*som(Vm(Gkm*cos(tk - tm) + Bkm*sen(tk - tm))), som em m pertence a K
%Qk = Vk*som(Vm(Gkm*sen(tk - tm) - Bkm*cos(tk - tm))), som em m pertence a K

%calcula os valores esperados para as poências conhecidas
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
%Esp = [EspP; EspQ]


iT = 1;
iV = 1;
for i = 1:linhas;
    if(Barras(i,2)) == 2;
        TetaVet(iT,1) = Teta0(i);
        V_Vet(iV,1) = V0(i);
        iT = iT + 1;
        iV = iV + 1;
    elseif(Barras(i,2)) == 3;
        TetaVet(iT,1) = Teta0(i);
        iT = iT + 1;
    end
end

if (normalizado == 0);
    [Teta_iterado,V_iterado,DeltaP,DeltaQ,contadorP,contadorQ] = NewtonDesacoplado(Barras,linhas,conjK,G,B,V0,Teta0,EspP,EspQ,TetaVet,V_Vet,Erro);
else
    [Teta_iterado,V_iterado,DeltaP,DeltaQ,contadorP,contadorQ] = NewtonNormalizado(Barras,linhas,conjK,G,B,V0,Teta0,EspP,EspQ,TetaVet,V_Vet,Erro);
end


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
%Fluxos_e_perdas vai seguir a ordem da matriz Dados_Linhas ou ent_int. Assim, se por exemplo, suas primeiras duas linhas da ent_int forem 1 2; 3 4 (referentes as ligações entre as barras 1 e 2, e entre 3 e 4), a primeira linha da Fluxos_e_perdas vai ter na primeira coluna o fluxo de 1 para 2, na segunda coluna, de 2 para 1,e na terceira, a perda relacionada a essa ligação. Na segunda linha, terá os mesmos dados, mas referentes a ligação 3 e 4.
for i = 1:ligacoes;
    Ek = TensaoFasor(round(real(ent_int(i,1))));
    Em = TensaoFasor(round(real(ent_int(i,2))));
    ykm = ent_int(i,3);
    bkm = ent_int(i,4);
    Fluxos_e_perdas(i,1) = Ek*conj((ykm*(Ek - Em)) + bkm*Ek*j);
    Fluxos_e_perdas(i,2) = Em*conj((ykm*(Em - Ek)) + bkm*Em*j);
    Fluxos_e_perdas(i,3) = Fluxos_e_perdas(i,1) + Fluxos_e_perdas(i,2);
end   




