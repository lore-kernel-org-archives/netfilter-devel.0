From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 01/14] Fix SQL reconnection algorithm.
Date: Sun, 23 Mar 2008 17:25:09 +0100
Message-ID: <12062895222895-git-send-email-eric@inl.fr>
References: <1206289522679-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:55040 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752359AbYCWQZZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Mar 2008 12:25:25 -0400
In-Reply-To: <1206289522679-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes a problem in SQL reconnection algorithm which is managed in
the db.c file for PgSQL and MySQL. In case of problem during request execution
a new connection to the database was immediatly started without closing the
previous one. The consequence was to block the database by having too much
simultaneous open connections.

This patch fixes the problem by disconnectinng from the database after a
request failure and trying to reconnect after a delay which is by default
of 2 secondes. This delay can be customized via the reconnect configuration
variable in the database configuration section.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 include/ulogd/db.h |    2 ++
 util/db.c          |    9 +++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/ulogd/db.h b/include/ulogd/db.h
index 94cdbcb..62819f2 100644
--- a/include/ulogd/db.h
+++ b/include/ulogd/db.h
@@ -23,6 +23,7 @@ struct db_instance {
 	struct db_driver *driver;
 };
 #define TIME_ERR		((time_t)-1)	/* Be paranoid */
+#define RECONNECT_DEFAULT	2
 
 #define DB_CES							\
 		{						\
@@ -33,6 +34,7 @@ struct db_instance {
 		{						\
 			.key = "reconnect",			\
 			.type = CONFIG_TYPE_INT,		\
+			.u.value = RECONNECT_DEFAULT,		\
 		},						\
 		{						\
 			.key = "ip_as_string",			\
diff --git a/util/db.c b/util/db.c
index 49f6c29..b9ca8db 100644
--- a/util/db.c
+++ b/util/db.c
@@ -176,6 +176,8 @@ static int _init_reconnect(struct ulogd_pluginstance *upi)
 	struct db_instance *di = (struct db_instance *) upi->private;
 
 	if (reconnect_ce(upi->config_kset).u.value) {
+		if (time(NULL) < di->reconnect)
+			return -1;
 		di->reconnect = time(NULL);
 		if (di->reconnect != TIME_ERR) {
 			ulogd_log(ULOGD_ERROR, "no connection to database, "
@@ -312,8 +314,11 @@ static int __interp_db(struct ulogd_pluginstance *upi)
 
 	/* now we have created our statement, insert it */
 
-	if (di->driver->execute(upi, di->stmt, strlen(di->stmt)) < 0)
-		return _init_db(upi);
+	if (di->driver->execute(upi, di->stmt, strlen(di->stmt)) < 0) {
+		/* error occur, database connexion need to be closed */
+		di->driver->close_db(upi);
+		return _init_reconnect(upi);
+	}
 
 	return 0;
 }
-- 
1.5.2.5

