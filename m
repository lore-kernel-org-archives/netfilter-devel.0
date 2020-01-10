Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54842C33CA4
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 12:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A81B2077C
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 12:33:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="suPzMZjE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgAJMdO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Jan 2020 07:33:14 -0500
Received: from kadath.azazel.net ([81.187.231.250]:39618 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728151AbgAJMdO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 07:33:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SWH2fsNHdgS1g123EuVLW1bcyZaGJmRYynG26l5tOK8=; b=suPzMZjENa8lumwdhAS4N/i3e1
        zSUXkcIpkWIh1I69JB1gcw+P5QP6Ju3bDHxrK6/TMyfUq/X/Tg5z5jQ93DqWZ9fts3oGaQ7fJfakE
        ywOuUTTK7ve5v9JMjUHvk6SkZGjy7UYRGXemN+pMdVfRz14fpRnlAfjLgRDUSeowQlknDvrB0O3b1
        2AKF9rP+euqvBgHwi/TLqZqWeRaaC2pmDx11znfyP0sCvug9vnPrKICJI2Oqr0ActwzOHRq/VBFkS
        ZcU1sVFN5M2Q2nlw+rCxPIH8r+wmMBFYpvbke1Th+IQ/0rpnvzsMfrDCGcy7HPJs+XTeAt9W3xdZo
        WNTMV/8Q==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iptTV-0003by-6S
        for netfilter-devel@vger.kernel.org; Fri, 10 Jan 2020 12:33:13 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 2/3] netfilter: bitwise: replace gotos with returns.
Date:   Fri, 10 Jan 2020 12:33:11 +0000
Message-Id: <20200110123312.106438-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110123312.106438-1-jeremy@azazel.net>
References: <20200110123312.106438-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When dumping a bitwise expression, if any of the puts fails, we use goto
to jump to a label.  However, no clean-up is required and the only
statement at the label is a return.  Drop the goto's and return
immediately instead.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/nft_bitwise.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 10e9d50e4e19..d7724250be1f 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -107,24 +107,21 @@ static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
 
 	if (nft_dump_register(skb, NFTA_BITWISE_SREG, priv->sreg))
-		goto nla_put_failure;
+		return -1;
 	if (nft_dump_register(skb, NFTA_BITWISE_DREG, priv->dreg))
-		goto nla_put_failure;
+		return -1;
 	if (nla_put_be32(skb, NFTA_BITWISE_LEN, htonl(priv->len)))
-		goto nla_put_failure;
+		return -1;
 
 	if (nft_data_dump(skb, NFTA_BITWISE_MASK, &priv->mask,
 			  NFT_DATA_VALUE, priv->len) < 0)
-		goto nla_put_failure;
+		return -1;
 
 	if (nft_data_dump(skb, NFTA_BITWISE_XOR, &priv->xor,
 			  NFT_DATA_VALUE, priv->len) < 0)
-		goto nla_put_failure;
+		return -1;
 
 	return 0;
-
-nla_put_failure:
-	return -1;
 }
 
 static struct nft_data zero;
-- 
2.24.1

