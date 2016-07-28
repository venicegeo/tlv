function buildBeachfrontResultsTable() {
    $("#beachfrontResultsDialog").modal("show");

    var table = $("#beachfrontResultsTable")[0];
    for (var i = table.rows.length - 1; i > 0; i--) { table.deleteRow(i); }

    var row = table.insertRow(table.rows.length);
    var cell;
    $.each(
        ["Image ID", "Algorithm", "Processed", "View"],
        function(i, x) {
            cell = row.insertCell(row.cells.length);
            $(cell).append("<b>" + x + "</b>");
        }
    );

    $.each(
        tlv.layers,
        function(i, x) {
            if (!$.isEmptyObject(x.beachfront)) {
                $.each(
                    x.beachfront,
                    function(j, y) {
                        row = table.insertRow(table.rows.length);
                        cell = row.insertCell(row.cells.length);
                        $(cell).append(x.imageId);

                        cell = row.insertCell(row.cells.length);
                        $(cell).append(y.name);

                        cell = row.insertCell(row.cells.length);
                        $(cell).append(y.processedOn);

                        cell = row.insertCell(row.cells.length);
                        $(cell).append(
                            "<select onchange = toggleBeachfrontLayer(" + i + ",'" + j + "',$(this).val())>" +
                                "<option>OFF</option>" +
                                "<option>ON</option>" +
                            "</select>"
                        );
                    }
                );
            }
        }
    );
}

function loadGeojsonFromPiazza(dataId, source) {
    $.ajax({
        dataType: "json",
        headers: { "Authorization": "Basic " + btoa(tlv.piazzaCredentials.key + ":") },
        success: function(data) {
            var features = new ol.format.GeoJSON().readFeatures(data, { featureProjection: "EPSG:3857" });
            source.addFeatures(features);
        },
        url: document.location.origin.replace(/tlv/, "pz-gateway") + "/file/" + dataId
    });
}

function queryBeachfront() {
	$.each(
		tlv.layers,
		function(i, x) {
			if (!x.beachfront) {
				if (!tlv.piazzaCredentials) {
					$("#piazzaCredentialsDialog").modal("show");
					var loginButton = $("#piazzaCredentialsDialog .modal-footer").children()[0];
					loginButton.onclick = function() { validatePiazzaCredentials(queryBeachfront); }


                    return false;
				}
				else {
                    $("#beachfrontSearchProgressBar").show();

					$.ajax({
						contentType: "application/json",
						context: x,
						data: JSON.stringify({
                            "query" : {
                                "match" : {
                                    "_all" : "landsat:" + x.imageId
                                }
                            }
                        }),
						headers: { "Authorization": "Basic " + btoa(tlv.piazzaCredentials.key + ":") },
						success: function(data) {
                            var layer = this;
                            layer.beachfront = {};
							$.each(
								data.data,
								function(j, y) {
                                    var geojsonLayer = new ol.layer.Vector({
                                        source: new ol.source.Vector(),
                                            style: new ol.style.Style({
                                                stroke: new ol.style.Stroke({
                                                    color: "rgba(255, 255, 0, 1)",
                                                    wisth: 2
                                                })
                                		}),
                                        visible: false
                                    });
                                    tlv.map.addLayer(geojsonLayer);

									layer.beachfront[y.dataId] = {
							            mapLayer: geojsonLayer,
										name: y.metadata.metadata.algoName,
										processedOn: y.metadata.metadata.algoProcTime
									};
								}
							);

                            updateBeachfrontResultsButton();
                            queryBeachfront();
						},
						type: "POST",
						url: document.location.origin.replace(/tlv/, "pz-gateway") + "/data/query"
					});


					return false;
				}
			}
            else if (i == tlv.layers.length - 1) { $("#beachfrontSearchProgressBar").hide(); }
		}
	);
}

function toggleBeachfrontLayer(layerIndex, dataId, visibility) {
    var layer = tlv.layers[layerIndex].beachfront[dataId].mapLayer;
    switch (visibility) {
        case "ON":
            var source = layer.getSource();
            if (source.getFeatures().length == 0) { loadGeojsonFromPiazza(dataId, source); }
            layer.setVisible(true);
            break;
        case "OFF":
            layer.setVisible(false);
            break;
    }
}

function updateBeachfrontResultsButton() {
    var numberOfResults = 0;
    $.each(
        tlv.layers,
        function(i, x) {
            for (var key in x.beachfront) {
                if (x.beachfront.hasOwnProperty(key)) { numberOfResults++; }
            }
        }
    );

    var button = $("#beachfrontResultsButton");
    if (numberOfResults > 0) {
        button.attr("disabled", false);
    }
    button.html(numberOfResults + " Results" );
    // make sure to disable the button when setupTimeLapse fires
}
