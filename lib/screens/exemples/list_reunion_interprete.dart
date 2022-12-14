import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/material.dart';

import '../../constantes/theme_variable.dart';

class ListReunionInterprete extends StatefulWidget {
  const ListReunionInterprete({Key? key}) : super(key: key);

  @override
  State<ListReunionInterprete> createState() => _ListReunionInterpreteState();
}

class _ListReunionInterpreteState extends State<ListReunionInterprete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CalendarAppBar(
        lastDate: DateTime.now().add(const Duration(days: 7)),
        firstDate: DateTime.now()
            .subtract(DateTime.now().difference(DateTime(2022, 11, 28))),
        selectedDate: DateTime.now(),
        onDateChanged: (DateTime value) {},
        locale: 'fr',
        backButton: false,
        accent: APP_PRIMARY,
        fullCalendar: false,
        events: [
          DateTime.now(),
          DateTime.now().add(Duration(days: 2))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
                color: APP_PRIMARY,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: APP_LIGHT, width: 2.0),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(1.0, 2.0),
                    color: APP_DARK.withOpacity(0.1),
                    blurRadius: 8.0,
                  ),
                  BoxShadow(
                    offset: const Offset(1.0, 2.0),
                    color: APP_DARK.withOpacity(0.1),
                    blurRadius: 8.0,
                  ),
                ]),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Aujourd\'hui :',
                style: TextStyle(
                    color: APP_LIGHT,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Réunion de présentation de projet - Barry Sow',
                style: TextStyle(
                    color: APP_LIGHT,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: APP_LIGHT,
                        size: 12,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Mardi le 06, Décembre 2022',
                          style: TextStyle(
                              color: APP_LIGHT,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Row(
                    children: const [
                      Icon(
                        Icons.hourglass_bottom,
                        color: APP_LIGHT,
                        size: 12,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('16h 00',
                          style: TextStyle(
                              color: APP_LIGHT,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                          elevation: 0.0,
                          backgroundColor: APP_LIGHT,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: const Text('Rejoindre',
                          style: TextStyle(
                              color: APP_PRIMARY,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500))),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: APP_LIGHT, width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Text(
                      'Annuler la réunion',
                      style: TextStyle(
                          color: APP_LIGHT,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              )
            ]),
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            'Les réunions à venir',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: APP_GREY.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 8,
                  height: 50,
                  decoration: BoxDecoration(
                    color: APP_PRIMARY,
                    borderRadius: BorderRadius.circular(8)
                  ),
                ),
                Column(
                  children: const [
                    Text('10', style: TextStyle(
                      fontSize: 18,
                      color: APP_LIGHT,
                      fontWeight: FontWeight.w500
                    ),),
                    Text('Déc', style: TextStyle(
                      fontSize: 18,
                      color: APP_LIGHT,
                      fontWeight: FontWeight.w700
                    ),)
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Meetings avec Harry', style: TextStyle(
                      fontSize: 16,
                      color: APP_LIGHT,
                      fontWeight: FontWeight.w600
                    )),
                    Text('Fait par : Barry Sow', style: TextStyle(
                      fontSize: 12,
                      color: APP_LIGHT,
                      fontWeight: FontWeight.w500
                    ))
                  ],
                ),
                ElevatedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                          elevation: 0.0,
                          backgroundColor: APP_PRIMARY,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: const Text('Annuler',
                          style: TextStyle(
                              color: APP_LIGHT,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: APP_GREY.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 8,
                  height: 50,
                  decoration: BoxDecoration(
                    color: APP_LIGHT,
                    borderRadius: BorderRadius.circular(8)
                  ),
                ),
                Column(
                  children: const [
                    Text('23', style: TextStyle(
                      fontSize: 18,
                      color: APP_PRIMARY,
                      fontWeight: FontWeight.w500
                    ),),
                    Text('Déc', style: TextStyle(
                      fontSize: 18,
                      color: APP_PRIMARY,
                      fontWeight: FontWeight.w700
                    ),)
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Meetings avec Barry', style: TextStyle(
                      fontSize: 16,
                      color: APP_LIGHT,
                      fontWeight: FontWeight.w600
                    )),
                    Text('Fait par : Harry', style: TextStyle(
                      fontSize: 12,
                      color: APP_LIGHT,
                      fontWeight: FontWeight.w500
                    ))
                  ],
                ),
                ElevatedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                          elevation: 0.0,
                          backgroundColor: APP_LIGHT,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: const Text('Annuler',
                          style: TextStyle(
                              color: APP_PRIMARY,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600))),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text('Autres réunions',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: APP_PRIMARY,
                  borderRadius: BorderRadius.circular(10)
                ),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Meeting Test',
                     style: TextStyle(
                        color: APP_LIGHT,
                        fontSize: 18,
                        fontWeight: FontWeight.w700
                    ),),
                    const SizedBox(height: 10,),
                    Row(children: const [
                      Icon(Icons.calendar_today, color: APP_LIGHT,),
                      SizedBox(width: 5,),
                      Text('Début : 28 Décembre 2022 à 22:00', style: TextStyle(
                        color: APP_LIGHT,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),)
                    ],),
                    const SizedBox(height: 5,),
                    Row(children: const [
                      Icon(Icons.calendar_today, color: APP_LIGHT,),
                      SizedBox(width: 5,),
                      Text('Fin : 28 Décembre 2022 à 00:00', style: TextStyle(
                        color: APP_LIGHT,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),)
                    ],),
                    const SizedBox(height: 5,),
                    Row(children: const [
                      Icon(Icons.account_circle_rounded, color: APP_LIGHT,),
                      SizedBox(width: 5,),
                      Text('Créée par : Barry Sow', style: TextStyle(
                        color: APP_LIGHT,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),)
                    ],),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                                elevation: 0.0,
                                backgroundColor: APP_LIGHT,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: const Text('Valider',
                                style: TextStyle(
                                    color: APP_PRIMARY,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500))),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: APP_LIGHT, width: 1.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: const Text(
                            'Pas intéressé(e)',
                            style: TextStyle(
                                color: APP_LIGHT,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    )
                  ]),
                  
              ),
              Container(
                decoration: BoxDecoration(
                  color: APP_PRIMARY.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10)
                ),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Meeting Test 1',
                     style: TextStyle(
                        color: APP_LIGHT,
                        fontSize: 18,
                        fontWeight: FontWeight.w700
                    ),),
                    const SizedBox(height: 10,),
                    Row(children: const [
                      Icon(Icons.calendar_today, color: APP_LIGHT,),
                      SizedBox(width: 5,),
                      Text('Début : 30 Décembre 2022 à 13:00', style: TextStyle(
                        color: APP_LIGHT,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),)
                    ],),
                    const SizedBox(height: 5,),
                    Row(children: const [
                      Icon(Icons.calendar_today, color: APP_LIGHT,),
                      SizedBox(width: 5,),
                      Text('Fin : 30 Décembre 2022 à 14:30', style: TextStyle(
                        color: APP_LIGHT,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),)
                    ],),
                    const SizedBox(height: 5,),
                    Row(children: const [
                      Icon(Icons.account_circle_rounded, color: APP_LIGHT,),
                      SizedBox(width: 5,),
                      Text('Créée par : Rahman Sow', style: TextStyle(
                        color: APP_LIGHT,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),)
                    ],),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                                elevation: 0.0,
                                backgroundColor: APP_LIGHT,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: const Text('Valider',
                                style: TextStyle(
                                    color: APP_PRIMARY,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500))),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: APP_LIGHT, width: 1.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: const Text(
                            'Pas intéressé(e)',
                            style: TextStyle(
                                color: APP_LIGHT,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    )
                  ]),
                  
              ),
              Container(
                decoration: BoxDecoration(
                  color: APP_PRIMARY,
                  borderRadius: BorderRadius.circular(10)
                ),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Meeting Test 2',
                     style: TextStyle(
                        color: APP_LIGHT,
                        fontSize: 18,
                        fontWeight: FontWeight.w700
                    ),),
                    const SizedBox(height: 10,),
                    Row(children: const [
                      Icon(Icons.calendar_today, color: APP_LIGHT,),
                      SizedBox(width: 5,),
                      Text('Début : 31 Décembre 2022 à 09:00', style: TextStyle(
                        color: APP_LIGHT,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),)
                    ],),
                    const SizedBox(height: 5,),
                    Row(children: const [
                      Icon(Icons.calendar_today, color: APP_LIGHT,),
                      SizedBox(width: 5,),
                      Text('Fin : 31 Décembre 2022 à 10:00', style: TextStyle(
                        color: APP_LIGHT,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),)
                    ],),
                    const SizedBox(height: 5,),
                    Row(children: const [
                      Icon(Icons.account_circle_rounded, color: APP_LIGHT,),
                      SizedBox(width: 5,),
                      Text('Créée par : Harry Ba', style: TextStyle(
                        color: APP_LIGHT,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),)
                    ],),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                                elevation: 0.0,
                                backgroundColor: APP_LIGHT,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: const Text('Valider',
                                style: TextStyle(
                                    color: APP_PRIMARY,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500))),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: APP_LIGHT, width: 1.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: const Text(
                            'Pas intéressé(e)',
                            style: TextStyle(
                                color: APP_LIGHT,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    )
                  ]),
                  
              ),
            ],
          )
        ]),
      ),
    );
  }
}
