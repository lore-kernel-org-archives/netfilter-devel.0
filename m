Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D7D7C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 22:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbiKUW5S (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKUW5R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 17:57:17 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06977C67D3
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 14:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Tgcc9tkSxRZPjF0xQbzd+2ZGLaJ9oozwBAfcmq1tZFE=; b=dK9fs1T7DzHKMRlBDOfrpKp2ed
        oV2nwEyJPEU7UADL/7P/bvIBIRodod5sr234WTp6WA8FlMBjYiDzyyKL/vwzSCefXlagNnbiMuXBq
        KRD1baxDH5MskMCw7WLpRU1uwM5llfT7ihltSkOhK/cA1svRG0/jieHaA/LylweQjAuGZRVmrxG2L
        TFp5Iv6Zp8htY7/3YvzrF72+hoKXaRa78u96KFe6gzejDcyzZGZzWTtXWErqIGUecEmfkQ7yb+wUv
        ei3R6LL3xuUsPca677OvrkFnR76yh7RD5eHOXaXVuBFaiC9opIOl0JOP3DLZGavVTzN8v4rYhmxK/
        Z0HAWrPw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxFGG-005LgP-8D
        for netfilter-devel@vger.kernel.org; Mon, 21 Nov 2022 22:27:32 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 33/34] output: pgsql: add prep & exec support
Date:   Mon, 21 Nov 2022 22:26:10 +0000
Message-Id: <20221121222611.3914559-34-jeremy@azazel.net>
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

Now that the common DB API offers prep-exec support, update the Postgres
plug-in to use it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/pgsql/ulogd_output_PGSQL.c | 145 +++++++++++++++++++++++++-----
 1 file changed, 123 insertions(+), 22 deletions(-)

diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index 8c9aabf873ca..01afec1003f0 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -10,6 +10,7 @@
  *
  */
 
+#include <limits.h>
 #include <stdlib.h>
 #include <string.h>
 #include <errno.h>
@@ -27,6 +28,8 @@
 #define DEBUGP(x, args...)
 #endif
 
+#define BUF_SIZE (sizeof(uint64_t) * CHAR_BIT / 3 + 1)
+
 struct pgsql_instance {
 	struct db_instance db_inst;
 
@@ -217,6 +220,12 @@ get_column_pgsql(void *vp, unsigned int i)
 	return PQgetvalue(pgres, i, 0);
 }
 
+static unsigned int
+format_param_pgsql(char *buf, unsigned int size, unsigned int idx)
+{
+	return snprintf(buf, size, "$%u,", idx + 1);
+}
+
 static int close_db_pgsql(struct ulogd_pluginstance *upi)
 {
 	struct pgsql_instance *pi = (struct pgsql_instance *) upi->private;
@@ -313,38 +322,130 @@ err_close_db:
 	return rv;
 }
 
-static int escape_string_pgsql(struct ulogd_pluginstance *upi,
-			       char *dst, const char *src, unsigned int len)
+static int
+prepare_pgsql(struct ulogd_pluginstance *upi, const struct db_stmt *stmt)
 {
-	return PQescapeString(dst, src, strlen(src));
+	struct pgsql_instance *pi = (struct pgsql_instance *) upi->private;
+	PGresult *pgres;
+	int rv;
+
+	pgres = PQprepare(pi->dbh, procedure_ce(upi->config_kset).u.string,
+			  stmt->sql, 0, NULL);
+	if (PQresultStatus(pgres) != PGRES_COMMAND_OK) {
+		ulogd_log(ULOGD_ERROR, "Failed to prepare statement: %s\n",
+			  PQerrorMessage(pi->dbh));
+		rv = -1;
+	} else
+		rv = 0;
+
+	PQclear(pgres);
+	return rv;
 }
 
-static int execute_pgsql(struct ulogd_pluginstance *upi,
-			 const struct db_stmt *stmt)
+static int
+execute_pgsql(struct ulogd_pluginstance *upi, const struct db_stmt *stmt)
 {
 	struct pgsql_instance *pi = (struct pgsql_instance *) upi->private;
+	char **bindings, *buffers;
 	PGresult *pgres;
+	unsigned int i;
+	int rv = -1;
 
-	pgres = PQexec(pi->dbh, stmt->sql);
-	if (!(pgres && ((PQresultStatus(pgres) == PGRES_COMMAND_OK)
-		|| (PQresultStatus(pgres) == PGRES_TUPLES_OK)))) {
-		ulogd_log(ULOGD_ERROR, "execute failed (%s)\n",
-			  PQerrorMessage(pi->dbh));
+	if (!(bindings = malloc(stmt->nr_params * sizeof(*bindings)))) {
+		ulogd_log(ULOGD_ERROR, "Memory allocation failure\n");
 		return -1;
 	}
 
+	if (!(buffers = malloc(stmt->nr_params * BUF_SIZE))) {
+		ulogd_log(ULOGD_ERROR, "Memory allocation failure\n");
+		goto err_free_bindings;
+	}
+
+	for (i = 0; i < stmt->nr_params; i++) {
+		struct db_stmt_arg *arg = &stmt->args[i];
+		union db_stmt_arg_value *val = &arg->value;
+
+		if (arg->null) {
+			bindings[i] = NULL;
+			continue;
+		}
+
+		switch (arg->type) {
+		case ULOGD_RET_STRING:
+		case ULOGD_RET_RAWSTR:
+			bindings[i] = val->ptr;
+			continue;
+		}
+
+		bindings[i] = &buffers[i * BUF_SIZE];
+
+		switch (arg->type) {
+		case ULOGD_RET_BOOL:
+			snprintf(bindings[i], BUF_SIZE, "%d", val->b);
+			break;
+		case ULOGD_RET_INT8:
+			snprintf(bindings[i], BUF_SIZE, "%" PRId8, val->i8);
+			break;
+		case ULOGD_RET_UINT8:
+			snprintf(bindings[i], BUF_SIZE, "%" PRIu8, val->ui8);
+			break;
+		case ULOGD_RET_INT16:
+			snprintf(bindings[i], BUF_SIZE, "%" PRId16, val->i16);
+			break;
+		case ULOGD_RET_UINT16:
+			snprintf(bindings[i], BUF_SIZE, "%" PRIu16, val->ui16);
+			break;
+		case ULOGD_RET_INT32:
+			snprintf(bindings[i], BUF_SIZE, "%" PRId32, val->i32);
+			break;
+		case ULOGD_RET_IPADDR:
+		case ULOGD_RET_UINT32:
+			snprintf(bindings[i], BUF_SIZE, "%" PRIu32, val->ui32);
+			break;
+		case ULOGD_RET_INT64:
+			snprintf(bindings[i], BUF_SIZE, "%" PRId64, val->i64);
+			break;
+		case ULOGD_RET_UINT64:
+			snprintf(bindings[i], BUF_SIZE, "%" PRIu64, val->ui64);
+			break;
+		}
+	}
+
+	pgres = PQexecPrepared(pi->dbh, procedure_ce(upi->config_kset).u.string,
+			       stmt->nr_params, (const char **) bindings, NULL,
+			       NULL, 0);
+
+	switch (PQresultStatus(pgres)) {
+	case PGRES_COMMAND_OK:
+	case PGRES_TUPLES_OK:
+		rv = 0;
+		break;
+	default:
+		ulogd_log(ULOGD_ERROR,
+			  "Failed to execute statement: status = %s, error = %s\n",
+			  PQresStatus(PQresultStatus(pgres)),
+			  PQerrorMessage(pi->dbh));
+		break;
+	}
+
 	PQclear(pgres);
 
-	return 0;
+	free (buffers);
+
+err_free_bindings:
+	free (bindings);
+
+	return rv;
 }
 
 static struct db_driver db_driver_pgsql = {
-	.get_columns	= &get_columns_pgsql,
-	.get_column	= &get_column_pgsql,
-	.open_db	= &open_db_pgsql,
-	.close_db	= &close_db_pgsql,
-	.escape_string	= &escape_string_pgsql,
-	.execute	= &execute_pgsql,
+	.get_columns	= get_columns_pgsql,
+	.get_column	= get_column_pgsql,
+	.format_param	= format_param_pgsql,
+	.open_db	= open_db_pgsql,
+	.close_db	= close_db_pgsql,
+	.prepare	= prepare_pgsql,
+	.execute	= execute_pgsql,
 };
 
 static int configure_pgsql(struct ulogd_pluginstance *upi,
@@ -367,11 +468,11 @@ static struct ulogd_plugin pgsql_plugin = {
 	},
 	.config_kset	= &pgsql_kset,
 	.priv_size	= sizeof(struct pgsql_instance),
-	.configure	= &configure_pgsql,
-	.start		= &ulogd_db_start,
-	.stop		= &ulogd_db_stop,
-	.signal		= &ulogd_db_signal,
-	.interp		= &ulogd_db_interp,
+	.configure	= configure_pgsql,
+	.start		= ulogd_db_start,
+	.stop		= ulogd_db_stop,
+	.signal		= ulogd_db_signal,
+	.interp		= ulogd_db_interp,
 	.version	= VERSION,
 };
 
-- 
2.35.1

