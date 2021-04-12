function [deri] = Mkk(i,conjK,G,B,V,Teta)

P = Pcalculado(i,conjK,G,B,V,Teta);
deri = -G(i,i)*(V(i)^2) + P;

end