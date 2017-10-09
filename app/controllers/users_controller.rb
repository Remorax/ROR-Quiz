class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.answerString = ""
    @user.score = 0
    respond_to do |format|
      if @user.save
        flash[:notice]= 'User was successfully created.'
        format.html { redirect_to '/users/login'}
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        if(params[:questionID])
          if(@@alreadyCorrect) 
            flash[:notice] = "You've already answered this question correctly." 
          elsif(@@isCorrect==1)
            flash[:notice] = "Correct answer!"
          else  
            flash[:notice] = "Wrong answer :("
          end  
          genreID = Problem.find(params[:questionID]).genreID
          subgenreID = Problem.find(params[:questionID]).subgenreID
          format.html { redirect_to controller: "problems", genre_id: genreID, subgenre_id: subgenreID }
        else
          flash[:notice]= 'User was successfully updated.'
          format.html { redirect_to controller: "users", action: "welcome", id: session[:user_id]}
        end  
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      session[:user_id] = nil
      flash[:notice]= 'User was successfully destroyed.'
      format.html { redirect_to '/users/login' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      if(params[:user][:opt])
        correctAns = Problem.find(params[:questionID])[:answer]
        isCorrect = (params[:user][:opt]==correctAns)?1:0
        alreadyCorrect = false
        if(@user.answerString.blank?)
          @user.answerString += (params[:questionID].to_s + "#" + params[:user][:opt] + "#" + correctAns + "#" + isCorrect.to_s)
        else
          prevAnsList = @user.answerString.split(",")
          for prevAns in prevAnsList do
            parameters = prevAns.split("#")
            if((parameters[3]=="1") && (parameters[0]==(params[:questionID].to_s)))
              alreadyCorrect = true
              break
            end
          end
          if(!alreadyCorrect)    
            @user.answerString += ("," + params[:questionID].to_s + "#" + params[:user][:opt] + "#" + correctAns + "#" + isCorrect.to_s)
          end  
        end
        if(!alreadyCorrect)
          @user.score += (isCorrect==1)?2:-1
        end
      elsif (params[:questionID])
        problem = Problem.find(params[:questionID])
        correctAnsList = problem[:answer].split(",")
        isCorrect = 0
        if((params[:user][:answerA] == ((correctAnsList.include? "A")? "1" : "0")) && (params[:user][:answerB] == ((correctAnsList.include? "B")? "1" : "0")) && (params[:user][:answerC] == ((correctAnsList.include? "C")? "1" : "0")) && (params[:user][:answerD] == ((correctAnsList.include? "D")? "1" : "0")))
          isCorrect = 1
        end
        optAns = ""
        if(params[:user][:answerA]=="1")
          optAns += "A*"
        end  
        if(params[:user][:answerB]=="1")
          optAns += "B*"
        end  
        if(params[:user][:answerC]=="1")
          optAns += "C*"
        end  
        if(params[:user][:answerD]=="1")
          optAns += "D*"
        end  
        alreadyCorrect = false
        if(@user.answerString.blank?)
          @user.answerString += (params[:questionID].to_s + "#" + optAns + "#" + problem[:answer].split(',').join(';') + "#" + isCorrect.to_s)
        else
          prevAnsList = @user.answerString.split(",")
          for prevAns in prevAnsList do
            parameters = prevAns.split("#")
            if((parameters[3]=="1") && (parameters[0]==(params[:questionID].to_s)))
              alreadyCorrect = true
              break
            end
          end
          if(!alreadyCorrect)
            @user.answerString += ("," + params[:questionID].to_s + "#" + optAns + "#" + problem[:answer].split(',').join(';') + "#" + isCorrect.to_s)
          end  
        end
        if(!alreadyCorrect)
          @user.score += (isCorrect==1)?2:-1
        end
      end
      @@isCorrect = isCorrect
      @@alreadyCorrect = alreadyCorrect
      params.require(:user).permit(:name, :password, :password_confirmation, :answerString, :score)
    end
end
