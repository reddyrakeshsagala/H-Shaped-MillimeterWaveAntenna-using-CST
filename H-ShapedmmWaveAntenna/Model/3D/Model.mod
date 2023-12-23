'# MWS Version: Version 2021.1 - Nov 10 2020 - ACIS 30.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 10 fmax = 40
'# created = '[VERSION]2021.1|30.0.1|20201110[/VERSION]


'@ use template: Antenna - Planar_9.cfg

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
'set the units
With Units
    .Geometry "mm"
    .Frequency "GHz"
    .Voltage "V"
    .Resistance "Ohm"
    .Inductance "H"
    .TemperatureUnit  "Kelvin"
    .Time "ns"
    .Current "A"
    .Conductance "Siemens"
    .Capacitance "F"
End With

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

' optimize mesh settings for planar structures

With Mesh
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "20"
     .AutomeshRefineAtPecLines "True", "6"
     .FPBAAvoidNonRegUnite "True"
     .ConsiderSpaceForLowerMeshLimit "False"
     .MinimumStepNumber "5"
     .AnisotropicCurvatureRefinement "True"
     .AnisotropicCurvatureRefinementFSM "True"
End With

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "6"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With

With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With

' change mesh adaption scheme to energy
' 		(planar structures tend to store high energy
'     	 locally at edges rather than globally in volume)

MeshAdaption3D.SetAdaptionStrategy "Energy"

' switch on FD-TET setting for accurate farfields

FDSolver.ExtrudeOpenBC "True"

PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"

With FarfieldPlot
	.ClearCuts ' lateral=phi, polar=theta
	.AddCut "lateral", "0", "1"
	.AddCut "lateral", "90", "1"
	.AddCut "polar", "90", "1"
End With

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "PBA"
End With

'set the solver type
ChangeSolverType("HF Time Domain")

'----------------------------------------------------------------------------

'@ define material: Silver

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Material
     .Reset
     .Name "Silver"
     .Folder ""
     .FrqType "static"
     .Type "Normal"
     .SetMaterialUnit "Hz", "mm"
     .Epsilon "1"
     .Mu "1.0"
     .Kappa "6.3012e007"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .KappaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "General 1st"
     .DispersiveFittingSchemeMu "General 1st"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .FrqType "all"
     .Type "Lossy metal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .MaterialUnit "Temperature", "Kelvin"
     .Mu "1.0"
     .Sigma "6.3012e007"
     .Rho "10500.0"
     .ThermalType "Normal"
     .ThermalConductivity "429"
     .SpecificHeat "230", "J/K/kg"
     .MetabolicRate "0"
     .BloodFlow "0"
     .VoxelConvection "0"
     .MechanicsType "Isotropic"
     .YoungsModulus "76"
     .PoissonsRatio "0.37"
     .ThermalExpansionRate "20"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "1", "1", "0"
     .Wireframe "False"
     .Reflection "False"
     .Allowoutline "True"
     .Transparentoutline "False"
     .Transparency "0"
     .Create
End With

'@ new component: component1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.New "component1"

'@ define brick: component1:GROUND

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "GROUND" 
     .Component "component1" 
     .Material "Silver" 
     .Xrange "-SSW/2", "SSW/2" 
     .Yrange "-SSL/2", "SSL/2" 
     .Zrange "0", "-0.05" 
     .Create
End With

'@ define material: Rogers RT5880 (lossy)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Material
     .Reset
     .Name "Rogers RT5880 (lossy)"
     .Folder ""
     .FrqType "all"
     .Type "Normal"
     .SetMaterialUnit "GHz", "mm"
     .Epsilon "2.2"
     .Mu "1.0"
     .Kappa "0.0"
     .TanD "0.0009"
     .TanDFreq "10.0"
     .TanDGiven "True"
     .TanDModel "ConstTanD"
     .KappaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstKappa"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "General 1st"
     .DispersiveFittingSchemeMu "General 1st"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0.20"
     .SetActiveMaterial "all"
     .Colour "0.94", "0.82", "0.76"
     .Wireframe "False"
     .Transparency "0"
     .Create
End With

'@ define brick: component1:SUBSTRATE

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "SUBSTRATE" 
     .Component "component1" 
     .Material "Rogers RT5880 (lossy)" 
     .Xrange "-SSW/2", "SSW/2" 
     .Yrange "-SSL/2", "SSL/2" 
     .Zrange "2.2", "0" 
     .Create
End With

'@ activate local coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "local"

'@ move wcs

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.MoveWCS "local", "0.0", "0.0", "2.2"

'@ define brick: component1:FEED

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "FEED" 
     .Component "component1" 
     .Material "Silver" 
     .Xrange "-FW50/2", "FW50/2" 
     .Yrange "-FL50/2", "FL50/2" 
     .Zrange "0", "0.05" 
     .Create
End With

'@ transform: translate component1:FEED

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1:FEED" 
     .Vector "0", "-6.195", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ define brick: component1:FEEDMIDDLE

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "FEEDMIDDLE" 
     .Component "component1" 
     .Material "Silver" 
     .Xrange "-FW/2", "FW/2" 
     .Yrange "-FL/2", "FL/2" 
     .Zrange "0", "0.05" 
     .Create
End With

'@ transform: translate component1:FEEDMIDDLE

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1:FEEDMIDDLE" 
     .Vector "0", "-1.92", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ define brick: component1:ANTENNA

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "ANTENNA" 
     .Component "component1" 
     .Material "Silver" 
     .Xrange "-PW/2", "PW/2" 
     .Yrange "-PL/2", "PL/2" 
     .Zrange "0", "0.05" 
     .Create
End With

'@ transform: translate component1:ANTENNA

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1:ANTENNA" 
     .Vector "0", "2", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:ANTENNA

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1:ANTENNA" 
     .Vector "0", "1", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:ANTENNA

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1:ANTENNA" 
     .Vector "0", "-0.535", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ define brick: component1:ANTCUT

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "ANTCUT" 
     .Component "component1" 
     .Material "Silver" 
     .Xrange "-SW/2", "SW/2" 
     .Yrange "-SL/2", "SL/2" 
     .Zrange "0", "0.05" 
     .Create
End With

'@ transform: translate component1:ANTCUT

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1:ANTCUT" 
     .Vector "-0.4", "1.75", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:ANTCUT

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1:ANTCUT" 
     .Vector "0.4", "1.75", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ define brick: component1:ANTCUU

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "ANTCUU" 
     .Component "component1" 
     .Material "Silver" 
     .Xrange "-SAW/2", "SAW/2" 
     .Yrange "-SAL/2", "SAL/2" 
     .Zrange "0", "0.05" 
     .Create
End With

'@ define brick: component1:ANNCUUUT

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "ANNCUUUT" 
     .Component "component1" 
     .Material "Silver" 
     .Xrange "-SBL/2", "SBL/2" 
     .Yrange "-SBW/2", "SBW/2" 
     .Zrange "0", "0.05" 
     .Create
End With

'@ transform: translate component1:ANNCUUUT

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1:ANNCUUUT" 
     .Vector "0", "3.3", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:ANTCUU

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1:ANTCUU" 
     .Vector "0.9", "3.3", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:ANTCUU

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1:ANTCUU" 
     .Vector "-0.9", "3.3", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ boolean subtract shapes: component1:ANTENNA, component1:ANTCUT

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:ANTENNA", "component1:ANTCUT"

'@ boolean subtract shapes: component1:ANTENNA, component1:ANTCUT_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:ANTENNA", "component1:ANTCUT_1"

'@ boolean add shapes: component1:ANTENNA, component1:FEED

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:ANTENNA", "component1:FEED"

'@ boolean add shapes: component1:ANTENNA, component1:FEEDMIDDLE

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:ANTENNA", "component1:FEEDMIDDLE"

'@ boolean add shapes: component1:ANTCUU, component1:ANNCUUUT

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:ANTCUU", "component1:ANNCUUUT"

'@ boolean add shapes: component1:ANTCUU, component1:ANTCUU_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:ANTCUU", "component1:ANTCUU_1"

'@ delete shape: component1:ANTCUU

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Delete "component1:ANTCUU"

'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ define frequency range

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solver.FrequencyRange "10", "40"

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component1:ANTENNA", "9"

'@ define port: 1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Port 
     .Reset 
     .PortNumber "1" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "0"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "-0.775", "0.775"
     .Yrange "-7.5", "-7.5"
     .Zrange "2.2", "2.25"
     .XrangeAdd "0.7", "0.7"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "0.7", "0.7"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ define time domain solver parameters

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

