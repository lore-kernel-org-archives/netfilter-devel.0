From: Alex Xu <alex_y_xu@yahoo.ca>
Subject: [PATCH] sqlite3: Remove unused "buffer" option.
Date: Fri,  1 Jan 2016 12:05:42 -0500
Message-ID: <1451667942-30746-1-git-send-email-alex_y_xu@yahoo.ca>
Cc: laforge@gnumonks.org, pablo@netfilter.org, eric@regit.org,
	Alex Xu <alex_y_xu@yahoo.ca>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nm14-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.164]:49815 "EHLO
	nm14-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922AbcAARMP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jan 2016 12:12:15 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 doc/ulogd.sgml                        |  2 --
 output/sqlite3/ulogd_output_SQLITE3.c | 17 +----------------
 ulogd.conf.in                         |  2 --
 3 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/doc/ulogd.sgml b/doc/ulogd.sgml
index 30bfecb..65a63cf 100644
--- a/doc/ulogd.sgml
+++ b/doc/ulogd.sgml
@@ -603,8 +603,6 @@ The module defines the following configuration directives:
 Name of the table to which ulogd should log.
 <tag>db</tag>
 Name of the database.
-<tag>buffer</tag>
-Size of the sqlite buffer.
 </descrip>
 </sect2>
 
diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_output_SQLITE3.c
index 5c49055..20ceb3b 100644
--- a/output/sqlite3/ulogd_output_SQLITE3.c
+++ b/output/sqlite3/ulogd_output_SQLITE3.c
@@ -63,8 +63,6 @@ struct sqlite3_priv {
 	struct field_lh fields;
 	char *stmt;
 	sqlite3_stmt *p_stmt;
-	int buffer_size;
-	int buffer_curr;
 	struct {
 		unsigned err_tbl_busy;	/* "Table busy" */
 	} stats;
@@ -83,18 +81,11 @@ static struct config_keyset sqlite3_kset = {
 			.type = CONFIG_TYPE_STRING,
 			.options = CONFIG_OPT_MANDATORY,
 		},
-		{
-			.key = "buffer",
-			.type = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = CFG_BUFFER_DEFAULT,
-		},
 	},
 };
 
 #define db_ce(pi)		(pi)->config_kset->ces[0].u.string
 #define table_ce(pi)	(pi)->config_kset->ces[1].u.string
-#define buffer_ce(pi)	(pi)->config_kset->ces[2].u.value
 
 /* forward declarations */
 static int sqlite3_createstmt(struct ulogd_pluginstance *);
@@ -107,9 +98,7 @@ add_row(struct ulogd_pluginstance *pi)
 	int ret;
 
 	ret = sqlite3_step(priv->p_stmt);
-	if (ret == SQLITE_DONE)
-		priv->buffer_curr++;
-	else if (ret == SQLITE_BUSY)
+	if (ret == SQLITE_BUSY)
 		priv->stats.err_tbl_busy++;
 	else if (ret == SQLITE_ERROR) {
 		ret = sqlite3_finalize(priv->p_stmt);
@@ -404,10 +393,6 @@ sqlite3_start(struct ulogd_pluginstance *pi)
 		return -1;
 	}
 
-	/* initialize our buffer size and counter */
-	priv->buffer_size = buffer_ce(pi);
-	priv->buffer_curr = 0;
-
 	/* create and prepare the actual insert statement */
 	sqlite3_createstmt(pi);
 
diff --git a/ulogd.conf.in b/ulogd.conf.in
index 9624a4b..2fcf39a 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -301,12 +301,10 @@ procedure="INSERT_PACKET_FULL"
 [sqlite3_ct]
 table="ulog_ct"
 db="/var/log/ulogd.sqlite3db"
-buffer=200
 
 [sqlite3_pkt]
 table="ulog_pkt"
 db="/var/log/ulogd.sqlite3db"
-buffer=200
 
 [sys2]
 facility=LOG_LOCAL2
-- 
2.6.4

