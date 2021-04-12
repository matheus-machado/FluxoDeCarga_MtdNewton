function [deri] = Hkm(i,m,G,B,V,Teta)

deri = V(i)*V(m)*((G(i,m)*sin(Teta(i)-Teta(m))) - (B(i,m)*cos(Teta(i)-Teta(m))));

end