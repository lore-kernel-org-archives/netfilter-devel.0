From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH 12/15] br_netfilter: switch sysctls nf_call_iptables and nf_call_ip6tables
 to per-netns processing
Date: Sat, 10 May 2014 01:28:40 +0400
Message-ID: <536D4888.8040400@parallels.com>
References: <536A8054.90201@pandora.de> <cover.1399660706.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:6445 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757808AbaEIVa1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 May 2014 17:30:27 -0400
In-Reply-To: <cover.1399660706.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index dbf73cb..5043b1e 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -681,6 +681,7 @@ static unsigned int br_nf_pre_routing(const struct nf_hook_ops *ops,
 {
 	struct net_bridge_port *p;
 	struct net_bridge *br;
+	struct brnf_net *bn;
 	__u32 len = nf_bridge_encap_header_len(skb);
 
 	if (unlikely(!pskb_may_pull(skb, len)))
@@ -691,15 +692,16 @@ static unsigned int br_nf_pre_routing(const struct nf_hook_ops *ops,
 		return NF_DROP;
 	br = p->br;
 
+	bn = brnf_net(dev_net(skb->dev));
 	if (IS_IPV6(skb) || IS_VLAN_IPV6(skb) || IS_PPPOE_IPV6(skb)) {
-		if (!init_brnf_net.nf_call_ip6tables && !br->nf_call_ip6tables)
+		if (!bn->nf_call_ip6tables && !br->nf_call_ip6tables)
 			return NF_ACCEPT;
 
 		nf_bridge_pull_encap_header_rcsum(skb);
 		return br_nf_pre_routing_ipv6(ops, skb, in, out, okfn);
 	}
 
-	if (!init_brnf_net.nf_call_iptables && !br->nf_call_iptables)
+	if (!bn->nf_call_iptables && !br->nf_call_iptables)
 		return NF_ACCEPT;
 
 	if (!IS_IP(skb) && !IS_VLAN_IP(skb) && !IS_PPPOE_IP(skb))
@@ -1075,7 +1077,7 @@ static int brnf_sysctl_net_register(struct brnf_net *bn)
 		if (!table)
 			goto err_alloc;
 	}
-	for (i = 0; i < 1; i++)
+	for (i = 0; i < 3; i++)
 		table[i].data += (char *)bn - (char *)&init_brnf_net;
 
 	hdr = register_net_sysctl(bn->net, "net/bridge", table);
-- 
1.7.5.4

