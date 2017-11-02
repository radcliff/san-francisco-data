class CasesController < ApplicationController
  def index
    # TODO: http://www.justinweiss.com/articles/search-and-filter-rails-models-without-bloating-your-controller/
    @cases = Case.where(nil) # creates an anonymous scope
    @cases = @cases.requested_since(params[:since]) if params[:since].present?
    @cases = @cases.status(params[:status]) if params[:status].present?
    @cases = @cases.category(params[:category]) if params[:category].present?
    @cases = @cases.nearby(*params[:near].split(',')) if params[:near].present?
  end
end
