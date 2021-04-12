function [deri] = Nkk(i,conjK,G,B,V,Teta)

P = Pcalculado(i,conjK,G,B,V,Teta);
deri = (V(i)^-1)*(P + G(i,i)*(V(i)^2));

end