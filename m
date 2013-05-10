From: Eric Leblond <eric@regit.org>
Subject: [PATCH 08/11] db: use offset instead of direct pointer.
Date: Fri, 10 May 2013 08:48:55 +0200
Message-ID: <1368168538-29780-9-git-send-email-eric@regit.org>
References: <1368168538-29780-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:51466 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab3EJGt2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 May 2013 02:49:28 -0400
In-Reply-To: <1368168538-29780-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use an offset approach to get the start of values printing area. It
is more generic and will be use soon.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/ulogd/db.h |    2 +-
 util/db.c          |   16 +++++++++-------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/ulogd/db.h b/include/ulogd/db.h
index a02afb5..82f37b9 100644
--- a/include/ulogd/db.h
+++ b/include/ulogd/db.h
@@ -29,7 +29,7 @@ struct db_stmt {
 
 struct db_instance {
 	char *stmt; /* buffer for our insert statement */
-	char *stmt_val; /* pointer to the beginning of the "VALUES" part */
+	int stmt_offset; /* offset to the beginning of the "VALUES" part */
 	char *schema;
 	time_t reconnect;
 	int (*interp)(struct ulogd_pluginstance *upi);
diff --git a/util/db.c b/util/db.c
index ec0c045..1a11173 100644
--- a/util/db.c
+++ b/util/db.c
@@ -66,6 +66,7 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
 	unsigned int i;
 	char *table = table_ce(upi->config_kset).u.string;
 	char *procedure = procedure_ce(upi->config_kset).u.string;
+	char *stmt_val = NULL;
 
 	if (mi->stmt)
 		free(mi->stmt);
@@ -106,7 +107,7 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
 		else
 			sprintf(mi->stmt, "%s (", procedure);
 
-		mi->stmt_val = mi->stmt + strlen(mi->stmt);
+		stmt_val = mi->stmt + strlen(mi->stmt);
 
 		for (i = 0; i < upi->input.num_keys; i++) {
 			if (upi->input.keys[i].flags & ULOGD_KEYF_INACTIVE)
@@ -115,19 +116,20 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
 			strncpy(buf, upi->input.keys[i].name, ULOGD_MAX_KEYLEN);	
 			while ((underscore = strchr(buf, '.')))
 				*underscore = '_';
-			sprintf(mi->stmt_val, "%s,", buf);
-			mi->stmt_val = mi->stmt + strlen(mi->stmt);
+			sprintf(stmt_val, "%s,", buf);
+			stmt_val = mi->stmt + strlen(mi->stmt);
 		}
-		*(mi->stmt_val - 1) = ')';
+		*(stmt_val - 1) = ')';
 
-		sprintf(mi->stmt_val, " values (");
+		sprintf(stmt_val, " values (");
 	} else if (strncasecmp(procedure,"CALL", strlen("CALL")) == 0) {
 		sprintf(mi->stmt, "CALL %s(", procedure);
 	} else {
 		sprintf(mi->stmt, "SELECT %s(", procedure);
 
 	}
-	mi->stmt_val = mi->stmt + strlen(mi->stmt);
+
+	mi->stmt_offset = strlen(mi->stmt);
 
 	ulogd_log(ULOGD_DEBUG, "stmt='%s'\n", mi->stmt);
 
@@ -266,7 +268,7 @@ static void __format_query_db(struct ulogd_pluginstance *upi)
 
 	unsigned int i;
 
-	char * stmt_ins = di->stmt_val;
+	char * stmt_ins = di->stmt + di->stmt_offset;
 
 	for (i = 0; i < upi->input.num_keys; i++) {
 		struct ulogd_key *res = upi->input.keys[i].u.source;
-- 
1.7.10.4

