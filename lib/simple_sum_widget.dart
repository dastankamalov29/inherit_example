import 'package:flutter/material.dart';

class SimpleCalcWidget extends StatefulWidget {
  const SimpleCalcWidget({super.key});

  @override
  State<SimpleCalcWidget> createState() => _SimpleCalcWidgetState();
}

class _SimpleCalcWidgetState extends State<SimpleCalcWidget> {
  final _model = SimpleCalcWidgetModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: SimpleCalcWidgetProvider(
            model: _model,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FirstNumberWidget(),
                SizedBox(height: 10),
                SecondNumberWidget(),
                SizedBox(height: 10),
                SummButtonWidget(),
                SizedBox(height: 10),
                ResultWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FirstNumberWidget extends StatelessWidget {
  const FirstNumberWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
      //Подключение к inherit с помошью замыкания
      onChanged: (value) =>
          SimpleCalcWidgetProvider.of(context)?.firstNumber = value,
    );
  }
}

class SecondNumberWidget extends StatelessWidget {
  const SecondNumberWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),

      //Подключение к inherit с помошью замыкания
      onChanged: (value) =>
          SimpleCalcWidgetProvider.of(context)?.secondNumber = value,
    );
  }
}

class SummButtonWidget extends StatelessWidget {
  const SummButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      //Подключение к методу модели к функции summ()
      onPressed: () => SimpleCalcWidgetProvider.of(context)?.summ(),
      child: const Text("Посчитать сумму"),
    );
  }
}
//Заменяю этот код inheritedNotifier кодом ниже
// class ResultWidget extends StatefulWidget {
//   const ResultWidget({super.key});

//   @override
//   State<ResultWidget> createState() => _ResultWidgetState();
// }

// class _ResultWidgetState extends State<ResultWidget> {
//   String _value = '-1';

//   //didChangeDependenciess будет вызываться когда будет меняться inherit
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final model = SimpleCalcWidgetProvider.of(context)?.model;
//     if (model != null) {
//       model.addListener(() {
//         setState(() {
//           _value = "${model.sumResult}";
//         });
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final value = SimpleCalcWidgetProvider.of(context)?.model.sumResult ?? 0;
//     return Text(
//       "Результат: ${_value}",
//     );
//   }
// }

// extension on int {
//   get sumResult => null;
// }
class ResultWidget extends StatelessWidget {
  const ResultWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = SimpleCalcWidgetProvider.of(context)?.sumResult ?? '-1';
    return Text("Результат: $value");
  }
}

//Кусок бизнес логики
class SimpleCalcWidgetModel extends ChangeNotifier {
  int? _firstNumber;
  int? _secondNumber;
  int? sumResult;

  //Text field хронит цифры в строках, а эта фукнция превращает их в числа
  set firstNumber(String value) => _firstNumber = int.tryParse(value);
  set secondNumber(String value) => _secondNumber = int.tryParse(value);

  //Логика для сумирования
  void summ() {
    int? sumResult;

    if (_firstNumber != null && _secondNumber != null) {
      sumResult = _firstNumber! + _secondNumber!;
    } else {
      sumResult = null;
    }
    if (this.sumResult != sumResult) {
      this.sumResult = sumResult;
      notifyListeners();
    }
  }
}

//Провайдер который будет это все доставлять
class SimpleCalcWidgetProvider
    extends InheritedNotifier<SimpleCalcWidgetModel> {
  final SimpleCalcWidgetModel model;
  SimpleCalcWidgetProvider({
    super.key,
    required this.model,
    required Widget child,
  }) : super(
          child: child,
          notifier: model,
        );

  static SimpleCalcWidgetModel? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SimpleCalcWidgetProvider>()
        ?.model;
  }
}
