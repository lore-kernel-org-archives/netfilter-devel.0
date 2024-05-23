Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEFAC171D2;
	Thu, 23 May 2024 16:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716481228; cv=none; b=Afb9VuctUC619uD5ULCgScf0cAwuMF5WycDelAJkpLQ7VnG5IK4zDl/XZydXNOhDJbBusF+xYxfWgf9x1WLwumMmqw1UrposEWweNxCyavRMHJoXlrhyAZGLor82+aOIh1Htn7fKbh9RGOzMvv6AoysS5Eecj2JKtYIggfBuh/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716481228; c=relaxed/simple;
	bh=F61dKzlEpQOywDFWGNNfICzKievcbWit/fPk7eR29Uc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p+eHurRMSH8qL2BJX9yuGbQXevPrOjP/9qa+cQMApXBkGJCrLO1+AOb5i6FNU73xeIixoIIamiHSCffmDPxTFx0/ZcVowQtPRznyU5YvDAyrp8rXNveHH7e9IPNdR/vlUifO2SdLYZMvhgHOJIv0ZzJzhufiD2MLwZhJZ9La8iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 4/6] netfilter: nft_payload: skbuff vlan metadata mangle support
Date: Thu, 23 May 2024 18:20:17 +0200
Message-Id: <20240523162019.5035-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240523162019.5035-1-pablo@netfilter.org>
References: <20240523162019.5035-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Userspace assumes vlan header is present at a given offset, but vlan
offload allows to store this in metadata fields of the skbuff. Hence
mangling vlan results in a garbled packet. Handle this transparently by
adding a parser to the kernel.

If vlan metadata is present and payload offset is over 12 bytes (source
and destination mac address fields), then subtract vlan header present
in vlan metadata, otherwise mangle vlan metadata based on offset and
length, extracting data from the source register.

This is similar to:

  8cfd23e67401 ("netfilter: nft_payload: work around vlan header stripping")

to deal with vlan payload mangling.

Fixes: 7ec3f7b47b8d ("netfilter: nft_payload: add packet mangling support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 72 +++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index a3cb5dbcb362..f97ee7645bd2 100644
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
+	u16 vlan_tci;
+
+	if (offset >= offsetof(struct vlan_ethhdr, h_vlan_encapsulated_proto)) {
+		*vlan_hlen = VLAN_HLEN;
+		return true;
+	}
+
+	switch (offset) {
+	case offsetof(struct vlan_ethhdr, h_vlan_proto):
+		if (len == 2) {
+			vlan_proto = nft_reg_load_be16(src);
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
+		vlan_tci = ntohs(nft_reg_load_be16(src));
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

