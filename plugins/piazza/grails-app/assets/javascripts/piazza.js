function invalidPiazzaCredentials() {
	displayErrorDialog("Nope, those weren't the right credentials.");
	$("#piazzaCredentialsDialog").modal("show");
	tlv.piazzaCredentials = null;
}

function validatePiazzaCredentials(callback) {
	displayLoadingDialog("Hang tight, we'll see if our bouncer will let you in.");

	var password = $("#piazzaPasswordInput").val();
	var username = $("#piazzaUsernameInput").val();
	$.ajax({
		contentType: "application/json",
		data: JSON.stringify({ username: username, credential: password }),
		dataType: "text",
		error: function(jqXhr, textStatus, errorThrown) {
			hideLoadingDialog();
			invalidPiazzaCredentials();
		},
		success: function(data) {
			if (data == "true") {
				tlv.piazzaCredentials = {
					password: password,
					username: username
				};

				// get user api key
				$.ajax({
					contentType: "application/json",
					error: function(jqXhr, textStatus, errorThrown) {
						hideLoadingDialog();
						invalidPiazzaCredentials();
					},
					headers: { "Authorization": "Basic " + btoa(username + ":" + password) },
					success: function(data) {
						hideLoadingDialog();
						tlv.piazzaCredentials.key = data.uuid;
						callback();
					},
					url: document.location.origin.replace(/tlv/, "pz-security") + "/key"
				});
			}
			else { invalidPiazzaCredentials(); }
		},
		type: "POST",
		url: document.location.origin.replace(/tlv/, "pz-security") + "/verification"
	});
}
