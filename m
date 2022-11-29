Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55762C4708E
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 21:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236799AbiK2V5b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236910AbiK2V5O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 16:57:14 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3636E54C
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 13:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pBsg/eKR+OF4D9OmWNd7sRL81NqJ1TOrU/tzje1pcUY=; b=k7hAHGNJETBDYQhHDcqA4G7dTt
        II4nGNN6Y4v0Wt79HEIX4s6Y7NFXTm6v9+IhZEwTRxtw94uMgjVkaejdLdBqMWHziP4Gyk75kxl2X
        UDmvoonTjvW5yEbCxyaNMsfCPSMYXIccC2ZrRnnA5x8rEtWQ9y44XYDACspqiDqdi61FedkM6G7w+
        Bk5pQEDUIAqyOYtwSdPbB8DAouETA5UqjwsH+ILO7NTpOuUT4NdCi6cysMmyJIwtVfjp6P/Rx6/XK
        i9Te8oM/x/KpQdmXlB0M3N5IWmJp+rFF+CzP4hGgUK39FC4Ppcn6rO0giMVFTCNK3UzTzPYBfgYf6
        GSmFHXfw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p08SM-00DjQp-60
        for netfilter-devel@vger.kernel.org; Tue, 29 Nov 2022 21:47:58 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v2 v2 28/34] db: add prep & exec support
Date:   Tue, 29 Nov 2022 21:47:43 +0000
Message-Id: <20221129214749.247878-29-jeremy@azazel.net>
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

Currently, the common DB API pre-allocates the prefix of the SQL
statement, e.g.:

  insert into t (col1, col2, col3, col4) values (

and concatenates the literal values for each packet before executing the
statement.  However, this requires escaping these values, which is not
supported by all DB API's.  Furthermore, most data-bases offer the
ability to prepare statements with place-holders and bind values before
executing them since this avoids the need to analyse and optimize the
statement on every execution, and can, therefore, be more efficient.

Add the infrastructure to allow output plug-ins to prep & exec if the
data-base supports it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/ulogd/db.h |  33 ++++++
 util/db.c          | 286 ++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 287 insertions(+), 32 deletions(-)

diff --git a/include/ulogd/db.h b/include/ulogd/db.h
index 17eaa7cf60db..602ab25dc1b2 100644
--- a/include/ulogd/db.h
+++ b/include/ulogd/db.h
@@ -9,6 +9,7 @@
 #ifndef _ULOGD_DB_H
 #define _ULOGD_DB_H
 
+#include <stdbool.h>
 #include <ulogd/ulogd.h>
 
 struct db_stmt;
@@ -18,12 +19,15 @@ struct db_driver {
 	int (*get_columns)(struct ulogd_pluginstance *upi);
 	const char *(*get_column)(void *, unsigned int);
 	char *(*format_key)(char *);
+	unsigned int (*format_param)(char *, unsigned int, unsigned int);
 
 	int (*open_db)(struct ulogd_pluginstance *upi);
 	int (*close_db)(struct ulogd_pluginstance *upi);
 
 	int (*escape_string)(struct ulogd_pluginstance *upi,
 			     char *dst, const char *src, unsigned int len);
+	int (*prepare)(struct ulogd_pluginstance *upi,
+		       const struct db_stmt *stmt);
 	int (*execute)(struct ulogd_pluginstance *upi,
 		       const struct db_stmt *stmt);
 
@@ -63,9 +67,34 @@ struct db_stmt_backlog {
 
 };
 
+union db_stmt_arg_value {
+	uint8_t   b;
+	uint8_t   ui8;
+	uint16_t  ui16;
+	uint32_t  ui32;
+	uint64_t  ui64;
+	int8_t    i8;
+	int16_t   i16;
+	int32_t   i32;
+	int64_t   i64;
+	void     *ptr;
+};
+
+struct db_stmt_arg {
+	uint32_t len;
+	uint16_t type;
+	bool null;
+	union db_stmt_arg_value value;
+};
+
 struct db_stmt {
+
+	struct db_stmt_arg *args;
+	unsigned int nr_params;
+
 	unsigned int len, size;
 	char sql[];
+
 };
 
 struct db_stmt_item {
@@ -74,15 +103,19 @@ struct db_stmt_item {
 };
 
 struct db_instance {
+
 	struct db_stmt *stmt; /* buffer for our insert statement */
 	char *schema;
 	time_t reconnect;
 	int (*interp)(struct ulogd_pluginstance *upi);
 	struct db_driver *driver;
+
 	/* DB ring buffer */
 	struct db_stmt_ring ring;
+
 	/* Backlog system */
 	struct db_stmt_backlog backlog;
+
 };
 
 #define RECONNECT_DEFAULT	2
diff --git a/util/db.c b/util/db.c
index 271cd25efeaf..dafa9aa621a4 100644
--- a/util/db.c
+++ b/util/db.c
@@ -52,9 +52,21 @@ static int _create_sql_stmt(struct ulogd_pluginstance *upi);
 static unsigned int _calc_sql_stmt_size(const char *procedure,
 					const char *schema, const char *table,
 					struct ulogd_key *keys,
-					unsigned int num_keys);
-static void _bind_sql_stmt(struct ulogd_pluginstance *upi,
-			   struct db_stmt *stmt);
+					unsigned int num_keys,
+					unsigned int (*format_param)(char *,
+								     unsigned int,
+								     unsigned int));
+static bool _key_supported(const struct ulogd_key *key);
+static bool _key_type_supported(uint16_t key_type);
+static unsigned int _format_param(char *buf, unsigned int size,
+				  unsigned int idx);
+static int _bind_sql_stmt(struct ulogd_pluginstance *upi,
+			  struct db_stmt *stmt);
+static int _copy_sql_stmt_args(struct ulogd_pluginstance *upi,
+			       struct db_stmt *stmt);
+static void _concat_sql_stmt_args(struct ulogd_pluginstance *upi,
+				  struct db_stmt *stmt);
+static void _free_sql_stmt_args(struct db_stmt *stmt);
 
 static int _configure_backlog(struct ulogd_pluginstance *upi);
 static int _add_to_backlog(struct ulogd_pluginstance *upi,
@@ -254,7 +266,8 @@ _interp_db_init(struct ulogd_pluginstance *upi)
 	if (di->reconnect && di->reconnect > time(NULL)) {
 		/* store entry to backlog if it is active */
 		if (di->backlog.memcap && !di->backlog.full) {
-			_bind_sql_stmt(upi, di->stmt);
+			if (_bind_sql_stmt(upi, di->stmt) < 0)
+				return ULOGD_IRET_ERR;
 			_add_to_backlog(upi, di->stmt);
 		}
 		return ULOGD_IRET_OK;
@@ -263,14 +276,19 @@ _interp_db_init(struct ulogd_pluginstance *upi)
 	if (di->driver->open_db(upi) < 0) {
 		ulogd_log(ULOGD_ERROR, "can't establish database connection\n");
 		if (di->backlog.memcap && !di->backlog.full) {
-			_bind_sql_stmt(upi, di->stmt);
-			_add_to_backlog(upi, di->stmt);
+			if (_bind_sql_stmt(upi, di->stmt) == 0)
+				_add_to_backlog(upi, di->stmt);
 		}
 		if (_reconnect_db(upi) < 0)
 			return ULOGD_IRET_ERR;
 		return ULOGD_IRET_OK;
 	}
 
+	if (di->driver->prepare) {
+		if (di->driver->prepare(upi, di->stmt) < 0)
+			return ULOGD_IRET_ERR;
+	}
+
 	/* enable 'real' logging */
 	di->interp = &_interp_db_main;
 
@@ -293,7 +311,8 @@ _interp_db_main(struct ulogd_pluginstance *upi)
 		return ULOGD_IRET_OK;
 	}
 
-	_bind_sql_stmt(upi, di->stmt);
+	if (_bind_sql_stmt(upi, di->stmt) < 0)
+		return ULOGD_IRET_ERR;
 
 	/* if backup log is not empty we add current statement to it */
 	if (!llist_empty(&di->backlog.items)) {
@@ -393,6 +412,10 @@ static int
 _create_sql_stmt(struct ulogd_pluginstance *upi)
 {
 	struct db_instance *di = (struct db_instance *) upi->private;
+	unsigned int (*format_param)(char *, unsigned int, unsigned int)
+		= di->driver->prepare != NULL
+		? di->driver->format_param ? : _format_param
+		: NULL;
 	char *procedure = procedure_ce(upi->config_kset).u.string;
 	char *table = table_ce(upi->config_kset).u.string;
 	unsigned int size;
@@ -404,7 +427,8 @@ _create_sql_stmt(struct ulogd_pluginstance *upi)
 
 	/* calculate the size for the insert statement */
 	size = _calc_sql_stmt_size(procedure, di->schema, table,
-				   upi->input.keys, upi->input.num_keys);
+				   upi->input.keys, upi->input.num_keys,
+				   format_param);
 
 	ulogd_log(ULOGD_DEBUG, "allocating %u bytes for statement\n", size);
 
@@ -433,15 +457,15 @@ _create_sql_stmt(struct ulogd_pluginstance *upi)
 			sqlp += sprintf(sqlp, "%s (", procedure);
 
 		for (i = 0; i < upi->input.num_keys; i++) {
+			struct ulogd_key *key = &upi->input.keys[i];
 			char *underscore;
 
-			if (upi->input.keys[i].flags & ULOGD_KEYF_INACTIVE)
+			if (!_key_supported(key))
 				continue;
 
 			underscore = sqlp;
 
-			sqlp += sprintf(sqlp, "%s,",
-					upi->input.keys[i].name);
+			sqlp += sprintf(sqlp, "%s,", key->name);
 
 			while ((underscore = strchr(underscore, '.')))
 				*underscore = '_';
@@ -457,6 +481,29 @@ _create_sql_stmt(struct ulogd_pluginstance *upi)
 
 	di->stmt->len = sqlp - di->stmt->sql;
 
+	if (di->driver->prepare) {
+		unsigned int size, nr_params = 0;
+
+		sqlp = di->stmt->sql  + di->stmt->len;
+		size = di->stmt->size - di->stmt->len;
+
+		for (i = 0; i < upi->input.num_keys; i++) {
+			unsigned int used;
+
+			if (!_key_supported(&upi->input.keys[i]))
+				continue;
+
+			used = format_param(sqlp, size, nr_params++);
+
+			sqlp += used;
+			size -= used;
+		}
+		strcpy(sqlp - 1, ")");
+
+		di->stmt->len = sqlp - di->stmt->sql;
+		di->stmt->nr_params = nr_params;
+	}
+
 	ulogd_log(ULOGD_DEBUG, "stmt='%s'\n", di->stmt->sql);
 
 	return 0;
@@ -467,7 +514,9 @@ _create_sql_stmt(struct ulogd_pluginstance *upi)
 static unsigned int
 _calc_sql_stmt_size(const char *procedure,
 		    const char *schema, const char *table,
-		    struct ulogd_key *keys, unsigned int num_keys)
+		    struct ulogd_key *keys, unsigned int num_keys,
+		    unsigned int (*format_param)(char *, unsigned int,
+						 unsigned int))
 {
 	unsigned int i, size = 0;
 	bool include_keys;
@@ -516,11 +565,32 @@ _calc_sql_stmt_size(const char *procedure,
 	 */
 
 	for (i = 0; i < num_keys; i++) {
-		if (keys[i].flags & ULOGD_KEYF_INACTIVE)
+		struct ulogd_key *key = &keys[i], *res = key->u.source;
+
+		if (key->flags & ULOGD_KEYF_INACTIVE)
+			continue;
+
+		if (!res)
+			continue;
+
+		if (!_key_type_supported(res->type)) {
+			if (res->type == ULOGD_RET_RAW)
+				ulogd_log(ULOGD_NOTICE,
+					  "RAW type is unsupported in SQL output\n");
+			else
+				ulogd_log(ULOGD_NOTICE,
+					  "Unknown type %d for %s\n",
+					  res->type, key->name);
 			continue;
+		}
+
 		if (include_keys)
-			size += strlen(keys[i].name) + 1;
-		size += SQL_VALSIZE + 1;
+			size += strlen(key->name) + 1;
+
+		if (format_param)
+			size += format_param(NULL, 0, i);
+		else
+			size += SQL_VALSIZE + 1;
 	}
 
 	size++; /* Allow for the final NUL */
@@ -528,24 +598,149 @@ _calc_sql_stmt_size(const char *procedure,
 	return size;
 }
 
-static void
+static bool
+_key_supported(const struct ulogd_key *key)
+{
+	if (key->flags & ULOGD_KEYF_INACTIVE)
+		return false;
+
+	if (!key->u.source)
+		return false;
+
+	return _key_type_supported(key->u.source->type);
+}
+
+static bool
+_key_type_supported(uint16_t key_type)
+{
+	switch (key_type) {
+	case ULOGD_RET_BOOL:
+	case ULOGD_RET_UINT8:
+	case ULOGD_RET_UINT16:
+	case ULOGD_RET_IPADDR:
+	case ULOGD_RET_UINT32:
+	case ULOGD_RET_UINT64:
+	case ULOGD_RET_INT8:
+	case ULOGD_RET_INT16:
+	case ULOGD_RET_INT32:
+	case ULOGD_RET_INT64:
+	case ULOGD_RET_STRING:
+	case ULOGD_RET_RAWSTR:
+		return true;
+	default:
+		return false;;
+	}
+}
+
+static unsigned int
+_format_param(char *buf, unsigned int size,
+	      unsigned int idx __attribute__ ((unused)))
+{
+	return snprintf(buf, size, "?,");
+}
+
+static int
 _bind_sql_stmt(struct ulogd_pluginstance *upi, struct db_stmt *stmt)
+{
+	struct db_instance *di = (struct db_instance *) &upi->private;
+
+	if (di->driver->prepare)
+		return _copy_sql_stmt_args(upi, stmt);
+
+	_concat_sql_stmt_args(upi, stmt);
+	return 0;
+}
+
+static int
+_copy_sql_stmt_args(struct ulogd_pluginstance *upi, struct db_stmt *stmt)
+{
+	struct db_stmt_arg *stmt_args;
+	unsigned int i, j;
+
+	stmt_args = calloc(stmt->nr_params, sizeof(*stmt_args));
+	if (!stmt_args)
+		return -1;
+
+	for (i = 0, j = 0; i < upi->input.num_keys; i++) {
+		struct ulogd_key *key = &upi->input.keys[i],
+				 *res = key->u.source;
+		struct db_stmt_arg *arg = &stmt_args[j];
+		union db_stmt_arg_value *val = &arg->value;
+
+		if (!_key_supported(key))
+			continue;
+
+		if (!IS_VALID(*res))
+			arg->null = true;
+		else {
+			arg->type = res->type;
+
+			switch (res->type) {
+			case ULOGD_RET_BOOL:
+			case ULOGD_RET_UINT8:
+			case ULOGD_RET_UINT16:
+			case ULOGD_RET_IPADDR:
+			case ULOGD_RET_UINT32:
+			case ULOGD_RET_UINT64:
+			case ULOGD_RET_INT8:
+			case ULOGD_RET_INT16:
+			case ULOGD_RET_INT32:
+			case ULOGD_RET_INT64:
+				memcpy(val, &res->u.value, sizeof(*val));
+				break;
+			case ULOGD_RET_STRING:
+				if (!res->u.value.ptr)
+					continue;
+				arg->len = strlen(res->u.value.ptr);
+				val->ptr = strdup(res->u.value.ptr);
+				if (!val->ptr)
+					goto err_free_args;
+				break;
+			case ULOGD_RET_RAWSTR:
+				if (!res->u.value.ptr)
+					continue;
+				arg->len = res->len;
+				val->ptr = malloc(res->len);
+				if (!val->ptr)
+					goto err_free_args;
+				memcpy(val->ptr, res->u.value.ptr, res->len);
+				break;
+			}
+		}
+
+		j++;
+	}
+
+	stmt->args = stmt_args;
+	return 0;
+
+err_free_args:
+	while (i-- > 0)
+		switch(stmt_args[i].type) {
+		case ULOGD_RET_STRING:
+		case ULOGD_RET_RAWSTR:
+			free (stmt_args[i].value.ptr);
+			break;
+		}
+	free (stmt_args);
+	return -1;
+}
+
+static void
+_concat_sql_stmt_args(struct ulogd_pluginstance *upi, struct db_stmt *stmt)
 {
 	struct db_instance *di = (struct db_instance *) &upi->private;
 	char *sqlp = stmt->sql + stmt->len;
 	unsigned int i;
 
 	for (i = 0; i < upi->input.num_keys; i++) {
-		struct ulogd_key *res = upi->input.keys[i].u.source;
+		struct ulogd_key *key = &upi->input.keys[i],
+				 *res = key->u.source;
 
-		if (upi->input.keys[i].flags & ULOGD_KEYF_INACTIVE)
+		if (!_key_supported(key))
 			continue;
 
-		if (!res)
-			ulogd_log(ULOGD_NOTICE, "no source for `%s' ?!?\n",
-				  upi->input.keys[i].name);
-
-		if (!res || !IS_VALID(*res)) {
+		if (!IS_VALID(*res)) {
 			/* no result, we have to fake something */
 			sqlp += sprintf(sqlp, "NULL,");
 			continue;
@@ -604,14 +799,7 @@ _bind_sql_stmt(struct ulogd_pluginstance *upi, struct db_stmt *stmt)
 			}
 			*sqlp++ = ',';
 			break;
-		case ULOGD_RET_RAW:
-			ulogd_log(ULOGD_NOTICE,
-				"Unsupported RAW type is unsupported in SQL output");
-			break;
 		default:
-			ulogd_log(ULOGD_NOTICE,
-				"unknown type %d for %s\n",
-				res->type, upi->input.keys[i].name);
 			break;
 		}
 	}
@@ -620,6 +808,28 @@ _bind_sql_stmt(struct ulogd_pluginstance *upi, struct db_stmt *stmt)
 	stmt->len = sqlp - stmt->sql;
 }
 
+static void
+_free_sql_stmt_args(struct db_stmt *stmt)
+{
+	unsigned int i;
+
+	if (stmt->nr_params == 0)
+		return;
+
+	if (!stmt->args)
+		return;
+
+	for(i = 0; i < stmt->nr_params; ++i)
+		switch(stmt->args[i].type) {
+		case ULOGD_RET_STRING:
+		case ULOGD_RET_RAWSTR:
+			free(stmt->args[i].value.ptr);
+			break;
+		}
+	free(stmt->args);
+	stmt->args = NULL;
+}
+
 /******************************************************************************/
 
 static int
@@ -708,6 +918,7 @@ _process_backlog(struct ulogd_pluginstance *upi)
 		}
 
 		di->backlog.memusage -= sizeof(*item) + item->stmt.size;
+		_free_sql_stmt_args(&item->stmt);
 		llist_del(&item->list);
 		free(item);
 
@@ -797,6 +1008,7 @@ static int
 _add_to_ring(struct ulogd_pluginstance *upi)
 {
 	struct db_instance *di = (struct db_instance *) &upi->private;
+	int rv = ULOGD_IRET_OK;
 
 	pthread_mutex_lock(&di->ring.mutex);
 
@@ -813,14 +1025,18 @@ _add_to_ring(struct ulogd_pluginstance *upi)
 		di->ring.full = 0;
 	}
 
-	_bind_sql_stmt(upi, _get_ring_elem(&di->ring, di->ring.wr_idx));
+	if (_bind_sql_stmt(upi, _get_ring_elem(&di->ring,
+					       di->ring.wr_idx)) < 0) {
+		rv = ULOGD_IRET_ERR;
+		goto unlock_mutex;
+	}
 	_incr_ring_used(&di->ring, 1);
 
 	pthread_cond_signal(&di->ring.cond);
 unlock_mutex:
 	pthread_mutex_unlock(&di->ring.mutex);
 
-	return ULOGD_IRET_OK;
+	return rv;
 }
 
 static void *
@@ -848,6 +1064,7 @@ exec_stmt:
 
 				pthread_mutex_lock(&di->ring.mutex);
 
+				_free_sql_stmt_args(stmt);
 				_incr_ring_used(&di->ring, -1);
 
 				continue;
@@ -858,12 +1075,17 @@ exec_stmt:
 			 * open it again.  Once the connexion is made, retry the
 			 * statement.
 			 */
+close_db:
 			di->driver->close_db(upi);
 			while (!di->ring.shut_down) {
 				if (di->driver->open_db(upi) < 0) {
 					sleep(1);
 					continue;
 				}
+				if (di->driver->prepare) {
+					if (di->driver->prepare(upi, stmt) < 0)
+						goto close_db;
+				}
 				goto exec_stmt;
 			}
 
-- 
2.35.1

