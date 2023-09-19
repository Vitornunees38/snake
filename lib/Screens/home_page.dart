import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake_game/food_pixel.dart';
import 'package:snake_game/snake_pixel.dart';

import '../blank_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  State<HomePage> createState() => _HomePageState();

}

enum SnakeDirection{ UP, DOWN, LEFT, RIGTH}

class _HomePageState extends State<HomePage>{

  int rowSize = 10;
  int totalNumberofSquares = 150;

  int userScore = 0;

  List<int> snakePos = [0,1,2];

  var currentDirection = SnakeDirection.RIGTH;

  int foodPos = 55; 

  void startGame(){
      userScore = 0;
      Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        moveSnake();
      });
      if (gameOver()) {
                showDialog(context: context, builder: (context){
          return AlertDialog(
            title: Center(child: Text('Game Over!\nYour score is: ' + userScore.toString())),
          );
        }
        );

        timer.cancel();

        snakePos = [0,1,2];
        currentDirection = SnakeDirection.RIGTH;

      }
    });
  }

  void eatFood(){
    userScore++;
    while(snakePos.contains(foodPos)){
      foodPos = Random().nextInt(totalNumberofSquares);
    }
  }

  void moveSnake(){
    switch (currentDirection) {
      case SnakeDirection.RIGTH:
      {
        if (snakePos.last % rowSize == 9) {
        snakePos.add(snakePos.last + 1-rowSize);
        }else{
          snakePos.add(snakePos.last+1);
        }

 
      }
        break;
      case SnakeDirection.LEFT:
      {
        if (snakePos.last % rowSize == 0) {
        snakePos.add(snakePos.last - 1 + rowSize);
        }else{
          snakePos.add(snakePos.last-1);
        }
        

      }
        break;
      case SnakeDirection.UP:
      {
        if (snakePos.last < rowSize) {
          snakePos.add(snakePos.last - rowSize + totalNumberofSquares);
        }else{
          snakePos.add(snakePos.last - rowSize);
        }

      }
        break;
      case SnakeDirection.DOWN:
      {
        if (snakePos.last >= totalNumberofSquares-rowSize) {
          snakePos.add(snakePos.last + rowSize - totalNumberofSquares);
        }else{
          snakePos.add(snakePos.last + rowSize);
        }

      }
        break;  
      default:
    }

    if (snakePos.last == foodPos) {
      eatFood();
    }else{
      snakePos.removeAt(0);
    }

  }

  bool gameOver(){
    List<int> bodySnake = snakePos.sublist(0, snakePos.length-1);
    if(bodySnake.contains(snakePos.last)){
      return true;
    }else{return false;}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [

        //  scores
          Expanded(flex: 2,
            child: Container(
              alignment: Alignment.center,
              height: 1,
              padding: EdgeInsets.only(top: 30),
              child: Text('SCORE: ' + userScore.toString(), style: TextStyle(color: Colors.white, fontSize: 40),),
            )
          ),

        
        // game grid
        Expanded(
          
          flex: 12,
              child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy < 0 && currentDirection != SnakeDirection.DOWN) {
                      if (currentDirection != SnakeDirection.DOWN) {
                        currentDirection = SnakeDirection.UP;
                      }
                    } else if (details.delta.dy > 0 && currentDirection != SnakeDirection.UP) {
                      currentDirection = SnakeDirection.DOWN;
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx > 0 && currentDirection != SnakeDirection.LEFT) {
                      currentDirection = SnakeDirection.RIGTH;
                    } else if(details.delta.dx<0  && currentDirection != SnakeDirection.RIGTH) {
                      currentDirection = SnakeDirection.LEFT;
                    }
              },
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: totalNumberofSquares,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: rowSize),
                 itemBuilder: (context, index){
                  if(snakePos.contains(index)){
                    return SnakePixel();
                  }else if(foodPos == index){
                    return FoodPixel();
                    } else {return BlankPixel();}
                 }
               )
            )
          ),

        //play button
        Expanded(
          flex: 1,
            child: Container(
              child: Center(
                child: MaterialButton(
                  child: Text('PLAY'),
                  color: Colors.pink,
                  onPressed: (){startGame();},
                ),
              ),
            )
          ),

        ],

      ),
    );
  }

}

