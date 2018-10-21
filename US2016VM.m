function [vdep, vlat, vlon, vsv, vp, rho] = US2016VM(filename, pdep, plat, plon)
%Read USA velocity model from US.2016.nc distributed by Weisen SHEN.
%
% IRIS EMC: IRIS Earth Model Collaboration
%
% depth:      depth below earth surface, km, positive down;
% latitude:   latitude, degree, positive north;
% longtitude: longitude, degree, positive east;
% vsv:        S wave velocity, km/s, missing_value = 9999.0, FillValue = 9999.0;
% vp:         P wave velocity, km/s, missing_value = 9999.9, FillValue = 9999.0;
% rho:        density, g/cm^3, missing_value = 9999.0, FillValue = 9999.0;
%
% Download the netCDF file from http://ds.iris.edu/files/products/emc/data/US.2016/US.2016.nc,
% and refer to http://ds.iris.edu/ds/products/emc-us2016/.
% 
% Copyright (c) 2017.03 Tche L. at USTC

% filename = 'US.2016.nc';
% 
% pdep = [  0.0,  0.5, 150.0];
% plat = [ 20.0, 0.25,  50.0];
% plon = [235.0, 0.25, 295.0];

missingvalue = 9999.0;

ncid = netcdf.open(filename, 'NC_NOWRITE');

    dimid = netcdf.inqDimID(ncid, 'depth');
        [~, mdep] = netcdf.inqDim(ncid, dimid);
    dimid = netcdf.inqDimID(ncid, 'latitude');
        [~, mlat] = netcdf.inqDim(ncid, dimid);
    dimid = netcdf.inqDimID(ncid, 'longitude');
        [~, mlon] = netcdf.inqDim(ncid, dimid);

    mindep = str2double(netcdf.getAtt(ncid, netcdf.getConstant('NC_GLOBAL'), ...
        'geospatial_vertical_min'));
    maxdep = str2double(netcdf.getAtt(ncid, netcdf.getConstant('NC_GLOBAL'), ...
        'geospatial_vertical_max'));
    resdep = 0.5;
    minlat = str2double(netcdf.getAtt(ncid, netcdf.getConstant('NC_GLOBAL'), ...
        'geospatial_lat_min'));
    maxlat = str2double(netcdf.getAtt(ncid, netcdf.getConstant('NC_GLOBAL'), ...
        'geospatial_lat_max'));
    reslat = str2double(netcdf.getAtt(ncid, netcdf.getConstant('NC_GLOBAL'), ...
        'geospatial_lat_resolution'));
    minlon = str2double(netcdf.getAtt(ncid, netcdf.getConstant('NC_GLOBAL'), ...
        'geospatial_lon_min'));
    maxlon = str2double(netcdf.getAtt(ncid, netcdf.getConstant('NC_GLOBAL'), ...
        'geospatial_lon_max'));
    reslon = str2double(netcdf.getAtt(ncid, netcdf.getConstant('NC_GLOBAL'), ...
        'geospatial_lon_resolution'));

    if(pdep(1) < mindep)
        warning('pdep: Too small start value of depth, should be >= %g.', mindep);
        pdep(1) = mindep;
    end
    if(mod(pdep(2), resdep) ~= 0)
        error('pdep: Not suitable step value of depth, must be multiple of %g.', resdep);
    else
        idep(3) = round(pdep(2)/resdep);
    end
    if(pdep(3) > maxdep)
        warning('pdep: Too large end value of depth, should be <= %g.', maxdep);
        pdep(3) = maxdep;
    end
    if(plat(1) < minlat)
        warning('plat: Too small start value of latitude, should be >= %g.', minlat);
        plat(1) = minlat;
    end
    if(mod(plat(2), reslat) ~= 0)
        error('plat: Not suitable step value of latitude, must be multiple of %g.', reslat);
    else
        ilat(3) = round(plat(2)/reslat);
    end
    if(plat(3) > maxlat)
        warning('plat: Too large end value of latitude, should be <= %g.', maxlat);
        plat(3) = maxlat;
    end
    if(plon(1) < minlon)
        warning('plon: Too small start value of longitude, should be >= %g.', minlon);
        plon(1) = minlon;
    end
    if(mod(plon(2), reslon) ~= 0)
        error('plon: Not suitable step value of longitude, must be multiple of %g.', reslon);
    else
        ilon(3) = round(plon(2)/reslon);
    end
    if(plon(3) > maxlon)
        warning('plon: Too large end value of longitude, should be <= %g.', maxlon);
        plon(3) = maxlon;
    end
    
    idep(1:2) = round((pdep([1, 3]) - mindep)/resdep);
    idep(2)   = floor((idep(2) - idep(1))/idep(3)) + 1;
    ilat(1:2) = round((plat([1, 3]) - minlat)/reslat);
    ilat(2)   = floor((ilat(2) - ilat(1))/ilat(3)) + 1;
    ilon(1:2) = round((plon([1, 3]) - minlon)/reslon);
    ilon(2)   = floor((ilon(2) - ilon(1))/ilon(3)) + 1;

    varid = netcdf.inqVarID(ncid, 'depth');
        vdep = netcdf.getVar(ncid, varid, idep(1), idep(2), idep(3));
    varid = netcdf.inqVarID(ncid, 'latitude');
        vlat = netcdf.getVar(ncid, varid, ilat(1), ilat(2), ilat(3));
    varid = netcdf.inqVarID(ncid, 'longitude');
        vlon = netcdf.getVar(ncid, varid, ilon(1), ilon(2), ilon(3));

    varid = netcdf.inqVarID(ncid, 'vsv');
        vsv = netcdf.getVar(ncid, varid, [ilon(1), ilat(1), idep(1)], ...
            [ilon(2), ilat(2), idep(2)], [ilon(3), ilat(3), idep(3)]);
    varid = netcdf.inqVarID(ncid, 'vp');
        vp  = netcdf.getVar(ncid, varid, [ilon(1), ilat(1), idep(1)], ...
            [ilon(2), ilat(2), idep(2)], [ilon(3), ilat(3), idep(3)]);
    varid = netcdf.inqVarID(ncid, 'rho');
        rho = netcdf.getVar(ncid, varid, [ilon(1), ilat(1), idep(1)], ...
            [ilon(2), ilat(2), idep(2)], [ilon(3), ilat(3), idep(3)]);

netcdf.close(ncid);

vsv(vsv == missingvalue) = NaN;
vp (vp  == missingvalue) = NaN;
rho(rho == missingvalue) = NaN;

end
