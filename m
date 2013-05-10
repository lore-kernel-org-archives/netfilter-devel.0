From: Eric Leblond <eric@regit.org>
Subject: [PATCH 09/11] db: add ring buffer for DB query
Date: Fri, 10 May 2013 08:48:56 +0200
Message-ID: <1368168538-29780-10-git-send-email-eric@regit.org>
References: <1368168538-29780-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:51468 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3EJGt3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 May 2013 02:49:29 -0400
In-Reply-To: <1368168538-29780-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds an optional ring buffer option which modify
the way database queries are made. The main thread is only handling
kernel message reading and query formatting. The SQL request is made
in a separate dedicated thread.
The idea is to try to avoid buffer overrun by minimizing the time
requested to treat kernel message. Doing synchronous SQL request, as
it was made before was causing a delay which could cause some messages
to be lost in case of burst from kernel side.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 configure.ac       |    2 +
 include/ulogd/db.h |   31 ++++++++++-
 src/Makefile.am    |    2 +-
 ulogd.conf.in      |    4 ++
 util/db.c          |  152 ++++++++++++++++++++++++++++++++++++++++++++++++----
 5 files changed, 178 insertions(+), 13 deletions(-)

diff --git a/configure.ac b/configure.ac
index 7e04531..7351749 100644
--- a/configure.ac
+++ b/configure.ac
@@ -39,6 +39,8 @@ AC_CHECK_FUNCS(socket strerror)
 regular_CFLAGS="-Wall -Wextra -Wno-unused-parameter"
 AC_SUBST([regular_CFLAGS])
 
+AC_CHECK_LIB(pthread, pthread_create)
+
 dnl Check for the right nfnetlink version
 PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.1])
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
diff --git a/include/ulogd/db.h b/include/ulogd/db.h
index 82f37b9..823f462 100644
--- a/include/ulogd/db.h
+++ b/include/ulogd/db.h
@@ -21,6 +21,24 @@ struct db_driver {
 			const char *stmt, unsigned int len);
 };
 
+enum {
+	RING_NO_QUERY,
+	RING_QUERY_READY,
+};
+
+struct db_stmt_ring {
+	/* Ring buffer: 1 status byte + string */
+	char* ring; /* pointer to the ring */
+	uint32_t size; /* size of ring buffer in element */
+	int length; /* length of one ring buffer element */
+	uint32_t wr_item; /* write item in ring buffer */
+	uint32_t rd_item; /* read item in ring buffer */
+	char *wr_place;
+	pthread_cond_t cond;
+	pthread_mutex_t mutex;
+	int full;
+};
+
 struct db_stmt {
 	char *stmt;
 	int len;
@@ -34,6 +52,10 @@ struct db_instance {
 	time_t reconnect;
 	int (*interp)(struct ulogd_pluginstance *upi);
 	struct db_driver *driver;
+	/* DB ring buffer */
+	struct db_stmt_ring ring;
+	pthread_t db_thread_id;
+	/* Backlog system */
 	unsigned int backlog_memcap;
 	unsigned int backlog_memusage;
 	unsigned int backlog_oneshot;
@@ -43,6 +65,7 @@ struct db_instance {
 #define TIME_ERR		((time_t)-1)	/* Be paranoid */
 #define RECONNECT_DEFAULT	2
 #define MAX_ONESHOT_REQUEST	10
+#define RING_BUFFER_DEFAULT_SIZE	10
 
 #define DB_CES							\
 		{						\
@@ -73,15 +96,21 @@ struct db_instance {
 			.key = "backlog_oneshot_requests",	\
 			.type = CONFIG_TYPE_INT,		\
 			.u.value = MAX_ONESHOT_REQUEST,		\
+		},						\
+		{						\
+			.key = "ring_buffer_size",		\
+			.type = CONFIG_TYPE_INT,		\
+			.u.value = RING_BUFFER_DEFAULT_SIZE,	\
 		}
 
-#define DB_CE_NUM		6
+#define DB_CE_NUM		7
 #define table_ce(x)		(x->ces[0])
 #define reconnect_ce(x)		(x->ces[1])
 #define timeout_ce(x)		(x->ces[2])
 #define procedure_ce(x)		(x->ces[3])
 #define backlog_memcap_ce(x)	(x->ces[4])
 #define backlog_oneshot_ce(x)	(x->ces[5])
+#define ringsize_ce(x)		(x->ces[6])
 
 void ulogd_db_signal(struct ulogd_pluginstance *upi, int signal);
 int ulogd_db_start(struct ulogd_pluginstance *upi);
diff --git a/src/Makefile.am b/src/Makefile.am
index e462cb2..1097468 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -8,4 +8,4 @@ sbin_PROGRAMS = ulogd
 
 ulogd_SOURCES = ulogd.c select.c timer.c rbtree.c conffile.c hash.c addr.c
 ulogd_LDADD   = ${libdl_LIBS}
-ulogd_LDFLAGS = -export-dynamic
+ulogd_LDFLAGS = -export-dynamic -lpthread
diff --git a/ulogd.conf.in b/ulogd.conf.in
index 3e5e648..11a56d6 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -233,6 +233,10 @@ pass="changeme"
 procedure="INSERT_PACKET_FULL"
 #backlog_memcap=1000000
 #backlog_oneshot_requests=10
+# If superior to 1 a thread dedicated to SQL request execution
+# is created. The value stores the number of SQL request to keep
+# in the ring buffer
+#ring_buffer_size=1000
 
 [pgsql2]
 db="nulog"
diff --git a/util/db.c b/util/db.c
index 1a11173..4050f0f 100644
--- a/util/db.c
+++ b/util/db.c
@@ -8,6 +8,7 @@
  *           (C) 2005 Sven Schuster <schuster.sven@gmx.de>,
  *           (C) 2005 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
  *           (C) 2008 Eric Leblond <eric@inl.fr>
+ *           (C) 2013 Eric Leblond <eric@regit.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License version 2 
@@ -32,6 +33,7 @@
 #include <arpa/inet.h>
 #include <time.h>
 #include <inttypes.h>
+#include <pthread.h>
 
 #include <ulogd/ulogd.h>
 #include <ulogd/db.h>
@@ -90,6 +92,7 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
 		ulogd_log(ULOGD_ERROR, "OOM!\n");
 		return -ENOMEM;
 	}
+	mi->ring.length = size + 1;
 
 	if (strncasecmp(procedure,"INSERT", strlen("INSERT")) == 0 &&
 	    (procedure[strlen("INSERT")] == '\0' ||
@@ -138,6 +141,8 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
 
 static int _init_db(struct ulogd_pluginstance *upi);
 
+static void *__inject_thread(void *gdi);
+
 int ulogd_db_configure(struct ulogd_pluginstance *upi,
 			struct ulogd_pluginstance_stack *stack)
 {
@@ -185,6 +190,9 @@ int ulogd_db_configure(struct ulogd_pluginstance *upi,
 		di->backlog_full = 0;
 	}
 
+	/* check ring option */
+	di->ring.size = ringsize_ce(upi->config_kset).u.value;
+
 	return ret;
 }
 
@@ -192,6 +200,7 @@ int ulogd_db_start(struct ulogd_pluginstance *upi)
 {
 	struct db_instance *di = (struct db_instance *) upi->private;
 	int ret;
+	unsigned int i;
 
 	ulogd_log(ULOGD_NOTICE, "starting\n");
 
@@ -201,11 +210,51 @@ int ulogd_db_start(struct ulogd_pluginstance *upi)
 
 	ret = sql_createstmt(upi);
 	if (ret < 0)
-		di->driver->close_db(upi);
+		goto db_error;
+
+	if (di->ring.size > 0) {
+		/* allocate */
+		di->ring.ring = calloc(di->ring.size, sizeof(char) * di->ring.length);
+		if (di->ring.ring == NULL) {
+			ret = -1;
+			goto db_error;
+		}
+		di->ring.wr_place = di->ring.ring;
+		ulogd_log(ULOGD_NOTICE,
+			  "Allocating %d elements of size %d for ring\n",
+			  di->ring.size, di->ring.length);
+		/* init start of query for each element */
+		for(i = 0; i < di->ring.size; i++) {
+			strncpy(di->ring.ring + di->ring.length * i + 1,
+				di->stmt,
+				strlen(di->stmt));
+		}
+		/* init cond & mutex */
+		ret = pthread_cond_init(&di->ring.cond, NULL);
+		if (ret != 0)
+			goto alloc_error;
+		ret = pthread_mutex_init(&di->ring.mutex, NULL);
+		if (ret != 0)
+			goto cond_error;
+		/* create thread */
+		ret = pthread_create(&di->db_thread_id, NULL, __inject_thread, upi);
+		if (ret != 0)
+			goto mutex_error;
+	}
 
 	di->interp = &_init_db;
 
 	return ret;
+
+mutex_error:
+	pthread_mutex_destroy(&di->ring.mutex);
+cond_error:
+	pthread_cond_destroy(&di->ring.cond);
+alloc_error:
+	free(di->ring.ring);
+db_error:
+	di->driver->close_db(upi);
+	return ret;
 }
 
 static int ulogd_db_instance_stop(struct ulogd_pluginstance *upi)
@@ -219,7 +268,13 @@ static int ulogd_db_instance_stop(struct ulogd_pluginstance *upi)
 		free(di->stmt);
 		di->stmt = NULL;
 	}
-
+	if (di->ring.size > 0) {
+		pthread_cancel(di->db_thread_id);
+		free(di->ring.ring);
+		pthread_cond_destroy(&di->ring.cond);
+		pthread_mutex_destroy(&di->ring.mutex);
+		di->ring.ring = NULL;
+	}
 	return 0;
 }
 
@@ -262,13 +317,13 @@ static int _init_reconnect(struct ulogd_pluginstance *upi)
 	return 0;
 }
 
-static void __format_query_db(struct ulogd_pluginstance *upi)
+static void __format_query_db(struct ulogd_pluginstance *upi, char *start)
 {
 	struct db_instance *di = (struct db_instance *) &upi->private;
 
 	unsigned int i;
 
-	char * stmt_ins = di->stmt + di->stmt_offset;
+	char * stmt_ins = start + di->stmt_offset;
 
 	for (i = 0; i < upi->input.num_keys; i++) {
 		struct ulogd_key *res = upi->input.keys[i].u.source;
@@ -279,13 +334,13 @@ static void __format_query_db(struct ulogd_pluginstance *upi)
 		if (!res)
 			ulogd_log(ULOGD_NOTICE, "no source for `%s' ?!?\n",
 				  upi->input.keys[i].name);
-			
+
 		if (!res || !IS_VALID(*res)) {
 			/* no result, we have to fake something */
 			stmt_ins += sprintf(stmt_ins, "NULL,");
 			continue;
 		}
-		
+
 		switch (res->type) {
 		case ULOGD_RET_INT8:
 			sprintf(stmt_ins, "%d,", res->u.value.i8);
@@ -338,7 +393,7 @@ static void __format_query_db(struct ulogd_pluginstance *upi)
 				res->type, upi->input.keys[i].name);
 			break;
 		}
-		stmt_ins = di->stmt + strlen(di->stmt);
+		stmt_ins = start + strlen(start);
 	}
 	*(stmt_ins - 1) = ')';
 }
@@ -388,7 +443,7 @@ static int _init_db(struct ulogd_pluginstance *upi)
 	if (di->reconnect && di->reconnect > time(NULL)) {
 		/* store entry to backlog if it is active */
 		if (di->backlog_memcap && !di->backlog_full) {
-			__format_query_db(upi);
+			__format_query_db(upi, di->stmt);
 			__add_to_backlog(upi, di->stmt,
 						strlen(di->stmt));
 		}
@@ -398,7 +453,7 @@ static int _init_db(struct ulogd_pluginstance *upi)
 	if (di->driver->open_db(upi)) {
 		ulogd_log(ULOGD_ERROR, "can't establish database connection\n");
 		if (di->backlog_memcap && !di->backlog_full) {
-			__format_query_db(upi);
+			__format_query_db(upi, di->stmt);
 			__add_to_backlog(upi, di->stmt, strlen(di->stmt));
 		}
 		return _init_reconnect(upi);
@@ -442,14 +497,39 @@ static int __treat_backlog(struct ulogd_pluginstance *upi)
 	return 0;
 }
 
+static int __add_to_ring(struct ulogd_pluginstance *upi, struct db_instance *di)
+{
+	if (*di->ring.wr_place == RING_QUERY_READY) {
+		if (di->ring.full == 0) {
+			ulogd_log(ULOGD_ERROR, "No place left in ring\n");
+			di->ring.full = 1;
+		}
+		return ULOGD_IRET_OK;
+	} else if (di->ring.full) {
+		ulogd_log(ULOGD_NOTICE, "Recovered some place in ring\n");
+		di->ring.full = 0;
+	}
+	__format_query_db(upi, di->ring.wr_place + 1);
+	*di->ring.wr_place = RING_QUERY_READY;
+	pthread_cond_signal(&di->ring.cond);
+	di->ring.wr_item ++;
+	di->ring.wr_place += di->ring.length;
+	if (di->ring.wr_item == di->ring.size) {
+		di->ring.wr_item = 0;
+		di->ring.wr_place = di->ring.ring;
+	}
+	return ULOGD_IRET_OK;
+}
+
 /* our main output function, called by ulogd */
 static int __interp_db(struct ulogd_pluginstance *upi)
 {
 	struct db_instance *di = (struct db_instance *) &upi->private;
 
+	if (di->ring.size)
+		return __add_to_ring(upi, di);
 
-	__format_query_db(upi);
-	/* now we have created our statement, insert it */
+	__format_query_db(upi, di->stmt);
 
 	/* if backup log is not empty we add current query to it */
 	if (! llist_empty(&di->backlog)) {
@@ -475,6 +555,56 @@ static int __interp_db(struct ulogd_pluginstance *upi)
 	return 0;
 }
 
+static int __loop_reconnect_db(struct ulogd_pluginstance * upi) {
+	struct db_instance *di = (struct db_instance *) &upi->private;
+
+	di->driver->close_db(upi);
+	while (1) {
+		if (di->driver->open_db(upi)) {
+			sleep(1);
+		} else {
+			return 0;
+		}
+	}
+	return 0;
+}
+
+static void *__inject_thread(void *gdi)
+{
+	struct ulogd_pluginstance *upi = (struct ulogd_pluginstance *) gdi;
+	struct db_instance *di = (struct db_instance *) &upi->private;
+	char *wr_place;
+
+	wr_place = di->ring.ring;
+	pthread_mutex_lock(&di->ring.mutex);
+	while(1) {
+		/* wait cond */
+		pthread_cond_wait(&di->ring.cond, &di->ring.mutex);
+		while (*wr_place == RING_QUERY_READY) {
+			if (di->driver->execute(upi, wr_place + 1,
+						strlen(wr_place + 1)) < 0) {
+				if (__loop_reconnect_db(upi) != 0) {
+					/* loop has failed on unrecoverable error */
+					ulogd_log(ULOGD_ERROR,
+						  "permanently disabling plugin\n");
+					di->interp = &disabled_interp_db;
+					return NULL;
+				}
+			}
+			*wr_place = RING_NO_QUERY;
+			di->ring.rd_item++;
+			if (di->ring.rd_item == di->ring.size) {
+				di->ring.rd_item = 0;
+				wr_place = di->ring.ring;
+			} else
+				wr_place += di->ring.length;
+		}
+	}
+
+	return NULL;
+}
+
+
 void ulogd_db_signal(struct ulogd_pluginstance *upi, int signal)
 {
 	switch (signal) {
-- 
1.7.10.4

