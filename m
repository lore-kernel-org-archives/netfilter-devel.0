From: heitzenberger@astaro.com
Subject: [ULOGD RFC 20/30] SQLITE3: generalize error handling
Date: Wed, 30 Jan 2008 19:59:07 +0100
Message-ID: <20080130190129.038717227@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-82.dex002.intermedia.net ([64.78.20.215]:38024 "EHLO
	dhost002-82.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755796AbYA3TBp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:45 -0500
Content-Disposition: inline; filename=ulogd-SQLITE3-handle-errors-correctly.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add db_err() error handling function and place it where necessary.

The patch looks large than necessary because of some code
reorganization.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/output/sqlite3/ulogd_output_SQLITE3.c
===================================================================
--- ulogd-netfilter.orig/output/sqlite3/ulogd_output_SQLITE3.c
+++ ulogd-netfilter/output/sqlite3/ulogd_output_SQLITE3.c
@@ -167,9 +167,9 @@ row_new(void)
 static inline void
 __row_del(struct sqlite3_priv *priv, struct row *row)
 {
-	free(row);
+	assert(row != NULL);
 
-	priv->num_rows--;
+	free(row);
 }
 
 
@@ -179,15 +179,17 @@ row_del(struct sqlite3_priv *priv, struc
 	llist_del(&row->link);
 
 	__row_del(priv, row);
+
+	priv->num_rows--;
 }
 
 
 static int
 row_add(struct sqlite3_priv *priv, struct row *row)
 {
-	if (priv->max_backlog && priv->num_rows > priv->max_backlog) {
+	if (priv->max_backlog && priv->num_rows >= priv->max_backlog) {
 		if (!priv->overlimit_msg) {
-			ulogd_error(PFX "over max-backlog limit, dropping row\n");
+			ulogd_error(PFX "over max-backlog limit, dropping rows\n");
 
 			priv->overlimit_msg = 1;
 		}
@@ -436,107 +438,118 @@ db_start(struct ulogd_pluginstance *pi)
 	return 0;
 }
 
-
+/* db_err() - handle database errors */
 static int
-db_add_row(struct ulogd_pluginstance *pi, const struct row *row)
+db_err(struct ulogd_pluginstance *pi, int ret)
 {
 	struct sqlite3_priv *priv = (void *)pi->private;
-	int db_col = 1, ret = 0, db_ret;
 
-	db_ret = sqlite3_bind_int64(priv->p_stmt, db_col++, row->ip_saddr);
-	if (db_ret != SQLITE_OK)
-		goto err_bind;
-
-	db_ret = sqlite3_bind_int64(priv->p_stmt, db_col++, row->ip_daddr);
-	if (db_ret != SQLITE_OK)
-		goto err_bind;
-
-	db_ret = sqlite3_bind_int(priv->p_stmt, db_col++, row->ip_proto);
-	if (db_ret != SQLITE_OK)
-		goto err_bind;
-
-	db_ret = sqlite3_bind_int(priv->p_stmt, db_col++, row->l4_dport);
-	if (db_ret != SQLITE_OK)
-		goto err_bind;
-
-	db_ret = sqlite3_bind_int(priv->p_stmt, db_col++, row->raw_in_pktlen);
-	if (db_ret != SQLITE_OK)
-		goto err_bind;
-
-	db_ret = sqlite3_bind_int64(priv->p_stmt, db_col++, row->raw_in_pktcount);
-	if (db_ret != SQLITE_OK)
-		goto err_bind;
-
-	db_ret = sqlite3_bind_int(priv->p_stmt, db_col++, row->raw_out_pktlen);
-	if (db_ret != SQLITE_OK)
-		goto err_bind;
-
-	db_ret = sqlite3_bind_int64(priv->p_stmt, db_col++, row->raw_out_pktcount);
-	if (db_ret != SQLITE_OK)
-		goto err_bind;
-
-	db_ret = sqlite3_bind_int(priv->p_stmt, db_col++, row->flow_start_sec);
-	if (db_ret != SQLITE_OK)
-		goto err_bind;
-
-	db_ret = sqlite3_bind_int(priv->p_stmt, db_col++, row->flow_duration);
-	if (db_ret != SQLITE_OK)
-		goto err_bind;
-
-	db_ret = sqlite3_step(priv->p_stmt);
-
-	if (db_ret == SQLITE_DONE) {
-		/* the SQLITE book doesn't say that expclicitely _but_ between
-		   two sqlite_bind_*() calls to the same variable you need to
-		   call sqlite3_reset(). */
-		sqlite3_reset(priv->p_stmt);
+	pr_debug("%s: ret=%d (errcode %d)\n", __func__, ret,
+			 sqlite3_errcode(priv->dbh));
 
-		return 0;
-	}
+	assert(ret != SQLITE_OK && ret != SQLITE_DONE);
 
-	/* Ok, this is a bit confusing: some errors are reported as return
-	   values, most others are reported through sqlite3_errcode() instead.
-	   I think the only authorative source of information is the sqlite
-	   source code.	*/
-	switch (sqlite3_errcode(priv->dbh)) {
-	case SQLITE_LOCKED:
-	case SQLITE_BUSY:
+	if (ret == SQLITE_BUSY || ret == SQLITE_LOCKED)
 		set_commit_time(pi);
-		break;
+	else {
+		switch (sqlite3_errcode(priv->dbh)) {
+		case SQLITE_LOCKED:
+		case SQLITE_BUSY:
+			set_commit_time(pi);
+			break;
 
-	case SQLITE_SCHEMA:
-		if (priv->stmt) {
-			sqlite3_finalize(priv->p_stmt);
+		case SQLITE_SCHEMA:
+			if (priv->stmt) {
+				sqlite3_finalize(priv->p_stmt);
 
-			db_createstmt(pi);
-		}
-		return -1;
+				db_createstmt(pi);
 
-	case SQLITE_ERROR: /* e.g. constraint violation */
-	case SQLITE_MISUSE:
-		ulogd_error(PFX "step: %s\n", sqlite3_errmsg(priv->dbh));
-		ret = -1;
-		break;
+				ulogd_log(ULOGD_INFO, "%s: database schema changed\n",
+						  pi->id);
+			}
+			break;
 
-	default:
-		break;
+		default:
+			ulogd_error("%s: transaction: %s\n", pi->id,
+						sqlite3_errmsg(priv->dbh));
+			break;
+		}
 	}
 
-	sqlite3_reset(priv->p_stmt);
+	sqlite3_exec(priv->dbh, "rollback", NULL, NULL, NULL);
 
-	return ret;
+	/* no sqlit3_clear_bindings(), as an unbind will be done implicitely
+	   on next bind. */
+	if (priv->p_stmt != NULL)
+		sqlite3_reset(priv->p_stmt);
 
- err_bind:
-	ulogd_error(PFX "bind: %s\n", sqlite3_errmsg(priv->dbh));
+	return 0;
+}
 
-	sqlite3_reset(priv->p_stmt);
+static int
+db_add_row(struct ulogd_pluginstance *pi, const struct row *row)
+{
+	struct sqlite3_priv *priv = (void *)pi->private;
+	int db_col = 1, ret;
 
-	return -1;
-}
+	do {
+		ret = sqlite3_bind_int64(priv->p_stmt, db_col++, row->ip_saddr);
+		if (ret != SQLITE_OK)
+			break;
+
+		ret = sqlite3_bind_int64(priv->p_stmt, db_col++, row->ip_daddr);
+		if (ret != SQLITE_OK)
+			break;
+
+		ret = sqlite3_bind_int(priv->p_stmt, db_col++, row->ip_proto);
+		if (ret != SQLITE_OK)
+			break;
+
+		ret = sqlite3_bind_int(priv->p_stmt, db_col++, row->l4_dport);
+		if (ret != SQLITE_OK)
+			break;
+
+		ret = sqlite3_bind_int(priv->p_stmt, db_col++, row->raw_in_pktlen);
+		if (ret != SQLITE_OK)
+			break;
+
+		ret = sqlite3_bind_int64(priv->p_stmt, db_col++, row->raw_in_pktcount);
+		if (ret != SQLITE_OK)
+			break;
+
+		ret = sqlite3_bind_int(priv->p_stmt, db_col++, row->raw_out_pktlen);
+		if (ret != SQLITE_OK)
+			break;
+
+		ret = sqlite3_bind_int64(priv->p_stmt, db_col++,
+								 row->raw_out_pktcount);
+		if (ret != SQLITE_OK)
+			break;
+
+		ret = sqlite3_bind_int(priv->p_stmt, db_col++, row->flow_start_sec);
+		if (ret != SQLITE_OK)
+			break;
+
+		ret = sqlite3_bind_int(priv->p_stmt, db_col++, row->flow_duration);
+		if (ret != SQLITE_OK)
+			break;
 
-#define llist_for_each_prev_safe(pos, n, head) \
-    for (pos = (head)->prev, n = pos->prev; pos != (head); \
-        pos = n, n = pos->prev)
+		if ((ret = sqlite3_step(priv->p_stmt)) == SQLITE_DONE) {
+			/* no sqlite3_clear_bindings(), as an unbind will be
+			   implicetely done before next bind. */
+			sqlite3_reset(priv->p_stmt);
+
+			return 0;
+		}
+
+		/* according to the documentation sqlite3_step() always returns a
+		   generic SQLITE_ERROR.  In order to find out the cause of the
+		   error you have to call sqlite3_reset() or sqlite3_finalize(). */
+		ret = sqlite3_reset(priv->p_stmt);
+	} while (0);
+
+	return db_err(pi, ret);
+}
 
 /* delete_rows() - delete rows from the tail of the list */
 static int
@@ -574,23 +587,8 @@ db_commit_rows(struct ulogd_pluginstance
 
 	ret = sqlite3_exec(priv->dbh, "begin immediate transaction", NULL,
 					   NULL, NULL);
-	if (ret != SQLITE_OK) {
-		if (ret == SQLITE_BUSY) {
-			set_commit_time(pi);
-			goto err_rollback;
-		}
-
-		if (sqlite3_errcode(priv->dbh) == SQLITE_LOCKED) {
-			set_commit_time(pi);
-			return 0;			/* perform commit later */
-		}
-	
-		ulogd_error("%s: begin transaction: %s\n", pi->id,
-					sqlite3_errmsg(priv->dbh));
-
-		return -1;
-	}
-
+	if (ret != SQLITE_OK)
+		return db_err(pi, ret);
 
 	/* Limit number of rows to commit.  Note that currently three times
 	   buffer_size is a bit arbitrary and therefore might be adjusted in
@@ -602,33 +600,26 @@ db_commit_rows(struct ulogd_pluginstance
 			break;
 
 		if (db_add_row(pi, row) < 0)
-			goto err_rollback;
+			return db_err(pi, ret);
 	}
 
 	ret = sqlite3_exec(priv->dbh, "commit", NULL, NULL, NULL);
-	if (ret == SQLITE_OK) {
-		sqlite3_reset(priv->p_stmt);
-
-		pr_debug("%s: commited %d/%d rows\n", pi->id, rows, priv->num_rows);
-
-		delete_rows(pi, rows);
+	if (ret != SQLITE_OK)
+		return db_err(pi, ret);
 
-		if (priv->commit_time >= t_now)
-			priv->commit_time = 0;		/* release commit lock */
-
-		if (priv->overlimit_msg)
-			priv->overlimit_msg = 0;
-
-		return rows;
-	}
-
- err_rollback:
-	if (sqlite3_errcode(priv->dbh) == SQLITE_LOCKED)
-		return 0;
+	sqlite3_reset(priv->p_stmt);
+	
+	pr_debug("%s: commited %d/%d rows\n", pi->id, rows, priv->num_rows);
 
-	sqlite3_exec(priv->dbh, "rollback", NULL, NULL, NULL);
+	delete_rows(pi, rows);
+	
+	if (priv->commit_time >= t_now)
+		priv->commit_time = 0;		/* release commit lock */
+	
+	if (priv->overlimit_msg)
+		priv->overlimit_msg = 0;
 
-	return -1;
+	return rows;
 }
 
 

-- 
