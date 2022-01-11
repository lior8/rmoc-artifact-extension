#!/bin/bash

small_scale_evaluation() {
  echo
  echo "----- Small-Scale Evaluation -----"
  echo

  echo "(1) Generate Networks Datasets from Rocketfuel Topologies."
  python3 Scripts/NetworkDataSets.py $1

  mkdir -p OutputDataSets/Rocketfuel/AS$1/HopsLength/ProductOrderHopsLengths
  mkdir -p OutputDataSets/Rocketfuel/AS$1/WidthHops/ProductOrderWidthHops
  mkdir -p OutputDataSets/Rocketfuel/AS$1/WidthLength/ProductOrderWidthLengths
  mkdir -p OutputDataSets/Rocketfuel/AS$1/WidthHopsLength/ProductOrderWidthHopsLengths

  mkdir -p OutputDataSets/Rocketfuel/AS$1/WidthLength/WidestShortestOrder
  mkdir -p OutputDataSets/Rocketfuel/AS$1/WidthLength/ShortestWidestOrder

  echo "(2) Execute Simulation of Dominant-Paths Vectoring Protocols."
  echo
  if [ $3 = "y" ] || [ $3 = "yes" ]
  then
    echo -e "\t+ Compiling and Linking Programs"
    make -C Simulator clean all > /dev/null
  fi

  ./Simulator/Executables/SimulateNonRestartingProtocol -n Rocketfuel/AS$1/HopsLength      	-o ProductOrderHopsLengths      -r $2
  ./Simulator/Executables/SimulateNonRestartingProtocol -n Rocketfuel/AS$1/WidthHops       	-o ProductOrderWidthHops        -r $2
  ./Simulator/Executables/SimulateNonRestartingProtocol -n Rocketfuel/AS$1/WidthLength     	-o ProductOrderWidthLengths     -r $2
  ./Simulator/Executables/SimulateNonRestartingProtocol -n Rocketfuel/AS$1/WidthHopsLength 	-o ProductOrderWidthHopsLengths -r $2
  ./Simulator/Executables/SimulateNonRestartingProtocol -n Rocketfuel/AS$1/WidthLength 	   	-o ShortestWidestOrder          -r $2
  ./Simulator/Executables/SimulateNonRestartingProtocol -n Rocketfuel/AS$1/WidthLength     	-o WidestShortestOrder          -r $2

  ./Simulator/Executables/SimulateRestartingProtocol 	  -n Rocketfuel/AS$1/HopsLength       -o ProductOrderHopsLengths      -r $2
  ./Simulator/Executables/SimulateRestartingProtocol 	  -n Rocketfuel/AS$1/WidthHops        -o ProductOrderWidthHops        -r $2
  ./Simulator/Executables/SimulateRestartingProtocol 	  -n Rocketfuel/AS$1/WidthLength      -o ProductOrderWidthLengths     -r $2
  ./Simulator/Executables/SimulateRestartingProtocol 	  -n Rocketfuel/AS$1/WidthHopsLength  -o ProductOrderWidthHopsLengths -r $2

  echo
  echo "(3) Produce Plots with CCDFs of Number of Dominant Attributes and Termination Times."

  python3 Scripts/PlotNumberDominantAttributes.py $1
  python3 Scripts/PlotTerminationTimes.py $1

  echo "-----"
  echo
}

if [ "$#" -ne 3 ];
then
  echo "Parameters should be AS number and number of trials and if to compile (yes/no)"
else
  small_scale_evaluation $1 $2 $3
fi
