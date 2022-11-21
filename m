Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C72FC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 22:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiKUW6t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiKUW6r (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 17:58:47 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1828B63161
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 14:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cto7D/kz9OBABIM7Q7cXes7I00RMKmMJnlWa89XHv3A=; b=l6MkG4E1W34FHuuSoXNbBF8n+s
        NclovqUNURUxlJncmwPDlr1Iieg8jAcJMZqbsaDUgOz2oFGJVpVmtqT2Te08rkhFBXTtQ4k4Vrzjk
        Nxd8dsCbJ+qc+v1DvfTrAb/w4kAbXAdQArhbr2+vLvK4j1iiF2gms0esfNKORDKgGrx12L3VLspl0
        J0uBNXHEde3DRyNcjn6SAK4UpwrG/JNOMepIYkDxSTVSHHzxQ92w8k6XDXZ4CTekB2ewFhS3GOxgW
        Of+ijK4exBmeBSSw6a/jav63jNVWSl5QiqP0XJNHsQUvkeuphz2L29R0kFXTAoA1R1RrHNEq2vhjm
        DP17nGaQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxFGE-005LgP-U8
        for netfilter-devel@vger.kernel.org; Mon, 21 Nov 2022 22:27:31 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 24/34] db: use `struct db_stmt` objects more widely
Date:   Mon, 21 Nov 2022 22:26:01 +0000
Message-Id: <20221121222611.3914559-25-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221121222611.3914559-1-jeremy@azazel.net>
References: <20221121222611.3914559-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The back-log API uses a struct to encapsulate SQL statements.  Elsewhere
we pass pairs of string & length arguments.  Extend `struct db_stmt` and
reuse where it is useful.

Change references to "queries" to "statements" (we don't run any queries).

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/ulogd/db.h                |  18 ++-
 output/dbi/ulogd_output_DBI.c     |   6 +-
 output/mysql/ulogd_output_MYSQL.c |   4 +-
 output/pgsql/ulogd_output_PGSQL.c |   4 +-
 util/db.c                         | 185 +++++++++++++++---------------
 5 files changed, 110 insertions(+), 107 deletions(-)

diff --git a/include/ulogd/db.h b/include/ulogd/db.h
index fc3b15ef0e0f..6c2e3d07f463 100644
--- a/include/ulogd/db.h
+++ b/include/ulogd/db.h
@@ -11,6 +11,8 @@
 
 #include <ulogd/ulogd.h>
 
+struct db_stmt;
+
 struct db_driver {
 
 	int (*get_columns)(struct ulogd_pluginstance *upi);
@@ -23,13 +25,14 @@ struct db_driver {
 	int (*escape_string)(struct ulogd_pluginstance *upi,
 			     char *dst, const char *src, unsigned int len);
 	int (*execute)(struct ulogd_pluginstance *upi,
-			const char *stmt, unsigned int len);
+		       const struct db_stmt *stmt);
 
 };
 
 struct db_stmt_ring {
 
-	char *elems; /* Buffer containing `size` strings of `length` bytes */
+	struct db_stmt *elems; /* Buffer containing `size` statements of
+				* `length` bytes */
 
 	uint32_t size; /* No. of elements in ring buffer */
 	uint32_t used; /* No. of elements in ring buffer in use */
@@ -58,14 +61,17 @@ struct db_stmt_backlog {
 };
 
 struct db_stmt {
-	char *stmt;
-	int len;
+	unsigned int len, size;
+	char sql[];
+};
+
+struct db_stmt_item {
 	struct llist_head list;
+	struct db_stmt stmt;
 };
 
 struct db_instance {
-	char *stmt; /* buffer for our insert statement */
-	int stmt_offset; /* offset to the beginning of the "VALUES" part */
+	struct db_stmt *stmt; /* buffer for our insert statement */
 	char *schema;
 	time_t reconnect;
 	int (*interp)(struct ulogd_pluginstance *upi);
diff --git a/output/dbi/ulogd_output_DBI.c b/output/dbi/ulogd_output_DBI.c
index 3b8d8c325131..49c2d45cc992 100644
--- a/output/dbi/ulogd_output_DBI.c
+++ b/output/dbi/ulogd_output_DBI.c
@@ -239,18 +239,18 @@ static int escape_string_dbi(struct ulogd_pluginstance *upi,
 }
 
 static int execute_dbi(struct ulogd_pluginstance *upi,
-			 const char *stmt, unsigned int len)
+		       const struct db_stmt *stmt)
 {
 	struct dbi_instance *pi = (struct dbi_instance *) upi->private;
 
-	pi->result = dbi_conn_query(pi->dbh,stmt);
+	pi->result = dbi_conn_query(pi->dbh, stmt->sql);
 	if (!pi->result) {
 		const char *errptr;
 		dbi_conn_error(pi->dbh, &errptr);
 		ulogd_log(ULOGD_ERROR, "execute failed (%s)\n",
 			  errptr);
 		ulogd_log(ULOGD_DEBUG, "failed query: [%s]\n",
-			  stmt);
+			  stmt->sql);
 		return -1;
 	}
 
diff --git a/output/mysql/ulogd_output_MYSQL.c b/output/mysql/ulogd_output_MYSQL.c
index 55059f5c189e..bed1d7488019 100644
--- a/output/mysql/ulogd_output_MYSQL.c
+++ b/output/mysql/ulogd_output_MYSQL.c
@@ -206,13 +206,13 @@ static int escape_string_mysql(struct ulogd_pluginstance *upi,
 }
 
 static int execute_mysql(struct ulogd_pluginstance *upi,
-			 const char *stmt, unsigned int len)
+			 const struct db_stmt *stmt)
 {
 	struct mysql_instance *mi = (struct mysql_instance *) upi->private;
 	int ret;
 	MYSQL_RES * result;
 
-	ret = mysql_real_query(mi->dbh, stmt, len);
+	ret = mysql_real_query(mi->dbh, stmt->sql, stmt->len);
 	if (ret) {
 		ulogd_log(ULOGD_ERROR, "execute failed (%s)\n",
 			  mysql_error(mi->dbh));
diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index 70a4d48459ff..9dfef7946775 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -283,11 +283,11 @@ static int escape_string_pgsql(struct ulogd_pluginstance *upi,
 }
 
 static int execute_pgsql(struct ulogd_pluginstance *upi,
-			 const char *stmt, unsigned int len)
+			 const struct db_stmt *stmt)
 {
 	struct pgsql_instance *pi = (struct pgsql_instance *) upi->private;
 
-	pi->pgres = PQexec(pi->dbh, stmt);
+	pi->pgres = PQexec(pi->dbh, stmt->sql);
 	if (!(pi->pgres && ((PQresultStatus(pi->pgres) == PGRES_COMMAND_OK)
 		|| (PQresultStatus(pi->pgres) == PGRES_TUPLES_OK)))) {
 		ulogd_log(ULOGD_ERROR, "execute failed (%s)\n",
diff --git a/util/db.c b/util/db.c
index 89c81d8d1dc5..487eaed26153 100644
--- a/util/db.c
+++ b/util/db.c
@@ -54,18 +54,18 @@ static unsigned int _calc_sql_stmt_size(const char *procedure,
 					struct ulogd_key *keys,
 					unsigned int num_keys);
 static void _bind_sql_stmt(struct ulogd_pluginstance *upi,
-			   char *stmt);
+			   struct db_stmt *stmt);
 
 static int _configure_backlog(struct ulogd_pluginstance *upi);
 static int _add_to_backlog(struct ulogd_pluginstance *upi,
-			   const char *stmt, unsigned int len);
+			   const struct db_stmt *stmt);
 static int _process_backlog(struct ulogd_pluginstance *upi);
 
 static int _configure_ring(struct ulogd_pluginstance *upi);
 static int _start_ring(struct ulogd_pluginstance *upi);
 static int _add_to_ring(struct ulogd_pluginstance *upi);
 static void *_process_ring(void *arg);
-static char *_get_ring_elem(struct db_stmt_ring *r, uint32_t i);
+static struct db_stmt *_get_ring_elem(struct db_stmt_ring *r, uint32_t i);
 static void _incr_ring_used(struct db_stmt_ring *r, int incr);
 
 int
@@ -261,7 +261,7 @@ _interp_db_init(struct ulogd_pluginstance *upi)
 		/* store entry to backlog if it is active */
 		if (di->backlog.memcap && !di->backlog.full) {
 			_bind_sql_stmt(upi, di->stmt);
-			_add_to_backlog(upi, di->stmt, strlen(di->stmt));
+			_add_to_backlog(upi, di->stmt);
 		}
 		return ULOGD_IRET_OK;
 	}
@@ -270,7 +270,7 @@ _interp_db_init(struct ulogd_pluginstance *upi)
 		ulogd_log(ULOGD_ERROR, "can't establish database connection\n");
 		if (di->backlog.memcap && !di->backlog.full) {
 			_bind_sql_stmt(upi, di->stmt);
-			_add_to_backlog(upi, di->stmt, strlen(di->stmt));
+			_add_to_backlog(upi, di->stmt);
 		}
 		if (_reconnect_db(upi) < 0)
 			return ULOGD_IRET_ERR;
@@ -301,25 +301,23 @@ _interp_db_main(struct ulogd_pluginstance *upi)
 
 	_bind_sql_stmt(upi, di->stmt);
 
-	/* if backup log is not empty we add current query to it */
+	/* if backup log is not empty we add current statement to it */
 	if (!llist_empty(&di->backlog.items)) {
-		int ret = _add_to_backlog(upi, di->stmt, strlen(di->stmt));
-		if (ret == 0) {
-			if (_process_backlog(upi) < 0)
-				return ULOGD_IRET_ERR;
-			return ULOGD_IRET_OK;
-		}
-		ret = _process_backlog(upi);
-		if (ret < 0)
-			return ULOGD_IRET_ERR;
-		/* try adding once the data to backlog */
-		if (_add_to_backlog(upi, di->stmt, strlen(di->stmt)) < 0)
+		int ret = _add_to_backlog(upi, di->stmt);
+
+		if (_process_backlog(upi) < 0)
 			return ULOGD_IRET_ERR;
-		return ULOGD_IRET_OK;
+
+		/* If the initial attempt to add the new item failed, try again
+		 */
+		if (ret < 0)
+			ret = _add_to_backlog(upi, di->stmt);
+
+		return ret < 0 ? ULOGD_IRET_ERR : ULOGD_IRET_OK;
 	}
 
-	if (di->driver->execute(upi, di->stmt, strlen(di->stmt)) < 0) {
-		_add_to_backlog(upi, di->stmt, strlen(di->stmt));
+	if (di->driver->execute(upi, di->stmt) < 0) {
+		_add_to_backlog(upi, di->stmt);
 		/* error occur, database connexion need to be closed */
 		di->driver->close_db(upi);
 		if (_reconnect_db(upi) < 0)
@@ -402,7 +400,7 @@ _create_sql_stmt(struct ulogd_pluginstance *upi)
 	char *table = table_ce(upi->config_kset).u.string;
 	unsigned int size;
 	unsigned int i;
-	char *stmtp;
+	char *sqlp;
 
 	if (di->stmt)
 		free(di->stmt);
@@ -413,14 +411,14 @@ _create_sql_stmt(struct ulogd_pluginstance *upi)
 
 	ulogd_log(ULOGD_DEBUG, "allocating %u bytes for statement\n", size);
 
-	di->stmt = malloc(size);
+	di->stmt = malloc(sizeof(*di->stmt) + size);
 	if (!di->stmt) {
 		ulogd_log(ULOGD_ERROR, "OOM!\n");
 		return -1;
 	}
-	di->ring.length = size + 1;
+	di->stmt->size = size;
 
-	stmtp = di->stmt;
+	sqlp = di->stmt->sql;
 
 	if (strncasecmp(procedure, "INSERT", sizeof("INSERT") - 1) == 0 &&
 	    (procedure[sizeof("INSERT") - 1] == '\0' ||
@@ -429,13 +427,13 @@ _create_sql_stmt(struct ulogd_pluginstance *upi)
 		if(procedure[sizeof("INSERT") - 1] == '\0') {
 			/* procedure == "INSERT" */
 			if (di->schema)
-				stmtp += sprintf(stmtp, "insert into %s.%s (",
+				sqlp += sprintf(sqlp, "insert into %s.%s (",
 						di->schema, table);
 			else
-				stmtp += sprintf(stmtp, "insert into %s (",
+				sqlp += sprintf(sqlp, "insert into %s (",
 						table);
 		} else
-			stmtp += sprintf(stmtp, "%s (", procedure);
+			sqlp += sprintf(sqlp, "%s (", procedure);
 
 		for (i = 0; i < upi->input.num_keys; i++) {
 			char *underscore;
@@ -443,26 +441,26 @@ _create_sql_stmt(struct ulogd_pluginstance *upi)
 			if (upi->input.keys[i].flags & ULOGD_KEYF_INACTIVE)
 				continue;
 
-			underscore = stmtp;
+			underscore = sqlp;
 
-			stmtp += sprintf(stmtp, "%s,",
+			sqlp += sprintf(sqlp, "%s,",
 					upi->input.keys[i].name);
 
 			while ((underscore = strchr(underscore, '.')))
 				*underscore = '_';
 		}
-		stmtp --;
+		sqlp --;
 
-		stmtp += sprintf(stmtp, ") values (");
+		sqlp += sprintf(sqlp, ") values (");
 
 	} else if (strncasecmp(procedure, "CALL", sizeof("CALL") - 1) == 0)
-		stmtp += sprintf(stmtp, "CALL %s(", procedure);
+		sqlp += sprintf(sqlp, "CALL %s(", procedure);
 	else
-		stmtp += sprintf(stmtp, "SELECT %s(", procedure);
+		sqlp += sprintf(sqlp, "SELECT %s(", procedure);
 
-	di->stmt_offset = stmtp - di->stmt;
+	di->stmt->len = sqlp - di->stmt->sql;
 
-	ulogd_log(ULOGD_DEBUG, "stmt='%s'\n", di->stmt);
+	ulogd_log(ULOGD_DEBUG, "stmt='%s'\n", di->stmt->sql);
 
 	return 0;
 }
@@ -534,14 +532,12 @@ _calc_sql_stmt_size(const char *procedure,
 }
 
 static void
-_bind_sql_stmt(struct ulogd_pluginstance *upi, char *start)
+_bind_sql_stmt(struct ulogd_pluginstance *upi, struct db_stmt *stmt)
 {
 	struct db_instance *di = (struct db_instance *) &upi->private;
-
+	char *sqlp = stmt->sql + stmt->len;
 	unsigned int i;
 
-	char *stmt_ins = start + di->stmt_offset;
-
 	for (i = 0; i < upi->input.num_keys; i++) {
 		struct ulogd_key *res = upi->input.keys[i].u.source;
 
@@ -554,52 +550,54 @@ _bind_sql_stmt(struct ulogd_pluginstance *upi, char *start)
 
 		if (!res || !IS_VALID(*res)) {
 			/* no result, we have to fake something */
-			stmt_ins += sprintf(stmt_ins, "NULL,");
+			sqlp += sprintf(sqlp, "NULL,");
 			continue;
 		}
 
 		switch (res->type) {
 		case ULOGD_RET_INT8:
-			sprintf(stmt_ins, "%d,", res->u.value.i8);
+			sqlp += sprintf(sqlp, "%d,", res->u.value.i8);
 			break;
 		case ULOGD_RET_INT16:
-			sprintf(stmt_ins, "%d,", res->u.value.i16);
+			sqlp += sprintf(sqlp, "%d,", res->u.value.i16);
 			break;
 		case ULOGD_RET_INT32:
-			sprintf(stmt_ins, "%d,", res->u.value.i32);
+			sqlp += sprintf(sqlp, "%d,", res->u.value.i32);
 			break;
 		case ULOGD_RET_INT64:
-			sprintf(stmt_ins, "%" PRId64 ",", res->u.value.i64);
+			sqlp += sprintf(sqlp, "%" PRId64 ",", res->u.value.i64);
 			break;
 		case ULOGD_RET_UINT8:
-			sprintf(stmt_ins, "%u,", res->u.value.ui8);
+			sqlp += sprintf(sqlp, "%u,", res->u.value.ui8);
 			break;
 		case ULOGD_RET_UINT16:
-			sprintf(stmt_ins, "%u,", res->u.value.ui16);
+			sqlp += sprintf(sqlp, "%u,", res->u.value.ui16);
 			break;
 		case ULOGD_RET_IPADDR:
 			/* fallthrough when logging IP as uint32_t */
 		case ULOGD_RET_UINT32:
-			sprintf(stmt_ins, "%u,", res->u.value.ui32);
+			sqlp += sprintf(sqlp, "%u,", res->u.value.ui32);
 			break;
 		case ULOGD_RET_UINT64:
-			sprintf(stmt_ins, "%" PRIu64 ",", res->u.value.ui64);
+			sqlp += sprintf(sqlp, "%" PRIu64 ",",
+					res->u.value.ui64);
 			break;
 		case ULOGD_RET_BOOL:
-			sprintf(stmt_ins, "'%d',", res->u.value.b);
+			sqlp += sprintf(sqlp, "'%d',", res->u.value.b);
 			break;
 		case ULOGD_RET_STRING:
-			*(stmt_ins++) = '\'';
+			*sqlp++ = '\'';
 			if (res->u.value.ptr) {
-				stmt_ins +=
-				di->driver->escape_string(upi, stmt_ins,
-							  res->u.value.ptr,
-							strlen(res->u.value.ptr));
+				char *str = res->u.value.ptr;
+				size_t len = strlen(str);
+
+				sqlp += di->driver->escape_string(upi, sqlp,
+								  str, len);
 			}
-			sprintf(stmt_ins, "',");
+			sqlp += sprintf(sqlp, "',");
 			break;
 		case ULOGD_RET_RAWSTR:
-			sprintf(stmt_ins, "%s,", (char *) res->u.value.ptr);
+			sqlp += sprintf(sqlp, "%s,", (char *) res->u.value.ptr);
 			break;
 		case ULOGD_RET_RAW:
 			ulogd_log(ULOGD_NOTICE,
@@ -611,9 +609,10 @@ _bind_sql_stmt(struct ulogd_pluginstance *upi, char *start)
 				res->type, upi->input.keys[i].name);
 			break;
 		}
-		stmt_ins = start + strlen(start);
 	}
-	*(stmt_ins - 1) = ')';
+	*(sqlp - 1) = ')';
+
+	stmt->len = sqlp - stmt->sql;
 }
 
 /******************************************************************************/
@@ -650,21 +649,20 @@ _configure_backlog(struct ulogd_pluginstance *upi)
 }
 
 static int
-_add_to_backlog(struct ulogd_pluginstance *upi,
-		const char *stmt, unsigned int len)
+_add_to_backlog(struct ulogd_pluginstance *upi, const struct db_stmt *stmt)
 {
 	struct db_instance *di = (struct db_instance *) &upi->private;
-	unsigned int query_size;
-	struct db_stmt *query;
+	struct db_stmt_item *item;
+	unsigned int item_size;
 
 	/* check if we are using backlog */
 	if (di->backlog.memcap == 0)
 		return 0;
 
-	query_size = sizeof(*query) + len + 1;
+	item_size = sizeof(*item) + stmt->size;
 
 	/* check len against backlog */
-	if (query_size + di->backlog.memcap - di->backlog.memusage) {
+	if (item_size + di->backlog.memusage > di->backlog.memcap) {
 		if (!di->backlog.full)
 			ulogd_log(ULOGD_ERROR,
 				  "Backlog is full starting to reject events.\n");
@@ -672,23 +670,16 @@ _add_to_backlog(struct ulogd_pluginstance *upi,
 		return -1;
 	}
 
-	query = malloc(sizeof(*query));
-	if (query == NULL)
+	item = malloc(item_size);
+	if (item == NULL)
 		return -1;
 
-	query->stmt = strndup(stmt, len);
-	query->len = len;
-
-	if (query->stmt == NULL) {
-		free(query);
-		return -1;
-	}
+	memcpy(&item->stmt, stmt, sizeof(*stmt) + stmt->size);
+	llist_add_tail(&item->list, &di->backlog.items);
 
-	di->backlog.memusage += query_size;
+	di->backlog.memusage += item_size;
 	di->backlog.full = 0;
 
-	llist_add_tail(&query->list, &di->backlog.items);
-
 	return 0;
 }
 
@@ -696,27 +687,28 @@ static int
 _process_backlog(struct ulogd_pluginstance *upi)
 {
 	struct db_instance *di = (struct db_instance *) &upi->private;
+	struct db_stmt_item *item, *nitem;
 	int i = di->backlog.oneshot;
-	struct db_stmt *query;
-	struct db_stmt *nquery;
 
 	/* Don't try reconnect before timeout */
 	if (di->reconnect && di->reconnect > time(NULL))
 		return 0;
 
-	llist_for_each_entry_safe(query, nquery, &di->backlog.items, list) {
-		if (di->driver->execute(upi, query->stmt, query->len) < 0) {
+	llist_for_each_entry_safe(item, nitem, &di->backlog.items, list) {
+
+		if (di->driver->execute(upi, &item->stmt) < 0) {
 			/* error occur, database connexion need to be closed */
 			di->driver->close_db(upi);
 			return _reconnect_db(upi);
-		} else {
-			di->backlog.memusage -= sizeof(*query) + query->len + 1;
-			llist_del(&query->list);
-			free(query->stmt);
-			free(query);
 		}
+
+		di->backlog.memusage -= sizeof(*item) + item->stmt.size;
+		llist_del(&item->list);
+		free(item);
+
 		if (--i < 0)
 			break;
+
 	}
 	return 0;
 }
@@ -737,6 +729,7 @@ static int
 _start_ring(struct ulogd_pluginstance *upi)
 {
 	struct db_instance *di = (struct db_instance *) &upi->private;
+	size_t stmt_size, stmt_align;
 	unsigned int i;
 	int ret;
 
@@ -744,6 +737,11 @@ _start_ring(struct ulogd_pluginstance *upi)
 		return 0;
 
 	/* allocate */
+	stmt_size = sizeof(*di->stmt) + di->stmt->size;
+	stmt_align = __alignof__(*di->stmt);
+	di->ring.length = stmt_size % stmt_align != 0
+		? (1 + stmt_size / stmt_align) * stmt_align
+		: stmt_size;
 	di->ring.elems = calloc(di->ring.size, di->ring.length);
 	if (di->ring.elems == NULL)
 		return -1;
@@ -752,9 +750,9 @@ _start_ring(struct ulogd_pluginstance *upi)
 		  "Allocating %" PRIu32 " elements of size %" PRIu32 " for ring\n",
 		  di->ring.size, di->ring.length);
 
-	/* init start of query for each element */
+	/* init start of statement for each element */
 	for(i = 0; i < di->ring.size; i++)
-		strcpy(_get_ring_elem(&di->ring, i), di->stmt);
+		memcpy(_get_ring_elem(&di->ring, i), di->stmt, stmt_size);
 
 	/* init cond & mutex */
 	ret = pthread_cond_init(&di->ring.cond, NULL);
@@ -817,15 +815,14 @@ _process_ring(void *arg)
 		/* wait cond */
 		pthread_cond_wait(&di->ring.cond, &di->ring.mutex);
 		while (di->ring.used > 0) {
-			char *stmt = _get_ring_elem(&di->ring, di->ring.rd_idx);
-
-			if (di->driver->execute(upi, stmt,
-						strlen(stmt)) < 0) {
+			struct db_stmt *stmt = _get_ring_elem(&di->ring,
+							      di->ring.rd_idx);
 
+			if (di->driver->execute(upi, stmt) < 0) {
 				di->driver->close_db(upi);
 				while (di->driver->open_db(upi) < 0)
 					sleep(1);
-				/* try to re run query */
+				/* try to re-run statement */
 				continue;
 			}
 
@@ -836,10 +833,10 @@ _process_ring(void *arg)
 	return NULL;
 }
 
-static char *
+static struct db_stmt *
 _get_ring_elem(struct db_stmt_ring *r, uint32_t i)
 {
-	return &r->elems[i * r->length];
+	return (struct db_stmt *) ((char *) r->elems + i * r->length);
 }
 
 static void
-- 
2.35.1

