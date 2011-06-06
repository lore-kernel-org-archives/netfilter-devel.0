From: pablo@netfilter.org
Subject: [PATCH 5/7] netfilter: nf_nat: fix crash in nf_nat_csum
Date: Mon,  6 Jun 2011 02:11:38 +0200
Message-ID: <1307319100-21827-6-git-send-email-pablo@netfilter.org>
References: <1307319100-21827-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54943 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab1FFAMG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jun 2011 20:12:06 -0400
In-Reply-To: <1307319100-21827-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Julian Anastasov <ja@ssi.bg>

Fix crash in nf_nat_csum when mangling packets
in OUTPUT hook where skb->dev is not defined, it is set
later before POSTROUTING. Problem happens for CHECKSUM_NONE.
We can check device from rt but using CHECKSUM_PARTIAL
should be safe (skb_checksum_help).

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_nat_helper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_helper.c b/net/ipv4/netfilter/nf_nat_helper.c
index 99cfa28..ebc5f88 100644
--- a/net/ipv4/netfilter/nf_nat_helper.c
+++ b/net/ipv4/netfilter/nf_nat_helper.c
@@ -160,7 +160,7 @@ static void nf_nat_csum(struct sk_buff *skb, const struct iphdr *iph, void *data
 
 	if (skb->ip_summed != CHECKSUM_PARTIAL) {
 		if (!(rt->rt_flags & RTCF_LOCAL) &&
-		    skb->dev->features & NETIF_F_V4_CSUM) {
+		    (!skb->dev || skb->dev->features & NETIF_F_V4_CSUM)) {
 			skb->ip_summed = CHECKSUM_PARTIAL;
 			skb->csum_start = skb_headroom(skb) +
 					  skb_network_offset(skb) +
-- 
1.7.2.5

