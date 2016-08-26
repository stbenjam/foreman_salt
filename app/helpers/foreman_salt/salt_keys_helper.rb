module ForemanSalt
  module SaltKeysHelper
    STATES = [N_('accepted'), N_('rejected'), N_('unaccepted')]

    ICONS = { 'accepted' => 'pficon pficon-ok',
              'rejected' => 'fa fa-ban',
              'unaccepted' => 'pficon pficon-warning-triangle-o' }

    def salt_keys_state_filter
      select_tag 'Filter', options_for_select(['', _('accepted'), _('rejected'), _('unaccepted')], params[:state]),
        :class => "datatable-filter", :id => "salt_keys-filter"
    end
  end
end
