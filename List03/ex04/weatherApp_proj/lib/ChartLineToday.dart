import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartLineToday extends StatelessWidget{
  final List<String> time;
  final List<double> temperature;
  final double size;

  ChartLineToday(this.time, this.temperature, this.size);

  @override
  Widget build(BuildContext context) {
    List<FlSpot> listSpot = [];

    for(double index = 0; index < time.length; ++index){
      listSpot.add(FlSpot(index, temperature[index.toInt()]));
    }
    

    return  
      AspectRatio(
        aspectRatio: 1, 
        child: LineChart(
          LineChartData(
            lineBarsData: [ 
              LineChartBarData(
                spots: listSpot,
                isCurved: true,
                dotData: const FlDotData(show: true),
                color: Colors.orange,
                barWidth: 5,
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.orange.withOpacity(0.7),
                ),
              )
            ],
            minX: 0,
            maxX: 24,
            minY:  temperature.reduce((valorAtual, proximoValor) => valorAtual < proximoValor ? valorAtual : proximoValor) - 1,
            maxY:  temperature.reduce((valorAtual, proximoValor) => valorAtual > proximoValor ? valorAtual : proximoValor) + 1,
            backgroundColor: Colors.black.withOpacity(0.7),
            titlesData: FlTitlesData(
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 20,
                  getTitlesWidget: (value, meta) {
                    return const SizedBox();
                  },
                  )),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: 
                AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: size * 0.035,
                    getTitlesWidget: (value, meta) {
                      int num = value.toInt();
                      if(num == 0){
                        return const Text("");
                      }
                      else if(num == 24){
                        num = 23;
                      }
                      else if(num % 5 != 0){
                        return const Text("");
                      }
                     
                      String text = num.toString().length < 2 ? "0${num.toString()}:00" : "${num.toString()}:00";
                      return Container(
                        margin: EdgeInsets.only(right: size * 0.07),
                        child: Text(text, 
                          style: TextStyle(
                            fontSize: size * 0.035, 
                            color: Colors.white, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
               leftTitles: 
                AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize:  size * 0.09,
                    getTitlesWidget: (value, meta) {
                      if(value % 1 != 0){
                        return const Text("");
                      }
                      String text = "${value.toInt().toString()}ºC";
                      return Container(
                        child: Text(
                          text, 
                          style: TextStyle(
                            fontSize: size * 0.035, 
                            color: Colors.white, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                )
            ),
          ),
        ),
      );
  }
}