From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: rpfilter: bypass ipv4 lbcast packets with zeronet source
Date: Sat,  3 Dec 2016 21:25:08 +0800
Message-ID: <1480771508-4429-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:34919 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751481AbcLCN0m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Dec 2016 08:26:42 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Otherwise, DHCP Discover packets(0.0.0.0->255.255.255.255) may be
dropped incorrectly.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/ipv4/netfilter/ipt_rpfilter.c |  8 +++++---
 net/ipv4/netfilter/nft_fib_ipv4.c | 13 +++++++------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index 59b4994..f273098 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -83,10 +83,12 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		return true ^ invert;
 
 	iph = ip_hdr(skb);
-	if (ipv4_is_multicast(iph->daddr)) {
-		if (ipv4_is_zeronet(iph->saddr))
-			return ipv4_is_local_multicast(iph->daddr) ^ invert;
+	if (ipv4_is_zeronet(iph->saddr)) {
+		if (ipv4_is_lbcast(iph->daddr) ||
+		    ipv4_is_local_multicast(iph->daddr))
+			return true ^ invert;
 	}
+
 	flow.flowi4_iif = LOOPBACK_IFINDEX;
 	flow.daddr = iph->saddr;
 	flow.saddr = rpfilter_get_saddr(iph->daddr);
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 2581363..965b1a1 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -101,12 +101,13 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	}
 
 	iph = ip_hdr(pkt->skb);
-	if (ipv4_is_multicast(iph->daddr) &&
-	    ipv4_is_zeronet(iph->saddr) &&
-	    ipv4_is_local_multicast(iph->daddr)) {
-		nft_fib_store_result(dest, priv->result, pkt,
-				     get_ifindex(pkt->skb->dev));
-		return;
+	if (ipv4_is_zeronet(iph->saddr)) {
+		if (ipv4_is_lbcast(iph->daddr) ||
+		    ipv4_is_local_multicast(iph->daddr)) {
+			nft_fib_store_result(dest, priv->result, pkt,
+					     get_ifindex(pkt->skb->dev));
+			return;
+		}
 	}
 
 	if (priv->flags & NFTA_FIB_F_MARK)
-- 
2.5.5


