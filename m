Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9028C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 11:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236580AbhK3LSR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 06:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236342AbhK3LSQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 06:18:16 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58985C061746
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 03:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=boTbZSMkjfDyb2lcl+6LCjVcfVD9RLBEcZFjLZrj7O4=; b=MKgvwL9TXQ038R/Fh1xZfw8zlC
        7e0nLJ3HOJZPt8Qgha4inAgGtSRM9wAB4fet4fSp3XxWnplo5vMl+SkD9iYD3tzMaiRmHs5igxnJg
        O9c+GYe/C83ROLSxR1lnXvpEGZJfcHyULzteLbvIcK6LrPhKE2flsJm9lDwrPuTG5+ocvAwoNlqDD
        f9SFbW9FJw3YdPqJLVemdWkqBkgRFNugyGdD0qa+KQEbhnZd203ELh3HyrFwM5Ylk6ZQiiQ55+A32
        jO+7CRyjjtE53InkY1xAhlN1m58oJkR38nV2eBR2uf+ZNhR24EFW52OJLOnfQk0+KfpVgj/LlZj3p
        FLHe9NXw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ms0ns-00Awwr-PM
        for netfilter-devel@vger.kernel.org; Tue, 30 Nov 2021 10:56:04 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 19/32] output: SQLITE3: fix memory-leak in error-handling
Date:   Tue, 30 Nov 2021 10:55:47 +0000
Message-Id: <20211130105600.3103609-20-jeremy@azazel.net>
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

When mapping DB column names to input-keys, if we cannot find a key to
match a column, the newly allocated `struct field` is leaked.  Free it,
and log an error message.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/sqlite3/ulogd_output_SQLITE3.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_output_SQLITE3.c
index 554b1b34488c..41aeeec27854 100644
--- a/output/sqlite3/ulogd_output_SQLITE3.c
+++ b/output/sqlite3/ulogd_output_SQLITE3.c
@@ -342,8 +342,12 @@ sqlite3_init_db(struct ulogd_pluginstance *pi)
 		}
 		strncpy(f->name, buf, ULOGD_MAX_KEYLEN);
 
-		if ((f->key = ulogd_find_key(pi, buf)) == NULL)
+		if ((f->key = ulogd_find_key(pi, buf)) == NULL) {
+			ulogd_log(ULOGD_ERROR,
+				  "SQLITE3: unknown input key: %s\n", buf);
+			free(f);
 			return -1;
+		}
 
 		TAILQ_INSERT_TAIL(&priv->fields, f, link);
 	}
-- 
2.33.0

