Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 734AEC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 11:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236526AbhK3LSS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 06:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236342AbhK3LSS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 06:18:18 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293A7C061746
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 03:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WUJ2xAfW8IqMiE8BM2+0Z28oXR7HuaWVA7FYSqtX/G8=; b=mIfiTLSDnBIG6U+uOtRCrNMfZ5
        9H/6vmPLJMn5vVkLOsxMg5KbfvDCDIpRY/1CeXRWKx3MJIdiW1wYuI5P+0Ni0Qmqyt2/vzD+8yBkA
        X/c1c0zQAi93wdrZ2J5AxG3Sl9C/s24OwTHJHIjhn5rcJv4r723SInobPiqDrOlSTPzvm/b7Jlw45
        Yx/VEbMtNB/q8knwlzZHorv6FX1S+pi31pDu7V0yL6DetOK7lBGlMgsQg8/TTX2p9XG1RQqGCls8t
        PY2puCAq3vqdDE3CZSnJt6MrftZHsnUusoxzvYB0f4HOHCTyAXrXgOhZxaXINTcLvOluDmbpIGkJH
        x8q3Smew==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ms0ns-00Awwr-IG
        for netfilter-devel@vger.kernel.org; Tue, 30 Nov 2021 10:56:04 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 17/32] output: PGSQL: fix non-`connstring` configuration of DB connection
Date:   Tue, 30 Nov 2021 10:55:45 +0000
Message-Id: <20211130105600.3103609-18-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130105600.3103609-1-jeremy@azazel.net>
References: <20211130105600.3103609-1-jeremy@azazel.net>
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

