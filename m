Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BDA2C43219
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F84260F93
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhJ3QrJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 12:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhJ3QrH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 12:47:07 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80772C061767
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 09:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9167Olj9Rgfx+iSaXyD5QS+BJpF6nFLTihPvt08TfSE=; b=BpZ/WtyjhEENQY3Qa8yheqHE1m
        pFvi5d8IVOH8T7WCc1/duT5xtUSlD1ZpgcQSNSCCoCmL7gnN00xMaWtA+0wXvnakzcvQ2w99fWpum
        kepyVG6Sur3X2bO0KuCjEx+Vbnj/rQr5Wdp5NY5rCC1Le7loi3HQzt4nyg7oFTMyGfLSeq4/k3pxQ
        4rEGQkRK0c0hFtmdqkFtoPsqXlQVzbgNeaiP2r1qFW0vTICYJjUSY2J83DoCXSVx2HzQwp7el6ITM
        XErnhxwRkl4453Hax3sgyt26CZYfqn7bFhBYF9DIagmHu03n3YYBQn4EaSkp8ZEMJHv37E1PQxPn4
        v8c/lpUA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrT8-00AFgT-Iw
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:34 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 05/26] output: IPFIX: correct format-specifiers.
Date:   Sat, 30 Oct 2021 17:44:11 +0100
Message-Id: <20211030164432.1140896-6-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211030164432.1140896-1-jeremy@azazel.net>
References: <20211030164432.1140896-1-jeremy@azazel.net>
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

