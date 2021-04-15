function [deri] = Lkk_Linha(i,conjK,G,B,V,Teta)

Q = Qcalculado(i,conjK,G,B,V,Teta);
deri = Q/(V(i)^2) - B(i,i);

end