Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C2E9C4332F
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Nov 2021 20:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbhKUUo5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Nov 2021 15:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbhKUUo4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Nov 2021 15:44:56 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DA5C061756
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Nov 2021 12:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ly9smOqTkgthz9ofo0x89W+sITpPDaLr30CSdcHgjig=; b=DRusOvMg5/jYULcTsLsrkiwx3L
        Kje0uvkWQuadBXNMzN7dwk5Vr4BKL2Q1ahDtFqj6rO+GKhpD+puRhUa6LBZOLLm4XIo4k4cUgXs7u
        RVjmgtFlc+/N9+ZeuWHiS5gjYZQ2leCfeP31iKzttDhgXFQOWtLKZoSGs1usdXsEQJV4Df0AehunH
        zfjyWDYa1AezXh++2kqJhTFzht1Zyup5LMSrH/1u4pkYtUbTD7YXTgwZBaX5Onk05PmXMeS74/ZXH
        OnIUjeMJOBHAJn9n2rbhdkwxsJUYeauZM240fuzkcJfaWnc3ukt00iLpcdfFMmBLdiCDhjGjEItOw
        D5dsQ8VA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1motel-0025lK-FD
        for netfilter-devel@vger.kernel.org; Sun, 21 Nov 2021 20:41:47 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 5/5] output: IPFIX: correct format specifiers
Date:   Sun, 21 Nov 2021 20:41:39 +0000
Message-Id: <20211121204139.2218387-6-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211121204139.2218387-1-jeremy@azazel.net>
References: <20211121204139.2218387-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There are a couple of logging calls which use the wrong specifiers for
their integer arguments.  Change the specifiers to match the arguments.

Use the correct type for the variable holding the return-value of
`send(2)`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/ipfix/ulogd_output_IPFIX.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/output/ipfix/ulogd_output_IPFIX.c b/output/ipfix/ulogd_output_IPFIX.c
index 5b5900363853..4863d008562e 100644
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
@@ -212,8 +213,8 @@ static int send_msgs(struct ulogd_pluginstance *pi)
 
 		/* TODO handle short send() for other protocols */
 		if ((size_t) sent < ipfix_msg_len(msg))
-			ulogd_log(ULOGD_ERROR, "short send: %d < %d\n",
-					sent, ipfix_msg_len(msg));
+			ulogd_log(ULOGD_ERROR, "short send: %zd < %zu\n",
+				  sent, ipfix_msg_len(msg));
 	}
 
 	llist_for_each_safe(curr, tmp, &priv->list) {
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

