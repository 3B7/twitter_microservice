require 'digest/md5'

class PartnerUser < ActiveRecord::Base
  validates_presence_of :name, :url, :email
  
  before_create :set_uuid

  def approved?
    self.approved_at.present? and self.revoked_at.blank?
  end

  def revoked?
    self.revoked_at.present?
  end

  def under_review?
    self.approved_at.blank? and self.revoked_at.blank?
  end

  def status
    if self.approved?
      "Approved"
    elsif  self.revoked?
      "Rejected"
    elsif self.under_review?
      "Pending"
    end
  end   

  private

  def set_uuid
    self.uuid = Digest::MD5.hexdigest(self.name)
  end

end