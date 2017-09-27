//Pathfinder AI with genetic algortihm by macarrony00

//imports
import org.gicentre.utils.colour.*;
import org.gicentre.utils.stat.*;


//geral variables
int num_organisms = 100;
public float min_mutation = 0.0001;
public float max_mutation = 0.01;
ArrayList<organism> population = new ArrayList<organism>();
leaderboard board = new leaderboard();

//State variables
int turn = 1; //frame
public int gen = 1;
int deads = 0;
public final int max_turn = 2000;

//MAP variables
int goal_X = 1050;
int goal_Y = 253;

//Graphs variables
ColourTable gradient;
XYChart top1;


void setup() {
  size(1080, 720);
  frameRate(60000);

  //Graph setups
  gradient = ColourTable.readFile(createInput("gradient_0_1020.ctb"));
  top1 = new XYChart(this);
  // Axis formatting and labels.
  top1.showXAxis(true);
  top1.showYAxis(true);
  // Symbol colours
  top1.setPointSize(2);
  top1.setLineWidth(2);
  top1.setMinX(1.0001);
  top1.setXAxisLabel("Generation");
  top1.setYFormat("###");
  top1.setXFormat("###");
  top1.setLineColour(#4D4C4B);
  top1.setPointColour(#4D4C4B);

  for (int x=0; x<num_organisms; x++)
  {
    population.add(new organism(random(min_mutation,max_mutation)));
  }
}


void draw() {
  //if (turn==1)
    //println("-----Generation: "+gen+"-----");


  //Draw MAP
  background(150);
  noFill();
  stroke(0);
  rect(3, 3, 1074, 500);

  //draw obstacles
  fill(#4D4C4B);
  ellipse(180, 250, 30, 110);
  ellipse(220, 100, 30, 200);
  ellipse(220, 405, 30, 200);
  triangle(250, 247, 350, 247, 350, 150);
  triangle(250, 253, 350, 253, 350, 350);
  triangle(250+111, 250+160, 350+111, 150+160, 350+111, 350+160);
  triangle(250+111, 250-160, 350+111, 150-160, 350+111, 350-160);
  ellipse(420, 250, 70, 70);
  rect(500, 225, 200, 50);
  triangle(530, 220, 735, 250-120, 700, 220);
  triangle(530, 280, 735, 250+120, 700, 280);
  ellipse(420+140, 250-170, 80, 80);
  ellipse(420+140, 250+170, 80, 80);
  triangle(250+511, 250+160, 350+511, 150+160, 350+511, 350+160);
  triangle(250+511, 250-160, 350+511, 150-160, 350+511, 350-160);
  ellipse(920, 250, 70, 70);

  //draw goal
  noStroke();
  fill(#FCBA00);
  ellipse(goal_X, goal_Y, 20, 20);
  stroke(0);

  //POSITION UPDATES
  for (int g=0; g<num_organisms; g++) //For each organism
  {
    if (population.get(g).get_state()==0) //If alive
    {
      population.get(g).handle_mov(turn-1); //get new POSITION

      float dist; //dist to the target
      dist = dist(population.get(g).get_X(), population.get(g).get_Y(), goal_X, goal_Y);
      if (dist < population.get(g).get_closestGoal()) //closest distance ever for fitness calculation
      {
        population.get(g).set_closestGoal((int) dist);
      }

      //Death conditions
      if (population.get(g).get_X()>1077 || population.get(g).get_X()<3 || population.get(g).get_Y()>503 || population.get(g).get_Y()<3 || get(population.get(g).get_X(), population.get(g).get_Y())==#4D4C4B)
      {
        population.get(g).set_state(-turn); //negative for turn of death
        deads++;
      } else
      { //If reach goal
        if (get(population.get(g).get_X(), population.get(g).get_Y())==#FCBA00)
        {
          population.get(g).set_state(turn); //positive for turn of goal
          deads++;
          // To delete
          /*int final_dist = (int) dist(population.get(g).get_X(), population.get(g).get_Y(), goal_X, goal_Y);
          int state = population.get(g).get_state();
          int score = (int) (1.5*(max_turn-final_dist)+1.3*(max_turn-state));
          println("TEST REPORT |  Min:"+min_mutation+"   Max:"+max_mutation+"    Generation:"+gen+"   Score:"+score);
          exit();  //to DELETE*/
        }
      }
    }
  }

  //DRAW ORGANISMS
  for (int g = num_organisms-1; g>=0; g--) //For each organism
  {
    pushMatrix();
    translate(population.get(g).get_X(), population.get(g).get_Y());
    rotate(population.get(g).get_angle()-PI/2);
    if(g==0 && gen!=1)
      fill(#FCFCFC);
    else
      if(g==1 && gen!=1)
        fill(#CBCBCB);
      else
      {
        float mut = population.get(g).get_mutation();
        int col = (int) map(mut,min_mutation,max_mutation,850,0);
        fill(gradient.findColour(col));
      }

    triangle(-4, -8, +4, -8, 0, 8);
    popMatrix();
  }

  //draw data
  fill(0);
  noStroke();
  textSize(22);
  text("Generation: "+gen, 900, 30);
  text("Time Left: "+((max_turn-turn)/10), 900, 60);
  //text("Alive: "+(num_organisms-deads), 910, 90);

  //draw TOP 10
  textSize(16);
  text("1st", 10, 534);
  text("2nd", 10, 554);
  text("3rd", 10, 574);
  for(int i=4; i<=10; i++)
    text(i+"th", 10, 514+(20*i));
  if(gen!=1)
  {
    int aux = turn;
    if(aux > 100)
      aux = 100;
      stroke(0);
      for(int i=0; i<10; i++)
      {
        fill(gradient.findColour(board.get_color(i)));
        rect(55, map(aux,0,100,518+(board.get_last_position(i)*20),518+(i*20)), ((board.get_score(i)-2000)/6), 18);
      }
      fill(0);
      for(int i=0; i<10; i++)
      {
        text(board.get_score(i), ((board.get_score(i)-2000)/6)+60, map(aux,0,100,534+(board.get_last_position(i)*20),534+(i*20)));
        text("("+board.get_generation(i)+")" , (((board.get_score(i)-2000)/6)+35-int_size(board.get_generation(i))*9), map(aux,0,100,533+(board.get_last_position(i)*20),533+(i*20)));
      }
    }

  //draw graphs
  textSize(12);
  top1.draw(600,515,480,200);


  //check if last turn
  if (turn==max_turn || deads==num_organisms)
  {
    for (int j = 0; j<num_organisms; j++)
    {
      //fitness calculation
      //score = 1*(max_turn-final_distance)+0.5*(max_turn-closest_distance)+1*(1000-goal_turn)+0.3*(1000-last_of_dead_or_goal_turn)
      float score;
      float final_dist = dist(population.get(j).get_X(), population.get(j).get_Y(), goal_X, goal_Y);
      int state = population.get(j).get_state(); //turn of dead, positive or negative
      if (state>0) //if goal was reached
      {
        score = 1.5*(max_turn-final_dist)+1.3*(max_turn-state);
      } else
      {
        if(state != 0) //if state is 0, end of time and was still alive, so no bonus for early dead
          score = (max_turn-final_dist)+0.5*(max_turn-population.get(j).get_closestGoal())+0.3*(max_turn+state);
        else
          score = (max_turn-final_dist)+0.5*(max_turn-population.get(j).get_closestGoal());
      }
      population.get(j).set_closestGoal((int)score);
    }

    //sort
    ArrayList<organism> old = population;
    population = sortList(old);

    //data for graphs
    board.update(population);
    if(gen==1)  //set graphic MIN
      top1.setMinY(board.get_score(9));
    top1.setMaxY(board.get_score(0));
    top1.setData(board.get_generation_array(), board.get_top1());

    //kill organisms
    float prob_kill_step = (100/num_organisms)/1; //divided by 1 is 50 average deaths
    //this kill the mutation rate, the angles variation (DNA) will change anyway...
    for (int k = num_organisms-1; k>=0 ; k--)
    {
      float rand = random(0, 100);
      if(rand < prob_kill_step*k)
      {
        population.remove(k);
      }
    }
    int survived = population.size();
    while(population.size()<num_organisms)
    {
      float mut = random(1);
      if(mut>0.1)   //10% of 50 -> average of 5 mutation per generation (mutation rate mutation only)
      {
        int rand = (int) random(survived);
        float new_mutation = population.get(rand).get_mutation();
        population.add(new organism(new_mutation));
      }
      else
        population.add(new organism(random(min_mutation,max_mutation)));
    }

    //sort again (mom and dad may be death :(  )
    old = population;
    population = sortList(old);

    //generate new DNA
    organism dad = population.get(0);
    organism mom = population.get(1);
    for(int i=2; i<num_organisms; i++)
      population.get(i).child(mom, dad);

    //reset things
    for(int i=0; i<num_organisms; i++)
      population.get(i).reset();
    turn=0;
    deads=0;
    gen++;
  }

  turn++;
  //saveFrame("frames/frame_######.png");
}


ArrayList<organism> sortList(ArrayList<organism> old)
{
  ArrayList<organism> sorted = new ArrayList<organism>();
  for (int i = old.size()-1; i>=0; i--)
  {
    int max_score=-1;
    int index = -1;
    for (int j = old.size()-1; j>=0; j--)
    {
      if (old.get(j).get_closestGoal()>max_score)
      {
        max_score = old.get(j).get_closestGoal();
        index = j;
      }
    }
    sorted.add(old.get(index));
    old.remove(index);
  }
  return sorted;
}

/*
void fill_hack(int col)
{
  if(col<=255)
    fill(color(255,col,0,255));
  if(col>255 && col<510)
    fill(color(255-col%255,255,0,255));
  if(col>=510 && col<756)
    fill(color(0,255,col%255,255));
  if(col>=756)
    fill(color(0,255-col%255,255,255));
}*/

  int int_size(int num)
  {
    if(num<10)
      return 1;
    if(num<100)
      return 2;
    if(num<1000)
      return 3;
    return 4;
  }
