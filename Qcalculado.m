function [qcalci] = Qcalculado(i,conjK,G,B,V,Teta)

%Qk = Vk*som(Vm(Gkm*sen(tk - tm) - Bkm*cos(tk - tm))), som em m pertence a K

qcalci = 0;
for m = 1:length(conjK{i,1});
    qcalci = qcalci + V(round(conjK{i,1}(m)))*((G(i,round(conjK{i,1}(m))))*(sin(Teta(i) - Teta(round(conjK{i,1}(m))))) - (B(i,round(conjK{i,1}(m))))*(cos(Teta(i) - Teta(round(conjK{i,1}(m))))));
end

qcalci = qcalci*V(i);
end