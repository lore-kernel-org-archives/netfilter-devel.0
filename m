Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E94C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344942AbhKXWs0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346037AbhKXWsZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:48:25 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4507C061746
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=boTbZSMkjfDyb2lcl+6LCjVcfVD9RLBEcZFjLZrj7O4=; b=ES1riD5jvD1NqgqNuqx/XXM4jL
        DCA/ja1gn5D+SdE/r+qpnOgLUgo9n2xXlGymtHmXora8HLTQilVe5Qyqu1/gFxpgF6QFUCCvU5uyE
        deiLGxGqCzAjfYpeK0jVFRncX+AxO2mNlxdNGAhxoF4iNr3Qwu0kWacSRxSduXWlM0bMAWtzAldEf
        Gpm9nKbYe+3JfJgZyttj/jZr+CxfFSOIz+PFW9p5aJE0mOswJtqzyN9nUiqQoiMCo+N90y2eKRl0/
        44RHTecT6IGQMK/ywq5/WqSef1pGuhTIUwqNt0W5ph145q5/hTvUDXdYcJ5RYe8PI24f1gFUV9tqL
        lXr7vrPg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h8-00563U-Hr
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:50 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 19/32] output: SQLITE3: fix memory-leak in error-handling
Date:   Wed, 24 Nov 2021 22:24:19 +0000
Message-Id: <20211124222444.2597311-25-jeremy@azazel.net>
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

