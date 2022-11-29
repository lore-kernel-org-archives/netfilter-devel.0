Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8864C4708B
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 21:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236942AbiK2V6h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236961AbiK2V6S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 16:58:18 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652616F0DB
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 13:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8vzXZzVhcBJE+ZKtsiKxgxJZ1b82IFOCi4JQfyk1/1Y=; b=RKcA/Eq28huJsbAbiROJl+ePEX
        BkEEl+NKTJdR+Hk8v5lpWzx3vUaS43cV1iy21ehHqatsMVEz67//aG+abFPneZ6eLUCWZhkKHrr7Z
        hVpMngsVnU6UgGpw3aXdw5i82rdcfsicNFm6BKwjwlhzLWe6RM+ZU4Wug8pa0vrs89BNvxQ2CTU72
        F4+mG7DRSyZbmD/yjJRyXIP4n0K0zBdE8SKj/UY1vnQT5bDan2wQZZB8OJdLLnQI0aoHQjXDf6RGK
        UiiCI3RyIsuIIUAb+wRPoyGtYw5uiv/OtO+LsjFpTE7S43Dd+ugV/yKTZNPQSJAGHe0r9AixtNyUS
        JxSotQbQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p08SK-00DjQp-71
        for netfilter-devel@vger.kernel.org; Tue, 29 Nov 2022 21:47:56 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v2 v2 14/34] output: de-duplicate allocation of input keys
Date:   Tue, 29 Nov 2022 21:47:29 +0000
Message-Id: <20221129214749.247878-15-jeremy@azazel.net>
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

The three DB output plug-ins which use the ulogd_db API all derive the
names of their input keys from DB column names, and do so in almost
identical fashion.  Create a common ulogd_db implementation and update
them to use it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/ulogd/db.h                | 11 ++++-
 output/dbi/ulogd_output_DBI.c     | 67 ++++++++++++++-----------------
 output/mysql/ulogd_output_MYSQL.c | 46 ++++++++-------------
 output/pgsql/ulogd_output_PGSQL.c | 43 ++++++--------------
 util/db.c                         | 48 ++++++++++++++++++++++
 5 files changed, 116 insertions(+), 99 deletions(-)

diff --git a/include/ulogd/db.h b/include/ulogd/db.h
index a6fd25b4c043..7c0649583f1d 100644
--- a/include/ulogd/db.h
+++ b/include/ulogd/db.h
@@ -12,13 +12,19 @@
 #include <ulogd/ulogd.h>
 
 struct db_driver {
+
 	int (*get_columns)(struct ulogd_pluginstance *upi);
+	const char *(*get_column)(void *, unsigned int);
+	char *(*format_key)(char *);
+
 	int (*open_db)(struct ulogd_pluginstance *upi);
 	int (*close_db)(struct ulogd_pluginstance *upi);
+
 	int (*escape_string)(struct ulogd_pluginstance *upi,
 			     char *dst, const char *src, unsigned int len);
 	int (*execute)(struct ulogd_pluginstance *upi,
 			const char *stmt, unsigned int len);
+
 };
 
 enum {
@@ -116,7 +122,8 @@ int ulogd_db_start(struct ulogd_pluginstance *upi);
 int ulogd_db_stop(struct ulogd_pluginstance *upi);
 int ulogd_db_interp(struct ulogd_pluginstance *upi);
 int ulogd_db_configure(struct ulogd_pluginstance *upi,
-			struct ulogd_pluginstance_stack *stack);
-
+		       struct ulogd_pluginstance_stack *stack);
+int ulogd_db_alloc_input_keys(struct ulogd_pluginstance *upi,
+			      unsigned int num_keys, void *arg);
 
 #endif
diff --git a/output/dbi/ulogd_output_DBI.c b/output/dbi/ulogd_output_DBI.c
index 6312ac1649e2..5c10c787fb6a 100644
--- a/output/dbi/ulogd_output_DBI.c
+++ b/output/dbi/ulogd_output_DBI.c
@@ -92,7 +92,7 @@ static int get_columns_dbi(struct ulogd_pluginstance *upi)
 	struct dbi_instance *pi = (struct dbi_instance *) upi->private;
 	char *table = table_ce(upi->config_kset).u.string;
 	char query[256];
-	unsigned int ui;
+	int rv;
 
 	if (!pi->dbh) {
 		ulogd_log(ULOGD_ERROR, "no database handle\n");
@@ -111,48 +111,39 @@ static int get_columns_dbi(struct ulogd_pluginstance *upi)
 		return -1;
 	}
 
-	if (upi->input.keys)
-		free(upi->input.keys);
+	rv = ulogd_db_alloc_input_keys(upi,
+				       dbi_result_get_numfields(pi->result),
+				       pi->result);
 
-	upi->input.num_keys = dbi_result_get_numfields(pi->result);
-	ulogd_log(ULOGD_DEBUG, "%u fields in table\n", upi->input.num_keys);
-
-	upi->input.keys = calloc(upi->input.num_keys, sizeof(*upi->input.keys));
-	if (!upi->input.keys) {
-		upi->input.num_keys = 0;
-		ulogd_log(ULOGD_ERROR, "ENOMEM\n");
-		dbi_result_free(pi->result);
-		return -ENOMEM;
-	}
-
-	for (ui=1; ui<=upi->input.num_keys; ui++) {
-		const char *field_name = dbi_result_get_field_name(pi->result, ui);
-		char *cp;
+	/* ID is a sequence */
+	if (!rv)
+		upi->input.keys[0].flags |= ULOGD_KEYF_INACTIVE;
 
-		if (!field_name)
-			break;
+	dbi_result_free(pi->result);
+	return rv;
+}
 
-		snprintf(upi->input.keys[ui - 1].name,
-			 sizeof(upi->input.keys[ui - 1].name),
-			 "%s", field_name);
+static const char *
+get_column_dbi(void *vp, unsigned int i)
+{
+	dbi_result result = vp;
 
-		/* down-case and replace all underscores with dots */
-		for (cp = upi->input.keys[ui - 1].name; *cp; cp++) {
-			if (*cp == '_')
-				*cp = '.';
-			else
-				*cp = tolower(*cp);
-		}
+	return dbi_result_get_field_name(result, i + 1);
+}
 
-		DEBUGP("field '%s' found: ", upi->input.keys[ui - 1].name);
+static char *
+format_key_dbi(char *key)
+{
+	char *cp;
+
+	/* down-case and replace all underscores with dots */
+	for (cp = key; *cp; cp++) {
+		if (*cp == '_')
+			*cp = '.';
+		else
+			*cp = tolower(*cp);
 	}
-
-	/* ID is a sequence */
-	upi->input.keys[0].flags |= ULOGD_KEYF_INACTIVE;
-
-	dbi_result_free(pi->result);
-
-	return 0;
+	return key;
 }
 
 static int close_db_dbi(struct ulogd_pluginstance *upi)
@@ -270,6 +261,8 @@ static int execute_dbi(struct ulogd_pluginstance *upi,
 
 static struct db_driver db_driver_dbi = {
 	.get_columns	= &get_columns_dbi,
+	.get_column	= &get_column_dbi,
+	.format_key	= &format_key_dbi,
 	.open_db	= &open_db_dbi,
 	.close_db	= &close_db_dbi,
 	.escape_string	= &escape_string_dbi,
diff --git a/output/mysql/ulogd_output_MYSQL.c b/output/mysql/ulogd_output_MYSQL.c
index 5891207d5990..55059f5c189e 100644
--- a/output/mysql/ulogd_output_MYSQL.c
+++ b/output/mysql/ulogd_output_MYSQL.c
@@ -94,13 +94,13 @@ static struct config_keyset kset_mysql = {
 #define user_ce(x)	((x)->ces[DB_CE_NUM + 2])
 #define pass_ce(x)	((x)->ces[DB_CE_NUM + 3])
 #define port_ce(x)	((x)->ces[DB_CE_NUM + 4])
+
 /* find out which columns the table has */
 static int get_columns_mysql(struct ulogd_pluginstance *upi)
 {
 	struct mysql_instance *mi = (struct mysql_instance *) upi->private;
 	MYSQL_RES *result;
-	MYSQL_FIELD *field;
-	int i;
+	int rv;
 
 	if (!mi->dbh) {
 		ulogd_log(ULOGD_ERROR, "no database handle\n");
@@ -121,38 +121,23 @@ static int get_columns_mysql(struct ulogd_pluginstance *upi)
 	 * in case the core just calls ->configure() and then aborts (and thus
 	 * never free()s the memory we allocate here.  FIXME. */
 
-	/* Cleanup before reconnect */
-	if (upi->input.keys)
-		free(upi->input.keys);
-
-	upi->input.num_keys = mysql_num_fields(result);
-	ulogd_log(ULOGD_DEBUG, "%u fields in table\n", upi->input.num_keys);
-	upi->input.keys = calloc(upi->input.num_keys, sizeof(*upi->input.keys));
-	if (!upi->input.keys) {
-		upi->input.num_keys = 0;
-		ulogd_log(ULOGD_ERROR, "ENOMEM\n");
-		return -ENOMEM;
-	}
+	rv = ulogd_db_alloc_input_keys(upi, mysql_num_fields(result), result);
 
-	for (i = 0; (field = mysql_fetch_field(result)); i++) {
-		char *underscore;
+	/* MySQL Auto increment ... ID :) */
+	if (!rv)
+		upi->input.keys[0].flags |= ULOGD_KEYF_INACTIVE;
 
-		snprintf(upi->input.keys[i].name,
-			 sizeof(upi->input.keys[i].name),
-			 "%s", field->name);
+	mysql_free_result(result);
+	return rv;
+}
 
-		/* replace all underscores with dots */
-		for (underscore = upi->input.keys[i].name;
-		     (underscore = strchr(underscore, '_')); )
-			*underscore = '.';
+static const char *
+get_column_mysql(void *vp, unsigned int i __attribute__ ((unused)))
+{
+	MYSQL_RES *result = vp;
+	MYSQL_FIELD *field = mysql_fetch_field(result);
 
-		DEBUGP("field '%s' found\n", upi->input.keys[i].name);
-	}
-	/* MySQL Auto increment ... ID :) */
-	upi->input.keys[0].flags |= ULOGD_KEYF_INACTIVE;
-	
-	mysql_free_result(result);
-	return 0;
+	return field->name;
 }
 
 static int close_db_mysql(struct ulogd_pluginstance *upi)
@@ -243,6 +228,7 @@ static int execute_mysql(struct ulogd_pluginstance *upi,
 
 static struct db_driver db_driver_mysql = {
 	.get_columns	= &get_columns_mysql,
+	.get_column	= &get_column_mysql,
 	.open_db	= &open_db_mysql,
 	.close_db	= &close_db_mysql,
 	.escape_string	= &escape_string_mysql,
diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index bc0eae7558b3..c5bbc966d66d 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -137,7 +137,7 @@ static int get_columns_pgsql(struct ulogd_pluginstance *upi)
 	char pgbuf[strlen(PGSQL_GETCOLUMN_TEMPLATE_SCHEMA)
 		   + strlen(table_ce(upi->config_kset).u.string)
 		   + strlen(pi->db_inst.schema) + 2];
-	int i;
+	int rv;
 
 	if (!pi->dbh) {
 		ulogd_log(ULOGD_ERROR, "no database handle\n");
@@ -170,40 +170,22 @@ static int get_columns_pgsql(struct ulogd_pluginstance *upi)
 		return -1;
 	}
 
-	if (upi->input.keys)
-		free(upi->input.keys);
-
-	upi->input.num_keys = PQntuples(pi->pgres);
-	ulogd_log(ULOGD_DEBUG, "%u fields in table\n", upi->input.num_keys);
-	upi->input.keys = calloc(upi->input.num_keys, sizeof(*upi->input.keys));
-	if (!upi->input.keys) {
-		upi->input.num_keys = 0;
-		ulogd_log(ULOGD_ERROR, "ENOMEM\n");
-		PQclear(pi->pgres);
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < PQntuples(pi->pgres); i++) {
-		char *underscore;
-
-		snprintf(upi->input.keys[i].name,
-			 sizeof(upi->input.keys[i].name),
-			 "%s", PQgetvalue(pi->pgres, i, 0));
-
-		/* replace all underscores with dots */
-		for (underscore = upi->input.keys[i].name;
-		     (underscore = strchr(underscore, '_')); )
-			*underscore = '.';
-
-		DEBUGP("field '%s' found\n", upi->input.keys[i].name);
-	}
+	rv = ulogd_db_alloc_input_keys(upi, PQntuples(pi->pgres), pi->pgres);
 
 	/* ID (starting by '.') is a sequence */
-	if (upi->input.keys[0].name[0] == '.')
+	if (!rv && upi->input.keys[0].name[0] == '.')
 		upi->input.keys[0].flags |= ULOGD_KEYF_INACTIVE;
 
 	PQclear(pi->pgres);
-	return 0;
+	return rv;
+}
+
+static const char *
+get_column_pgsql(void *vp, unsigned int i)
+{
+	PGresult *pgres = vp;
+
+	return PQgetvalue(pgres, i, 0);
 }
 
 static int close_db_pgsql(struct ulogd_pluginstance *upi)
@@ -320,6 +302,7 @@ static int execute_pgsql(struct ulogd_pluginstance *upi,
 
 static struct db_driver db_driver_pgsql = {
 	.get_columns	= &get_columns_pgsql,
+	.get_column	= &get_column_pgsql,
 	.open_db	= &open_db_pgsql,
 	.close_db	= &close_db_pgsql,
 	.escape_string	= &escape_string_pgsql,
diff --git a/util/db.c b/util/db.c
index 6749079697dc..4ec0af2ea38a 100644
--- a/util/db.c
+++ b/util/db.c
@@ -644,3 +644,51 @@ void ulogd_db_signal(struct ulogd_pluginstance *upi, int signal)
 		break;
 	}
 }
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
-- 
2.35.1

