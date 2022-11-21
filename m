Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7272CC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 22:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiKUW6W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbiKUW6T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 17:58:19 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC61A3436
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 14:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=usniqaP0qkNWXeW5J6DO7cLu7UJMOkOkzSaDhB2VG9M=; b=jXY313UCZvJF8unFaSdJ+T+CCG
        Gu/YjSWcLzpMrpyWQYI539ye3o+p9aFofPI/g9FMJRLljVxgaNeFBmHCoev2WtQKTQIxA+oeeH4AZ
        ze1zMfE0Yxy1hCIMjv2XWH/9uRUwUhhQgYyI75EP0yBVrpvL1XOEhljS+cErDZcG4FCLMh5oM3x+n
        /s92hrdr/Y+kmBHn7YGllRqq1QvaPbLAQmAo6Iex2cquLYNAJSGVaGodRtR7xtjylNAl4vkdfvZk7
        HYjBKixSAENv1YnpKPLF+vto3b+pNV/Zu+PODiNW9E8MVMILYl878PxPdcGOTrHPmjrQPF18urvI0
        rEibJSWA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxFGF-005LgP-ND
        for netfilter-devel@vger.kernel.org; Mon, 21 Nov 2022 22:27:31 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 29/34] output: mysql: add prep & exec support
Date:   Mon, 21 Nov 2022 22:26:06 +0000
Message-Id: <20221121222611.3914559-30-jeremy@azazel.net>
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

Now that the common DB API offers prep & exec support, update the MySQL
plug-in to use it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/mysql/ulogd_output_MYSQL.c | 163 ++++++++++++++++++++++++------
 1 file changed, 131 insertions(+), 32 deletions(-)

diff --git a/output/mysql/ulogd_output_MYSQL.c b/output/mysql/ulogd_output_MYSQL.c
index bed1d7488019..d64da85a418a 100644
--- a/output/mysql/ulogd_output_MYSQL.c
+++ b/output/mysql/ulogd_output_MYSQL.c
@@ -37,11 +37,12 @@
  * 	Port to ulogd2 (@ 0sec conference, Bern, Suisse)
  */
 
+#include <assert.h>
+#ifdef DEBUG_MYSQL
+#include <stdio.h>
+#endif
 #include <stdlib.h>
 #include <string.h>
-#include <errno.h>
-#include <time.h>
-#include <arpa/inet.h>
 #include <mysql/mysql.h>
 #include <ulogd/ulogd.h>
 #include <ulogd/conffile.h>
@@ -56,6 +57,12 @@
 struct mysql_instance {
 	struct db_instance db_inst;
 	MYSQL *dbh; /* the database handle we are using */
+	MYSQL_STMT *sth;
+};
+
+struct mysql_buffer {
+	unsigned long length;
+	my_bool is_null;
 };
 
 /* our configuration directives */
@@ -193,46 +200,138 @@ static int open_db_mysql(struct ulogd_pluginstance *upi)
 	return 0;
 }
 
-static int escape_string_mysql(struct ulogd_pluginstance *upi,
-				char *dst, const char *src, unsigned int len)
+static int prepare_mysql(struct ulogd_pluginstance *upi,
+			 const struct db_stmt *stmt)
 {
 	struct mysql_instance *mi = (struct mysql_instance *) upi->private;
 
-#ifdef OLD_MYSQL
-	return mysql_escape_string(dst, src, len);
-#else
-	return mysql_real_escape_string(mi->dbh, dst, src, len);
-#endif /* OLD_MYSQL */
+	if (mi->sth)
+		mysql_stmt_close(mi->sth);
+
+	if (!(mi->sth = mysql_stmt_init(mi->dbh))) {
+		ulogd_log(ULOGD_ERROR,
+			  "Failed to initialize statement: %s\n",
+			  mysql_error(mi->dbh));
+		return -1;
+	}
+
+	if (mysql_stmt_prepare(mi->sth, stmt->sql, stmt->len) != 0) {
+		ulogd_log(ULOGD_ERROR,
+			  "Failed to prepare statement: %s\n",
+			  mysql_stmt_error(mi->sth));
+		return -1;
+	}
+
+	return 0;
 }
 
 static int execute_mysql(struct ulogd_pluginstance *upi,
 			 const struct db_stmt *stmt)
 {
 	struct mysql_instance *mi = (struct mysql_instance *) upi->private;
-	int ret;
-	MYSQL_RES * result;
+	struct mysql_buffer *buffers;
+	MYSQL_BIND *bindings;
+	unsigned int i;
+	int rv = -1;
 
-	ret = mysql_real_query(mi->dbh, stmt->sql, stmt->len);
-	if (ret) {
-		ulogd_log(ULOGD_ERROR, "execute failed (%s)\n",
-			  mysql_error(mi->dbh));
-		return -1;
+	if (!(bindings = calloc(stmt->nr_params, sizeof(*bindings))))
+		goto err_return;
+
+	if (!(buffers = calloc(stmt->nr_params, sizeof(*buffers))))
+		goto err_free_bindings;
+
+	for (i = 0; i < stmt->nr_params; i++) {
+		struct db_stmt_arg *arg = &stmt->args[i];
+		union db_stmt_arg_value *val = &arg->value;
+
+		if (arg->null) {
+			bindings[i++].buffer_type = MYSQL_TYPE_NULL;
+			continue;
+		}
+
+		switch (arg->type) {
+		case ULOGD_RET_BOOL:
+		case ULOGD_RET_INT8:
+		case ULOGD_RET_UINT8:
+			bindings[i].buffer_type = MYSQL_TYPE_TINY;
+			bindings[i].buffer = val;
+			bindings[i].is_unsigned = arg->type != ULOGD_RET_INT8;
+			break;
+		case ULOGD_RET_INT16:
+		case ULOGD_RET_UINT16:
+			bindings[i].buffer_type = MYSQL_TYPE_SHORT;
+			bindings[i].buffer = val;
+			bindings[i].is_unsigned = arg->type != ULOGD_RET_INT16;
+			break;
+		case ULOGD_RET_INT32:
+		case ULOGD_RET_UINT32:
+		case ULOGD_RET_IPADDR:
+			bindings[i].buffer_type = MYSQL_TYPE_LONG;
+			bindings[i].buffer = val;
+			bindings[i].is_unsigned = arg->type != ULOGD_RET_INT32;
+			break;
+		case ULOGD_RET_INT64:
+		case ULOGD_RET_UINT64:
+			bindings[i].buffer_type = MYSQL_TYPE_LONGLONG;
+			bindings[i].buffer = val;
+			bindings[i].is_unsigned = arg->type != ULOGD_RET_INT64;
+			break;
+		case ULOGD_RET_STRING:
+			bindings[i].buffer_type = MYSQL_TYPE_STRING;
+			bindings[i].is_null = &buffers[i].is_null;
+			bindings[i].length = &buffers[i].length;
+			if (val->ptr) {
+				bindings[i].buffer = val->ptr;
+				bindings[i].buffer_length = arg->len + 1;
+				buffers[i].length = arg->len;
+			} else
+				buffers[i].is_null = 1;
+			break;
+		case ULOGD_RET_RAWSTR:
+			bindings[i].buffer_type = MYSQL_TYPE_BLOB;
+			bindings[i].is_null = &buffers[i].is_null;
+			bindings[i].length = &buffers[i].length;
+			if (val->ptr) {
+				bindings[i].buffer = val->ptr;
+				bindings[i].buffer_length = arg->len;
+				buffers[i].length = arg->len;
+			} else
+				buffers[i].is_null = 1;
+			break;
+		}
 	}
-	result = mysql_use_result(mi->dbh);
-	if (result) {
-		mysql_free_result(result);
+
+	if (mysql_stmt_bind_param(mi->sth, bindings) != 0) {
+		ulogd_log(ULOGD_ERROR,
+			  "Failed to bind statement parameters: %s\n",
+			  mysql_stmt_error(mi->sth));
+		goto err_free_buffers;
 	}
 
-	return 0;
+	if (mysql_stmt_execute(mi->sth) != 0) {
+		ulogd_log(ULOGD_ERROR,
+			  "Failed to execute statement: %s\n",
+			  mysql_stmt_error(mi->sth));
+		goto err_free_buffers;
+	}
+
+	rv = 0;
+
+err_free_buffers:
+	free (buffers);
+err_free_bindings:
+	free (bindings);
+err_return:
+	return rv;
 }
 
 static struct db_driver db_driver_mysql = {
-	.get_columns	= &get_columns_mysql,
-	.get_column	= &get_column_mysql,
-	.open_db	= &open_db_mysql,
-	.close_db	= &close_db_mysql,
-	.escape_string	= &escape_string_mysql,
-	.execute	= &execute_mysql,
+	.get_columns	= get_columns_mysql,
+	.get_column	= get_column_mysql,
+	.open_db	= open_db_mysql,
+	.close_db	= close_db_mysql,
+	.prepare	= prepare_mysql,
+	.execute	= execute_mysql,
 };
 
 static int configure_mysql(struct ulogd_pluginstance *upi,
@@ -254,11 +353,11 @@ static struct ulogd_plugin plugin_mysql = {
 	},
 	.config_kset = &kset_mysql,
 	.priv_size   = sizeof(struct mysql_instance),
-	.configure   = &configure_mysql,
-	.start	     = &ulogd_db_start,
-	.stop	     = &ulogd_db_stop,
-	.signal	     = &ulogd_db_signal,
-	.interp	     = &ulogd_db_interp,
+	.configure   = configure_mysql,
+	.start	     = ulogd_db_start,
+	.stop	     = ulogd_db_stop,
+	.signal	     = ulogd_db_signal,
+	.interp	     = ulogd_db_interp,
 	.version     = VERSION,
 };
 
-- 
2.35.1

