function addGbdxFeatureInteraction(type) {
	var layer = tlv.gbdx.vectors[type].mapLayer;

	var featureInteraction = tlv.gbdx.vectors[type].featureInteraction;
	if (featureInteraction) { tlv.map.removeInteraction(featureInteraction); }
	featureInteraction = new ol.interaction.Select({
		condition: ol.events.condition.pointerMove,
		layers: [layer]
	});

	featureInteraction.on('select', function(event) {
		var features = event.selected;
		if (features.length > 0) {
			var feature = features[0];
			var pixel = event.mapBrowserEvent.pixel;
			pixel[1] += $(".security-classification").parent().height() + $("#navigationMenu").parent().height() + $("#navigationMenu").parent().next().height() + $("#tileLoadProgressBar").height();
			tlv.tooltipInfo.css({
				left: pixel[0] + "px",
				top: pixel[1] + "px"
			});

			var properties = feature.getProperties();
			var ingestDate = properties.ingest_date;
			var sourceText = properties.ingest_source || "";
			var typeText = properties.item_type ? properties.item_type[0] : "";
   			tlv.tooltipInfo.tooltip("hide")
				.attr('data-original-title', "Type: " + typeText + "\nSource: " + sourceText + "\nIngest Date: " + ingestDate)
				.tooltip('fixTitle')
				.tooltip('show');
		}
		else { tlv.tooltipInfo.tooltip("hide"); }

	});
	tlv.map.addInteraction(featureInteraction);
}

function buildGbdxVectorTypesTable() {
    var table = $("#gbdxVectorTypesTable")[0];
    for (var i = table.rows.length - 1; i >= 0; i--) { table.deleteRow(i); }

    var row = table.insertRow(table.rows.length);
    var cell;
    $.each(
        tlv.gbdx.types,
        function(i, x) {
            row = table.insertRow(table.rows.length);
            cell = row.insertCell(row.cells.length);
            $(cell).append(x);


			cell = row.insertCell(row.cells.length);
			var div = document.createElement("div");
			$(div).attr("align", "center");
			$(div).attr("id", "gbdx" + i + "Progress");
			$(div).css("background-color", "grey");
			$(div).css("width", "100%");
			$(div).html("Not Loaded");
			$(cell).append(div);


            cell = row.insertCell(row.cells.length);
			var select = document.createElement("select");
			$(select).attr("id", "gbdx" + i + "VisibilitySelect");
			$(select).change(function() { toggleGbdxLayer(i, $(this).val()); });
			$(select).css("opacity", 0.5);
			$(cell).append(select);

			$.each(
				["OFF", "ON"],
				function(j, y) {
					var option = document.createElement("option");
					$(option).html(y);
					$(select).append(option);
				}
			);


			cell = row.insertCell(row.cells.length);
			var color = document.createElement("input");
			$(color).attr("id", "gbdx" + i + "ColorInput");
			$(color).change(function() { changeGbdxLayerColor(i); });
			$(color).attr("type", "color");
			$(color).attr("value", "#FFFF00");
			$(cell).append(color);
        }
    );
}

function changeGbdxLayerColor(typeIndex) {
	var type = tlv.gbdx.types[typeIndex];
	var layer = tlv.gbdx.vectors[type].mapLayer;
	if (layer) {
		var style = createGbdxLayerStyle(typeIndex);
		layer.setStyle(style);
	}
}

function createGbdxLayerStyle(typeIndex) {
	var color = $("#gbdx" + typeIndex + "ColorInput").val();
	return new ol.style.Style({
		fill: new ol.style.Fill({ color: color }),
		image: new ol.style.Circle({
			fill: new ol.style.Fill({ color: color }),
			radius: 5
		}),
		stroke: new ol.style.Stroke({
			color: color,
            width: 1
 		})
	});
}

function invalidGbdxCredentials() {
	displayErrorDialog("Nope, those weren't the right credentials.");
	$("#gbdxCredentialsDialog").modal("show");
	tlv.gbdxCredentials = null;
}

function loadGbdxVectors(type) {
	var typeIndex = tlv.gbdx.types.indexOf(type);
	var progress = $("#gbdx" + typeIndex + "Progress");
	$(progress).css("background-color", "blue");
	$(progress).html("Searching...");


	tlv.gbdx.vectors[type].mapLayer = new ol.layer.Vector({
		source: new ol.source.Vector(),
		style: createGbdxLayerStyle(typeIndex)
	});
	tlv.map.addLayer(tlv.gbdx.vectors[type].mapLayer);

	var extent = tlv.map.getView().calculateExtent(tlv.map.getSize());
	var bbox = ol.proj.transformExtent(extent, "EPSG:3857", "EPSG:4326");
	$.ajax({
		data: "auth=" + tlv.gbdxCredentials.accessToken + "&bbox=" + bbox.join(",") + "&type=" + type,
		dataType: "json",
		error: function(jqXhr, textStatus, errorThrown) {
			$(progress).css("background-color", "red");
			$(progress).html("Error");
		},
		success: function(data) {
			var features = [];
			$.each(
				data.data,
				function(i, x) {
					var feature = new ol.format.GeoJSON().readFeature(x, { featureProjection: "EPSG:3857" });
					features.push(feature);
				}
			);

			tlv.gbdx.vectors[type].mapLayer.getSource().addFeatures(features);

			$(progress).css("background-color", "green");
			$(progress).html("Loaded");

			addGbdxFeatureInteraction(type);
		},
		url: tlv.contextPath + "/gbdx/queryVectors"
	});
}

function validateGbdxCredentials(callback) {
	displayLoadingDialog("Hang tight, we'll see if our bouncer will let you in.");

	var apiKey = $("#gbdxApiKeyInput").val();
	var password = $("#gbdxPasswordInput").val();
	var username = $("#gbdxUsernameInput").val();
	$.ajax({
		data: "apiKey=" + apiKey + "&password=" + password + "&username=" + username,
		dataType: "json",
		error: function(jqXhr, textStatus, errorThrown) {
			hideLoadingDialog();
			invalidGbdxCredentials();
		},
		success: function(data) {
			hideLoadingDialog();
			if (data.access_token) {
				tlv.gbdxCredentials = {
					accessToken: data.access_token,
					apiKey: apiKey,
					password: password,
					username: username
				};

				callback();
			}
			else { invalidPiazzaCredentials(); }
		},
		type: "POST",
		url: tlv.contextPath + "/gbdx/validateCredentials"
	});
}

function queryGbdx() {
	if (!tlv.gbdxCredentials) {
		$("#gbdxCredentialsDialog").modal("show");
		var loginButton = $("#gbdxCredentialsDialog .modal-footer").children()[0];
		loginButton.onclick = function() { validateGbdxCredentials(queryGbdx); }
	}
	else {
		$.each(
			tlv.gbdx.vectors,
			function(i, x) {
				if (x.featureInteraction) { tlv.map.removeInteraction(x.featureInteraction); }
				if (x.mapLayer) { tlv.map.removeLayer(x.mapLayer); }
			}
		);

		tlv.gbdx = {};
		queryVectorSources();
	}
}

function queryVectorSources() {
	displayLoadingDialog("Ok, let's see who has some vectors for us today...");

	var extent = tlv.map.getView().calculateExtent(tlv.map.getSize());
	var bbox = ol.proj.transformExtent(extent, "EPSG:3857", "EPSG:4326");
	$.ajax({
		data: "auth=" + tlv.gbdxCredentials.accessToken + "&bbox=" + bbox.join(","),
		dataType: "json",
		error: function(jqXhr, textStatus, errorThrown) {
			hideLoadingDialog();
		},
		success: function(data) {
			hideLoadingDialog();
			if (data) {
				tlv.gbdx.sources = data.data;
				tlv.gbdx.types = [];
				tlv.gbdx.vectors = {};

				queryVectorTypes();
			}
			else { displayErrorDialog("Sorry, couldn't find any vector sources. :()"); }
		},
		url: tlv.contextPath + "/gbdx/queryVectorSources"
	});
}

function queryVectorTypes() {
	$.each(
		tlv.gbdx.sources,
		function(i, x) {
			if (!x.checked) {
				var source = x.name;
				displayLoadingDialog("Alright, let's see what types of " + source + " vectors are out there...");

				var extent = tlv.map.getView().calculateExtent(tlv.map.getSize());
				var bbox = ol.proj.transformExtent(extent, "EPSG:3857", "EPSG:4326");
				$.ajax({
					context: { source: x },
					data: "auth=" + tlv.gbdxCredentials.accessToken + "&bbox=" + bbox.join(",") + "&source=" + source,
					dataType: "json",
					error: function(jqXhr, textStatus, errorThrown) {
						hideLoadingDialog();
					},
					success: function(data) {
						this.source.checked = true;
						var types = data ? data.data : [];
						$.each(
							types,
							function(j, y) {
								var type = y.name;
								if (!tlv.gbdx.types.includes(type)) {
									tlv.gbdx.types.push(type);
									tlv.gbdx.vectors[type] = {};
								}
							}
						);
						hideLoadingDialog();
						queryVectorTypes();
					},
					url: tlv.contextPath + "/gbdx/queryVectorTypes"
				});


				return false;
			}
			else if (i == tlv.gbdx.sources.length - 1) {
				tlv.gbdx.types.sort();
				updateGbdxResultsButton();
				buildGbdxVectorTypesTable();
			}
		}
	);
}

function updateGbdxResultsButton() {
	var numberOfTypes = 0;
	$.each(tlv.gbdx.types, function(i, x) { numberOfTypes++; });

    var button = $("#gbdxTypesButton");
    if (numberOfTypes > 0) { button.attr("disabled", false); }
    button.html(numberOfTypes + " Types" );
}

var setupTimeLapseGbdx = setupTimeLapse;
setupTimeLapse = function() {
	setupTimeLapseGbdx();

	tlv.gbdx = {};
	var button = $("#gbdxTypesButton");
	button.attr("disabled", true);
	button.html("0 Types" );
}

function toggleGbdxLayer(typeIndex, visibility) {
	var type = tlv.gbdx.types[typeIndex];
	var layer = tlv.gbdx.vectors[type].mapLayer;
    switch (visibility) {
    	case "ON":
			if (!layer) { loadGbdxVectors(type); }
			else { layer.setVisible(true); }
			$("#gbdx" + typeIndex + "VisibilitySelect").css("opacity", 1);
        	break;
    	case "OFF":
        	layer.setVisible(false);
			$("#gbdx" + typeIndex + "VisibilitySelect").css("opacity", 0.5);
        	break;
	}
}
