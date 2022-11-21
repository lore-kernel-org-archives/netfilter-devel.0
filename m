Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DAADC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 22:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbiKUW5P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKUW5N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 17:57:13 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D789EC72EF
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 14:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lxgVvnx4lrS9xfu0HmC7jvBgUe0iF+Xr9IW/3mYlZWs=; b=sNWb+FtpvQFDTxTNgO3pWHZzGe
        q0I5Z4dPRHQedmaVJ2oZYSoS/WIicbrvevRbeMufytgIPNNG2eOEjiONEG28c2dVYMa4ixPx7geTr
        7YofZAGF0kPcGnD+5OcgZaKeMf28TEMLlZA6VkbbUbU+rEA8AeRJ4whfEWPp+oUIXuREVZKUUwanX
        HWHji8oM8j96Iy2h/ScFtI8qXVBEIypEZagk5Uem3ucsZPPwnvgXap6Fq+peBQeFY1sbygm60h33W
        Fzq3KXkqjNFCFQXPU4XeIQMrpyAsc1E2eyqWzGYuAUH0XuANANO1zoGdTqkdCKS6ZD8uTdpFlss/p
        HO9T8LOA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxFGD-005LgP-QD
        for netfilter-devel@vger.kernel.org; Mon, 21 Nov 2022 22:27:29 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 15/34] db: reorganize source
Date:   Mon, 21 Nov 2022 22:25:52 +0000
Message-Id: <20221121222611.3914559-16-jeremy@azazel.net>
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

The functions are rather haphazardly ordered and inconsistently named.
Group all function declarations first, followed by the public functions
(those with extern linkage) next, and then the static ones, grouping
those related to the back-log and ring-buffer separately.  Extern
functions are all prefixed `ulogd_db_`, static ones are all prefixed
with a single underscore.

Rename a couple of `struct db_instance` variables for consistency.

No functional changes.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 util/db.c | 623 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 328 insertions(+), 295 deletions(-)

diff --git a/util/db.c b/util/db.c
index 4ec0af2ea38a..7a6401f73609 100644
--- a/util/db.c
+++ b/util/db.c
@@ -37,115 +37,30 @@
 #include <ulogd/ulogd.h>
 #include <ulogd/db.h>
 
-
 /* generic db layer */
 
-static int __interp_db(struct ulogd_pluginstance *upi);
-
-/* this is a wrapper that just calls the current real
- * interp function */
-int ulogd_db_interp(struct ulogd_pluginstance *upi)
-{
-	struct db_instance *dbi = (struct db_instance *) &upi->private;
-	return dbi->interp(upi);
-}
-
-/* no connection, plugin disabled */
-static int disabled_interp_db(struct ulogd_pluginstance *upi)
-{
-	return 0;
-}
-
-#define SQL_INSERTTEMPL   "SELECT P(Y)"
-#define SQL_VALSIZE	100
-
-/* create the static part of our insert statement */
-static int sql_createstmt(struct ulogd_pluginstance *upi)
-{
-	struct db_instance *mi = (struct db_instance *) upi->private;
-	unsigned int size;
-	unsigned int i;
-	char *table = table_ce(upi->config_kset).u.string;
-	char *procedure = procedure_ce(upi->config_kset).u.string;
-
-	if (mi->stmt)
-		free(mi->stmt);
-
-	/* caclulate the size for the insert statement */
-	size = strlen(SQL_INSERTTEMPL) + strlen(table);
-
-	for (i = 0; i < upi->input.num_keys; i++) {
-		if (upi->input.keys[i].flags & ULOGD_KEYF_INACTIVE)
-			continue;
-		/* we need space for the key and a comma, as well as
-		 * enough space for the values */
-		size += strlen(upi->input.keys[i].name) + 1 + SQL_VALSIZE;
-	}
-	size += strlen(procedure);
-
-	ulogd_log(ULOGD_DEBUG, "allocating %u bytes for statement\n", size);
-
-	mi->stmt = malloc(size);
-	if (!mi->stmt) {
-		ulogd_log(ULOGD_ERROR, "OOM!\n");
-		return -ENOMEM;
-	}
-	mi->ring.length = size + 1;
-
-	if (strncasecmp(procedure,"INSERT", strlen("INSERT")) == 0 &&
-	    (procedure[strlen("INSERT")] == '\0' ||
-			procedure[strlen("INSERT")] == ' ')) {
-		char *stmt_val = mi->stmt;
-
-		if(procedure[6] == '\0') {
-			/* procedure == "INSERT" */
-			if (mi->schema)
-				stmt_val += sprintf(stmt_val,
-						    "insert into %s.%s (",
-						    mi->schema, table);
-			else
-				stmt_val += sprintf(stmt_val,
-						    "insert into %s (", table);
-		} else
-			stmt_val += sprintf(stmt_val, "%s (", procedure);
-
-		for (i = 0; i < upi->input.num_keys; i++) {
-			char *underscore;
-
-			if (upi->input.keys[i].flags & ULOGD_KEYF_INACTIVE)
-				continue;
-
-			underscore = stmt_val;
-
-			stmt_val += sprintf(stmt_val, "%s,",
-					    upi->input.keys[i].name);
-
-			while ((underscore = strchr(underscore, '.')))
-				*underscore = '_';
-		}
-		*(stmt_val - 1) = ')';
-
-		sprintf(stmt_val, " values (");
-	} else if (strncasecmp(procedure,"CALL", strlen("CALL")) == 0) {
-		sprintf(mi->stmt, "CALL %s(", procedure);
-	} else {
-		sprintf(mi->stmt, "SELECT %s(", procedure);
-
-	}
+static int _interp_db_init(struct ulogd_pluginstance *upi);
+static int _interp_db_main(struct ulogd_pluginstance *upi);
+static int _interp_db_disabled(struct ulogd_pluginstance *upi);
+static int _reconnect_db(struct ulogd_pluginstance *upi);
+static int _stop_db(struct ulogd_pluginstance *upi);
 
-	mi->stmt_offset = strlen(mi->stmt);
+static char *_format_key(char *key);
+static int _create_sql_stmt(struct ulogd_pluginstance *upi);
+static void _bind_sql_stmt(struct ulogd_pluginstance *upi,
+			   char *stmt);
 
-	ulogd_log(ULOGD_DEBUG, "stmt='%s'\n", mi->stmt);
+static int _add_to_backlog(struct ulogd_pluginstance *upi,
+			   const char *stmt, unsigned int len);
+static int _process_backlog(struct ulogd_pluginstance *upi);
 
-	return 0;
-}
-
-static int _init_db(struct ulogd_pluginstance *upi);
-
-static void *__inject_thread(void *gdi);
+static int _add_to_ring(struct ulogd_pluginstance *upi, struct db_instance *di);
+static void *_process_ring(void *arg);
+static int _loop_reconnect_db(struct ulogd_pluginstance *upi);
 
-int ulogd_db_configure(struct ulogd_pluginstance *upi,
-			struct ulogd_pluginstance_stack *stack)
+int
+ulogd_db_configure(struct ulogd_pluginstance *upi,
+		   struct ulogd_pluginstance_stack *stack)
 {
 	struct db_instance *di = (struct db_instance *) upi->private;
 	int ret;
@@ -199,7 +114,44 @@ int ulogd_db_configure(struct ulogd_pluginstance *upi,
 	return ret;
 }
 
-int ulogd_db_start(struct ulogd_pluginstance *upi)
+int
+ulogd_db_alloc_input_keys(struct ulogd_pluginstance *upi,
+			  unsigned int num_keys, void *arg)
+{
+	struct db_instance *di = (struct db_instance *) &upi->private;
+	char *(*format_key)(char *) = di->driver->format_key ? : _format_key;
+	unsigned int i;
+
+	if (upi->input.keys)
+		free(upi->input.keys);
+
+	upi->input.num_keys = num_keys;
+	ulogd_log(ULOGD_DEBUG, "%u fields in table\n", upi->input.num_keys);
+	upi->input.keys = calloc(upi->input.num_keys, sizeof(upi->input.keys[0]));
+	if (!upi->input.keys) {
+		upi->input.num_keys = 0;
+		ulogd_log(ULOGD_ERROR, "ENOMEM\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < num_keys; i++) {
+		const char *col = di->driver->get_column(arg, i);
+
+		if (!col)
+			break;
+
+		snprintf(upi->input.keys[i].name,
+			 sizeof(upi->input.keys[i].name),
+			 "%s", col);
+
+		format_key(upi->input.keys[i].name);
+	}
+
+	return 0;
+}
+
+int
+ulogd_db_start(struct ulogd_pluginstance *upi)
 {
 	struct db_instance *di = (struct db_instance *) upi->private;
 	int ret;
@@ -211,7 +163,7 @@ int ulogd_db_start(struct ulogd_pluginstance *upi)
 	if (ret < 0)
 		return ret;
 
-	ret = sql_createstmt(upi);
+	ret = _create_sql_stmt(upi);
 	if (ret < 0)
 		goto db_error;
 
@@ -239,12 +191,12 @@ int ulogd_db_start(struct ulogd_pluginstance *upi)
 		if (ret != 0)
 			goto cond_error;
 		/* create thread */
-		ret = pthread_create(&di->db_thread_id, NULL, __inject_thread, upi);
+		ret = pthread_create(&di->db_thread_id, NULL, _process_ring, upi);
 		if (ret != 0)
 			goto mutex_error;
 	}
 
-	di->interp = &_init_db;
+	di->interp = &_interp_db_init;
 
 	return ret;
 
@@ -259,30 +211,55 @@ db_error:
 	return ret;
 }
 
-static int ulogd_db_instance_stop(struct ulogd_pluginstance *upi)
+/* this is a wrapper that just calls the current real interp function */
+int
+ulogd_db_interp(struct ulogd_pluginstance *upi)
 {
-	struct db_instance *di = (struct db_instance *) upi->private;
-	ulogd_log(ULOGD_NOTICE, "stopping\n");
-	di->driver->close_db(upi);
+	struct db_instance *di = (struct db_instance *) &upi->private;
+	return di->interp(upi);
+}
 
-	/* try to free the buffer for insert statement */
-	if (di->stmt) {
-		free(di->stmt);
-		di->stmt = NULL;
-	}
-	if (di->ring.size > 0) {
-		pthread_cancel(di->db_thread_id);
-		free(di->ring.ring);
-		pthread_cond_destroy(&di->ring.cond);
-		pthread_mutex_destroy(&di->ring.mutex);
-		di->ring.ring = NULL;
+void
+ulogd_db_signal(struct ulogd_pluginstance *upi, int signal)
+{
+	struct db_instance *di = (struct db_instance *) &upi->private;
+
+	switch (signal) {
+	case SIGHUP:
+		if (!di->ring.size) {
+			/* reopen database connection */
+			_stop_db(upi);
+			ulogd_db_start(upi);
+		} else
+			ulogd_log(ULOGD_ERROR,
+				  "No SIGHUP handling if ring buffer is used\n");
+		break;
+	case SIGTERM:
+	case SIGINT:
+		if (di->ring.size) {
+			int s = pthread_cancel(di->db_thread_id);
+			if (s != 0) {
+				ulogd_log(ULOGD_ERROR,
+					  "Can't cancel injection thread\n");
+				break;
+			}
+			s = pthread_join(di->db_thread_id, NULL);
+			if (s != 0) {
+				ulogd_log(ULOGD_ERROR,
+					  "Error waiting for injection thread"
+					  "cancelation\n");
+			}
+		}
+		break;
+	default:
+		break;
 	}
-	return 0;
 }
 
-int ulogd_db_stop(struct ulogd_pluginstance *upi)
+int
+ulogd_db_stop(struct ulogd_pluginstance *upi)
 {
-	ulogd_db_instance_stop(upi);
+	_stop_db(upi);
 
 	/* try to free our dynamically allocated input key array */
 	if (upi->input.keys) {
@@ -293,8 +270,85 @@ int ulogd_db_stop(struct ulogd_pluginstance *upi)
 	return 0;
 }
 
+/******************************************************************************/
 
-static int _init_reconnect(struct ulogd_pluginstance *upi)
+static int
+_interp_db_init(struct ulogd_pluginstance *upi)
+{
+	struct db_instance *di = (struct db_instance *) upi->private;
+
+	if (di->reconnect && di->reconnect > time(NULL)) {
+		/* store entry to backlog if it is active */
+		if (di->backlog_memcap && !di->backlog_full) {
+			_bind_sql_stmt(upi, di->stmt);
+			_add_to_backlog(upi, di->stmt, strlen(di->stmt));
+		}
+		return 0;
+	}
+
+	if (di->driver->open_db(upi)) {
+		ulogd_log(ULOGD_ERROR, "can't establish database connection\n");
+		if (di->backlog_memcap && !di->backlog_full) {
+			_bind_sql_stmt(upi, di->stmt);
+			_add_to_backlog(upi, di->stmt, strlen(di->stmt));
+		}
+		return _reconnect_db(upi);
+	}
+
+	/* enable 'real' logging */
+	di->interp = &_interp_db_main;
+
+	di->reconnect = 0;
+
+	/* call the interpreter function to actually write the
+	 * log line that we wanted to write */
+	return _interp_db_main(upi);
+}
+
+/* our main output function, called by ulogd */
+static int
+_interp_db_main(struct ulogd_pluginstance *upi)
+{
+	struct db_instance *di = (struct db_instance *) &upi->private;
+
+	if (di->ring.size)
+		return _add_to_ring(upi, di);
+
+	_bind_sql_stmt(upi, di->stmt);
+
+	/* if backup log is not empty we add current query to it */
+	if (!llist_empty(&di->backlog)) {
+		int ret = _add_to_backlog(upi, di->stmt, strlen(di->stmt));
+		if (ret == 0)
+			return _process_backlog(upi);
+		else {
+			ret = _process_backlog(upi);
+			if (ret)
+				return ret;
+			/* try adding once the data to backlog */
+			return _add_to_backlog(upi, di->stmt, strlen(di->stmt));
+		}
+	}
+
+	if (di->driver->execute(upi, di->stmt, strlen(di->stmt)) < 0) {
+		_add_to_backlog(upi, di->stmt, strlen(di->stmt));
+		/* error occur, database connexion need to be closed */
+		di->driver->close_db(upi);
+		return _reconnect_db(upi);
+	}
+
+	return 0;
+}
+
+/* no connection, plugin disabled */
+static int
+_interp_db_disabled(struct ulogd_pluginstance *upi)
+{
+	return 0;
+}
+
+static int
+_reconnect_db(struct ulogd_pluginstance *upi)
 {
 	struct db_instance *di = (struct db_instance *) upi->private;
 
@@ -306,18 +360,137 @@ static int _init_reconnect(struct ulogd_pluginstance *upi)
 			  "no connection to database, attempting to reconnect after %u seconds\n",
 			  reconnect_ce(upi->config_kset).u.value);
 		di->reconnect += reconnect_ce(upi->config_kset).u.value;
-		di->interp = &_init_db;
+		di->interp = &_interp_db_init;
 		return -1;
 	}
 
 	/* Disable plugin permanently */
 	ulogd_log(ULOGD_ERROR, "permanently disabling plugin\n");
-	di->interp = &disabled_interp_db;
+	di->interp = &_interp_db_disabled;
 
 	return 0;
 }
 
-static void __format_query_db(struct ulogd_pluginstance *upi, char *start)
+static int
+_stop_db(struct ulogd_pluginstance *upi)
+{
+	struct db_instance *di = (struct db_instance *) upi->private;
+	ulogd_log(ULOGD_NOTICE, "stopping\n");
+	di->driver->close_db(upi);
+
+	/* try to free the buffer for insert statement */
+	if (di->stmt) {
+		free(di->stmt);
+		di->stmt = NULL;
+	}
+	if (di->ring.size > 0) {
+		pthread_cancel(di->db_thread_id);
+		free(di->ring.ring);
+		pthread_cond_destroy(&di->ring.cond);
+		pthread_mutex_destroy(&di->ring.mutex);
+		di->ring.ring = NULL;
+	}
+	return 0;
+}
+
+static char *
+_format_key(char *key)
+{
+	char *cp = key;
+
+	/* replace all underscores with dots */
+	while ((cp = strchr(cp, '_')))
+		*cp = '.';
+
+	return key;
+}
+
+#define SQL_INSERTTEMPL   "SELECT P(Y)"
+#define SQL_VALSIZE	100
+
+/* create the static part of our insert statement */
+static int
+_create_sql_stmt(struct ulogd_pluginstance *upi)
+{
+	struct db_instance *di = (struct db_instance *) upi->private;
+	unsigned int size;
+	unsigned int i;
+	char *table = table_ce(upi->config_kset).u.string;
+	char *procedure = procedure_ce(upi->config_kset).u.string;
+
+	if (di->stmt)
+		free(di->stmt);
+
+	/* caclulate the size for the insert statement */
+	size = strlen(SQL_INSERTTEMPL) + strlen(table);
+
+	for (i = 0; i < upi->input.num_keys; i++) {
+		if (upi->input.keys[i].flags & ULOGD_KEYF_INACTIVE)
+			continue;
+		/* we need space for the key and a comma, as well as
+		 * enough space for the values */
+		size += strlen(upi->input.keys[i].name) + 1 + SQL_VALSIZE;
+	}
+	size += strlen(procedure);
+
+	ulogd_log(ULOGD_DEBUG, "allocating %u bytes for statement\n", size);
+
+	di->stmt = malloc(size);
+	if (!di->stmt) {
+		ulogd_log(ULOGD_ERROR, "OOM!\n");
+		return -ENOMEM;
+	}
+	di->ring.length = size + 1;
+
+	if (strncasecmp(procedure,"INSERT", strlen("INSERT")) == 0 &&
+	    (procedure[strlen("INSERT")] == '\0' ||
+			procedure[strlen("INSERT")] == ' ')) {
+		char *stmt_val = di->stmt;
+
+		if(procedure[6] == '\0') {
+			/* procedure == "INSERT" */
+			if (di->schema)
+				stmt_val += sprintf(stmt_val,
+						    "insert into %s.%s (",
+						    di->schema, table);
+			else
+				stmt_val += sprintf(stmt_val,
+						    "insert into %s (", table);
+		} else
+			stmt_val += sprintf(stmt_val, "%s (", procedure);
+
+		for (i = 0; i < upi->input.num_keys; i++) {
+			char *underscore;
+
+			if (upi->input.keys[i].flags & ULOGD_KEYF_INACTIVE)
+				continue;
+
+			underscore = stmt_val;
+
+			stmt_val += sprintf(stmt_val, "%s,",
+					    upi->input.keys[i].name);
+
+			while ((underscore = strchr(underscore, '.')))
+				*underscore = '_';
+		}
+		*(stmt_val - 1) = ')';
+
+		sprintf(stmt_val, " values (");
+	} else if (strncasecmp(procedure,"CALL", strlen("CALL")) == 0) {
+		sprintf(di->stmt, "CALL %s(", procedure);
+	} else {
+		sprintf(di->stmt, "SELECT %s(", procedure);
+	}
+
+	di->stmt_offset = strlen(di->stmt);
+
+	ulogd_log(ULOGD_DEBUG, "stmt='%s'\n", di->stmt);
+
+	return 0;
+}
+
+static void
+_bind_sql_stmt(struct ulogd_pluginstance *upi, char *start)
 {
 	struct db_instance *di = (struct db_instance *) &upi->private;
 
@@ -399,7 +572,11 @@ static void __format_query_db(struct ulogd_pluginstance *upi, char *start)
 	*(stmt_ins - 1) = ')';
 }
 
-static int __add_to_backlog(struct ulogd_pluginstance *upi, const char *stmt, unsigned int len)
+/******************************************************************************/
+
+static int
+_add_to_backlog(struct ulogd_pluginstance *upi,
+		const char *stmt, unsigned int len)
 {
 	struct db_instance *di = (struct db_instance *) &upi->private;
 	unsigned int query_size;
@@ -440,40 +617,8 @@ static int __add_to_backlog(struct ulogd_pluginstance *upi, const char *stmt, un
 	return 0;
 }
 
-static int _init_db(struct ulogd_pluginstance *upi)
-{
-	struct db_instance *di = (struct db_instance *) upi->private;
-
-	if (di->reconnect && di->reconnect > time(NULL)) {
-		/* store entry to backlog if it is active */
-		if (di->backlog_memcap && !di->backlog_full) {
-			__format_query_db(upi, di->stmt);
-			__add_to_backlog(upi, di->stmt,
-						strlen(di->stmt));
-		}
-		return 0;
-	}
-
-	if (di->driver->open_db(upi)) {
-		ulogd_log(ULOGD_ERROR, "can't establish database connection\n");
-		if (di->backlog_memcap && !di->backlog_full) {
-			__format_query_db(upi, di->stmt);
-			__add_to_backlog(upi, di->stmt, strlen(di->stmt));
-		}
-		return _init_reconnect(upi);
-	}
-
-	/* enable 'real' logging */
-	di->interp = &__interp_db;
-
-	di->reconnect = 0;
-
-	/* call the interpreter function to actually write the
-	 * log line that we wanted to write */
-	return __interp_db(upi);
-}
-
-static int __treat_backlog(struct ulogd_pluginstance *upi)
+static int
+_process_backlog(struct ulogd_pluginstance *upi)
 {
 	struct db_instance *di = (struct db_instance *) &upi->private;
 	int i = di->backlog_oneshot;
@@ -488,7 +633,7 @@ static int __treat_backlog(struct ulogd_pluginstance *upi)
 		if (di->driver->execute(upi, query->stmt, query->len) < 0) {
 			/* error occur, database connexion need to be closed */
 			di->driver->close_db(upi);
-			return _init_reconnect(upi);
+			return _reconnect_db(upi);
 		} else {
 			di->backlog_memusage -= sizeof(*query) + query->len + 1;
 			llist_del(&query->list);
@@ -501,7 +646,10 @@ static int __treat_backlog(struct ulogd_pluginstance *upi)
 	return 0;
 }
 
-static int __add_to_ring(struct ulogd_pluginstance *upi, struct db_instance *di)
+/******************************************************************************/
+
+static int
+_add_to_ring(struct ulogd_pluginstance *upi, struct db_instance *di)
 {
 	if (*di->ring.wr_place == RING_QUERY_READY) {
 		if (di->ring.full == 0) {
@@ -513,7 +661,7 @@ static int __add_to_ring(struct ulogd_pluginstance *upi, struct db_instance *di)
 		ulogd_log(ULOGD_NOTICE, "Recovered some place in ring\n");
 		di->ring.full = 0;
 	}
-	__format_query_db(upi, di->ring.wr_place + 1);
+	_bind_sql_stmt(upi, di->ring.wr_place + 1);
 	*di->ring.wr_place = RING_QUERY_READY;
 	pthread_cond_signal(&di->ring.cond);
 	di->ring.wr_item ++;
@@ -525,55 +673,8 @@ static int __add_to_ring(struct ulogd_pluginstance *upi, struct db_instance *di)
 	return ULOGD_IRET_OK;
 }
 
-/* our main output function, called by ulogd */
-static int __interp_db(struct ulogd_pluginstance *upi)
-{
-	struct db_instance *di = (struct db_instance *) &upi->private;
-
-	if (di->ring.size)
-		return __add_to_ring(upi, di);
-
-	__format_query_db(upi, di->stmt);
-
-	/* if backup log is not empty we add current query to it */
-	if (!llist_empty(&di->backlog)) {
-		int ret = __add_to_backlog(upi, di->stmt, strlen(di->stmt));
-		if (ret == 0)
-			return __treat_backlog(upi);
-		else {
-			ret = __treat_backlog(upi);
-			if (ret)
-				return ret;
-			/* try adding once the data to backlog */
-			return __add_to_backlog(upi, di->stmt, strlen(di->stmt));
-		}
-	}
-
-	if (di->driver->execute(upi, di->stmt, strlen(di->stmt)) < 0) {
-		__add_to_backlog(upi, di->stmt, strlen(di->stmt));
-		/* error occur, database connexion need to be closed */
-		di->driver->close_db(upi);
-		return _init_reconnect(upi);
-	}
-
-	return 0;
-}
-
-static int __loop_reconnect_db(struct ulogd_pluginstance * upi) {
-	struct db_instance *di = (struct db_instance *) &upi->private;
-
-	di->driver->close_db(upi);
-	while (1) {
-		if (di->driver->open_db(upi)) {
-			sleep(1);
-		} else {
-			return 0;
-		}
-	}
-	return 0;
-}
-
-static void *__inject_thread(void *gdi)
+static void *
+_process_ring(void *gdi)
 {
 	struct ulogd_pluginstance *upi = gdi;
 	struct db_instance *di = (struct db_instance *) &upi->private;
@@ -587,11 +688,11 @@ static void *__inject_thread(void *gdi)
 		while (*wr_place == RING_QUERY_READY) {
 			if (di->driver->execute(upi, wr_place + 1,
 						strlen(wr_place + 1)) < 0) {
-				if (__loop_reconnect_db(upi) != 0) {
+				if (_loop_reconnect_db(upi) != 0) {
 					/* loop has failed on unrecoverable error */
 					ulogd_log(ULOGD_ERROR,
 						  "permanently disabling plugin\n");
-					di->interp = &disabled_interp_db;
+					di->interp = &_interp_db_disabled;
 					return NULL;
 				} else /* try to re run query */
 					continue;
@@ -609,86 +710,18 @@ static void *__inject_thread(void *gdi)
 	return NULL;
 }
 
-
-void ulogd_db_signal(struct ulogd_pluginstance *upi, int signal)
+static int
+_loop_reconnect_db(struct ulogd_pluginstance * upi)
 {
 	struct db_instance *di = (struct db_instance *) &upi->private;
-	switch (signal) {
-	case SIGHUP:
-		if (!di->ring.size) {
-			/* reopen database connection */
-			ulogd_db_instance_stop(upi);
-			ulogd_db_start(upi);
-		} else
-			ulogd_log(ULOGD_ERROR,
-				  "No SIGHUP handling if ring buffer is used\n");
-		break;
-	case SIGTERM:
-	case SIGINT:
-		if (di->ring.size) {
-			int s = pthread_cancel(di->db_thread_id);
-			if (s != 0) {
-				ulogd_log(ULOGD_ERROR,
-					  "Can't cancel injection thread\n");
-				break;
-			}
-			s = pthread_join(di->db_thread_id, NULL);
-			if (s != 0) {
-				ulogd_log(ULOGD_ERROR,
-					  "Error waiting for injection thread"
-					  "cancelation\n");
-			}
-		}
-		break;
-	default:
-		break;
-	}
-}
-
-static char *
-_format_key(char *key)
-{
-	char *cp = key;
-
-	/* replace all underscores with dots */
-	while ((cp = strchr(cp, '_')))
-		*cp = '.';
-
-	return key;
-}
-
-int
-ulogd_db_alloc_input_keys(struct ulogd_pluginstance *upi,
-			  unsigned int num_keys, void *arg)
-{
-	struct db_instance *di = (struct db_instance *) &upi->private;
-	char *(*format_key)(char *) = di->driver->format_key ? : _format_key;
-	unsigned int i;
-
-	if (upi->input.keys)
-		free(upi->input.keys);
 
-	upi->input.num_keys = num_keys;
-	ulogd_log(ULOGD_DEBUG, "%u fields in table\n", upi->input.num_keys);
-	upi->input.keys = calloc(upi->input.num_keys, sizeof(upi->input.keys[0]));
-	if (!upi->input.keys) {
-		upi->input.num_keys = 0;
-		ulogd_log(ULOGD_ERROR, "ENOMEM\n");
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < num_keys; i++) {
-		const char *col = di->driver->get_column(arg, i);
-
-		if (!col)
-			break;
-
-		snprintf(upi->input.keys[i].name,
-			 sizeof(upi->input.keys[i].name),
-			 "%s", col);
-
-		format_key(upi->input.keys[i].name);
+	di->driver->close_db(upi);
+	while (1) {
+		if (di->driver->open_db(upi)) {
+			sleep(1);
+		} else {
+			return 0;
+		}
 	}
-
 	return 0;
 }
-- 
2.35.1

