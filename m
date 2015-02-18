From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v2] iptables-compat: unset context flags in netlink delinearize step
Date: Thu, 19 Feb 2015 00:32:21 +0100
Message-ID: <1424302341-21509-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60727 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbbBRX3E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2015 18:29:04 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Once the data that the compare expression provides have been digested.

For example:

-A INPUT -i noexist -p udplite -s 10.10.10.10/32 -d 10.0.0.10/32 -j ACCEPT

doesn't show anymore the following broken output via iptables-compat-save:

-A INPUT -i

+t -p udplite -s 10.10.10.10/32 -d 10.0.0.10/32 -j ACCEPT

Reported-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-arp.c    |   12 ++++++++----
 iptables/nft-ipv4.c   |   14 ++++++++++----
 iptables/nft-ipv6.c   |   20 ++++++++++++--------
 iptables/nft-shared.c |    8 ++++++--
 4 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 0567201..523b3ec 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -337,10 +337,12 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 					   fw->arp.arhln) {
 			get_cmp_data(e, &addr, sizeof(addr), &inv);
 			fw->arp.src.s_addr = addr.s_addr;
-			if (ctx->flags & NFT_XT_CTX_BITWISE)
+			if (ctx->flags & NFT_XT_CTX_BITWISE) {
 				parse_mask_ipv4(ctx, &fw->arp.smsk);
-			else
+				ctx->flags &= ~NFT_XT_CTX_BITWISE;
+			} else {
 				fw->arp.smsk.s_addr = 0xffffffff;
+			}
 
 			if (inv)
 				fw->arp.invflags |= ARPT_INV_SRCIP;
@@ -349,10 +351,12 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 						  sizeof(struct in_addr)) {
 			get_cmp_data(e, &addr, sizeof(addr), &inv);
 			fw->arp.tgt.s_addr = addr.s_addr;
-			if (ctx->flags & NFT_XT_CTX_BITWISE)
+			if (ctx->flags & NFT_XT_CTX_BITWISE) {
 				parse_mask_ipv4(ctx, &fw->arp.tmsk);
-			else
+				ctx->flags &= ~NFT_XT_CTX_BITWISE;
+			} else {
 				fw->arp.tmsk.s_addr = 0xffffffff;
+			}
 
 			if (inv)
 				fw->arp.invflags |= ARPT_INV_TGTIP;
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index ed30920..140093c 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -123,6 +123,8 @@ static void get_frag(struct nft_xt_ctx *ctx, struct nft_rule_expr *e, bool *inv)
 		*inv = true;
 	else
 		*inv = false;
+
+	ctx->flags &= ~NFT_XT_CTX_BITWISE;
 }
 
 static const char *mask_to_str(uint32_t mask)
@@ -178,10 +180,12 @@ static void nft_ipv4_parse_payload(struct nft_xt_ctx *ctx,
 	case offsetof(struct iphdr, saddr):
 		get_cmp_data(e, &addr, sizeof(addr), &inv);
 		cs->fw.ip.src.s_addr = addr.s_addr;
-		if (ctx->flags & NFT_XT_CTX_BITWISE)
+		if (ctx->flags & NFT_XT_CTX_BITWISE) {
 			parse_mask_ipv4(ctx, &cs->fw.ip.smsk);
-		else
+			ctx->flags &= ~NFT_XT_CTX_BITWISE;
+		} else {
 			cs->fw.ip.smsk.s_addr = 0xffffffff;
+		}
 
 		if (inv)
 			cs->fw.ip.invflags |= IPT_INV_SRCIP;
@@ -189,10 +193,12 @@ static void nft_ipv4_parse_payload(struct nft_xt_ctx *ctx,
 	case offsetof(struct iphdr, daddr):
 		get_cmp_data(e, &addr, sizeof(addr), &inv);
 		cs->fw.ip.dst.s_addr = addr.s_addr;
-		if (ctx->flags & NFT_XT_CTX_BITWISE)
+		if (ctx->flags & NFT_XT_CTX_BITWISE) {
 			parse_mask_ipv4(ctx, &cs->fw.ip.dmsk);
-		else
+			ctx->flags &= ~NFT_XT_CTX_BITWISE;
+		} else {
 			cs->fw.ip.dmsk.s_addr = 0xffffffff;
+		}
 
 		if (inv)
 			cs->fw.ip.invflags |= IPT_INV_DSTIP;
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 37365da..d50b138 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -126,10 +126,12 @@ static void nft_ipv6_parse_payload(struct nft_xt_ctx *ctx,
 	case offsetof(struct ip6_hdr, ip6_src):
 		get_cmp_data(e, &addr, sizeof(addr), &inv);
 		memcpy(cs->fw6.ipv6.src.s6_addr, &addr, sizeof(addr));
-                if (ctx->flags & NFT_XT_CTX_BITWISE)
-                        parse_mask_ipv6(ctx, &cs->fw6.ipv6.smsk);
-                else
-                        memset(&cs->fw.ip.smsk, 0xff, sizeof(struct in6_addr));
+		if (ctx->flags & NFT_XT_CTX_BITWISE) {
+			parse_mask_ipv6(ctx, &cs->fw6.ipv6.smsk);
+			ctx->flags &= ~NFT_XT_CTX_BITWISE;
+		} else {
+			memset(&cs->fw.ip.smsk, 0xff, sizeof(struct in6_addr));
+		}
 
 		if (inv)
 			cs->fw6.ipv6.invflags |= IPT_INV_SRCIP;
@@ -137,10 +139,12 @@ static void nft_ipv6_parse_payload(struct nft_xt_ctx *ctx,
 	case offsetof(struct ip6_hdr, ip6_dst):
 		get_cmp_data(e, &addr, sizeof(addr), &inv);
 		memcpy(cs->fw6.ipv6.dst.s6_addr, &addr, sizeof(addr));
-                if (ctx->flags & NFT_XT_CTX_BITWISE)
-                        parse_mask_ipv6(ctx, &cs->fw6.ipv6.dmsk);
-                else
-                        memset(&cs->fw.ip.dmsk, 0xff, sizeof(struct in6_addr));
+		if (ctx->flags & NFT_XT_CTX_BITWISE) {
+			parse_mask_ipv6(ctx, &cs->fw6.ipv6.dmsk);
+			ctx->flags &= ~NFT_XT_CTX_BITWISE;
+		} else {
+			memset(&cs->fw.ip.dmsk, 0xff, sizeof(struct in6_addr));
+		}
 
 		if (inv)
 			cs->fw6.ipv6.invflags |= IPT_INV_DSTIP;
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 620da3e..1182f56 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -434,11 +434,15 @@ void nft_parse_cmp(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
 	if (ctx->reg && reg != ctx->reg)
 		return;
 
-	if (ctx->flags & NFT_XT_CTX_META)
+	if (ctx->flags & NFT_XT_CTX_META) {
 		ops->parse_meta(ctx, e, data);
+		ctx->flags &= ~NFT_XT_CTX_META;
+	}
 	/* bitwise context is interpreted from payload */
-	if (ctx->flags & NFT_XT_CTX_PAYLOAD)
+	if (ctx->flags & NFT_XT_CTX_PAYLOAD) {
 		ops->parse_payload(ctx, e, data);
+		ctx->flags &= ~NFT_XT_CTX_PAYLOAD;
+	}
 }
 
 void nft_parse_counter(struct nft_rule_expr *e, struct xt_counters *counters)
-- 
1.7.10.4

