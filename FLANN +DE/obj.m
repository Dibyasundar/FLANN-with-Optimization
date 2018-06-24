function [ error ] = obj( w,train_input,train_output,test_input,test_output,ex_k,mm )

N=size(train_input,2);
m=size(train_input,1);
error=flannTrain( w,train_input,train_output,ex_k);

if mm==1
    [error,test_out]=flannTrain( w,test_input,test_output,ex_k );
    figure;plot(test_output,'b');hold on;plot(test_out,'r');
    disp(strcat('Mean square error:',num2str(error)))
end


end

