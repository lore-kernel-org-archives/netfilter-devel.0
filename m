From: Eric Leblond <eric@regit.org>
Subject: [PATCH 04/11] mysql: add sanity checking
Date: Fri, 10 May 2013 08:48:51 +0200
Message-ID: <1368168538-29780-5-git-send-email-eric@regit.org>
References: <1368168538-29780-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:51457 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3EJGtZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 May 2013 02:49:25 -0400
In-Reply-To: <1368168538-29780-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nullify mysql handler at deinit.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 output/mysql/ulogd_output_MYSQL.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/output/mysql/ulogd_output_MYSQL.c b/output/mysql/ulogd_output_MYSQL.c
index 72c080e..0a1ebfc 100644
--- a/output/mysql/ulogd_output_MYSQL.c
+++ b/output/mysql/ulogd_output_MYSQL.c
@@ -162,7 +162,9 @@ static int get_columns_mysql(struct ulogd_pluginstance *upi)
 static int close_db_mysql(struct ulogd_pluginstance *upi)
 {
 	struct mysql_instance *mi = (struct mysql_instance *) upi->private;
-	mysql_close(mi->dbh);
+	if (mi->dbh)
+		mysql_close(mi->dbh);
+	mi->dbh = NULL;
 	return 0;
 }
 
-- 
1.7.10.4

