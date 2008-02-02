From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 15/34]  MySQL client library does not reconnect automatically since 5.0.
Date: Sat,  2 Feb 2008 22:24:10 +0100
Message-ID: <12019874703897-git-send-email-eric@inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr>
 <1201987469368-git-send-email-eric@inl.fr>
 <12019874692227-git-send-email-eric@inl.fr>
 <12019874701613-git-send-email-eric@inl.fr>
 <12019874702005-git-send-email-eric@inl.fr>
 <12019874703998-git-send-email-eric@inl.fr>
 <12019874701589-git-send-email-eric@inl.fr>
 <12019874701366-git-send-email-eric@inl.fr>
 <12019874704144-git-send-email-eric@inl.fr>
 <12019874703136-git-send-email-eric@inl.fr>
 <12019874701552-git-send-email-eric@inl.fr>
 <12019874701370-git-send-email-eric@inl.fr>
 <12019874702349-git-send-email-eric@inl.fr>
 <12019874703504-git-send-email-eric@inl.fr>
 <12019874704067-git-send-email-eric@inl.fr>
Cc: Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46042 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762283AbYBBWQP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:16:15 -0500
In-Reply-To: <12019874704067-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric leblond <eric@inl.fr>

This patch restores the reconnection functionnality for the mysql output plugin.

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 1826c03... 800d79d... M	output/mysql/ulogd_output_MYSQL.c
 output/mysql/ulogd_output_MYSQL.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/output/mysql/ulogd_output_MYSQL.c b/output/mysql/ulogd_output_MYSQL.c
index 1826c03..800d79d 100644
--- a/output/mysql/ulogd_output_MYSQL.c
+++ b/output/mysql/ulogd_output_MYSQL.c
@@ -180,6 +180,9 @@ static int open_db_mysql(struct ulogd_pluginstance *upi)
 	char *user = user_ce(upi->config_kset).u.string;
 	char *pass = pass_ce(upi->config_kset).u.string;
 	char *db = db_ce(upi->config_kset).u.string;
+#ifdef MYSQL_OPT_RECONNECT
+	my_bool trueval = 1;
+#endif 
 
 	mi->dbh = mysql_init(NULL);
 	if (!mi->dbh) {
@@ -190,6 +193,11 @@ static int open_db_mysql(struct ulogd_pluginstance *upi)
 	if (connect_timeout)
 		mysql_options(mi->dbh, MYSQL_OPT_CONNECT_TIMEOUT, 
 			      (const char *) &connect_timeout);
+#ifdef MYSQL_OPT_RECONNECT
+#  if defined(MYSQL_VERSION_ID) && (MYSQL_VERSION_ID >= 50019)
+	mysql_options(mi->dbh, MYSQL_OPT_RECONNECT, &trueval);
+#  endif
+#endif 
 
 	if (!mysql_real_connect(mi->dbh, server, user, pass, db, port, NULL, 0)) {
 		ulogd_log(ULOGD_ERROR, "can't connect to db: %s\n",
@@ -197,6 +205,12 @@ static int open_db_mysql(struct ulogd_pluginstance *upi)
 		return -1;
 	}
 		
+#ifdef MYSQL_OPT_RECONNECT
+#  if defined(MYSQL_VERSION_ID) && (MYSQL_VERSION_ID < 50019)
+	mysql_options(mi->dbh, MYSQL_OPT_RECONNECT, &trueval);
+#  endif
+#endif
+
 	return 0;
 }
 
-- 
1.5.2.5

