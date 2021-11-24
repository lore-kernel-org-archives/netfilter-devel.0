Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F61C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244645AbhKXWsM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344072AbhKXWsK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:48:10 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B13FC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vaLguVRxJTc08lNsJRSlC4sMIOzi+9EVq/gzHRZgH/I=; b=YG2usyBOBdcUbQNSPJSNbyZcdr
        XG0BF67db6fvgDg4XqPsUGwVUDZkLccxcx4+JbleyoLYsxwmq883Djc6mBTIIDpTdQ8CQWWl+Zd2h
        Ivc/5NG0wS1k7A9IZRtQdqnTSfjkzh7n02ChDRwb7ffts4UWmSWGqzuZWftVVQvYTcwj9JIzilDn5
        xTaQ6TQ4t8tO1kinOv6qHACiqV4wFOigOfn/S7Ko1bhBnqsai50b3HRH663FuXsQuwI45X4LnmfV0
        V9+hIUhZausGPDWOfswhWzbUwWq6IfozPIH4hsn7SJGz7agPhEW5T45WvRrXmbar5kOAph4PistJh
        65JDcd1A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0hA-00563U-Ak
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:52 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 26/32] db: simplify initialization of ring-buffer
Date:   Wed, 24 Nov 2021 22:24:33 +0000
Message-Id: <20211124222444.2597311-39-jeremy@azazel.net>
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

Currently, `strncpy` is used to copy the SQL statement to the ring
buffer, passing the length of the source string, which leads gcc to
complain:

  ../../util/db.c:231:25: warning: `strncpy` specified bound depends on the length of the source argument

In fact, the ring buffer is sized to be a multiple of the size of the
SQL buffer, and the SQL is simply copied multiple times at increasing
offsets, so use `strcpy` instead.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 util/db.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/util/db.c b/util/db.c
index 339e39ef4797..c1d24365239f 100644
--- a/util/db.c
+++ b/util/db.c
@@ -228,9 +228,8 @@ int ulogd_db_start(struct ulogd_pluginstance *upi)
 			  di->ring.size, di->ring.length);
 		/* init start of query for each element */
 		for(i = 0; i < di->ring.size; i++) {
-			strncpy(di->ring.ring + di->ring.length * i + 1,
-				di->stmt,
-				strlen(di->stmt));
+			strcpy(di->ring.ring + di->ring.length * i + 1,
+			       di->stmt);
 		}
 		/* init cond & mutex */
 		ret = pthread_cond_init(&di->ring.cond, NULL);
-- 
2.33.0

