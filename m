Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B053C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 22:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiKUW5L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKUW5K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 17:57:10 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF6BC75AE
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 14:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ieYUiwMzqGCMHiktm9MQ0rFPNckn4Ke6RPrvf23nkLA=; b=GD1ZuPtUsrowmisGdlUu7VKLDS
        q7QIaGZXQZCWLQdmevS79nzxRHkO2RN4ql+NplYLGL22z9ErgHpysyV9VNRESmdRwGCDRsyi3BikP
        anfr3syjPAaqWnCjKRjQ0/3K+nu0WPm8Q+wlEQoIT4JhHlApiv+uMsXpzsL0XNXy88YwQ+5fu35+a
        2FehTCgU/ckKLmWJoV6qWLUs1ppprgQiDLKyybDW7NwBb8K3oHtsrmzp4719klPN05s4+aNt2Z28l
        IIaWWFANzJJwnCcg0hFiK3aT8RydDBJIhS7vgV4TZ0ASA1PfIzANxxw4N/cck1jBAmmRURbgZMCJ0
        Ze9g9osg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxFGE-005LgP-45
        for netfilter-devel@vger.kernel.org; Mon, 21 Nov 2022 22:27:30 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 17/34] db: change return type of two functions to `void`
Date:   Mon, 21 Nov 2022 22:25:54 +0000
Message-Id: <20221121222611.3914559-18-jeremy@azazel.net>
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

`_stop_db` and `_loop_reconnect_db` always return successfully.  Change
the return types and remove error-checking from callers.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 util/db.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/util/db.c b/util/db.c
index cd9ebef077dd..0514a87e0759 100644
--- a/util/db.c
+++ b/util/db.c
@@ -43,7 +43,7 @@ static int _interp_db_init(struct ulogd_pluginstance *upi);
 static int _interp_db_main(struct ulogd_pluginstance *upi);
 static int _interp_db_disabled(struct ulogd_pluginstance *upi);
 static int _reconnect_db(struct ulogd_pluginstance *upi);
-static int _stop_db(struct ulogd_pluginstance *upi);
+static void _stop_db(struct ulogd_pluginstance *upi);
 
 static char *_format_key(char *key);
 static int _create_sql_stmt(struct ulogd_pluginstance *upi);
@@ -56,7 +56,7 @@ static int _process_backlog(struct ulogd_pluginstance *upi);
 
 static int _add_to_ring(struct ulogd_pluginstance *upi, struct db_instance *di);
 static void *_process_ring(void *arg);
-static int _loop_reconnect_db(struct ulogd_pluginstance *upi);
+static void _loop_reconnect_db(struct ulogd_pluginstance *upi);
 
 int
 ulogd_db_configure(struct ulogd_pluginstance *upi,
@@ -378,7 +378,7 @@ _reconnect_db(struct ulogd_pluginstance *upi)
 	return 0;
 }
 
-static int
+static void
 _stop_db(struct ulogd_pluginstance *upi)
 {
 	struct db_instance *di = (struct db_instance *) upi->private;
@@ -397,7 +397,6 @@ _stop_db(struct ulogd_pluginstance *upi)
 		pthread_mutex_destroy(&di->ring.mutex);
 		di->ring.ring = NULL;
 	}
-	return 0;
 }
 
 static char *
@@ -695,14 +694,10 @@ _process_ring(void *gdi)
 		while (*wr_place == RING_QUERY_READY) {
 			if (di->driver->execute(upi, wr_place + 1,
 						strlen(wr_place + 1)) < 0) {
-				if (_loop_reconnect_db(upi) != 0) {
-					/* loop has failed on unrecoverable error */
-					ulogd_log(ULOGD_ERROR,
-						  "permanently disabling plugin\n");
-					di->interp = &_interp_db_disabled;
-					return NULL;
-				} else /* try to re run query */
-					continue;
+				_loop_reconnect_db(upi);
+				/* try to re run query */
+				continue;
+
 			}
 			*wr_place = RING_NO_QUERY;
 			di->ring.rd_item++;
@@ -717,7 +712,7 @@ _process_ring(void *gdi)
 	return NULL;
 }
 
-static int
+static void
 _loop_reconnect_db(struct ulogd_pluginstance * upi)
 {
 	struct db_instance *di = (struct db_instance *) &upi->private;
@@ -727,8 +722,7 @@ _loop_reconnect_db(struct ulogd_pluginstance * upi)
 		if (di->driver->open_db(upi) < 0) {
 			sleep(1);
 		} else {
-			return 0;
+			return;
 		}
 	}
-	return 0;
 }
-- 
2.35.1

