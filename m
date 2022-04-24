Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B425C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Apr 2022 21:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239690AbiDXV70 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Apr 2022 17:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236417AbiDXV7Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Apr 2022 17:59:25 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A58DE393E6
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Apr 2022 14:56:22 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables 2/7] nft: pass struct nft_xt_ctx to parse_meta()
Date:   Sun, 24 Apr 2022 23:56:08 +0200
Message-Id: <20220424215613.106165-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220424215613.106165-1-pablo@netfilter.org>
References: <20220424215613.106165-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In preparation for native mark match support.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-arp.c    | 2 +-
 iptables/nft-bridge.c | 2 +-
 iptables/nft-ipv4.c   | 2 +-
 iptables/nft-ipv6.c   | 2 +-
 iptables/nft-shared.c | 6 +++---
 iptables/nft-shared.h | 6 +++---
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 028b06a608e4..89e6413441e2 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -174,7 +174,7 @@ static void nft_arp_parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
 	struct arpt_entry *fw = &cs->arp;
 	uint8_t flags = 0;
 
-	parse_meta(e, ctx->meta.key, fw->arp.iniface, fw->arp.iniface_mask,
+	parse_meta(ctx, e, ctx->meta.key, fw->arp.iniface, fw->arp.iniface_mask,
 		   fw->arp.outiface, fw->arp.outiface_mask,
 		   &flags);
 
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index d4b66a25c740..097ef6e16827 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -171,7 +171,7 @@ static void nft_bridge_parse_meta(struct nft_xt_ctx *ctx,
 	uint8_t invflags = 0;
 	char iifname[IFNAMSIZ] = {}, oifname[IFNAMSIZ] = {};
 
-	parse_meta(e, ctx->meta.key, iifname, NULL, oifname, NULL, &invflags);
+	parse_meta(ctx, e, ctx->meta.key, iifname, NULL, oifname, NULL, &invflags);
 
 	switch (ctx->meta.key) {
 	case NFT_META_BRI_IIFNAME:
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index af3d0c98b798..cf03edfae9ac 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -144,7 +144,7 @@ static void nft_ipv4_parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
 		break;
 	}
 
-	parse_meta(e, ctx->meta.key, cs->fw.ip.iniface, cs->fw.ip.iniface_mask,
+	parse_meta(ctx, e, ctx->meta.key, cs->fw.ip.iniface, cs->fw.ip.iniface_mask,
 		   cs->fw.ip.outiface, cs->fw.ip.outiface_mask,
 		   &cs->fw.ip.invflags);
 }
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 892a48541593..5b767a4059e6 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -117,7 +117,7 @@ static void nft_ipv6_parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
 		break;
 	}
 
-	parse_meta(e, ctx->meta.key, cs->fw6.ipv6.iniface,
+	parse_meta(ctx, e, ctx->meta.key, cs->fw6.ipv6.iniface,
 		   cs->fw6.ipv6.iniface_mask, cs->fw6.ipv6.outiface,
 		   cs->fw6.ipv6.outiface_mask, &cs->fw6.ipv6.invflags);
 }
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index b3993211c79d..5b13b29c9844 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -261,9 +261,9 @@ static void parse_ifname(const char *name, unsigned int len, char *dst, unsigned
 		memset(mask, 0xff, len - 2);
 }
 
-int parse_meta(struct nftnl_expr *e, uint8_t key, char *iniface,
-		unsigned char *iniface_mask, char *outiface,
-		unsigned char *outiface_mask, uint8_t *invflags)
+int parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e, uint8_t key,
+	       char *iniface, unsigned char *iniface_mask,
+	       char *outiface, unsigned char *outiface_mask, uint8_t *invflags)
 {
 	uint32_t value;
 	const void *ifname;
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 7b337943836a..092958cd67fa 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -156,9 +156,9 @@ bool is_same_interfaces(const char *a_iniface, const char *a_outiface,
 			unsigned const char *b_iniface_mask,
 			unsigned const char *b_outiface_mask);
 
-int parse_meta(struct nftnl_expr *e, uint8_t key, char *iniface,
-		unsigned char *iniface_mask, char *outiface,
-		unsigned char *outiface_mask, uint8_t *invflags);
+int parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e, uint8_t key,
+	       char *iniface, unsigned char *iniface_mask, char *outiface,
+	       unsigned char *outiface_mask, uint8_t *invflags);
 void get_cmp_data(struct nftnl_expr *e, void *data, size_t dlen, bool *inv);
 void nft_rule_to_iptables_command_state(struct nft_handle *h,
 					const struct nftnl_rule *r,
-- 
2.30.2

