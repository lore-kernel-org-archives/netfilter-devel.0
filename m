Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB06C43217
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 11:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbiKULY7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 06:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiKULYU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 06:24:20 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B94450B5
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 03:19:56 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ox4qB-0002Q3-8N; Mon, 21 Nov 2022 12:19:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [iptables-nft RFC 3/5] nft: check for unknown meta keys
Date:   Mon, 21 Nov 2022 12:19:30 +0100
Message-Id: <20221121111932.18222-4-fw@strlen.de>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221121111932.18222-1-fw@strlen.de>
References: <20221121111932.18222-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set ->errmsg when the meta key isn't supported by iptables-nft instead
of pretending everything is fine.

The old code is good enough to handle rules added by iptables-nft, but
its not enough to handle rules added by native nft.

At least make sure that there is a an error message telling that
iptables-nft could not decode the entire ruleset.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft-arp.c    | 9 ++++++---
 iptables/nft-bridge.c | 6 +++++-
 iptables/nft-ipv4.c   | 7 +++++--
 iptables/nft-ipv6.c   | 7 +++++--
 4 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index e9e111416d79..59f100af2a6b 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -168,11 +168,14 @@ static void nft_arp_parse_meta(struct nft_xt_ctx *ctx,
 	struct arpt_entry *fw = &cs->arp;
 	uint8_t flags = 0;
 
-	parse_meta(ctx, e, reg->meta_dreg.key, fw->arp.iniface, fw->arp.iniface_mask,
+	if (parse_meta(ctx, e, reg->meta_dreg.key, fw->arp.iniface, fw->arp.iniface_mask,
 		   fw->arp.outiface, fw->arp.outiface_mask,
-		   &flags);
+		   &flags) == 0) {
+		fw->arp.invflags |= flags;
+		return;
+	}
 
-	fw->arp.invflags |= flags;
+	ctx->errmsg = "Unknown arp meta key";
 }
 
 static void parse_mask_ipv4(const struct nft_xt_ctx_reg *reg, struct in_addr *mask)
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 749cbc6fbbaf..e8ac7a364169 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -197,7 +197,10 @@ static void nft_bridge_parse_meta(struct nft_xt_ctx *ctx,
 	uint8_t invflags = 0;
 	char iifname[IFNAMSIZ] = {}, oifname[IFNAMSIZ] = {};
 
-	parse_meta(ctx, e, reg->meta_dreg.key, iifname, NULL, oifname, NULL, &invflags);
+	if (parse_meta(ctx, e, reg->meta_dreg.key, iifname, NULL, oifname, NULL, &invflags) < 0) {
+		ctx->errmsg = "unknown meta key";
+		return;
+	}
 
 	switch (reg->meta_dreg.key) {
 	case NFT_META_BRI_IIFNAME:
@@ -221,6 +224,7 @@ static void nft_bridge_parse_meta(struct nft_xt_ctx *ctx,
 		snprintf(fw->out, sizeof(fw->out), "%s", oifname);
 		break;
 	default:
+		ctx->errmsg = "unknown bridge meta key";
 		break;
 	}
 }
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 92a914f1a4a4..6c62dd46ddda 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -146,9 +146,12 @@ static void nft_ipv4_parse_meta(struct nft_xt_ctx *ctx,
 		break;
 	}
 
-	parse_meta(ctx, e, reg->meta_dreg.key, cs->fw.ip.iniface, cs->fw.ip.iniface_mask,
+	if (parse_meta(ctx, e, reg->meta_dreg.key, cs->fw.ip.iniface, cs->fw.ip.iniface_mask,
 		   cs->fw.ip.outiface, cs->fw.ip.outiface_mask,
-		   &cs->fw.ip.invflags);
+		   &cs->fw.ip.invflags) == 0)
+		return;
+
+	ctx->errmsg = "unknown ipv4 meta key";
 }
 
 static void parse_mask_ipv4(const struct nft_xt_ctx_reg *sreg, struct in_addr *mask)
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 7ca9d842f2b1..98c35afa67ad 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -119,9 +119,12 @@ static void nft_ipv6_parse_meta(struct nft_xt_ctx *ctx,
 		break;
 	}
 
-	parse_meta(ctx, e, reg->meta_dreg.key, cs->fw6.ipv6.iniface,
+	if (parse_meta(ctx, e, reg->meta_dreg.key, cs->fw6.ipv6.iniface,
 		   cs->fw6.ipv6.iniface_mask, cs->fw6.ipv6.outiface,
-		   cs->fw6.ipv6.outiface_mask, &cs->fw6.ipv6.invflags);
+		   cs->fw6.ipv6.outiface_mask, &cs->fw6.ipv6.invflags) == 0)
+		return;
+
+	ctx->errmsg = "unknown ipv6 meta key";
 }
 
 static void parse_mask_ipv6(const struct nft_xt_ctx_reg *reg,
-- 
2.37.4

