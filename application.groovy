import groovy.json.JsonSlurper


def dbConnection = new JsonSlurper().parseText(System.getenv("VCAP_SERVICES"))."user-provided"[0].credentials

dataSource {
	pooled = true
	jmxExport = true
	driverClassName = "org.postgresql.Driver"
	username = dbConnection.username
	password = dbConnection.password
}

environments {
	production {
		grails.dbconsole.enabled = true
		dataSource {
			dbCreate = "update"
			url = "jdbc:postgresql://${dbConnection.host}/${dbConnection.database}"
			properties {
				jmxEnabled = true
				initialSize = 5
				maxActive = 50
				minIdle = 5
				maxIdle = 25
				maxWait = 10000
				maxAge = 600000
				timeBetweenEvictionRunsMillis = 5000
				minEvictableIdleTimeMillis = 60000
				validationQuery = "SELECT 1"
				validationQueryTimeout = 3
				validationInterval = 15000
				testOnBorrow = true
				testWhileIdle = true
				testOnReturn = false
				jdbcInterceptors = "ConnectionState"
				defaultTransactionIsolation = 2
			}
		}
	}
}
