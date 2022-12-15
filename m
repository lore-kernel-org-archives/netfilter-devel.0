Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71ED8C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Dec 2022 16:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiLOQST (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Dec 2022 11:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiLOQSS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Dec 2022 11:18:18 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9ED2EF4E
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2022 08:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MoCzM2cSvIfd3P/Kl76ghHtYou0sey33/GpshRgPKUw=; b=Gu1+eOJ+SeZDGT4bhUieWSHIyv
        TSVnNB/zCDbA7KPYYNnehHxu3hHEjFscg/TO6msN/NxjCacjcsoW6f3wpS0M/PA6MEyeEO21HwBxb
        /ChYKtX5CgLSY1RfVm9+U2I6Ke4T4XH43gt87UVEGkVgMvxyTW7dn9BnKGTX6VJ0+u0bF5ETNQRRg
        X7Z0wQK4GYJ9wBav+9+GJawS9Iz4PfioFwz/WwDQbu7N+El6xFnOOMRzGywl+GvpWyqguWorl5Kg3
        WrXF2hqZHd1BU2PyxR9Z/BxQ/OnPCwKyQZLKFfqH+1yRFms567fetIBUdwLdJUde9Ny9mDScuwHIL
        OUaTub9Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p5qw3-0001uP-DV; Thu, 15 Dec 2022 17:18:15 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 3/4] nft: Increase rule parser strictness
Date:   Thu, 15 Dec 2022 17:17:55 +0100
Message-Id: <20221215161756.3463-4-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221215161756.3463-1-phil@nwl.cc>
References: <20221215161756.3463-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Catch more unexpected conditions.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c    |  2 ++
 iptables/nft-bridge.c |  4 ++++
 iptables/nft-ipv4.c   |  4 +++-
 iptables/nft-ipv6.c   |  4 +++-
 iptables/nft-shared.c | 35 +++++++++++++++++++++++++----------
 5 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index edf179521e355..210f43d2cefbe 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -288,6 +288,8 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 
 			if (inv)
 				fw->arp.invflags |= IPT_INV_DSTIP;
+		} else {
+			ctx->errmsg = "unknown payload offset";
 		}
 		break;
 	}
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index e223d19765f90..83cbe31559d4b 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -287,6 +287,10 @@ static void nft_bridge_parse_payload(struct nft_xt_ctx *ctx,
 			fw->invflags |= EBT_IPROTO;
 		fw->bitmask &= ~EBT_NOPROTO;
 		break;
+	default:
+		DEBUGP("unknown payload offset %d\n", reg->payload.offset);
+		ctx->errmsg = "unknown payload offset";
+		break;
 	}
 }
 
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 42167351710e6..dcc4a8edfc87f 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -207,10 +207,12 @@ static void nft_ipv4_parse_payload(struct nft_xt_ctx *ctx,
 			cs->fw.ip.invflags |= IPT_INV_FRAG;
 		break;
 	case offsetof(struct iphdr, ttl):
-		nft_parse_hl(ctx, e, cs);
+		if (nft_parse_hl(ctx, e, cs) < 0)
+			ctx->errmsg = "invalid ttl field match";
 		break;
 	default:
 		DEBUGP("unknown payload offset %d\n", sreg->payload.offset);
+		ctx->errmsg = "unknown payload offset";
 		break;
 	}
 }
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 3a373b7eb2cfe..e98921856c75d 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -173,10 +173,12 @@ static void nft_ipv6_parse_payload(struct nft_xt_ctx *ctx,
 		if (inv)
 			cs->fw6.ipv6.invflags |= IP6T_INV_PROTO;
 	case offsetof(struct ip6_hdr, ip6_hlim):
-		nft_parse_hl(ctx, e, cs);
+		if (nft_parse_hl(ctx, e, cs) < 0)
+			ctx->errmsg = "invalid ttl field match";
 		break;
 	default:
 		DEBUGP("unknown payload offset %d\n", reg->payload.offset);
+		ctx->errmsg = "unknown payload offset";
 		break;
 	}
 }
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index d4b21921077d9..c13fc307e7a89 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -444,8 +444,10 @@ static void nft_parse_target(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	size_t size;
 
 	target = xtables_find_target(targname, XTF_TRY_LOAD);
-	if (target == NULL)
+	if (target == NULL) {
+		ctx->errmsg = "target extension not found";
 		return;
+	}
 
 	size = XT_ALIGN(sizeof(struct xt_entry_target)) + tg_len;
 
@@ -482,8 +484,10 @@ static void nft_parse_match(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	}
 
 	match = xtables_find_match(mt_name, XTF_TRY_LOAD, matches);
-	if (match == NULL)
+	if (match == NULL) {
+		ctx->errmsg = "match extension not found";
 		return;
+	}
 
 	m = xtables_calloc(1, sizeof(struct xt_entry_match) + mt_len);
 	memcpy(&m->data, mt_info, mt_len);
@@ -690,9 +694,10 @@ static struct xt_tcp *nft_tcp_match(struct nft_xt_ctx *ctx,
 
 	if (!tcp) {
 		match = nft_create_match(ctx, cs, "tcp");
-		if (!match)
+		if (!match) {
+			ctx->errmsg = "tcp match extension not found";
 			return NULL;
-
+		}
 		tcp = (void*)match->m->data;
 		ctx->tcpudp.tcp = tcp;
 	}
@@ -904,6 +909,8 @@ static void nft_parse_th_port(struct nft_xt_ctx *ctx,
 	case IPPROTO_TCP:
 		nft_parse_tcp(ctx, cs, sport, dport, op);
 		break;
+	default:
+		ctx->errmsg = "unknown layer 4 protocol for TH match";
 	}
 }
 
@@ -957,8 +964,8 @@ static void nft_parse_transport(struct nft_xt_ctx *ctx,
 		proto = ctx->cs->fw6.ipv6.proto;
 		break;
 	default:
-		proto = 0;
-		break;
+		ctx->errmsg = "invalid family for TH match";
+		return;
 	}
 
 	nftnl_expr_get(e, NFTNL_EXPR_CMP_DATA, &len);
@@ -1129,8 +1136,10 @@ static void nft_parse_immediate(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		if (!dreg)
 			return;
 
-		if (len > sizeof(dreg->immediate.data))
+		if (len > sizeof(dreg->immediate.data)) {
+			ctx->errmsg = "oversized immediate data";
 			return;
+		}
 
 		memcpy(dreg->immediate.data, imm_data, len);
 		dreg->immediate.len = len;
@@ -1163,8 +1172,10 @@ static void nft_parse_immediate(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	}
 
 	cs->target = xtables_find_target(cs->jumpto, XTF_TRY_LOAD);
-	if (!cs->target)
+	if (!cs->target) {
+		ctx->errmsg = "verdict extension not found";
 		return;
+	}
 
 	size = XT_ALIGN(sizeof(struct xt_entry_target)) + cs->target->size;
 	t = xtables_calloc(1, size);
@@ -1197,8 +1208,10 @@ static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	}
 
 	match = xtables_find_match("limit", XTF_TRY_LOAD, matches);
-	if (match == NULL)
+	if (match == NULL) {
+		ctx->errmsg = "limit match extension not found";
 		return;
+	}
 
 	size = XT_ALIGN(sizeof(struct xt_entry_match)) + match->size;
 	match->m = xtables_calloc(1, size);
@@ -1245,8 +1258,10 @@ static void nft_parse_log(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 			 nftnl_expr_get_str(e, NFTNL_EXPR_LOG_PREFIX));
 
 	target = xtables_find_target("NFLOG", XTF_TRY_LOAD);
-	if (target == NULL)
+	if (target == NULL) {
+		ctx->errmsg = "NFLOG target extension not found";
 		return;
+	}
 
 	target_size = XT_ALIGN(sizeof(struct xt_entry_target)) +
 		      XT_ALIGN(sizeof(struct xt_nflog_info_nft));
-- 
2.38.0

