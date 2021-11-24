Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CEF6C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:45:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351035AbhKXWs7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245389AbhKXWs7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:48:59 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B26BC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WUJ2xAfW8IqMiE8BM2+0Z28oXR7HuaWVA7FYSqtX/G8=; b=uxBrhW3QrITSqkj3dQyUf0NIRE
        DyARh2xzJHQm120uuM78hvBBrbH22+l+lXWFSBroRMQ33i9kgkXR7qaGnT+IwwOa7KFoohZ8YNkG9
        Z6WsrFDZwN5oiBZ4fP5c9lMOg49TdzX/oiOOP4v/O+kysLIuiyqD7pBQkN01yz9xXD0bA565gT4rM
        G9KI6dX+MWqMJ0HManZhG4kyf04VpgSmuZPPA0Nz/09vQgFmcR3QJIIlfXNksAgk//wD2INmYKMl0
        MDEhAM6YwMC1eJF/ZTOMO3jO2GPTUjpgoJB6WJxtYgP7my+hiVjF/eWcUgqXefmIMVp/SFD0fwejg
        ij5W6qbQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h8-00563U-5m
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:50 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 17/32] output: PGSQL: fix non-`connstring` configuration of DB connection
Date:   Wed, 24 Nov 2021 22:24:15 +0000
Message-Id: <20211124222444.2597311-21-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124222444.2597311-1-jeremy@azazel.net>
References: <20211124222444.2597311-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In `open_db_pgsql`, we test whether various config-settings are defined
by comparing their string values to `NULL`.  However, the `u.string`
member of `struct config_entry` is an array, not a pointer, so it is
never `NULL`.  Instead, check whether the string is empty.

Use a pointer to the end of the `connstr` buffer and `sprintf`, rather
than repeated `strcat`s.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/pgsql/ulogd_output_PGSQL.c | 44 ++++++++++++-------------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index 71d94031ac4e..b52023273bc6 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -232,48 +232,38 @@ static int open_db_pgsql(struct ulogd_pluginstance *upi)
 	char *schema = NULL;
 	char pgbuf[128];
 
-	if (!connstr) {
-		char *server = host_ce(upi->config_kset).u.string;
-		unsigned int port = port_ce(upi->config_kset).u.value;
-		char *user = user_ce(upi->config_kset).u.string;
-		char *pass = pass_ce(upi->config_kset).u.string;
-		char *db = db_ce(upi->config_kset).u.string;
+	if (!connstr[0]) {
+		char         *server = host_ce(upi->config_kset).u.string;
+		unsigned int  port   = port_ce(upi->config_kset).u.value;
+		char         *user   = user_ce(upi->config_kset).u.string;
+		char         *pass   = pass_ce(upi->config_kset).u.string;
+		char         *db     = db_ce  (upi->config_kset).u.string;
+		char         *cp;
 		/* 80 is more than what we need for the fixed parts below */
 		len = 80 + strlen(user) + strlen(db);
 
 		/* hostname and  and password are the only optionals */
-		if (server)
+		if (server[0])
 			len += strlen(server);
-		if (pass)
+		if (pass[0])
 			len += strlen(pass);
 		if (port)
 			len += 20;
 
-		connstr = (char *) malloc(len);
+		cp = connstr = malloc(len);
 		if (!connstr)
 			return -ENOMEM;
-		connstr[0] = '\0';
 
-		if (server && strlen(server) > 0) {
-			strcpy(connstr, " host=");
-			strcat(connstr, server);
-		}
+		if (server[0])
+			cp += sprintf(cp, "host=%s ", server);
 
-		if (port) {
-			char portbuf[20];
-			snprintf(portbuf, sizeof(portbuf), " port=%u", port);
-			strcat(connstr, portbuf);
-		}
+		if (port)
+			cp += sprintf(cp, "port=%u ", port);
 
-		strcat(connstr, " dbname=");
-		strcat(connstr, db);
-		strcat(connstr, " user=");
-		strcat(connstr, user);
+		cp += sprintf(cp, "dbname=%s user=%s", db, user);
 
-		if (pass) {
-			strcat(connstr, " password=");
-			strcat(connstr, pass);
-		}
+		if (pass[0])
+			cp += sprintf(cp, " password=%s", pass);
 	}
 	pi->dbh = PQconnectdb(connstr);
 	if (PQstatus(pi->dbh) != CONNECTION_OK) {
-- 
2.33.0

