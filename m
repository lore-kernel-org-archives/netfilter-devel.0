Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2A05C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8161C61360
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbhKFRRo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 13:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234662AbhKFRRn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 13:17:43 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31183C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 10:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kEz+B4wJFCikgqCrwaOq7Rm5jqNbSBJpO/0rIku/vn8=; b=negyOhys54aYckXBAPJPtXjvO0
        lVtFlurbw5SMWvOHPB6FnA+jCADkwmWNhqE4of4Gqu/RUWxT7jt0VlKMQsfLCHauJCPYYSXcIqXZA
        YuXLLEeZG37+UZRJ74gK1V4yNucPND2YDFqtMuCnEep8tG++rfJRucTHw5qhDD1cBQ1vEflzLpWIF
        xhLTdPCwklC51ztZ5271vndKHAhz7q+X8KbV0BXBOLCTWoOAGs29wkZtlwJXEOcvg5zJFHnfOQLR7
        5ZsLkWyGYMIt0Xp2NBFurSF8bpcqGDyeekK8s0w47fMQYMkv0NoK+LW0S+xiiqfPwd8Fsac7ouOIi
        sqyMRqJw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOtL-004m1E-3s
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:50:07 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 21/27] output: SQLITE3: catch errors creating SQL statement
Date:   Sat,  6 Nov 2021 16:49:47 +0000
Message-Id: <20211106164953.130024-22-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106164953.130024-1-jeremy@azazel.net>
References: <20211106164953.130024-1-jeremy@azazel.net>
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
 output/sqlite3/ulogd_output_SQLITE3.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_output_SQLITE3.c
index 053d7a3b0238..f2ee03b8c446 100644
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
@@ -253,8 +256,8 @@ sqlite3_createstmt(struct ulogd_pluginstance *pi)
 	sqlite3_prepare(priv->dbh, priv->stmt, -1, &priv->p_stmt, 0);
 	if (priv->p_stmt == NULL) {
 		ulogd_log(ULOGD_ERROR, "SQLITE3: prepare: %s\n",
-				  sqlite3_errmsg(priv->dbh));
-		return 1;
+			  sqlite3_errmsg(priv->dbh));
+		return -1;
 	}
 
 	DEBUGP("statement prepared.\n");
@@ -388,7 +391,10 @@ sqlite3_start(struct ulogd_pluginstance *pi)
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

