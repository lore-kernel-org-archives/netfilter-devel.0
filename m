From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/6] netfilter: xt_TEE: have cloned packet travel through Xtables too
Date: Wed,  7 Apr 2010 20:50:15 +0200
Message-ID: <1270666217-27670-6-git-send-email-jengelh@medozas.de>
References: <1270666217-27670-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50602 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757072Ab0DGSud (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Apr 2010 14:50:33 -0400
In-Reply-To: <1270666217-27670-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since Xtables is now reentrant/nestable, the cloned packet can also go
through Xtables and be subject to rules itself.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/ip_output.c   |    1 -
 net/ipv6/ip6_output.c  |    1 -
 net/netfilter/xt_TEE.c |   39 ++++++++++++++++++---------------------
 3 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 0abfdde..f09135e 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -309,7 +309,6 @@ int ip_output(struct sk_buff *skb)
 			    ip_finish_output,
 			    !(IPCB(skb)->flags & IPSKB_REROUTED));
 }
-EXPORT_SYMBOL_GPL(ip_output);
 
 int ip_queue_xmit(struct sk_buff *skb, int ipfragok)
 {
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 307d8bf..7e10f62 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -176,7 +176,6 @@ int ip6_output(struct sk_buff *skb)
 			    ip6_finish_output,
 			    !(IP6CB(skb)->flags & IPSKB_REROUTED));
 }
-EXPORT_SYMBOL_GPL(ip6_output);
 
 /*
  *	xmit an sk_buff (used by TCP)
diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index 79c5bf9..0bdcab4 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -33,6 +33,7 @@ static struct nf_conn tee_track;
 #endif
 
 static const union nf_inet_addr tee_zero_address;
+static bool tee_active[NR_CPUS];
 
 static bool
 tee_tg_route4(struct sk_buff *skb, const struct xt_tee_tginfo *info)
@@ -61,15 +62,18 @@ static unsigned int
 tee_tg4(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	const struct xt_tee_tginfo *info = par->targinfo;
+	unsigned int cpu = smp_processor_id();
 	struct iphdr *iph;
 
+	if (tee_active[cpu])
+		return XT_CONTINUE;
 	/*
 	 * Copy the skb, and route the copy. Will later return %XT_CONTINUE for
 	 * the original skb, which should continue on its way as if nothing has
 	 * happened. The copy should be independently delivered to the TEE
 	 * --gateway.
 	 */
-	skb = skb_copy(skb, GFP_ATOMIC);
+	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (skb == NULL)
 		return XT_CONTINUE;
 
@@ -96,22 +100,11 @@ tee_tg4(struct sk_buff *skb, const struct xt_target_param *par)
 		--iph->ttl;
 	ip_send_check(iph);
 
-	/*
-	 * Xtables is not reentrant currently, so a choice has to be made:
-	 * 1. return absolute verdict for the original and let the cloned
-	 *    packet travel through the chains
-	 * 2. let the original continue travelling and not pass the clone
-	 *    to Xtables.
-	 * #2 is chosen. Normally, we would use ip_local_out for the clone.
-	 * Because iph->check is already correct and we don't pass it to
-	 * Xtables anyway, a shortcut to dst_output [forwards to ip_output] can
-	 * be taken. %IPSKB_REROUTED needs to be set so that ip_output does not
-	 * invoke POSTROUTING on the cloned packet.
-	 */
-	IPCB(skb)->flags |= IPSKB_REROUTED;
-	if (tee_tg_route4(skb, info))
-		ip_output(skb);
-
+	if (tee_tg_route4(skb, info)) {
+		tee_active[cpu] = true;
+		ip_local_out(skb);
+		tee_active[cpu] = false;
+	}
 	return XT_CONTINUE;
 }
 
@@ -144,7 +137,10 @@ static unsigned int
 tee_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	const struct xt_tee_tginfo *info = par->targinfo;
+	unsigned int cpu = smp_processor_id();
 
+	if (tee_active[cpu])
+		return XT_CONTINUE;
 	if ((skb = skb_copy(skb, GFP_ATOMIC)) == NULL)
 		return XT_CONTINUE;
 
@@ -159,10 +155,11 @@ tee_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 		struct ipv6hdr *iph = ipv6_hdr(skb);
 		--iph->hop_limit;
 	}
-	IP6CB(skb)->flags |= IPSKB_REROUTED;
-	if (tee_tg_route6(skb, info))
-		ip6_output(skb);
-
+	if (tee_tg_route6(skb, info)) {
+		tee_active[cpu] = true;
+		ip6_local_out(skb);
+		tee_active[cpu] = false;
+	}
 	return XT_CONTINUE;
 }
 #endif /* WITH_IPV6 */
-- 
1.7.0.2

