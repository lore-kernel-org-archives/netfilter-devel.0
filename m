Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB08C46467
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 21:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236775AbiK2V5a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236874AbiK2V5L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 16:57:11 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DDB70468
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 13:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VzIh1Gp3IUthCvqNk808Mk4cB7rwG2OLPSCM/NNf+9w=; b=jdIAMXTav4xY56tuuVbk2Lbbrf
        U08EAFr9mayM5+hJP3Cbbeba+ibblSa2fHYuATBxTJQzLKqk8ghWlNsOjox+5NWPmB1Z+4zZdfTHk
        OpZaCPyJZYCVmSW96azQhJ6zz5G118joislGbVg1X8PaOA5YYAfvWhu5AgrMYxS7r8dScjL5f3j0o
        uNW+F3TQ++zqq/7LBC9IZK/pXcIQhxMmqg3IZO6ZYRSBZMC7M2jzNqa8OGSaWsEOY+lTlXEa/SDlh
        QG1d6pdgxpjKeg7+Ti+h/0ZYecRUpa/igNvtaV4OPAlJ+Tc8C2wp5tJpqrbfK3nDaWd+YDl6Dud3v
        FhihBfrQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p08SK-00DjQp-Oo
        for netfilter-devel@vger.kernel.org; Tue, 29 Nov 2022 21:47:56 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v2 v2 18/34] db: open-code `_loop_reconnect_db`
Date:   Tue, 29 Nov 2022 21:47:33 +0000
Message-Id: <20221129214749.247878-19-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221129214749.247878-1-jeremy@azazel.net>
References: <20221129214749.247878-1-jeremy@azazel.net>
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

