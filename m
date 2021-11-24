Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CBDBC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345570AbhKXWsT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344942AbhKXWsS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:48:18 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898FBC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=q0vWQf5+Ff6xEdZUMSxT6djQe8InMjjFrnjBcb/aUUY=; b=LTQ5/GfHfUwy5yPuUF/A1AeeFB
        P/EE1+lsDOHIrs4rnShRMZvhv9ltRsFxp83Opl52VhEvdYnLQddDoSB0/SHOjkFbqBR1YHRQ4Yat+
        MErsOVy9SpqYp8TWVRD/ZcUcx27Tn1QOmXvbT1LmY7ZlRQgjcwshHWG0n+s/7gFJIV7xERpYuuWEE
        nnfwd2I2eeTqKHe8FPFMtz3LgXE5FiEMOo5ND5aWiX/KjRkKxjy7djLawYA23Y735zba6CrYOgKHX
        bFUFVYICh8Ej08oomLPp2jpH8QcdBsgNkqbRrZl2SdeBlfCU6qw6YBWGXQ7hvPAoEFAkdF1/OjIgO
        fdk3B6ew==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h9-00563U-7K
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:51 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 21/30] output: SQLITE3: catch errors creating SQL statement
Date:   Wed, 24 Nov 2021 22:24:23 +0000
Message-Id: <20211124222444.2597311-29-jeremy@azazel.net>
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

