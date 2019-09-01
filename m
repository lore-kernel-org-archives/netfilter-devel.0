Return-Path: <SRS0=UAOK=W4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 482D9C3A5A4
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 09:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01296216C8
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 09:48:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="XWlBLS21"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbfIAJsW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Sep 2019 05:48:22 -0400
Received: from mx1.riseup.net ([198.252.153.129]:50662 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728390AbfIAJsW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Sep 2019 05:48:22 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 9DD5E1A0593
        for <netfilter-devel@vger.kernel.org>; Sun,  1 Sep 2019 02:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1567331301; bh=EJFZc8kFAg8E57Z2xHWkyjTGnha2bQ4ZhEcAl6A80yM=;
        h=From:To:Cc:Subject:Date:From;
        b=XWlBLS21y4oil6NO1LBFQop4rbbIWPIROMFjqFUSTlSfLVFOIUaOisiwZqCywNbbG
         tQVbQcE6XIYBiq4hFOfcphMAs9Zz1Kbl/7pP4kqQ+Q+4RLjRcGtlnM0Cxri4IpPhO4
         45HUBN7YXtaG8aj/CxX07Tt+adiEGvjYd1/NR10I=
X-Riseup-User-ID: 2546AE5BE5E90C8DCED0BC1E07B4113DAC11C75B4C4EAE892C69045D5FED3724
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 63BD322278B;
        Sun,  1 Sep 2019 02:48:20 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nf-next v2] netfilter: nft_socket: fix erroneous socket assignment
Date:   Sun,  1 Sep 2019 11:48:08 +0200
Message-Id: <20190901094808.848-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The socket assignment is wrong, see skb_orphan():
When skb->destructor callback is not set, but skb->sk is set, this hits BUG().

Link: https://bugzilla.redhat.com/show_bug.cgi?id=1651813
Fixes: 554ced0a6e29 ("netfilter: nf_tables: add support for native socket matching")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 net/netfilter/nft_socket.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index d7f3776dfd71..637ce3e8c575 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -47,9 +47,6 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		return;
 	}
 
-	/* So that subsequent socket matching not to require other lookups. */
-	skb->sk = sk;
-
 	switch(priv->key) {
 	case NFT_SOCKET_TRANSPARENT:
 		nft_reg_store8(dest, inet_sk_transparent(sk));
@@ -66,6 +63,9 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		WARN_ON(1);
 		regs->verdict.code = NFT_BREAK;
 	}
+
+	if (sk != skb->sk)
+		sock_gen_put(sk);
 }
 
 static const struct nla_policy nft_socket_policy[NFTA_SOCKET_MAX + 1] = {
-- 
2.20.1

