% Exploring the cellular objective in flux balance constraint-based models.

% Author: Rafael Costa
% Affiliation: Instituto de Engenharia de Sistemas e Computadores, Investigac�o e Desenvolvimento (INESC-ID), Lisboa
% and
% Center for Intelligent Systems, LAETA, IDMEC, IST, University of Lisbon 
% Author: Nguyen Hoang Son

function FBAsolution=maxX(glob,model,netcode,taskcode,minNorm)
    if exist('minNorm','var')
        if isempty(minNorm)
            minNorm=true;
        end
    else
        minNorm=true;
    end
    A=[model.S(model.csense=='L',:);-model.S(model.csense=='G',:)];
    b=[model.b(model.csense=='L',:);-model.b(model.csense=='G',:)];
    Aeq=model.S(model.csense=='E',:);
    beq=model.b(model.csense=='E',:);

    if minNorm
        FBAsolution=optimizeCbModel(model,'max','one');
        if FBAsolution.stat < 1
            warning('No solution found!');
            FBAsolution.minE=-1;
        else
            FBAsolution.minE=eclDistance(glob,FBAsolution.x)/100;
        end
        FBAsolution.maxE=FBAsolution.minE;
    else
        FBAsolution=optimizeCbModel(model,'max');
        if FBAsolution.stat < 1
            warning('No solution found!');
            FBAsolution.minE=-1;FBAsolution.maxE=-1;
            return;
        end
        x0=FBAsolution.x;
        f0=FBAsolution.f;

        Aeq=[Aeq;model.c'];
        beq=[beq;f0];
        [FBAsolution.minE,FBAsolution.maxE,FBAsolution.x]=fidelity4linear(glob,taskcode,x0,Aeq,beq,A,b,model.lb,model.ub);
    end
end
