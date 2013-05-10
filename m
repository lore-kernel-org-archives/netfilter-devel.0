From: Eric Leblond <eric@regit.org>
Subject: [PATCH 07/11] db: suppress field in db structure
Date: Fri, 10 May 2013 08:48:54 +0200
Message-ID: <1368168538-29780-8-git-send-email-eric@regit.org>
References: <1368168538-29780-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:51464 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3EJGt1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 May 2013 02:49:27 -0400
In-Reply-To: <1368168538-29780-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The field is currently only used in a single function as a string
pointer and can thus be removed from the db instance structure.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/ulogd/db.h |    2 +-
 util/db.c          |   36 ++++++++++++++++++------------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/ulogd/db.h b/include/ulogd/db.h
index a533902..a02afb5 100644
--- a/include/ulogd/db.h
+++ b/include/ulogd/db.h
@@ -1,6 +1,7 @@
 /* DB handling functions
  *
  * (C) 2000-2005 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2013 by Eric Leblond <eric@regit.org>
  *
  * This code is distributed under the terms of GNU GPL version 2 */
 
@@ -29,7 +30,6 @@ struct db_stmt {
 struct db_instance {
 	char *stmt; /* buffer for our insert statement */
 	char *stmt_val; /* pointer to the beginning of the "VALUES" part */
-	char *stmt_ins; /* pointer to current inser position in statement */
 	char *schema;
 	time_t reconnect;
 	int (*interp)(struct ulogd_pluginstance *upi);
diff --git a/util/db.c b/util/db.c
index d125e21..ec0c045 100644
--- a/util/db.c
+++ b/util/db.c
@@ -266,7 +266,7 @@ static void __format_query_db(struct ulogd_pluginstance *upi)
 
 	unsigned int i;
 
-	di->stmt_ins = di->stmt_val;
+	char * stmt_ins = di->stmt_val;
 
 	for (i = 0; i < upi->input.num_keys; i++) {
 		struct ulogd_key *res = upi->input.keys[i].u.source;
@@ -280,52 +280,52 @@ static void __format_query_db(struct ulogd_pluginstance *upi)
 			
 		if (!res || !IS_VALID(*res)) {
 			/* no result, we have to fake something */
-			di->stmt_ins += sprintf(di->stmt_ins, "NULL,");
+			stmt_ins += sprintf(stmt_ins, "NULL,");
 			continue;
 		}
 		
 		switch (res->type) {
 		case ULOGD_RET_INT8:
-			sprintf(di->stmt_ins, "%d,", res->u.value.i8);
+			sprintf(stmt_ins, "%d,", res->u.value.i8);
 			break;
 		case ULOGD_RET_INT16:
-			sprintf(di->stmt_ins, "%d,", res->u.value.i16);
+			sprintf(stmt_ins, "%d,", res->u.value.i16);
 			break;
 		case ULOGD_RET_INT32:
-			sprintf(di->stmt_ins, "%d,", res->u.value.i32);
+			sprintf(stmt_ins, "%d,", res->u.value.i32);
 			break;
 		case ULOGD_RET_INT64:
-			sprintf(di->stmt_ins, "%" PRId64 ",", res->u.value.i64);
+			sprintf(stmt_ins, "%" PRId64 ",", res->u.value.i64);
 			break;
 		case ULOGD_RET_UINT8:
-			sprintf(di->stmt_ins, "%u,", res->u.value.ui8);
+			sprintf(stmt_ins, "%u,", res->u.value.ui8);
 			break;
 		case ULOGD_RET_UINT16:
-			sprintf(di->stmt_ins, "%u,", res->u.value.ui16);
+			sprintf(stmt_ins, "%u,", res->u.value.ui16);
 			break;
 		case ULOGD_RET_IPADDR:
 			/* fallthrough when logging IP as u_int32_t */
 		case ULOGD_RET_UINT32:
-			sprintf(di->stmt_ins, "%u,", res->u.value.ui32);
+			sprintf(stmt_ins, "%u,", res->u.value.ui32);
 			break;
 		case ULOGD_RET_UINT64:
-			sprintf(di->stmt_ins, "%" PRIu64 ",", res->u.value.ui64);
+			sprintf(stmt_ins, "%" PRIu64 ",", res->u.value.ui64);
 			break;
 		case ULOGD_RET_BOOL:
-			sprintf(di->stmt_ins, "'%d',", res->u.value.b);
+			sprintf(stmt_ins, "'%d',", res->u.value.b);
 			break;
 		case ULOGD_RET_STRING:
-			*(di->stmt_ins++) = '\'';
+			*(stmt_ins++) = '\'';
 			if (res->u.value.ptr) {
-				di->stmt_ins +=
-				di->driver->escape_string(upi, di->stmt_ins,
+				stmt_ins +=
+				di->driver->escape_string(upi, stmt_ins,
 							  res->u.value.ptr,
 							strlen(res->u.value.ptr));
 			}
-			sprintf(di->stmt_ins, "',");
+			sprintf(stmt_ins, "',");
 			break;
 		case ULOGD_RET_RAWSTR:
-			sprintf(di->stmt_ins, "%s,", (char *) res->u.value.ptr);
+			sprintf(stmt_ins, "%s,", (char *) res->u.value.ptr);
 			break;
 		case ULOGD_RET_RAW:
 			ulogd_log(ULOGD_NOTICE,
@@ -336,9 +336,9 @@ static void __format_query_db(struct ulogd_pluginstance *upi)
 				res->type, upi->input.keys[i].name);
 			break;
 		}
-		di->stmt_ins = di->stmt + strlen(di->stmt);
+		stmt_ins = di->stmt + strlen(di->stmt);
 	}
-	*(di->stmt_ins - 1) = ')';
+	*(stmt_ins - 1) = ')';
 }
 
 static int __add_to_backlog(struct ulogd_pluginstance *upi, const char *stmt, unsigned int len)
-- 
1.7.10.4

