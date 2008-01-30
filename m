From: heitzenberger@astaro.com
Subject: [ULOGD RFC 14/30] SQLITLE3: add disable switch
Date: Wed, 30 Jan 2008 19:59:01 +0100
Message-ID: <20080130190128.234506875@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-24.dex002.intermedia.net ([64.78.21.104]:55064 "EHLO
	DHOST002-24.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754168AbYA3TBn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:43 -0500
Content-Disposition: inline; filename=ulogd-SQLITE3-add-disable-switch.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/output/sqlite3/ulogd_output_SQLITE3.c
===================================================================
--- ulogd-netfilter.orig/output/sqlite3/ulogd_output_SQLITE3.c
+++ ulogd-netfilter/output/sqlite3/ulogd_output_SQLITE3.c
@@ -95,13 +95,13 @@ struct sqlite3_priv {
 	int max_rows;				/* number of rows actually seen */
 	int max_rows_allowed;
 
+	unsigned disable : 1;
 	unsigned overlimit_msg : 1;
 };
 
 
-static int do_reinit;
 static struct config_keyset sqlite3_kset = {
-	.num_ces = 5,
+	.num_ces = 6,
 	.ces = {
 		{
 			.key = "db",
@@ -131,6 +131,12 @@ static struct config_keyset sqlite3_kset
 			.options = CONFIG_OPT_NONE,
 			.u.value = CFG_MAX_BACKLOG_DEFAULT,
 		},
+		{
+			.key = "disable",
+			.type = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = 0,
+		},
 	},
 };
 
@@ -139,6 +145,7 @@ static struct config_keyset sqlite3_kset
 #define buffer_ce(pi)	(pi)->config_kset->ces[2].u.value
 #define timer_ce(pi)	(pi)->config_kset->ces[3].u.value
 #define max_backlog_ce(pi)	(pi)->config_kset->ces[4].u.value
+#define disable_ce(pi)	(pi)->config_kset->ces[5].u.value
 
 
 #define SQL_CREATE_STR \
@@ -248,7 +255,7 @@ db_createstmt(struct ulogd_pluginstance 
 		return 1;
 	}
 
-	pr_debug("statement prepared.\n");
+	pr_debug("%s: statement prepared.\n", pi->id);
 
 	return 0;
 }
@@ -322,7 +329,7 @@ db_init(struct ulogd_pluginstance *pi)
 
 	num_cols = db_count_cols(pi, &schema_stmt);
 	if (num_cols != DB_NUM_COLS) {
-		ulogd_log(ULOGD_INFO, PFX "(re)creating database\n");
+		ulogd_log(ULOGD_INFO, "%s: (re)creating database\n", pi->id);
 
 		if (db_create_tbl(pi) < 0)
 			return -1;
@@ -351,7 +358,7 @@ db_init(struct ulogd_pluginstance *pi)
 		}
 	}
 
-	ulogd_log(ULOGD_INFO, PFX "database successfully opened\n");
+	ulogd_log(ULOGD_INFO, "%s: database opened\n", pi->id);
 
 	if (sqlite3_finalize(schema_stmt) != SQLITE_OK) {
 		ulogd_error(PFX "sqlite_finalize: %s\n",
@@ -383,7 +390,7 @@ db_start(struct ulogd_pluginstance *pi)
 {
 	struct sqlite3_priv *priv = (void *)pi->private;
 
-	ulogd_log(ULOGD_DEBUG, PFX "opening database connection\n");
+	ulogd_log(ULOGD_DEBUG, "%s: opening database connection\n", pi->id);
 
 	if (sqlite3_open(db_ce(pi), &priv->dbh) != SQLITE_OK) {
 		ulogd_error(PFX "%s\n", sqlite3_errmsg(priv->dbh));
@@ -538,7 +545,8 @@ db_commit_rows(struct ulogd_pluginstance
 		if (sqlite3_errcode(priv->dbh) == SQLITE_LOCKED)
 			return 0;			/* perform commit later */
 	
-		ulogd_error(PFX "begin transaction: %s\n", sqlite3_errmsg(priv->dbh));
+		ulogd_error("%s: begin transaction: %s\n", pi->id,
+					sqlite3_errmsg(priv->dbh));
 
 		return -1;
 	}
@@ -555,8 +563,8 @@ db_commit_rows(struct ulogd_pluginstance
 		sqlite3_reset(priv->p_stmt);
 
 		if (priv->num_rows > priv->buffer_size)
-			ulogd_log(ULOGD_INFO, PFX "commited backlog buffer (%d rows)\n",
-					  priv->num_rows);
+			ulogd_log(ULOGD_INFO, "%s: commited backlog buffer (%d rows)\n",
+					  pi->id, priv->num_rows);
 
 		delete_all_rows(pi);
 
@@ -626,34 +634,38 @@ sqlite3_configure(struct ulogd_pluginsta
 {
 	struct sqlite3_priv *priv = (void *)pi->private;
 
+	memset(priv, 0, sizeof(struct sqlite3_priv));
+	
 	config_parse_file(pi->id, pi->config_kset);
 
 	if (ulogd_wildcard_inputkeys(pi) < 0)
 		return -1;
 
 	if (db_ce(pi) == NULL) {
-		ulogd_error(PFX "configure: no database specified\n");
+		ulogd_error("%s: configure: no database specified\n", pi->id);
 		return -1;
 	}
 
 	if (table_ce(pi) == NULL) {
-		ulogd_error(PFX "configure: no table specified\n");
+		ulogd_error("%s: configure: no table specified\n", pi->id);
 		return -1;
 	}
 
 	if (timer_ce(pi) <= 0) {
-		ulogd_error(PFX "configure: invalid timer value\n");
+		ulogd_error("%s: configure: invalid timer value\n", pi->id);
 		return -1;
 	}
 
 	if (max_backlog_ce(pi)) {
 		if (max_backlog_ce(pi) <= buffer_ce(pi)) {
-			ulogd_error(PFX "configure: invalid max-backlog value\n");
+			ulogd_error("%s: configure: invalid max-backlog value\n",
+						pi->id);
 			return -1;
 		}
 	}
 
 	priv->max_rows_allowed = max_backlog_ce(pi);
+	priv->disable = disable_ce(pi);
 
 	pr_debug("%s: db='%s' table='%s' timer=%d max-backlog=%d\n", pi->id,
 			 db_ce(pi), table_ce(pi), timer_ce(pi), max_backlog_ce(pi));
@@ -677,6 +689,11 @@ sqlite3_start(struct ulogd_pluginstance 
 
 	pr_debug("%s: pi=%p\n", __func__, pi);
 
+	if (priv->disable) {
+		ulogd_log(ULOGD_NOTICE, "%s: disabled\n", pi->id);
+		return 0;
+	}
+
 	priv->num_rows = priv->max_rows = 0;
 	TAILQ_INIT(&priv->rows);
 
@@ -697,6 +714,9 @@ sqlite3_stop(struct ulogd_pluginstance *
 
 	pr_debug("%s: pi=%p\n", __func__, pi);
 
+	if (priv->disable)
+		return 0;				/* wasn't started */
+
 	if (priv->dbh == NULL)
 		return 0;				/* already stopped */
 

-- 
