Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E096AC433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 22:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbiKUW1l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiKUW1k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 17:27:40 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C847E02C
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 14:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7ViKe8Osu4SApu0xaM0xPM2WuyCLUBlu70yZHewCPXQ=; b=akgExUxtuPNz5DQHSJSAn4La/h
        xGFdzVEbOkUDTY2/C8HR0o3hFckcVnXkqlQeLpQb4Bt2NVvgTu+XxI68VxeWisfm7Jt63aSMyiP4F
        PPw1RJ/hlKsDE5e7Taj/+hAJM+97qmL8vbRyM8WgHtm57soGQQMMRLBMsNO1ETQMTaIPHuePYFMdD
        ZPHLu0nzFH4y+LvJMDH8k1Ko5jnheYk0Ry6a02BRqBP1TZty1Gi8MjfDX2VVhSPovwkSZQbjOEWvx
        EYtTwh5AFP8FDNojPP9XnmYaKDMeAhzA/B0IOxmwYHkGmYKX8XxaEDH+Vh1cLwMTtbsHa6XWPHltk
        CPqII59A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxFGC-005LgP-ID
        for netfilter-devel@vger.kernel.org; Mon, 21 Nov 2022 22:27:28 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 06/34] src: remove some trailing white space
Date:   Mon, 21 Nov 2022 22:25:43 +0000
Message-Id: <20221121222611.3914559-7-jeremy@azazel.net>
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

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/dbi/ulogd_output_DBI.c         | 26 +++++-----
 output/mysql/ulogd_output_MYSQL.c     | 24 ++++-----
 output/pcap/ulogd_output_PCAP.c       | 18 +++----
 output/pgsql/ulogd_output_PGSQL.c     | 34 ++++++------
 output/sqlite3/ulogd_output_SQLITE3.c | 18 +++----
 src/ulogd.c                           | 74 +++++++++++++--------------
 util/db.c                             |  8 +--
 7 files changed, 101 insertions(+), 101 deletions(-)

diff --git a/output/dbi/ulogd_output_DBI.c b/output/dbi/ulogd_output_DBI.c
index 88af7a1473c3..1a623e14c41a 100644
--- a/output/dbi/ulogd_output_DBI.c
+++ b/output/dbi/ulogd_output_DBI.c
@@ -4,8 +4,8 @@
  * layer
  *
  * (C) 2000-2008 by Pierre Chifflier <chifflier@inl.fr>
- * This software is distributed under the terms of GNU GPL 
- * 
+ * This software is distributed under the terms of GNU GPL
+ *
  * This plugin is based on the PostgreSQL plugin made by Harald Welte.
  *
  */
@@ -44,23 +44,23 @@ static struct config_keyset dbi_kset = {
 	.num_ces = DB_CE_NUM + 7,
 	.ces = {
 		DB_CES,
-		{ 
-			.key = "db", 
+		{
+			.key = "db",
 			.type = CONFIG_TYPE_STRING,
 			.options = CONFIG_OPT_MANDATORY,
 		},
 		{
-			.key = "host", 
+			.key = "host",
 			.type = CONFIG_TYPE_STRING,
 			.options = CONFIG_OPT_NONE,
 		},
-		{ 
-			.key = "user", 
+		{
+			.key = "user",
 			.type = CONFIG_TYPE_STRING,
 			.options = CONFIG_OPT_MANDATORY,
 		},
 		{
-			.key = "pass", 
+			.key = "pass",
 			.type = CONFIG_TYPE_STRING,
 			.options = CONFIG_OPT_NONE,
 		},
@@ -70,13 +70,13 @@ static struct config_keyset dbi_kset = {
 			.options = CONFIG_OPT_NONE,
 		},
 		{
-			.key = "schema", 
+			.key = "schema",
 			.type = CONFIG_TYPE_STRING,
 			.options = CONFIG_OPT_NONE,
 			.u.string = "public",
 		},
-		{ 
-			.key = "dbtype", 
+		{
+			.key = "dbtype",
 			.type = CONFIG_TYPE_STRING,
 			.options = CONFIG_OPT_MANDATORY,
 		},
@@ -291,8 +291,8 @@ static int configure_dbi(struct ulogd_pluginstance *upi,
 	return ulogd_db_configure(upi, stack);
 }
 
-static struct ulogd_plugin dbi_plugin = { 
-	.name 		= "DBI", 
+static struct ulogd_plugin dbi_plugin = {
+	.name 		= "DBI",
 	.input 		= {
 		.keys	= NULL,
 		.num_keys = 0,
diff --git a/output/mysql/ulogd_output_MYSQL.c b/output/mysql/ulogd_output_MYSQL.c
index 9727e303f2c5..dc49a2ae4e5b 100644
--- a/output/mysql/ulogd_output_MYSQL.c
+++ b/output/mysql/ulogd_output_MYSQL.c
@@ -5,7 +5,7 @@
  * (C) 2000-2005 by Harald Welte <laforge@gnumonks.org>
  *
  *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 
+ *  it under the terms of the GNU General Public License version 2
  *  as published by the Free Software Foundation
  *
  *  This program is distributed in the hope that it will be useful,
@@ -64,22 +64,22 @@ static struct config_keyset kset_mysql = {
 	.ces = {
 		DB_CES,
 		{
-			.key = "db", 
+			.key = "db",
 			.type = CONFIG_TYPE_STRING,
 			.options = CONFIG_OPT_MANDATORY,
 		},
 		{
-			.key = "host", 
+			.key = "host",
 			.type = CONFIG_TYPE_STRING,
 			.options = CONFIG_OPT_MANDATORY,
 		},
 		{
-			.key = "user", 
+			.key = "user",
 			.type = CONFIG_TYPE_STRING,
 			.options = CONFIG_OPT_MANDATORY,
 		},
 		{
-			.key = "pass", 
+			.key = "pass",
 			.type = CONFIG_TYPE_STRING,
 			.options = CONFIG_OPT_MANDATORY,
 		},
@@ -107,7 +107,7 @@ static int get_columns_mysql(struct ulogd_pluginstance *upi)
 		return -1;
 	}
 
-	result = mysql_list_fields(mi->dbh, 
+	result = mysql_list_fields(mi->dbh,
 				   table_ce(upi->config_kset).u.string, NULL);
 	if (!result) {
 		ulogd_log(ULOGD_ERROR, "error in list_fields(): %s\n",
@@ -176,7 +176,7 @@ static int open_db_mysql(struct ulogd_pluginstance *upi)
 	char *db = db_ce(upi->config_kset).u.string;
 #ifdef MYSQL_OPT_RECONNECT
 	my_bool trueval = 1;
-#endif 
+#endif
 
 	mi->dbh = mysql_init(NULL);
 	if (!mi->dbh) {
@@ -185,20 +185,20 @@ static int open_db_mysql(struct ulogd_pluginstance *upi)
 	}
 
 	if (connect_timeout)
-		mysql_options(mi->dbh, MYSQL_OPT_CONNECT_TIMEOUT, 
+		mysql_options(mi->dbh, MYSQL_OPT_CONNECT_TIMEOUT,
 			      (const char *) &connect_timeout);
 #ifdef MYSQL_OPT_RECONNECT
 #  if defined(MYSQL_VERSION_ID) && (MYSQL_VERSION_ID >= 50019)
 	mysql_options(mi->dbh, MYSQL_OPT_RECONNECT, &trueval);
 #  endif
-#endif 
+#endif
 
 	if (!mysql_real_connect(mi->dbh, server, user, pass, db, port, NULL, 0)) {
 		ulogd_log(ULOGD_ERROR, "can't connect to db: %s\n",
 			  mysql_error(mi->dbh));
 		return -1;
 	}
-		
+
 #ifdef MYSQL_OPT_RECONNECT
 #  if defined(MYSQL_VERSION_ID) && (MYSQL_VERSION_ID < 50019)
 	mysql_options(mi->dbh, MYSQL_OPT_RECONNECT, &trueval);
@@ -263,7 +263,7 @@ static struct ulogd_plugin plugin_mysql = {
 	.input = {
 		.keys = NULL,
 		.num_keys = 0,
-		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW, 
+		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
 	},
 	.output = {
 		.type = ULOGD_DTYPE_SINK,
@@ -280,7 +280,7 @@ static struct ulogd_plugin plugin_mysql = {
 
 void __attribute__ ((constructor)) init(void);
 
-void init(void) 
+void init(void)
 {
 	ulogd_register_plugin(&plugin_mysql);
 }
diff --git a/output/pcap/ulogd_output_PCAP.c b/output/pcap/ulogd_output_PCAP.c
index e7798f20c8fc..6640087f55a5 100644
--- a/output/pcap/ulogd_output_PCAP.c
+++ b/output/pcap/ulogd_output_PCAP.c
@@ -5,7 +5,7 @@
  * (C) 2002-2005 by Harald Welte <laforge@gnumonks.org>
  *
  *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 
+ *  it under the terms of the GNU General Public License version 2
  *  as published by the Free Software Foundation
  *
  *  This program is distributed in the hope that it will be useful,
@@ -91,14 +91,14 @@ struct pcap_sf_pkthdr {
 static struct config_keyset pcap_kset = {
 	.num_ces = 2,
 	.ces = {
-		{ 
-			.key = "file", 
-			.type = CONFIG_TYPE_STRING, 
+		{
+			.key = "file",
+			.type = CONFIG_TYPE_STRING,
 			.options = CONFIG_OPT_NONE,
 			.u = { .string = ULOGD_PCAP_DEFAULT },
 		},
-		{ 
-			.key = "sync", 
+		{
+			.key = "sync",
 			.type = CONFIG_TYPE_INT,
 			.options = CONFIG_OPT_NONE,
 			.u = { .value = ULOGD_PCAP_SYNC_DEFAULT },
@@ -112,7 +112,7 @@ struct pcap_instance {
 
 struct intr_id {
 	char* name;
-	unsigned int id;		
+	unsigned int id;
 };
 
 #define INTR_IDS 	7
@@ -242,11 +242,11 @@ static int append_create_outfile(struct ulogd_pluginstance *upi)
 	} else {
 		pi->of = fopen(filename, "a");
 		if (!pi->of) {
-			ulogd_log(ULOGD_ERROR, "can't open pcap file %s: %s\n", 
+			ulogd_log(ULOGD_ERROR, "can't open pcap file %s: %s\n",
 				filename,
 				strerror(errno));
 			return -EPERM;
-		}		
+		}
 	}
 
 	return 0;
diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index 04c266510a40..6f3cde61a312 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -2,9 +2,9 @@
  *
  * ulogd output plugin for logging to a PGSQL database
  *
- * (C) 2000-2005 by Harald Welte <laforge@gnumonks.org> 
- * This software is distributed under the terms of GNU GPL 
- * 
+ * (C) 2000-2005 by Harald Welte <laforge@gnumonks.org>
+ * This software is distributed under the terms of GNU GPL
+ *
  * This plugin is based on the MySQL plugin made by Harald Welte.
  * The support PostgreSQL were made by Jakab Laszlo.
  *
@@ -41,23 +41,23 @@ static struct config_keyset pgsql_kset = {
 	.num_ces = DB_CE_NUM + 7,
 	.ces = {
 		DB_CES,
-		{ 
-			.key = "db", 
+		{
+			.key = "db",
 			.type = CONFIG_TYPE_STRING,
 			.options = CONFIG_OPT_MANDATORY,
 		},
 		{
-			.key = "host", 
+			.key = "host",
 			.type = CONFIG_TYPE_STRING,
 			.options = CONFIG_OPT_NONE,
 		},
-		{ 
-			.key = "user", 
+		{
+			.key = "user",
 			.type = CONFIG_TYPE_STRING,
 			.options = CONFIG_OPT_MANDATORY,
 		},
 		{
-			.key = "pass", 
+			.key = "pass",
 			.type = CONFIG_TYPE_STRING,
 			.options = CONFIG_OPT_NONE,
 		},
@@ -67,7 +67,7 @@ static struct config_keyset pgsql_kset = {
 			.options = CONFIG_OPT_NONE,
 		},
 		{
-			.key = "schema", 
+			.key = "schema",
 			.type = CONFIG_TYPE_STRING,
 			.options = CONFIG_OPT_NONE,
 			.u.string = "public",
@@ -94,7 +94,7 @@ static struct config_keyset pgsql_kset = {
 static int pgsql_namespace(struct ulogd_pluginstance *upi)
 {
 	struct pgsql_instance *pi = (struct pgsql_instance *) upi->private;
-	char pgbuf[strlen(PGSQL_HAVE_NAMESPACE_TEMPLATE) + 
+	char pgbuf[strlen(PGSQL_HAVE_NAMESPACE_TEMPLATE) +
 		   strlen(schema_ce(upi->config_kset).u.string) + 1];
 
 	if (!pi->dbh)
@@ -103,7 +103,7 @@ static int pgsql_namespace(struct ulogd_pluginstance *upi)
 	sprintf(pgbuf, PGSQL_HAVE_NAMESPACE_TEMPLATE,
 		schema_ce(upi->config_kset).u.string);
 	ulogd_log(ULOGD_DEBUG, "%s\n", pgbuf);
-	
+
 	pi->pgres = PQexec(pi->dbh, pgbuf);
 	if (!pi->pgres) {
 		ulogd_log(ULOGD_DEBUG, "\n result false");
@@ -126,7 +126,7 @@ static int pgsql_namespace(struct ulogd_pluginstance *upi)
 	}
 
 	PQclear(pi->pgres);
-	
+
 	return 0;
 }
 
@@ -141,7 +141,7 @@ static int get_columns_pgsql(struct ulogd_pluginstance *upi)
 {
 	struct pgsql_instance *pi = (struct pgsql_instance *) upi->private;
 	char pgbuf[strlen(PGSQL_GETCOLUMN_TEMPLATE_SCHEMA)
-		   + strlen(table_ce(upi->config_kset).u.string) 
+		   + strlen(table_ce(upi->config_kset).u.string)
 		   + strlen(pi->db_inst.schema) + 2];
 	int i;
 
@@ -303,7 +303,7 @@ static int open_db_pgsql(struct ulogd_pluginstance *upi)
 static int escape_string_pgsql(struct ulogd_pluginstance *upi,
 			       char *dst, const char *src, unsigned int len)
 {
-	return PQescapeString(dst, src, strlen(src)); 
+	return PQescapeString(dst, src, strlen(src));
 }
 
 static int execute_pgsql(struct ulogd_pluginstance *upi,
@@ -342,8 +342,8 @@ static int configure_pgsql(struct ulogd_pluginstance *upi,
 	return ulogd_db_configure(upi, stack);
 }
 
-static struct ulogd_plugin pgsql_plugin = { 
-	.name 		= "PGSQL", 
+static struct ulogd_plugin pgsql_plugin = {
+	.name 		= "PGSQL",
 	.input 		= {
 		.keys	= NULL,
 		.num_keys = 0,
diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_output_SQLITE3.c
index 0a9ad67edcff..8dd7cec586cf 100644
--- a/output/sqlite3/ulogd_output_SQLITE3.c
+++ b/output/sqlite3/ulogd_output_SQLITE3.c
@@ -4,7 +4,7 @@
  * (C) 2005 by Ben La Monica <ben.lamonica@gmail.com>
  *
  *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 
+ *  it under the terms of the GNU General Public License version 2
  *  as published by the Free Software Foundation
  *
  *  This program is distributed in the hope that it will be useful,
@@ -15,7 +15,7 @@
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- * 
+ *
  *  This module has been adapted from the ulogd_MYSQL.c written by
  *  Harald Welte <laforge@gnumonks.org>
  *  Alex Janssen <alex@ynfonatic.de>
@@ -24,7 +24,7 @@
  *  at http://www.pojo.us/ulogd/
  *
  *  2005-02-09 Harald Welte <laforge@gnumonks.org>:
- *  	- port to ulogd-1.20 
+ *  	- port to ulogd-1.20
  *
  *  2006-10-09 Holger Eitzenberger <holger@my-eitzenberger.de>
  *  	- port to ulogd-2.00
@@ -160,11 +160,11 @@ sqlite3_interp(struct ulogd_pluginstance *pi)
 		case ULOGD_RET_INT64:
 			ret = sqlite3_bind_int(priv->p_stmt, i, k_ret->u.value.i64);
 			break;
-			
+
 		case ULOGD_RET_UINT8:
 			ret = sqlite3_bind_int(priv->p_stmt, i, k_ret->u.value.ui8);
 			break;
-			
+
 		case ULOGD_RET_UINT16:
 			ret = sqlite3_bind_int(priv->p_stmt, i, k_ret->u.value.ui16);
 			break;
@@ -205,7 +205,7 @@ sqlite3_interp(struct ulogd_pluginstance *pi)
 
  err_bind:
 	ulogd_log(ULOGD_ERROR, "SQLITE: bind: %s\n", sqlite3_errmsg(priv->dbh));
-	
+
 	return ULOGD_IRET_ERR;
 }
 
@@ -418,8 +418,8 @@ sqlite3_stop(struct ulogd_pluginstance *pi)
 	return 0;
 }
 
-static struct ulogd_plugin sqlite3_plugin = { 
-	.name = "SQLITE3", 
+static struct ulogd_plugin sqlite3_plugin = {
+	.name = "SQLITE3",
 	.input = {
 		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
 	},
@@ -438,7 +438,7 @@ static struct ulogd_plugin sqlite3_plugin = {
 static void init(void) __attribute__((constructor));
 
 static void
-init(void) 
+init(void)
 {
 	ulogd_register_plugin(&sqlite3_plugin);
 }
diff --git a/src/ulogd.c b/src/ulogd.c
index 8ea9793ec0fb..cdb5c689ab36 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -7,7 +7,7 @@
  * (C) 2013 Chris Boot <bootc@bootc.net>
  *
  *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 
+ *  it under the terms of the GNU General Public License version 2
  *  as published by the Free Software Foundation
  *
  *  This program is distributed in the hope that it will be useful,
@@ -71,7 +71,7 @@
 #ifdef DEBUG
 #define DEBUGP(format, args...) fprintf(stderr, format, ## args)
 #else
-#define DEBUGP(format, args...) 
+#define DEBUGP(format, args...)
 #endif
 
 #define COPYRIGHT \
@@ -143,7 +143,7 @@ static struct config_keyset ulogd_kset = {
 			.u.parser = &load_plugin,
 		},
 		{
-			.key = "loglevel", 
+			.key = "loglevel",
 			.type = CONFIG_TYPE_INT,
 			.options = CONFIG_OPT_NONE,
 			.u.value = ULOGD_NOTICE,
@@ -253,7 +253,7 @@ int ulogd_wildcard_inputkeys(struct ulogd_pluginstance *upi)
 
 
 /***********************************************************************
- * PLUGIN MANAGEMENT 
+ * PLUGIN MANAGEMENT
  ***********************************************************************/
 
 /* try to lookup a registered plugin for a given name */
@@ -325,7 +325,7 @@ void get_plugin_infos(struct ulogd_plugin *me)
 			switch (me->config_kset->ces[i].type) {
 				case CONFIG_TYPE_STRING:
 					printf("String");
-					printf(", Default: %s", 
+					printf(", Default: %s",
 					       me->config_kset->ces[i].u.string);
 					break;
 				case CONFIG_TYPE_INT:
@@ -340,7 +340,7 @@ void get_plugin_infos(struct ulogd_plugin *me)
 					printf("Unknown");
 					break;
 			}
-			if (me->config_kset->ces[i].options == 
+			if (me->config_kset->ces[i].options ==
 						CONFIG_OPT_MANDATORY) {
 				printf(", Mandatory");
 			}
@@ -353,7 +353,7 @@ void get_plugin_infos(struct ulogd_plugin *me)
 			printf("\tNo statically defined keys\n");
 		} else {
 			for(i = 0; i < me->input.num_keys; i++) {
-				char *tstring = 
+				char *tstring =
 					type_to_string(me->input.keys[i].type);
 				printf("\tKey: %s (%s",
 				       me->input.keys[i].name,
@@ -391,8 +391,8 @@ void get_plugin_infos(struct ulogd_plugin *me)
 /* the function called by all plugins for registering themselves */
 void ulogd_register_plugin(struct ulogd_plugin *me)
 {
-	if (strcmp(me->version, VERSION)) { 
-		ulogd_log(ULOGD_NOTICE, 
+	if (strcmp(me->version, VERSION)) {
+		ulogd_log(ULOGD_NOTICE,
 			  "plugin `%s' has incompatible version %s\n",
 			  me->name,
 			  me->version);
@@ -588,7 +588,7 @@ static void ulogd_clean_results(struct ulogd_pluginstance *pi)
 	/* iterate through plugin stack */
 	llist_for_each_entry(cur, &pi->stack->list, list) {
 		unsigned int i;
-		
+
 		/* iterate through input keys of pluginstance */
 		for (i = 0; i < cur->output.num_keys; i++) {
 			struct ulogd_key *key = &cur->output.keys[i];
@@ -614,7 +614,7 @@ void ulogd_propagate_results(struct ulogd_pluginstance *pi)
 	/* iterate over remaining plugin stack */
 	llist_for_each_entry_continue(cur, &pi->stack->list, list) {
 		int ret;
-		
+
 		ret = cur->plugin->interp(cur);
 		switch (ret) {
 		case ULOGD_IRET_ERR:
@@ -656,7 +656,7 @@ pluginstance_alloc_init(struct ulogd_plugin *pl, char *pi_id,
 	if (pl->config_kset) {
 		size += sizeof(struct config_keyset);
 		if (pl->config_kset->num_ces)
-			size += pl->config_kset->num_ces * 
+			size += pl->config_kset->num_ces *
 						sizeof(struct config_entry);
 	}
 	size += pl->input.num_keys * sizeof(struct ulogd_key);
@@ -681,9 +681,9 @@ pluginstance_alloc_init(struct ulogd_plugin *pl, char *pi_id,
 		ptr += sizeof(struct config_keyset);
 		pi->config_kset->num_ces = pl->config_kset->num_ces;
 		if (pi->config_kset->num_ces) {
-			ptr += pi->config_kset->num_ces 
+			ptr += pi->config_kset->num_ces
 						* sizeof(struct config_entry);
-			memcpy(pi->config_kset->ces, pl->config_kset->ces, 
+			memcpy(pi->config_kset->ces, pl->config_kset->ces,
 			       pi->config_kset->num_ces
 						* sizeof(struct config_entry));
 		}
@@ -694,16 +694,16 @@ pluginstance_alloc_init(struct ulogd_plugin *pl, char *pi_id,
 	if (pl->input.num_keys) {
 		pi->input.num_keys = pl->input.num_keys;
 		pi->input.keys = ptr;
-		memcpy(pi->input.keys, pl->input.keys, 
+		memcpy(pi->input.keys, pl->input.keys,
 		       pl->input.num_keys * sizeof(struct ulogd_key));
 		ptr += pl->input.num_keys * sizeof(struct ulogd_key);
 	}
-	
+
 	/* copy input keys */
 	if (pl->output.num_keys) {
 		pi->output.num_keys = pl->output.num_keys;
 		pi->output.keys = ptr;
-		memcpy(pi->output.keys, pl->output.keys, 
+		memcpy(pi->output.keys, pl->output.keys,
 		       pl->output.num_keys * sizeof(struct ulogd_key));
 	}
 
@@ -799,12 +799,12 @@ create_stack_resolve_keys(struct ulogd_pluginstance_stack *stack)
 
 	/* pre-configuration pass */
 	llist_for_each_entry_reverse(pi_cur, &stack->list, list) {
-		ulogd_log(ULOGD_DEBUG, "traversing plugin `%s'\n", 
+		ulogd_log(ULOGD_DEBUG, "traversing plugin `%s'\n",
 			  pi_cur->plugin->name);
 		/* call plugin to tell us which keys it requires in
 		 * given configuration */
 		if (pi_cur->plugin->configure) {
-			int ret = pi_cur->plugin->configure(pi_cur, 
+			int ret = pi_cur->plugin->configure(pi_cur,
 							    stack);
 			if (ret < 0) {
 				ulogd_log(ULOGD_ERROR, "error during "
@@ -838,7 +838,7 @@ create_stack_resolve_keys(struct ulogd_pluginstance_stack *stack)
 
 		if (&pi_prev->list == &stack->list) {
 			/* this is the last one in the stack */
-			if (!(pi_cur->plugin->input.type 
+			if (!(pi_cur->plugin->input.type
 						& ULOGD_DTYPE_SOURCE)) {
 				ulogd_log(ULOGD_ERROR, "first plugin in stack "
 					  "has to be source plugin\n");
@@ -856,7 +856,7 @@ create_stack_resolve_keys(struct ulogd_pluginstance_stack *stack)
 					  pi_cur->plugin->name,
 					  pi_prev->plugin->name);
 			}
-	
+
 			for (j = 0; j < pi_cur->input.num_keys; j++) {
 				struct ulogd_key *okey;
 				struct ulogd_key *ikey = &pi_cur->input.keys[j];
@@ -866,7 +866,7 @@ create_stack_resolve_keys(struct ulogd_pluginstance_stack *stack)
 				if (ikey->flags & ULOGD_KEYF_INACTIVE)
 					continue;
 
-				if (ikey->u.source) { 
+				if (ikey->u.source) {
 					ulogd_log(ULOGD_ERROR, "input key `%s' "
 						  "already has source\n",
 						  ikey->name);
@@ -874,7 +874,7 @@ create_stack_resolve_keys(struct ulogd_pluginstance_stack *stack)
 					return -EINVAL;
 				}
 
-				okey = find_okey_in_stack(ikey->name, 
+				okey = find_okey_in_stack(ikey->name,
 							  stack, pi_cur);
 				if (!okey) {
 					if (ikey->flags & ULOGD_KEYF_OPTIONAL)
@@ -942,7 +942,7 @@ static int create_stack_start_instances(struct ulogd_pluginstance_stack *stack)
 		if (!pluginstance_started(pi)) {
 			ret = pi->plugin->start(pi);
 			if (ret < 0) {
-				ulogd_log(ULOGD_ERROR, 
+				ulogd_log(ULOGD_ERROR,
 					  "error starting `%s'\n",
 					  pi->id);
 				return ret;
@@ -998,7 +998,7 @@ static int create_stack(const char *option)
 		strncpy(pi_id, tok, ULOGD_MAX_KEYLEN-1);
 		pi_id[equals-tok] = '\0';
 		plname = equals+1;
-	
+
 		/* find matching plugin */
 		pl = find_plugin(plname);
 		if (!pl) {
@@ -1012,16 +1012,16 @@ static int create_stack(const char *option)
 		/* allocate */
 		pi = pluginstance_alloc_init(pl, pi_id, stack);
 		if (!pi) {
-			ulogd_log(ULOGD_ERROR, 
+			ulogd_log(ULOGD_ERROR,
 				  "unable to allocate pluginstance for %s\n",
 				  pi_id);
 			ret = -ENOMEM;
 			goto out;
 		}
-	
+
 		/* FIXME: call constructor routine from end to beginning,
 		 * fix up input/output keys */
-			
+
 		ulogd_log(ULOGD_DEBUG, "pushing `%s' on stack\n", pl->name);
 		llist_add_tail(&pi->list, &stack->list);
 	}
@@ -1052,7 +1052,7 @@ out_stack:
 out_buf:
 	return ret;
 }
-	
+
 
 static void ulogd_main_loop(void)
 {
@@ -1089,7 +1089,7 @@ static int logfile_open(const char *name)
 	} else {
 		logfile = fopen(ulogd_logfile, "a");
 		if (!logfile) {
-			fprintf(stderr, "ERROR: can't open logfile '%s': %s\n", 
+			fprintf(stderr, "ERROR: can't open logfile '%s': %s\n",
 				name, strerror(errno));
 			exit(2);
 		}
@@ -1410,7 +1410,7 @@ static void sigterm_handler_task(int signal)
 static void signal_handler_task(int signal)
 {
 	ulogd_log(ULOGD_NOTICE, "signal received, calling pluginstances\n");
-	
+
 	switch (signal) {
 	case SIGHUP:
 		/* reopen logfile */
@@ -1418,12 +1418,12 @@ static void signal_handler_task(int signal)
 			fclose(logfile);
 			logfile = fopen(ulogd_logfile, "a");
  			if (!logfile) {
-				fprintf(stderr, 
-					"ERROR: can't open logfile %s: %s\n", 
+				fprintf(stderr,
+					"ERROR: can't open logfile %s: %s\n",
 					ulogd_logfile, strerror(errno));
 				sigterm_handler_task(signal);
 			}
-	
+
 		}
 		break;
 	default:
@@ -1494,7 +1494,7 @@ int main(int argc, char* argv[])
 		default:
 		case '?':
 			if (isprint(optopt))
-				fprintf(stderr, "Unknown option `-%c'.\n", 
+				fprintf(stderr, "Unknown option `-%c'.\n",
 					optopt);
 			else
 				fprintf(stderr, "Unknown option character "
@@ -1591,7 +1591,7 @@ int main(int argc, char* argv[])
 	}
 
 	if (llist_empty(&ulogd_pi_stacks)) {
-		ulogd_log(ULOGD_FATAL, 
+		ulogd_log(ULOGD_FATAL,
 			  "not even a single working plugin stack\n");
 		warn_and_exit(daemonize);
 	}
@@ -1642,7 +1642,7 @@ int main(int argc, char* argv[])
 	signal(SIGUSR2, &signal_handler);
 	set_scheduler();
 
-	ulogd_log(ULOGD_INFO, 
+	ulogd_log(ULOGD_INFO,
 		  "initialization finished, entering main loop\n");
 
 	ulogd_main_loop();
diff --git a/util/db.c b/util/db.c
index ebd9f152ed83..dab66216e07d 100644
--- a/util/db.c
+++ b/util/db.c
@@ -10,7 +10,7 @@
  *           (C) 2008,2013 Eric Leblond <eric@regit.org>
  *
  *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 
+ *  it under the terms of the GNU General Public License version 2
  *  as published by the Free Software Foundation
  *
  *  This program is distributed in the hope that it will be useful,
@@ -21,7 +21,7 @@
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- * 
+ *
  */
 
 #include <unistd.h>
@@ -170,7 +170,7 @@ int ulogd_db_configure(struct ulogd_pluginstance *upi,
 	ret = di->driver->get_columns(upi);
 	if (ret < 0)
 		ulogd_log(ULOGD_ERROR, "error in get_columns\n");
-	
+
 	/* Close database, since ulogd core could just call configure
 	 * but abort during input key resolving routines.  configure
 	 * doesn't have a destructor... */
@@ -315,7 +315,7 @@ static int _init_reconnect(struct ulogd_pluginstance *upi)
 	/* Disable plugin permanently */
 	ulogd_log(ULOGD_ERROR, "permanently disabling plugin\n");
 	di->interp = &disabled_interp_db;
-	
+
 	return 0;
 }
 
-- 
2.35.1

