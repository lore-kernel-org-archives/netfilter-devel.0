Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC71CC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350236AbhKXWsx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:48:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343941AbhKXWsx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:48:53 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3ECC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=iRoMO6lyX9AyWadDoszAOhKqDXMQJiUCKOzVckiJQKM=; b=dQ4CSlX27NtrZtDWZ3O+5AjUt7
        lCW1LCvzZKGToxPugPqPJRaY/Z5Jgc7R/9TRxOzemHzwnHnG0Am9BwU0zR5N8XA09U2fjcIM8fiEK
        cGPqWwoHlx/0w1YA+v1ACWMAXqfef3WBuuND/ckAA10bU7kzTTHicEqI3PwkJACtWfD0GBfSv7NZC
        KJv5ziUxQn6me0DrAvHdgTBRhaRfddUjvMCcIws2cWPwk2iFjOg8cgpC4fn7idgC7H5gz9wOfNo6j
        wtfIxH0CXH7O2d4V2dP+K6aAnASCAL+QyTZ1MCWSRZ730ArVMKK1YNk4V+3nqkwhnbDP6bZs+XOCr
        XIzOOmBA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0hA-00563U-0b
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:52 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 24/32] db: improve formatting of insert statement
Date:   Wed, 24 Nov 2021 22:24:29 +0000
Message-Id: <20211124222444.2597311-35-jeremy@azazel.net>
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

`sql_createstmt` contains a variable `stmt_val` which points to the end
of the SQL already written, where the next chunk should be appended.
Currently, this is assigned after every write:

  sprintf(stmt_val, ...);
  stmt_val = mi->stmt + strlen(mi->stmt);

However, since `sprintf` returns the number of bytes written, increment
`stmt_val` by the return-value of `sprintf` in order to avoid the
repeated `strlen` calls.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 util/db.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/util/db.c b/util/db.c
index f0711146867f..2dbe0db2fbfe 100644
--- a/util/db.c
+++ b/util/db.c
@@ -67,7 +67,6 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
 	unsigned int i;
 	char *table = table_ce(upi->config_kset).u.string;
 	char *procedure = procedure_ce(upi->config_kset).u.string;
-	char *stmt_val = NULL;
 
 	if (mi->stmt)
 		free(mi->stmt);
@@ -96,20 +95,21 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
 	if (strncasecmp(procedure,"INSERT", strlen("INSERT")) == 0 &&
 	    (procedure[strlen("INSERT")] == '\0' ||
 			procedure[strlen("INSERT")] == ' ')) {
+		char *stmt_val = mi->stmt;
 		char buf[ULOGD_MAX_KEYLEN];
 		char *underscore;
 
 		if(procedure[6] == '\0') {
 			/* procedure == "INSERT" */
 			if (mi->schema)
-				sprintf(mi->stmt, "insert into %s.%s (", mi->schema, table);
+				stmt_val += sprintf(stmt_val,
+						    "insert into %s.%s (",
+						    mi->schema, table);
 			else
-				sprintf(mi->stmt, "insert into %s (", table);
-		}
-		else
-			sprintf(mi->stmt, "%s (", procedure);
-
-		stmt_val = mi->stmt + strlen(mi->stmt);
+				stmt_val += sprintf(stmt_val,
+						    "insert into %s (", table);
+		} else
+			stmt_val += sprintf(stmt_val, "%s (", procedure);
 
 		for (i = 0; i < upi->input.num_keys; i++) {
 			if (upi->input.keys[i].flags & ULOGD_KEYF_INACTIVE)
@@ -118,8 +118,7 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
 			strncpy(buf, upi->input.keys[i].name, ULOGD_MAX_KEYLEN);	
 			while ((underscore = strchr(buf, '.')))
 				*underscore = '_';
-			sprintf(stmt_val, "%s,", buf);
-			stmt_val = mi->stmt + strlen(mi->stmt);
+			stmt_val += sprintf(stmt_val, "%s,", buf);
 		}
 		*(stmt_val - 1) = ')';
 
-- 
2.33.0

