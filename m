Return-Path: <SRS0=kOBD=7V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F65C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jun 2020 19:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C5B82074B
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jun 2020 19:00:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="srAGaWzQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgFHTAj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jun 2020 15:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgFHTA0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jun 2020 15:00:26 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BD5C08C5C2
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2020 12:00:26 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id n24so19566073ejd.0
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Jun 2020 12:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=Z//DuGf15y1uQGWm+B3H5jjBixv5CrmRtleFd9InXCA=;
        b=srAGaWzQ9CHH8UHVdlPd+MUGqP/JPvis+CpGZQcHuhpCX7Scyz9a0fmwW9LBIChgad
         im2orC8HaQetH27VFxm5mIqiYG1b03hkxAEpI/oF4okErnn6/j46PaRxEnFVyoZdcFp6
         BmV48IY+qxLMHb0+u5dlqYaJoeVoxiZQRCSsWxckChOx+h9iUwVGIed8j1GRQQ5g1ZGS
         GRPAFGRc46cq38zQ0QItnnAlcEBbp5mSip3VIgyV2OLQ3HKOLy4ms2M8KJmUhPf5UUSJ
         OR6hzUQ4AWB8vzqU7kn2LbfAu2Ar1HC2qS70PzEeImR/+RZnbhJe9piZ8aZzJaRrNZlD
         zT3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Z//DuGf15y1uQGWm+B3H5jjBixv5CrmRtleFd9InXCA=;
        b=tsl3deb8C87pvRK+YTV0wdJoFOAlJu+QnXbuWFoIjGaOzKXBaszItlOxNV1Xh6/TEE
         TZ2O64SVjBXJrsATyh2XW+7/gzlbs0Lb8ZYlc6GkvdgTRjHKxDcF0SasXEVPIGtwmq2I
         8sPKogw13aNXgMHBTk5rMrK67z++QdTZ0xR6OYJomRivUMYNKsCSP4eMzv6f0Y4DxoOL
         GVvTqk07WCBrCZ69D/OZw67gtx5fk1U9QEwWZ9PQFfQXhQeZZtW9zZuvoOzgeIdY5TpZ
         g6QLscoCtrbIWaH9vqP1n4KB8Yju5QHwpw9n6ooAXk9W1j7QMGhk+4B446nrtd4/wtUK
         SvYw==
X-Gm-Message-State: AOAM531rmgcmJ9EobwX//YtqbrIBSXjn07EV8LPyg8Gf/PODlYe66Drq
        fU9Hd7u6T8CaKvYfE1e93kTK+0ibBmo=
X-Google-Smtp-Source: ABdhPJyaloaPISgFnaEnmVh1lqqPJfOlJfKH4bTiUL4ltRWginQbdy+6kdUE9eEBavLIixKYbDZKqg==
X-Received: by 2002:a17:906:3456:: with SMTP id d22mr21671352ejb.358.1591642824570;
        Mon, 08 Jun 2020 12:00:24 -0700 (PDT)
Received: from nevthink ([91.126.71.247])
        by smtp.gmail.com with ESMTPSA id v29sm13572221edb.62.2020.06.08.12.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 12:00:23 -0700 (PDT)
Date:   Mon, 8 Jun 2020 21:00:21 +0200
From:   Laura Garcia Liebana <nevola@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, devel@zevenet.com
Subject: [PATCH nf-next 1/2] netfilter: nft: refactor reject verdict source
 code
Message-ID: <20200608190021.GA23098@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Within REJECT modules there are duplicated code for different
families, so this patch re-structures the source code in order
to reuse as much as possible. The refactoring produces ~30 lines
removed in total and prepares the code to be added the ingress
support of REJECT.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 include/net/netfilter/ipv4/nft_reject_ipv4.h |   9 ++
 include/net/netfilter/ipv6/nft_reject_ipv6.h |   9 ++
 include/net/netfilter/nft_reject.h           |   3 +
 net/ipv4/netfilter/nft_reject_ipv4.c         |  12 ++-
 net/ipv6/netfilter/nft_reject_ipv6.c         |  16 ++-
 net/netfilter/nft_reject.c                   |  29 +++++-
 net/netfilter/nft_reject_inet.c              | 101 ++-----------------
 7 files changed, 77 insertions(+), 102 deletions(-)
 create mode 100644 include/net/netfilter/ipv4/nft_reject_ipv4.h
 create mode 100644 include/net/netfilter/ipv6/nft_reject_ipv6.h

diff --git a/include/net/netfilter/ipv4/nft_reject_ipv4.h b/include/net/netfilter/ipv4/nft_reject_ipv4.h
new file mode 100644
index 000000000000..364810b613c2
--- /dev/null
+++ b/include/net/netfilter/ipv4/nft_reject_ipv4.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NFT_REJECT_IPV4_H_
+#define _NFT_REJECT_IPV4_H_
+
+void nft_reject_ipv4_eval(const struct nft_expr *expr,
+			  struct nft_regs *regs,
+			  const struct nft_pktinfo *pkt);
+
+#endif
diff --git a/include/net/netfilter/ipv6/nft_reject_ipv6.h b/include/net/netfilter/ipv6/nft_reject_ipv6.h
new file mode 100644
index 000000000000..568297083858
--- /dev/null
+++ b/include/net/netfilter/ipv6/nft_reject_ipv6.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NFT_REJECT_IPV6_H_
+#define _NFT_REJECT_IPV6_H_
+
+void nft_reject_ipv6_eval(const struct nft_expr *expr,
+			  struct nft_regs *regs,
+			  const struct nft_pktinfo *pkt);
+
+#endif
diff --git a/include/net/netfilter/nft_reject.h b/include/net/netfilter/nft_reject.h
index 56b123a42220..3a3a0a4eaac9 100644
--- a/include/net/netfilter/nft_reject.h
+++ b/include/net/netfilter/nft_reject.h
@@ -26,5 +26,8 @@ int nft_reject_dump(struct sk_buff *skb, const struct nft_expr *expr);
 
 int nft_reject_icmp_code(u8 code);
 int nft_reject_icmpv6_code(u8 code);
+int nft_reject_generic_validate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr,
+				const struct nft_data **data);
 
 #endif
diff --git a/net/ipv4/netfilter/nft_reject_ipv4.c b/net/ipv4/netfilter/nft_reject_ipv4.c
index 7e6fd5cde50f..39414795a5c2 100644
--- a/net/ipv4/netfilter/nft_reject_ipv4.c
+++ b/net/ipv4/netfilter/nft_reject_ipv4.c
@@ -16,9 +16,9 @@
 #include <net/netfilter/ipv4/nf_reject.h>
 #include <net/netfilter/nft_reject.h>
 
-static void nft_reject_ipv4_eval(const struct nft_expr *expr,
-				 struct nft_regs *regs,
-				 const struct nft_pktinfo *pkt)
+void nft_reject_ipv4_eval(const struct nft_expr *expr,
+			  struct nft_regs *regs,
+			  const struct nft_pktinfo *pkt)
 {
 	struct nft_reject *priv = nft_expr_priv(expr);
 
@@ -29,12 +29,18 @@ static void nft_reject_ipv4_eval(const struct nft_expr *expr,
 	case NFT_REJECT_TCP_RST:
 		nf_send_reset(nft_net(pkt), pkt->skb, nft_hook(pkt));
 		break;
+	case NFT_REJECT_ICMPX_UNREACH:
+		nf_send_unreach(pkt->skb,
+				nft_reject_icmp_code(priv->icmp_code),
+				nft_hook(pkt));
+		break;
 	default:
 		break;
 	}
 
 	regs->verdict.code = NF_DROP;
 }
+EXPORT_SYMBOL_GPL(nft_reject_ipv4_eval);
 
 static struct nft_expr_type nft_reject_ipv4_type;
 static const struct nft_expr_ops nft_reject_ipv4_ops = {
diff --git a/net/ipv6/netfilter/nft_reject_ipv6.c b/net/ipv6/netfilter/nft_reject_ipv6.c
index 680a28ce29fd..8a2ad7ad387e 100644
--- a/net/ipv6/netfilter/nft_reject_ipv6.c
+++ b/net/ipv6/netfilter/nft_reject_ipv6.c
@@ -15,13 +15,17 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nft_reject.h>
 #include <net/netfilter/ipv6/nf_reject.h>
+#include <net/ipv6.h>
 
-static void nft_reject_ipv6_eval(const struct nft_expr *expr,
-				 struct nft_regs *regs,
-				 const struct nft_pktinfo *pkt)
+void nft_reject_ipv6_eval(const struct nft_expr *expr,
+			  struct nft_regs *regs,
+			  const struct nft_pktinfo *pkt)
 {
 	struct nft_reject *priv = nft_expr_priv(expr);
 
+	if (!ipv6_mod_enabled())
+		return;
+
 	switch (priv->type) {
 	case NFT_REJECT_ICMP_UNREACH:
 		nf_send_unreach6(nft_net(pkt), pkt->skb, priv->icmp_code,
@@ -30,12 +34,18 @@ static void nft_reject_ipv6_eval(const struct nft_expr *expr,
 	case NFT_REJECT_TCP_RST:
 		nf_send_reset6(nft_net(pkt), pkt->skb, nft_hook(pkt));
 		break;
+	case NFT_REJECT_ICMPX_UNREACH:
+		nf_send_unreach6(nft_net(pkt), pkt->skb,
+				 nft_reject_icmpv6_code(priv->icmp_code),
+				 nft_hook(pkt));
+		break;
 	default:
 		break;
 	}
 
 	regs->verdict.code = NF_DROP;
 }
+EXPORT_SYMBOL_GPL(nft_reject_ipv6_eval);
 
 static struct nft_expr_type nft_reject_ipv6_type;
 static const struct nft_expr_ops nft_reject_ipv6_ops = {
diff --git a/net/netfilter/nft_reject.c b/net/netfilter/nft_reject.c
index 5eac28269bdb..bd796e4e8468 100644
--- a/net/netfilter/nft_reject.c
+++ b/net/netfilter/nft_reject.c
@@ -26,6 +26,20 @@ EXPORT_SYMBOL_GPL(nft_reject_policy);
 int nft_reject_validate(const struct nft_ctx *ctx,
 			const struct nft_expr *expr,
 			const struct nft_data **data)
+{
+	struct nft_reject *priv = nft_expr_priv(expr);
+
+	if (priv->type != NFT_REJECT_ICMP_UNREACH &&
+		priv->type != NFT_REJECT_TCP_RST)
+		return -EINVAL;
+
+	return nft_reject_generic_validate(ctx, expr, data);
+}
+EXPORT_SYMBOL_GPL(nft_reject_validate);
+
+int nft_reject_generic_validate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr,
+				const struct nft_data **data)
 {
 	return nft_chain_validate_hooks(ctx->chain,
 					(1 << NF_INET_LOCAL_IN) |
@@ -33,13 +47,14 @@ int nft_reject_validate(const struct nft_ctx *ctx,
 					(1 << NF_INET_LOCAL_OUT) |
 					(1 << NF_INET_PRE_ROUTING));
 }
-EXPORT_SYMBOL_GPL(nft_reject_validate);
+EXPORT_SYMBOL_GPL(nft_reject_generic_validate);
 
 int nft_reject_init(const struct nft_ctx *ctx,
 		    const struct nft_expr *expr,
 		    const struct nlattr * const tb[])
 {
 	struct nft_reject *priv = nft_expr_priv(expr);
+	int icmp_code;
 
 	if (tb[NFTA_REJECT_TYPE] == NULL)
 		return -EINVAL;
@@ -47,15 +62,22 @@ int nft_reject_init(const struct nft_ctx *ctx,
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
 		return -EINVAL;
 	}
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nft_reject_init);
@@ -69,6 +91,7 @@ int nft_reject_dump(struct sk_buff *skb, const struct nft_expr *expr)
 
 	switch (priv->type) {
 	case NFT_REJECT_ICMP_UNREACH:
+	case NFT_REJECT_ICMPX_UNREACH:
 		if (nla_put_u8(skb, NFTA_REJECT_ICMP_CODE, priv->icmp_code))
 			goto nla_put_failure;
 		break;
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index f41f414b72d1..4c5d37b1bd22 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (c) 2014 Patrick McHardy <kaber@trash.net>
+ * Copyright (c) 2020 Laura Garcia Liebana <nevola@gmail.com>
  */
 
 #include <linux/kernel.h>
@@ -11,107 +12,21 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nft_reject.h>
-#include <net/netfilter/ipv4/nf_reject.h>
-#include <net/netfilter/ipv6/nf_reject.h>
+#include <net/netfilter/ipv4/nft_reject_ipv4.h>
+#include <net/netfilter/ipv6/nft_reject_ipv6.h>
 
 static void nft_reject_inet_eval(const struct nft_expr *expr,
 				 struct nft_regs *regs,
 				 const struct nft_pktinfo *pkt)
 {
-	struct nft_reject *priv = nft_expr_priv(expr);
-
 	switch (nft_pf(pkt)) {
 	case NFPROTO_IPV4:
-		switch (priv->type) {
-		case NFT_REJECT_ICMP_UNREACH:
-			nf_send_unreach(pkt->skb, priv->icmp_code,
-					nft_hook(pkt));
-			break;
-		case NFT_REJECT_TCP_RST:
-			nf_send_reset(nft_net(pkt), pkt->skb, nft_hook(pkt));
-			break;
-		case NFT_REJECT_ICMPX_UNREACH:
-			nf_send_unreach(pkt->skb,
-					nft_reject_icmp_code(priv->icmp_code),
-					nft_hook(pkt));
-			break;
-		}
+		nft_reject_ipv4_eval(expr, regs, pkt);
 		break;
 	case NFPROTO_IPV6:
-		switch (priv->type) {
-		case NFT_REJECT_ICMP_UNREACH:
-			nf_send_unreach6(nft_net(pkt), pkt->skb,
-					 priv->icmp_code, nft_hook(pkt));
-			break;
-		case NFT_REJECT_TCP_RST:
-			nf_send_reset6(nft_net(pkt), pkt->skb, nft_hook(pkt));
-			break;
-		case NFT_REJECT_ICMPX_UNREACH:
-			nf_send_unreach6(nft_net(pkt), pkt->skb,
-					 nft_reject_icmpv6_code(priv->icmp_code),
-					 nft_hook(pkt));
-			break;
-		}
-		break;
-	}
-
-	regs->verdict.code = NF_DROP;
-}
-
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
+		nft_reject_ipv6_eval(expr, regs, pkt);
 		break;
-	case NFT_REJECT_TCP_RST:
-		break;
-	default:
-		return -EINVAL;
 	}
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
 }
 
 static struct nft_expr_type nft_reject_inet_type;
@@ -119,9 +34,9 @@ static const struct nft_expr_ops nft_reject_inet_ops = {
 	.type		= &nft_reject_inet_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_reject)),
 	.eval		= nft_reject_inet_eval,
-	.init		= nft_reject_inet_init,
-	.dump		= nft_reject_inet_dump,
-	.validate	= nft_reject_validate,
+	.init		= nft_reject_init,
+	.dump		= nft_reject_dump,
+	.validate	= nft_reject_generic_validate,
 };
 
 static struct nft_expr_type nft_reject_inet_type __read_mostly = {
-- 
2.20.1

