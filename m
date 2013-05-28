From: Eric Leblond <eric@regit.org>
Subject: [Ulogd PATCH] pgsql: add var to specify arbitrary conn params
Date: Tue, 28 May 2013 21:58:57 +0200
Message-ID: <1369771137-5453-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:59232 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab3E1T7K (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 May 2013 15:59:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a configuration variable for PostgreSQL output.
Named connstring it stores the character string that will be
used to connect to the PostgreSQL server. This allows the user
to use all options available like TLS parameters for example.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 output/pgsql/ulogd_output_PGSQL.c |   87 ++++++++++++++++++++-----------------
 ulogd.conf.in                     |    6 +++
 2 files changed, 53 insertions(+), 40 deletions(-)

diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index 88fb765..fda289e 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -38,7 +38,7 @@ struct pgsql_instance {
 
 /* our configuration directives */
 static struct config_keyset pgsql_kset = {
-	.num_ces = DB_CE_NUM + 6,
+	.num_ces = DB_CE_NUM + 7,
 	.ces = {
 		DB_CES,
 		{ 
@@ -72,6 +72,11 @@ static struct config_keyset pgsql_kset = {
 			.options = CONFIG_OPT_NONE,
 			.u.string = "public",
 		},
+		{
+			.key = "connstring",
+			.type = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_NONE,
+		},
 	},
 };
 #define db_ce(x)	(x->ces[DB_CE_NUM+0])
@@ -80,6 +85,7 @@ static struct config_keyset pgsql_kset = {
 #define pass_ce(x)	(x->ces[DB_CE_NUM+3])
 #define port_ce(x)	(x->ces[DB_CE_NUM+4])
 #define schema_ce(x)	(x->ces[DB_CE_NUM+5])
+#define connstr_ce(x)	(x->ces[DB_CE_NUM+6])
 
 #define PGSQL_HAVE_NAMESPACE_TEMPLATE 			\
 	"SELECT nspname FROM pg_namespace n WHERE n.nspname='%s'"
@@ -226,52 +232,53 @@ static int open_db_pgsql(struct ulogd_pluginstance *upi)
 {
 	struct pgsql_instance *pi = (struct pgsql_instance *) upi->private;
 	int len;
-	char *connstr;
-	char *server = host_ce(upi->config_kset).u.string;
-	unsigned int port = port_ce(upi->config_kset).u.value;
-	char *user = user_ce(upi->config_kset).u.string;
-	char *pass = pass_ce(upi->config_kset).u.string;
-	char *db = db_ce(upi->config_kset).u.string;
+	char *connstr = connstr_ce(upi->config_kset).u.string;
 	char *schema = NULL;
 	char pgbuf[128];
 
-	/* 80 is more than what we need for the fixed parts below */
-	len = 80 + strlen(user) + strlen(db);
-
-	/* hostname and  and password are the only optionals */
-	if (server)
-		len += strlen(server);
-	if (pass)
-		len += strlen(pass);
-	if (port)
-		len += 20;
-
-	connstr = (char *) malloc(len);
-	if (!connstr) 
-		return -ENOMEM;
-	connstr[0] = '\0';
-
-	if (server && strlen(server) > 0) {
-		strcpy(connstr, " host=");
-		strcat(connstr, server);
-	}
+	if (!connstr) {
+		char *server = host_ce(upi->config_kset).u.string;
+		unsigned int port = port_ce(upi->config_kset).u.value;
+		char *user = user_ce(upi->config_kset).u.string;
+		char *pass = pass_ce(upi->config_kset).u.string;
+		char *db = db_ce(upi->config_kset).u.string;
+		/* 80 is more than what we need for the fixed parts below */
+		len = 80 + strlen(user) + strlen(db);
+
+		/* hostname and  and password are the only optionals */
+		if (server)
+			len += strlen(server);
+		if (pass)
+			len += strlen(pass);
+		if (port)
+			len += 20;
+
+		connstr = (char *) malloc(len);
+		if (!connstr)
+			return -ENOMEM;
+		connstr[0] = '\0';
+
+		if (server && strlen(server) > 0) {
+			strcpy(connstr, " host=");
+			strcat(connstr, server);
+		}
 
-	if (port) {
-		char portbuf[20];
-		snprintf(portbuf, sizeof(portbuf), " port=%u", port);
-		strcat(connstr, portbuf);
-	}
+		if (port) {
+			char portbuf[20];
+			snprintf(portbuf, sizeof(portbuf), " port=%u", port);
+			strcat(connstr, portbuf);
+		}
 
-	strcat(connstr, " dbname=");
-	strcat(connstr, db);
-	strcat(connstr, " user=");
-	strcat(connstr, user);
+		strcat(connstr, " dbname=");
+		strcat(connstr, db);
+		strcat(connstr, " user=");
+		strcat(connstr, user);
 
-	if (pass) {
-		strcat(connstr, " password=");
-		strcat(connstr, pass);
+		if (pass) {
+			strcat(connstr, " password=");
+			strcat(connstr, pass);
+		}
 	}
-	
 	pi->dbh = PQconnectdb(connstr);
 	if (PQstatus(pi->dbh) != CONNECTION_OK) {
 		ulogd_log(ULOGD_ERROR, "unable to connect to db (%s): %s\n",
diff --git a/ulogd.conf.in b/ulogd.conf.in
index 11a56d6..042bfe1 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -231,6 +231,12 @@ table="ulog"
 #schema="public"
 pass="changeme"
 procedure="INSERT_PACKET_FULL"
+# connstring can be used to define PostgreSQL connection string which
+# contains all parameters of the connection. If set, this value has
+# precedence on other variables used to build the connection string.
+# See http://www.postgresql.org/docs/9.2/static/libpq-connect.html#LIBPQ-CONNSTRING
+# for a complete description of options.
+#connstring="host=localhost port=4321 dbname=nulog user=nupik password=changeme"
 #backlog_memcap=1000000
 #backlog_oneshot_requests=10
 # If superior to 1 a thread dedicated to SQL request execution
-- 
1.7.10.4

