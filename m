Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A48C43219
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4889C60F9D
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbhKFQw6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbhKFQwt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 12:52:49 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1260AC061208
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 09:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9167Olj9Rgfx+iSaXyD5QS+BJpF6nFLTihPvt08TfSE=; b=WSS9ZOMHWjn5/J/9TrOPe0rBJ/
        lgTANyQ4CVmozgCruYCqun8o0PKyX3D/IbFUlC40R7tnMktX2MH8W+jR32dVghCrC3ubHlCXwlu+M
        bX0D8h7hO9v4u8US64QqU5SVo6fi3qvLC0p2Hh+qFzFs85v3KE0Aw658OWC1DdVAOISkjbYxj4erH
        QGg//tK/QtqPpbfbrt3B43LF6QXkIk7jCby+MOr2dknZ47AWyMrrUOuX3sdBpkhJS0A3C7XZ0Hr38
        ohNthBs57kFiV5ypl4ydK5hToZLhjLVHnEoRgUFr+LGNAD1aKVopO5/YoDnYKMFV44YD1qwOoML7R
        3O3ladKQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOtJ-004m1E-EC
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:50:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 05/27] output: IPFIX: correct format-specifiers
Date:   Sat,  6 Nov 2021 16:49:31 +0000
Message-Id: <20211106164953.130024-6-jeremy@azazel.net>
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
 output/ipfix/ulogd_output_IPFIX.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/output/ipfix/ulogd_output_IPFIX.c b/output/ipfix/ulogd_output_IPFIX.c
index 5b5900363853..508d5f4974fc 100644
--- a/output/ipfix/ulogd_output_IPFIX.c
+++ b/output/ipfix/ulogd_output_IPFIX.c
@@ -198,7 +198,8 @@ static int send_msgs(struct ulogd_pluginstance *pi)
 	struct ipfix_priv *priv = (struct ipfix_priv *) &pi->private;
 	struct llist_head *curr, *tmp;
 	struct ipfix_msg *msg;
-	int ret = ULOGD_IRET_OK, sent;
+	int ret = ULOGD_IRET_OK;
+	ssize_t sent;
 
 	llist_for_each_prev(curr, &priv->list) {
 		msg = llist_entry(curr, struct ipfix_msg, link);
@@ -212,7 +213,7 @@ static int send_msgs(struct ulogd_pluginstance *pi)
 
 		/* TODO handle short send() for other protocols */
 		if ((size_t) sent < ipfix_msg_len(msg))
-			ulogd_log(ULOGD_ERROR, "short send: %d < %d\n",
+			ulogd_log(ULOGD_ERROR, "short send: %zd < %zu\n",
 					sent, ipfix_msg_len(msg));
 	}
 
@@ -242,7 +243,7 @@ static int ipfix_ufd_cb(int fd, unsigned what, void *arg)
 			ulogd_log(ULOGD_INFO, "connection reset by peer\n");
 			ulogd_unregister_fd(&priv->ufd);
 		} else
-			ulogd_log(ULOGD_INFO, "unexpected data (%d bytes)\n", nread);
+			ulogd_log(ULOGD_INFO, "unexpected data (%zd bytes)\n", nread);
 	}
 
 	return 0;
-- 
2.33.0

