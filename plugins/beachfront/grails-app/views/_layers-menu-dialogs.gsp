<label><a onclick = 'window.open(document.location.origin.replace(/tlv/, "beachfront"))'>Beachfront</a></label>
<div class = "row">
	<div class = "col-md-6">
		<button class = "btn btn-primary form-control" onclick = queryBeachfront()>Search</button>
	</div>
	<div class = "col-md-6">
		<div class = "row">
			<button class = "btn btn-primary form-control" data-dismiss = "modal" disabled = "true" id = "beachfrontResultsButton" onclick = buildBeachfrontResultsTable()>0 Results</button>
		</div>
		<div class = "row">
			<div class = "progress progress-striped" id = "beachfrontSearchProgressBar" style = "display: none">
				<div class = "progress-bar progress-bar-info" role = "progressbar" style = "width: 100%">Searchhing...</div>
			</div>
		</div>
	</div>
</div>
