From: Liping Zhang <zlpwmdx@163.com>
Subject: [PATCH V2] netfilter: ip6t_SYNPROXY: remove magic number
Date: Mon, 28 Mar 2016 22:27:27 +0800
Message-ID: <1459175247-13846-1-git-send-email-zlpwmdx@163.com>
Cc: kaber@trash.net, davem@davemloft.net,
	netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:51230 "EHLO m12-16.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbcC1Oa4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Mar 2016 10:30:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Replace '64' with the per-net ipv6_devconf_all's hop_limit when
building the ipv6 header.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/ipv6/netfilter/ip6t_SYNPROXY.c | 56 ++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index 3deed58..5d778dd 100644
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
@@ -37,13 +38,12 @@ synproxy_build_ip(struct sk_buff *skb, const struct in6_addr *saddr,
 }
 
 static void
-synproxy_send_tcp(const struct synproxy_net *snet,
+synproxy_send_tcp(struct net *net,
 		  const struct sk_buff *skb, struct sk_buff *nskb,
 		  struct nf_conntrack *nfct, enum ip_conntrack_info ctinfo,
 		  struct ipv6hdr *niph, struct tcphdr *nth,
 		  unsigned int tcp_hdr_size)
 {
-	struct net *net = nf_ct_net(snet->tmpl);
 	struct dst_entry *dst;
 	struct flowi6 fl6;
 
@@ -84,7 +84,7 @@ free_nskb:
 }
 
 static void
-synproxy_send_client_synack(const struct synproxy_net *snet,
+synproxy_send_client_synack(struct net *net,
 			    const struct sk_buff *skb, const struct tcphdr *th,
 			    const struct synproxy_options *opts)
 {
@@ -103,7 +103,7 @@ synproxy_send_client_synack(const struct synproxy_net *snet,
 		return;
 	skb_reserve(nskb, MAX_TCP_HEADER);
 
-	niph = synproxy_build_ip(nskb, &iph->daddr, &iph->saddr);
+	niph = synproxy_build_ip(net, nskb, &iph->daddr, &iph->saddr);
 
 	skb_reset_transport_header(nskb);
 	nth = (struct tcphdr *)skb_put(nskb, tcp_hdr_size);
@@ -121,15 +121,16 @@ synproxy_send_client_synack(const struct synproxy_net *snet,
 
 	synproxy_build_options(nth, opts);
 
-	synproxy_send_tcp(snet, skb, nskb, skb->nfct, IP_CT_ESTABLISHED_REPLY,
+	synproxy_send_tcp(net, skb, nskb, skb->nfct, IP_CT_ESTABLISHED_REPLY,
 			  niph, nth, tcp_hdr_size);
 }
 
 static void
-synproxy_send_server_syn(const struct synproxy_net *snet,
+synproxy_send_server_syn(struct net *net,
 			 const struct sk_buff *skb, const struct tcphdr *th,
 			 const struct synproxy_options *opts, u32 recv_seq)
 {
+	struct synproxy_net *snet = synproxy_pernet(net);
 	struct sk_buff *nskb;
 	struct ipv6hdr *iph, *niph;
 	struct tcphdr *nth;
@@ -144,7 +145,7 @@ synproxy_send_server_syn(const struct synproxy_net *snet,
 		return;
 	skb_reserve(nskb, MAX_TCP_HEADER);
 
-	niph = synproxy_build_ip(nskb, &iph->saddr, &iph->daddr);
+	niph = synproxy_build_ip(net, nskb, &iph->saddr, &iph->daddr);
 
 	skb_reset_transport_header(nskb);
 	nth = (struct tcphdr *)skb_put(nskb, tcp_hdr_size);
@@ -165,12 +166,12 @@ synproxy_send_server_syn(const struct synproxy_net *snet,
 
 	synproxy_build_options(nth, opts);
 
-	synproxy_send_tcp(snet, skb, nskb, &snet->tmpl->ct_general, IP_CT_NEW,
+	synproxy_send_tcp(net, skb, nskb, &snet->tmpl->ct_general, IP_CT_NEW,
 			  niph, nth, tcp_hdr_size);
 }
 
 static void
-synproxy_send_server_ack(const struct synproxy_net *snet,
+synproxy_send_server_ack(struct net *net,
 			 const struct ip_ct_tcp *state,
 			 const struct sk_buff *skb, const struct tcphdr *th,
 			 const struct synproxy_options *opts)
@@ -189,7 +190,7 @@ synproxy_send_server_ack(const struct synproxy_net *snet,
 		return;
 	skb_reserve(nskb, MAX_TCP_HEADER);
 
-	niph = synproxy_build_ip(nskb, &iph->daddr, &iph->saddr);
+	niph = synproxy_build_ip(net, nskb, &iph->daddr, &iph->saddr);
 
 	skb_reset_transport_header(nskb);
 	nth = (struct tcphdr *)skb_put(nskb, tcp_hdr_size);
@@ -205,11 +206,11 @@ synproxy_send_server_ack(const struct synproxy_net *snet,
 
 	synproxy_build_options(nth, opts);
 
-	synproxy_send_tcp(snet, skb, nskb, NULL, 0, niph, nth, tcp_hdr_size);
+	synproxy_send_tcp(net, skb, nskb, NULL, 0, niph, nth, tcp_hdr_size);
 }
 
 static void
-synproxy_send_client_ack(const struct synproxy_net *snet,
+synproxy_send_client_ack(struct net *net,
 			 const struct sk_buff *skb, const struct tcphdr *th,
 			 const struct synproxy_options *opts)
 {
@@ -227,7 +228,7 @@ synproxy_send_client_ack(const struct synproxy_net *snet,
 		return;
 	skb_reserve(nskb, MAX_TCP_HEADER);
 
-	niph = synproxy_build_ip(nskb, &iph->saddr, &iph->daddr);
+	niph = synproxy_build_ip(net, nskb, &iph->saddr, &iph->daddr);
 
 	skb_reset_transport_header(nskb);
 	nth = (struct tcphdr *)skb_put(nskb, tcp_hdr_size);
@@ -243,15 +244,16 @@ synproxy_send_client_ack(const struct synproxy_net *snet,
 
 	synproxy_build_options(nth, opts);
 
-	synproxy_send_tcp(snet, skb, nskb, skb->nfct, IP_CT_ESTABLISHED_REPLY,
+	synproxy_send_tcp(net, skb, nskb, skb->nfct, IP_CT_ESTABLISHED_REPLY,
 			  niph, nth, tcp_hdr_size);
 }
 
 static bool
-synproxy_recv_client_ack(const struct synproxy_net *snet,
+synproxy_recv_client_ack(struct net *net,
 			 const struct sk_buff *skb, const struct tcphdr *th,
 			 struct synproxy_options *opts, u32 recv_seq)
 {
+	struct synproxy_net *snet = synproxy_pernet(net);
 	int mss;
 
 	mss = __cookie_v6_check(ipv6_hdr(skb), th, ntohl(th->ack_seq) - 1);
@@ -267,7 +269,7 @@ synproxy_recv_client_ack(const struct synproxy_net *snet,
 	if (opts->options & XT_SYNPROXY_OPT_TIMESTAMP)
 		synproxy_check_timestamp_cookie(opts);
 
-	synproxy_send_server_syn(snet, skb, th, opts, recv_seq);
+	synproxy_send_server_syn(net, skb, th, opts, recv_seq);
 	return true;
 }
 
@@ -275,7 +277,8 @@ static unsigned int
 synproxy_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_synproxy_info *info = par->targinfo;
-	struct synproxy_net *snet = synproxy_pernet(par->net);
+	struct net *net = par->net;
+	struct synproxy_net *snet = synproxy_pernet(net);
 	struct synproxy_options opts = {};
 	struct tcphdr *th, _th;
 
@@ -304,12 +307,12 @@ synproxy_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 					  XT_SYNPROXY_OPT_SACK_PERM |
 					  XT_SYNPROXY_OPT_ECN);
 
-		synproxy_send_client_synack(snet, skb, th, &opts);
+		synproxy_send_client_synack(net, skb, th, &opts);
 		return NF_DROP;
 
 	} else if (th->ack && !(th->fin || th->rst || th->syn)) {
 		/* ACK from client */
-		synproxy_recv_client_ack(snet, skb, th, &opts, ntohl(th->seq));
+		synproxy_recv_client_ack(net, skb, th, &opts, ntohl(th->seq));
 		return NF_DROP;
 	}
 
@@ -320,7 +323,8 @@ static unsigned int ipv6_synproxy_hook(void *priv,
 				       struct sk_buff *skb,
 				       const struct nf_hook_state *nhs)
 {
-	struct synproxy_net *snet = synproxy_pernet(nhs->net);
+	struct net *net = nhs->net;
+	struct synproxy_net *snet = synproxy_pernet(net);
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
 	struct nf_conn_synproxy *synproxy;
@@ -384,7 +388,7 @@ static unsigned int ipv6_synproxy_hook(void *priv,
 			 * therefore we need to add 1 to make the SYN sequence
 			 * number match the one of first SYN.
 			 */
-			if (synproxy_recv_client_ack(snet, skb, th, &opts,
+			if (synproxy_recv_client_ack(net, skb, th, &opts,
 						     ntohl(th->seq) + 1))
 				this_cpu_inc(snet->stats->cookie_retrans);
 
@@ -410,12 +414,12 @@ static unsigned int ipv6_synproxy_hook(void *priv,
 				  XT_SYNPROXY_OPT_SACK_PERM);
 
 		swap(opts.tsval, opts.tsecr);
-		synproxy_send_server_ack(snet, state, skb, th, &opts);
+		synproxy_send_server_ack(net, state, skb, th, &opts);
 
 		nf_ct_seqadj_init(ct, ctinfo, synproxy->isn - ntohl(th->seq));
 
 		swap(opts.tsval, opts.tsecr);
-		synproxy_send_client_ack(snet, skb, th, &opts);
+		synproxy_send_client_ack(net, skb, th, &opts);
 
 		consume_skb(skb);
 		return NF_STOLEN;
-- 
1.9.1


