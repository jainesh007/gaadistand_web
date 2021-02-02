import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';



class AccountHistory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccountHistoryState();
  }
}

class _AccountHistoryState extends State<AccountHistory> {

  List<String> examples = new List<String>();

  @override
  void initState() {
    super.initState();

    examples.add("1");
    examples.add("2");
    examples.add("3");
    examples.add("4");
    examples.add("5");
    examples.add("6");
    examples.add("6");
    examples.add("6");
    examples.add("6");
    examples.add("6");
    examples.add("6");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(

            children: <Widget>[

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top:15),
                  child: Text("Account History" ,style: TextStyle(fontSize: 18.0, color: Colors.black,fontWeight: FontWeight.bold)),
                ),
              ),

              SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: examples.length,
                  itemBuilder: (BuildContext context, int index) {

                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.1,
                        isFirst: index == 0,
                        isLast: index == examples.length - 1,
                        indicatorStyle: IndicatorStyle(
                          width: 60,
                          height: 60,
                          indicator: _IndicatorExample(number: '${index + 1}'),
                          drawGap: true,
                        ),

                        beforeLineStyle: LineStyle(color: Colors.black),

                        endChild: GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("THis is the time line for bsaibfias asbfipasas asfgiasgfas ibfsiasb ${examples[index]}",style: TextStyle(fontSize: 15,color: Colors.black),),
                          ),
                          onTap: () {

                          },
                        ),
                      ),
                    );
                  },
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}


class _IndicatorExample extends StatelessWidget {
  const _IndicatorExample({Key key, this.number}) : super(key: key);

  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(fontSize: 15,color: Colors.black),
        ),
      ),
    );
  }
}

