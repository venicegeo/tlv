<div class = "modal" id = "gbdxCredentialsDialog" role = "dialog" tabindex = "-1">
	<div class = "modal-dialog">
		<div class = "modal-content">
			<div class = "modal-header">
				<h4>GBDX Credentials</h4>
				<a href = "https://gbdx.geobigdata.io" target = "_blank">What is GBDX?</a>
			</div>
			<div class = "modal-body">
				<form>
				<div class = "form-group">
					<label>Username</label>
					<input class = "form-control" id = "gbdxUsernameInput" name = "gbdxUsername" type = "text">

					<label>Password</label>
					<input class = "form-control" id = "gbdxPasswordInput" name = "gbdxPassword" type = "password">

					<label>API Key</label>
					<input class = "form-control" id = "gbdxApiKeyInput" name = "gbdxApiKey" type = "text">
				</div>
				</form>
			</div>
			<div class = "modal-footer">
				<button type = "button" class = "btn btn-primary" data-dismiss = "modal">Login</button>
				<button type = "button" class = "btn btn-default" data-dismiss = "modal">Close</button>
			</div>
		</div>
	</div>
</div>

<g:javascript>
	$("#gbdxCredentialsDialog").on("hidden.bs.modal", function (event) { hideDialog("gbdxCredentialsDialog"); });
	$("#gbdxCredentialsDialog").on("shown.bs.modal", function (event) { displayDialog("gbdxCredentialsDialog"); });
</g:javascript>
