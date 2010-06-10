From: Shan Wei <shanwei@cn.fujitsu.com>
Subject: [PATCH] netfilter: kill redundant check code in which setting ip_summed
 value
Date: Thu, 10 Jun 2010 16:14:37 +0800
Message-ID: <4C109EED.2000405@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57612 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab0FJIOf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jun 2010 04:14:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the returned csum value is 0, We has set ip_summed with CHECKSUM_UNNECESSARY flag
in __skb_checksum_complete_head(), 

So this patch kills the check and changes to return to upper caller directly.

Signed-off-by: Shan Wei<shanwei@cn.fujitsu.com>
---
 net/ipv4/netfilter.c |    4 +---
 net/ipv6/netfilter.c |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 07de855..acd1ea8 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -212,9 +212,7 @@ static __sum16 nf_ip_checksum_partial(struct sk_buff *skb, unsigned int hook,
 		skb->csum = csum_tcpudp_nofold(iph->saddr, iph->daddr, protocol,
 					       skb->len - dataoff, 0);
 		skb->ip_summed = CHECKSUM_NONE;
-		csum = __skb_checksum_complete_head(skb, dataoff + len);
-		if (!csum)
-			skb->ip_summed = CHECKSUM_UNNECESSARY;
+		return __skb_checksum_complete_head(skb, dataoff + len);
 	}
 	return csum;
 }
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index a74951c..7155b24 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -151,9 +151,7 @@ static __sum16 nf_ip6_checksum_partial(struct sk_buff *skb, unsigned int hook,
 							 protocol,
 							 csum_sub(0, hsum)));
 		skb->ip_summed = CHECKSUM_NONE;
-		csum = __skb_checksum_complete_head(skb, dataoff + len);
-		if (!csum)
-			skb->ip_summed = CHECKSUM_UNNECESSARY;
+		return __skb_checksum_complete_head(skb, dataoff + len);
 	}
 	return csum;
 };
-- 
1.6.3.3

