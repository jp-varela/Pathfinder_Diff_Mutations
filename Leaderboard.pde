class leaderboard {
  //current TOP 10
  int[] generation = {};
  int[] score = {};
  int[] colour = {};
  int[] last_position = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}; //for animation in bars

  float[] generation_array = {};
  float[] top1 = {};


  leaderboard()
  {}


  void update(ArrayList<organism> board)
  {
    reset_last_position();
    if(gen == 1)
      first_update(board);
    else
    {
      for(int i=0; i<10 && board.get(i).get_closestGoal()>score[9] ; i++) //until 10 or score now enough to TOP 10 for each new score
      {
        boolean flag = true;
        for(int j=0; j<10 && flag==true; j++) //flag for not repeat, for each current TOP10
        {
          if(board.get(i).get_closestGoal()==score[j] && board.get(i).get_color()==colour[j]) // check if new entry or just mom or dad from previous
          {
            flag = false;
            continue;
          }
          if(board.get(i).get_closestGoal()>score[j])
          {
            for(int k=9; k>j; k--)
            {
              generation[k]=generation[k-1];
              score[k]=score[k-1];
              colour[k]=colour[k-1];
              last_position[k]=last_position[k-1];
            }
            generation[j]=gen;
            score[j]=board.get(i).get_closestGoal();
            colour[j]=board.get(i).get_color();
            last_position[j]=11;
            flag = false;
          }
        }
      }
    }

    //for(int i = 0; i<10; i++)
      //println("#"+(i+1)+" Score: "+score[i]+" color: "+colour[i]+" | GEN: "+generation[i]);
    //update others things maybe
    top1 = append(top1, score[0]);
    generation_array = append(generation_array, gen);
  }


  //local functions
  private void first_update(ArrayList<organism> board)
  {
    for (int t=0; t<10; t++)
    {
      generation = append(generation, 1);
      score = append(score, board.get(t).get_closestGoal());
      int c = (int) map(board.get(t).get_mutation(), min_mutation, max_mutation, 850, 0);
      colour = append(colour, c);
    }
      generation_array = append(generation_array, 1);
      top1 = append(top1, score[0]);
  }

  int get_score(int index)
  {
    return score[index];
  }

  int get_color(int index)
  {
    return colour[index];
  }

  int get_generation(int index)
  {
    return generation[index];
  }

  float[] get_top1()
  {
    return top1;
  }

  float[] get_generation_array()
  {
    return generation_array;
  }

  private void reset_last_position()
  {
    for(int i=0; i<10; i++)
      last_position[i]=i;
  }

  int get_last_position(int index)
  {
    return last_position[index];
  }

} //end of class
