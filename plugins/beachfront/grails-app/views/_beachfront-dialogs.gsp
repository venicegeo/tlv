<div class = "modal" id = "beachfrontResultsDialog" role = "dialog" tabindex = "-1">
	<div class = "modal-dialog">
		<div class = "modal-content">
			<div class = "modal-header"><h4>Beachfront Results</h4></div>
			<div class = "modal-body">
				<table class = "table table-condensed" id = "beachfrontResultsTable"></table>
			</div>
			<div class = "modal-footer">
				<button type = "button" class = "btn btn-default" data-dismiss = "modal">Close</button>
			</div>
		</div>
	</div>
</div>

<g:javascript>
	$("#beachfrontResultsDialog").on("hidden.bs.modal", function (event) { hideDialog("beachfrontResultsDialog"); });
	$("#beachfrontResultsDialog").on("shown.bs.modal", function (event) { displayDialog("beachfrontResultsDialog"); });
</g:javascript>
