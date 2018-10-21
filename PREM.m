function varargout = PREM(hintv)
% [h, vp, vs, rho] = PREM(hintv)
% [h, vph, vpv, vsh, vsv, rho, qm, qk, eta] = PREM(hintv)
% This is a program that give us a Preliminary Reference Earth Model.
% Ref. to the TABLE 1 of this paper:
%   Dziewonski A.M., and Anderson D.L., 1981, Preliminary reference Earth model,
%   Phys. Earth Plan. Int., 25:297-356.
% Note that : in the LVZ and LID zone, use the (Vph+Vpv)/2 for P-wave velocity.
% Written by Tche.L. from USTC, 2016, 3.
%
% h: a vector, the depth from the surface of earth to the depth point; Unit: km.
% rho: a vector, the density at every depth point; Unit: g/(cm^3).
% vp: a vector, the P-wave velocity at every depth point; Unit: km/s.
% vph: a vector, the horizontally polarized P-wave velocity at every depth point; Unit: km/s.
% vpv: a vector, the vertically polarized P-wave velocity at every depth point; Unit: km/s.
% vs: a vector, the S-wave velocity at every depth point; Unit: km/s.
% vsh: a vector, the horizontally polarized S-wave velocity at every depth point; Unit: km/s.
% vsv: a vector, the vertically polarized S-wave velocity at every depth point; Unit: km/s.
% qm: a vector, the quality factor of $\mu$.
% qk: a vector, the quality factor of $\kappa$.
% eta: a vector, the transversely isotropic model parameter.
%
% hintv: a constant variable, the interval of depth points; Unit: km.

if(nargin < 1)
    error('Not enough input arguments.');
elseif(nargin > 1)
    warning('Input arguments after the 1-st one are invalid.');
end

R = 6371;							% the radius of the earth.

n = ceil(R/hintv) + 1;              % the number of depth points.
h = NaN*ones(n, 1);
vp = NaN*ones(n, 1);
vph = NaN*ones(n, 1);
vpv = NaN*ones(n, 1);
vs = NaN*ones(n, 1);
vsh = NaN*ones(n, 1);
vsv = NaN*ones(n, 1);
rho = NaN*ones(n, 1);
qm = NaN*ones(n, 1);
qk = NaN*ones(n, 1);
eta = NaN*ones(n, 1);

for i = 1:1:(n - 1)
    h(i) = (i - 1)*hintv;
    r = R - h(i);                   % the radius at the depth point.
    if(r >= 6368)
        vp(i) = 1.45;
        vph(i) = vp(i);
        vpv(i) = vp(i);
        vs(i) = 0;
        vsh(i) = vs(i);
        vsv(i) = vs(i);
        rho(i) = 1.02;
        qm(i) = inf;
        qk(i) = 57823;
        eta(i) = 1;
    elseif(r >= 6356)
        vp(i) = 5.8;
        vph(i) = vp(i);
        vpv(i) = vp(i);
        vs(i) = 3.2;
        vsh(i) = vs(i);
        vsv(i) = vs(i);
        rho(i) = 2.6;
        qm(i) = 600;
        qk(i) = 57823;
        eta(i) = 1;
    elseif(r >= 6346.6)
        vp(i) = 6.8;
        vph(i) = vp(i);
        vpv(i) = vp(i);
        vs(i) = 3.9;
        vsh(i) = vs(i);
        vsv(i) = vs(i);
        rho(i) = 2.9;
        qm(i) = 600;
        qk(i) = 57823;
        eta(i) = 1;
    elseif(r >= 6151)
        x = r/R;                    % the nomalized radius at the depth point.
        vp(i) = 4.1875 + 3.9382*x;
		vph(i) = 3.5908 + 4.6172*x;
		vpv(i) = 0.8317 + 7.2180*x;
        vs(i) = 2.1519 + 2.3481*x;
		vsh(i) = - 1.0839 + 5.7176*x;
		vsv(i) = 5.8582 - 1.4678*x;
        rho(i) = 2.6910 + 0.6924*x;
        if(r >= 6291)
          qm(i) = 600;
        else
          qm(i) = 80;
        end
        qk(i) = 57823;
        eta(i) = 3.3687 - 2.4778*x;
    elseif(r >= 5971)
        x = r/R;
        vp(i) = 20.3926 - 12.2569*x;
        vph(i) = vp(i);
        vpv(i) = vp(i);
        vs(i) = 8.9496 - 4.4597*x;
        vsh(i) = vs(i);
        vsv(i) = vs(i);
        rho(i) = 7.1089 - 3.8045*x;
        qm(i) = 143;
        qk(i) = 57823;
        eta(i) = 1;
    elseif(r >= 5771)
        x = r/R;
        vp(i) = 39.7027 - 32.6166*x;
        vph(i) = vp(i);
        vpv(i) = vp(i);
        vs(i) = 22.3512 - 18.5856*x;
        vsh(i) = vs(i);
        vsv(i) = vs(i);
        rho(i) = 11.2494 - 8.0298*x;
        qm(i) = 143;
        qk(i) = 57823;
        eta(i) = 1;
    elseif(r >= 5701)
        x = r/R;
        vp(i) = 19.0957 - 9.8672*x;
        vph(i) = vp(i);
        vpv(i) = vp(i);
        vs(i) = 9.9839 - 4.9324*x;
        vsh(i) = vs(i);
        vsv(i) = vs(i);
        rho(i) = 5.3197 - 1.4836*x;
        qm(i) = 143;
        qk(i) = 57823;
        eta(i) = 1;
    elseif(r >= 5600)
        x = r/R;
        vp(i) = 29.2766 - 23.6027*x + 5.5242*x^2 - 2.5514*x^3;
        vph(i) = vp(i);
        vpv(i) = vp(i);
        vs(i) = 22.3459 - 17.2473*x - 2.0834*x^2 + 0.9783*x^3;
        vsh(i) = vs(i);
        vsv(i) = vs(i);
        rho(i) = 7.9565 - 6.4761*x + 5.5283*x^2 - 3.0807*x^3;
        qm(i) = 312;
        qk(i) = 57823;
        eta(i) = 1;
    elseif(r >= 3630)
        x = r/R;
        vp(i) = 24.9520 - 40.4673*x + 51.4832*x^2 - 26.6419*x^3;
        vph(i) = vp(i);
        vpv(i) = vp(i);
        vs(i) = 11.1671 - 13.7818*x + 17.4575*x^2 - 9.2777*x^3;
        vsh(i) = vs(i);
        vsv(i) = vs(i);
        rho(i) = 7.9565 - 6.4761*x + 5.5283*x^2 - 3.0807*x^3;
        qm(i) = 312;
        qk(i) = 57823;
        eta(i) = 1;
    elseif(r >= 3480)
        x = r/R;
        vp(i) = 15.3891 - 5.3181*x + 5.5242*x^2 - 2.5514*x^3;
        vph(i) = vp(i);
        vpv(i) = vp(i);
        vs(i) = 6.9254 + 1.4672*x - 2.0834*x^2 + 0.9783*x^3;
        vsh(i) = vs(i);
        vsv(i) = vs(i);
        rho(i) = 7.9565 - 6.4761*x + 5.5283*x^2 - 3.0807*x^3;
        qm(i) = 312;
        qk(i) = 57823;
        eta(i) = 1;
    elseif(r >= 1221.5)
        x = r/R;
        vp(i) = 11.0487 - 4.0362*x + 4.8023*x^2 - 13.5732*x^3;
        vph(i) = vp(i);
        vpv(i) = vp(i);
        vs(i) = 0;
        vsh(i) = vs(i);
        vsv(i) = vs(i);
        rho(i) = 12.5815 - 1.2638*x - 3.6426*x^2 - 5.5281*x^3;
        qm(i) = inf;
        qk(i) = 57823;
        eta(i) = 1;
    else
        x = r/R;
        vp(i) = 11.2622 - 6.3640*x^2;
        vph(i) = vp(i);
        vpv(i) = vp(i);
        vs(i) = 3.6678 - 4.4475*x^2;
        vsh(i) = vs(i);
        vsv(i) = vs(i);
        rho(i) = 13.0885 - 8.8381*x^2;
        qm(i) = 84.6;
        qk(i) = 1327.7;
        eta(i) = 1;
    end
end

h(n) = 6371;
vp(n) = 11.2622;
vph(n) = vp(n);
vpv(n) = vp(n);
vs(n) = 3.6678;
vsh(n) = vs(n);
vsv(n) = vs(n);
rho(n) = 13.0885;
qm(n) = 84.6;
qk(n) = 1327.7;
eta(n) = 1;

if(1)
  figure; plot(h, vp, h, vs, h, rho);
  xlabel('Depth (km)'); ylabel('Density (g/cm^3) / Velocity (km/s)');
  title('Preliminary Reference Earth Model');
  legend('location', 'East', 'P-wave velocity', 'S-wave velocity', 'Density');
end

if(nargout == 4)
  varargout{1} = h;
  varargout{2} = vp;
  varargout{3} = vs;
  varargout{4} = rho;
elseif(nargout == 9)
  varargout{1} = h;
  varargout{2} = vph;
  varargout{3} = vpv;
  varargout{4} = vsh;
  varargout{5} = vsv;
  varargout{6} = rho;
  varargout{7} = qm;
  varargout{8} = qk;
  varargout{9} = eta;
else
  error('The number of output arguments MUST be 4 or 9.');
end

end
