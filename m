Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7141EC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 11:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234673AbhK3LSP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 06:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236580AbhK3LSO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 06:18:14 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87486C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 03:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GXyQP3Ce3W7vJMWbnZpGxiQlMW9Oz8rbMnJaCwq7a7U=; b=rKJg1vo12odb93lzUpqqQCGlJC
        3fPak45mnVLDmoT3sJcFTGRZGIym+RlCdyidsDzi/K19BlnFTplirniBC3YHQdq3pWq5sKYmTSVLb
        tDDlkAxOeqlkCg5apmunHNJkzHYn3prnIt3ErhM5zT7Xyh2Rn6XcJBv5+pSs3nHU76GRb5RbENnHh
        zAWA56zuO2JfKX1lIUGN4THATV5gUxua78jBTZ6AkjdC3dT12+kVGHVSTQoaoNLf18oH31ohIclyG
        a0NJSkQmZSzsWYdr67EF9a2fT+m7zSIEqmsq7MC+WKMGcflGt3emibWe9bF615M0AKyMXV3KPXV6J
        8la12sLQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ms0ns-00Awwr-MJ
        for netfilter-devel@vger.kernel.org; Tue, 30 Nov 2021 10:56:04 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 18/32] output: SQLITE3: fix possible buffer overruns
Date:   Tue, 30 Nov 2021 10:55:46 +0000
Message-Id: <20211130105600.3103609-19-jeremy@azazel.net>
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

There is a an off-by-one error in the size of some of the buffers used
to hold key-names.  The maximum length of a name is `ULOGD_MAX_KEYLEN`,
and so declare the buffers with size `ULOGD_MAX_KEYLEN + 1`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/sqlite3/ulogd_output_SQLITE3.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_output_SQLITE3.c
index 20ceb3b5d6e2..554b1b34488c 100644
--- a/output/sqlite3/ulogd_output_SQLITE3.c
+++ b/output/sqlite3/ulogd_output_SQLITE3.c
@@ -48,7 +48,7 @@
 
 struct field {
 	TAILQ_ENTRY(field) link;
-	char name[ULOGD_MAX_KEYLEN];
+	char name[ULOGD_MAX_KEYLEN + 1];
 	struct ulogd_key *key;
 };
 
@@ -214,7 +214,7 @@ sqlite3_createstmt(struct ulogd_pluginstance *pi)
 {
 	struct sqlite3_priv *priv = (void *)pi->private;
 	struct field *f;
-	char buf[ULOGD_MAX_KEYLEN];
+	char buf[ULOGD_MAX_KEYLEN + 1];
 	char *underscore;
 	char *stmt_pos;
 	int i, cols = 0;
@@ -305,7 +305,7 @@ static int
 sqlite3_init_db(struct ulogd_pluginstance *pi)
 {
 	struct sqlite3_priv *priv = (void *)pi->private;
-	char buf[ULOGD_MAX_KEYLEN];
+	char buf[ULOGD_MAX_KEYLEN + 1];
 	char *underscore;
 	struct field *f;
 	sqlite3_stmt *schema_stmt;
-- 
2.33.0

