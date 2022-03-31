Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06390C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Mar 2022 15:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238056AbiCaPQs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Mar 2022 11:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238058AbiCaPQl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Mar 2022 11:16:41 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1DCEC60CF5
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2022 08:14:52 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E67E363052;
        Thu, 31 Mar 2022 17:11:30 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf-next,v2] netfilter: nft_fib: reverse path filter for policy-based routing on iif
Date:   Thu, 31 Mar 2022 17:14:47 +0200
Message-Id: <20220331151447.12074-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If policy-based routing using the iif selector is used, then the fib
expression fails to look up for the reverse path from the prerouting
hook because the input interface cannot be inferred. In order to support
this scenario, extend the fib expression to allow to use after the route
lookup, from the input and forward hooks.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: allow to use it from the input hook too.

 net/ipv4/netfilter/nft_fib_ipv4.c | 4 ++++
 net/ipv6/netfilter/nft_fib_ipv6.c | 4 ++++
 net/netfilter/nft_fib.c           | 4 ++++
 3 files changed, 12 insertions(+)

diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 4151eb1262dd..b75cac69bd7e 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -112,6 +112,10 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		fl4.daddr = iph->daddr;
 		fl4.saddr = get_saddr(iph->saddr);
 	} else {
+		if (nft_hook(pkt) == NF_INET_FORWARD &&
+		    priv->flags & NFTA_FIB_F_IIF)
+			fl4.flowi4_iif = nft_out(pkt)->ifindex;
+
 		fl4.daddr = iph->saddr;
 		fl4.saddr = get_saddr(iph->daddr);
 	}
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index b3f163b40c2b..8970d0b4faeb 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -30,6 +30,10 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
 		fl6->daddr = iph->daddr;
 		fl6->saddr = iph->saddr;
 	} else {
+		if (nft_hook(pkt) == NF_INET_FORWARD &&
+		    priv->flags & NFTA_FIB_F_IIF)
+			fl6->flowi6_iif = nft_out(pkt)->ifindex;
+
 		fl6->daddr = iph->saddr;
 		fl6->saddr = iph->daddr;
 	}
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index f198f2d9ef90..1f12d7ade606 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -35,6 +35,10 @@ int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	case NFT_FIB_RESULT_OIF:
 	case NFT_FIB_RESULT_OIFNAME:
 		hooks = (1 << NF_INET_PRE_ROUTING);
+		if (priv->flags & NFTA_FIB_F_IIF) {
+			hooks |= (1 << NF_INET_LOCAL_IN) |
+				 (1 << NF_INET_FORWARD);
+		}
 		break;
 	case NFT_FIB_RESULT_ADDRTYPE:
 		if (priv->flags & NFTA_FIB_F_IIF)
-- 
2.30.2

