Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88663C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352124AbhKXWtU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352164AbhKXWtU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:49:20 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA4BC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=a41YbP+R04R0BDB1NJ1n48WqLUOZgA/3HMs/5OJTkk4=; b=SXF9sYocreEgGmzdz0uMNrp/vb
        ySO46hiX5TYMH7GYsIPc1uBrnFKNV5dyu3oCw3AumSdm99TR76MI2brkmRoMzo9wve2KQvKAFa9A/
        hxdhph9Tzrz+g9aNZyfhZyxRzNQEIW0yqeJWZMnyphJVs5pRNgzKWF5iqXOMIY5V9KXUWHg8kTf/j
        rv39bNl5YrnGJHJvm6qvEi8KRBzs4+M+9OzyuiTSsXFedHDV7b2m9KuCTlublg+y7bsAS+hz3L072
        FTDrCx7oU3mGr9AURKA/nf4fNDdivgP3nRRxkTpPXlZeYYzdjVNv41FeOz4ZJfK37eMUp3W4sOU1g
        iA8LCWrw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h8-00563U-1j
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:50 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 16/30] output: SQLITE3: fix possible buffer overruns
Date:   Wed, 24 Nov 2021 22:24:14 +0000
Message-Id: <20211124222444.2597311-20-jeremy@azazel.net>
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

There is a an off-by-one error in the size of some of the buffers used
to hold key-names.  The maximum length of a name is `ULOGD_MAX_KEYLEN`,
and so the buffer size should be be `ULOGD_MAX_KEYLEN + 1`.

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

