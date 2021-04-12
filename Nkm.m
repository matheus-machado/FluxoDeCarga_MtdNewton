function [deri] = Nkm(i,m,G,B,V,Teta)

deri = V(i)*((G(i,m)*cos(Teta(i)-Teta(m))) + (B(i,m)*sin(Teta(i)-Teta(m))));

end