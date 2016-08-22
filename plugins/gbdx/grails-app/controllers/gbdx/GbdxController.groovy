package gbdx


import groovy.json.JsonOutput
import static groovyx.net.http.Method.*


class GbdxController {

	def httpDownloadService


	def getPagingId(params) {
		params.authType = "Bearer"

		def bbox = params.bbox.split(",")
		def type = params.type.replaceAll(/\s/, "%20")
		params.url = "https://vector.geobigdata.io/insight-vector/api/vectors/query/paging" +
			"?q=item_type:${type}" +
			"&left=${bbox[0]}&lower=${bbox[1]}&right=${bbox[2]}&upper=${bbox[3]}&ttl=5m&count=100"

		def query = httpDownloadService.serviceMethod(params)
	 	def pagingId = query.pagingId


		return pagingId
	}

	def getVectors(params) {
		params.authType = "Bearer"
		params.body = [pagingId: params.pagingId]
		params.method = POST
		params.url = "https://vector.geobigdata.io/insight-vector/api/vectors/paging"
		def vectors = httpDownloadService.serviceMethod(params)


		return vectors
	}

	def validateCredentials() {
		params.url = "https://geobigdata.io/auth/v1/oauth/token"
		params.auth = params.apiKey
		params.method = POST
		def body = [
			grant_type: "password",
			password: params.password,
			username: params.username
		]
		params.body = body
		params.remove("password")
		params.remove("username")

		def credentials = httpDownloadService.serviceMethod(params)


		render JsonOutput.toJson(credentials)
	}

	def queryVectorSources() {
		params.authType = "Bearer"

		def bbox = params.bbox.split(",")
		params.url = "https://vector.geobigdata.io/insight-vector/api/vectors/sources" +
			"?left=${bbox[0]}&lower=${bbox[1]}&right=${bbox[2]}&upper=${bbox[3]}"

		def sources = httpDownloadService.serviceMethod(params)


		render JsonOutput.toJson(sources)
	}

	def queryVectorTypes() {
		params.authType = "Bearer"

		def bbox = params.bbox.split(",")
		def source = params.source.replaceAll(/\s/, "%20")
		params.url = "https://vector.geobigdata.io/insight-vector/api/vectors/${source}/types" +
			"?left=${bbox[0]}&lower=${bbox[1]}&right=${bbox[2]}&upper=${bbox[3]}"
		println params.url

		def types = httpDownloadService.serviceMethod(params)


		render JsonOutput.toJson(types)
	}

	def queryVectors() {
		def pagingId = getPagingId(params)
		def vectors = getVectors([
			auth: params.auth,
			pagingId: pagingId
		])


		render JsonOutput.toJson(vectors)
	}

}
