function G = CN_sph_1(D,R1,N,L,t,S,m_s,c_g,Boundary)
            %D: diffusion coefficient or coefficients matrix;
            %R1: first spot radius to mid
            %N: spot numers;
            %L: step length;
            %t_interval: time step;
            %S: starting profile;
            %m_s: multi or single
            %c_g: carbonate or garnet
            if strcmp(c_g,'garnet')
                if strcmp(m_s,'single')
                    %creat matrix
                    A = zeros(N);
                    B = zeros(N);
                    %edge condition
                    if isempty(Boundary)
                        Boundary_0 = S(1);
                        Boundary_end = S(end);
                    else
                        Boundary_0 = Boundary(1,1);
                        Boundary_end = Boundary(2,1);
                    end
                    S(1) = Boundary_0;
                    S(end) = Boundary_end;
                  
                    %edge of the matrix
                    A(1,1) = 1;
                    B(1,1) = 1;
                    %set r
                    A(N,N) = 1;
                    B(N,N) = 1;
                    
                    %mid condition
                    for i = 2:N-1
                        r = D(i,1)*t/(2*(R1+(i-1)*L)*(L^2));
                        A(i,i-1) = -r*((R1+(i-1)*L)-L);
                        A(i,i) = 1+2*r*(R1+(i-1)*L);
                        A(i,i+1) = -r*((R1+(i-1)*L)+L);
                        B(i,i-1) = r*((R1+(i-1)*L)-L);
                        B(i,i) = 1-2*r*(R1+(i-1)*L);
                        B(i,i+1) = r*((R1+(i-1)*L)+L);
                    end
                    G = A\B*S;
                elseif strcmp(m_s,'multi')
                    %DX,DY,DZ: diffusion coefficient;
                    %N: spot numers;
                    %L: step length;
                    %t: time;
                    %S: sample starting material with convolution(import array);
                    C = zeros(3*N,1);
                    E = zeros(N,1);
                    %boundary condition
                    
                    if isempty(Boundary)
                        Boundary_1_0 = S(1,1);
                        Boundary_1_end = S(end,1);
                        Boundary_2_0 = S(1,2);
                        Boundary_2_end = S(end,2);
                        Boundary_3_0 = S(1,3);
                        Boundary_3_end = S(end,3);
                    else
                        Boundary_1_0 = Boundary(1,1);
                        Boundary_1_end = Boundary(2,1);
                        Boundary_2_0 = Boundary(1,2);
                        Boundary_2_end = Boundary(2,2);
                        Boundary_3_0 = Boundary(1,3);
                        Boundary_3_end = Boundary(2,3);
                    end
                    S(1,1) = Boundary_1_0;
                    S(end,1) = Boundary_1_end;
                    S(1,2) = Boundary_2_0;
                    S(end,2) = Boundary_2_end;
                    S(1,3) = Boundary_3_0;
                    S(end,3) = Boundary_3_end;
                    
                    %conpositional
                    for a=1:N
                        C(a,1) = S(a,1);
                    end
                    for a=N+1:2*N
                        C(a,1) = S(a-N,2);
                    end
                    for a=2*N+1:3*N
                        C(a,1) = S(a-2*N,3);
                    end
                    for a=1:N
                        E(a,1) = S(a,4);
                    end %starting condition
                    
                    A = zeros(3*N);
                    A(1,1) = 1;
                    A(N+1,N+1) = 1;
                    A(2*N+1,2*N+1) = 1;
                    B = zeros(3*N);
                    B(1,1) = 1;
                    B(N+1,N+1) = 1;
                    B(2*N+1,2*N+1) = 1;
                    %edge matrix N
                    A(N,N) = 1;
                    A(2*N,2*N) = 1;
                    A(3*N,3*N) = 1;
                    B(N,N) = 1;
                    B(2*N,2*N) = 1;
                    B(3*N,3*N) = 1;
                    %mid condition
                    for i = 2:N-1
                        R(i,1) = R1+(i-1)*L;
                        r1 = D(i,1)*t/(2*R(i,1)*(L^2));
                        r2 = D(i,2)*t/(2*R(i,1)*(L^2));
                        r3 = D(i,3)*t/(2*R(i,1)*(L^2));
                        r4 = D(i,4)*t/(2*R(i,1)*(L^2));
                        r5 = D(i,5)*t/(2*R(i,1)*(L^2));
                        r6 = D(i,6)*t/(2*R(i,1)*(L^2));
                        r7 = D(i,7)*t/(2*R(i,1)*(L^2));
                        r8 = D(i,8)*t/(2*R(i,1)*(L^2));
                        r9 = D(i,9)*t/(2*R(i,1)*(L^2));
                        
                        A(i,i-1) = -r1*(R(i,1)-L);
                        A(i,i) = 1+2*r1*R(i,1);
                        A(i,i+1) = -r1*(R(i,1)+L);
                        B(i,i-1) = r1*(R(i,1)-L);
                        B(i,i) = 1-2*r1*R(i,1);
                        B(i,i+1) = r1*(R(i,1)+L);
                        A(i,i-1+N) = -r2*(R(i,1)-L);
                        A(i,i+N) = 2*r2*R(i,1);
                        A(i,i+1+N) = -r2*(R(i,1)+L);
                        B(i,i-1+N) = r2*(R(i,1)-L);
                        B(i,i+N) = -2*r2*R(i,1);
                        B(i,i+1+N) = r2*(R(i,1)+L);
                        A(i,i-1+2*N) = -r3*(R(i,1)-L);
                        A(i,i+2*N) = 2*r3*R(i,1);
                        A(i,i+1+2*N) = -r3*(R(i,1)+L);
                        B(i,i-1+2*N) = r3*(R(i,1)-L);
                        B(i,i+2*N) = -2*r3*R(i,1);
                        B(i,i+1+2*N) = r3*(R(i,1)+L);
                        
                        A(i+N,i-1) = -r4*(R(i,1)-L);
                        A(i+N,i) = 2*r4*R(i,1);
                        A(i+N,i+1) = -r4*(R(i,1)+L);
                        B(i+N,i-1) = r4*(R(i,1)-L);
                        B(i+N,i) = -2*r4*R(i,1);
                        B(i+N,i+1) = r4*(R(i,1)+L);
                        A(i+N,i-1+N) = -r5*(R(i,1)-L);
                        A(i+N,i+N) = 1+2*r5*R(i,1);
                        A(i+N,i+1+N) = -r5*(R(i,1)+L);
                        B(i+N,i-1+N) = r5*(R(i,1)-L);
                        B(i+N,i+N) = 1-2*r5*R(i,1);
                        B(i+N,i+1+N) = r5*(R(i,1)+L);
                        A(i+N,i-1+2*N) = -r6*(R(i,1)-L);
                        A(i+N,i+2*N) = 2*r6*R(i,1);
                        A(i+N,i+1+2*N) = -r6*(R(i,1)+L);
                        B(i+N,i-1+2*N) = r6*(R(i,1)-L);
                        B(i+N,i+2*N) = -2*r6*R(i,1);
                        B(i+N,i+1+2*N) = r6*(R(i,1)+L);
                        
                        A(i+2*N,i-1) = -r7*(R(i,1)-L);
                        A(i+2*N,i) = 2*r7*R(i,1);
                        A(i+2*N,i+1) = -r7*(R(i,1)+L);
                        B(i+2*N,i-1) = r7*(R(i,1)-L);
                        B(i+2*N,i) = -2*r7*R(i,1);
                        B(i+2*N,i+1) = r7*(R(i,1)+L);
                        A(i+2*N,i-1+N) = -r8*(R(i,1)-L);
                        A(i+2*N,i+N) = 2*r8*R(i,1);
                        A(i+2*N,i+1+N) = -r8*(R(i,1)+L);
                        B(i+2*N,i-1+N) = r8*(R(i,1)-L);
                        B(i+2*N,i+N) = -2*r8*R(i,1);
                        B(i+2*N,i+1+N) = r8*(R(i,1)+L);
                        A(i+2*N,i-1+2*N) = -r9*(R(i,1)-L);
                        A(i+2*N,i+2*N) = 1+2*r9*R(i,1);
                        A(i+2*N,i+1+2*N) = -r9*(R(i,1)+L);
                        B(i+2*N,i-1+2*N) = r9*(R(i,1)-L);
                        B(i+2*N,i+2*N) = 1-2*r9*R(i,1);
                        B(i+2*N,i+1+2*N) = r9*(R(i,1)+L);
                        
                    end
                    %matrix
                    C = A\B*C;
                    for q = 1:N
                        G(q,1)=C(q,1);
                        G(q,2)=C(q+N,1);
                        G(q,3)=C(q+2*N,1);
                        G(q,4)=1-C(q,1)-C(q+N,1)-C(q+2*N,1);
                    end
                end
            elseif strcmp(c_g,'carbonate')
                if strcmp(m_s,'single')
                    %creat matrix
                    A = zeros(N);
                    B = zeros(N);
                    %edge condition
                    if isempty(Boundary)
                        Boundary_0 = S(1);
                        Boundary_end = S(end);
                    else
                        Boundary_0 = Boundary(1,1);
                        Boundary_end = Boundary(2,1);
                    end
                    S(1) = Boundary_0;
                    S(end) = Boundary_end;
                    
                    %edge condition
                    A(1,1) = 1;
                    B(1,1) = 1;
                    A(N,N) = 1;
                    B(N,N) = 1;
                    %mid condition
                    for i = 2:N-1
                        r = D(i,1)*t/(2*(R1+(i-1)*L)*(L^2));
                        A(i,i-1) = -r*((R1+(i-1)*L)-L);
                        A(i,i) = 1+2*r*(R1+(i-1)*L);
                        A(i,i+1) = -r*((R1+(i-1)*L)+L);
                        B(i,i-1) = r*((R1+(i-1)*L)-L);
                        B(i,i) = 1-2*r*(R1+(i-1)*L);
                        B(i,i+1) = r*((R1+(i-1)*L)+L);
                    end
                    G = A\B*S;
                elseif strcmp(m_s,'multi')
                    %DX,DY,DZ: diffusion coefficient;
                    %N: spot numers;
                    %L: step length;
                    %t: time;
                    %S: sample starting material with convolution(import array);
                    C = zeros(2*N,1);
                    E = zeros(N,1);
                    %boundary condition
                    if isempty(Boundary)
                        Boundary_1_0 = S(1,1);
                        Boundary_1_end = S(end,1);
                        Boundary_2_0 = S(1,2);
                        Boundary_2_end = S(end,2);
                    else
                        Boundary_1_0 = Boundary(1,1);
                        Boundary_1_end = Boundary(2,1);
                        Boundary_2_0 = Boundary(1,2);
                        Boundary_2_end = Boundary(2,2);
                    end
                    S(1,1) = Boundary_1_0;
                    S(end,1) = Boundary_1_end;
                    S(1,2) = Boundary_2_0;
                    S(end,2) = Boundary_2_end;
                    
                    for a=1:N
                        C(a,1) = S(a,1);
                    end
                    for a=N+1:2*N
                        C(a,1) = S(a-N,2);
                    end
                    for a=1:N
                        E(a,1) = S(a,3);
                    end
                    
                    
                    A = zeros(2*N);
                    A(1,1) = 1;
                    A(N+1,N+1) = 1;
                    B = zeros(2*N);
                    B(1,1) = 1;
                    B(N+1,N+1) = 1;
                    %edge condition N
                    A(N,N) = 1;
                    A(2*N,2*N) = 1;
                    B(N,N) = 1;
                    B(2*N,2*N) = 1;
                    %mid condition
                    for i = 2:N-1
                        R(i,1) = R1+(i-1)*L;
                        r1 = D(i,1)*t/(2*R(i,1)*(L^2));
                        r2 = D(i,2)*t/(2*R(i,1)*(L^2));
                        r3 = D(i,3)*t/(2*R(i,1)*(L^2));
                        r4 = D(i,4)*t/(2*R(i,1)*(L^2));
                        A(i,i-1) = -r1*(R(i,1)-L);
                        A(i,i) = 1+2*r1*R(i,1);
                        A(i,i+1) = -r1*(R(i,1)+L);
                        B(i,i-1) = r1*(R(i,1)-L);
                        B(i,i) = 1-2*r1*R(i,1);
                        B(i,i+1) = r1*(R(i,1)+L);
                        A(i,i-1+N) = -r2*(R(i,1)-L);
                        A(i,i+N) = 2*r2*R(i,1);
                        A(i,i+1+N) = -r2*(R(i,1)+L);
                        B(i,i-1+N) = r2*(R(i,1)-L);
                        B(i,i+N) = -2*r2*R(i,1);
                        B(i,i+1+N) = r2*(R(i,1)+L);
                        A(i+N,i-1) = -r3*(R(i,1)-L);
                        A(i+N,i) = 2*r3*R(i,1);
                        A(i+N,i+1) = -r3*(R(i,1)+L);
                        B(i+N,i-1) = r3*(R(i,1)-L);
                        B(i+N,i) = -2*r3*R(i,1);
                        B(i+N,i+1) = r3*(R(i,1)+L);
                        A(i+N,i-1+N) = -r4*(R(i,1)-L);
                        A(i+N,i+N) = 1+2*r4*R(i,1);
                        A(i+N,i+1+N) = -r4*(R(i,1)+L);
                        B(i+N,i-1+N) = r4*(R(i,1)-L);
                        B(i+N,i+N) = 1-2*r4*R(i,1);
                        B(i+N,i+1+N) = r4*(R(i,1)+L);
                    end
                    %matrix
                    C = A\B*C;
                    for q = 1:N
                        G(q,1)=C(q,1);
                        G(q,2)=C(q+N,1);
                        G(q,3)=1-C(q,1)-C(q+N,1);
                    end
                end
            end
        end