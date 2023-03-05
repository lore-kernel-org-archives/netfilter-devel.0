Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC45EC6FD1A
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Mar 2023 12:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjCEMeU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Mar 2023 07:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjCEMeR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2023 07:34:17 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FC9EC6F
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Mar 2023 04:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=riqQ9EAimefVbFXGaSW1OYnb8xynkex3cjAaJYkt0Jw=; b=QyOQjBlGacH0Hbivhw26NhvLgk
        fZb/pvyJP0rj8FjSMy2lQAFRISsEaJQPKJr97K4Zz3r5tSez+FWqlaVKi7TDqh4hO6gA5AGIeVZLZ
        K3zo+5EjPb37lrZc7kqP6IllwRRKv8jiExVg3mOiq1V9GlDai3i0GFyA8YNWUhGhe/+CtMqx1I7zk
        GKXA4tjsO8p12Dmy/gxBg6o062brbjbNoGY7MykCdZnu45+1PGFZojN+hupV5b2mgvl1d927n4t+P
        IcBDZAVxk8kapNEOjD6BGo9sjl11WyZ0AgWmFdtQEQcst83Z8bps66MyW01CBn4FE9xIdw3ASoW9R
        dx8356oA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYnZ7-00E3og-6o
        for netfilter-devel@vger.kernel.org; Sun, 05 Mar 2023 12:34:13 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 09/13] netfilter: nft_redir: correct value of inet type `.maxattrs`
Date:   Sun,  5 Mar 2023 12:18:13 +0000
Message-Id: <20230305121817.2234734-10-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305121817.2234734-1-jeremy@azazel.net>
References: <20230305121817.2234734-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`nft_redir_inet_type.maxattrs` was being set, presumably because of a
cut-and-paste error, to `NFTA_MASQ_MAX`, instead of `NFTA_REDIR_MAX`.

Fixes: 63ce3940f3ab ("netfilter: nft_redir: add inet support")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/nft_redir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index 5f7739987559..aa8545775ae7 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -236,7 +236,7 @@ static struct nft_expr_type nft_redir_inet_type __read_mostly = {
 	.name		= "redir",
 	.ops		= &nft_redir_inet_ops,
 	.policy		= nft_redir_policy,
-	.maxattr	= NFTA_MASQ_MAX,
+	.maxattr	= NFTA_REDIR_MAX,
 	.owner		= THIS_MODULE,
 };
 
-- 
2.39.2

