Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E17C3BF68F;
	Thu, 16 Apr 2026 13:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776345314; cv=none; b=i2fwnFb9WCDU8yIvAWez62t1ngjiGMn2M+wtgoj2PDkrNkyfu0IQfhyucVRNIhs/io+ZUzQ4sAE4mPqGMcsSBku7Of/hKwoaVEZ98T1nJ1yUx+/YNy46v/PHuuuZ4zlZJOCwetjwSQ4zN0INyt8uYiMOgYnvMzpkLYkJUVYhFSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776345314; c=relaxed/simple;
	bh=K3jCvsals8BPY7qGgU/izMTL7eFMYcpuqpfYf5bWk6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fP1ZYr364hVeFZqvYueZ2iJiFIa9qhEEqAzNnMm4trtNVGCVYgP30utedD33OYMa+5vJao5bsNZPOMNk/i2Kk6c/x0dORkLkwGe+xVFDctzxgLx9Ab8s6BWPIqr32CKtrT3Fvjzad5jutvoW1w/+KGDND3BnlBSPxv55zPVKaIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JnKpWhU4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JnKpWhU4"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 31FA160177;
	Thu, 16 Apr 2026 15:15:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776345311;
	bh=fkRYP2uZVZjeOQ1Q6YgYeZAja49M92t1g5wZ2mqC/nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JnKpWhU4bus84SpADQ/4rc5FznTivDPkz3xaavLN07iuZeef2KgyMdQ/bIivrbxD6
	 oM4+H0CP9SWWuzHbaHf5OF+0nxF3syy/zohpm6wcB9t3hM0QTDEnoTfZ1d/KrkFLNr
	 ljh7RxurnbF/j6aLjNMPrHnD3H5s+ktrGdrrGCrBVArLdTOjOSbVM3vqMpTQrTcqM/
	 wq8vpT4skwCs6Mk2WO2hk4gq4Rnk6IIsLbv7m6z0PNneof6teo7wHfhd8EBTNCmGcD
	 YmkZ6sM6eFZxZ/0G0mh3Ssqit+v+f0ZHIzerxfJJk6P3nBBMIsmZUa7Dr4ykGD8pka
	 S4IXfzgYiWPlg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 08/11] ipvs: fix MTU check for GSO packets in tunnel mode
Date: Thu, 16 Apr 2026 15:14:50 +0200
Message-ID: <20260416131453.308611-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260416131453.308611-1-pablo@netfilter.org>
References: <20260416131453.308611-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yingnan Zhang <342144303@qq.com>

Currently, IPVS skips MTU checks for GSO packets by excluding them with
the !skb_is_gso(skb) condition. This creates problems when IPVS tunnel
mode encapsulates GSO packets with IPIP headers.

The issue manifests in two ways:

1. MTU violation after encapsulation:
   When a GSO packet passes through IPVS tunnel mode, the original MTU
   check is bypassed. After adding the IPIP tunnel header, the packet
   size may exceed the outgoing interface MTU, leading to unexpected
   fragmentation at the IP layer.

2. Fragmentation with problematic IP IDs:
   When net.ipv4.vs.pmtu_disc=1 and a GSO packet with multiple segments
   is fragmented after encapsulation, each segment gets a sequentially
   incremented IP ID (0, 1, 2, ...). This happens because:

   a) The GSO packet bypasses MTU check and gets encapsulated
   b) At __ip_finish_output, the oversized GSO packet is split into
      separate SKBs (one per segment), with IP IDs incrementing
   c) Each SKB is then fragmented again based on the actual MTU

   This sequential IP ID allocation differs from the expected behavior
   and can cause issues with fragment reassembly and packet tracking.

Fix this by properly validating GSO packets using
skb_gso_validate_network_len(). This function correctly validates
whether the GSO segments will fit within the MTU after segmentation. If
validation fails, send an ICMP Fragmentation Needed message to enable
proper PMTU discovery.

Fixes: 4cdd34084d53 ("netfilter: nf_conntrack_ipv6: improve fragmentation handling")
Signed-off-by: Yingnan Zhang <342144303@qq.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_xmit.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 3601eb86d025..7c570f48ade2 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -102,6 +102,18 @@ __ip_vs_dst_check(struct ip_vs_dest *dest)
 	return dest_dst;
 }
 
+/* Based on ip_exceeds_mtu(). */
+static bool ip_vs_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
+{
+	if (skb->len <= mtu)
+		return false;
+
+	if (skb_is_gso(skb) && skb_gso_validate_network_len(skb, mtu))
+		return false;
+
+	return true;
+}
+
 static inline bool
 __mtu_check_toobig_v6(const struct sk_buff *skb, u32 mtu)
 {
@@ -111,10 +123,9 @@ __mtu_check_toobig_v6(const struct sk_buff *skb, u32 mtu)
 		 */
 		if (IP6CB(skb)->frag_max_size > mtu)
 			return true; /* largest fragment violate MTU */
-	}
-	else if (skb->len > mtu && !skb_is_gso(skb)) {
+	} else if (ip_vs_exceeds_mtu(skb, mtu))
 		return true; /* Packet size violate MTU size */
-	}
+
 	return false;
 }
 
@@ -232,7 +243,7 @@ static inline bool ensure_mtu_is_adequate(struct netns_ipvs *ipvs, int skb_af,
 			return true;
 
 		if (unlikely(ip_hdr(skb)->frag_off & htons(IP_DF) &&
-			     skb->len > mtu && !skb_is_gso(skb) &&
+			     ip_vs_exceeds_mtu(skb, mtu) &&
 			     !ip_vs_iph_icmp(ipvsh))) {
 			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 				  htonl(mtu));
-- 
2.47.3

