Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E251C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 22:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiKUW6w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiKUW6u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 17:58:50 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5382F383
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 14:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Wpdcwffk2/sqTd2hhZaeL1ieIWpf5w+DMnE4wbkGqBk=; b=ZPBF33KLgxzyVgTEHI7nEmq8oU
        Z/0H74t9THSuh2PL2ALSL3Mc2FhoXRnlTHtwa4gBMUPAauHmm/gVhgmAV3lpjnjfq85JJWA69NVz1
        JB6Ax7Lpprlp+Ic7nDESCkWrZpRT76eFvSkitZuizss5vi/aix2dliCEQWquTsaV/vpJXdEzH8kd7
        /GOHBfzGgaUHEJoAE820tMWiBDAq12MUdst66ZuOxsa94A8lKM1FNNINYg/O+jhBONxkP48ogg2Km
        lzCy8cGp5H9wb2FKpk3VfMn7RJyiQHk13M0A2YJERqji2vjDJQf2ZzVbIu08SH8/vQ0XAxosSn0lo
        8jB/KoMQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxFGF-005LgP-Rn
        for netfilter-devel@vger.kernel.org; Mon, 21 Nov 2022 22:27:31 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 30/34] output: pgsql: remove a couple of struct members
Date:   Mon, 21 Nov 2022 22:26:07 +0000
Message-Id: <20221121222611.3914559-31-jeremy@azazel.net>
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

The `pgsql_have_schemas` of `struct pgsql_instance` is never used.  The
`pgres` member is always assigned and cleared in the same function.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/pgsql/ulogd_output_PGSQL.c | 46 ++++++++++++++++---------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index 9dfef7946775..70bfbee7f565 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -31,8 +31,6 @@ struct pgsql_instance {
 	struct db_instance db_inst;
 
 	PGconn *dbh;
-	PGresult *pgres;
-	unsigned char pgsql_have_schemas;
 };
 
 /* our configuration directives */
@@ -90,6 +88,7 @@ static int pgsql_namespace(struct ulogd_pluginstance *upi)
 	struct pgsql_instance *pi = (struct pgsql_instance *) upi->private;
 	char pgbuf[strlen(PGSQL_HAVE_NAMESPACE_TEMPLATE) +
 		   strlen(schema_ce(upi->config_kset).u.string) + 1];
+	PGresult *pgres;
 
 	if (!pi->dbh)
 		return -1;
@@ -98,28 +97,28 @@ static int pgsql_namespace(struct ulogd_pluginstance *upi)
 		schema_ce(upi->config_kset).u.string);
 	ulogd_log(ULOGD_DEBUG, "%s\n", pgbuf);
 
-	pi->pgres = PQexec(pi->dbh, pgbuf);
-	if (!pi->pgres) {
+	pgres = PQexec(pi->dbh, pgbuf);
+	if (!pgres) {
 		ulogd_log(ULOGD_DEBUG, "\n result false");
 		return -1;
 	}
 
-	if (PQresultStatus(pi->pgres) == PGRES_TUPLES_OK) {
-		if (PQntuples(pi->pgres)) {
+	if (PQresultStatus(pgres) == PGRES_TUPLES_OK) {
+		if (PQntuples(pgres)) {
 			ulogd_log(ULOGD_DEBUG, "using schema %s\n",
 				  schema_ce(upi->config_kset).u.string);
 			pi->db_inst.schema = schema_ce(upi->config_kset).u.string;
 		} else {
 			ulogd_log(ULOGD_ERROR, "schema %s not found: %s\n",
 				 schema_ce(upi->config_kset).u.string, PQerrorMessage(pi->dbh));
-			PQclear(pi->pgres);
+			PQclear(pgres);
 			return -1;
 		}
 	} else {
 		pi->db_inst.schema = NULL;
 	}
 
-	PQclear(pi->pgres);
+	PQclear(pgres);
 
 	return 0;
 }
@@ -137,6 +136,7 @@ static int get_columns_pgsql(struct ulogd_pluginstance *upi)
 	char pgbuf[strlen(PGSQL_GETCOLUMN_TEMPLATE_SCHEMA)
 		   + strlen(table_ce(upi->config_kset).u.string)
 		   + strlen(pi->db_inst.schema) + 2];
+	PGresult *pgres;
 	int rv;
 
 	if (!pi->dbh) {
@@ -156,27 +156,27 @@ static int get_columns_pgsql(struct ulogd_pluginstance *upi)
 
 	ulogd_log(ULOGD_DEBUG, "%s\n", pgbuf);
 
-	pi->pgres = PQexec(pi->dbh, pgbuf);
-	if (!pi->pgres) {
+	pgres = PQexec(pi->dbh, pgbuf);
+	if (!pgres) {
 		ulogd_log(ULOGD_DEBUG, "result false (%s)",
 			  PQerrorMessage(pi->dbh));
 		return -1;
 	}
 
-	if (PQresultStatus(pi->pgres) != PGRES_TUPLES_OK) {
+	if (PQresultStatus(pgres) != PGRES_TUPLES_OK) {
 		ulogd_log(ULOGD_DEBUG, "pres_command_not_ok (%s)",
 			  PQerrorMessage(pi->dbh));
-		PQclear(pi->pgres);
+		PQclear(pgres);
 		return -1;
 	}
 
-	rv = ulogd_db_alloc_input_keys(upi, PQntuples(pi->pgres), pi->pgres);
+	rv = ulogd_db_alloc_input_keys(upi, PQntuples(pgres), pgres);
 
 	/* ID (starting by '.') is a sequence */
 	if (!rv && upi->input.keys[0].name[0] == '.')
 		upi->input.keys[0].flags |= ULOGD_KEYF_INACTIVE;
 
-	PQclear(pi->pgres);
+	PQclear(pgres);
 	return rv;
 }
 
@@ -207,6 +207,7 @@ static int open_db_pgsql(struct ulogd_pluginstance *upi)
 	char *connstr = connstr_ce(upi->config_kset).u.string;
 	char *schema = NULL;
 	char pgbuf[128];
+	PGresult *pgres;
 
 	if (!connstr[0]) {
 		char         *server = host_ce(upi->config_kset).u.string;
@@ -260,13 +261,13 @@ static int open_db_pgsql(struct ulogd_pluginstance *upi)
 
 	if (!(schema == NULL) && (strcmp(schema,"public"))) {
 		snprintf(pgbuf, 128, "SET search_path='%.63s', \"$user\", 'public'", schema);
-		pi->pgres = PQexec(pi->dbh, pgbuf);
-		if ((PQresultStatus(pi->pgres) == PGRES_COMMAND_OK)) {
-			PQclear(pi->pgres);
+		pgres = PQexec(pi->dbh, pgbuf);
+		if ((PQresultStatus(pgres) == PGRES_COMMAND_OK)) {
+			PQclear(pgres);
 		} else {
 			ulogd_log(ULOGD_ERROR, "could not set search path to (%s): %s\n",
 				 schema, PQerrorMessage(pi->dbh));
-			PQclear(pi->pgres);
+			PQclear(pgres);
 			close_db_pgsql(upi);
 			return -1;
 		}
@@ -286,16 +287,17 @@ static int execute_pgsql(struct ulogd_pluginstance *upi,
 			 const struct db_stmt *stmt)
 {
 	struct pgsql_instance *pi = (struct pgsql_instance *) upi->private;
+	PGresult *pgres;
 
-	pi->pgres = PQexec(pi->dbh, stmt->sql);
-	if (!(pi->pgres && ((PQresultStatus(pi->pgres) == PGRES_COMMAND_OK)
-		|| (PQresultStatus(pi->pgres) == PGRES_TUPLES_OK)))) {
+	pgres = PQexec(pi->dbh, stmt->sql);
+	if (!(pgres && ((PQresultStatus(pgres) == PGRES_COMMAND_OK)
+		|| (PQresultStatus(pgres) == PGRES_TUPLES_OK)))) {
 		ulogd_log(ULOGD_ERROR, "execute failed (%s)\n",
 			  PQerrorMessage(pi->dbh));
 		return -1;
 	}
 
-	PQclear(pi->pgres);
+	PQclear(pgres);
 
 	return 0;
 }
-- 
2.35.1

