var beginSearchPiazza = beginSearch;
beginSearch = function() {
	if (!tlv.piazzaCredentials) {
		$("#piazzaCredentialsDialog").modal("show");
	}
	else { beginSearchPiazza(); }
}

function invalidPiazzaCredentials() {
	displayErrorDialog("Nope, those weren't the right credentials.");
	$("#piazzaCredentialsDialog").modal("show");
	tlv.piazzaCredentials = null;
}

function getPiazzaApiKey(callback) {
	displayLoadingDialog("Let me see if my keys are in my other pair of pants.");

	var password = tlv.piazzaCredentials.password;
	var username = tlv.piazzaCredentials.username;
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

var pageLoadPiazza = pageLoad;
pageLoad = function() {
	pageLoadPiazza();

	tlv.domain = ".stage.geointservices.io"; //document.location.origin.replace(/http[s]?[:]\/\/tlv/, "");
	$("#searchDialog").modal("hide");

	$("#piazzaCredentialsDialog").modal({
		backdrop: "static",
		keyboard: false
	});
}

function validatePiazzaCredentials() {
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
			hideLoadingDialog();

			if (data == "true") {
				tlv.piazzaCredentials = {
					password: password,
					username: username
				};

				$("#piazzaCredentialsDialog").modal("hide");
				$("#searchDialog").modal("show");
			}
			else { invalidPiazzaCredentials(); }
		},
		type: "POST",
		url: "https://pz-security" + tlv.domain + "/verification"
	});
}
