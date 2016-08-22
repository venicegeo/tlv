<div class = "modal" id = "gbdxVectorTypesDialog" role = "dialog" tabindex = "-1">
	<div class = "modal-dialog">
		<div class = "modal-content">
			<div class = "modal-header"><h4>GBDX Vector Types</h4></div>
			<div class = "modal-body">
				<table class = "table table-condensed" id = "gbdxVectorTypesTable"></table>
			</div>
			<div class = "modal-footer">
				<button type = "button" class = "btn btn-default" data-dismiss = "modal">Close</button>
			</div>
		</div>
	</div>
</div>

<g:javascript>
	$("#gbdxVectorTypesDialog").on("hidden.bs.modal", function (event) { hideDialog("gbdxVectorTypesDialog"); });
	$("#gbdxVectorTypesDialog").on("shown.bs.modal", function (event) { displayDialog("gbdxVectorTypesDialog"); });
</g:javascript>
