From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable] netfilter: ip6t_SYNPROXY: fix NULL pointer dereference
Date: Mon, 14 Dec 2015 13:17:16 +0100
Message-ID: <1450095436-24855-6-git-send-email-pablo@netfilter.org>
References: <1450095436-24855-1-git-send-email-pablo@netfilter.org>
Cc: stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38464 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbbLNMR2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Dec 2015 07:17:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9D5092E4F4
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 13:17:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 93C7DDA814
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 13:17:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 173B9DA843
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 13:17:24 +0100 (CET)
In-Reply-To: <1450095436-24855-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Phil Sutter <phil@nwl.cc>

[ upstream commit 96fffb4f23f124f297d51dedc9cf51d19eb88ee1 ]

This happens when networking namespaces are enabled.

Cc: <stable@vger.kernel.org> # 3.12.x
Cc: <stable@vger.kernel.org> # 3.14.x
Cc: <stable@vger.kernel.org> # 3.18.x
Cc: <stable@vger.kernel.org> # 4.1.x
Suggested-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Phil Sutter <phil@nwl.cc>
Acked-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/ip6t_SYNPROXY.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index 6edb7b1..bcebc24 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -37,12 +37,13 @@ synproxy_build_ip(struct sk_buff *skb, const struct in6_addr *saddr,
 }
 
 static void
-synproxy_send_tcp(const struct sk_buff *skb, struct sk_buff *nskb,
+synproxy_send_tcp(const struct synproxy_net *snet,
+		  const struct sk_buff *skb, struct sk_buff *nskb,
 		  struct nf_conntrack *nfct, enum ip_conntrack_info ctinfo,
 		  struct ipv6hdr *niph, struct tcphdr *nth,
 		  unsigned int tcp_hdr_size)
 {
-	struct net *net = nf_ct_net((struct nf_conn *)nfct);
+	struct net *net = nf_ct_net(snet->tmpl);
 	struct dst_entry *dst;
 	struct flowi6 fl6;
 
@@ -83,7 +84,8 @@ free_nskb:
 }
 
 static void
-synproxy_send_client_synack(const struct sk_buff *skb, const struct tcphdr *th,
+synproxy_send_client_synack(const struct synproxy_net *snet,
+			    const struct sk_buff *skb, const struct tcphdr *th,
 			    const struct synproxy_options *opts)
 {
 	struct sk_buff *nskb;
@@ -119,7 +121,7 @@ synproxy_send_client_synack(const struct sk_buff *skb, const struct tcphdr *th,
 
 	synproxy_build_options(nth, opts);
 
-	synproxy_send_tcp(skb, nskb, skb->nfct, IP_CT_ESTABLISHED_REPLY,
+	synproxy_send_tcp(snet, skb, nskb, skb->nfct, IP_CT_ESTABLISHED_REPLY,
 			  niph, nth, tcp_hdr_size);
 }
 
@@ -163,7 +165,7 @@ synproxy_send_server_syn(const struct synproxy_net *snet,
 
 	synproxy_build_options(nth, opts);
 
-	synproxy_send_tcp(skb, nskb, &snet->tmpl->ct_general, IP_CT_NEW,
+	synproxy_send_tcp(snet, skb, nskb, &snet->tmpl->ct_general, IP_CT_NEW,
 			  niph, nth, tcp_hdr_size);
 }
 
@@ -203,7 +205,7 @@ synproxy_send_server_ack(const struct synproxy_net *snet,
 
 	synproxy_build_options(nth, opts);
 
-	synproxy_send_tcp(skb, nskb, NULL, 0, niph, nth, tcp_hdr_size);
+	synproxy_send_tcp(snet, skb, nskb, NULL, 0, niph, nth, tcp_hdr_size);
 }
 
 static void
@@ -241,7 +243,7 @@ synproxy_send_client_ack(const struct synproxy_net *snet,
 
 	synproxy_build_options(nth, opts);
 
-	synproxy_send_tcp(skb, nskb, NULL, 0, niph, nth, tcp_hdr_size);
+	synproxy_send_tcp(snet, skb, nskb, NULL, 0, niph, nth, tcp_hdr_size);
 }
 
 static bool
@@ -301,7 +303,7 @@ synproxy_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 					  XT_SYNPROXY_OPT_SACK_PERM |
 					  XT_SYNPROXY_OPT_ECN);
 
-		synproxy_send_client_synack(skb, th, &opts);
+		synproxy_send_client_synack(snet, skb, th, &opts);
 		return NF_DROP;
 
 	} else if (th->ack && !(th->fin || th->rst || th->syn)) {
-- 
2.1.4

