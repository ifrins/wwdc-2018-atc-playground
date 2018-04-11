/*:
## Final Words

Hope you enjoyed experiencing an ATC Radar.

What you experienced, was in fact, real. That's what an Air Traffic Controller could see over the 28th March. Data was collected through ADS-B Exchange, a network of volunteers collecting ADS-B signals from planes. 

## Technology

All the maps are custom-drawn using UIKit with Core Graphics. 

The main tech challenge for this Playground has been fitting plane position data into the 25 MB size limit. A custom binary 
format was developed to be able to store efficiently this data. Data was collected in JSON format and converted to the custom 
format for this playground.

In average, every data point originally consumed 277 bytes. With the binary format, every data point is only 7 bytes. 

The difference is astonishing, from being able to store 72,000 data points, to being able to store 2.8 million. 

The custom format not only offers better storage efficiency but also makes playing the animations more efficient, 
as it contains a table that maps data points to frames. 
*/