From: heitzenberger@astaro.com
Subject: [ULOGD RFC 12/30] SQLITE3: make reconfigurable
Date: Wed, 30 Jan 2008 19:58:59 +0100
Message-ID: <20080130190127.975499144@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-28.dex002.intermedia.net ([64.78.21.113]:20892 "EHLO
	dhost002-28.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753507AbYA3TBq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:46 -0500
Content-Disposition: inline; filename=ulogd-SQLITE3-make-reconfigurable.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/output/sqlite3/ulogd_output_SQLITE3.c
===================================================================
--- ulogd-netfilter.orig/output/sqlite3/ulogd_output_SQLITE3.c
+++ ulogd-netfilter/output/sqlite3/ulogd_output_SQLITE3.c
@@ -50,11 +50,6 @@
 /* number of colums we have (really should be configurable) */
 #define DB_NUM_COLS	10
 
-#if 0
-#define DEBUGP(x, args...)	fprintf(stderr, x, ## args)
-#else
-#define DEBUGP(x, args...)
-#endif
 
 /* map DB column to ulogd key */
 struct col {
@@ -245,7 +240,7 @@ db_createstmt(struct ulogd_pluginstance 
 	sprintf(stmt_pos, "?)");
 	ulogd_log(ULOGD_DEBUG, "%s: stmt='%s'\n", pi->id, priv->stmt);
 
-	DEBUGP("about to prepare statement.\n");
+	pr_debug("about to prepare statement.\n");
 
 	sqlite3_prepare(priv->dbh, priv->stmt, -1, &priv->p_stmt, 0);
 	if (priv->p_stmt == NULL) {
@@ -253,7 +248,7 @@ db_createstmt(struct ulogd_pluginstance 
 		return 1;
 	}
 
-	DEBUGP("statement prepared.\n");
+	pr_debug("statement prepared.\n");
 
 	return 0;
 }
@@ -346,7 +341,7 @@ db_init(struct ulogd_pluginstance *pi)
 		while ((underscore = strchr(buf, '_')) != NULL)
 			*underscore = '.';
 
-		DEBUGP("column '%s' found\n", buf);
+		pr_debug("column '%s' found\n", buf);
 
 		strncpy(col->name, buf, ULOGD_MAX_KEYLEN);
 
@@ -589,15 +584,6 @@ sqlite3_interp(struct ulogd_pluginstance
 	struct col *cols = priv->cols;
 	struct row *row;
 
-	if (do_reinit) {
-		db_reset(pi);
-
-		if (db_start(pi) < 0)
-			return ULOGD_IRET_STOP;
-
-		do_reinit = 0;
-	}
-
 	if ((row = row_new()) == NULL)
 		return ULOGD_IRET_ERR;
 
@@ -622,7 +608,7 @@ sqlite3_interp(struct ulogd_pluginstance
 
 
 static void
-timer_cb(struct ulogd_timer *t)
+sqlite_timer_cb(struct ulogd_timer *t)
 {
 	struct ulogd_pluginstance *pi = t->data;
 	struct sqlite3_priv *priv = (void *)pi->private;
@@ -669,11 +655,11 @@ sqlite3_configure(struct ulogd_pluginsta
 
 	priv->max_rows_allowed = max_backlog_ce(pi);
 
-	DEBUGP("%s: db='%s' table='%s' timer=%d max-backlog=%d\n", pi->id,
-		   db_ce(pi), table_ce(pi), timer_ce(pi), max_backlog_ce(pi));
+	pr_debug("%s: db='%s' table='%s' timer=%d max-backlog=%d\n", pi->id,
+			 db_ce(pi), table_ce(pi), timer_ce(pi), max_backlog_ce(pi));
 
 	/* init timer */
-	priv->timer.cb = timer_cb;
+	priv->timer.cb = sqlite_timer_cb;
 	priv->timer.ival = timer_ce(pi);
 	priv->timer.flags = TIMER_F_PERIODIC;
 	priv->timer.data = pi;
@@ -689,10 +675,17 @@ sqlite3_start(struct ulogd_pluginstance 
 {
 	struct sqlite3_priv *priv = (void *)pi->private;
 
+	pr_debug("%s: pi=%p\n", __func__, pi);
+
 	priv->num_rows = priv->max_rows = 0;
 	TAILQ_INIT(&priv->rows);
 
-	return db_start(pi);
+	if (db_start(pi) < 0)
+		return -1;
+
+	ulogd_log(ULOGD_INFO, "%s: started\n", pi->id);
+
+	return 0;
 }
 
 
@@ -702,16 +695,12 @@ sqlite3_stop(struct ulogd_pluginstance *
 {
 	struct sqlite3_priv *priv = (void *)pi->private;
 
-	/* free up our prepared statements so we can close the db */
-	if (priv->p_stmt) {
-		sqlite3_finalize(priv->p_stmt);
-		DEBUGP("prepared statement finalized\n");
-	}
+	pr_debug("%s: pi=%p\n", __func__, pi);
 
 	if (priv->dbh == NULL)
-		return -1;
+		return 0;				/* already stopped */
 
-	sqlite3_close(priv->dbh);
+	db_reset(pi);
 
 	return 0;
 }
@@ -720,9 +709,18 @@ sqlite3_stop(struct ulogd_pluginstance *
 static void
 sqlite3_signal(struct ulogd_pluginstance *pi, int sig)
 {
+	struct sqlite3_priv *priv = (void *)pi->private;
+
 	switch (sig) {
 	case SIGUSR1:
-		do_reinit++;
+		if (priv->dbh != NULL) {
+			db_reset(pi);
+
+			if (db_start(pi) < 0) {
+				ulogd_log(ULOGD_FATAL, "%s: database reset failed\n", pi->id);
+				exit(EXIT_FAILURE);
+			}
+		}
 		break;
 
 	default:
@@ -732,7 +730,8 @@ sqlite3_signal(struct ulogd_pluginstance
 
 
 static struct ulogd_plugin sqlite3_plugin = { 
-	.name = "SQLITE3", 
+	.name = "SQLITE3",
+	.flags = ULOGD_PF_RECONF,
 	.input = {
 		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
 	},

-- 
