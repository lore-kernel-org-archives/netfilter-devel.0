From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 42/79: netns nf_conntrack: fixup DNAT in netns
Date: Wed,  8 Oct 2008 12:47:18 +0200 (MEST)
Message-ID: <20081008104717.10423.9260.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45992 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbYJHKrT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:19 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 9174c1538fffbb5dddab99563eac6b3d8b212277
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Wed Oct 8 11:35:11 2008 +0200

    netfilter: netns nf_conntrack: fixup DNAT in netns
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index 0a02a8c..f929352 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -91,13 +91,13 @@ static unsigned int ipt_snat_target(struct sk_buff *skb,
 }
 
 /* Before 2.6.11 we did implicit source NAT if required. Warn about change. */
-static void warn_if_extra_mangle(__be32 dstip, __be32 srcip)
+static void warn_if_extra_mangle(struct net *net, __be32 dstip, __be32 srcip)
 {
 	static int warned = 0;
 	struct flowi fl = { .nl_u = { .ip4_u = { .daddr = dstip } } };
 	struct rtable *rt;
 
-	if (ip_route_output_key(&init_net, &rt, &fl) != 0)
+	if (ip_route_output_key(net, &rt, &fl) != 0)
 		return;
 
 	if (rt->rt_src != srcip && !warned) {
@@ -130,7 +130,7 @@ static unsigned int ipt_dnat_target(struct sk_buff *skb,
 
 	if (hooknum == NF_INET_LOCAL_OUT &&
 	    mr->range[0].flags & IP_NAT_RANGE_MAP_IPS)
-		warn_if_extra_mangle(ip_hdr(skb)->daddr,
+		warn_if_extra_mangle(dev_net(out), ip_hdr(skb)->daddr,
 				     mr->range[0].min_ip);
 
 	return nf_nat_setup_info(ct, &mr->range[0], IP_NAT_MANIP_DST);
