Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA9BC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 22:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbiKUW6a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbiKUW6Y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 17:58:24 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B9CA3433
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 14:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VzIh1Gp3IUthCvqNk808Mk4cB7rwG2OLPSCM/NNf+9w=; b=VAR+aK/kdks+grE9nKaLL2WSn9
        l9HNo8LU5A1UBL22GE6g8xA8mMDZQQ+qiqFKIoKTFkICNXhEJygJ1NSyx/iNikllksJpfFRYgWhjE
        JMW2Q4CyZSYz6o6jPalIpFdTGzTE96j76S90icSTLDNI3UtLcxHLECJuCUX4GelF5uUjOlcl1UDCn
        a3yetmmQWN9nAl7UJyPeTJxrYe/jboe+nocKBq126EtpLa+7CUoBbrSjOHyot3s0cSubxEeUtc/Zl
        H50s8YppQiUS4FER7dXia7XHJvKFAVho2yprDcZk9hhVarM2EzddYzNTzhJv0dgtZADxsvPHfYqym
        Z8rH1WeA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxFGE-005LgP-8j
        for netfilter-devel@vger.kernel.org; Mon, 21 Nov 2022 22:27:30 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 18/34] db: open-code `_loop_reconnect_db`
Date:   Mon, 21 Nov 2022 22:25:55 +0000
Message-Id: <20221121222611.3914559-19-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221121222611.3914559-1-jeremy@azazel.net>
References: <20221121222611.3914559-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Now that `_loop_reconnect_db` returns `void`, it can be reduced to
`while (open_db fails) sleep 1 second`, so remove the function altogther
and open code the simplified while-loop.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 util/db.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/util/db.c b/util/db.c
index 0514a87e0759..afa86a3f137b 100644
--- a/util/db.c
+++ b/util/db.c
@@ -56,7 +56,6 @@ static int _process_backlog(struct ulogd_pluginstance *upi);
 
 static int _add_to_ring(struct ulogd_pluginstance *upi, struct db_instance *di);
 static void *_process_ring(void *arg);
-static void _loop_reconnect_db(struct ulogd_pluginstance *upi);
 
 int
 ulogd_db_configure(struct ulogd_pluginstance *upi,
@@ -694,10 +693,11 @@ _process_ring(void *gdi)
 		while (*wr_place == RING_QUERY_READY) {
 			if (di->driver->execute(upi, wr_place + 1,
 						strlen(wr_place + 1)) < 0) {
-				_loop_reconnect_db(upi);
+				di->driver->close_db(upi);
+				while (di->driver->open_db(upi) < 0)
+					sleep(1);
 				/* try to re run query */
 				continue;
-
 			}
 			*wr_place = RING_NO_QUERY;
 			di->ring.rd_item++;
@@ -711,18 +711,3 @@ _process_ring(void *gdi)
 
 	return NULL;
 }
-
-static void
-_loop_reconnect_db(struct ulogd_pluginstance * upi)
-{
-	struct db_instance *di = (struct db_instance *) &upi->private;
-
-	di->driver->close_db(upi);
-	while (1) {
-		if (di->driver->open_db(upi) < 0) {
-			sleep(1);
-		} else {
-			return;
-		}
-	}
-}
-- 
2.35.1

