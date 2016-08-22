<label>GBDX</label>
<div class = "row">
	<div class = "col-md-6">
		<button class = "btn btn-primary form-control" onclick = queryGbdx()>Search</button>
	</div>
	<div class = "col-md-6">
		<div class = "row">
			<button class = "btn btn-primary form-control" data-dismiss = "modal" disabled = "true" id = "gbdxTypesButton" onclick = $("#gbdxVectorTypesDialog").modal("show")>0 Types</button>
		</div>
		<div class = "row">
			<div class = "progress progress-striped" id = "gbdxSearchProgressBar" style = "display: none">
				<div class = "progress-bar progress-bar-info" role = "progressbar" style = "width: 100%">Searchhing...</div>
			</div>
		</div>
	</div>
</div>
