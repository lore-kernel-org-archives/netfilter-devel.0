Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BADCC4321E
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 21:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236832AbiK2V6f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236878AbiK2V6H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 16:58:07 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7603E6F0DB
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 13:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PRC9sPZ4tjSXbj/2CW+2Nsda82MgOy9B7fiG7SssA1U=; b=JVuvDQPDlIGJQmF5hMJkQcpqSa
        JPMvCShILvsfH1j2pVgcevSPWS2CMOndxKEb1lZbo+Y4SGSxpsrGGpmUfRLGg/bwcghLBGNFg+Onn
        Avo/at2K6ZN4ppWlbNIj9uhtTON4WGpJ2GOeeUSLz8u/t1/YvD7aeohEEbDDxhMHb7wHUhEhQPD4I
        W786cXBJqpDZJaj+bCu2Mta4NzeBtXuV1eqNenKxlaH4Rnqj5JJV7eTFzUr2xEFAmFqu7AgOfSACX
        dNkt/zou1PBC28cY/aY2G0SptQu94RXWim0GoByJ7RjwQS4lCWf7aLD+k8AJcO8O4BVUzoPkCwSnO
        IOWfXFWg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p08SM-00DjQp-U4
        for netfilter-devel@vger.kernel.org; Tue, 29 Nov 2022 21:47:59 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v2 v2 34/34] output: sqlite3: reimplement using the common DB API
Date:   Tue, 29 Nov 2022 21:47:49 +0000
Message-Id: <20221129214749.247878-35-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221129214749.247878-1-jeremy@azazel.net>
References: <20221129214749.247878-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SQLite doesn't have support for escaping strings to embed them in SQL
statements.  Therefore, the sqlite3 plug-in has not used the `util_db`
API.  Now that the common API supports prep & exec, convert the sqlite3
plug-in to use it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/sqlite3/ulogd_output_SQLITE3.c | 459 +++++++++-----------------
 1 file changed, 150 insertions(+), 309 deletions(-)

diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_output_SQLITE3.c
index 32459dd6c4c5..2875c504d20e 100644
--- a/output/sqlite3/ulogd_output_SQLITE3.c
+++ b/output/sqlite3/ulogd_output_SQLITE3.c
@@ -30,392 +30,232 @@
  *  	- port to ulogd-2.00
  */
 
+#ifdef DEBUG_SQLITE3
+#include <stdio.h>
+#endif
 #include <stdlib.h>
 #include <string.h>
-#include <arpa/inet.h>
+#include <sqlite3.h>
 #include <ulogd/ulogd.h>
 #include <ulogd/conffile.h>
-#include <sqlite3.h>
-#include <sys/queue.h>
+#include <ulogd/db.h>
 
-#define CFG_BUFFER_DEFAULT		10
-
-#if 0
+#ifdef DEBUG_SQLITE3
 #define DEBUGP(x, args...)	fprintf(stderr, x, ## args)
 #else
 #define DEBUGP(x, args...)
 #endif
 
-struct field {
-	TAILQ_ENTRY(field) link;
-	char name[ULOGD_MAX_KEYLEN + 1];
-	struct ulogd_key *key;
-};
-
-TAILQ_HEAD(field_lh, field);
-
-#define tailq_for_each(pos, head, link) \
-        for (pos = (head).tqh_first; pos != NULL; pos = pos->link.tqe_next)
-
+#define SQLITE3_BUSY_TIMEOUT 300
 
-struct sqlite3_priv {
+struct sqlite3_instance {
+	struct db_instance db_inst;
 	sqlite3 *dbh;				/* database handle we are using */
-	struct field_lh fields;
-	char *stmt;
 	sqlite3_stmt *p_stmt;
-	struct {
-		unsigned err_tbl_busy;	/* "Table busy" */
-	} stats;
 };
 
-static struct config_keyset sqlite3_kset = {
-	.num_ces = 3,
+static struct config_keyset kset_sqlite3 = {
+	.num_ces = DB_CE_NUM + 1,
 	.ces = {
+		DB_CES,
 		{
 			.key = "db",
 			.type = CONFIG_TYPE_STRING,
 			.options = CONFIG_OPT_MANDATORY,
 		},
-		{
-			.key = "table",
-			.type = CONFIG_TYPE_STRING,
-			.options = CONFIG_OPT_MANDATORY,
-		},
 	},
 };
 
-#define db_ce(pi)		(pi)->config_kset->ces[0].u.string
-#define table_ce(pi)	(pi)->config_kset->ces[1].u.string
-
-/* forward declarations */
-static int sqlite3_createstmt(struct ulogd_pluginstance *);
+#define db_ce(x) ((x)->ces[DB_CE_NUM + 0])
 
+#define SELECT_ALL_FROM "select * from "
 
 static int
-add_row(struct ulogd_pluginstance *pi)
+get_columns_sqlite3(struct ulogd_pluginstance *upi)
 {
-	struct sqlite3_priv *priv = (void *)pi->private;
-	int ret;
-
-	ret = sqlite3_step(priv->p_stmt);
-	if (ret == SQLITE_BUSY)
-		priv->stats.err_tbl_busy++;
-	else if (ret == SQLITE_ERROR) {
-		ret = sqlite3_finalize(priv->p_stmt);
-		priv->p_stmt = NULL;
-
-		if (ret != SQLITE_SCHEMA) {
-			ulogd_log(ULOGD_ERROR, "SQLITE3: step: %s\n",
-				  sqlite3_errmsg(priv->dbh));
-			goto err_reset;
-		}
-		if (sqlite3_createstmt(pi) < 0) {
-			ulogd_log(ULOGD_ERROR,
-				  "SQLITE3: Could not create statement.\n");
-			goto err_reset;
-		}
-	}
+	struct sqlite3_instance *si = (struct sqlite3_instance *) upi->private;
+	char query[sizeof(SELECT_ALL_FROM) + CONFIG_VAL_STRING_LEN];
+	sqlite3_stmt *stmt;
+	int rv;
 
-	ret = sqlite3_reset(priv->p_stmt);
+	snprintf(query, sizeof(query), SELECT_ALL_FROM "%s",
+		 table_ce(upi->config_kset).u.string);
 
-	return 0;
+	if (sqlite3_prepare_v2(si->dbh, query, -1, &stmt, NULL) != SQLITE_OK) {
+		ulogd_log(ULOGD_ERROR, "%s: prepare failed: %s\n",
+			  __func__, sqlite3_errmsg(si->dbh));
+		return -1;
+	}
 
- err_reset:
-	sqlite3_reset(priv->p_stmt);
+	rv = ulogd_db_alloc_input_keys(upi, sqlite3_column_count(stmt), stmt);
 
-	return -1;
+	sqlite3_finalize(stmt);
+	return rv;
 }
 
-
-/* our main output function, called by ulogd */
-static int
-sqlite3_interp(struct ulogd_pluginstance *pi)
+static const char *
+get_column_sqlite3(void *vp, unsigned int i)
 {
-	struct sqlite3_priv *priv = (void *)pi->private;
-	struct field *f;
-	int ret, i = 1;
-
-	tailq_for_each(f, priv->fields, link) {
-		struct ulogd_key *k_ret = f->key->u.source;
-
-		if (f->key == NULL || !IS_VALID(*k_ret)) {
-			sqlite3_bind_null(priv->p_stmt, i);
-			i++;
-			continue;
-		}
-
-		switch (f->key->type) {
-		case ULOGD_RET_INT8:
-			ret = sqlite3_bind_int(priv->p_stmt, i, k_ret->u.value.i8);
-			break;
-
-		case ULOGD_RET_INT16:
-			ret = sqlite3_bind_int(priv->p_stmt, i, k_ret->u.value.i16);
-			break;
-
-		case ULOGD_RET_INT32:
-			ret = sqlite3_bind_int(priv->p_stmt, i, k_ret->u.value.i32);
-			break;
-
-		case ULOGD_RET_INT64:
-			ret = sqlite3_bind_int(priv->p_stmt, i, k_ret->u.value.i64);
-			break;
+	sqlite3_stmt *schema_stmt = vp;
 
-		case ULOGD_RET_UINT8:
-			ret = sqlite3_bind_int(priv->p_stmt, i, k_ret->u.value.ui8);
-			break;
-
-		case ULOGD_RET_UINT16:
-			ret = sqlite3_bind_int(priv->p_stmt, i, k_ret->u.value.ui16);
-			break;
-
-		case ULOGD_RET_UINT32:
-			ret = sqlite3_bind_int(priv->p_stmt, i, k_ret->u.value.ui32);
-			break;
-
-		case ULOGD_RET_IPADDR:
-		case ULOGD_RET_UINT64:
-			ret = sqlite3_bind_int64(priv->p_stmt, i, k_ret->u.value.ui64);
-			break;
-
-		case ULOGD_RET_BOOL:
-			ret = sqlite3_bind_int(priv->p_stmt, i, k_ret->u.value.b);
-			break;
-
-		case ULOGD_RET_STRING:
-			ret = sqlite3_bind_text(priv->p_stmt, i, k_ret->u.value.ptr,
-									strlen(k_ret->u.value.ptr), SQLITE_STATIC);
-			break;
-
-		default:
-			ret = SQLITE_OK;
-			ulogd_log(ULOGD_NOTICE, "unknown type %d for %s\n",
-					  f->key->type, f->key->name);
-		}
-		if (ret != SQLITE_OK)
-			goto err_bind;
-
-		i++;
-	}
-
-	if (add_row(pi) < 0)
-		return ULOGD_IRET_ERR;
-
-	return ULOGD_IRET_OK;
-
- err_bind:
-	ulogd_log(ULOGD_ERROR, "SQLITE: bind: %s\n", sqlite3_errmsg(priv->dbh));
-
-	return ULOGD_IRET_ERR;
+	return sqlite3_column_name(schema_stmt, i);
 }
 
-#define _SQLITE3_INSERTTEMPL   "insert into X (Y) values (Z)"
-
-/* create the static part of our insert statement */
 static int
-sqlite3_createstmt(struct ulogd_pluginstance *pi)
+open_db_sqlite3(struct ulogd_pluginstance *upi)
 {
-	struct sqlite3_priv *priv = (void *)pi->private;
-	struct field *f;
-	int i, cols = 0;
-	char *stmt_pos;
-
-	if (priv->stmt != NULL)
-		free(priv->stmt);
-
-	if ((priv->stmt = calloc(1, 1024)) == NULL) {
-		ulogd_log(ULOGD_ERROR, "SQLITE3: out of memory\n");
-		return -1;
-	}
-	stmt_pos = priv->stmt;
-
-	stmt_pos += sprintf(stmt_pos, "insert into %s (", table_ce(pi));
-
-	tailq_for_each(f, priv->fields, link) {
-		stmt_pos += sprintf(stmt_pos, "%s,", f->name);
-		cols++;
-	}
-
-	*(stmt_pos - 1) = ')';
-
-	stmt_pos += sprintf(stmt_pos, " values (");
-
-	for (i = 0; i < cols - 1; i++)
-		stmt_pos += sprintf(stmt_pos, "?,");
-
-	sprintf(stmt_pos, "?)");
-	ulogd_log(ULOGD_DEBUG, "%s: stmt='%s'\n", pi->id, priv->stmt);
+	struct sqlite3_instance *si = (struct sqlite3_instance *) upi->private;
 
-	DEBUGP("about to prepare statement.\n");
-
-	sqlite3_prepare(priv->dbh, priv->stmt, -1, &priv->p_stmt, 0);
-	if (priv->p_stmt == NULL) {
-		ulogd_log(ULOGD_ERROR, "SQLITE3: prepare: %s\n",
-			  sqlite3_errmsg(priv->dbh));
+	if (sqlite3_open(db_ce(upi->config_kset).u.string,
+			 &si->dbh) != SQLITE_OK) {
+		ulogd_log(ULOGD_ERROR, "%s: open failed: %s\n",
+			  __func__, sqlite3_errmsg(si->dbh));
 		return -1;
 	}
 
-	DEBUGP("statement prepared.\n");
+	/* Set the timeout so that we don't automatically fail if the table is
+	 * busy.
+	 */
+	sqlite3_busy_timeout(si->dbh, SQLITE3_BUSY_TIMEOUT);
 
 	return 0;
 }
 
-
-static struct ulogd_key *
-ulogd_find_key(struct ulogd_pluginstance *pi, const char *name)
+static int
+close_db_sqlite3(struct ulogd_pluginstance *upi)
 {
-	char buf[ULOGD_MAX_KEYLEN + 1] = "";
-	unsigned int i;
+	struct sqlite3_instance *si = (struct sqlite3_instance *) upi->private;
 
-	/* replace all underscores with dots */
-	for (i = 0; i < sizeof(buf) - 1 && name[i]; ++i)
-		buf[i] = name[i] != '_' ? name[i] : '.';
+	if (si->p_stmt) {
+		sqlite3_finalize(si->p_stmt);
+		si->p_stmt = NULL;
+	}
 
-	for (i = 0; i < pi->input.num_keys; i++) {
-		if (strcmp(pi->input.keys[i].name, buf) == 0)
-			return &pi->input.keys[i];
+	if (si->dbh) {
+		sqlite3_close(si->dbh);
+		si->dbh = NULL;
 	}
 
-	return NULL;
+	return 0;
 }
 
-#define SELECT_ALL_STR			"select * from "
-#define SELECT_ALL_LEN			sizeof(SELECT_ALL_STR)
-
 static int
-db_count_cols(struct ulogd_pluginstance *pi, sqlite3_stmt **stmt)
+prepare_sqlite3(struct ulogd_pluginstance *upi, const struct db_stmt *stmt)
 {
-	struct sqlite3_priv *priv = (void *)pi->private;
-	char query[SELECT_ALL_LEN + CONFIG_VAL_STRING_LEN] = SELECT_ALL_STR;
+	struct sqlite3_instance *si = (struct sqlite3_instance *) upi->private;
 
-	strncat(query, table_ce(pi), sizeof(query) - strlen(query) - 1);
+	if (si->p_stmt) {
+		sqlite3_finalize(si->p_stmt);
+		si->p_stmt = NULL;
+	}
 
-	if (sqlite3_prepare(priv->dbh, query, -1, stmt, 0) != SQLITE_OK)
+	if (sqlite3_prepare_v2(si->dbh, stmt->sql, stmt->len + 1,
+			       &si->p_stmt, NULL) != SQLITE_OK) {
+		ulogd_log(ULOGD_ERROR, "%s: prepare failed: %s\n",
+			  __func__, sqlite3_errmsg(si->dbh));
 		return -1;
+	}
 
-	return sqlite3_column_count(*stmt);
+	return 0;
 }
 
-/* initialize DB, possibly creating it */
 static int
-sqlite3_init_db(struct ulogd_pluginstance *pi)
+execute_sqlite3(struct ulogd_pluginstance *upi, const struct db_stmt *stmt)
 {
-	struct sqlite3_priv *priv = (void *)pi->private;
-	sqlite3_stmt *schema_stmt;
-	int col, num_cols;
-
-	if (priv->dbh == NULL) {
-		ulogd_log(ULOGD_ERROR, "SQLITE3: No database handle.\n");
-		return -1;
-	}
-
-	num_cols = db_count_cols(pi, &schema_stmt);
-	if (num_cols <= 0) {
-		ulogd_log(ULOGD_ERROR, "table `%s' is empty or missing in "
-				       "file `%s'. Did you created this "
-				       "table in the database file? Please, "
-				       "see ulogd2 documentation.\n",
-					table_ce(pi), db_ce(pi));
-		return -1;
-	}
+	struct sqlite3_instance *si = (struct sqlite3_instance *) upi->private;
+	unsigned int i;
+	int rv;
 
-	for (col = 0; col < num_cols; col++) {
-		struct field *f;
+	for (i = 0; i < stmt->nr_params; i++) {
+		struct db_stmt_arg *arg = &stmt->args[i];
+		union db_stmt_arg_value *val = &arg->value;
 
-		/* prepend it to the linked list */
-		if ((f = calloc(1, sizeof(struct field))) == NULL) {
-			ulogd_log(ULOGD_ERROR, "SQLITE3: out of memory\n");
-			return -1;
+		if (arg->null) {
+			sqlite3_bind_null(si->p_stmt, i + 1);
+			continue;
 		}
-		snprintf(f->name, sizeof(f->name),
-			 "%s", sqlite3_column_name(schema_stmt, col));
-
-		DEBUGP("field '%s' found\n", f->name);
 
-		if ((f->key = ulogd_find_key(pi, f->name)) == NULL) {
-			ulogd_log(ULOGD_ERROR,
-				  "SQLITE3: unknown input key: %s\n", f->name);
-			free(f);
-			return -1;
+		switch (arg->type) {
+		case ULOGD_RET_BOOL:
+			rv = sqlite3_bind_int(si->p_stmt, i + 1, val->b);
+			break;
+		case ULOGD_RET_INT8:
+			rv = sqlite3_bind_int(si->p_stmt, i + 1, val->i8);
+			break;
+		case ULOGD_RET_INT16:
+			rv = sqlite3_bind_int(si->p_stmt, i + 1, val->i16);
+			break;
+		case ULOGD_RET_INT32:
+			rv = sqlite3_bind_int(si->p_stmt, i + 1, val->i32);
+			break;
+		case ULOGD_RET_INT64:
+			rv = sqlite3_bind_int(si->p_stmt, i + 1, val->i64);
+			break;
+		case ULOGD_RET_UINT8:
+			rv = sqlite3_bind_int(si->p_stmt, i + 1, val->ui8);
+			break;
+		case ULOGD_RET_UINT16:
+			rv = sqlite3_bind_int(si->p_stmt, i + 1, val->ui16);
+			break;
+		case ULOGD_RET_UINT32:
+			rv = sqlite3_bind_int(si->p_stmt, i + 1, val->ui32);
+			break;
+		case ULOGD_RET_IPADDR:
+		case ULOGD_RET_UINT64:
+			rv = sqlite3_bind_int64(si->p_stmt, i + 1, val->ui64);
+			break;
+		case ULOGD_RET_STRING:
+			rv = sqlite3_bind_text(si->p_stmt, i + 1, val->ptr,
+					       arg->len, SQLITE_STATIC);
+			break;
+		case ULOGD_RET_RAWSTR:
+			rv = sqlite3_bind_blob(si->p_stmt, i + 1, val->ptr,
+					       arg->len, SQLITE_STATIC);
+			break;
 		}
 
-		TAILQ_INSERT_TAIL(&priv->fields, f, link);
+		if (rv != SQLITE_OK) {
+			ulogd_log(ULOGD_ERROR, "%s: bind %u failed: %s\n",
+				  __func__, i + 1, sqlite3_errmsg(si->dbh));
+			rv = -1;
+			goto err_clear_bindings;
+		}
 	}
 
-	sqlite3_finalize(schema_stmt);
-
-	return 0;
-}
+	rv = sqlite3_step(si->p_stmt);
 
-#define SQLITE3_BUSY_TIMEOUT 300
+	if (rv != SQLITE_DONE) {
+		ulogd_log(ULOGD_ERROR, "%s: step failed: %s\n",
+			  __func__, sqlite3_errmsg(si->dbh));
+		rv = -1;
+	} else
+		rv = 0;
 
-static int
-sqlite3_configure(struct ulogd_pluginstance *pi,
-				  struct ulogd_pluginstance_stack *stack)
-{
-	/* struct sqlite_priv *priv = (void *)pi->private; */
+	sqlite3_reset(si->p_stmt);
 
-	config_parse_file(pi->id, pi->config_kset);
+err_clear_bindings:
+	sqlite3_clear_bindings(si->p_stmt);
 
-	if (ulogd_wildcard_inputkeys(pi) < 0)
-		return -1;
-
-	DEBUGP("%s: db='%s' table='%s'\n", pi->id, db_ce(pi), table_ce(pi));
-
-	return 0;
+	return rv;
 }
 
-static int
-sqlite3_start(struct ulogd_pluginstance *pi)
-{
-	struct sqlite3_priv *priv = (void *)pi->private;
-
-	TAILQ_INIT(&priv->fields);
-
-	if (sqlite3_open(db_ce(pi), &priv->dbh) != SQLITE_OK) {
-		ulogd_log(ULOGD_ERROR, "SQLITE3: %s\n", sqlite3_errmsg(priv->dbh));
-		return -1;
-	}
-
-	/* set the timeout so that we don't automatically fail
-	   if the table is busy */
-	sqlite3_busy_timeout(priv->dbh, SQLITE3_BUSY_TIMEOUT);
-
-	/* read the fieldnames to know which values to insert */
-	if (sqlite3_init_db(pi) < 0) {
-		ulogd_log(ULOGD_ERROR, "SQLITE3: Could not read database fieldnames.\n");
-		return -1;
-	}
-
-	/* create and prepare the actual insert statement */
-	if (sqlite3_createstmt(pi) < 0) {
-		ulogd_log(ULOGD_ERROR, "SQLITE3: Could not create statement.\n");
-		return -1;
-	}
-
-	return 0;
-}
+static struct db_driver sqlite3_db_driver = {
+	.get_columns	= get_columns_sqlite3,
+	.get_column	= get_column_sqlite3,
+	.open_db	= open_db_sqlite3,
+	.close_db	= close_db_sqlite3,
+	.prepare	= prepare_sqlite3,
+	.execute	= execute_sqlite3,
+};
 
-/* give us an opportunity to close the database down properly */
 static int
-sqlite3_stop(struct ulogd_pluginstance *pi)
+configure_sqlite3(struct ulogd_pluginstance *upi,
+		  struct ulogd_pluginstance_stack *stack)
 {
-	struct sqlite3_priv *priv = (void *)pi->private;
+	struct db_instance *di = (struct db_instance *) &upi->private;
+	di->driver = &sqlite3_db_driver;
 
-	/* free up our prepared statements so we can close the db */
-	if (priv->p_stmt) {
-		sqlite3_finalize(priv->p_stmt);
-		DEBUGP("prepared statement finalized\n");
-	}
-
-	if (priv->dbh == NULL)
-		return -1;
-
-	sqlite3_close(priv->dbh);
-
-	priv->dbh = NULL;
-
-	return 0;
+	return ulogd_db_configure(upi, stack);
 }
 
 static struct ulogd_plugin sqlite3_plugin = {
@@ -426,12 +266,13 @@ static struct ulogd_plugin sqlite3_plugin = {
 	.output	     = {
 		.type = ULOGD_DTYPE_SINK,
 	},
-	.config_kset = &sqlite3_kset,
-	.priv_size   = sizeof(struct sqlite3_priv),
-	.configure   = sqlite3_configure,
-	.start	     = sqlite3_start,
-	.stop	     = sqlite3_stop,
-	.interp	     = sqlite3_interp,
+	.config_kset = &kset_sqlite3,
+	.priv_size   = sizeof(struct sqlite3_instance),
+	.configure   = configure_sqlite3,
+	.start	     = ulogd_db_start,
+	.stop	     = ulogd_db_stop,
+	.signal	     = ulogd_db_signal,
+	.interp	     = ulogd_db_interp,
 	.version     = VERSION,
 };
 
-- 
2.35.1

