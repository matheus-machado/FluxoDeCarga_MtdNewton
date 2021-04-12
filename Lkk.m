function [deri] = Lkk(i,conjK,G,B,V,Teta)

Q = Qcalculado(i,conjK,G,B,V,Teta);
deri = (V(i)^-1)*(Q - B(i,i)*(V(i)^2));

end