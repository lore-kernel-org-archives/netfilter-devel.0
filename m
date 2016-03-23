From: Liping Zhang <zlpwmdx@163.com>
Subject: [PATCH] netfilter: ip6t_SYNPROXY: remove magic number
Date: Wed, 23 Mar 2016 22:29:16 +0800
Message-ID: <1458743356-4045-1-git-send-email-zlpwmdx@163.com>
Cc: Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org, kaber@trash.net, davem@davemloft.net,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:32880 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbcCWOaH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Mar 2016 10:30:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Replace '64' with the per-net ipv6_devconf_all's hop_limit when
building the ipv6 header.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/ipv6/netfilter/ip6t_SYNPROXY.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index 3deed58..b99314a 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -20,15 +20,16 @@
 #include <net/netfilter/nf_conntrack_synproxy.h>
 
 static struct ipv6hdr *
-synproxy_build_ip(struct sk_buff *skb, const struct in6_addr *saddr,
-				       const struct in6_addr *daddr)
+synproxy_build_ip(struct net *net, struct sk_buff *skb,
+		  const struct in6_addr *saddr,
+		  const struct in6_addr *daddr)
 {
 	struct ipv6hdr *iph;
 
 	skb_reset_network_header(skb);
 	iph = (struct ipv6hdr *)skb_put(skb, sizeof(*iph));
 	ip6_flow_hdr(iph, 0, 0);
-	iph->hop_limit	= 64;	//XXX
+	iph->hop_limit	= net->ipv6.devconf_all->hop_limit;
 	iph->nexthdr	= IPPROTO_TCP;
 	iph->saddr	= *saddr;
 	iph->daddr	= *daddr;
@@ -103,7 +104,8 @@ synproxy_send_client_synack(const struct synproxy_net *snet,
 		return;
 	skb_reserve(nskb, MAX_TCP_HEADER);
 
-	niph = synproxy_build_ip(nskb, &iph->daddr, &iph->saddr);
+	niph = synproxy_build_ip(nf_ct_net(snet->tmpl), nskb, &iph->daddr,
+				 &iph->saddr);
 
 	skb_reset_transport_header(nskb);
 	nth = (struct tcphdr *)skb_put(nskb, tcp_hdr_size);
@@ -144,7 +146,8 @@ synproxy_send_server_syn(const struct synproxy_net *snet,
 		return;
 	skb_reserve(nskb, MAX_TCP_HEADER);
 
-	niph = synproxy_build_ip(nskb, &iph->saddr, &iph->daddr);
+	niph = synproxy_build_ip(nf_ct_net(snet->tmpl), nskb, &iph->saddr,
+				 &iph->daddr);
 
 	skb_reset_transport_header(nskb);
 	nth = (struct tcphdr *)skb_put(nskb, tcp_hdr_size);
@@ -189,7 +192,8 @@ synproxy_send_server_ack(const struct synproxy_net *snet,
 		return;
 	skb_reserve(nskb, MAX_TCP_HEADER);
 
-	niph = synproxy_build_ip(nskb, &iph->daddr, &iph->saddr);
+	niph = synproxy_build_ip(nf_ct_net(snet->tmpl), nskb, &iph->daddr,
+				 &iph->saddr);
 
 	skb_reset_transport_header(nskb);
 	nth = (struct tcphdr *)skb_put(nskb, tcp_hdr_size);
@@ -227,7 +231,8 @@ synproxy_send_client_ack(const struct synproxy_net *snet,
 		return;
 	skb_reserve(nskb, MAX_TCP_HEADER);
 
-	niph = synproxy_build_ip(nskb, &iph->saddr, &iph->daddr);
+	niph = synproxy_build_ip(nf_ct_net(snet->tmpl), nskb, &iph->saddr,
+				 &iph->daddr);
 
 	skb_reset_transport_header(nskb);
 	nth = (struct tcphdr *)skb_put(nskb, tcp_hdr_size);
-- 
1.7.9.5


