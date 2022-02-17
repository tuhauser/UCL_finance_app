clear; close all; clc
inp = [0 1 0 0 0];

conn = zeros(length(inp));
conn(1,3) = 1;
conn(2,3) = 1;
conn(3,4) = 1;
conn(3,5) = 1;

out = [];

%% loop
for t = 1: 3
    out = inp * conn
    pause
    inp = out;
end 

