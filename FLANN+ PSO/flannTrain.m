function [ error_avg ,Oo] = flannTrain( w,inp,output,ex_k )
[m n]=size(inp);
j=1;
for i=1:n
    input_data(:,j)=inp(:,i);
    j=j+1;
    k=1;
    while k<=ex_k
        input_data(:,j)=sin(k.*pi.*inp(:,i));
        input_data(:,j+1)=cos(k.*pi.*inp(:,i));
        k=k+1;
        j=j+2;
    end
end
    error_avg=0;
    for i=1:m
        Ii=input_data(i,:)';
        t=output(i,:)';
        Io=w*Ii;
        Oo(i)=Io;
        error=t-Oo(i);
        error_avg=error_avg+sum(abs(error)^2);
    end
    error_avg=error_avg/m;
end

