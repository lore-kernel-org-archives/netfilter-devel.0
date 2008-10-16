From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: fix arptable_filter wrong hook registering
Date: Wed, 15 Oct 2008 21:41:39 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810152126380.28060@fbirervta.pbzchgretzou.qr>
References: <20081016012451.6126.34071.stgit@Decadence>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53222 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbYJPBlm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 21:41:42 -0400
In-Reply-To: <20081016012451.6126.34071.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-10-15 21:24, Pablo Neira Ayuso wrote:

>This patch replaces NFPROTO_ARP by NF_ARP in the hooks registered
>by arptable_filter, otherwise the arptables tool does not work.
>Thus, we use NF_ARP to register ARP hooks to match the NF_HOOK
>invocation in net/ipv4/arp.c and NFPROTO_ARP for internal xtables
>handling, ie. matches, targets and tables.

This does not fly. You are essentially trying to register
arpt_in_hook for NFPROTO_UNSPEC, since NF_ARP == 0, and
0 == NFPROTO_UNSPEC.


Define "does not work". Do you mean arptables sees no packets?
Perhaps the following helps?


commit 60318cc486d15253b5ffc39b662a329f7e8f73b4
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 15 21:31:21 2008 -0400

netfilter: replace old NF_ARP calls with NFPROTO_ARP

(Supplements: ee999d8b9573df1b547aacdc6d79f86eb79c25cd)

NFPROTO_ARP actually has a different value from NF_ARP, so ensure all
callers use the new value so that packets _do_ get delivered to the
registered hooks.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/bridge/br_netfilter.c  |    2 +-
 net/ipv4/arp.c             |    4 ++--
 net/netfilter/xt_NFQUEUE.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index a4abed5..fa5cda4 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -719,7 +719,7 @@ static unsigned int br_nf_forward_arp(unsigned int hook, struct sk_buff *skb,
 		return NF_ACCEPT;
 	}
 	*d = (struct net_device *)in;
-	NF_HOOK(NF_ARP, NF_ARP_FORWARD, skb, (struct net_device *)in,
+	NF_HOOK(NFPROTO_ARP, NF_ARP_FORWARD, skb, (struct net_device *)in,
 		(struct net_device *)out, br_nf_forward_finish);
 
 	return NF_STOLEN;
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index b043eda..1a9dd66 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -663,7 +663,7 @@ out:
 void arp_xmit(struct sk_buff *skb)
 {
 	/* Send it off, maybe filter it using firewalling first.  */
-	NF_HOOK(NF_ARP, NF_ARP_OUT, skb, NULL, skb->dev, dev_queue_xmit);
+	NF_HOOK(NFPROTO_ARP, NF_ARP_OUT, skb, NULL, skb->dev, dev_queue_xmit);
 }
 
 /*
@@ -928,7 +928,7 @@ static int arp_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	memset(NEIGH_CB(skb), 0, sizeof(struct neighbour_cb));
 
-	return NF_HOOK(NF_ARP, NF_ARP_IN, skb, dev, NULL, arp_process);
+	return NF_HOOK(NFPROTO_ARP, NF_ARP_IN, skb, dev, NULL, arp_process);
 
 freeskb:
 	kfree_skb(skb);
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index 2cc1fff..f9977b3 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -48,7 +48,7 @@ static struct xt_target nfqueue_tg_reg[] __read_mostly = {
 	},
 	{
 		.name		= "NFQUEUE",
-		.family		= NF_ARP,
+		.family		= NFPROTO_ARP,
 		.target		= nfqueue_tg,
 		.targetsize	= sizeof(struct xt_NFQ_info),
 		.me		= THIS_MODULE,
