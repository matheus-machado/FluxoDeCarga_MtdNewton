function [deri] = Hkk_Linha(i,conjK,G,B,V,Teta)

Q = Qcalculado(i,conjK,G,B,V,Teta);
deri = - B(i,i)*V(i) - Q/V(i);

end