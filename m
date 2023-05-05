Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21F5EC7EE22
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 15:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbjEEPb4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 11:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbjEEPbz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 11:31:55 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8973B11DBB
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 08:31:36 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 02/12] netfilter: nf_tables: add nft_reg_store_*() and use it
Date:   Fri,  5 May 2023 17:31:20 +0200
Message-Id: <20230505153130.2385-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230505153130.2385-1-pablo@netfilter.org>
References: <20230505153130.2385-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a helper function to wrap data write to register and use it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h      |  91 ++++++++++---
 include/net/netfilter/nft_fib.h        |   2 +-
 net/bridge/netfilter/nft_meta_bridge.c |   7 +-
 net/ipv4/netfilter/nft_fib_ipv4.c      |  13 +-
 net/ipv6/netfilter/nft_fib_ipv6.c      |  11 +-
 net/netfilter/nf_tables_core.c         |  12 +-
 net/netfilter/nft_bitwise.c            |  30 +++--
 net/netfilter/nft_byteorder.c          |  21 ++-
 net/netfilter/nft_ct.c                 |  73 ++++++----
 net/netfilter/nft_ct_fast.c            |  12 +-
 net/netfilter/nft_exthdr.c             |  34 +++--
 net/netfilter/nft_fib.c                |  27 +++-
 net/netfilter/nft_hash.c               |   4 +-
 net/netfilter/nft_meta.c               | 178 ++++++++++++++-----------
 net/netfilter/nft_numgen.c             |   4 +-
 net/netfilter/nft_osf.c                |   7 +-
 net/netfilter/nft_payload.c            |  31 ++---
 net/netfilter/nft_rt.c                 |  18 +--
 net/netfilter/nft_socket.c             |  29 ++--
 net/netfilter/nft_tunnel.c             |  10 +-
 net/netfilter/nft_xfrm.c               |  19 +--
 21 files changed, 371 insertions(+), 262 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3ed21d2d5659..1bc9e6571231 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -141,46 +141,101 @@ struct nft_regs_track {
  * garbage values.
  */
 
-static inline void nft_reg_store8(u32 *dreg, u8 val)
+static inline u8 nft_reg_load8(const u32 *sreg)
 {
-	*dreg = 0;
-	*(u8 *)dreg = val;
+	return *(u8 *)sreg;
 }
 
-static inline u8 nft_reg_load8(const u32 *sreg)
+static inline u16 nft_reg_load16(const u32 *sreg)
 {
-	return *(u8 *)sreg;
+	return *(u16 *)sreg;
 }
 
-static inline void nft_reg_store16(u32 *dreg, u16 val)
+static inline __be16 nft_reg_load_be16(const u32 *sreg)
 {
-	*dreg = 0;
-	*(u16 *)dreg = val;
+	return (__force __be16)nft_reg_load16(sreg);
 }
 
-static inline void nft_reg_store_be16(u32 *dreg, __be16 val)
+static inline __be32 nft_reg_load_be32(const u32 *sreg)
 {
-	nft_reg_store16(dreg, (__force __u16)val);
+	return *(__force __be32 *)sreg;
 }
 
-static inline u16 nft_reg_load16(const u32 *sreg)
+static inline void nft_reg_store_u8(struct nft_regs *regs, u32 dreg, u8 value)
 {
-	return *(u16 *)sreg;
+	u32 *dest = &regs->data[dreg];
+
+	*dest = 0;
+	*(u8 *)dest = value;
 }
 
-static inline __be16 nft_reg_load_be16(const u32 *sreg)
+static inline void nft_reg_store_u16(struct nft_regs *regs, u32 dreg, u16 value)
 {
-	return (__force __be16)nft_reg_load16(sreg);
+	u32 *dest = &regs->data[dreg];
+
+	*dest = 0;
+	*(u16 *)dest = value;
 }
 
-static inline __be32 nft_reg_load_be32(const u32 *sreg)
+static inline void nft_reg_store_be16(struct nft_regs *regs, u32 dreg, __be16 val)
 {
-	return *(__force __be32 *)sreg;
+	nft_reg_store_u16(regs, dreg, (__force __u16)val);
+}
+
+static inline void nft_reg_store_u32(struct nft_regs *regs, u32 dreg, u32 value)
+{
+	u32 *dest = &regs->data[dreg];
+
+	*dest = value;
+}
+
+static inline void nft_reg_store_be32(struct nft_regs *regs, u32 dreg, __be32 val)
+{
+	nft_reg_store_u32(regs, dreg, (__force __u32)val);
+}
+
+static inline int nft_reg_store_skb(struct nft_regs *regs, u32 dreg, int offset,
+				    int len, const struct sk_buff *skb)
+{
+	u32 *dest = &regs->data[dreg];
+
+	if (len % NFT_REG32_SIZE)
+		dest[len / NFT_REG32_SIZE] = 0;
+
+	if (skb_copy_bits(skb, offset, dest, len) < 0)
+		return -1;
+
+	return 0;
 }
 
-static inline void nft_reg_store64(u32 *dreg, u64 val)
+static inline void nft_reg_store_u64(struct nft_regs *regs, u32 dreg, u64 val)
 {
-	put_unaligned(val, (u64 *)dreg);
+	u32 *dest = &regs->data[dreg];
+
+	put_unaligned(val, (u64 *)dest);
+}
+
+static inline void nft_reg_store_str(struct nft_regs *regs, u32 dreg, u8 len,
+                                     const char *str)
+{
+	char *dest = (char *) &regs->data[dreg];
+
+	strncpy(dest, str, len);
+}
+
+static inline void nft_reg_store(struct nft_regs *regs, u32 dreg, u8 len,
+				 const void *ptr)
+{
+	u32 *dest = &regs->data[dreg];
+
+	memcpy(dest, ptr, len);
+}
+
+static inline void nft_reg_reset(struct nft_regs *regs, u32 dreg, u8 len)
+{
+	u32 *dest = &regs->data[dreg];
+
+	memset(dest, 0, len);
 }
 
 static inline u64 nft_reg_load64(const u32 *sreg)
diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
index 167640b843ef..d365eb765327 100644
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -35,7 +35,7 @@ void nft_fib6_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
 void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		   const struct nft_pktinfo *pkt);
 
-void nft_fib_store_result(void *reg, const struct nft_fib *priv,
+void nft_fib_store_result(struct nft_regs *regs, const struct nft_fib *priv,
 			  const struct net_device *dev);
 
 bool nft_fib_reduce(struct nft_regs_track *track,
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index bd4d1b4d745f..c96a0f08bb3e 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -27,7 +27,6 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	const struct net_device *in = nft_in(pkt), *out = nft_out(pkt);
-	u32 *dest = &regs->data[priv->dreg];
 	const struct net_device *br_dev;
 
 	switch (priv->key) {
@@ -45,7 +44,7 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 			goto err;
 
 		br_vlan_get_pvid_rcu(in, &p_pvid);
-		nft_reg_store16(dest, p_pvid);
+		nft_reg_store_u16(regs, priv->dreg, p_pvid);
 		return;
 	}
 	case NFT_META_BRI_IIFVPROTO: {
@@ -56,14 +55,14 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 			goto err;
 
 		br_vlan_get_proto(br_dev, &p_proto);
-		nft_reg_store_be16(dest, htons(p_proto));
+		nft_reg_store_be16(regs, priv->dreg, htons(p_proto));
 		return;
 	}
 	default:
 		return nft_meta_get_eval(expr, regs, pkt);
 	}
 
-	strncpy((char *)dest, br_dev ? br_dev->name : "", IFNAMSIZ);
+	nft_reg_store_str(regs, priv->dreg, IFNAMSIZ, br_dev ? br_dev->name : "");
 	return;
 err:
 	regs->verdict.code = NFT_BREAK;
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 9eee535c64dd..cece7cc48104 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -29,7 +29,6 @@ void nft_fib4_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
 {
 	const struct nft_fib *priv = nft_expr_priv(expr);
 	int noff = skb_network_offset(pkt->skb);
-	u32 *dst = &regs->data[priv->dreg];
 	const struct net_device *dev = NULL;
 	struct iphdr *iph, _iph;
 	__be32 addr;
@@ -50,7 +49,8 @@ void nft_fib4_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
 	else
 		addr = iph->saddr;
 
-	*dst = inet_dev_addr_type(nft_net(pkt), dev, addr);
+	nft_reg_store_u32(regs, priv->dreg,
+			  inet_dev_addr_type(nft_net(pkt), dev, addr));
 }
 EXPORT_SYMBOL_GPL(nft_fib4_eval_type);
 
@@ -59,7 +59,6 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 {
 	const struct nft_fib *priv = nft_expr_priv(expr);
 	int noff = skb_network_offset(pkt->skb);
-	u32 *dest = &regs->data[priv->dreg];
 	struct iphdr *iph, _iph;
 	struct fib_result res;
 	struct flowi4 fl4 = {
@@ -89,7 +88,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 
 	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
 	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
-		nft_fib_store_result(dest, priv, nft_in(pkt));
+		nft_fib_store_result(regs, priv, nft_in(pkt));
 		return;
 	}
 
@@ -102,7 +101,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	if (ipv4_is_zeronet(iph->saddr)) {
 		if (ipv4_is_lbcast(iph->daddr) ||
 		    ipv4_is_local_multicast(iph->daddr)) {
-			nft_fib_store_result(dest, priv, pkt->skb->dev);
+			nft_fib_store_result(regs, priv, pkt->skb->dev);
 			return;
 		}
 	}
@@ -124,7 +123,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		fl4.saddr = get_saddr(iph->daddr);
 	}
 
-	*dest = 0;
+	nft_reg_store_u32(regs, priv->dreg, 0);
 
 	if (fib_lookup(nft_net(pkt), &fl4, &res, FIB_LOOKUP_IGNORE_LINKSTATE))
 		return;
@@ -146,7 +145,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		found = oif;
 	}
 
-	nft_fib_store_result(dest, priv, found);
+	nft_fib_store_result(regs, priv, found);
 }
 EXPORT_SYMBOL_GPL(nft_fib4_eval);
 
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 36dc14b34388..e12251175434 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -129,7 +129,6 @@ void nft_fib6_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
 {
 	const struct nft_fib *priv = nft_expr_priv(expr);
 	int noff = skb_network_offset(pkt->skb);
-	u32 *dest = &regs->data[priv->dreg];
 	struct ipv6hdr *iph, _iph;
 
 	iph = skb_header_pointer(pkt->skb, noff, sizeof(_iph), &_iph);
@@ -138,7 +137,8 @@ void nft_fib6_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
 		return;
 	}
 
-	*dest = __nft_fib6_eval_type(priv, pkt, iph);
+	nft_reg_store_u32(regs, priv->dreg,
+			  __nft_fib6_eval_type(priv, pkt, iph));
 }
 EXPORT_SYMBOL_GPL(nft_fib6_eval_type);
 
@@ -159,7 +159,6 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	const struct nft_fib *priv = nft_expr_priv(expr);
 	int noff = skb_network_offset(pkt->skb);
 	const struct net_device *oif = NULL;
-	u32 *dest = &regs->data[priv->dreg];
 	struct ipv6hdr *iph, _iph;
 	struct flowi6 fl6 = {
 		.flowi6_iif = LOOPBACK_IFINDEX,
@@ -186,12 +185,12 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	    nft_hook(pkt) == NF_INET_INGRESS) {
 		if (nft_fib_is_loopback(pkt->skb, nft_in(pkt)) ||
 		    nft_fib_v6_skip_icmpv6(pkt->skb, pkt->tprot, iph)) {
-			nft_fib_store_result(dest, priv, nft_in(pkt));
+			nft_fib_store_result(regs, priv, nft_in(pkt));
 			return;
 		}
 	}
 
-	*dest = 0;
+	nft_reg_store_u32(regs, priv->dreg, 0);
 	rt = (void *)ip6_route_lookup(nft_net(pkt), &fl6, pkt->skb,
 				      lookup_flags);
 	if (rt->dst.error)
@@ -205,7 +204,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) != oif->ifindex)
 		goto put_rt_err;
 
-	nft_fib_store_result(dest, priv, rt->rt6i_idev->dev);
+	nft_fib_store_result(regs, priv, rt->rt6i_idev->dev);
  put_rt_err:
 	ip6_rt_put(rt);
 }
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 4d0ce12221f6..1ee950368b6c 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -79,9 +79,8 @@ static void nft_bitwise_fast_eval(const struct nft_expr *expr,
 {
 	const struct nft_bitwise_fast_expr *priv = nft_expr_priv(expr);
 	u32 *src = &regs->data[priv->sreg];
-	u32 *dst = &regs->data[priv->dreg];
 
-	*dst = (*src & priv->mask) ^ priv->xor;
+	nft_reg_store_u32(regs, priv->dreg, (*src & priv->mask) ^ priv->xor);
 }
 
 static void nft_cmp_fast_eval(const struct nft_expr *expr,
@@ -150,7 +149,6 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 {
 	const struct nft_payload *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
-	u32 *dest = &regs->data[priv->dreg];
 	unsigned char *ptr;
 
 	if (priv->base == NFT_PAYLOAD_NETWORK_HEADER)
@@ -166,13 +164,13 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 	if (unlikely(ptr + priv->len > skb_tail_pointer(skb)))
 		return false;
 
-	*dest = 0;
 	if (priv->len == 2)
-		*(u16 *)dest = *(u16 *)ptr;
+		nft_reg_store_u16(regs, priv->dreg, *(u16 *)ptr);
 	else if (priv->len == 4)
-		*(u32 *)dest = *(u32 *)ptr;
+		nft_reg_store_u32(regs, priv->dreg, *(u32 *)ptr);
 	else
-		*(u8 *)dest = *(u8 *)ptr;
+		nft_reg_store_u8(regs, priv->dreg, *(u8 *)ptr);
+
 	return true;
 }
 
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 84eae7cabc67..d3c066aa399a 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -25,37 +25,42 @@ struct nft_bitwise {
 	struct nft_data		data;
 };
 
-static void nft_bitwise_eval_bool(u32 *dst, const u32 *src,
+static void nft_bitwise_eval_bool(struct nft_regs *regs, const u32 *src,
 				  const struct nft_bitwise *priv)
 {
 	unsigned int i;
+	u32 data;
 
-	for (i = 0; i < DIV_ROUND_UP(priv->len, sizeof(u32)); i++)
-		dst[i] = (src[i] & priv->mask.data[i]) ^ priv->xor.data[i];
+	for (i = 0; i < DIV_ROUND_UP(priv->len, sizeof(u32)); i++) {
+		data = (src[i] & priv->mask.data[i]) ^ priv->xor.data[i];
+		nft_reg_store_u32(regs, priv->dreg + i, data);
+	}
 }
 
-static void nft_bitwise_eval_lshift(u32 *dst, const u32 *src,
+static void nft_bitwise_eval_lshift(struct nft_regs *regs, const u32 *src,
 				    const struct nft_bitwise *priv)
 {
 	u32 shift = priv->data.data[0];
+	u32 data, carry = 0;
 	unsigned int i;
-	u32 carry = 0;
 
 	for (i = DIV_ROUND_UP(priv->len, sizeof(u32)); i > 0; i--) {
-		dst[i - 1] = (src[i - 1] << shift) | carry;
+		data = (src[i - 1] << shift) | carry;
+		nft_reg_store_u32(regs, priv->dreg + i - 1, data);
 		carry = src[i - 1] >> (BITS_PER_TYPE(u32) - shift);
 	}
 }
 
-static void nft_bitwise_eval_rshift(u32 *dst, const u32 *src,
+static void nft_bitwise_eval_rshift(struct nft_regs *regs, const u32 *src,
 				    const struct nft_bitwise *priv)
 {
 	u32 shift = priv->data.data[0];
+	u32 data, carry = 0;
 	unsigned int i;
-	u32 carry = 0;
 
 	for (i = 0; i < DIV_ROUND_UP(priv->len, sizeof(u32)); i++) {
-		dst[i] = carry | (src[i] >> shift);
+		data = carry | (src[i] >> shift);
+		nft_reg_store_u32(regs, priv->dreg + i, data);
 		carry = src[i] << (BITS_PER_TYPE(u32) - shift);
 	}
 }
@@ -65,17 +70,16 @@ void nft_bitwise_eval(const struct nft_expr *expr,
 {
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
 	const u32 *src = &regs->data[priv->sreg];
-	u32 *dst = &regs->data[priv->dreg];
 
 	switch (priv->op) {
 	case NFT_BITWISE_BOOL:
-		nft_bitwise_eval_bool(dst, src, priv);
+		nft_bitwise_eval_bool(regs, src, priv);
 		break;
 	case NFT_BITWISE_LSHIFT:
-		nft_bitwise_eval_lshift(dst, src, priv);
+		nft_bitwise_eval_lshift(regs, src, priv);
 		break;
 	case NFT_BITWISE_RSHIFT:
-		nft_bitwise_eval_rshift(dst, src, priv);
+		nft_bitwise_eval_rshift(regs, src, priv);
 		break;
 	}
 }
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index b66647a5a171..7c9c32706d10 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -29,12 +29,10 @@ void nft_byteorder_eval(const struct nft_expr *expr,
 {
 	const struct nft_byteorder *priv = nft_expr_priv(expr);
 	u32 *src = &regs->data[priv->sreg];
-	u32 *dst = &regs->data[priv->dreg];
-	union { u32 u32; u16 u16; } *s, *d;
+	union { u32 u32; u16 u16; } *s;
 	unsigned int i;
 
 	s = (void *)src;
-	d = (void *)dst;
 
 	switch (priv->size) {
 	case 8: {
@@ -44,15 +42,15 @@ void nft_byteorder_eval(const struct nft_expr *expr,
 		case NFT_BYTEORDER_NTOH:
 			for (i = 0; i < priv->len / 8; i++) {
 				src64 = nft_reg_load64(&src[i]);
-				nft_reg_store64(&dst[i],
-						be64_to_cpu((__force __be64)src64));
+				nft_reg_store_u64(regs, priv->dreg,
+						  be64_to_cpu((__force __be64)src64));
 			}
 			break;
 		case NFT_BYTEORDER_HTON:
 			for (i = 0; i < priv->len / 8; i++) {
 				src64 = (__force __u64)
 					cpu_to_be64(nft_reg_load64(&src[i]));
-				nft_reg_store64(&dst[i], src64);
+				nft_reg_store_u64(regs, priv->dreg, src64);
 			}
 			break;
 		}
@@ -62,26 +60,27 @@ void nft_byteorder_eval(const struct nft_expr *expr,
 		switch (priv->op) {
 		case NFT_BYTEORDER_NTOH:
 			for (i = 0; i < priv->len / 4; i++)
-				d[i].u32 = ntohl((__force __be32)s[i].u32);
+				nft_reg_store_u32(regs, priv->dreg + i, ntohl(s[i].u32));
 			break;
 		case NFT_BYTEORDER_HTON:
 			for (i = 0; i < priv->len / 4; i++)
-				d[i].u32 = (__force __u32)htonl(s[i].u32);
+				nft_reg_store_be32(regs, priv->dreg + i, htonl(s[i].u32));
 			break;
 		}
 		break;
-	case 2:
+	case 2: {
 		switch (priv->op) {
 		case NFT_BYTEORDER_NTOH:
 			for (i = 0; i < priv->len / 2; i++)
-				d[i].u16 = ntohs((__force __be16)s[i].u16);
+				nft_reg_store_u16(regs, priv->dreg + i, ntohs(s[i].u16));
 			break;
 		case NFT_BYTEORDER_HTON:
 			for (i = 0; i < priv->len / 2; i++)
-				d[i].u16 = (__force __u16)htons(s[i].u16);
+				nft_reg_store_be16(regs, priv->dreg + i, htons(s[i].u16));
 			break;
 		}
 		break;
+		}
 	}
 }
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index b9c84499438b..8477f1b636bc 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -52,7 +52,6 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 			    const struct nft_pktinfo *pkt)
 {
 	const struct nft_ct *priv = nft_expr_priv(expr);
-	u32 *dest = &regs->data[priv->dreg];
 	enum ip_conntrack_info ctinfo;
 	const struct nf_conn *ct;
 	const struct nf_conn_help *help;
@@ -70,7 +69,8 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 			state = NF_CT_STATE_UNTRACKED_BIT;
 		else
 			state = NF_CT_STATE_INVALID_BIT;
-		*dest = state;
+
+		nft_reg_store_u32(regs, priv->dreg, state);
 		return;
 	default:
 		break;
@@ -81,23 +81,24 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 
 	switch (priv->key) {
 	case NFT_CT_DIRECTION:
-		nft_reg_store8(dest, CTINFO2DIR(ctinfo));
+		nft_reg_store_u8(regs, priv->dreg, CTINFO2DIR(ctinfo));
 		return;
 	case NFT_CT_STATUS:
-		*dest = ct->status;
+		nft_reg_store_u32(regs, priv->dreg, ct->status);
 		return;
 #ifdef CONFIG_NF_CONNTRACK_MARK
 	case NFT_CT_MARK:
-		*dest = READ_ONCE(ct->mark);
+		nft_reg_store_u32(regs, priv->dreg, READ_ONCE(ct->mark));
 		return;
 #endif
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 	case NFT_CT_SECMARK:
-		*dest = ct->secmark;
+		nft_reg_store_u32(regs, priv->dreg, ct->secmark);
 		return;
 #endif
 	case NFT_CT_EXPIRATION:
-		*dest = jiffies_to_msecs(nf_ct_expires(ct));
+		nft_reg_store_u32(regs, priv->dreg,
+				  jiffies_to_msecs(nf_ct_expires(ct)));
 		return;
 	case NFT_CT_HELPER:
 		if (ct->master == NULL)
@@ -108,16 +109,20 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		helper = rcu_dereference(help->helper);
 		if (helper == NULL)
 			goto err;
-		strncpy((char *)dest, helper->name, NF_CT_HELPER_NAME_LEN);
+
+		nft_reg_store_str(regs, priv->dreg, NF_CT_HELPER_NAME_LEN,
+				  helper->name);
 		return;
 #ifdef CONFIG_NF_CONNTRACK_LABELS
 	case NFT_CT_LABELS: {
 		struct nf_conn_labels *labels = nf_ct_labels_find(ct);
 
-		if (labels)
-			memcpy(dest, labels->bits, NF_CT_LABELS_MAX_SIZE);
-		else
-			memset(dest, 0, NF_CT_LABELS_MAX_SIZE);
+		if (labels) {
+			nft_reg_store(regs, priv->dreg, NF_CT_LABELS_MAX_SIZE,
+				      labels->bits);
+		} else {
+			nft_reg_reset(regs, priv->dreg, NF_CT_LABELS_MAX_SIZE);
+		}
 		return;
 	}
 #endif
@@ -129,7 +134,7 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		if (acct)
 			count = nft_ct_get_eval_counter(acct->counter,
 							priv->key, priv->dir);
-		memcpy(dest, &count, sizeof(count));
+		nft_reg_store(regs, priv->dreg, sizeof(count), &count);
 		return;
 	}
 	case NFT_CT_AVGPKT: {
@@ -145,14 +150,14 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 				avgcnt = div64_u64(bcnt, pcnt);
 		}
 
-		memcpy(dest, &avgcnt, sizeof(avgcnt));
+		nft_reg_store(regs, priv->dreg, sizeof(avgcnt), &avgcnt);
 		return;
 	}
 	case NFT_CT_L3PROTOCOL:
-		nft_reg_store8(dest, nf_ct_l3num(ct));
+		nft_reg_store_u8(regs, priv->dreg, nf_ct_l3num(ct));
 		return;
 	case NFT_CT_PROTOCOL:
-		nft_reg_store8(dest, nf_ct_protonum(ct));
+		nft_reg_store_u8(regs, priv->dreg, nf_ct_protonum(ct));
 		return;
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	case NFT_CT_ZONE: {
@@ -164,12 +169,12 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		else
 			zoneid = zone->id;
 
-		nft_reg_store16(dest, zoneid);
+		nft_reg_store_u16(regs, priv->dreg, zoneid);
 		return;
 	}
 #endif
 	case NFT_CT_ID:
-		*dest = nf_ct_get_id(ct);
+		nft_reg_store_u32(regs, priv->dreg, nf_ct_get_id(ct));
 		return;
 	default:
 		break;
@@ -178,38 +183,50 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 	tuple = &ct->tuplehash[priv->dir].tuple;
 	switch (priv->key) {
 	case NFT_CT_SRC:
-		memcpy(dest, tuple->src.u3.all,
-		       nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16);
+		nft_reg_store(regs, priv->dreg,
+			      nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16,
+			      tuple->src.u3.all);
 		return;
 	case NFT_CT_DST:
-		memcpy(dest, tuple->dst.u3.all,
-		       nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16);
+		nft_reg_store(regs, priv->dreg,
+			      nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16,
+			      tuple->dst.u3.all);
 		return;
 	case NFT_CT_PROTO_SRC:
-		nft_reg_store16(dest, (__force u16)tuple->src.u.all);
+		nft_reg_store_u16(regs, priv->dreg,
+				  (__force u16)tuple->src.u.all);
 		return;
 	case NFT_CT_PROTO_DST:
-		nft_reg_store16(dest, (__force u16)tuple->dst.u.all);
+		nft_reg_store_u16(regs, priv->dreg,
+				  (__force u16)tuple->dst.u.all);
 		return;
 	case NFT_CT_SRC_IP:
 		if (nf_ct_l3num(ct) != NFPROTO_IPV4)
 			goto err;
-		*dest = (__force __u32)tuple->src.u3.ip;
+
+		nft_reg_store_u32(regs, priv->dreg,
+				  (__force __u32)tuple->src.u3.ip);
 		return;
 	case NFT_CT_DST_IP:
 		if (nf_ct_l3num(ct) != NFPROTO_IPV4)
 			goto err;
-		*dest = (__force __u32)tuple->dst.u3.ip;
+
+		nft_reg_store_u32(regs, priv->dreg,
+				  (__force __u32)tuple->dst.u3.ip);
 		return;
 	case NFT_CT_SRC_IP6:
 		if (nf_ct_l3num(ct) != NFPROTO_IPV6)
 			goto err;
-		memcpy(dest, tuple->src.u3.ip6, sizeof(struct in6_addr));
+
+		nft_reg_store(regs, priv->dreg, sizeof(struct in6_addr),
+			      tuple->src.u3.ip6);
 		return;
 	case NFT_CT_DST_IP6:
 		if (nf_ct_l3num(ct) != NFPROTO_IPV6)
 			goto err;
-		memcpy(dest, tuple->dst.u3.ip6, sizeof(struct in6_addr));
+
+		nft_reg_store(regs, priv->dreg, sizeof(struct in6_addr),
+			      tuple->dst.u3.ip6);
 		return;
 	default:
 		break;
diff --git a/net/netfilter/nft_ct_fast.c b/net/netfilter/nft_ct_fast.c
index 89983b0613fa..94cd3e61f26b 100644
--- a/net/netfilter/nft_ct_fast.c
+++ b/net/netfilter/nft_ct_fast.c
@@ -9,7 +9,6 @@ void nft_ct_get_fast_eval(const struct nft_expr *expr,
 			  const struct nft_pktinfo *pkt)
 {
 	const struct nft_ct *priv = nft_expr_priv(expr);
-	u32 *dest = &regs->data[priv->dreg];
 	enum ip_conntrack_info ctinfo;
 	const struct nf_conn *ct;
 	unsigned int state;
@@ -28,22 +27,23 @@ void nft_ct_get_fast_eval(const struct nft_expr *expr,
 			state = NF_CT_STATE_UNTRACKED_BIT;
 		else
 			state = NF_CT_STATE_INVALID_BIT;
-		*dest = state;
+
+		nft_reg_store_u32(regs, priv->dreg, state);
 		return;
 	case NFT_CT_DIRECTION:
-		nft_reg_store8(dest, CTINFO2DIR(ctinfo));
+		nft_reg_store_u8(regs, priv->dreg, CTINFO2DIR(ctinfo));
 		return;
 	case NFT_CT_STATUS:
-		*dest = ct->status;
+		nft_reg_store_u32(regs, priv->dreg, ct->status);
 		return;
 #ifdef CONFIG_NF_CONNTRACK_MARK
 	case NFT_CT_MARK:
-		*dest = ct->mark;
+		nft_reg_store_u32(regs, priv->dreg, ct->mark);
 		return;
 #endif
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 	case NFT_CT_SECMARK:
-		*dest = ct->secmark;
+		nft_reg_store_u32(regs, priv->dreg, ct->secmark);
 		return;
 #endif
 	default:
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index a54a7f772cec..4af9af63a604 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -39,7 +39,6 @@ static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
 				 const struct nft_pktinfo *pkt)
 {
 	struct nft_exthdr *priv = nft_expr_priv(expr);
-	u32 *dest = &regs->data[priv->dreg];
 	unsigned int offset = 0;
 	int err;
 
@@ -48,16 +47,16 @@ static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
 
 	err = ipv6_find_hdr(pkt->skb, &offset, priv->type, NULL, NULL);
 	if (priv->flags & NFT_EXTHDR_F_PRESENT) {
-		nft_reg_store8(dest, err >= 0);
+		nft_reg_store_u8(regs, priv->dreg, err >= 0);
 		return;
 	} else if (err < 0) {
 		goto err;
 	}
 	offset += priv->offset;
 
-	dest[priv->len / NFT_REG32_SIZE] = 0;
-	if (skb_copy_bits(pkt->skb, offset, dest, priv->len) < 0)
+	if (nft_reg_store_skb(regs, priv->dreg, offset, priv->len, pkt->skb) < 0)
 		goto err;
+
 	return;
 err:
 	regs->verdict.code = NFT_BREAK;
@@ -135,7 +134,6 @@ static void nft_exthdr_ipv4_eval(const struct nft_expr *expr,
 				 const struct nft_pktinfo *pkt)
 {
 	struct nft_exthdr *priv = nft_expr_priv(expr);
-	u32 *dest = &regs->data[priv->dreg];
 	struct sk_buff *skb = pkt->skb;
 	unsigned int offset;
 	int err;
@@ -145,16 +143,16 @@ static void nft_exthdr_ipv4_eval(const struct nft_expr *expr,
 
 	err = ipv4_find_option(nft_net(pkt), skb, &offset, priv->type);
 	if (priv->flags & NFT_EXTHDR_F_PRESENT) {
-		nft_reg_store8(dest, err >= 0);
+		nft_reg_store_u8(regs, priv->dreg, err >= 0);
 		return;
 	} else if (err < 0) {
 		goto err;
 	}
 	offset += priv->offset;
 
-	dest[priv->len / NFT_REG32_SIZE] = 0;
-	if (skb_copy_bits(pkt->skb, offset, dest, priv->len) < 0)
+	if (nft_reg_store_skb(regs, priv->dreg, offset, priv->len, pkt->skb) < 0)
 		goto err;
+
 	return;
 err:
 	regs->verdict.code = NFT_BREAK;
@@ -187,7 +185,6 @@ static void nft_exthdr_tcp_eval(const struct nft_expr *expr,
 	u8 buff[sizeof(struct tcphdr) + MAX_TCP_OPTION_SPACE];
 	struct nft_exthdr *priv = nft_expr_priv(expr);
 	unsigned int i, optl, tcphdr_len, offset;
-	u32 *dest = &regs->data[priv->dreg];
 	struct tcphdr *tcph;
 	u8 *opt;
 
@@ -207,10 +204,11 @@ static void nft_exthdr_tcp_eval(const struct nft_expr *expr,
 
 		offset = i + priv->offset;
 		if (priv->flags & NFT_EXTHDR_F_PRESENT) {
-			*dest = 1;
+			nft_reg_store_u32(regs, priv->dreg, 1);
 		} else {
-			dest[priv->len / NFT_REG32_SIZE] = 0;
-			memcpy(dest, opt + offset, priv->len);
+			if (nft_reg_store_skb(regs, priv->dreg, offset,
+					      priv->len, pkt->skb) < 0)
+				goto err;
 		}
 
 		return;
@@ -218,7 +216,7 @@ static void nft_exthdr_tcp_eval(const struct nft_expr *expr,
 
 err:
 	if (priv->flags & NFT_EXTHDR_F_PRESENT)
-		*dest = 0;
+		nft_reg_store_u32(regs, priv->dreg, 0);
 	else
 		regs->verdict.code = NFT_BREAK;
 }
@@ -370,7 +368,6 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
 {
 	unsigned int offset = nft_thoff(pkt) + sizeof(struct sctphdr);
 	struct nft_exthdr *priv = nft_expr_priv(expr);
-	u32 *dest = &regs->data[priv->dreg];
 	const struct sctp_chunkhdr *sch;
 	struct sctp_chunkhdr _sch;
 
@@ -384,16 +381,15 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
 
 		if (sch->type == priv->type) {
 			if (priv->flags & NFT_EXTHDR_F_PRESENT) {
-				nft_reg_store8(dest, true);
+				nft_reg_store_u8(regs, priv->dreg, true);
 				return;
 			}
 			if (priv->offset + priv->len > ntohs(sch->length) ||
 			    offset + ntohs(sch->length) > pkt->skb->len)
 				break;
 
-			dest[priv->len / NFT_REG32_SIZE] = 0;
-			if (skb_copy_bits(pkt->skb, offset + priv->offset,
-					  dest, priv->len) < 0)
+			if (nft_reg_store_skb(regs, priv->dreg, offset,
+					      priv->len, pkt->skb) < 0)
 				break;
 			return;
 		}
@@ -401,7 +397,7 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
 	} while (offset < pkt->skb->len);
 err:
 	if (priv->flags & NFT_EXTHDR_F_PRESENT)
-		nft_reg_store8(dest, false);
+		nft_reg_store_u8(regs, priv->dreg, false);
 	else
 		regs->verdict.code = NFT_BREAK;
 }
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 6e049fd48760..17480514cdb0 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -135,26 +135,39 @@ int nft_fib_dump(struct sk_buff *skb, const struct nft_expr *expr, bool reset)
 }
 EXPORT_SYMBOL_GPL(nft_fib_dump);
 
-void nft_fib_store_result(void *reg, const struct nft_fib *priv,
+void nft_fib_store_result(struct nft_regs *regs, const struct nft_fib *priv,
 			  const struct net_device *dev)
 {
-	u32 *dreg = reg;
+	const char *ifname;
 	int index;
+	u32 res;
 
 	switch (priv->result) {
 	case NFT_FIB_RESULT_OIF:
 		index = dev ? dev->ifindex : 0;
-		*dreg = (priv->flags & NFTA_FIB_F_PRESENT) ? !!index : index;
+		if (priv->flags & NFTA_FIB_F_PRESENT)
+			res = !!index;
+		else
+			res = index;
+
+		nft_reg_store_u32(regs, priv->dreg, res);
 		break;
 	case NFT_FIB_RESULT_OIFNAME:
-		if (priv->flags & NFTA_FIB_F_PRESENT)
-			*dreg = !!dev;
+		if (priv->flags & NFTA_FIB_F_PRESENT) {
+			nft_reg_store_u32(regs, priv->dreg, !!dev);
+			break;
+		}
+
+		if (dev)
+			ifname = dev->name;
 		else
-			strncpy(reg, dev ? dev->name : "", IFNAMSIZ);
+			ifname = "";
+
+		nft_reg_store_str(regs, priv->dreg, IFNAMSIZ, ifname);
 		break;
 	default:
 		WARN_ON_ONCE(1);
-		*dreg = 0;
+		nft_reg_store_u32(regs, priv->dreg, 0);
 		break;
 	}
 }
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index ee8d487b69c0..8bcf9e9aa550 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -34,7 +34,7 @@ static void nft_jhash_eval(const struct nft_expr *expr,
 	h = reciprocal_scale(jhash(data, priv->len, priv->seed),
 			     priv->modulus);
 
-	regs->data[priv->dreg] = h + priv->offset;
+	nft_reg_store_u32(regs, priv->dreg, h + priv->offset);
 }
 
 struct nft_symhash {
@@ -53,7 +53,7 @@ static void nft_symhash_eval(const struct nft_expr *expr,
 
 	h = reciprocal_scale(__skb_get_hash_symmetric(skb), priv->modulus);
 
-	regs->data[priv->dreg] = h + priv->offset;
+	nft_reg_store_u32(regs, priv->dreg, h + priv->offset);
 }
 
 static const struct nla_policy nft_hash_policy[NFTA_HASH_MAX + 1] = {
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index e384e0de7a54..05b98b39a132 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -57,19 +57,19 @@ static u32 nft_meta_hour(time64_t secs)
 		+ tm.tm_sec;
 }
 
-static noinline_for_stack void
-nft_meta_get_eval_time(enum nft_meta_keys key,
-		       u32 *dest)
+static noinline_for_stack
+void nft_meta_get_eval_time(struct nft_regs *regs, const struct nft_meta *priv)
 {
-	switch (key) {
+	switch (priv->key) {
 	case NFT_META_TIME_NS:
-		nft_reg_store64(dest, ktime_get_real_ns());
+		nft_reg_store_u64(regs, priv->dreg, ktime_get_real_ns());
 		break;
 	case NFT_META_TIME_DAY:
-		nft_reg_store8(dest, nft_meta_weekday());
+		nft_reg_store_u8(regs, priv->dreg, nft_meta_weekday());
 		break;
 	case NFT_META_TIME_HOUR:
-		*dest = nft_meta_hour(ktime_get_real_seconds());
+		nft_reg_store_u32(regs, priv->dreg,
+				  nft_meta_hour(ktime_get_real_seconds()));
 		break;
 	default:
 		break;
@@ -77,20 +77,21 @@ nft_meta_get_eval_time(enum nft_meta_keys key,
 }
 
 static noinline bool
-nft_meta_get_eval_pkttype_lo(const struct nft_pktinfo *pkt,
-			     u32 *dest)
+nft_meta_get_eval_pkttype_lo(struct nft_regs *regs,
+			     const struct nft_meta *priv,
+			     const struct nft_pktinfo *pkt)
 {
 	const struct sk_buff *skb = pkt->skb;
 
 	switch (nft_pf(pkt)) {
 	case NFPROTO_IPV4:
 		if (ipv4_is_multicast(ip_hdr(skb)->daddr))
-			nft_reg_store8(dest, PACKET_MULTICAST);
+			nft_reg_store_u8(regs, priv->dreg, PACKET_MULTICAST);
 		else
-			nft_reg_store8(dest, PACKET_BROADCAST);
+			nft_reg_store_u8(regs, priv->dreg, PACKET_BROADCAST);
 		break;
 	case NFPROTO_IPV6:
-		nft_reg_store8(dest, PACKET_MULTICAST);
+		nft_reg_store_u8(regs, priv->dreg, PACKET_MULTICAST);
 		break;
 	case NFPROTO_NETDEV:
 		switch (skb->protocol) {
@@ -104,14 +105,13 @@ nft_meta_get_eval_pkttype_lo(const struct nft_pktinfo *pkt,
 				return false;
 
 			if (ipv4_is_multicast(iph->daddr))
-				nft_reg_store8(dest, PACKET_MULTICAST);
+				nft_reg_store_u8(regs, priv->dreg, PACKET_MULTICAST);
 			else
-				nft_reg_store8(dest, PACKET_BROADCAST);
-
+				nft_reg_store_u8(regs, priv->dreg, PACKET_BROADCAST);
 			break;
 		}
 		case htons(ETH_P_IPV6):
-			nft_reg_store8(dest, PACKET_MULTICAST);
+			nft_reg_store_u8(regs, priv->dreg, PACKET_MULTICAST);
 			break;
 		default:
 			WARN_ON_ONCE(1);
@@ -127,8 +127,7 @@ nft_meta_get_eval_pkttype_lo(const struct nft_pktinfo *pkt,
 }
 
 static noinline bool
-nft_meta_get_eval_skugid(enum nft_meta_keys key,
-			 u32 *dest,
+nft_meta_get_eval_skugid(struct nft_regs *regs, const struct nft_meta *priv,
 			 const struct nft_pktinfo *pkt)
 {
 	struct sock *sk = skb_to_full_sk(pkt->skb);
@@ -144,53 +143,61 @@ nft_meta_get_eval_skugid(enum nft_meta_keys key,
 		return false;
 	}
 
-	switch (key) {
+	switch (priv->key) {
 	case NFT_META_SKUID:
-		*dest = from_kuid_munged(sock_net(sk)->user_ns,
-					 sock->file->f_cred->fsuid);
+		nft_reg_store_u32(regs, priv->dreg,
+				  from_kuid_munged(sock_net(sk)->user_ns,
+						   sock->file->f_cred->fsuid));
 		break;
 	case NFT_META_SKGID:
-		*dest =	from_kgid_munged(sock_net(sk)->user_ns,
-					 sock->file->f_cred->fsgid);
+		nft_reg_store_u32(regs, priv->dreg,
+				  from_kgid_munged(sock_net(sk)->user_ns,
+						   sock->file->f_cred->fsgid));
 		break;
 	default:
 		break;
 	}
-
 	read_unlock_bh(&sk->sk_callback_lock);
+
 	return true;
 }
 
 #ifdef CONFIG_CGROUP_NET_CLASSID
 static noinline bool
-nft_meta_get_eval_cgroup(u32 *dest, const struct nft_pktinfo *pkt)
+nft_meta_get_eval_cgroup(struct nft_regs *regs, const struct nft_meta *priv,
+			 const struct nft_pktinfo *pkt)
 {
 	struct sock *sk = skb_to_full_sk(pkt->skb);
 
 	if (!sk || !sk_fullsock(sk) || !net_eq(nft_net(pkt), sock_net(sk)))
 		return false;
 
-	*dest = sock_cgroup_classid(&sk->sk_cgrp_data);
+	nft_reg_store_u32(regs, priv->dreg,
+			  sock_cgroup_classid(&sk->sk_cgrp_data));
 	return true;
 }
 #endif
 
-static noinline bool nft_meta_get_eval_kind(enum nft_meta_keys key,
-					    u32 *dest,
+static noinline bool nft_meta_get_eval_kind(struct nft_regs *regs,
+					    const struct nft_meta *priv,
 					    const struct nft_pktinfo *pkt)
 {
 	const struct net_device *in = nft_in(pkt), *out = nft_out(pkt);
 
-	switch (key) {
+	switch (priv->key) {
 	case NFT_META_IIFKIND:
 		if (!in || !in->rtnl_link_ops)
 			return false;
-		strncpy((char *)dest, in->rtnl_link_ops->kind, IFNAMSIZ);
+
+		nft_reg_store_str(regs, priv->dreg, IFNAMSIZ,
+				  in->rtnl_link_ops->kind);
 		break;
 	case NFT_META_OIFKIND:
 		if (!out || !out->rtnl_link_ops)
 			return false;
-		strncpy((char *)dest, out->rtnl_link_ops->kind, IFNAMSIZ);
+
+		nft_reg_store_str(regs, priv->dreg, IFNAMSIZ,
+				  out->rtnl_link_ops->kind);
 		break;
 	default:
 		return false;
@@ -199,68 +206,79 @@ static noinline bool nft_meta_get_eval_kind(enum nft_meta_keys key,
 	return true;
 }
 
-static void nft_meta_store_ifindex(u32 *dest, const struct net_device *dev)
+static void nft_meta_store_ifindex(struct nft_regs *regs,
+				   const struct nft_meta *priv,
+				   const struct net_device *dev)
 {
-	*dest = dev ? dev->ifindex : 0;
+	nft_reg_store_u32(regs, priv->dreg, dev ? dev->ifindex : 0);
 }
 
-static void nft_meta_store_ifname(u32 *dest, const struct net_device *dev)
+static void nft_meta_store_ifname(struct nft_regs *regs,
+				  const struct nft_meta *priv,
+				  const struct net_device *dev)
 {
-	strncpy((char *)dest, dev ? dev->name : "", IFNAMSIZ);
+	nft_reg_store_str(regs, priv->dreg, IFNAMSIZ, dev ? dev->name : "");
 }
 
-static bool nft_meta_store_iftype(u32 *dest, const struct net_device *dev)
+static bool nft_meta_store_iftype(struct nft_regs *regs,
+				  const struct nft_meta *priv,
+				  const struct net_device *dev)
 {
 	if (!dev)
 		return false;
 
-	nft_reg_store16(dest, dev->type);
+	nft_reg_store_u32(regs, priv->dreg, dev->type);
+
 	return true;
 }
 
-static bool nft_meta_store_ifgroup(u32 *dest, const struct net_device *dev)
+static bool nft_meta_store_ifgroup(struct nft_regs *regs,
+				   const struct nft_meta *priv,
+				   const struct net_device *dev)
 {
 	if (!dev)
 		return false;
 
-	*dest = dev->group;
+	nft_reg_store_u32(regs, priv->dreg, dev->group);
+
 	return true;
 }
 
-static bool nft_meta_get_eval_ifname(enum nft_meta_keys key, u32 *dest,
+static bool nft_meta_get_eval_ifname(struct nft_regs *regs,
+				     const struct nft_meta *priv,
 				     const struct nft_pktinfo *pkt)
 {
-	switch (key) {
+	switch (priv->key) {
 	case NFT_META_IIFNAME:
-		nft_meta_store_ifname(dest, nft_in(pkt));
+		nft_meta_store_ifname(regs, priv, nft_in(pkt));
 		break;
 	case NFT_META_OIFNAME:
-		nft_meta_store_ifname(dest, nft_out(pkt));
+		nft_meta_store_ifname(regs, priv, nft_out(pkt));
 		break;
 	case NFT_META_IIF:
-		nft_meta_store_ifindex(dest, nft_in(pkt));
+		nft_meta_store_ifindex(regs, priv, nft_in(pkt));
 		break;
 	case NFT_META_OIF:
-		nft_meta_store_ifindex(dest, nft_out(pkt));
+		nft_meta_store_ifindex(regs, priv, nft_out(pkt));
 		break;
 	case NFT_META_IFTYPE:
-		if (!nft_meta_store_iftype(dest, pkt->skb->dev))
+		if (!nft_meta_store_iftype(regs, priv, pkt->skb->dev))
 			return false;
 		break;
 	case __NFT_META_IIFTYPE:
-		if (!nft_meta_store_iftype(dest, nft_in(pkt)))
+		if (!nft_meta_store_iftype(regs, priv, nft_in(pkt)))
 			return false;
 		break;
 	case NFT_META_OIFTYPE:
-		if (!nft_meta_store_iftype(dest, nft_out(pkt)))
+		if (!nft_meta_store_iftype(regs, priv, nft_out(pkt)))
 			return false;
 		break;
 	case NFT_META_IIFGROUP:
-		if (!nft_meta_store_ifgroup(dest, nft_in(pkt)))
+		if (!nft_meta_store_ifgroup(regs, priv, nft_in(pkt)))
 			return false;
 		break;
 	case NFT_META_OIFGROUP:
-		if (!nft_meta_store_ifgroup(dest, nft_out(pkt)))
+		if (!nft_meta_store_ifgroup(regs, priv, nft_out(pkt)))
 			return false;
 		break;
 	default:
@@ -272,14 +290,16 @@ static bool nft_meta_get_eval_ifname(enum nft_meta_keys key, u32 *dest,
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
 static noinline bool
-nft_meta_get_eval_rtclassid(const struct sk_buff *skb, u32 *dest)
+nft_meta_get_eval_rtclassid(struct nft_regs *regs, const struct nft_meta *priv,
+			    const struct sk_buff *skb)
 {
 	const struct dst_entry *dst = skb_dst(skb);
 
 	if (!dst)
 		return false;
 
-	*dest = dst->tclassid;
+	nft_reg_store_u32(regs, priv->dreg, dst->tclassid);
+
 	return true;
 }
 #endif
@@ -297,13 +317,14 @@ static noinline u32 nft_meta_get_eval_sdif(const struct nft_pktinfo *pkt)
 }
 
 static noinline void
-nft_meta_get_eval_sdifname(u32 *dest, const struct nft_pktinfo *pkt)
+nft_meta_get_eval_sdifname(struct nft_regs *regs, const struct nft_meta *priv,
+			   const struct nft_pktinfo *pkt)
 {
 	u32 sdif = nft_meta_get_eval_sdif(pkt);
 	const struct net_device *dev;
 
 	dev = sdif ? dev_get_by_index_rcu(nft_net(pkt), sdif) : NULL;
-	nft_meta_store_ifname(dest, dev);
+	nft_meta_store_ifname(regs, priv, dev);
 }
 
 void nft_meta_get_eval(const struct nft_expr *expr,
@@ -312,28 +333,28 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
-	u32 *dest = &regs->data[priv->dreg];
 
 	switch (priv->key) {
 	case NFT_META_LEN:
-		*dest = skb->len;
+		nft_reg_store_u32(regs, priv->dreg, skb->len);
 		break;
 	case NFT_META_PROTOCOL:
-		nft_reg_store16(dest, (__force u16)skb->protocol);
+		nft_reg_store_u16(regs, priv->dreg, (__force u16)skb->protocol);
 		break;
 	case NFT_META_NFPROTO:
-		nft_reg_store8(dest, nft_pf(pkt));
+		nft_reg_store_u8(regs, priv->dreg, nft_pf(pkt));
 		break;
 	case NFT_META_L4PROTO:
 		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
 			goto err;
-		nft_reg_store8(dest, pkt->tprot);
+
+		nft_reg_store_u8(regs, priv->dreg, pkt->tprot);
 		break;
 	case NFT_META_PRIORITY:
-		*dest = skb->priority;
+		nft_reg_store_u32(regs, priv->dreg, skb->priority);
 		break;
 	case NFT_META_MARK:
-		*dest = skb->mark;
+		nft_reg_store_u32(regs, priv->dreg, skb->mark);
 		break;
 	case NFT_META_IIF:
 	case NFT_META_OIF:
@@ -343,66 +364,67 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 	case NFT_META_OIFTYPE:
 	case NFT_META_IIFGROUP:
 	case NFT_META_OIFGROUP:
-		if (!nft_meta_get_eval_ifname(priv->key, dest, pkt))
+		if (!nft_meta_get_eval_ifname(regs, priv, pkt))
 			goto err;
 		break;
 	case NFT_META_SKUID:
 	case NFT_META_SKGID:
-		if (!nft_meta_get_eval_skugid(priv->key, dest, pkt))
+		if (!nft_meta_get_eval_skugid(regs, priv, pkt))
 			goto err;
 		break;
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	case NFT_META_RTCLASSID:
-		if (!nft_meta_get_eval_rtclassid(skb, dest))
+		if (!nft_meta_get_eval_rtclassid(regs, priv, skb))
 			goto err;
 		break;
 #endif
 #ifdef CONFIG_NETWORK_SECMARK
 	case NFT_META_SECMARK:
-		*dest = skb->secmark;
+		nft_reg_store_u32(regs, priv->dreg, skb->secmark);
 		break;
 #endif
 	case NFT_META_PKTTYPE:
 		if (skb->pkt_type != PACKET_LOOPBACK) {
-			nft_reg_store8(dest, skb->pkt_type);
+			nft_reg_store_u8(regs, priv->dreg, skb->pkt_type);
 			break;
 		}
 
-		if (!nft_meta_get_eval_pkttype_lo(pkt, dest))
+		if (!nft_meta_get_eval_pkttype_lo(regs, priv, pkt))
 			goto err;
 		break;
 	case NFT_META_CPU:
-		*dest = raw_smp_processor_id();
+		nft_reg_store_u32(regs, priv->dreg, raw_smp_processor_id());
 		break;
 #ifdef CONFIG_CGROUP_NET_CLASSID
 	case NFT_META_CGROUP:
-		if (!nft_meta_get_eval_cgroup(dest, pkt))
+		if (!nft_meta_get_eval_cgroup(regs, priv, pkt))
 			goto err;
 		break;
 #endif
 	case NFT_META_PRANDOM:
-		*dest = get_random_u32();
+		nft_reg_store_u32(regs, priv->dreg, get_random_u32());
 		break;
 #ifdef CONFIG_XFRM
 	case NFT_META_SECPATH:
-		nft_reg_store8(dest, secpath_exists(skb));
+		nft_reg_store_u8(regs, priv->dreg, secpath_exists(skb));
 		break;
 #endif
 	case NFT_META_IIFKIND:
 	case NFT_META_OIFKIND:
-		if (!nft_meta_get_eval_kind(priv->key, dest, pkt))
+		if (!nft_meta_get_eval_kind(regs, priv, pkt))
 			goto err;
 		break;
 	case NFT_META_TIME_NS:
 	case NFT_META_TIME_DAY:
 	case NFT_META_TIME_HOUR:
-		nft_meta_get_eval_time(priv->key, dest);
+		nft_meta_get_eval_time(regs, priv);
 		break;
 	case NFT_META_SDIF:
-		*dest = nft_meta_get_eval_sdif(pkt);
+		nft_reg_store_u32(regs, priv->dreg,
+				  nft_meta_get_eval_sdif(pkt));
 		break;
 	case NFT_META_SDIFNAME:
-		nft_meta_get_eval_sdifname(dest, pkt);
+		nft_meta_get_eval_sdifname(regs, priv, pkt);
 		break;
 	default:
 		WARN_ON(1);
@@ -862,17 +884,17 @@ void nft_meta_inner_eval(const struct nft_expr *expr,
 			 struct nft_inner_tun_ctx *tun_ctx)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
-	u32 *dest = &regs->data[priv->dreg];
 
 	switch (priv->key) {
 	case NFT_META_PROTOCOL:
-		nft_reg_store16(dest, (__force u16)tun_ctx->llproto);
+		nft_reg_store_u16(regs, priv->dreg,
+				  (__force u16)tun_ctx->llproto);
 		break;
 	case NFT_META_L4PROTO:
 		if (!(tun_ctx->flags & NFT_PAYLOAD_CTX_INNER_TH))
 			goto err;
 
-		nft_reg_store8(dest, tun_ctx->l4proto);
+		nft_reg_store_u8(regs, priv->dreg, tun_ctx->l4proto);
 		break;
 	default:
 		WARN_ON_ONCE(1);
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 7d29db7c2ac0..8d2d3d52fc63 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -39,7 +39,7 @@ static void nft_ng_inc_eval(const struct nft_expr *expr,
 {
 	struct nft_ng_inc *priv = nft_expr_priv(expr);
 
-	regs->data[priv->dreg] = nft_ng_inc_gen(priv);
+	nft_reg_store_u32(regs, priv->dreg, nft_ng_inc_gen(priv));
 }
 
 static const struct nla_policy nft_ng_policy[NFTA_NG_MAX + 1] = {
@@ -146,7 +146,7 @@ static void nft_ng_random_eval(const struct nft_expr *expr,
 {
 	struct nft_ng_random *priv = nft_expr_priv(expr);
 
-	regs->data[priv->dreg] = nft_ng_random_gen(priv);
+	nft_reg_store_u32(regs, priv->dreg, nft_ng_random_gen(priv));
 }
 
 static int nft_ng_random_init(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 70820c66b591..0f50d36eec18 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -21,7 +21,6 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 			 const struct nft_pktinfo *pkt)
 {
 	struct nft_osf *priv = nft_expr_priv(expr);
-	u32 *dest = &regs->data[priv->dreg];
 	struct sk_buff *skb = pkt->skb;
 	char os_match[NFT_OSF_MAXGENRELEN + 1];
 	const struct tcphdr *tcp;
@@ -45,7 +44,8 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	}
 
 	if (!nf_osf_find(skb, nf_osf_fingers, priv->ttl, &data)) {
-		strncpy((char *)dest, "unknown", NFT_OSF_MAXGENRELEN);
+		nft_reg_store_str(regs, priv->dreg, NFT_OSF_MAXGENRELEN,
+				  "unknown");
 	} else {
 		if (priv->flags & NFT_OSF_F_VERSION)
 			snprintf(os_match, NFT_OSF_MAXGENRELEN, "%s:%s",
@@ -53,7 +53,8 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		else
 			strscpy(os_match, data.genre, NFT_OSF_MAXGENRELEN);
 
-		strncpy((char *)dest, os_match, NFT_OSF_MAXGENRELEN);
+		nft_reg_store_str(regs, priv->dreg, NFT_OSF_MAXGENRELEN,
+				  os_match);
 	}
 }
 
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 3a3c7746e88f..1c016089727b 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -40,13 +40,17 @@ static bool nft_payload_rebuild_vlan_hdr(const struct sk_buff *skb, int mac_off,
 
 /* add vlan header into the user buffer for if tag was removed by offloads */
 static bool
-nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
+nft_payload_copy_vlan(struct nft_regs *regs, const struct sk_buff *skb,
+		      const struct nft_payload *priv)
 {
+	u8 *vlanh, dst[sizeof_field(struct nft_regs, data)], *dst_u8;
 	int mac_off = skb_mac_header(skb) - skb->data;
-	u8 *vlanh, *dst_u8 = (u8 *) d;
+	u8 offset = priv->offset, len = priv->len;
 	struct vlan_ethhdr veth;
 	u8 vlan_hlen = 0;
 
+	dst_u8 = dst;
+
 	if ((skb->protocol == htons(ETH_P_8021AD) ||
 	     skb->protocol == htons(ETH_P_8021Q)) &&
 	    offset >= VLAN_ETH_HLEN && offset < VLAN_ETH_HLEN + VLAN_HLEN)
@@ -77,7 +81,12 @@ nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
 		offset -= VLAN_HLEN + vlan_hlen;
 	}
 
-	return skb_copy_bits(skb, offset + mac_off, dst_u8, len) == 0;
+	if (skb_copy_bits(skb, offset + mac_off, dst_u8, len) < 0)
+		return false;
+
+	nft_reg_store(regs, priv->dreg, priv->len, dst_u8);
+
+	return true;
 }
 
 static int __nft_payload_inner_offset(struct nft_pktinfo *pkt)
@@ -160,20 +169,15 @@ void nft_payload_eval(const struct nft_expr *expr,
 {
 	const struct nft_payload *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
-	u32 *dest = &regs->data[priv->dreg];
 	int offset;
 
-	if (priv->len % NFT_REG32_SIZE)
-		dest[priv->len / NFT_REG32_SIZE] = 0;
-
 	switch (priv->base) {
 	case NFT_PAYLOAD_LL_HEADER:
 		if (!skb_mac_header_was_set(skb))
 			goto err;
 
 		if (skb_vlan_tag_present(skb)) {
-			if (!nft_payload_copy_vlan(dest, skb,
-						   priv->offset, priv->len))
+			if (!nft_payload_copy_vlan(regs, skb, priv))
 				goto err;
 			return;
 		}
@@ -198,8 +202,9 @@ void nft_payload_eval(const struct nft_expr *expr,
 	}
 	offset += priv->offset;
 
-	if (skb_copy_bits(skb, offset, dest, priv->len) < 0)
+	if (nft_reg_store_skb(regs, priv->dreg, offset, priv->len, skb) < 0)
 		goto err;
+
 	return;
 err:
 	regs->verdict.code = NFT_BREAK;
@@ -595,12 +600,8 @@ void nft_payload_inner_eval(const struct nft_expr *expr, struct nft_regs *regs,
 {
 	const struct nft_payload *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
-	u32 *dest = &regs->data[priv->dreg];
 	int offset;
 
-	if (priv->len % NFT_REG32_SIZE)
-		dest[priv->len / NFT_REG32_SIZE] = 0;
-
 	switch (priv->base) {
 	case NFT_PAYLOAD_TUN_HEADER:
 		if (!(tun_ctx->flags & NFT_PAYLOAD_CTX_INNER_TUN))
@@ -632,7 +633,7 @@ void nft_payload_inner_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	}
 	offset += priv->offset;
 
-	if (skb_copy_bits(skb, offset, dest, priv->len) < 0)
+	if (nft_reg_store_skb(regs, priv->dreg, offset, priv->len, skb) < 0)
 		goto err;
 
 	return;
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index 5990fdd7b3cc..0d836ef1e33c 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -56,7 +56,6 @@ void nft_rt_get_eval(const struct nft_expr *expr,
 {
 	const struct nft_rt *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
-	u32 *dest = &regs->data[priv->dreg];
 	const struct dst_entry *dst;
 
 	dst = skb_dst(skb);
@@ -66,30 +65,31 @@ void nft_rt_get_eval(const struct nft_expr *expr,
 	switch (priv->key) {
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	case NFT_RT_CLASSID:
-		*dest = dst->tclassid;
+		nft_reg_store_u32(regs, priv->dreg, dst->tclassid);
 		break;
 #endif
 	case NFT_RT_NEXTHOP4:
 		if (nft_pf(pkt) != NFPROTO_IPV4)
 			goto err;
 
-		*dest = (__force u32)rt_nexthop((const struct rtable *)dst,
-						ip_hdr(skb)->daddr);
+		nft_reg_store_u32(regs, priv->dreg,
+				  (__force u32)rt_nexthop((const struct rtable *)dst,
+							  ip_hdr(skb)->daddr));
 		break;
 	case NFT_RT_NEXTHOP6:
 		if (nft_pf(pkt) != NFPROTO_IPV6)
 			goto err;
 
-		memcpy(dest, rt6_nexthop((struct rt6_info *)dst,
-					 &ipv6_hdr(skb)->daddr),
-		       sizeof(struct in6_addr));
+		nft_reg_store(regs, priv->dreg, sizeof(struct in6_addr),
+			      rt6_nexthop((struct rt6_info *)dst,
+					  &ipv6_hdr(skb)->daddr));
 		break;
 	case NFT_RT_TCPMSS:
-		nft_reg_store16(dest, get_tcpmss(pkt, dst));
+		nft_reg_store_u16(regs, priv->dreg, get_tcpmss(pkt, dst));
 		break;
 #ifdef CONFIG_XFRM
 	case NFT_RT_XFRM:
-		nft_reg_store8(dest, !!dst->xfrm);
+		nft_reg_store_u8(regs, priv->dreg, !!dst->xfrm);
 		break;
 #endif
 	default:
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 85f8df87efda..cdea11597cf1 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -18,15 +18,17 @@ struct nft_socket {
 
 static void nft_socket_wildcard(const struct nft_pktinfo *pkt,
 				struct nft_regs *regs, struct sock *sk,
-				u32 *dest)
+				const struct nft_socket *priv)
 {
 	switch (nft_pf(pkt)) {
 	case NFPROTO_IPV4:
-		nft_reg_store8(dest, inet_sk(sk)->inet_rcv_saddr == 0);
+		nft_reg_store_u8(regs, priv->dreg,
+				 inet_sk(sk)->inet_rcv_saddr == 0);
 		break;
 #if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
 	case NFPROTO_IPV6:
-		nft_reg_store8(dest, ipv6_addr_any(&sk->sk_v6_rcv_saddr));
+		nft_reg_store_u8(regs, priv->dreg,
+				 ipv6_addr_any(&sk->sk_v6_rcv_saddr));
 		break;
 #endif
 	default:
@@ -37,7 +39,9 @@ static void nft_socket_wildcard(const struct nft_pktinfo *pkt,
 
 #ifdef CONFIG_SOCK_CGROUP_DATA
 static noinline bool
-nft_sock_get_eval_cgroupv2(u32 *dest, struct sock *sk, const struct nft_pktinfo *pkt, u32 level)
+nft_sock_get_eval_cgroupv2(struct nft_regs *regs, struct sock *sk,
+			   const struct nft_pktinfo *pkt,
+			   const struct nft_socket *priv)
 {
 	struct cgroup *cgrp;
 	u64 cgid;
@@ -45,12 +49,13 @@ nft_sock_get_eval_cgroupv2(u32 *dest, struct sock *sk, const struct nft_pktinfo
 	if (!sk_fullsock(sk))
 		return false;
 
-	cgrp = cgroup_ancestor(sock_cgroup_ptr(&sk->sk_cgrp_data), level);
+	cgrp = cgroup_ancestor(sock_cgroup_ptr(&sk->sk_cgrp_data), priv->level);
 	if (!cgrp)
 		return false;
 
 	cgid = cgroup_id(cgrp);
-	memcpy(dest, &cgid, sizeof(u64));
+	nft_reg_store(regs, priv->dreg, sizeof(cgid), &cgid);
+
 	return true;
 }
 #endif
@@ -88,7 +93,6 @@ static void nft_socket_eval(const struct nft_expr *expr,
 	const struct nft_socket *priv = nft_expr_priv(expr);
 	struct sk_buff *skb = pkt->skb;
 	struct sock *sk = skb->sk;
-	u32 *dest = &regs->data[priv->dreg];
 
 	if (sk && !net_eq(nft_net(pkt), sock_net(sk)))
 		sk = NULL;
@@ -103,26 +107,25 @@ static void nft_socket_eval(const struct nft_expr *expr,
 
 	switch(priv->key) {
 	case NFT_SOCKET_TRANSPARENT:
-		nft_reg_store8(dest, inet_sk_transparent(sk));
+		nft_reg_store_u8(regs, priv->dreg, inet_sk_transparent(sk));
 		break;
 	case NFT_SOCKET_MARK:
-		if (sk_fullsock(sk)) {
-			*dest = sk->sk_mark;
-		} else {
+		if (!sk_fullsock(sk)) {
 			regs->verdict.code = NFT_BREAK;
 			return;
 		}
+		nft_reg_store_u32(regs, priv->dreg, sk->sk_mark);
 		break;
 	case NFT_SOCKET_WILDCARD:
 		if (!sk_fullsock(sk)) {
 			regs->verdict.code = NFT_BREAK;
 			return;
 		}
-		nft_socket_wildcard(pkt, regs, sk, dest);
+		nft_socket_wildcard(pkt, regs, sk, priv);
 		break;
 #ifdef CONFIG_SOCK_CGROUP_DATA
 	case NFT_SOCKET_CGROUPV2:
-		if (!nft_sock_get_eval_cgroupv2(dest, sk, pkt, priv->level)) {
+		if (!nft_sock_get_eval_cgroupv2(regs, sk, pkt, priv)) {
 			regs->verdict.code = NFT_BREAK;
 			return;
 		}
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index b059aa541798..7b84585e3795 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -25,7 +25,6 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 				const struct nft_pktinfo *pkt)
 {
 	const struct nft_tunnel *priv = nft_expr_priv(expr);
-	u32 *dest = &regs->data[priv->dreg];
 	struct ip_tunnel_info *tun_info;
 
 	tun_info = skb_tunnel_info(pkt->skb);
@@ -33,7 +32,7 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 	switch (priv->key) {
 	case NFT_TUNNEL_PATH:
 		if (!tun_info) {
-			nft_reg_store8(dest, false);
+			nft_reg_store_u8(regs, priv->dreg, false);
 			return;
 		}
 		if (priv->mode == NFT_TUNNEL_MODE_NONE ||
@@ -41,9 +40,9 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 		     !(tun_info->mode & IP_TUNNEL_INFO_TX)) ||
 		    (priv->mode == NFT_TUNNEL_MODE_TX &&
 		     (tun_info->mode & IP_TUNNEL_INFO_TX)))
-			nft_reg_store8(dest, true);
+			nft_reg_store_u8(regs, priv->dreg, true);
 		else
-			nft_reg_store8(dest, false);
+			nft_reg_store_u8(regs, priv->dreg, false);
 		break;
 	case NFT_TUNNEL_ID:
 		if (!tun_info) {
@@ -55,7 +54,8 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 		     !(tun_info->mode & IP_TUNNEL_INFO_TX)) ||
 		    (priv->mode == NFT_TUNNEL_MODE_TX &&
 		     (tun_info->mode & IP_TUNNEL_INFO_TX)))
-			*dest = ntohl(tunnel_id_to_key32(tun_info->key.tun_id));
+			nft_reg_store_u32(regs, priv->dreg,
+					  ntohl(tunnel_id_to_key32(tun_info->key.tun_id)));
 		else
 			regs->verdict.code = NFT_BREAK;
 		break;
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index c88fd078a9ae..2bb6463c26dc 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -119,8 +119,6 @@ static void nft_xfrm_state_get_key(const struct nft_xfrm *priv,
 				   struct nft_regs *regs,
 				   const struct xfrm_state *state)
 {
-	u32 *dest = &regs->data[priv->dreg];
-
 	if (!xfrm_state_addr_ok(priv->key,
 				state->props.family,
 				state->props.mode)) {
@@ -134,22 +132,27 @@ static void nft_xfrm_state_get_key(const struct nft_xfrm *priv,
 		WARN_ON_ONCE(1);
 		break;
 	case NFT_XFRM_KEY_DADDR_IP4:
-		*dest = (__force __u32)state->id.daddr.a4;
+		nft_reg_store_u32(regs, priv->dreg,
+				  (__force __u32)state->id.daddr.a4);
 		return;
 	case NFT_XFRM_KEY_DADDR_IP6:
-		memcpy(dest, &state->id.daddr.in6, sizeof(struct in6_addr));
+		nft_reg_store(regs, priv->dreg, sizeof(struct in6_addr),
+			      &state->id.daddr.in6);
 		return;
 	case NFT_XFRM_KEY_SADDR_IP4:
-		*dest = (__force __u32)state->props.saddr.a4;
+		nft_reg_store_u32(regs, priv->dreg,
+				  (__force __u32)state->props.saddr.a4);
 		return;
 	case NFT_XFRM_KEY_SADDR_IP6:
-		memcpy(dest, &state->props.saddr.in6, sizeof(struct in6_addr));
+		nft_reg_store(regs, priv->dreg, sizeof(struct in6_addr),
+			      &state->props.saddr.in6);
 		return;
 	case NFT_XFRM_KEY_REQID:
-		*dest = state->props.reqid;
+		nft_reg_store_u32(regs, priv->dreg, state->props.reqid);
 		return;
 	case NFT_XFRM_KEY_SPI:
-		*dest = (__force __u32)state->id.spi;
+		nft_reg_store_u32(regs, priv->dreg,
+				  (__force __u32)state->id.spi);
 		return;
 	}
 
-- 
2.30.2

