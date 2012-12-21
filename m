From: Eric Leblond <eric@regit.org>
Subject: [PATCH 2/3] Handle postgresql schemas correctly
Date: Fri, 21 Dec 2012 15:01:52 +0100
Message-ID: <1356098513-18684-3-git-send-email-eric@regit.org>
References: <1356098513-18684-1-git-send-email-eric@regit.org>
Cc: Bob Hockney <zeus@ix.netcom.com>, Eric Leblond <eric@regit.org>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:46339 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab2LUOCy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Dec 2012 09:02:54 -0500
In-Reply-To: <1356098513-18684-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Bob Hockney <zeus@ix.netcom.com>

Add 'schema' variable to look into corresponding schema.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 output/pgsql/ulogd_output_PGSQL.c |   35 +++++++++++++++++++++++++++++++----
 ulogd.conf.in                     |    4 ++++
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index cd793ca..f246153 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -105,9 +105,16 @@ static int pgsql_namespace(struct ulogd_pluginstance *upi)
 	}
 
 	if (PQresultStatus(pi->pgres) == PGRES_TUPLES_OK) {
-		ulogd_log(ULOGD_DEBUG, "using schema %s\n",
-			  schema_ce(upi->config_kset).u.string);
-		pi->db_inst.schema = schema_ce(upi->config_kset).u.string;
+		if (PQntuples(pi->pgres)) {
+			ulogd_log(ULOGD_DEBUG, "using schema %s\n",
+				  schema_ce(upi->config_kset).u.string);
+			pi->db_inst.schema = schema_ce(upi->config_kset).u.string;
+		} else {
+			ulogd_log(ULOGD_ERROR, "schema %s not found: %s\n",
+				 schema_ce(upi->config_kset).u.string, PQerrorMessage(pi->dbh));
+			PQclear(pi->pgres);
+			return -1;
+		}
 	} else {
 		pi->db_inst.schema = NULL;
 	}
@@ -223,6 +230,8 @@ static int open_db_pgsql(struct ulogd_pluginstance *upi)
 	char *user = user_ce(upi->config_kset).u.string;
 	char *pass = pass_ce(upi->config_kset).u.string;
 	char *db = db_ce(upi->config_kset).u.string;
+	char *schema = NULL;
+	char pgbuf[128];
 
 	/* 80 is more than what we need for the fixed parts below */
 	len = 80 + strlen(user) + strlen(db);
@@ -270,11 +279,29 @@ static int open_db_pgsql(struct ulogd_pluginstance *upi)
 	}
 
 	if (pgsql_namespace(upi)) {
-		ulogd_log(ULOGD_ERROR, "unable to test for pgsql schemas\n");
+		ulogd_log(ULOGD_ERROR, "problem testing for pgsql schemas\n");
 		close_db_pgsql(upi);
 		return -1;
 	}
 
+	pi=(struct pgsql_instance *)upi->private;
+	schema = pi->db_inst.schema;
+
+	if (!(schema == NULL) && (strcmp(schema,"public"))) {
+		snprintf(pgbuf, 128, "SET search_path='%.63s', \"$user\", 'public'", schema);
+		pi->pgres = PQexec(pi->dbh, pgbuf);
+		if ((PQresultStatus(pi->pgres) == PGRES_COMMAND_OK)) {
+			PQclear(pi->pgres);
+		} else {
+			ulogd_log(ULOGD_ERROR, "could not set search path to (%s): %s\n",
+				 schema, PQerrorMessage(pi->dbh));
+			PQclear(pi->pgres);
+			close_db_pgsql(upi);
+			return -1;
+		}
+
+	}
+
 	return 0;
 }
 
diff --git a/ulogd.conf.in b/ulogd.conf.in
index 3bd464b..c630b88 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -213,6 +213,7 @@ db="nulog"
 host="localhost"
 user="nupik"
 table="ulog"
+#schema="public"
 pass="changeme"
 procedure="INSERT_PACKET_FULL"
 
@@ -221,6 +222,7 @@ db="nulog"
 host="localhost"
 user="nupik"
 table="ulog2_ct"
+#schema="public"
 pass="changeme"
 procedure="INSERT_CT"
 
@@ -229,6 +231,7 @@ db="nulog"
 host="localhost"
 user="nupik"
 table="ulog2_ct"
+#schema="public"
 pass="changeme"
 procedure="INSERT_OR_REPLACE_CT"
 
@@ -237,6 +240,7 @@ db="nulog"
 host="localhost"
 user="nupik"
 table="nfacct"
+#schema="public"
 pass="changeme"
 procedure="INSERT_NFACCT"
 
-- 
1.7.10.4

