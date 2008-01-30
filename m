From: heitzenberger@astaro.com
Subject: [ULOGD RFC 16/30] SQLITE3: handle locked DB smarter
Date: Wed, 30 Jan 2008 19:59:03 +0100
Message-ID: <20080130190128.493660125@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-82.dex002.intermedia.net ([64.78.20.215]:38024 "EHLO
	dhost002-82.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756332AbYA3TBs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:48 -0500
Content-Disposition: inline; filename=ulogd-SQLITE3-handle-locked-db-smarter.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the DB was locked for some longer time it turned out that ulogd
consumed was hammering the Sqlite DB too often, which resulted in high
CPU usage.

Also replace BSD list (sys/queue.h) by Linux list implementation, as
used by other parts of ulogd.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/output/sqlite3/ulogd_output_SQLITE3.c
===================================================================
--- ulogd-netfilter.orig/output/sqlite3/ulogd_output_SQLITE3.c
+++ ulogd-netfilter/output/sqlite3/ulogd_output_SQLITE3.c
@@ -33,9 +33,9 @@
 #include <ulogd/ulogd.h>
 #include <ulogd/conffile.h>
 #include <ulogd/common.h>
+#include <ulogd/linuxlist.h>
 #include <arpa/inet.h>
 #include <sqlite3.h>
-#include <sys/queue.h>
 
 #define PFX		"SQLITE3: "
 
@@ -58,7 +58,7 @@ struct col {
 };
 
 struct row {
-	TAILQ_ENTRY(row) link;
+	struct llist_head link;
 	uint32_t ip_saddr;
 	uint32_t ip_daddr;
 	unsigned char ip_proto;
@@ -71,11 +71,6 @@ struct row {
 	unsigned flow_duration;
 };
 
-TAILQ_HEAD(row_lh, row);
-
-#define TAILQ_FOR_EACH(pos, head, link) \
-        for (pos = (head).tqh_first; pos != NULL; pos = pos->link.tqe_next)
-
 #define RKEY(key)	((key)->u.source)
 
 
@@ -90,10 +85,11 @@ struct sqlite3_priv {
 	struct col cols[DB_NUM_COLS];
 
 	/* our backlog buffer */
-	struct row_lh rows;
+	struct llist_head rows;
 	int num_rows;
-	int max_rows;				/* number of rows actually seen */
-	int max_rows_allowed;
+	int max_backlog;
+
+	time_t commit_time;
 
 	unsigned disable : 1;
 	unsigned overlimit_msg : 1;
@@ -168,11 +164,9 @@ row_new(void)
 }
 
 
-static void
-row_del(struct sqlite3_priv *priv, struct row *row)
+static inline void
+__row_del(struct sqlite3_priv *priv, struct row *row)
 {
-	TAILQ_REMOVE(&priv->rows, row, link);
-
 	free(row);
 
 	priv->num_rows--;
@@ -180,23 +174,49 @@ row_del(struct sqlite3_priv *priv, struc
 
 
 static void
+row_del(struct sqlite3_priv *priv, struct row *row)
+{
+	llist_del(&row->link);
+
+	__row_del(priv, row);
+}
+
+
+static int
 row_add(struct sqlite3_priv *priv, struct row *row)
 {
-	if (priv->max_rows_allowed && priv->num_rows > priv->max_rows_allowed) {
+	if (priv->max_backlog && priv->num_rows > priv->max_backlog) {
 		if (!priv->overlimit_msg) {
 			ulogd_error(PFX "over max-backlog limit, dropping row\n");
 
 			priv->overlimit_msg = 1;
 		}
 
-		return;
+		__row_del(priv, row);
+
+		return -1;
 	}
 
-	TAILQ_INSERT_TAIL(&priv->rows, row, link);
+	llist_add_tail(&row->link, &priv->rows);
 
 	priv->num_rows++;
+
+	return 0;
 }
 
+/* set_commit_time() - set time for next try on locked database
+ *
+ * The database is effectively locked in between.
+ */
+static void
+set_commit_time(const struct ulogd_pluginstance *pi)
+{
+	struct sqlite3_priv *priv = (void *)pi->private;
+
+	priv->commit_time = t_now + 1;
+
+	pr_debug("%s: commit time %d\n", __func__, priv->commit_time);
+}
 
 #define _SQLITE3_INSERTTEMPL   "insert into X (Y) values (Z)"
 
@@ -408,7 +428,7 @@ db_start(struct ulogd_pluginstance *pi)
 	/* initialize our buffer size and counter */
 	priv->buffer_size = buffer_ce(pi);
 
-	priv->max_rows_allowed = max_backlog_ce(pi);
+	priv->max_backlog = max_backlog_ce(pi);
 
 	/* create and prepare the actual insert statement */
 	db_createstmt(pi);
@@ -481,6 +501,7 @@ db_add_row(struct ulogd_pluginstance *pi
 	switch (sqlite3_errcode(priv->dbh)) {
 	case SQLITE_LOCKED:
 	case SQLITE_BUSY:
+		set_commit_time(pi);
 		break;
 
 	case SQLITE_SCHEMA:
@@ -513,14 +534,22 @@ db_add_row(struct ulogd_pluginstance *pi
 	return -1;
 }
 
+#define llist_for_each_prev_safe(pos, n, head) \
+    for (pos = (head)->prev, n = pos->prev; pos != (head); \
+        pos = n, n = pos->prev)
 
+/* delete_rows() - delete rows from the tail of the list */
 static int
-delete_all_rows(struct ulogd_pluginstance *pi)
+delete_rows(struct ulogd_pluginstance *pi, int rows)
 {
 	struct sqlite3_priv *priv = (void *)pi->private;
+	struct llist_head *curr, *tmp;
 
-	while (priv->rows.tqh_first != NULL) {
-		struct row *row = priv->rows.tqh_first;
+    llist_for_each_prev_safe(curr, tmp, &priv->rows) {
+		struct row *row = container_of(curr, struct row, link);
+
+		if (rows-- == 0)
+			break;
 
 		row_del(priv, row);
 	}
@@ -528,22 +557,33 @@ delete_all_rows(struct ulogd_pluginstanc
 	return 0;
 }
 
+/*
+  db_commit_rows()
 
+  RETURN
+    >0	rows commited
+    0	locked
+   -1	error
+*/
 static int
 db_commit_rows(struct ulogd_pluginstance *pi)
 {
 	struct sqlite3_priv *priv = (void *)pi->private;
 	struct row *row;
-	int ret, rows = 0;
+	int ret, rows = 0, max_commit;
 
 	ret = sqlite3_exec(priv->dbh, "begin immediate transaction", NULL,
 					   NULL, NULL);
 	if (ret != SQLITE_OK) {
-		if (ret == SQLITE_BUSY)
+		if (ret == SQLITE_BUSY) {
+			set_commit_time(pi);
 			goto err_rollback;
+		}
 
-		if (sqlite3_errcode(priv->dbh) == SQLITE_LOCKED)
+		if (sqlite3_errcode(priv->dbh) == SQLITE_LOCKED) {
+			set_commit_time(pi);
 			return 0;			/* perform commit later */
+		}
 	
 		ulogd_error("%s: begin transaction: %s\n", pi->id,
 					sqlite3_errmsg(priv->dbh));
@@ -551,27 +591,35 @@ db_commit_rows(struct ulogd_pluginstance
 		return -1;
 	}
 
-	TAILQ_FOR_EACH(row, priv->rows, link) {
+
+	/* Limit number of rows to commit.  Note that currently three times
+	   buffer_size is a bit arbitrary and therefore might be adjusted in
+	   the future. */
+	max_commit = max(3 * priv->buffer_size, 1024);
+
+	llist_for_each_entry_reverse(row, &priv->rows, link) {
+		if (++rows > max_commit)
+			break;
+
 		if (db_add_row(pi, row) < 0)
 			goto err_rollback;
-
-		rows++;
 	}
 
 	ret = sqlite3_exec(priv->dbh, "commit", NULL, NULL, NULL);
 	if (ret == SQLITE_OK) {
 		sqlite3_reset(priv->p_stmt);
 
-		if (priv->num_rows > priv->buffer_size)
-			ulogd_log(ULOGD_INFO, "%s: commited backlog buffer (%d rows)\n",
-					  pi->id, priv->num_rows);
+		pr_debug("%s: commited %d/%d rows\n", pi->id, rows, priv->num_rows);
+
+		delete_rows(pi, rows);
 
-		delete_all_rows(pi);
+		if (priv->commit_time >= t_now)
+			priv->commit_time = 0;		/* release commit lock */
 
 		if (priv->overlimit_msg)
 			priv->overlimit_msg = 0;
 
-		return 0;
+		return rows;
 	}
 
  err_rollback:
@@ -606,9 +654,10 @@ sqlite3_interp(struct ulogd_pluginstance
 	row->flow_start_sec = RKEY(cols[9].key)->u.value.ui32;
 	row->flow_duration = RKEY(cols[10].key)->u.value.ui32;
 
-	row_add(priv, row);
+	if (row_add(priv, row) < 0)
+		return ULOGD_IRET_OK;
 
-	if (priv->num_rows >= priv->buffer_size)
+	if (priv->num_rows >= priv->buffer_size && priv->commit_time == 0)
 		db_commit_rows(pi);
 
 	return ULOGD_IRET_OK;
@@ -620,11 +669,20 @@ sqlite_timer_cb(struct ulogd_timer *t)
 {
 	struct ulogd_pluginstance *pi = t->data;
 	struct sqlite3_priv *priv = (void *)pi->private;
+	int rows;
 
-	priv->max_rows = max(priv->max_rows, priv->num_rows);
+	pr_debug("%s: timer=%p\n", __func__, t);
 
-	if (priv->num_rows > 0)
-		db_commit_rows(pi);
+	if (priv->commit_time != 0 && priv->commit_time > t_now)
+		return;
+
+	if (priv->num_rows == 0)
+		return;
+
+	rows = db_commit_rows(pi);
+
+	ulogd_log(ULOGD_DEBUG, "%s: rows=%d commited=%d\n", pi->id,
+			  priv->num_rows, rows);
 }
 
 
@@ -664,7 +722,7 @@ sqlite3_configure(struct ulogd_pluginsta
 		}
 	}
 
-	priv->max_rows_allowed = max_backlog_ce(pi);
+	priv->max_backlog = max_backlog_ce(pi);
 	priv->disable = disable_ce(pi);
 
 	pr_debug("%s: db='%s' table='%s' timer=%d max-backlog=%d\n", pi->id,
@@ -694,8 +752,8 @@ sqlite3_start(struct ulogd_pluginstance 
 		return 0;
 	}
 
-	priv->num_rows = priv->max_rows = 0;
-	TAILQ_INIT(&priv->rows);
+	priv->num_rows = 0;
+	INIT_LLIST_HEAD(&priv->rows);
 
 	if (db_start(pi) < 0)
 		return -1;

-- 
