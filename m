Return-Path: <SRS0=B2LC=D5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BDA1C5517A
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 19:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB22F207C4
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 19:44:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="rPGVzr4L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370383AbgJVTog (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Oct 2020 15:44:36 -0400
Received: from mx1.riseup.net ([198.252.153.129]:44142 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S370377AbgJVTof (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Oct 2020 15:44:35 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4CHHr248TSzFvhr;
        Thu, 22 Oct 2020 12:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1603395874; bh=pQ504p2HowEfDIQ3F37pgkUDHTtJngw3QzSKGpsdfMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPGVzr4LvWKBBBwTJ2nT2jNwP5pC2C79QnE9ehyVJlNiTIeEm1CBEfu8M0MD8Qltx
         UwvySogkvLGQx4bIF1ZArSr+YkEWKPgxd/9GYQfRrs6hb8vAYrfTVJrjo98CXt+lmB
         2bAvyxdVHJEnaGZuZ6EOXVsqsfJWPAOaARTH2E/A=
X-Riseup-User-ID: 832587DF0FAB7B58E39A15F5138F5D2C92ABF228284D5290A0F344FA3116C04F
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4CHHr15XDSz8sX6;
        Thu, 22 Oct 2020 12:44:33 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 2/5] net: netfilter: unify reject init and dump into nft_reject
Date:   Thu, 22 Oct 2020 21:43:52 +0200
Message-Id: <20201022194355.1816-3-guigom@riseup.net>
In-Reply-To: <20201022194355.1816-1-guigom@riseup.net>
References: <20201022194355.1816-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Bridge family is using the same static init and dump function as inet.

This patch removes duplicate code unifying these functions body into
nft_reject.c so they can be reused in the rest of families supporting
reject verdict.

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 net/bridge/netfilter/nft_reject_bridge.c | 60 +-----------------------
 net/netfilter/nft_reject.c               | 12 ++++-
 net/netfilter/nft_reject_inet.c          | 60 +-----------------------
 3 files changed, 15 insertions(+), 117 deletions(-)

diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index 25ca7723c6c2..eba0efe64d05 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -177,69 +177,13 @@ static int nft_reject_bridge_validate(const struct nft_ctx *ctx,
 						    (1 << NF_BR_LOCAL_IN));
 }
 
-static int nft_reject_bridge_init(const struct nft_ctx *ctx,
-				  const struct nft_expr *expr,
-				  const struct nlattr * const tb[])
-{
-	struct nft_reject *priv = nft_expr_priv(expr);
-	int icmp_code;
-
-	if (tb[NFTA_REJECT_TYPE] == NULL)
-		return -EINVAL;
-
-	priv->type = ntohl(nla_get_be32(tb[NFTA_REJECT_TYPE]));
-	switch (priv->type) {
-	case NFT_REJECT_ICMP_UNREACH:
-	case NFT_REJECT_ICMPX_UNREACH:
-		if (tb[NFTA_REJECT_ICMP_CODE] == NULL)
-			return -EINVAL;
-
-		icmp_code = nla_get_u8(tb[NFTA_REJECT_ICMP_CODE]);
-		if (priv->type == NFT_REJECT_ICMPX_UNREACH &&
-		    icmp_code > NFT_REJECT_ICMPX_MAX)
-			return -EINVAL;
-
-		priv->icmp_code = icmp_code;
-		break;
-	case NFT_REJECT_TCP_RST:
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int nft_reject_bridge_dump(struct sk_buff *skb,
-				  const struct nft_expr *expr)
-{
-	const struct nft_reject *priv = nft_expr_priv(expr);
-
-	if (nla_put_be32(skb, NFTA_REJECT_TYPE, htonl(priv->type)))
-		goto nla_put_failure;
-
-	switch (priv->type) {
-	case NFT_REJECT_ICMP_UNREACH:
-	case NFT_REJECT_ICMPX_UNREACH:
-		if (nla_put_u8(skb, NFTA_REJECT_ICMP_CODE, priv->icmp_code))
-			goto nla_put_failure;
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-
-nla_put_failure:
-	return -1;
-}
-
 static struct nft_expr_type nft_reject_bridge_type;
 static const struct nft_expr_ops nft_reject_bridge_ops = {
 	.type		= &nft_reject_bridge_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_reject)),
 	.eval		= nft_reject_bridge_eval,
-	.init		= nft_reject_bridge_init,
-	.dump		= nft_reject_bridge_dump,
+	.init		= nft_reject_init,
+	.dump		= nft_reject_dump,
 	.validate	= nft_reject_bridge_validate,
 };
 
diff --git a/net/netfilter/nft_reject.c b/net/netfilter/nft_reject.c
index 61fb7e8afbf0..927ff8459bd9 100644
--- a/net/netfilter/nft_reject.c
+++ b/net/netfilter/nft_reject.c
@@ -40,6 +40,7 @@ int nft_reject_init(const struct nft_ctx *ctx,
 		    const struct nlattr * const tb[])
 {
 	struct nft_reject *priv = nft_expr_priv(expr);
+	int icmp_code;
 
 	if (tb[NFTA_REJECT_TYPE] == NULL)
 		return -EINVAL;
@@ -47,9 +48,17 @@ int nft_reject_init(const struct nft_ctx *ctx,
 	priv->type = ntohl(nla_get_be32(tb[NFTA_REJECT_TYPE]));
 	switch (priv->type) {
 	case NFT_REJECT_ICMP_UNREACH:
+	case NFT_REJECT_ICMPX_UNREACH:
 		if (tb[NFTA_REJECT_ICMP_CODE] == NULL)
 			return -EINVAL;
-		priv->icmp_code = nla_get_u8(tb[NFTA_REJECT_ICMP_CODE]);
+
+		icmp_code = nla_get_u8(tb[NFTA_REJECT_ICMP_CODE]);
+		if (priv->type == NFT_REJECT_ICMPX_UNREACH &&
+		    icmp_code > NFT_REJECT_ICMPX_MAX)
+			return -EINVAL;
+
+		priv->icmp_code = icmp_code;
+		break;
 	case NFT_REJECT_TCP_RST:
 		break;
 	default:
@@ -69,6 +78,7 @@ int nft_reject_dump(struct sk_buff *skb, const struct nft_expr *expr)
 
 	switch (priv->type) {
 	case NFT_REJECT_ICMP_UNREACH:
+	case NFT_REJECT_ICMPX_UNREACH:
 		if (nla_put_u8(skb, NFTA_REJECT_ICMP_CODE, priv->icmp_code))
 			goto nla_put_failure;
 		break;
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index cf8f2646e93c..ffd1aa1f9576 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -58,69 +58,13 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 	regs->verdict.code = NF_DROP;
 }
 
-static int nft_reject_inet_init(const struct nft_ctx *ctx,
-				const struct nft_expr *expr,
-				const struct nlattr * const tb[])
-{
-	struct nft_reject *priv = nft_expr_priv(expr);
-	int icmp_code;
-
-	if (tb[NFTA_REJECT_TYPE] == NULL)
-		return -EINVAL;
-
-	priv->type = ntohl(nla_get_be32(tb[NFTA_REJECT_TYPE]));
-	switch (priv->type) {
-	case NFT_REJECT_ICMP_UNREACH:
-	case NFT_REJECT_ICMPX_UNREACH:
-		if (tb[NFTA_REJECT_ICMP_CODE] == NULL)
-			return -EINVAL;
-
-		icmp_code = nla_get_u8(tb[NFTA_REJECT_ICMP_CODE]);
-		if (priv->type == NFT_REJECT_ICMPX_UNREACH &&
-		    icmp_code > NFT_REJECT_ICMPX_MAX)
-			return -EINVAL;
-
-		priv->icmp_code = icmp_code;
-		break;
-	case NFT_REJECT_TCP_RST:
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int nft_reject_inet_dump(struct sk_buff *skb,
-				const struct nft_expr *expr)
-{
-	const struct nft_reject *priv = nft_expr_priv(expr);
-
-	if (nla_put_be32(skb, NFTA_REJECT_TYPE, htonl(priv->type)))
-		goto nla_put_failure;
-
-	switch (priv->type) {
-	case NFT_REJECT_ICMP_UNREACH:
-	case NFT_REJECT_ICMPX_UNREACH:
-		if (nla_put_u8(skb, NFTA_REJECT_ICMP_CODE, priv->icmp_code))
-			goto nla_put_failure;
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-
-nla_put_failure:
-	return -1;
-}
-
 static struct nft_expr_type nft_reject_inet_type;
 static const struct nft_expr_ops nft_reject_inet_ops = {
 	.type		= &nft_reject_inet_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_reject)),
 	.eval		= nft_reject_inet_eval,
-	.init		= nft_reject_inet_init,
-	.dump		= nft_reject_inet_dump,
+	.init		= nft_reject_init,
+	.dump		= nft_reject_dump,
 	.validate	= nft_reject_validate,
 };
 
-- 
2.28.0

