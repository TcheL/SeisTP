function [sacheader, wavedata] = ReadSAC(filename)
% ReadSAC(filename)
% This is a program to read a SAC file from IRIS and plot the waveform.
% Written by Tche.L. from USTC, 2016.3.
%
% filename: a string, the SAC file name.

%% Read the header part of the file
fid = fopen(filename);

FType = fread(fid,70, 'float');
NType = fread(fid,15, 'int');
IType = fread(fid,20, 'int');
LType = fread(fid,5, 'int');
KType = fread(fid, [8,24], '*char');

%% Organize the header data
sacheader.delta = FType(1);
sacheader.depmin = FType(2);
sacheader.depmax = FType(3);
sacheader.scale = FType(4);
sacheader.odelta = FType(5);
sacheader.b = FType(6);
sacheader.e = FType(7);
sacheader.o = FType(8);
sacheader.a = FType(9);
sacheader.t0 = FType(11);
sacheader.t1 = FType(12);
sacheader.t2 = FType(13);
sacheader.t3 = FType(14);
sacheader.t4 = FType(15);
sacheader.t5 = FType(16);
sacheader.t6 = FType(17);
sacheader.t7 = FType(18);
sacheader.t8 = FType(19);
sacheader.t9 = FType(20);
sacheader.f = FType(21);
sacheader.resp0 = FType(22);
sacheader.resp1 = FType(23);
sacheader.resp2 = FType(24);
sacheader.resp3 = FType(25);
sacheader.resp4 = FType(26);
sacheader.resp5 = FType(27);
sacheader.resp6 = FType(28);
sacheader.resp7 = FType(29);
sacheader.resp8 = FType(30);
sacheader.resp9 = FType(31);
sacheader.stla = FType(32);
sacheader.stlo = FType(33);
sacheader.stel = FType(34);
sacheader.stdp = FType(35);
sacheader.evla = FType(36);
sacheader.evlo = FType(37);
sacheader.evel = FType(38);
sacheader.evdp = FType(39);
sacheader.mag = FType(40);
sacheader.user0 = FType(41);
sacheader.user1 = FType(42);
sacheader.user2 = FType(43);
sacheader.user3 = FType(44);
sacheader.user4 = FType(45);
sacheader.user5 = FType(46);
sacheader.user6 = FType(47);
sacheader.user7 = FType(48);
sacheader.user8 = FType(49);
sacheader.user9 = FType(50);
sacheader.dist = FType(51);
sacheader.az = FType(52);
sacheader.baz = FType(53);
sacheader.gcarc = FType(54);
sacheader.depmen = FType(57);
sacheader.cmpaz = FType(58);
sacheader.cmpinc = FType(59);
sacheader.xminimum = FType(60);
sacheader.xmaximum = FType(61);
sacheader.yminimum = FType(62);
sacheader.ymaximum = FType(63);
sacheader.nzyear = NType(1);
sacheader.nzjday = NType(2);
sacheader.nzhour = NType(3);
sacheader.nzmin = NType(4);
sacheader.nzsec = NType(5);
sacheader.nzmsec = NType(6);
sacheader.nvhdr = NType(7);
sacheader.norid = NType(8);
sacheader.nevid = NType(9);
sacheader.npts = NType(10);
sacheader.nwfid = NType(12);
sacheader.nxsize = NType(13);
sacheader.nysize = NType(14);
sacheader.iftype = IType(1);
sacheader.idep = IType(2);
sacheader.iztype = IType(3);
sacheader.iinst = IType(5);
sacheader.istreg = IType(6);
sacheader.ievreg = IType(7);
sacheader.ievtyp = IType(8);
sacheader.iqual = IType(9);
sacheader.isynth = IType(10);
sacheader.imagtyp = IType(11);
sacheader.imagsrc = IType(12);
sacheader.leven = LType(1);
sacheader.lpspol = LType(2);
sacheader.lovrok = LType(3);
sacheader.lcalda = LType(4);
sacheader.kstnm = deblank(KType(:,1)');
sacheader.kevnm = deblank([KType(:,2); KType(:,3)]');
sacheader.khole = deblank(KType(:,4)');
sacheader.k0 = deblank(KType(:,5)');
sacheader.ka = deblank(KType(:,6)');
sacheader.kt0 = deblank(KType(:,7)');
sacheader.kt1 = deblank(KType(:,8)');
sacheader.kt2 = deblank(KType(:,9)');
sacheader.kt3 = deblank(KType(:,10)');
sacheader.kt4 = deblank(KType(:,11)');
sacheader.kt5 = deblank(KType(:,12)');
sacheader.kt6 = deblank(KType(:,13)');
sacheader.kt7 = deblank(KType(:,14)');
sacheader.kt8 = deblank(KType(:,15)');
sacheader.kt9 = deblank(KType(:,16)');
sacheader.kf = deblank(KType(:,17)');
sacheader.kuser0 = deblank(KType(:,18)');
sacheader.kuser1 = deblank(KType(:,19)');
sacheader.kuser2 = deblank(KType(:,20)');
sacheader.kcmpnm = deblank(KType(:,21)');
sacheader.knetwk = deblank(KType(:,22)');
sacheader.kdatrd = deblank(KType(:,23)');
sacheader.kinst = deblank(KType(:,24)');

%% Process the header data
[nzojday, nzohour, nzomin, nzosec] = StandardizeTimeDHMS(sacheader.nzjday, ...
    sacheader.nzhour, sacheader.nzmin, sacheader.nzsec + sacheader.o);
[nzmonth, nzday] = jday2mmdd(sacheader.nzyear, nzojday);
if(sacheader.cmpaz == 0 && sacheader.cmpinc == 90)
	cmpname = 'N-S Component';
elseif(sacheader.cmpaz == 90 && sacheader.cmpinc == 90)
	cmpname = 'E-W Component';
elseif(sacheader.cmpaz == 0 && sacheader.cmpinc == 0)
	cmpname = 'U-D Component';
else
	cmpname = 'Can''t automatically identify the component name';
end

%% Read the waveform data
wavedata = fread(fid, sacheader.npts, 'float');
fclose(fid);

%% Plot the waveform
if(1)
  figure; plot(wavedata);
  xlabel('time'); ylabel(cmpname);
  title({['The waveform of ', sacheader.knetwk, '.', sacheader.kstnm, ' of the event ', ...
      sacheader.kevnm, sprintf(' %d/%d/%d', sacheader.nzyear, nzmonth, nzday)], ...
      [sprintf('%d:%d:%.2f (UTC)', nzohour, nzomin, nzosec), ' with \Delta = ', ...
      sprintf('%.2f', sacheader.gcarc), ' \circ']});
end

end

function [month, day] = jday2mmdd(year, jday)
% [month, day] = jday2mmdd(year, jday)
% This ia a program that gets the month and day number from the first few days of a year.
% Eg. the 32nd day of a year is the 1st day of February.
% Written by Tche.L. from USTC, 2016,3.
%
% month: a constant variable, the month number.
% day: a constant variable, the day number.
%
% year: a constant variable, the year number.
% jday: a constant variable, the number of the first few days of year.
%
% Eg. [3, 1] = jday2mmdd(2016, 61)

if(mod(year,100) == 0)
    if(mod(year,400) == 0)
		isleapyear = 1;
	else
		isleapyear = 0;
    end
else
    if(mod(year,4) == 0)
		isleapyear = 1;
	else
		isleapyear = 0;
    end
end

month = 1;
monday = 31;                                % the total day number of month.
while(jday > monday)
    jday = jday - monday;
    month = month + 1;
    if(month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
        monday = 31;
    elseif(month == 4 || month == 6 || month == 9 || month == 11)
        monday = 30;
    else
        if(isleapyear == 1)
            monday = 29;
        else
            monday = 28;
        end
    end
end
day = jday;

end

function [nday, nhour, nmin, nsec] = StandardizeTimeDHMS(nday, nhour, nmin, nsec)
% [nday, nhour, nmin, nsec] = StandardizeTimeDHMS(nday, nhour, nmin, nsec)
% This is a program to standardize time only for some days, hours, minutes and seconds.
% Eg. 82 senconds is 1 minutes and 22 seconds.
% Written by Tche.L. from USTC, 2016,3
%
% nday: a constant variable, the day number.
% nhour: a constant variable, the hour number.
% nmin: a constant variable, the minute number.
% nsec: a constant variable, the second number.
%
% Eg. [2, 3, 4, 22] = StandardizeTimeDHMS(1, 24+1, 60+3, 3600+60+22)

sec2min = fix(nsec/60);
nsec = mod(nsec, 60);
nmin = nmin + sec2min;

min2hour = fix(nmin/60);
nmin = mod(nmin, 60);
nhour = nhour + min2hour;

hour2day = fix(nhour/24);
nhour = mod(nhour, 24);
nday = nday + hour2day;

end
