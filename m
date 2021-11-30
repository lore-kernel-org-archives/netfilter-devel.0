Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1368AC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 11:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbhK3LSo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 06:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237936AbhK3LSn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 06:18:43 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B37C061748
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 03:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=q0vWQf5+Ff6xEdZUMSxT6djQe8InMjjFrnjBcb/aUUY=; b=eQtbqK6HswA5noywQnQDaGutXm
        hLshvJZyDLLUcLQqqyTP1hkpHn/qgELOV7V0YQyQPDJO7vqG5fIRkc2kM8IJMRjqJOrvtC+nvspSk
        tytFi6t1QsEhe+RlaIDihzFnmfWy89PrvGK1vkjobmvYRJIuw8v9Sd5cV1mWGDTwtYxDcnjo7MIP5
        2y6ck0DLOmoEoNmT/J+i1iyXgxrtjAGfKz1tSZvt4zz0HHM445bQcTsYwYpkifNA6SvTcM/hgH2cz
        Q84BU9mU5jq/1PrXJwItlg/NaIkWDWEX/ilzuTCJOTfsS1gEmq34Tz6dTyN30fjAov5yTR8TW1CDD
        j9cElYaQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ms0nt-00Awwr-5O
        for netfilter-devel@vger.kernel.org; Tue, 30 Nov 2021 10:56:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 23/32] output: SQLITE3: catch errors creating SQL statement
Date:   Tue, 30 Nov 2021 10:55:51 +0000
Message-Id: <20211130105600.3103609-24-jeremy@azazel.net>
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

`sqlite3_createstmt` returns non-zero on error, but the return-value was
being ignored.  Change the calling code to check the return-value, log
an error message and propagate the error.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/sqlite3/ulogd_output_SQLITE3.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_output_SQLITE3.c
index c61694a51d47..c03018155a6b 100644
--- a/output/sqlite3/ulogd_output_SQLITE3.c
+++ b/output/sqlite3/ulogd_output_SQLITE3.c
@@ -104,11 +104,14 @@ add_row(struct ulogd_pluginstance *pi)
 		ret = sqlite3_finalize(priv->p_stmt);
 		priv->p_stmt = NULL;
 
-		if (ret == SQLITE_SCHEMA)
-			sqlite3_createstmt(pi);
-		else {
+		if (ret != SQLITE_SCHEMA) {
 			ulogd_log(ULOGD_ERROR, "SQLITE3: step: %s\n",
-					  sqlite3_errmsg(priv->dbh));
+				  sqlite3_errmsg(priv->dbh));
+			goto err_reset;
+		}
+		if (sqlite3_createstmt(pi) < 0) {
+			ulogd_log(ULOGD_ERROR,
+				  "SQLITE3: Could not create statement.\n");
 			goto err_reset;
 		}
 	}
@@ -250,8 +253,8 @@ sqlite3_createstmt(struct ulogd_pluginstance *pi)
 	sqlite3_prepare(priv->dbh, priv->stmt, -1, &priv->p_stmt, 0);
 	if (priv->p_stmt == NULL) {
 		ulogd_log(ULOGD_ERROR, "SQLITE3: prepare: %s\n",
-				  sqlite3_errmsg(priv->dbh));
-		return 1;
+			  sqlite3_errmsg(priv->dbh));
+		return -1;
 	}
 
 	DEBUGP("statement prepared.\n");
@@ -387,7 +390,10 @@ sqlite3_start(struct ulogd_pluginstance *pi)
 	}
 
 	/* create and prepare the actual insert statement */
-	sqlite3_createstmt(pi);
+	if (sqlite3_createstmt(pi) < 0) {
+		ulogd_log(ULOGD_ERROR, "SQLITE3: Could not create statement.\n");
+		return -1;
+	}
 
 	return 0;
 }
-- 
2.33.0

