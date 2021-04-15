function [deri] = Lkm_Linha(i,m,G,B,V,Teta)

deri = ((G(i,m)*sin(Teta(i)-Teta(m))) - (B(i,m)*cos(Teta(i)-Teta(m))));

end