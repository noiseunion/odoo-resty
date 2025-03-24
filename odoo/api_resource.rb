module Odoo
  class ApiResource < Object
    def save
      raise NotImplementedError, "changes to an #{self.class.name} can not be saved"
    end
  end
end
