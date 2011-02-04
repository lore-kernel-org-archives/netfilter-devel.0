From: Simon Horman <horms@verge.net.au>
Subject: [PATCH 03/14] IPVS: Add sysctl_nat_icmp_send()
Date: Fri,  4 Feb 2011 18:46:11 +0900
Message-ID: <1296812782-14953-4-git-send-email-horms@verge.net.au>
References: <1296812782-14953-1-git-send-email-horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>,
	Hans Schillstrom <hans@schillstrom.com>,
	Simon Horman <horms@verge.net.au>
To: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, lvs-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:34738 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab1BDJqf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 04:46:35 -0500
In-Reply-To: <1296812782-14953-1-git-send-email-horms@verge.net.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In preparation for not including sysctl_nat_icmp_send in
struct netns_ipvs when CONFIG_SYCTL is not defined.

Signed-off-by: Simon Horman <horms@verge.net.au>
---
 net/netfilter/ipvs/ip_vs_core.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 3abc009..66bb68b 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -607,9 +607,16 @@ static int sysctl_snat_reroute(struct sk_buff *skb)
 	return ipvs->sysctl_snat_reroute;
 }
 
+static int sysctl_nat_icmp_send(struct net *net)
+{
+	struct netns_ipvs *ipvs = net_ipvs(net);
+	return ipvs->sysctl_nat_icmp_send;
+}
+
 #else
 
 static int sysctl_snat_reroute(struct sk_buff *skb) { return 0; }
+static int sysctl_nat_icmp_send(struct net *net) { return 0; }
 
 #endif
 
@@ -1075,7 +1082,6 @@ ip_vs_out(unsigned int hooknum, struct sk_buff *skb, int af)
 	struct ip_vs_protocol *pp;
 	struct ip_vs_proto_data *pd;
 	struct ip_vs_conn *cp;
-	struct netns_ipvs *ipvs;
 
 	EnterFunction(11);
 
@@ -1150,11 +1156,10 @@ ip_vs_out(unsigned int hooknum, struct sk_buff *skb, int af)
 	 * Check if the packet belongs to an existing entry
 	 */
 	cp = pp->conn_out_get(af, skb, &iph, iph.len, 0);
-	ipvs = net_ipvs(net);
 
 	if (likely(cp))
 		return handle_response(af, skb, pd, cp, iph.len);
-	if (ipvs->sysctl_nat_icmp_send &&
+	if (sysctl_nat_icmp_send(net) &&
 	    (pp->protocol == IPPROTO_TCP ||
 	     pp->protocol == IPPROTO_UDP ||
 	     pp->protocol == IPPROTO_SCTP)) {
-- 
1.7.2.3

