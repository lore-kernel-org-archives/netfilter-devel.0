Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DCF91396
	for <netfilter-devel@vger.kernel.org>; Fri, 10 May 2024 00:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715299654; cv=none; b=c6CEUZcHML3KHumf7QfwYdDyZEboWpEyHlmROkIUF97Z6YBfKA3dzXcpbHnwBY+jW96WONqyVCuNw9I144D5EYPMBj/CH5F3q9esL6hZtPYhzTM7VjpdtqOVp0m1Ww0zQZ0BzraHhfOMyj/0vAlCe+JfNl8W7NMZ4gxERQ8yU+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715299654; c=relaxed/simple;
	bh=Kl1hatbDvoPkE+SV3b9o2dQqQtjDw7GjY6QaOqy2HT8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sQYnE+s8zTkZ+oocjMB3y/r2i08vRkBOOFoWx1g8ufvt5uzzE5ALyAz94qHMeJ8/5KzzElN/CBCUqReptRN2nFj5qFvn2LTKx552fr5/CaWd//rxA94O9I9FKWtcsfv9ueBoxoQP5DuAFXfWtNd+6LuNoCs8uIILv9P1d6b0YlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/2] netfilter: nft_payload: restore vlan q-in-q match support
Date: Fri, 10 May 2024 02:07:18 +0200
Message-Id: <20240510000719.3205-2-pablo@netfilter.org>
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

Revert f6ae9f120dad ("netfilter: nft_payload: add C-VLAN support").

f41f72d09ee1 ("netfilter: nft_payload: simplify vlan header handling")
already allows to match on inner vlan tags by subtract the vlan header
size to the payload offset which has been popped and stored in skbuff
metadata fields.

Fixes: f6ae9f120dad ("netfilter: nft_payload: add C-VLAN support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 0a689c8e0295..a3cb5dbcb362 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -45,36 +45,27 @@ nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
 	int mac_off = skb_mac_header(skb) - skb->data;
 	u8 *vlanh, *dst_u8 = (u8 *) d;
 	struct vlan_ethhdr veth;
-	u8 vlan_hlen = 0;
-
-	if ((skb->protocol == htons(ETH_P_8021AD) ||
-	     skb->protocol == htons(ETH_P_8021Q)) &&
-	    offset >= VLAN_ETH_HLEN && offset < VLAN_ETH_HLEN + VLAN_HLEN)
-		vlan_hlen += VLAN_HLEN;
 
 	vlanh = (u8 *) &veth;
-	if (offset < VLAN_ETH_HLEN + vlan_hlen) {
+	if (offset < VLAN_ETH_HLEN) {
 		u8 ethlen = len;
 
-		if (vlan_hlen &&
-		    skb_copy_bits(skb, mac_off, &veth, VLAN_ETH_HLEN) < 0)
-			return false;
-		else if (!nft_payload_rebuild_vlan_hdr(skb, mac_off, &veth))
+		if (!nft_payload_rebuild_vlan_hdr(skb, mac_off, &veth))
 			return false;
 
-		if (offset + len > VLAN_ETH_HLEN + vlan_hlen)
-			ethlen -= offset + len - VLAN_ETH_HLEN - vlan_hlen;
+		if (offset + len > VLAN_ETH_HLEN)
+			ethlen -= offset + len - VLAN_ETH_HLEN;
 
-		memcpy(dst_u8, vlanh + offset - vlan_hlen, ethlen);
+		memcpy(dst_u8, vlanh + offset, ethlen);
 
 		len -= ethlen;
 		if (len == 0)
 			return true;
 
 		dst_u8 += ethlen;
-		offset = ETH_HLEN + vlan_hlen;
+		offset = ETH_HLEN;
 	} else {
-		offset -= VLAN_HLEN + vlan_hlen;
+		offset -= VLAN_HLEN;
 	}
 
 	return skb_copy_bits(skb, offset + mac_off, dst_u8, len) == 0;
-- 
2.30.2

