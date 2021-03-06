{$picker_table_domid = uniqid()}
{$picker_workers = $worker_picker_data.workers}

<div id="{$picker_table_domid}">

<table cellpadding="2" cellspacing="0" border="0" width="100%" class="picker-selected">
	<thead>
	<tr>
		<td>
			<b>{'common.worker'|devblocks_translate|capitalize}</b>
		</td>
		<td>
			<b>{'common.availability'|devblocks_translate|capitalize} (24h)</b>
		</td>
		<td>
			<abbr title="Open assignments / Recommendations / Unread notifications" style="font-weight:bold;">Workload</abbr>
		</td>
		{if $worker_picker_data.show_responsibilities}
		<td>
			<b>{'common.responsibility'|devblocks_translate|capitalize}</b>
		</td>
		{/if}
		<td>
		</td>
	</tr>
	</thead>
		
	<tbody>
		{foreach from=$picker_workers.sample item=worker key=worker_id}
		{include file="devblocks:cerberusweb.core::internal/workers/worker_picker_row.tpl" show_responsibilities=$worker_picker_data.show_responsibilities}
		{/foreach}
	</tbody>
	
</table>

<fieldset class="peek" style="margin-top:10px;border:0;background:0;box-shadow: 0px 5px 15px 0px #afafaf;border-radius:5px;">
	<div>
		<b>{'common.add'|devblocks_translate|capitalize}:</b>
		<input type="text" class="input_search" size="45" style="border-radius:10px;border-color:rgb(200,200,200);" autofocus="autofocus">
	</div>
	
	<div style="max-height:350px;overflow-y:auto;-webkit-appearance:none;padding:5px 5px 0px 5px;">
	<table cellpadding="2" cellspacing="0" border="0" width="100%" class="picker-available">
		<thead>
		<tr>
			<td>
				<b>{'common.worker'|devblocks_translate|capitalize}</b>
			</td>
			<td>
				<b>{'common.availability'|devblocks_translate|capitalize} (24h)</b>
			</td>
			<td>
				<abbr title="Open assignments / Recommendations / Unread notifications" style="font-weight:bold;">Workload</abbr>
			</td>
			{if $worker_picker_data.show_responsibilities}
			<td>
				<b>{'common.responsibility'|devblocks_translate|capitalize}</b>
			</td>
			{/if}
			<td>
			</td>
		</tr>
		</thead>
		
		<tbody>
			{foreach from=$picker_workers.population item=worker key=worker_id}
			{include file="devblocks:cerberusweb.core::internal/workers/worker_picker_row.tpl" show_responsibilities=$worker_picker_data.show_responsibilities}
			{/foreach}
		</tbody>
		
	</table>
	</div>
</fieldset>

</div>

<script type="text/javascript">
$(function() {
	var $container = $('#{$picker_table_domid}');
	var $picker = $container.find('table.picker-available');
	var $table = $container.find('table.picker-selected');
	var $search = $container.find('input.input_search');
	
	$search.keypress(
		function(e) {
			var code = (e.keyCode ? e.keyCode : e.which);
			if(code == 13) {
				e.preventDefault();
				e.stopPropagation();
				$(this).select().focus();
				return false;
			}
		}
	);
		
	$search.keyup(
		function(e) {
			var term = $(this).val().toLowerCase();
			$picker.find('tbody > tr > td > a.item').each(function(e) {
				var $tr = $(this).closest('tr');
				
				if(-1 != $(this).html().toLowerCase().indexOf(term)) {
					$tr.show();
				} else {
					$tr.hide();
				}
			});
		}
	);
	
	$table.on('click', 'tbody a.delete', function() {
		var $tr = $(this).closest('tr');
		var worker_id = $tr.attr('data-worker-id');
		
		$tr.find('a.delete').hide();
		
		$tr.find('input:hidden[name="current_sample[]"]').remove();
		
		$tr.appendTo($picker.find('tbody'));
		
		$search.focus();
	});
	
	$picker.on('click', 'tbody a.item', function() {
		var $tr = $(this).closest('tr');
		var $input = $('<input type="hidden">');
		var worker_id = $tr.attr('data-worker-id');
		var score = $tr.attr('data-score');
		
		$input.attr('name', 'current_sample[]');
		$input.attr('value', worker_id);
		$input.insertAfter($(this));
		
		$tr.find('a.delete').show();
		
		$tr.appendTo($table.find('tbody'));
		
		$search.focus();
	});
});
</script>