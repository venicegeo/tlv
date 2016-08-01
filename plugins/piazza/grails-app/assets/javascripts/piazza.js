function invalidPiazzaCredentials() {
	displayErrorDialog("Nope, those weren't the right credentials.");
	$("#piazzaCredentialsDialog").modal("show");
	tlv.piazzaCredentials = null;
}

var pageLoadPiazza = pageLoad;
pageLoad = function() {
	pageLoadPiazza();

	tlv.domain = document.location.origin.replace(/http[s]?[:]\/\/tlv/, "");
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
					url: "https://pz-security" + tlv.domain + "/key"
				});
			}
			else { invalidPiazzaCredentials(); }
		},
		type: "POST",
		url: "https://pz-security" + tlv.domain + "/verification"
	});
}
