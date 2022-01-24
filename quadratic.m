% My function. Enter your arbitrary function here.
clear all
f = @(x) (20*x ^ 4 - 22 * x ^ 3 + 2);

x1 = 0;
x2 = 1;
x3 = 2;
tol = 10^-6;

% Invoking function
quadratic_interpolation(f, x1, x2, x3, tol)

function quadratic_interpolation(f, x1, x2, x3, tol)
    fx1 = f(x1);
    fx2 = f(x2);
    fx3 = f(x3);
    if (fx1 > fx2 && fx2 < fx3)
        cond = true;
        iterations = 1;
        while(cond)
            % Quadratic interpolation in the form of a second-order polynomial y(x) = a + bx + cx^2
            % a, b, c is calculated from the following linear equations
            syms a b c
            fx1 = f(x1);
            fx2 = f(x2);
            fx3 = f(x3);
            eq1 = a + x1*b + x1^2 * c == fx1;
            eq2 = a + x2*b + x2^2 * c == fx2;
            eq3 = a + x3*b + x3^2 * c == fx3;
            sol = solve([eq1, eq2, eq3], [a, b, c]);
            aS = sol.a;
            bS = sol.b;
            cS = sol.c;
            
            xOpt = -(bS/(2*cS));
            parabolaOpt = aS + bS*xOpt + cS*(xOpt^2);
            fxOpt = f(xOpt);
            vars = [x1 x2 x3 xOpt];
   
            cond = (abs(fxOpt - parabolaOpt) > tol);
                if (cond)
                    iterations = iterations + 1;
                    % Calculating new points
                    vSorted = sort(vars);
                    vSIndice = find(vSorted==xOpt);
                    vSortedLeft = vSorted(:,1:(vSIndice-1));
                    vSortedRight = vSorted(:, (vSIndice+1:end));
                    x1 = max(vSortedLeft);
                    x2 = xOpt;
                    x3 = min(vSortedRight);
                end
        end
            fprintf('Optimal x* = %.4f \n', x2)
            fprintf('No. of iterations = %d \n', iterations)
    else
        disp('f(x1) > f(x2) && f(x2) < f(x3) not satisfied, aborting method...')
    end
end
