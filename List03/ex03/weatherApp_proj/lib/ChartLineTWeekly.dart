import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartLineTWeekly extends StatelessWidget{
  final List<String> days;
  final List<double> min;
  final List<double> max;
  final double size;

  ChartLineTWeekly(this.days, this.min, this.max,this.size);

  @override
  Widget build(BuildContext context) {
    List<FlSpot> listSpotMin = [];
    List<FlSpot> listSpotMax = [];
    List<String> datesChartX = [];

    for(double index = 0; index < days.length; ++index){
      listSpotMin.add(FlSpot(index, min[index.toInt()]));
      listSpotMax.add(FlSpot(index, max[index.toInt()]));
    }

    return  
      AspectRatio(
        aspectRatio: 1, 
        child: LineChart(
          LineChartData(
            lineBarsData: [ 
              LineChartBarData(
                spots: listSpotMin,
                isCurved: true,
                dotData: const FlDotData(show: true),
                color: Colors.blue,
                barWidth: 5,
                belowBarData: BarAreaData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: listSpotMax,
                isCurved: true,
                dotData: const FlDotData(show: true),
                color: Colors.red,
                barWidth: 5,
                belowBarData: BarAreaData(
                  show: false,
                ),
              )
            ],
            minX: 0,
            maxX: 6,
            minY:  min.reduce((valorAtual, proximoValor) => valorAtual < proximoValor ? valorAtual : proximoValor) - 1,
            maxY:  max.reduce((valorAtual, proximoValor) => valorAtual > proximoValor ? valorAtual : proximoValor) + 1,
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
                    reservedSize: size * 0.04,
                    getTitlesWidget: (value, meta) {
                      int num = value.toInt();                   
                      String text = days[num];
                      if(num == 0 || datesChartX.contains(text)){
                        return const Text("");
                      }
                      datesChartX.add(text);
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