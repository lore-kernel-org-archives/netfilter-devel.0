From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 15/18]: Call POST_ROUTING hook before fragmentation
Date: Thu,  5 Jan 2006 05:06:50 +0100 (MET)
Message-ID: <20060105040614.23512.36341.sendpatchset@localhost.localdomain>
References: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S. Miller <davem@davemloft.net>
In-Reply-To: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: Call POST_ROUTING hook before fragmentation

Call POST_ROUTING hook before fragmentation to get rid of the okfn use
in ip_refrag and save the useless fragmentation/defragmentation step
when NAT is used.

The patch introduces one user-visible change, the POSTROUTING chain
in the mangle table gets entire packets, not fragments, which should
simplify use of the MARK and CLASSIFY targets for queueing as a nice
side-effect.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 08d7c2719c70f5819768203f17db35934236469b
tree ba94685ebe63dd495ab0cb1cff120d1b3763b938
parent 512a75394473e444f2276a3f7fd2c131df5d67d2
author Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 03:16:21 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 03:16:21 +0100

 include/net/ip.h                               |    1 -
 net/ipv4/ip_output.c                           |   30 +++++++++++-------------
 net/ipv4/netfilter/ip_conntrack_standalone.c   |   26 +--------------------
 net/ipv4/netfilter/ip_nat_standalone.c         |   17 --------------
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   26 +--------------------
 5 files changed, 16 insertions(+), 84 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index f7e7fd7..7bb5804 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -317,7 +317,6 @@ enum ip_defrag_users
 	IP_DEFRAG_CALL_RA_CHAIN,
 	IP_DEFRAG_CONNTRACK_IN,
 	IP_DEFRAG_CONNTRACK_OUT,
-	IP_DEFRAG_NAT_OUT,
 	IP_DEFRAG_VS_IN,
 	IP_DEFRAG_VS_OUT,
 	IP_DEFRAG_VS_FWD
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 2a830de..71da318 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -202,13 +202,11 @@ static inline int ip_finish_output2(stru
 
 static inline int ip_finish_output(struct sk_buff *skb)
 {
-	struct net_device *dev = skb->dst->dev;
-
-	skb->dev = dev;
-	skb->protocol = htons(ETH_P_IP);
-
-	return NF_HOOK(PF_INET, NF_IP_POST_ROUTING, skb, NULL, dev,
-		       ip_finish_output2);
+	if (skb->len > dst_mtu(skb->dst) &&
+	    !(skb_shinfo(skb)->ufo_size || skb_shinfo(skb)->tso_size))
+		return ip_fragment(skb, ip_finish_output2);
+	else
+		return ip_finish_output2(skb);
 }
 
 int ip_mc_output(struct sk_buff *skb)
@@ -265,21 +263,21 @@ int ip_mc_output(struct sk_buff *skb)
 				newskb->dev, ip_dev_loopback_xmit);
 	}
 
-	if (skb->len > dst_mtu(&rt->u.dst))
-		return ip_fragment(skb, ip_finish_output);
-	else
-		return ip_finish_output(skb);
+	return NF_HOOK(PF_INET, NF_IP_POST_ROUTING, skb, NULL, skb->dev,
+		       ip_finish_output);
 }
 
 int ip_output(struct sk_buff *skb)
 {
+	struct net_device *dev = skb->dst->dev;
+
 	IP_INC_STATS(IPSTATS_MIB_OUTREQUESTS);
 
-	if (skb->len > dst_mtu(skb->dst) &&
-		!(skb_shinfo(skb)->ufo_size || skb_shinfo(skb)->tso_size))
-		return ip_fragment(skb, ip_finish_output);
-	else
-		return ip_finish_output(skb);
+	skb->dev = dev;
+	skb->protocol = htons(ETH_P_IP);
+
+	return NF_HOOK(PF_INET, NF_IP_POST_ROUTING, skb, NULL, dev,
+		       ip_finish_output);
 }
 
 int ip_queue_xmit(struct sk_buff *skb, int ipfragok)
diff --git a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
index a88bcc5..7ba9778 100644
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c
@@ -451,30 +451,6 @@ static unsigned int ip_conntrack_defrag(
 	return NF_ACCEPT;
 }
 
-static unsigned int ip_refrag(unsigned int hooknum,
-			      struct sk_buff **pskb,
-			      const struct net_device *in,
-			      const struct net_device *out,
-			      int (*okfn)(struct sk_buff *))
-{
-	struct rtable *rt = (struct rtable *)(*pskb)->dst;
-
-	/* We've seen it coming out the other side: confirm */
-	if (ip_confirm(hooknum, pskb, in, out, okfn) != NF_ACCEPT)
-		return NF_DROP;
-
-	/* Local packets are never produced too large for their
-	   interface.  We degfragment them at LOCAL_OUT, however,
-	   so we have to refragment them here. */
-	if ((*pskb)->len > dst_mtu(&rt->u.dst) &&
-	    !skb_shinfo(*pskb)->tso_size) {
-		/* No hook can be after us, so this should be OK. */
-		ip_fragment(*pskb, okfn);
-		return NF_STOLEN;
-	}
-	return NF_ACCEPT;
-}
-
 static unsigned int ip_conntrack_local(unsigned int hooknum,
 				       struct sk_buff **pskb,
 				       const struct net_device *in,
@@ -544,7 +520,7 @@ static struct nf_hook_ops ip_conntrack_h
 
 /* Refragmenter; last chance. */
 static struct nf_hook_ops ip_conntrack_out_ops = {
-	.hook		= ip_refrag,
+	.hook		= ip_confirm,
 	.owner		= THIS_MODULE,
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_POST_ROUTING,
diff --git a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
index 30cd4e1..f04111f 100644
--- a/net/ipv4/netfilter/ip_nat_standalone.c
+++ b/net/ipv4/netfilter/ip_nat_standalone.c
@@ -190,23 +190,6 @@ ip_nat_out(unsigned int hooknum,
 	    || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr))
 		return NF_ACCEPT;
 
-	/* We can hit fragment here; forwarded packets get
-	   defragmented by connection tracking coming in, then
-	   fragmented (grr) by the forward code.
-
-	   In future: If we have nfct != NULL, AND we have NAT
-	   initialized, AND there is no helper, then we can do full
-	   NAPT on the head, and IP-address-only NAT on the rest.
-
-	   I'm starting to have nightmares about fragments.  */
-
-	if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
-		*pskb = ip_ct_gather_frags(*pskb, IP_DEFRAG_NAT_OUT);
-
-		if (!*pskb)
-			return NF_STOLEN;
-	}
-
 	return ip_nat_fn(hooknum, pskb, in, out, okfn);
 }
 
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 80d30d7..9bdbb77 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -181,30 +181,6 @@ static unsigned int ipv4_conntrack_defra
 	return NF_ACCEPT;
 }
 
-static unsigned int ipv4_refrag(unsigned int hooknum,
-				struct sk_buff **pskb,
-				const struct net_device *in,
-				const struct net_device *out,
-				int (*okfn)(struct sk_buff *))
-{
-	struct rtable *rt = (struct rtable *)(*pskb)->dst;
-
-	/* We've seen it coming out the other side: confirm */
-	if (ipv4_confirm(hooknum, pskb, in, out, okfn) != NF_ACCEPT)
-		return NF_DROP;
-
-	/* Local packets are never produced too large for their
-	   interface.  We degfragment them at LOCAL_OUT, however,
-	   so we have to refragment them here. */
-	if ((*pskb)->len > dst_mtu(&rt->u.dst) &&
-	    !skb_shinfo(*pskb)->tso_size) {
-		/* No hook can be after us, so this should be OK. */
-		ip_fragment(*pskb, okfn);
-		return NF_STOLEN;
-	}
-	return NF_ACCEPT;
-}
-
 static unsigned int ipv4_conntrack_in(unsigned int hooknum,
 				      struct sk_buff **pskb,
 				      const struct net_device *in,
@@ -284,7 +260,7 @@ static struct nf_hook_ops ipv4_conntrack
 
 /* Refragmenter; last chance. */
 static struct nf_hook_ops ipv4_conntrack_out_ops = {
-	.hook		= ipv4_refrag,
+	.hook		= ipv4_confirm,
 	.owner		= THIS_MODULE,
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_POST_ROUTING,
