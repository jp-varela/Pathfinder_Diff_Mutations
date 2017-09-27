class organism{

int x, y;
float angle;
float genome[];
int state; //0-Alive   -###-Dead Turn     ###-Number of turn to reach goal
int closestGoal;  //Used to store score too
float mutation;


organism(float mut)
{
  //Inicial position
  x = 50;
  y = 250;
  angle = 0;
  state = 0;
  genome = new float[max_turn];
  closestGoal = 2000; //random big number
  mutation = mut;

  for (int i=0; i<max_turn; i++)
  {
    genome[i]=random(-0.2, 0.2);
  }
}

int get_X()
{
  return x;
}

int get_Y()
{
  return y;
}

float get_angle()
{
  return angle;
}

void set_X(int xx)
{
  x = xx;
}

void set_Y(int yy)
{
  y = yy;
}

void set_angle(float ang)
{
  angle = ang;
}

void set_state(int state1)
{
  state = state1;
}

int get_state()
{
  return state;
}

float get_mutation()
{
  return mutation;
}

void set_mutation(float t)
{
  mutation = t;
}

int get_color()
{
  return (int) map(mutation, min_mutation, max_mutation, 850, 0);
}

void reset()
{
  x = 50;
  y = 250;
  state = 0;
  angle = 0;
  closestGoal = 2000;
}


void handle_mov(int turn)
{
  angle = angle + genome[turn];
  x = x + int(2*cos(angle));
  y = y + int(2*sin(angle));
}

int get_closestGoal()
{
  return closestGoal;
}

void set_closestGoal(int dist)
{
  closestGoal = dist;
}


void random_genome()
{
  for (int i=0; i<max_turn; i++)
  {
    genome[i]=random(-0.2, 0.2);
  }
}

float get_genome_index(int index)
{
  return genome[index];
}

float[] get_genome()
{
  return genome;
}

void set_genome(float[] g)
{
  for (int i=0; i<max_turn; i++)
    genome[i]=g[i];
}

void child(organism mom, organism dad)
{
  float random1, random2;
  for (int i=0; i < abs(dad.get_state()) ; i++) //just pass to next generation the array until dead
  {
    random1=random(0, 1);
    if (random1<0.5)
      genome[i]=mom.get_genome_index(i);
    else
      genome[i]=dad.get_genome_index(i);

    random2=random(0, 1);
    if (random2<mutation) //mutations
      genome[i]=random(-0.2, 0.2);
  }
  for (int i= abs(dad.get_state())+1; i<max_turn; i++) //random after dead array positions (can reduce a lot of not evolution time)
    genome[i]=random(-0.2, 0.2);
}
}
