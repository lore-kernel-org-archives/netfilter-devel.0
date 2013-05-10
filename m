From: Eric Leblond <eric@regit.org>
Subject: [PATCH 06/11] db: store data in memory during database downtime
Date: Fri, 10 May 2013 08:48:53 +0200
Message-ID: <1368168538-29780-7-git-send-email-eric@regit.org>
References: <1368168538-29780-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:51462 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3EJGt1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 May 2013 02:49:27 -0400
In-Reply-To: <1368168538-29780-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch is adding a mechanism to store query in a backlog build
in memory. This allow to store events during downtime in memory and
realize the effective insertion when the database comes back.
A memory cap is used to avoid any memory flooding.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/ulogd/db.h |   34 +++++++++--
 ulogd.conf.in      |    9 +++
 util/db.c          |  170 +++++++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 180 insertions(+), 33 deletions(-)

diff --git a/include/ulogd/db.h b/include/ulogd/db.h
index 1c910ff..a533902 100644
--- a/include/ulogd/db.h
+++ b/include/ulogd/db.h
@@ -20,6 +20,12 @@ struct db_driver {
 			const char *stmt, unsigned int len);
 };
 
+struct db_stmt {
+	char *stmt;
+	int len;
+	struct llist_head list;
+};
+
 struct db_instance {
 	char *stmt; /* buffer for our insert statement */
 	char *stmt_val; /* pointer to the beginning of the "VALUES" part */
@@ -28,9 +34,15 @@ struct db_instance {
 	time_t reconnect;
 	int (*interp)(struct ulogd_pluginstance *upi);
 	struct db_driver *driver;
+	unsigned int backlog_memcap;
+	unsigned int backlog_memusage;
+	unsigned int backlog_oneshot;
+	unsigned char backlog_full;
+	struct llist_head backlog;
 };
 #define TIME_ERR		((time_t)-1)	/* Be paranoid */
 #define RECONNECT_DEFAULT	2
+#define MAX_ONESHOT_REQUEST	10
 
 #define DB_CES							\
 		{						\
@@ -51,13 +63,25 @@ struct db_instance {
 			.key = "procedure",			\
 			.type = CONFIG_TYPE_STRING,		\
 			.options = CONFIG_OPT_MANDATORY,	\
+		},						\
+		{						\
+			.key = "backlog_memcap",		\
+			.type = CONFIG_TYPE_INT,		\
+			.u.value = 0,				\
+		},						\
+		{						\
+			.key = "backlog_oneshot_requests",	\
+			.type = CONFIG_TYPE_INT,		\
+			.u.value = MAX_ONESHOT_REQUEST,		\
 		}
 
-#define DB_CE_NUM	4
-#define table_ce(x)	(x->ces[0])
-#define reconnect_ce(x)	(x->ces[1])
-#define timeout_ce(x)	(x->ces[2])
-#define procedure_ce(x)	(x->ces[3])
+#define DB_CE_NUM		6
+#define table_ce(x)		(x->ces[0])
+#define reconnect_ce(x)		(x->ces[1])
+#define timeout_ce(x)		(x->ces[2])
+#define procedure_ce(x)		(x->ces[3])
+#define backlog_memcap_ce(x)	(x->ces[4])
+#define backlog_oneshot_ce(x)	(x->ces[5])
 
 void ulogd_db_signal(struct ulogd_pluginstance *upi, int signal);
 int ulogd_db_start(struct ulogd_pluginstance *upi);
diff --git a/ulogd.conf.in b/ulogd.conf.in
index f4f63d9..3e5e648 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -207,6 +207,13 @@ user="nupik"
 table="ulog"
 pass="changeme"
 procedure="INSERT_PACKET_FULL"
+# backlog configuration:
+# set backlog_memcap to the size of memory that will be
+# allocated to store events in memory if data is temporary down
+# and insert them when the database came back.
+#backlog_memcap=1000000
+# number of events to insert at once when backlog is not empty
+#backlog_oneshot_requests=10
 
 [mysql2]
 db="nulog"
@@ -224,6 +231,8 @@ table="ulog"
 #schema="public"
 pass="changeme"
 procedure="INSERT_PACKET_FULL"
+#backlog_memcap=1000000
+#backlog_oneshot_requests=10
 
 [pgsql2]
 db="nulog"
diff --git a/util/db.c b/util/db.c
index 0d8b9c1..d125e21 100644
--- a/util/db.c
+++ b/util/db.c
@@ -167,7 +167,22 @@ int ulogd_db_configure(struct ulogd_pluginstance *upi,
 	 * but abort during input key resolving routines.  configure
 	 * doesn't have a destructor... */
 	di->driver->close_db(upi);
+
+	INIT_LLIST_HEAD(&di->backlog);
+	di->backlog_memusage = 0;
 	
+	di->backlog_memcap = backlog_memcap_ce(upi->config_kset).u.value;
+	if (di->backlog_memcap > 0) {
+		di->backlog_oneshot = backlog_oneshot_ce(upi->config_kset).u.value;
+		if (di->backlog_oneshot <= 2) {
+			ulogd_log(ULOGD_ERROR,
+				  "backlog_oneshot_requests must be > 2 to hope"
+				  " cleaning. Setting it to 3.\n");
+			di->backlog_oneshot = 3;
+		}
+		di->backlog_full = 0;
+	}
+
 	return ret;
 }
 
@@ -245,38 +260,15 @@ static int _init_reconnect(struct ulogd_pluginstance *upi)
 	return 0;
 }
 
-static int _init_db(struct ulogd_pluginstance *upi)
-{
-	struct db_instance *di = (struct db_instance *) upi->private;
-
-	if (di->reconnect && di->reconnect > time(NULL))
-		return 0;
-	
-	if (di->driver->open_db(upi)) {
-		ulogd_log(ULOGD_ERROR, "can't establish database connection\n");
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
-
-/* our main output function, called by ulogd */
-static int __interp_db(struct ulogd_pluginstance *upi)
+static void __format_query_db(struct ulogd_pluginstance *upi)
 {
 	struct db_instance *di = (struct db_instance *) &upi->private;
+
 	unsigned int i;
 
 	di->stmt_ins = di->stmt_val;
 
-	for (i = 0; i < upi->input.num_keys; i++) { 
+	for (i = 0; i < upi->input.num_keys; i++) {
 		struct ulogd_key *res = upi->input.keys[i].u.source;
 
 		if (upi->input.keys[i].flags & ULOGD_KEYF_INACTIVE)
@@ -325,8 +317,8 @@ static int __interp_db(struct ulogd_pluginstance *upi)
 		case ULOGD_RET_STRING:
 			*(di->stmt_ins++) = '\'';
 			if (res->u.value.ptr) {
-				di->stmt_ins += 
-				di->driver->escape_string(upi, di->stmt_ins, 
+				di->stmt_ins +=
+				di->driver->escape_string(upi, di->stmt_ins,
 							  res->u.value.ptr,
 							strlen(res->u.value.ptr));
 			}
@@ -347,10 +339,132 @@ static int __interp_db(struct ulogd_pluginstance *upi)
 		di->stmt_ins = di->stmt + strlen(di->stmt);
 	}
 	*(di->stmt_ins - 1) = ')';
+}
+
+static int __add_to_backlog(struct ulogd_pluginstance *upi, const char *stmt, unsigned int len)
+{
+	struct db_instance *di = (struct db_instance *) &upi->private;
+	struct db_stmt *query;
 
+	/* check if we are using backlog */
+	if (di->backlog_memcap == 0)
+		return 0;
+
+	/* check len against backlog */
+	if (len + di->backlog_memusage > di->backlog_memcap) {
+		if (di->backlog_full == 0)
+			ulogd_log(ULOGD_ERROR,
+				  "Backlog is full starting to reject events.\n");
+		di->backlog_full = 1;
+		return -1;
+	}
+
+	query = malloc(sizeof(struct db_stmt));
+	if (query == NULL)
+		return -1;
+
+	query->stmt = strndup(stmt, len);
+	query->len = len;
+
+	if (query->stmt == NULL) {
+		free(query);
+		return -1;
+	}
+
+	di->backlog_memusage += len + sizeof(struct db_stmt);
+	di->backlog_full = 0;
+
+	llist_add_tail(&query->list, &di->backlog);
+
+	return 0;
+}
+
+static int _init_db(struct ulogd_pluginstance *upi)
+{
+	struct db_instance *di = (struct db_instance *) upi->private;
+
+	if (di->reconnect && di->reconnect > time(NULL)) {
+		/* store entry to backlog if it is active */
+		if (di->backlog_memcap && !di->backlog_full) {
+			__format_query_db(upi);
+			__add_to_backlog(upi, di->stmt,
+						strlen(di->stmt));
+		}
+		return 0;
+	}
+
+	if (di->driver->open_db(upi)) {
+		ulogd_log(ULOGD_ERROR, "can't establish database connection\n");
+		if (di->backlog_memcap && !di->backlog_full) {
+			__format_query_db(upi);
+			__add_to_backlog(upi, di->stmt, strlen(di->stmt));
+		}
+		return _init_reconnect(upi);
+	}
+
+	/* enable 'real' logging */
+	di->interp = &__interp_db;
+
+	di->reconnect = 0;
+
+	/* call the interpreter function to actually write the
+	 * log line that we wanted to write */
+	return __interp_db(upi);
+}
+
+static int __treat_backlog(struct ulogd_pluginstance *upi)
+{
+	struct db_instance *di = (struct db_instance *) &upi->private;
+	int i = di->backlog_oneshot;
+	struct db_stmt *query;
+	struct db_stmt *nquery;
+
+	/* Don't try reconnect before timeout */
+	if (di->reconnect && di->reconnect > time(NULL))
+		return 0;
+
+	llist_for_each_entry_safe(query, nquery, &di->backlog, list) {
+		if (di->driver->execute(upi, query->stmt, query->len) < 0) {
+			/* error occur, database connexion need to be closed */
+			di->driver->close_db(upi);
+			return _init_reconnect(upi);
+		} else {
+			di->backlog_memusage -= query->len + sizeof(struct db_stmt);
+			llist_del(&query->list);
+			free(query->stmt);
+			free(query);
+		}
+		if (--i < 0)
+			break;
+	}
+	return 0;
+}
+
+/* our main output function, called by ulogd */
+static int __interp_db(struct ulogd_pluginstance *upi)
+{
+	struct db_instance *di = (struct db_instance *) &upi->private;
+
+
+	__format_query_db(upi);
 	/* now we have created our statement, insert it */
 
+	/* if backup log is not empty we add current query to it */
+	if (! llist_empty(&di->backlog)) {
+		int ret = __add_to_backlog(upi, di->stmt, strlen(di->stmt));
+		if (ret == 0)
+			return __treat_backlog(upi);
+		else {
+			ret = __treat_backlog(upi);
+			if (ret)
+				return ret;
+			/* try adding once the data to backlog */
+			return __add_to_backlog(upi, di->stmt, strlen(di->stmt));
+		}
+	}
+
 	if (di->driver->execute(upi, di->stmt, strlen(di->stmt)) < 0) {
+		__add_to_backlog(upi, di->stmt, strlen(di->stmt));
 		/* error occur, database connexion need to be closed */
 		di->driver->close_db(upi);
 		return _init_reconnect(upi);
-- 
1.7.10.4

