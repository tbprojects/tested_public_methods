class ProjectsController < ActionController::Base

  def index
    render json: Project.all
  end

  def create
    create_project
    render nothing: true
  end

  private
  def create_project
    Project.create(project_parameters)
  end

  def project_parameters
    params.require(:project).permit(:subject)
  end

end