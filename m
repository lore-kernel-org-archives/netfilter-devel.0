Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7671C742A7
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 23:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjCGXXR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 18:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjCGXXO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 18:23:14 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2323C39CD5
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 15:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WJzgci6VJzcphQgQXkiCUuvqGyrmOWXwhjOnD/dXt1k=; b=XrtDQKLMiEdLigq+QKVxATyvVi
        JTts1wOHo13wrwmbrhrCYi8ZmzpK2ImliVqFBQS9dp+PfR9pDbtyAMXPEwit3RAsfu9Ss921BKLxc
        pokRnbKnL1pO35G8pypmItZ4IBCWLWXTEb9ofKmSSjgZnW+SZ3iekii1lTUYrG83Tv+Y8Bry3x8Ox
        Z9yK2rkcO3FBoe1tEru2zWQ54y+G72oBgjvvPEicU4+UKv6spu7tR3yTjYGh7g1QXnCy5L4l5zNUG
        s/+s4hAqaubMsZeYVciFxMLkbsR3TExZ7OpKfgaxoop4T5u6XLYkuLg8y4GdijCf3F8DM/tuY7UrX
        5UEsqC1A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pZgeA-00H2Fp-2X
        for netfilter-devel@vger.kernel.org; Tue, 07 Mar 2023 23:23:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf 4/4] netfilter: nft_redir: correct value of inet type `.maxattrs`
Date:   Tue,  7 Mar 2023 23:22:59 +0000
Message-Id: <20230307232259.2681135-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307232259.2681135-1-jeremy@azazel.net>
References: <20230307232259.2681135-1-jeremy@azazel.net>
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
index dbc642f5d32a..67cec56bc84a 100644
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

