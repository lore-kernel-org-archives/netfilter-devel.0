Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 455DFC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 22:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbiKUW5Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKUW5X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 17:57:23 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651CFC67D3
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 14:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xHpkBGJwHMBmnl20zmNGiZyEmQXxjU10T66p+6wSZhs=; b=Wm5qLVIwe36Zq4r9nYkv/T4O2N
        s3ehjkFGrWHNSjUatrEbAqIaC2lbS5eCU734lHKq0k7Wndjc4G5s4LGCRHWn0xIPY+4IgK2ZXLFl0
        SJMj78g9in3tDIgrOAM6v6eouY4REwhAjsIPm+5ddyeDuPkqkKBuSanOqQ0N4HQBDU7sEOge8fM0p
        ILXPwf7OCXzJ29pqZqE8y0qy9lTinY5Lu5l3s4LJWKsm0NYExnhRPeIeSHV9zFz4GjqGibLN1pe/0
        qq08o3AXMVQz4HyVflSoEmBvavg9yBmdO+EdXj/2jPTx84QijX0SKzay6cqQGj5x88n0QG7Dsd5u4
        AQu4/0wQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxFGF-005LgP-7H
        for netfilter-devel@vger.kernel.org; Mon, 21 Nov 2022 22:27:31 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 26/34] db: avoid cancelling ring-buffer thread
Date:   Mon, 21 Nov 2022 22:26:03 +0000
Message-Id: <20221121222611.3914559-27-jeremy@azazel.net>
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

Using `pthread_cancel` can leave the DB driver in an inconsistent state
and may lead to undefined behaviour when cleaning up the plug-in.
Instead of cancelling the thread, set a flag and signal the condition
variable, thereby giving the thread a chance to exit in good order.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/ulogd/db.h |  1 +
 util/db.c          | 30 +++++++++++++-----------------
 2 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/include/ulogd/db.h b/include/ulogd/db.h
index bf4a19dea150..17eaa7cf60db 100644
--- a/include/ulogd/db.h
+++ b/include/ulogd/db.h
@@ -47,6 +47,7 @@ struct db_stmt_ring {
 	pthread_mutex_t mutex;
 
 	int full;
+	volatile sig_atomic_t shut_down;
 
 };
 
diff --git a/util/db.c b/util/db.c
index 6cfbcbc16791..42b59cc6284c 100644
--- a/util/db.c
+++ b/util/db.c
@@ -184,17 +184,11 @@ ulogd_db_signal(struct ulogd_pluginstance *upi, int signal)
 	case SIGTERM:
 	case SIGINT:
 		if (di->ring.size) {
-			int s = pthread_cancel(di->ring.thread_id);
-			if (s != 0) {
+			di->ring.shut_down = 1;
+			pthread_cond_signal(&di->ring.cond);
+			if (pthread_join(di->ring.thread_id, NULL) != 0)
 				ulogd_log(ULOGD_ERROR,
-					  "Can't cancel ring-processing thread\n");
-				break;
-			}
-			s = pthread_join(di->ring.thread_id, NULL);
-			if (s != 0) {
-				ulogd_log(ULOGD_ERROR,
-					  "Error waiting for ring-processing thread cancellation\n");
-			}
+					  "Error waiting for ring-processing thread exit\n");
 		}
 		break;
 	default:
@@ -371,8 +365,6 @@ _stop_db(struct ulogd_pluginstance *upi)
 		di->stmt = NULL;
 	}
 	if (di->ring.size > 0) {
-		pthread_cancel(di->ring.thread_id);
-
 		pthread_cond_destroy(&di->ring.cond);
 		pthread_mutex_destroy(&di->ring.mutex);
 
@@ -832,11 +824,11 @@ _process_ring(void *arg)
 
 	pthread_mutex_lock(&di->ring.mutex);
 
-	while(1) {
+	while(!di->ring.shut_down) {
 
 		pthread_cond_wait(&di->ring.cond, &di->ring.mutex);
 
-		while (di->ring.used > 0) {
+		while (!di->ring.shut_down && di->ring.used > 0) {
 
 			memcpy(stmt, _get_ring_elem(&di->ring, di->ring.rd_idx),
 			       di->ring.length);
@@ -859,9 +851,13 @@ exec_stmt:
 			 * statement.
 			 */
 			di->driver->close_db(upi);
-			while (di->driver->open_db(upi) < 0)
-				sleep(1);
-			goto exec_stmt;
+			while (!di->ring.shut_down) {
+				if (di->driver->open_db(upi) < 0) {
+					sleep(1);
+					continue;
+				}
+				goto exec_stmt;
+			}
 
 		}
 
-- 
2.35.1

