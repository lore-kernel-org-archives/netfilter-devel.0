Return-Path: <SRS0=T6Q7=W3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48DC4C3A59F
	for <netfilter-devel@archiver.kernel.org>; Sat, 31 Aug 2019 10:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F16C021670
	for <netfilter-devel@archiver.kernel.org>; Sat, 31 Aug 2019 10:15:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="SKv8i2s0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfHaKPS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 31 Aug 2019 06:15:18 -0400
Received: from mx1.riseup.net ([198.252.153.129]:37290 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726498AbfHaKPS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 31 Aug 2019 06:15:18 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id D563D1A31B7
        for <netfilter-devel@vger.kernel.org>; Sat, 31 Aug 2019 03:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1567246517; bh=vuZSgGlxtd8O7gc9e7i7X5l393FRm8OVbD4jTU2Obxg=;
        h=From:To:Cc:Subject:Date:From;
        b=SKv8i2s0Ohsbbq0PxbaSsOj4cD03eSk67NrdOwwYAH+/+5Gag0IOy6yUcR3S9NGOK
         7K51j54IjjRS5YundL61PoWJfgvr0wa99KMxeR43TorQDTdm5Teu0ek9L4OQ6VBuCT
         IVeI6ezu0dT+gXhyvBNpwY37P/cnQ9OOhCBGyM34=
X-Riseup-User-ID: AE336B88FF02ED5F67F11CC24903E1AF97C4140DC3E4DAF24333BBA924470F57
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id D62A7223307;
        Sat, 31 Aug 2019 03:15:15 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nf-next] netfilter: nft_socket: fix erroneous socket assignment
Date:   Sat, 31 Aug 2019 12:14:54 +0200
Message-Id: <20190831101453.1869-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This socket assignment was unnecessary and also added a missing sock_gen_put().

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

