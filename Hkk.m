function [deri] = Hkk(i,conjK,G,B,V,Teta)

Q = Qcalculado(i,conjK,G,B,V,Teta);
deri = - B(i,i)*(V(i)^2) - Q;

end