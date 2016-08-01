<div class = "modal" id = "piazzaCredentialsDialog" role = "dialog" tabindex = "-1">
	<div class = "modal-dialog">
		<div class = "modal-content">
			<div class = "modal-header">
				<h4>Piazza Credentials</h4>
				<a onclick = 'window.open(document.location.origin.replace(/tlv/, "pz-docs"))'>What is Piazza?</a>
			</div>
			<div class = "modal-body">
				<form>
				<div class = "form-group">
					<label>Username</label>
					<input class = "form-control" id = "piazzaUsernameInput" name = "piazzaUsername" type = "text">

					<label>Password</label>
					<input class = "form-control" id = "piazzaPasswordInput" name = "piazzaPassword" type = "password">
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
	$("#piazzaCredentialsDialog").on("hidden.bs.modal", function (event) { hideDialog("piazzaCredentialsDialog"); });
	$("#piazzaCredentialsDialog").on("shown.bs.modal", function (event) { displayDialog("piazzaCredentialsDialog"); });
</g:javascript>
