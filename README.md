# SeisTP

Some seismology minitools and miniprograms.

## License

[The MIT License](http://tchel.mit-license.org)

## PREM

Uniformly discrete the Preliminary Reference Earth Model by the fixed depth interval (the thickness of layer).

As an example, you can just run the follow command in  **matlab**:

```matlab
>> hintv = 10;
>> [h, vp, vs, rho] = PREM(hintv);
```

where `hintv` is the depth sampling interval, `h` is the depth from the surface of earth to the depth point, `vp` is the P-wave velocity at every depth point, `vs` is the S-wave velocity at every depth point, and `rho` is the density at every depth point.

![PREM(10)](./figures/PREM-10.png)

**NOTICE**: After the uniformly discretization of PREM, the velocity variation at the discontinuity interfaces may be NOT enough accurate. If you have a strict requirement, you can make a few adjustments at the interfaces.

## ReadSAC

Read a SAC-formatted file.

As an example, you can just run the follow command in  **matlab**:

```matlab
>> [h, d] = ReadSAC('examples/IC.XAN.00.BH1.M.2016.036.195527.SAC')
```

where `h` is file header information of the example file _examples/IC.XAN.00.BH1.M.2016.036.195527.SAC_, and `d` is waveform data in the file.

![ReadSAC('examples/IC.XAN.00.BH1.M.2016.036.195527.SAC')](./figures/IC.XAN_TW20160205.png)

