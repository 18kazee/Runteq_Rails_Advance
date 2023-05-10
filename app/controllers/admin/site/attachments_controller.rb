class Admin::Site::AttachmentsController < ApplicationController
  def destroy
    authorize(current_site)
    image = ActiveStorage::Attachment.find(params[:id])
    image.purge
    redirect_to edit_admin_site_path
  end

  private

  def set_site
    @site = Site.find(current_site.id)
  end
end
