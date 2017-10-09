class ProblemsController < ApplicationController
  before_action :set_problem, only: [:show, :edit, :update, :destroy]

  # GET /problems
  # GET /problems.json
  def index
    @problems = Problem.all
  end

  # GET /problems/1
  # GET /problems/1.json
  def show
  end

  # GET /problems/new
  def new
    @problem = Problem.new
    @@genreid = params[:genre_id]
    @@subgenreid = params[:subgenre_id]
  end

  # GET /problems/1/edit
  def edit
  end

  # POST /problems
  # POST /problems.json
  def create
    @problem = Problem.new(problem_params)
    @problem.genreID = @@genreid
    @problem.subgenreID = @@subgenreid
    @problem.userAnswers = ""
    respond_to do |format|
      if @problem.save
        flash[:notice] = 'Problem was successfully created.'
        format.html { redirect_to controller: "problems", genre_id: @problem.genreID, subgenre_id: @problem.subgenreID  }
        format.json { render :show, status: :created, location: @problem }
      else
        format.html { render :new }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /problems/1
  # PATCH/PUT /problems/1.json
  def update
    respond_to do |format|
      if @problem.update(problem_params)
        flash[:notice] = 'Problem was successfully updated.'
        format.html { redirect_to controller: "problems", genre_id: @problem.genreID, subgenre_id: @problem.subgenreID  }
        format.json { render :show, status: :ok, location: @problem }
      else
        format.html { render :edit }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /problems/1
  # DELETE /problems/1.json
  def destroy
    @problem.destroy
    respond_to do |format|
      flash[:notice] = 'Problem was successfully deleted.'      
      format.html { redirect_to controller: "problems", genre_id: @@genreid, subgenre_id: @@subgenreid }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem
      @problem = Problem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def problem_params
      params[:problem][:answer] = ""
      params[:problem][:answer] += (params[:problem][:answerA]=="0") ? ("") : ("A,")
      params[:problem][:answer] += (params[:problem][:answerB]=="0") ? ("") : ("B,")
      params[:problem][:answer] += (params[:problem][:answerC]=="0") ? ("") : ("C,")
      params[:problem][:answer] += (params[:problem][:answerD]=="0") ? ("") : ("D,")
      params[:problem][:answer] = params[:problem][:answer].chomp(",")
      if(params[:problem][:answer].length>2)
         params[:problem][:questionType] = 2
      else
         params[:problem][:questionType] = 1
      end
      params.require(:problem).permit(:question, :a, :b, :c, :d, :genreID, :subgenreID, :answer, :questionType, :userAnswers)
    end
end
