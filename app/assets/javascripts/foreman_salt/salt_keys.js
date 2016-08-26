function filterKeys(state) {
    $('#salt_keys table').dataTable().fnFilter(state, 1, true);
}

function keysTable() {
    activateDatatables();
    var filter = $('#salt_keys-filter');
    activate_select2(filter);
    filter.on('change', function() {filterKeys(filter.val())});
}

