module ForemanSalt
  module Concerns
    module HostgroupExtensions
      extend ActiveSupport::Concern

      included do
        has_many :salt_modules, :through => :hostgroup_salt_modules, :class_name => '::ForemanSalt::SaltModule'
        has_many :hostgroup_salt_modules, :class_name => '::ForemanSalt::HostgroupSaltModule'

        belongs_to :salt_proxy, :class_name => 'SmartProxy'
        belongs_to :salt_environment, :class_name => 'ForemanSalt::SaltEnvironment'

        scoped_search :in => :salt_modules, :on => :name, :complete_value => true, :rename => :salt_state
        scoped_search :in => :salt_environment, :on => :name, :complete_value => true, :rename => :salt_environment
        scoped_search :in => :salt_proxy, :on => :name, :complete_value => true, :rename => :saltmaster
      end

      def all_salt_modules
        ForemanSalt::SaltModule.in_environment(salt_environment).where(:id => salt_module_ids + inherited_salt_module_ids)
      end

      def inherited_salt_modules
        ForemanSalt::SaltModule.where(:id => inherited_salt_module_ids)
      end

      def inherited_salt_module_ids
        ancestors.map(&:salt_module_ids).flatten.uniq
      end

      def salt_proxy
        return super unless ancestry.present?
        SmartProxy.find_by_id(inherited_salt_proxy_id)
      end

      def inherited_salt_proxy_id
        if ancestry.present?
          self[:salt_proxy_id] || self.class.sort_by_ancestry(ancestors.where('salt_proxy_id is not NULL')).last.try(:salt_proxy_id)
        else
          salt_proxy_id
        end
      end

      def salt_environment
        return super unless ancestry.present?
        ForemanSalt::SaltEnvironment.find_by_id(inherited_salt_environment_id)
      end

      def inherited_salt_environment_id
        if ancestry.present?
          self[:salt_environment_id] || self.class.sort_by_ancestry(ancestors.where('salt_environment_id is not NULL')).last.try(:salt_environment_id)
        else
          salt_environment_id
        end
      end

      def salt_master
        salt_proxy.to_s
      end
    end
  end
end
