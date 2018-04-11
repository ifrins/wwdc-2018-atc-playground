# ATC: A day in Air Traffic Control

## Introduction
More than 100.000 flights are scheduled every day. People visiting family, going on vacation or to the WWDC. It’s ATC responsability to keep the flights safe.
This visualization shows how they do it, focusing on the radars they use. Oh, and using **real data**.

See the playground on [YouTube](https://youtu.be/pWUEkQliDcc)


## Radar

![](https://i.imgur.com/yJBXnTV.png)

Each plane is represented as a green square. 

The first line shows the call sign of the plane –or the IATA plane code. 
They use the NATO phonetic alphabet to say the call sign when contacted over the radio. 
For example, AY 5657 is Alpha Yankee Five Six Five Seven.

The second line shows the altitude of the plane in feet (1 ft = 0.3 m) and the speed in knots (1 kt = 1.15 mph = 1.85 km/h).

Then there's a line inside the plane. It indicates tail direction. If it's going to the north, then the tail will be pointing to the south. 

What happens if there's an emergency? The green text turns into red. 

## Tech Details

All the maps are custom-drawn using UIKit with Core Graphics. 

The main tech challenge for this Playground has been fitting plane position data into the 25 MB size limit. A custom binary 
format was developed to be able to store efficiently this data. Data was collected in JSON format and converted to the custom 
format for this playground.

In average, every data point originally consumed 277 bytes. With the binary format, every data point is only 7 bytes. 

The difference is astonishing, from being able to store 72,000 data points, to being able to store 2.8 million. 

The custom format not only offers better storage efficiency but also makes playing the animations more efficient, 
as it contains a table that maps data points to frames. 
