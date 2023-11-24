Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZQu/ntA6"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1CF10EC
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2023 03:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Ckk5t0DTa+hOAnLfeGjngaroBVbF0+yMCzxhlA2vqHk=; b=ZQu/ntA6qj3RibJRyUhvHDtMrL
	y6NpSkOZIJyxaacj/cwJsw1STy59Tn7RsoHZFsoNyMNTZl7aAeeMeCxTB8VRO6ND4pm9hkBTxXRwT
	qhUzgDhp+lGwm1ARuDmNoJ03sI8X7Milyve12+QGN6//4frV8EDsjgE1V9u04zW0zzd5HEq+fU4jP
	2YBYlu5LfFRDXEn4eOoPExTJYWXIhNvi10i3mDF5ee3eev5yxFKskFFQs24zvCtvDneN/YzH1mkcj
	NAhF92lyZiJ8j394BoWpbDgvx7PdNM5tt6V4ijHgj6oxYFwyuOhixYK9iIO1WBJHSfIW42sP11P+J
	trlkRSiA==;
Received: from localhost ([::1] helo=minime)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r6UDU-0002UR-1R
	for netfilter-devel@vger.kernel.org; Fri, 24 Nov 2023 12:19:24 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/3] nft: Leave interface masks alone when parsing from kernel
Date: Fri, 24 Nov 2023 12:28:34 +0100
Message-ID: <20231124112834.5363-4-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231124112834.5363-1-phil@nwl.cc>
References: <20231124112834.5363-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The mask is entirely unused by nft-variants in general and legacy ones
when printing. It is relevant only when inserting a legacy rule into
kernel as it doesn't detect the '+'-suffix.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-ruleparse-arp.c    |  5 ++---
 iptables/nft-ruleparse-bridge.c |  3 ++-
 iptables/nft-ruleparse-ipv4.c   |  5 ++---
 iptables/nft-ruleparse-ipv6.c   |  3 +--
 iptables/nft-ruleparse.c        | 33 ++++++++-------------------------
 iptables/nft-ruleparse.h        |  3 +--
 6 files changed, 16 insertions(+), 36 deletions(-)

diff --git a/iptables/nft-ruleparse-arp.c b/iptables/nft-ruleparse-arp.c
index cd74747e91895..b0671cb0dfe8f 100644
--- a/iptables/nft-ruleparse-arp.c
+++ b/iptables/nft-ruleparse-arp.c
@@ -34,9 +34,8 @@ static void nft_arp_parse_meta(struct nft_xt_ctx *ctx,
 	struct arpt_entry *fw = &cs->arp;
 	uint8_t flags = 0;
 
-	if (parse_meta(ctx, e, reg->meta_dreg.key, fw->arp.iniface, fw->arp.iniface_mask,
-		   fw->arp.outiface, fw->arp.outiface_mask,
-		   &flags) == 0) {
+	if (parse_meta(ctx, e, reg->meta_dreg.key, fw->arp.iniface,
+		       fw->arp.outiface, &flags) == 0) {
 		fw->arp.invflags |= flags;
 		return;
 	}
diff --git a/iptables/nft-ruleparse-bridge.c b/iptables/nft-ruleparse-bridge.c
index c6cc9af5ea198..aee08b1396c1a 100644
--- a/iptables/nft-ruleparse-bridge.c
+++ b/iptables/nft-ruleparse-bridge.c
@@ -43,7 +43,8 @@ static void nft_bridge_parse_meta(struct nft_xt_ctx *ctx,
 		return;
 	}
 
-	if (parse_meta(ctx, e, reg->meta_dreg.key, iifname, NULL, oifname, NULL, &invflags) < 0) {
+	if (parse_meta(ctx, e, reg->meta_dreg.key,
+		       iifname, oifname, &invflags) < 0) {
 		ctx->errmsg = "unknown meta key";
 		return;
 	}
diff --git a/iptables/nft-ruleparse-ipv4.c b/iptables/nft-ruleparse-ipv4.c
index 491cbf42c7754..fe65b33cf847b 100644
--- a/iptables/nft-ruleparse-ipv4.c
+++ b/iptables/nft-ruleparse-ipv4.c
@@ -41,9 +41,8 @@ static void nft_ipv4_parse_meta(struct nft_xt_ctx *ctx,
 		break;
 	}
 
-	if (parse_meta(ctx, e, reg->meta_dreg.key, cs->fw.ip.iniface, cs->fw.ip.iniface_mask,
-		   cs->fw.ip.outiface, cs->fw.ip.outiface_mask,
-		   &cs->fw.ip.invflags) == 0)
+	if (parse_meta(ctx, e, reg->meta_dreg.key, cs->fw.ip.iniface,
+		       cs->fw.ip.outiface, &cs->fw.ip.invflags) == 0)
 		return;
 
 	ctx->errmsg = "unknown ipv4 meta key";
diff --git a/iptables/nft-ruleparse-ipv6.c b/iptables/nft-ruleparse-ipv6.c
index 7581b8636e601..29b085802f76c 100644
--- a/iptables/nft-ruleparse-ipv6.c
+++ b/iptables/nft-ruleparse-ipv6.c
@@ -42,8 +42,7 @@ static void nft_ipv6_parse_meta(struct nft_xt_ctx *ctx,
 	}
 
 	if (parse_meta(ctx, e, reg->meta_dreg.key, cs->fw6.ipv6.iniface,
-		   cs->fw6.ipv6.iniface_mask, cs->fw6.ipv6.outiface,
-		   cs->fw6.ipv6.outiface_mask, &cs->fw6.ipv6.invflags) == 0)
+		       cs->fw6.ipv6.outiface, &cs->fw6.ipv6.invflags) == 0)
 		return;
 
 	ctx->errmsg = "unknown ipv6 meta key";
diff --git a/iptables/nft-ruleparse.c b/iptables/nft-ruleparse.c
index c8322f936acd9..0bbdf44fafe03 100644
--- a/iptables/nft-ruleparse.c
+++ b/iptables/nft-ruleparse.c
@@ -983,18 +983,14 @@ bool nft_rule_to_iptables_command_state(struct nft_handle *h,
 	return ret;
 }
 
-static void parse_ifname(const char *name, unsigned int len,
-			 char *dst, unsigned char *mask)
+static void parse_ifname(const char *name, unsigned int len, char *dst)
 {
 	if (len == 0)
 		return;
 
 	memcpy(dst, name, len);
-	if (name[len - 1] == '\0') {
-		if (mask)
-			memset(mask, 0xff, strlen(name) + 1);
+	if (name[len - 1] == '\0')
 		return;
-	}
 
 	if (len >= IFNAMSIZ)
 		return;
@@ -1004,12 +1000,9 @@ static void parse_ifname(const char *name, unsigned int len,
 	if (len >= IFNAMSIZ)
 		return;
 	dst[len++] = 0;
-	if (mask)
-		memset(mask, 0xff, len - 2);
 }
 
-static void parse_invalid_iface(char *iface, unsigned char *mask,
-				uint8_t *invflags, uint8_t invbit)
+static void parse_invalid_iface(char *iface, uint8_t *invflags, uint8_t invbit)
 {
 	if (*invflags & invbit || strcmp(iface, "INVAL/D"))
 		return;
@@ -1018,9 +1011,6 @@ static void parse_invalid_iface(char *iface, unsigned char *mask,
 	*invflags |= invbit;
 	iface[0] = '+';
 	iface[1] = '\0';
-	mask[0] = 0xff;
-	mask[1] = 0xff;
-	memset(mask + 2, 0, IFNAMSIZ - 2);
 }
 
 static uint32_t get_meta_mask(struct nft_xt_ctx *ctx, enum nft_registers sreg)
@@ -1071,8 +1061,7 @@ static int parse_meta_pkttype(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 }
 
 int parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e, uint8_t key,
-	       char *iniface, unsigned char *iniface_mask,
-	       char *outiface, unsigned char *outiface_mask, uint8_t *invflags)
+	       char *iniface, char *outiface, uint8_t *invflags)
 {
 	uint32_t value;
 	const void *ifname;
@@ -1085,8 +1074,6 @@ int parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e, uint8_t key,
 			*invflags |= IPT_INV_VIA_IN;
 
 		if_indextoname(value, iniface);
-
-		memset(iniface_mask, 0xff, strlen(iniface)+1);
 		break;
 	case NFT_META_OIF:
 		value = nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_DATA);
@@ -1094,8 +1081,6 @@ int parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e, uint8_t key,
 			*invflags |= IPT_INV_VIA_OUT;
 
 		if_indextoname(value, outiface);
-
-		memset(outiface_mask, 0xff, strlen(outiface)+1);
 		break;
 	case NFT_META_BRI_IIFNAME:
 	case NFT_META_IIFNAME:
@@ -1103,9 +1088,8 @@ int parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e, uint8_t key,
 		if (nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_OP) == NFT_CMP_NEQ)
 			*invflags |= IPT_INV_VIA_IN;
 
-		parse_ifname(ifname, len, iniface, iniface_mask);
-		parse_invalid_iface(iniface, iniface_mask,
-				    invflags, IPT_INV_VIA_IN);
+		parse_ifname(ifname, len, iniface);
+		parse_invalid_iface(iniface, invflags, IPT_INV_VIA_IN);
 		break;
 	case NFT_META_BRI_OIFNAME:
 	case NFT_META_OIFNAME:
@@ -1113,9 +1097,8 @@ int parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e, uint8_t key,
 		if (nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_OP) == NFT_CMP_NEQ)
 			*invflags |= IPT_INV_VIA_OUT;
 
-		parse_ifname(ifname, len, outiface, outiface_mask);
-		parse_invalid_iface(outiface, outiface_mask,
-				    invflags, IPT_INV_VIA_OUT);
+		parse_ifname(ifname, len, outiface);
+		parse_invalid_iface(outiface, invflags, IPT_INV_VIA_OUT);
 		break;
 	case NFT_META_MARK:
 		parse_meta_mark(ctx, e);
diff --git a/iptables/nft-ruleparse.h b/iptables/nft-ruleparse.h
index 25ce05d2e8644..62c9160d77711 100644
--- a/iptables/nft-ruleparse.h
+++ b/iptables/nft-ruleparse.h
@@ -128,8 +128,7 @@ bool nft_rule_to_iptables_command_state(struct nft_handle *h,
 #define max(x, y) ((x) > (y) ? (x) : (y))
 
 int parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e, uint8_t key,
-	       char *iniface, unsigned char *iniface_mask, char *outiface,
-	       unsigned char *outiface_mask, uint8_t *invflags);
+	       char *iniface, char *outiface, uint8_t *invflags);
 
 int nft_parse_hl(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
 		 struct iptables_command_state *cs);
-- 
2.41.0

