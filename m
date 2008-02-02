From: heitzenberger@astaro.com
Subject: [ULOGD 14/15] SQLITE3: port to ulogd 2.00, mostly a rewrite
Date: Sat, 02 Feb 2008 21:48:40 +0100
Message-ID: <20080202205109.156076629@astaro.com>
References: <20080202204826.267107164@astaro.com>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-47.dex002.intermedia.net ([64.78.21.143]:21876 "EHLO
	dhost002-47.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933784AbYBBUv3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:51:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
Content-Disposition: inline; filename=ulogd-SQLITE3-plugin.diff

NOTE

As described in

 http://www.sqlite.org/cvstrac/wiki?p=CorruptionFollowingBusyError

some versions of SQLITE contain an error when transactions other than
EXCLUSIVE are used.  If a SQL commands to create a transaction or
inside a transaction ever gets SQLITE_BUSY a ROLLBACK has to be done,
as otherwise a corrupt database might be the result.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter-stuffed/output/sqlite3/ulogd_output_SQLITE3.c
===================================================================
--- ulogd-netfilter-stuffed.orig/output/sqlite3/ulogd_output_SQLITE3.c
+++ ulogd-netfilter-stuffed/output/sqlite3/ulogd_output_SQLITE3.c
@@ -1,4 +1,3 @@
-#if 0
 /*
  * ulogd output plugin for logging to a SQLITE database
  *
@@ -26,389 +25,805 @@
  *
  *  2005-02-09 Harald Welte <laforge@gnumonks.org>:
  *  	- port to ulogd-1.20 
+ *
+ *  Holger Eitzenberger <holger@eitzenberger.org>  Astaro AG, 2007
+ *  	- port to ulogd-2.00
  */
 
-#include <stdlib.h>
-#include <string.h>
-#include <arpa/inet.h>
 #include <ulogd/ulogd.h>
 #include <ulogd/conffile.h>
+#include <ulogd/common.h>
+#include <ulogd/linuxlist.h>
+#include <arpa/inet.h>
 #include <sqlite3.h>
 
-#ifdef DEBUG_SQLITE3
-#define DEBUGP(x, args...)	fprintf(stderr, x, ## args)
-#else
-#define DEBUGP(x, args...)
-#endif
+#define PFX		"SQLITE3: "
+
+/* config defaults */
+#define CFG_BUFFER_DEFAULT		100
+#define CFG_TIMER_DEFAULT		1 SEC
+#define CFG_MAX_BACKLOG_DEFAULT	0		/* unlimited */
+
+
+#define SQLITE3_BUSY_TIMEOUT 300
+
+/* number of colums we have (really should be configurable) */
+#define DB_NUM_COLS	10
 
-struct _field {
+
+/* map DB column to ulogd key */
+struct col {
 	char name[ULOGD_MAX_KEYLEN];
-	unsigned int id;
-	struct _field *next;
+	struct ulogd_key *key;
+};
+
+struct row {
+	struct llist_head link;
+	uint32_t ip_saddr;
+	uint32_t ip_daddr;
+	unsigned char ip_proto;
+	unsigned l4_dport;
+	unsigned raw_in_pktlen;
+	unsigned raw_in_pktcount;
+	unsigned raw_out_pktlen;
+	unsigned raw_out_pktcount;
+	unsigned flow_start_sec;
+	unsigned flow_duration;
 };
 
-/* the database handle we are using */
-static sqlite3 *dbh;
+#define RKEY(key)	((key)->u.source)
 
-/* a linked list of the fields the table has */
-static struct _field *fields;
 
-/* buffer for our insert statement */
-static char *stmt;
+struct sqlite3_priv {
+	sqlite3 *dbh;				/* database handle we are using */
+	char *stmt;
+	sqlite3_stmt *p_stmt;
+	int buffer_size;
 
-/* pointer to the final prepared statement */
-static sqlite3_stmt *p_stmt;
+	struct ulogd_timer timer;
 
-/* number of statements to buffer before we commit */
-static int buffer_size;
+	struct col cols[DB_NUM_COLS];
 
-/* number of statements currently in the buffer */
-static int buffer_ctr;
+	/* our backlog buffer */
+	struct llist_head rows;
+	int num_rows;
+	int max_backlog;
 
-/* our configuration directives */
-static config_entry_t db_ce = { 
-	.key = "db", 
-	.type = CONFIG_TYPE_STRING,
-	.options = CONFIG_OPT_MANDATORY,
-};
+	time_t commit_time;
 
-static config_entry_t table_ce = { 
-	.next = &db_ce, 
-	.key = "table",
-	.type = CONFIG_TYPE_STRING,
-	.options = CONFIG_OPT_MANDATORY,
+	unsigned disable : 1;
+	unsigned overlimit_msg : 1;
 };
 
-static config_entry_t buffer_ce = { 
-	.next = &table_ce,
-	.key = "buffer",
-	.type = CONFIG_TYPE_INT,
-	.options = CONFIG_OPT_MANDATORY,
+
+static struct config_keyset sqlite3_kset = {
+	.num_ces = 6,
+	.ces = {
+		{
+			.key = "db",
+			.type = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_MANDATORY,
+		},
+		{
+			.key = "table",
+			.type = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_MANDATORY,
+		},
+		{
+			.key = "buffer",
+			.type = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = CFG_BUFFER_DEFAULT,
+		},
+		{
+			.key = "timer",
+			.type = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = CFG_TIMER_DEFAULT,
+		},
+		{
+			.key = "max-backlog",
+			.type = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = CFG_MAX_BACKLOG_DEFAULT,
+		},
+		{
+			.key = "disable",
+			.type = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = 0,
+		},
+	},
 };
 
-/* our main output function, called by ulogd */
-static int _sqlite3_output(ulog_iret_t *result)
+#define db_ce(pi)		(pi)->config_kset->ces[0].u.string
+#define table_ce(pi)	(pi)->config_kset->ces[1].u.string
+#define buffer_ce(pi)	(pi)->config_kset->ces[2].u.value
+#define timer_ce(pi)	(pi)->config_kset->ces[3].u.value
+#define max_backlog_ce(pi)	(pi)->config_kset->ces[4].u.value
+#define disable_ce(pi)	(pi)->config_kset->ces[5].u.value
+
+
+#define SQL_CREATE_STR \
+		"create table daily(ip_saddr integer, ip_daddr integer, " \
+		"ip_protocol integer, l4_dport integer, raw_in_pktlen integer, " \
+		"raw_in_pktcount integer, raw_out_pktlen integer, " \
+		"raw_out_pktcount integer, flow_start_sec integer, " \
+		"flow_duration integer)"
+
+
+static struct row *
+row_new(void)
 {
-	struct _field *f;
-	ulog_iret_t *res;
-	int col_counter;
-#ifdef IP_AS_STRING
-	char *ipaddr;
-	struct in_addr addr;
-#endif
-
-	col_counter = 1;
-	for (f = fields; f; f = f->next) {
-		res = keyh_getres(f->id);
-
-		if (!res) {
-			ulogd_log(ULOGD_NOTICE,
-				"no result for %s ?!?\n", f->name);
-		}
-			
-		if (!res || !IS_VALID((*res))) {
-			/* no result, pass a null */
-			sqlite3_bind_null(p_stmt, col_counter);
-			col_counter++;
-			continue;
-		}
-		
-		switch (res->type) {
-			case ULOGD_RET_INT8:
-				sqlite3_bind_int(p_stmt,col_counter,res->value.i8);
-				break;
-			case ULOGD_RET_INT16:
-				sqlite3_bind_int(p_stmt,col_counter,res->value.i16);
-				break;
-			case ULOGD_RET_INT32:
-				sqlite3_bind_int(p_stmt,col_counter,res->value.i32);
-				break;
-			case ULOGD_RET_INT64:
-				sqlite3_bind_int64(p_stmt,col_counter,res->value.i64);
-				break;
-			case ULOGD_RET_UINT8:
-				sqlite3_bind_int(p_stmt,col_counter,res->value.ui8);
-				break;
-			case ULOGD_RET_UINT16:
-				sqlite3_bind_int(p_stmt,col_counter,res->value.ui16);
-				break;
-			case ULOGD_RET_IPADDR:
-#ifdef IP_AS_STRING
-				memset(&addr, 0, sizeof(addr));
-				addr.s_addr = ntohl(res->value.ui32);
-				ipaddr = inet_ntoa(addr);
-				sqlite3_bind_text(p_stmt,col_counter,ipaddr,strlen(ipaddr),SQLITE_STATIC);
-                                break;
-#endif /* IP_AS_STRING */
-			/* EVIL: fallthrough when logging IP as u_int32_t */
-			case ULOGD_RET_UINT32:
-				sqlite3_bind_int(p_stmt,col_counter,res->value.ui32);
-				break;
-			case ULOGD_RET_UINT64:
-				sqlite3_bind_int64(p_stmt,col_counter,res->value.ui64);
-				break;
-			case ULOGD_RET_BOOL:
-				sqlite3_bind_int(p_stmt,col_counter,res->value.b);
-				break;
-			case ULOGD_RET_STRING:
-				sqlite3_bind_text(p_stmt,col_counter,res->value.ptr,strlen(res->value.ptr),SQLITE_STATIC);
-				break;
-			default:
-				ulogd_log(ULOGD_NOTICE,
-					"unknown type %d for %s\n",
-					res->type, res->key);
-				break;
-		} 
-
-		col_counter++;
-	}
-
-	/* now we have created our statement, insert it */
-
-	if (sqlite3_step(p_stmt) == SQLITE_DONE) {
-		sqlite3_reset(p_stmt);
-		buffer_ctr++;
-	} else {
-		ulogd_log(ULOGD_ERROR, "sql error during insert: %s\n",
-				sqlite3_errmsg(dbh));
-		return 1;
-	}
+	struct row *row;
+
+	if ((row = calloc(1, sizeof(struct row))) == NULL)
+		ulogd_error("%s: out of memory\n", __func__);
+
+	return row;
+}
+
 
-	/* commit all of the inserts to the database, ie flush buffer */
-	if (buffer_ctr >= buffer_size) {
-		if (sqlite3_exec(dbh,"commit",NULL,NULL,NULL) != SQLITE_OK)
-			ulogd_log(ULOGD_ERROR,"unable to commit records to db.");
+static inline void
+__row_del(struct sqlite3_priv *priv, struct row *row)
+{
+	assert(row != NULL);
 
-		if (sqlite3_exec(dbh,"begin deferred",NULL,NULL,NULL) != SQLITE_OK)
-			ulogd_log(ULOGD_ERROR,"unable to begin a new transaction.");
+	free(row);
+}
+
+
+static void
+row_del(struct sqlite3_priv *priv, struct row *row)
+{
+	llist_del(&row->link);
 
-		buffer_ctr = 0;
-		DEBUGP("committing.\n");
+	__row_del(priv, row);
+
+	priv->num_rows--;
+}
+
+
+static int
+row_add(struct sqlite3_priv *priv, struct row *row)
+{
+	if (priv->max_backlog && priv->num_rows >= priv->max_backlog) {
+		if (!priv->overlimit_msg) {
+			ulogd_error(PFX "over max-backlog limit, dropping rows\n");
+
+			priv->overlimit_msg = 1;
+		}
+
+		__row_del(priv, row);
+
+		return -1;
 	}
 
+	llist_add_tail(&row->link, &priv->rows);
+
+	priv->num_rows++;
+
 	return 0;
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
+
 #define _SQLITE3_INSERTTEMPL   "insert into X (Y) values (Z)"
 
-/* create the static part of our insert statement */
-static int _sqlite3_createstmt(void)
+/* create static part of our insert statement */
+static int
+db_createstmt(struct ulogd_pluginstance *pi)
 {
-	struct _field *f;
-	unsigned int size;
+	struct sqlite3_priv *priv = (void *)pi->private;
 	char buf[ULOGD_MAX_KEYLEN];
 	char *underscore;
 	char *stmt_pos;
-	int col_count;
 	int i;
 
-	if (stmt) {
-		ulogd_log(ULOGD_NOTICE, "createstmt called, but stmt"
-			" already existing\n");	
-		return 1;
-	}
-
-	/* caclulate the size for the insert statement */
-	size = strlen(_SQLITE3_INSERTTEMPL) + strlen(table_ce.u.string);
+	if (priv->stmt != NULL)
+		free(priv->stmt);
 
-	DEBUGP("initial size: %u\n", size);
-
-	col_count = 0;
-	for (f = fields; f; f = f->next) {
-		/* we need space for the key and a comma, and a ? */
-		size += strlen(f->name) + 3;
-		DEBUGP("size is now %u since adding %s\n",size,f->name);
-		col_count++;
+	if ((priv->stmt = calloc(1, 1024)) == NULL) {
+		ulogd_error(PFX "out of memory\n");
+		return -1;
 	}
 
-	DEBUGP("there were %d columns\n",col_count);
-	DEBUGP("after calc name length: %u\n",size);
-
-	ulogd_log(ULOGD_DEBUG, "allocating %u bytes for statement\n", size);
-
-	stmt = (char *) malloc(size);
+	sprintf(priv->stmt, "insert into %s (", table_ce(pi));
+	stmt_pos = priv->stmt + strlen(priv->stmt);
 
-	if (!stmt) {
-		ulogd_log(ULOGD_ERROR, "OOM!\n");
-		return 1;
-	}
+	for (i = 0; i < DB_NUM_COLS; i++) {
+		struct col *col = &priv->cols[i];
 
-	sprintf(stmt, "insert into %s (", table_ce.u.string);
-	stmt_pos = stmt + strlen(stmt);
+		/* convert name */
+		strncpy(buf, col->name, ULOGD_MAX_KEYLEN);
 
-	for (f = fields; f; f = f->next) {
-		strncpy(buf, f->name, ULOGD_MAX_KEYLEN);	
 		while ((underscore = strchr(buf, '.')))
 			*underscore = '_';
+
 		sprintf(stmt_pos, "%s,", buf);
-		stmt_pos = stmt + strlen(stmt);
+		stmt_pos = priv->stmt + strlen(priv->stmt);
 	}
 
 	*(stmt_pos - 1) = ')';
 
 	sprintf(stmt_pos, " values (");
-	stmt_pos = stmt + strlen(stmt);
+	stmt_pos = priv->stmt + strlen(priv->stmt);
 
-	for (i = 0; i < col_count - 1; i++) {
+	for (i = 0; i < DB_NUM_COLS - 1; i++) {
 		sprintf(stmt_pos,"?,");
 		stmt_pos += 2;
 	}
 
 	sprintf(stmt_pos, "?)");
-	ulogd_log(ULOGD_DEBUG, "stmt='%s'\n", stmt);
+	ulogd_log(ULOGD_DEBUG, "%s: stmt='%s'\n", pi->id, priv->stmt);
 
-	DEBUGP("about to prepare statement.\n");
+	pr_debug("about to prepare statement.\n");
 
-	sqlite3_prepare(dbh,stmt,-1,&p_stmt,0);
-
-	DEBUGP("statement prepared.\n");
-
-	if (!p_stmt) {
-		ulogd_log(ULOGD_ERROR,"unable to prepare statement");
+	sqlite3_prepare(priv->dbh, priv->stmt, -1, &priv->p_stmt, 0);
+	if (priv->p_stmt == NULL) {
+		ulogd_error(PFX "prepare: %s\n", sqlite3_errmsg(priv->dbh));
 		return 1;
 	}
 
+	pr_debug("%s: statement prepared.\n", pi->id);
+
 	return 0;
 }
 
 
-/* length of "select * from \0" */
-#define SQLITE_SELECT_LEN 15
+static struct ulogd_key *
+ulogd_find_key(struct ulogd_pluginstance *pi, const char *name)
+{
+	int i;
+
+	for (i = 0; i < pi->input.num_keys; i++) {
+		if (strcmp(pi->input.keys[i].name, name) == 0)
+			return &pi->input.keys[i];
+	}
+
+	return NULL;
+}
+
+#define SELECT_ALL_STR			"select * from "
+#define SELECT_ALL_LEN			sizeof(SELECT_ALL_STR)
 
-/* find out which columns the table has */
-static int _sqlite3_get_columns(const char *table)
+static int
+db_count_cols(struct ulogd_pluginstance *pi, sqlite3_stmt **stmt)
 {
+	struct sqlite3_priv *priv = (void *)pi->private;
+	char query[SELECT_ALL_LEN + CONFIG_VAL_STRING_LEN] = SELECT_ALL_STR;
+
+	strncat(query, table_ce(pi), LINE_LEN);
+
+	if (sqlite3_prepare(priv->dbh, query, -1, stmt, 0) != SQLITE_OK) {
+		return -1;
+	}
+
+	return sqlite3_column_count(*stmt);
+}
+
+
+static int
+db_create_tbl(struct ulogd_pluginstance *pi)
+{
+	struct sqlite3_priv *priv = (void *)pi->private;
+	char *errmsg;
+	int ret;
+
+	sqlite3_exec(priv->dbh, "drop table daily", NULL, NULL, NULL);
+
+	ret = sqlite3_exec(priv->dbh, SQL_CREATE_STR, NULL, NULL, &errmsg);
+	if (ret != SQLITE_OK) {
+		ulogd_error(PFX "create table: %s\n", errmsg);
+		sqlite3_free(errmsg);
+
+		return -1;
+	}
+
+	return 0;
+}
+
+
+/* initialize DB, possibly creating it */
+static int
+db_init(struct ulogd_pluginstance *pi)
+{
+	struct sqlite3_priv *priv = (void *)pi->private;
 	char buf[ULOGD_MAX_KEYLEN];
-	char query[SQLITE_SELECT_LEN + CONFIG_VAL_STRING_LEN] = "select * from \0";
 	char *underscore;
-	struct _field *f;
 	sqlite3_stmt *schema_stmt;
-	int column;
-	int result;
-	int id;
+	int num_cols, i;
 
-	if (!dbh)
-		return 1;
+	if (priv->dbh == NULL)
+		return -1;
 
-	strncat(query,table,LINE_LEN);
-	
-	result = sqlite3_prepare(dbh,query,-1,&schema_stmt,0);
-	
-	if (result != SQLITE_OK)
-		return 1;
+	num_cols = db_count_cols(pi, &schema_stmt);
+	if (num_cols != DB_NUM_COLS) {
+		ulogd_log(ULOGD_INFO, "%s: (re)creating database\n", pi->id);
+
+		if (db_create_tbl(pi) < 0)
+			return -1;
+
+		num_cols = db_count_cols(pi, &schema_stmt);
+	}
+
+	assert(num_cols == DB_NUM_COLS);
+
+	for (i = 0; i < DB_NUM_COLS; i++) {
+		struct col *col = &priv->cols[i];
+
+		strncpy(buf, sqlite3_column_name(schema_stmt, i), ULOGD_MAX_KEYLEN);
 
-	for (column = 0; column < sqlite3_column_count(schema_stmt); column++) {
 		/* replace all underscores with dots */
-		strncpy(buf, sqlite3_column_name(schema_stmt,column), ULOGD_MAX_KEYLEN);
-		while ((underscore = strchr(buf, '_')))
+		while ((underscore = strchr(buf, '_')) != NULL)
 			*underscore = '.';
 
-		DEBUGP("field '%s' found: ", buf);
+		pr_debug("column '%s' found\n", buf);
 
-		if (!(id = keyh_getid(buf))) {
-			DEBUGP(" no keyid!\n");
-			continue;
+		strncpy(col->name, buf, ULOGD_MAX_KEYLEN);
+
+		if ((col->key = ulogd_find_key(pi, buf)) == NULL) {
+			printf(PFX "%s: key not found\n", buf);
+			return -1;
 		}
+	}
+
+	ulogd_log(ULOGD_INFO, "%s: database opened\n", pi->id);
+
+	if (sqlite3_finalize(schema_stmt) != SQLITE_OK) {
+		ulogd_error(PFX "sqlite_finalize: %s\n",
+					sqlite3_errmsg(priv->dbh));
+		return -1;
+	}
+
+	return 0;
+}
+
+
+static void
+db_reset(struct ulogd_pluginstance *pi)
+{
+	struct sqlite3_priv *priv = (void *)pi->private;
+
+	sqlite3_finalize(priv->p_stmt);
+
+	sqlite3_close(priv->dbh);
+	priv->dbh = NULL;
+
+	free(priv->stmt);
+	priv->stmt = NULL;
+}
+
+
+static int
+db_start(struct ulogd_pluginstance *pi)
+{
+	struct sqlite3_priv *priv = (void *)pi->private;
 
-		DEBUGP("keyid %u\n", id);
+	ulogd_log(ULOGD_DEBUG, "%s: opening database connection\n", pi->id);
 
-		/* prepend it to the linked list */
-		f = (struct _field *) malloc(sizeof *f);
-		if (!f) {
-			ulogd_log(ULOGD_ERROR, "OOM!\n");
-			return 1;
+	if (sqlite3_open(db_ce(pi), &priv->dbh) != SQLITE_OK) {
+		ulogd_error(PFX "%s\n", sqlite3_errmsg(priv->dbh));
+		return -1;
+	}
+
+	/* set the timeout so that we don't automatically fail
+	   if the table is busy */
+	sqlite3_busy_timeout(priv->dbh, SQLITE3_BUSY_TIMEOUT);
+
+	/* read the fieldnames to know which values to insert */
+	if (db_init(pi) < 0)
+		return -1;
+
+	/* initialize our buffer size and counter */
+	priv->buffer_size = buffer_ce(pi);
+
+	priv->max_backlog = max_backlog_ce(pi);
+
+	/* create and prepare the actual insert statement */
+	db_createstmt(pi);
+
+	return 0;
+}
+
+/* db_err() - handle database errors */
+static int
+db_err(struct ulogd_pluginstance *pi, int ret)
+{
+	struct sqlite3_priv *priv = (void *)pi->private;
+
+	pr_debug("%s: ret=%d (errcode %d)\n", __func__, ret,
+			 sqlite3_errcode(priv->dbh));
+
+	assert(ret != SQLITE_OK && ret != SQLITE_DONE);
+
+	if (ret == SQLITE_BUSY || ret == SQLITE_LOCKED)
+		set_commit_time(pi);
+	else {
+		switch (sqlite3_errcode(priv->dbh)) {
+		case SQLITE_LOCKED:
+		case SQLITE_BUSY:
+			set_commit_time(pi);
+			break;
+
+		case SQLITE_SCHEMA:
+			if (priv->stmt) {
+				sqlite3_finalize(priv->p_stmt);
+
+				db_createstmt(pi);
+
+				ulogd_log(ULOGD_INFO, "%s: database schema changed\n",
+						  pi->id);
+			}
+			break;
+
+		default:
+			ulogd_error("%s: transaction: %s\n", pi->id,
+						sqlite3_errmsg(priv->dbh));
+			break;
 		}
-		strncpy(f->name, buf, ULOGD_MAX_KEYLEN);
-		f->id = id;
-		f->next = fields;
-		fields = f;	
 	}
 
-	sqlite3_finalize(schema_stmt);
+	sqlite3_exec(priv->dbh, "rollback", NULL, NULL, NULL);
+
+	/* no sqlit3_clear_bindings(), as an unbind will be done implicitely
+	   on next bind. */
+	if (priv->p_stmt != NULL)
+		sqlite3_reset(priv->p_stmt);
+
 	return 0;
 }
 
-/** 
- * make connection and select database 
- * returns 0 if database failed to open.
- */
-static int _sqlite3_open_db(char *db_file)
+static int
+db_add_row(struct ulogd_pluginstance *pi, const struct row *row)
 {
-	DEBUGP("opening database.\n");
-	return sqlite3_open(db_file,&dbh);
+	struct sqlite3_priv *priv = (void *)pi->private;
+	int db_col = 1, ret;
+
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
+
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
 }
 
-/* give us an opportunity to close the database down properly */
-static void _sqlite3_fini(void)
+/* delete_rows() - delete rows from the tail of the list */
+static int
+delete_rows(struct ulogd_pluginstance *pi, int rows)
 {
-	DEBUGP("cleaning up db connection\n");
+	struct sqlite3_priv *priv = (void *)pi->private;
+	struct llist_head *curr, *tmp;
+
+    llist_for_each_prev_safe(curr, tmp, &priv->rows) {
+		struct row *row = container_of(curr, struct row, link);
 
-	/* free up our prepared statements so we can close the db */
-	if (p_stmt) {
-		sqlite3_finalize(p_stmt);
-		DEBUGP("prepared statement finalized\n");
+		if (rows-- == 0)
+			break;
+
+		row_del(priv, row);
 	}
 
-	if (dbh) {
-		int result;
-		/* flush the remaining insert statements to the database. */
-		result = sqlite3_exec(dbh,"commit",NULL,NULL,NULL);
+	return 0;
+}
+
+/*
+  db_commit_rows()
+
+  RETURN
+    >0	rows commited
+    0	locked
+   -1	error
+*/
+static int
+db_commit_rows(struct ulogd_pluginstance *pi)
+{
+	struct sqlite3_priv *priv = (void *)pi->private;
+	struct row *row;
+	int ret, rows = 0, max_commit;
+
+	ret = sqlite3_exec(priv->dbh, "begin immediate transaction", NULL,
+					   NULL, NULL);
+	if (ret != SQLITE_OK)
+		return db_err(pi, ret);
+
+	/* Limit number of rows to commit.  Note that currently three times
+	   buffer_size is a bit arbitrary and therefore might be adjusted in
+	   the future. */
+	max_commit = max(3 * priv->buffer_size, 1024);
 
-		if (result != SQLITE_OK)
-			ulogd_log(ULOGD_ERROR,"unable to commit remaining records to db.");
+	llist_for_each_entry_reverse(row, &priv->rows, link) {
+		if (++rows > max_commit)
+			break;
 
-		sqlite3_close(dbh);
-		DEBUGP("database file closed\n");
+		if (db_add_row(pi, row) < 0)
+			return db_err(pi, ret);
 	}
+
+	ret = sqlite3_exec(priv->dbh, "commit", NULL, NULL, NULL);
+	if (ret != SQLITE_OK)
+		return db_err(pi, ret);
+
+	sqlite3_reset(priv->p_stmt);
+	
+	pr_debug("%s: commited %d/%d rows\n", pi->id, rows, priv->num_rows);
+
+	delete_rows(pi, rows);
+	
+	if (priv->commit_time >= t_now)
+		priv->commit_time = 0;		/* release commit lock */
+	
+	if (priv->overlimit_msg)
+		priv->overlimit_msg = 0;
+
+	return rows;
 }
 
-#define _SQLITE3_BUSY_TIMEOUT 300
 
-static int _sqlite3_init(void)
+/* our main output function, called by ulogd */
+static int
+sqlite3_interp(struct ulogd_pluginstance *pi)
 {
-	/* have the opts parsed */
-	config_parse_file("SQLITE3", &buffer_ce);
+	struct sqlite3_priv *priv = (void *)pi->private;
+	struct col *cols = priv->cols;
+	struct row *row;
+
+	if ((row = row_new()) == NULL)
+		return ULOGD_IRET_ERR;
+
+	row->ip_saddr = RKEY(cols[0].key)->u.value.ui32;
+	row->ip_daddr = RKEY(cols[1].key)->u.value.ui32;
+	row->ip_proto = RKEY(cols[2].key)->u.value.ui8;
+	row->l4_dport = RKEY(cols[3].key)->u.value.ui16;
+	row->raw_in_pktlen = RKEY(cols[4].key)->u.value.ui32;
+	row->raw_in_pktcount = RKEY(cols[5].key)->u.value.ui32;
+	row->raw_out_pktlen = RKEY(cols[6].key)->u.value.ui32;
+	row->raw_out_pktcount = RKEY(cols[7].key)->u.value.ui32;
+	row->flow_start_sec = RKEY(cols[9].key)->u.value.ui32;
+	row->flow_duration = RKEY(cols[10].key)->u.value.ui32;
 
-	if (_sqlite3_open_db(db_ce.u.string)) {
-		ulogd_log(ULOGD_ERROR, "can't open the database file\n");
-		return 1;
+	if (row_add(priv, row) < 0)
+		return ULOGD_IRET_OK;
+
+	if (priv->num_rows >= priv->buffer_size && priv->commit_time == 0)
+		db_commit_rows(pi);
+
+	return ULOGD_IRET_OK;
+}
+
+
+static void
+sqlite_timer_cb(struct ulogd_timer *t)
+{
+	struct ulogd_pluginstance *pi = t->data;
+	struct sqlite3_priv *priv = (void *)pi->private;
+	int rows;
+
+	pr_debug("%s: timer=%p\n", __func__, t);
+
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
+}
+
+
+static int
+sqlite3_configure(struct ulogd_pluginstance *pi,
+				  struct ulogd_pluginstance_stack *stack)
+{
+	struct sqlite3_priv *priv = (void *)pi->private;
+
+	memset(priv, 0, sizeof(struct sqlite3_priv));
+	
+	config_parse_file(pi->id, pi->config_kset);
+
+	if (ulogd_wildcard_inputkeys(pi) < 0)
+		return -1;
+
+	if (db_ce(pi) == NULL) {
+		ulogd_error("%s: configure: no database specified\n", pi->id);
+		return -1;
 	}
 
-	/* set the timeout so that we don't automatically fail
-         * if the table is busy. */
-	sqlite3_busy_timeout(dbh, _SQLITE3_BUSY_TIMEOUT);
+	if (table_ce(pi) == NULL) {
+		ulogd_error("%s: configure: no table specified\n", pi->id);
+		return -1;
+	}
 
-	/* read the fieldnames to know which values to insert */
-	if (_sqlite3_get_columns(table_ce.u.string)) {
-		ulogd_log(ULOGD_ERROR, "unable to get sqlite columns\n");
-		return 1;
+	if (timer_ce(pi) <= 0) {
+		ulogd_error("%s: configure: invalid timer value\n", pi->id);
+		return -1;
 	}
 
-	/* initialize our buffer size and counter */
-	buffer_size = buffer_ce.u.value;
-	buffer_ctr = 0;
+	if (max_backlog_ce(pi)) {
+		if (max_backlog_ce(pi) <= buffer_ce(pi)) {
+			ulogd_error("%s: configure: invalid max-backlog value\n",
+						pi->id);
+			return -1;
+		}
+	}
 
-	DEBUGP("Have a buffer size of : %d\n", buffer_size);
+	priv->max_backlog = max_backlog_ce(pi);
+	priv->disable = disable_ce(pi);
 
-	if (sqlite3_exec(dbh,"begin deferred",NULL,NULL,NULL) != SQLITE_OK)
-		ulogd_log(ULOGD_ERROR,"can't create a new transaction\n");
+	pr_debug("%s: db='%s' table='%s' timer=%d max-backlog=%d\n", pi->id,
+			 db_ce(pi), table_ce(pi), timer_ce(pi), max_backlog_ce(pi));
 
-	/* create and prepare the actual insert statement */
-	_sqlite3_createstmt();
+	return 0;
+}
+
+
+static int
+sqlite3_start(struct ulogd_pluginstance *pi)
+{
+	struct sqlite3_priv *priv = (void *)pi->private;
+
+	pr_debug("%s: pi=%p\n", __func__, pi);
+
+	if (priv->disable) {
+		ulogd_log(ULOGD_NOTICE, "%s: disabled\n", pi->id);
+		return 0;
+	}
+
+	priv->num_rows = 0;
+	INIT_LLIST_HEAD(&priv->rows);
+
+	if (db_start(pi) < 0)
+		return -1;
+
+	/* init timer */
+	priv->timer.cb = sqlite_timer_cb;
+	priv->timer.ival = timer_ce(pi);
+	priv->timer.flags = TIMER_F_PERIODIC;
+	priv->timer.data = pi;
+
+	if (ulogd_register_timer(&priv->timer) < 0)
+		return -1;
+
+	ulogd_log(ULOGD_INFO, "%s: started\n", pi->id);
 
 	return 0;
 }
 
-static ulog_output_t _sqlite3_plugin = { 
-	.name = "sqlite3", 
-	.output = &_sqlite3_output, 
-	.init = &_sqlite3_init,
-	.fini = &_sqlite3_fini,
-};
 
-void _init(void) 
+/* give us an opportunity to close the database down properly */
+static int
+sqlite3_stop(struct ulogd_pluginstance *pi)
 {
-	register_output(&_sqlite3_plugin);
+	struct sqlite3_priv *priv = (void *)pi->private;
+
+	pr_debug("%s: pi=%p\n", __func__, pi);
+
+	if (priv->disable)
+		return 0;				/* wasn't started */
+
+	if (priv->dbh == NULL)
+		return 0;				/* already stopped */
+
+	db_reset(pi);
+
+	return 0;
 }
 
-#endif
+
+static void
+sqlite3_signal(struct ulogd_pluginstance *pi, int sig)
+{
+	struct sqlite3_priv *priv = (void *)pi->private;
+
+	switch (sig) {
+	case SIGUSR1:
+		if (priv->dbh != NULL) {
+			db_reset(pi);
+
+			if (db_start(pi) < 0) {
+				ulogd_log(ULOGD_FATAL, "%s: database reset failed\n", pi->id);
+				exit(EXIT_FAILURE);
+			}
+		}
+		break;
+
+	default:
+		break;
+	}
+}
+
+
+static struct ulogd_plugin sqlite3_plugin = { 
+	.name = "SQLITE3",
+	.flags = ULOGD_PF_RECONF,
+	.input = {
+		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
+	},
+	.output = {
+		.type = ULOGD_DTYPE_SINK,
+	},
+	.config_kset = &sqlite3_kset,
+	.priv_size = sizeof(struct sqlite3_priv),
+	.configure = sqlite3_configure,
+	.start = sqlite3_start,
+	.stop = sqlite3_stop,
+	.signal = sqlite3_signal,
+	.interp = sqlite3_interp,
+	.version = ULOGD_VERSION,
+};
+
+static void init(void) __attribute__((constructor));
+
+static void
+init(void) 
+{
+	ulogd_register_plugin(&sqlite3_plugin);
+
+	ulogd_log(ULOGD_INFO, "using Sqlite version %s\n", sqlite3_libversion());
+}

-- 
