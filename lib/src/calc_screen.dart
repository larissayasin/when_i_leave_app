import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalcScreen extends StatefulWidget {
  createState() {
    return CalcScreenState();
  }
}

class CalcScreenState extends State<CalcScreen> {
  TimeOfDay _arriveWork;
  TimeOfDay _leaveLunch;
  TimeOfDay _arriveLunch;

  Future<TimeOfDay> _selectTime(
      BuildContext context, TimeOfDay timeOfDayInit) async {
    return await showTimePicker(
        context: context, initialTime: timeOfDayInit ?? TimeOfDay.now());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            margin: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                  child: arrivedWork(context),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                  child: leaveLunch(context),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                  child: arriveLunch(context),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
                  child: btnLeavingTime(context),
                ),
                Text('Horário de saída: $leave', textAlign: TextAlign.left)
              ],
            )));
  }

  String leave = '';

  int _totalWork = 480;

  String leavingTime() {
    final now = new DateTime.now();
    final awDt = DateTime(
        now.year, now.month, now.day, _arriveWork.hour, _arriveWork.minute);
    final llDt = DateTime(
        now.year, now.month, now.day, _leaveLunch.hour, _leaveLunch.minute);
    final alDt = DateTime(
        now.year, now.month, now.day, _arriveLunch.hour, _arriveLunch.minute);

    int morningDiff = llDt.difference(awDt).inMinutes;
    int leftWork =_totalWork - morningDiff ;

    print(alDt.toString());
   DateTime lwDt = alDt.add(new Duration(minutes: leftWork));

    print(lwDt.toString());

    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(lwDt);
  }

  Widget btnLeavingTime(BuildContext context) {
    return RaisedButton(
        color: Colors.blue[800],
        textColor: Colors.white,
        child: Text("Calcular"),
        onPressed: () {
          setState(() {
            leave = leavingTime();
          });
        });
  }

  Widget leaveLunch(BuildContext context) {
    return new _InputDropdown(
      labelText: "Horário Saída Almoço",
      valueText: formatTimeOfDay(_leaveLunch),
      onPressed: () {
        _selectTime(context, _leaveLunch).then((TimeOfDay tod) {
          setState(() {
            _leaveLunch = tod;
          });
        });
      },
    );
  }

  Widget arriveLunch(BuildContext context) {
    return new _InputDropdown(
      labelText: "Horário Chegada Almoço",
      valueText: formatTimeOfDay(_arriveLunch),
      onPressed: () {
        _selectTime(context, _arriveLunch).then((TimeOfDay tod) {
          setState(() {
            _arriveLunch = tod;
          });
        });
      },
    );
  }

  Widget arrivedWork(BuildContext context) {
    return new _InputDropdown(
      labelText: "Horário entrada",
      valueText: formatTimeOfDay(_arriveWork),
      onPressed: () {
        _selectTime(context, _arriveWork).then((TimeOfDay tod) {
          setState(() {
            _arriveWork = tod;
          });
        });
      },
    );
  }

  String formatTimeOfDay(TimeOfDay tod) {
    if (tod == null) return "Selecione";
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}
