function [pcalci] = Pcalculado(i,conjK,G,B,V,Teta)

%Pk = Vk*som(Vm(Gkm*cos(tk - tm) + Bkm*sen(tk - tm))), som em m pertence a K

pcalci = 0;
for m = 1:length(conjK{i,1});
    pcalci = pcalci + V(round(conjK{i,1}(m)))*((G(i,round(conjK{i,1}(m))))*(cos(Teta(i) - Teta(round(conjK{i,1}(m))))) + (B(i,round(conjK{i,1}(m))))*(sin(Teta(i) - Teta(round(conjK{i,1}(m))))));
end

pcalci = pcalci*V(i);
end

