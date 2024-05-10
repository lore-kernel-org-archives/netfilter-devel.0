Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0AC2173
	for <netfilter-devel@vger.kernel.org>; Fri, 10 May 2024 00:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715299656; cv=none; b=rwB6SHLIGHUNopzZ0DnK96actIktdlUS9/KZKIno5NgBqKh2OHoP+EsvV6us5GFGbA5796dIIGBI0gPkGuYwxXg05qOIjnPgYfYD+GqYwxXy3DL2LUrKDznuNzpqWiTK+ntIGJ5SEoqGAQt6SmtWm+ubtV1dZwVGFaERr56D+2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715299656; c=relaxed/simple;
	bh=DwQMFKPssavHVlRJeVHDjzFWsa594eVp/3cCYsgpAIs=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p5QW7+u+6X0vEHLtLsY4McyqsoAt0kfqZWnqcImdy7TnEJ+HcupWegYVu85TRmGMWrVIXjKL05UDjT+6zFi3MDwI6dNOs3HSPoSCZnuMLge9FCouUyJ8e9leaicK+iPqLdNa1pBH0SYDQ/5gD43L3ZRq4q85eUf870WEgTws6cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 2/2] netfilter: nft_payload: skbuff vlan metadata mangle support
Date: Fri, 10 May 2024 02:07:19 +0200
Message-Id: <20240510000719.3205-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240510000719.3205-1-pablo@netfilter.org>
References: <20240510000719.3205-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Userspace assumes vlan header is present at a given offset, but vlan
offload allows to store this in metadata fields of the skbuff. Handle
this transparently by adding a parser to the kernel.

If vlan metadata is present and payload offset is over 12 bytes (source
and destination mac address fields), then subtract vlan header present
in vlan metadata, otherwise mangle vlan metadata based on offset and
length, extracting data from the source register.

This is similar to:

  8cfd23e67401 ("netfilter: nft_payload: work around vlan header stripping")

to deal with vlan payload mangling.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 72 +++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index a3cb5dbcb362..e1af7b5e70c6 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -145,12 +145,12 @@ int nft_payload_inner_offset(const struct nft_pktinfo *pkt)
 	return pkt->inneroff;
 }
 
-static bool nft_payload_need_vlan_copy(const struct nft_payload *priv)
+static bool nft_payload_need_vlan_adjust(u32 offset, u32 len)
 {
-	unsigned int len = priv->offset + priv->len;
+	unsigned int boundary = offset + len;
 
 	/* data past ether src/dst requested, copy needed */
-	if (len > offsetof(struct ethhdr, h_proto))
+	if (boundary > offsetof(struct ethhdr, h_proto))
 		return true;
 
 	return false;
@@ -174,7 +174,7 @@ void nft_payload_eval(const struct nft_expr *expr,
 			goto err;
 
 		if (skb_vlan_tag_present(skb) &&
-		    nft_payload_need_vlan_copy(priv)) {
+		    nft_payload_need_vlan_adjust(priv->offset, priv->len)) {
 			if (!nft_payload_copy_vlan(dest, skb,
 						   priv->offset, priv->len))
 				goto err;
@@ -801,21 +801,79 @@ struct nft_payload_set {
 	u8			csum_flags;
 };
 
+/* This is not struct vlan_hdr. */
+struct nft_payload_vlan_hdr {
+        __be16          h_vlan_proto;
+        __be16          h_vlan_TCI;
+};
+
+static bool
+nft_payload_set_vlan(const u32 *src, struct sk_buff *skb, u8 offset, u8 len,
+		     int *vlan_hlen)
+{
+	struct nft_payload_vlan_hdr *vlanh;
+	__be16 vlan_proto;
+	__be16 vlan_tci;
+
+	if (offset >= offsetof(struct vlan_ethhdr, h_vlan_encapsulated_proto)) {
+		*vlan_hlen = VLAN_HLEN;
+		return true;
+	}
+
+	switch (offset) {
+	case offsetof(struct vlan_ethhdr, h_vlan_proto):
+		if (len == 2) {
+			vlan_proto = nft_reg_load16(src);
+			skb->vlan_proto = vlan_proto;
+		} else if (len == 4) {
+			vlanh = (struct nft_payload_vlan_hdr *)src;
+			__vlan_hwaccel_put_tag(skb, vlanh->h_vlan_proto,
+					       ntohs(vlanh->h_vlan_TCI));
+		} else {
+			return false;
+		}
+		break;
+	case offsetof(struct vlan_ethhdr, h_vlan_TCI):
+		if (len != 2)
+			return false;
+
+		vlan_tci = ntohs(nft_reg_load16(src));
+		skb->vlan_tci = vlan_tci;
+		break;
+	default:
+		return false;
+	}
+
+	return true;
+}
+
 static void nft_payload_set_eval(const struct nft_expr *expr,
 				 struct nft_regs *regs,
 				 const struct nft_pktinfo *pkt)
 {
 	const struct nft_payload_set *priv = nft_expr_priv(expr);
-	struct sk_buff *skb = pkt->skb;
 	const u32 *src = &regs->data[priv->sreg];
-	int offset, csum_offset;
+	int offset, csum_offset, vlan_hlen = 0;
+	struct sk_buff *skb = pkt->skb;
 	__wsum fsum, tsum;
 
 	switch (priv->base) {
 	case NFT_PAYLOAD_LL_HEADER:
 		if (!skb_mac_header_was_set(skb))
 			goto err;
-		offset = skb_mac_header(skb) - skb->data;
+
+		if (skb_vlan_tag_present(skb) &&
+		    nft_payload_need_vlan_adjust(priv->offset, priv->len)) {
+			if (!nft_payload_set_vlan(src, skb,
+						  priv->offset, priv->len,
+						  &vlan_hlen))
+				goto err;
+
+			if (!vlan_hlen)
+				return;
+		}
+
+		offset = skb_mac_header(skb) - skb->data - vlan_hlen;
 		break;
 	case NFT_PAYLOAD_NETWORK_HEADER:
 		offset = skb_network_offset(skb);
-- 
2.30.2

