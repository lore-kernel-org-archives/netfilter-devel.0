Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FEEDC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 21:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236712AbiK2V53 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236772AbiK2V5E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 16:57:04 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF6B6E541
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 13:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TCGWhjQfs6se8nw6k6gwwo7z/eXpja866L4dvEvRk9Q=; b=TOGR2YAKPL2/Tz2CsxT94eRPX0
        2TtSQYgB8RMfFTS/6oWehbw6TVnZrwgU8gXUKFHVTp/ao24Vj2D+tQJH4Q2RhyE/H8seKa/jM51Bo
        DRijk3CZRsEHTWAucM6YB1AEKdOa+mfmvue55KUxCmJOvzPs1eg4RlHxEibdZSjKy6oRBphd8XA+X
        HFMeLC+mK7Uuoa8scNM77TjAEauaya4s4AD/j7P+TPTV4O8mjKHWoRfiWlGncDoZXaSy90zpPdm7f
        P34RAL6iBn/C1RUlnV8FrILZk9BDCO3xFqS+kU2i4Ulfoi2s/sm5YXenW1SJYZzwzRbDCT5oafWSJ
        AoVK8cgA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p08SM-00DjQp-NW
        for netfilter-devel@vger.kernel.org; Tue, 29 Nov 2022 21:47:58 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v2 v2 32/34] output: pgsql: tidy up `open_db_pgsql` and fix memory leak
Date:   Tue, 29 Nov 2022 21:47:47 +0000
Message-Id: <20221129214749.247878-33-jeremy@azazel.net>
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

 * Remove some excess parentheses and a superfluous local variable.
 * Tighten up the scope of a couple of other variables.
 * Streamline the error-handling.
 * Free the connexion string.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/pgsql/ulogd_output_PGSQL.c | 57 +++++++++++++++++--------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index b125674b7364..8c9aabf873ca 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -232,11 +232,9 @@ static int close_db_pgsql(struct ulogd_pluginstance *upi)
 static int open_db_pgsql(struct ulogd_pluginstance *upi)
 {
 	struct pgsql_instance *pi = (struct pgsql_instance *) upi->private;
-	int len;
 	char *connstr = connstr_ce(upi->config_kset).u.string;
-	char *schema = NULL;
-	char pgbuf[128];
-	PGresult *pgres;
+	PGresult *pgres = NULL;
+	int rv = -1;
 
 	if (!connstr[0]) {
 		char         *server = host_ce(upi->config_kset).u.string;
@@ -245,10 +243,11 @@ static int open_db_pgsql(struct ulogd_pluginstance *upi)
 		char         *pass   = pass_ce(upi->config_kset).u.string;
 		char         *db     = db_ce(upi->config_kset).u.string;
 		char         *cp;
+
 		/* 80 is more than what we need for the fixed parts below */
-		len = 80 + strlen(user) + strlen(db);
+		size_t len = 80 + strlen(user) + strlen(db);
 
-		/* hostname and  and password are the only optionals */
+		/* hostname and and password are the only optionals */
 		if (server[0])
 			len += strlen(server);
 		if (pass[0])
@@ -271,39 +270,47 @@ static int open_db_pgsql(struct ulogd_pluginstance *upi)
 		if (pass[0])
 			cp += sprintf(cp, " password=%s", pass);
 	}
+
 	pi->dbh = PQconnectdb(connstr);
 	if (PQstatus(pi->dbh) != CONNECTION_OK) {
 		ulogd_log(ULOGD_ERROR, "unable to connect to db (%s): %s\n",
 			  connstr, PQerrorMessage(pi->dbh));
-		close_db_pgsql(upi);
-		return -1;
+		goto err_close_db;
 	}
 
-	if (pgsql_namespace(upi)) {
+	if (pgsql_namespace(upi) < 0) {
 		ulogd_log(ULOGD_ERROR, "problem testing for pgsql schemas\n");
-		close_db_pgsql(upi);
-		return -1;
+		goto err_close_db;
 	}
 
-	pi=(struct pgsql_instance *)upi->private;
-	schema = pi->db_inst.schema;
+	if (pi->db_inst.schema != NULL && strcmp(pi->db_inst.schema,"public") != 0) {
+		char pgbuf[128];
 
-	if (!(schema == NULL) && (strcmp(schema,"public"))) {
-		snprintf(pgbuf, 128, "SET search_path='%.63s', \"$user\", 'public'", schema);
+		snprintf(pgbuf, sizeof(pgbuf),
+			 "SET search_path='%.63s', \"$user\", 'public'",
+			 pi->db_inst.schema);
 		pgres = PQexec(pi->dbh, pgbuf);
-		if ((PQresultStatus(pgres) == PGRES_COMMAND_OK)) {
-			PQclear(pgres);
-		} else {
-			ulogd_log(ULOGD_ERROR, "could not set search path to (%s): %s\n",
-				 schema, PQerrorMessage(pi->dbh));
-			PQclear(pgres);
-			close_db_pgsql(upi);
-			return -1;
+		if (PQresultStatus(pgres) != PGRES_COMMAND_OK) {
+			ulogd_log(ULOGD_ERROR,
+				  "could not set search path to (%s): %s\n",
+				  pi->db_inst.schema, PQerrorMessage(pi->dbh));
+			goto err_free_result;
 		}
-
 	}
 
-	return 0;
+	rv = 0;
+
+err_free_result:
+	PQclear(pgres);
+
+err_close_db:
+	if (rv == -1)
+		close_db_pgsql(upi);
+
+	if (connstr != connstr_ce(upi->config_kset).u.string)
+		free(connstr);
+
+	return rv;
 }
 
 static int escape_string_pgsql(struct ulogd_pluginstance *upi,
-- 
2.35.1

