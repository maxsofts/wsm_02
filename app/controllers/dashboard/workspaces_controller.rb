class Dashboard::WorkspacesController < DashboardController
  skip_before_action :load_workspace, only: :index
  skip_before_action :verify_owner, only: :index

  def index
    @workspaces = current_user.owned_workspaces.page(params[:page])
      .per(Settings.workspace.per_page)
    @workspace = Workspace.new
  end

  def new
  end

  def create
    @workspace = current_user.owned_workspaces.new workspace_params
    if @workspace.save
      flash[:success] = t "create_success"
      redirect_to workspaces_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    node_data = params[:nodeDataArray]
    services = WorkspaceService.new @workspace
    services.build_sections node_data
    services.build_positions node_data
    build_results = services.get_build_results
    result_msg = build_results[0]
    updated_counter = build_results[1]
    result_msg.push t(".success", count: updated_counter)
    flash[:info] = result_msg.join(Settings.break_line).html_safe
    redirect_to action: :edit
  end

  private
  def workspace_params
    params.require(:workspace).permit :name, :description, :image
  end
end