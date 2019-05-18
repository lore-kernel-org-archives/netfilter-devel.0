Return-Path: <SRS0=bWeD=TS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE11C04AAF
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 May 2019 18:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4F6320675
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 May 2019 18:23:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="PM6+ajZa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729818AbfERSXE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 May 2019 14:23:04 -0400
Received: from mx1.riseup.net ([198.252.153.129]:60018 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728337AbfERSXE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 May 2019 14:23:04 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 91A7E1A2FE3
        for <netfilter-devel@vger.kernel.org>; Sat, 18 May 2019 11:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1558203782; bh=fv1Vb9VVPLC+N1/tSbYspeZvH4JYFZfyARnCPYMGizg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PM6+ajZaGmrSfT8gJR3EYGgDFLnfaXj7urGuQAPTQjqozVxL0JBRxKA9lErxqTg/D
         hdyMuWcrCIjp0chCTyjT0NjfmqH8w7VA8VUiEG24QMAtNonvK6HRml7AQ9zLc34FeX
         aoHxOB9KK+f/EbTNoLhGn+EdGJHTQB7e2aytV1d8=
X-Riseup-User-ID: 7D3D15DDA45392208734B13572A5EE75120FB584B985F85E2DBF64411B967C88
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 79CBF12056F;
        Sat, 18 May 2019 11:23:01 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 4/5 nf-next] netfilter: synproxy: extract IPv6 SYNPROXY infrastructure from ip6t_SYNPROXY
Date:   Sat, 18 May 2019 20:21:54 +0200
Message-Id: <20190518182151.1231-5-ffmancera@riseup.net>
In-Reply-To: <20190518182151.1231-1-ffmancera@riseup.net>
References: <20190518182151.1231-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add common functions into nf_synproxy_ipv6.c to prepare for nftables support.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/net/netfilter/ipv6/nf_synproxy_ipv6.h |  43 ++
 net/ipv6/netfilter/ip6t_SYNPROXY.c            | 420 +-----------------
 net/ipv6/netfilter/nf_synproxy_ipv6.c         | 414 +++++++++++++++++
 3 files changed, 466 insertions(+), 411 deletions(-)
 create mode 100644 include/net/netfilter/ipv6/nf_synproxy_ipv6.h
 create mode 100644 net/ipv6/netfilter/nf_synproxy_ipv6.c

diff --git a/include/net/netfilter/ipv6/nf_synproxy_ipv6.h b/include/net/netfilter/ipv6/nf_synproxy_ipv6.h
new file mode 100644
index 000000000000..afcbbfa5bc17
--- /dev/null
+++ b/include/net/netfilter/ipv6/nf_synproxy_ipv6.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NF_SYNPROXY_IPV6_H
+#define _NF_SYNPROXY_IPV6_H
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <net/ip6_checksum.h>
+#include <net/ip6_route.h>
+#include <net/tcp.h>
+
+#include <net/netfilter/nf_conntrack_seqadj.h>
+#include <net/netfilter/nf_conntrack_synproxy.h>
+
+void synproxy_send_client_synack_ipv6(struct net *net, const struct sk_buff *skb,
+				      const struct tcphdr *th,
+				      const struct synproxy_options *opts);
+
+bool synproxy_recv_client_ack_ipv6(struct net *net, const struct sk_buff *skb,
+				   const struct tcphdr *th,
+				   struct synproxy_options *opts, u32 recv_seq);
+
+unsigned int ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
+				const struct nf_hook_state *nhs);
+
+int nf_synproxy_ipv6_init(struct synproxy_net *snet, struct net *net);
+void nf_synproxy_ipv6_fini(struct synproxy_net *snet, struct net *net);
+
+static const struct nf_hook_ops ipv6_synproxy_ops[] = {
+	{
+		.hook		= ipv6_synproxy_hook,
+		.pf		= NFPROTO_IPV6,
+		.hooknum	= NF_INET_LOCAL_IN,
+		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM - 1,
+	},
+	{
+		.hook		= ipv6_synproxy_hook,
+		.pf		= NFPROTO_IPV6,
+		.hooknum	= NF_INET_POST_ROUTING,
+		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM - 1,
+	},
+};
+
+#endif /* _NF_SYNPROXY_IPV6_H */
diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index cb6d42b03cb5..e53eb76a2bad 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -6,272 +6,11 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <net/ip6_checksum.h>
-#include <net/ip6_route.h>
-#include <net/tcp.h>
-
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_SYNPROXY.h>
-#include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_conntrack_seqadj.h>
-#include <net/netfilter/nf_conntrack_synproxy.h>
-#include <net/netfilter/nf_conntrack_ecache.h>
-
-static struct ipv6hdr *
-synproxy_build_ip(struct net *net, struct sk_buff *skb,
-		  const struct in6_addr *saddr,
-		  const struct in6_addr *daddr)
-{
-	struct ipv6hdr *iph;
-
-	skb_reset_network_header(skb);
-	iph = skb_put(skb, sizeof(*iph));
-	ip6_flow_hdr(iph, 0, 0);
-	iph->hop_limit	= net->ipv6.devconf_all->hop_limit;
-	iph->nexthdr	= IPPROTO_TCP;
-	iph->saddr	= *saddr;
-	iph->daddr	= *daddr;
-
-	return iph;
-}
-
-static void
-synproxy_send_tcp(struct net *net,
-		  const struct sk_buff *skb, struct sk_buff *nskb,
-		  struct nf_conntrack *nfct, enum ip_conntrack_info ctinfo,
-		  struct ipv6hdr *niph, struct tcphdr *nth,
-		  unsigned int tcp_hdr_size)
-{
-	struct dst_entry *dst;
-	struct flowi6 fl6;
-
-	nth->check = ~tcp_v6_check(tcp_hdr_size, &niph->saddr, &niph->daddr, 0);
-	nskb->ip_summed   = CHECKSUM_PARTIAL;
-	nskb->csum_start  = (unsigned char *)nth - nskb->head;
-	nskb->csum_offset = offsetof(struct tcphdr, check);
-
-	memset(&fl6, 0, sizeof(fl6));
-	fl6.flowi6_proto = IPPROTO_TCP;
-	fl6.saddr = niph->saddr;
-	fl6.daddr = niph->daddr;
-	fl6.fl6_sport = nth->source;
-	fl6.fl6_dport = nth->dest;
-	security_skb_classify_flow((struct sk_buff *)skb, flowi6_to_flowi(&fl6));
-	dst = ip6_route_output(net, NULL, &fl6);
-	if (dst->error) {
-		dst_release(dst);
-		goto free_nskb;
-	}
-	dst = xfrm_lookup(net, dst, flowi6_to_flowi(&fl6), NULL, 0);
-	if (IS_ERR(dst))
-		goto free_nskb;
-
-	skb_dst_set(nskb, dst);
-
-	if (nfct) {
-		nf_ct_set(nskb, (struct nf_conn *)nfct, ctinfo);
-		nf_conntrack_get(nfct);
-	}
-
-	ip6_local_out(net, nskb->sk, nskb);
-	return;
-
-free_nskb:
-	kfree_skb(nskb);
-}
-
-static void
-synproxy_send_client_synack(struct net *net,
-			    const struct sk_buff *skb, const struct tcphdr *th,
-			    const struct synproxy_options *opts)
-{
-	struct sk_buff *nskb;
-	struct ipv6hdr *iph, *niph;
-	struct tcphdr *nth;
-	unsigned int tcp_hdr_size;
-	u16 mss = opts->mss;
-
-	iph = ipv6_hdr(skb);
-
-	tcp_hdr_size = sizeof(*nth) + synproxy_options_size(opts);
-	nskb = alloc_skb(sizeof(*niph) + tcp_hdr_size + MAX_TCP_HEADER,
-			 GFP_ATOMIC);
-	if (nskb == NULL)
-		return;
-	skb_reserve(nskb, MAX_TCP_HEADER);
-
-	niph = synproxy_build_ip(net, nskb, &iph->daddr, &iph->saddr);
-
-	skb_reset_transport_header(nskb);
-	nth = skb_put(nskb, tcp_hdr_size);
-	nth->source	= th->dest;
-	nth->dest	= th->source;
-	nth->seq	= htonl(__cookie_v6_init_sequence(iph, th, &mss));
-	nth->ack_seq	= htonl(ntohl(th->seq) + 1);
-	tcp_flag_word(nth) = TCP_FLAG_SYN | TCP_FLAG_ACK;
-	if (opts->options & XT_SYNPROXY_OPT_ECN)
-		tcp_flag_word(nth) |= TCP_FLAG_ECE;
-	nth->doff	= tcp_hdr_size / 4;
-	nth->window	= 0;
-	nth->check	= 0;
-	nth->urg_ptr	= 0;
-
-	synproxy_build_options(nth, opts);
-
-	synproxy_send_tcp(net, skb, nskb, skb_nfct(skb),
-			  IP_CT_ESTABLISHED_REPLY, niph, nth, tcp_hdr_size);
-}
 
-static void
-synproxy_send_server_syn(struct net *net,
-			 const struct sk_buff *skb, const struct tcphdr *th,
-			 const struct synproxy_options *opts, u32 recv_seq)
-{
-	struct synproxy_net *snet = synproxy_pernet(net);
-	struct sk_buff *nskb;
-	struct ipv6hdr *iph, *niph;
-	struct tcphdr *nth;
-	unsigned int tcp_hdr_size;
-
-	iph = ipv6_hdr(skb);
-
-	tcp_hdr_size = sizeof(*nth) + synproxy_options_size(opts);
-	nskb = alloc_skb(sizeof(*niph) + tcp_hdr_size + MAX_TCP_HEADER,
-			 GFP_ATOMIC);
-	if (nskb == NULL)
-		return;
-	skb_reserve(nskb, MAX_TCP_HEADER);
-
-	niph = synproxy_build_ip(net, nskb, &iph->saddr, &iph->daddr);
-
-	skb_reset_transport_header(nskb);
-	nth = skb_put(nskb, tcp_hdr_size);
-	nth->source	= th->source;
-	nth->dest	= th->dest;
-	nth->seq	= htonl(recv_seq - 1);
-	/* ack_seq is used to relay our ISN to the synproxy hook to initialize
-	 * sequence number translation once a connection tracking entry exists.
-	 */
-	nth->ack_seq	= htonl(ntohl(th->ack_seq) - 1);
-	tcp_flag_word(nth) = TCP_FLAG_SYN;
-	if (opts->options & XT_SYNPROXY_OPT_ECN)
-		tcp_flag_word(nth) |= TCP_FLAG_ECE | TCP_FLAG_CWR;
-	nth->doff	= tcp_hdr_size / 4;
-	nth->window	= th->window;
-	nth->check	= 0;
-	nth->urg_ptr	= 0;
-
-	synproxy_build_options(nth, opts);
-
-	synproxy_send_tcp(net, skb, nskb, &snet->tmpl->ct_general, IP_CT_NEW,
-			  niph, nth, tcp_hdr_size);
-}
-
-static void
-synproxy_send_server_ack(struct net *net,
-			 const struct ip_ct_tcp *state,
-			 const struct sk_buff *skb, const struct tcphdr *th,
-			 const struct synproxy_options *opts)
-{
-	struct sk_buff *nskb;
-	struct ipv6hdr *iph, *niph;
-	struct tcphdr *nth;
-	unsigned int tcp_hdr_size;
-
-	iph = ipv6_hdr(skb);
-
-	tcp_hdr_size = sizeof(*nth) + synproxy_options_size(opts);
-	nskb = alloc_skb(sizeof(*niph) + tcp_hdr_size + MAX_TCP_HEADER,
-			 GFP_ATOMIC);
-	if (nskb == NULL)
-		return;
-	skb_reserve(nskb, MAX_TCP_HEADER);
-
-	niph = synproxy_build_ip(net, nskb, &iph->daddr, &iph->saddr);
-
-	skb_reset_transport_header(nskb);
-	nth = skb_put(nskb, tcp_hdr_size);
-	nth->source	= th->dest;
-	nth->dest	= th->source;
-	nth->seq	= htonl(ntohl(th->ack_seq));
-	nth->ack_seq	= htonl(ntohl(th->seq) + 1);
-	tcp_flag_word(nth) = TCP_FLAG_ACK;
-	nth->doff	= tcp_hdr_size / 4;
-	nth->window	= htons(state->seen[IP_CT_DIR_ORIGINAL].td_maxwin);
-	nth->check	= 0;
-	nth->urg_ptr	= 0;
-
-	synproxy_build_options(nth, opts);
-
-	synproxy_send_tcp(net, skb, nskb, NULL, 0, niph, nth, tcp_hdr_size);
-}
-
-static void
-synproxy_send_client_ack(struct net *net,
-			 const struct sk_buff *skb, const struct tcphdr *th,
-			 const struct synproxy_options *opts)
-{
-	struct sk_buff *nskb;
-	struct ipv6hdr *iph, *niph;
-	struct tcphdr *nth;
-	unsigned int tcp_hdr_size;
-
-	iph = ipv6_hdr(skb);
-
-	tcp_hdr_size = sizeof(*nth) + synproxy_options_size(opts);
-	nskb = alloc_skb(sizeof(*niph) + tcp_hdr_size + MAX_TCP_HEADER,
-			 GFP_ATOMIC);
-	if (nskb == NULL)
-		return;
-	skb_reserve(nskb, MAX_TCP_HEADER);
-
-	niph = synproxy_build_ip(net, nskb, &iph->saddr, &iph->daddr);
-
-	skb_reset_transport_header(nskb);
-	nth = skb_put(nskb, tcp_hdr_size);
-	nth->source	= th->source;
-	nth->dest	= th->dest;
-	nth->seq	= htonl(ntohl(th->seq) + 1);
-	nth->ack_seq	= th->ack_seq;
-	tcp_flag_word(nth) = TCP_FLAG_ACK;
-	nth->doff	= tcp_hdr_size / 4;
-	nth->window	= htons(ntohs(th->window) >> opts->wscale);
-	nth->check	= 0;
-	nth->urg_ptr	= 0;
-
-	synproxy_build_options(nth, opts);
-
-	synproxy_send_tcp(net, skb, nskb, skb_nfct(skb),
-			  IP_CT_ESTABLISHED_REPLY, niph, nth, tcp_hdr_size);
-}
-
-static bool
-synproxy_recv_client_ack(struct net *net,
-			 const struct sk_buff *skb, const struct tcphdr *th,
-			 struct synproxy_options *opts, u32 recv_seq)
-{
-	struct synproxy_net *snet = synproxy_pernet(net);
-	int mss;
-
-	mss = __cookie_v6_check(ipv6_hdr(skb), th, ntohl(th->ack_seq) - 1);
-	if (mss == 0) {
-		this_cpu_inc(snet->stats->cookie_invalid);
-		return false;
-	}
-
-	this_cpu_inc(snet->stats->cookie_valid);
-	opts->mss = mss;
-	opts->options |= XT_SYNPROXY_OPT_MSS;
-
-	if (opts->options & XT_SYNPROXY_OPT_TIMESTAMP)
-		synproxy_check_timestamp_cookie(opts);
-
-	synproxy_send_server_syn(net, skb, th, opts, recv_seq);
-	return true;
-}
+#include <net/netfilter/ipv6/nf_synproxy_ipv6.h>
 
 static unsigned int
 synproxy_tg6(struct sk_buff *skb, const struct xt_action_param *par)
@@ -307,13 +46,14 @@ synproxy_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 					  XT_SYNPROXY_OPT_SACK_PERM |
 					  XT_SYNPROXY_OPT_ECN);
 
-		synproxy_send_client_synack(net, skb, th, &opts);
+		synproxy_send_client_synack_ipv6(net, skb, th, &opts);
 		consume_skb(skb);
 		return NF_STOLEN;
 
 	} else if (th->ack && !(th->fin || th->rst || th->syn)) {
 		/* ACK from client */
-		if (synproxy_recv_client_ack(net, skb, th, &opts, ntohl(th->seq))) {
+		if (synproxy_recv_client_ack_ipv6(net, skb, th, &opts,
+						  ntohl(th->seq))) {
 			consume_skb(skb);
 			return NF_STOLEN;
 		} else {
@@ -324,141 +64,6 @@ synproxy_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	return XT_CONTINUE;
 }
 
-static unsigned int ipv6_synproxy_hook(void *priv,
-				       struct sk_buff *skb,
-				       const struct nf_hook_state *nhs)
-{
-	struct net *net = nhs->net;
-	struct synproxy_net *snet = synproxy_pernet(net);
-	enum ip_conntrack_info ctinfo;
-	struct nf_conn *ct;
-	struct nf_conn_synproxy *synproxy;
-	struct synproxy_options opts = {};
-	const struct ip_ct_tcp *state;
-	struct tcphdr *th, _th;
-	__be16 frag_off;
-	u8 nexthdr;
-	int thoff;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	if (ct == NULL)
-		return NF_ACCEPT;
-
-	synproxy = nfct_synproxy(ct);
-	if (synproxy == NULL)
-		return NF_ACCEPT;
-
-	if (nf_is_loopback_packet(skb))
-		return NF_ACCEPT;
-
-	nexthdr = ipv6_hdr(skb)->nexthdr;
-	thoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
-				 &frag_off);
-	if (thoff < 0 || nexthdr != IPPROTO_TCP)
-		return NF_ACCEPT;
-
-	th = skb_header_pointer(skb, thoff, sizeof(_th), &_th);
-	if (th == NULL)
-		return NF_DROP;
-
-	state = &ct->proto.tcp;
-	switch (state->state) {
-	case TCP_CONNTRACK_CLOSE:
-		if (th->rst && !test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
-			nf_ct_seqadj_init(ct, ctinfo, synproxy->isn -
-						      ntohl(th->seq) + 1);
-			break;
-		}
-
-		if (!th->syn || th->ack ||
-		    CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL)
-			break;
-
-		/* Reopened connection - reset the sequence number and timestamp
-		 * adjustments, they will get initialized once the connection is
-		 * reestablished.
-		 */
-		nf_ct_seqadj_init(ct, ctinfo, 0);
-		synproxy->tsoff = 0;
-		this_cpu_inc(snet->stats->conn_reopened);
-
-		/* fall through */
-	case TCP_CONNTRACK_SYN_SENT:
-		if (!synproxy_parse_options(skb, thoff, th, &opts))
-			return NF_DROP;
-
-		if (!th->syn && th->ack &&
-		    CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
-			/* Keep-Alives are sent with SEG.SEQ = SND.NXT-1,
-			 * therefore we need to add 1 to make the SYN sequence
-			 * number match the one of first SYN.
-			 */
-			if (synproxy_recv_client_ack(net, skb, th, &opts,
-						     ntohl(th->seq) + 1)) {
-				this_cpu_inc(snet->stats->cookie_retrans);
-				consume_skb(skb);
-				return NF_STOLEN;
-			} else {
-				return NF_DROP;
-			}
-		}
-
-		synproxy->isn = ntohl(th->ack_seq);
-		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
-			synproxy->its = opts.tsecr;
-
-		nf_conntrack_event_cache(IPCT_SYNPROXY, ct);
-		break;
-	case TCP_CONNTRACK_SYN_RECV:
-		if (!th->syn || !th->ack)
-			break;
-
-		if (!synproxy_parse_options(skb, thoff, th, &opts))
-			return NF_DROP;
-
-		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP) {
-			synproxy->tsoff = opts.tsval - synproxy->its;
-			nf_conntrack_event_cache(IPCT_SYNPROXY, ct);
-		}
-
-		opts.options &= ~(XT_SYNPROXY_OPT_MSS |
-				  XT_SYNPROXY_OPT_WSCALE |
-				  XT_SYNPROXY_OPT_SACK_PERM);
-
-		swap(opts.tsval, opts.tsecr);
-		synproxy_send_server_ack(net, state, skb, th, &opts);
-
-		nf_ct_seqadj_init(ct, ctinfo, synproxy->isn - ntohl(th->seq));
-		nf_conntrack_event_cache(IPCT_SEQADJ, ct);
-
-		swap(opts.tsval, opts.tsecr);
-		synproxy_send_client_ack(net, skb, th, &opts);
-
-		consume_skb(skb);
-		return NF_STOLEN;
-	default:
-		break;
-	}
-
-	synproxy_tstamp_adjust(skb, thoff, th, ct, ctinfo, synproxy);
-	return NF_ACCEPT;
-}
-
-static const struct nf_hook_ops ipv6_synproxy_ops[] = {
-	{
-		.hook		= ipv6_synproxy_hook,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_LOCAL_IN,
-		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM - 1,
-	},
-	{
-		.hook		= ipv6_synproxy_hook,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_POST_ROUTING,
-		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM - 1,
-	},
-};
-
 static int synproxy_tg6_check(const struct xt_tgchk_param *par)
 {
 	struct synproxy_net *snet = synproxy_pernet(par->net);
@@ -474,16 +79,12 @@ static int synproxy_tg6_check(const struct xt_tgchk_param *par)
 	if (err)
 		return err;
 
-	if (snet->hook_ref6 == 0) {
-		err = nf_register_net_hooks(par->net, ipv6_synproxy_ops,
-					    ARRAY_SIZE(ipv6_synproxy_ops));
-		if (err) {
-			nf_ct_netns_put(par->net, par->family);
-			return err;
-		}
+	err = nf_synproxy_ipv6_init(snet, par->net);
+	if (err) {
+		nf_ct_netns_put(par->net, par->family);
+		return err;
 	}
 
-	snet->hook_ref6++;
 	return err;
 }
 
@@ -491,10 +92,7 @@ static void synproxy_tg6_destroy(const struct xt_tgdtor_param *par)
 {
 	struct synproxy_net *snet = synproxy_pernet(par->net);
 
-	snet->hook_ref6--;
-	if (snet->hook_ref6 == 0)
-		nf_unregister_net_hooks(par->net, ipv6_synproxy_ops,
-					ARRAY_SIZE(ipv6_synproxy_ops));
+	nf_synproxy_ipv6_fini(snet, par->net);
 	nf_ct_netns_put(par->net, par->family);
 }
 
diff --git a/net/ipv6/netfilter/nf_synproxy_ipv6.c b/net/ipv6/netfilter/nf_synproxy_ipv6.c
new file mode 100644
index 000000000000..31568ef65913
--- /dev/null
+++ b/net/ipv6/netfilter/nf_synproxy_ipv6.c
@@ -0,0 +1,414 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
+#include <net/netfilter/ipv6/nf_synproxy_ipv6.h>
+
+#include <linux/netfilter/nf_SYNPROXY.h>
+
+static struct ipv6hdr *
+synproxy_build_ip(struct net *net, struct sk_buff *skb,
+		  const struct in6_addr *saddr,
+		  const struct in6_addr *daddr)
+{
+	struct ipv6hdr *iph;
+
+	skb_reset_network_header(skb);
+	iph = skb_put(skb, sizeof(*iph));
+	ip6_flow_hdr(iph, 0, 0);
+	iph->hop_limit	= net->ipv6.devconf_all->hop_limit;
+	iph->nexthdr	= IPPROTO_TCP;
+	iph->saddr	= *saddr;
+	iph->daddr	= *daddr;
+
+	return iph;
+}
+
+static void
+synproxy_send_tcp(struct net *net,
+		  const struct sk_buff *skb, struct sk_buff *nskb,
+		  struct nf_conntrack *nfct, enum ip_conntrack_info ctinfo,
+		  struct ipv6hdr *niph, struct tcphdr *nth,
+		  unsigned int tcp_hdr_size)
+{
+	struct dst_entry *dst;
+	struct flowi6 fl6;
+
+	nth->check = ~tcp_v6_check(tcp_hdr_size, &niph->saddr, &niph->daddr, 0);
+	nskb->ip_summed   = CHECKSUM_PARTIAL;
+	nskb->csum_start  = (unsigned char *)nth - nskb->head;
+	nskb->csum_offset = offsetof(struct tcphdr, check);
+
+	memset(&fl6, 0, sizeof(fl6));
+	fl6.flowi6_proto = IPPROTO_TCP;
+	fl6.saddr = niph->saddr;
+	fl6.daddr = niph->daddr;
+	fl6.fl6_sport = nth->source;
+	fl6.fl6_dport = nth->dest;
+	security_skb_classify_flow((struct sk_buff *)skb, flowi6_to_flowi(&fl6));
+	dst = ip6_route_output(net, NULL, &fl6);
+	if (dst->error) {
+		dst_release(dst);
+		goto free_nskb;
+	}
+	dst = xfrm_lookup(net, dst, flowi6_to_flowi(&fl6), NULL, 0);
+	if (IS_ERR(dst))
+		goto free_nskb;
+
+	skb_dst_set(nskb, dst);
+
+	if (nfct) {
+		nf_ct_set(nskb, (struct nf_conn *)nfct, ctinfo);
+		nf_conntrack_get(nfct);
+	}
+
+	ip6_local_out(net, nskb->sk, nskb);
+	return;
+
+free_nskb:
+	kfree_skb(nskb);
+}
+
+void
+synproxy_send_client_synack_ipv6(struct net *net,
+				 const struct sk_buff *skb,
+				 const struct tcphdr *th,
+				 const struct synproxy_options *opts)
+{
+	struct sk_buff *nskb;
+	struct ipv6hdr *iph, *niph;
+	struct tcphdr *nth;
+	unsigned int tcp_hdr_size;
+	u16 mss = opts->mss;
+
+	iph = ipv6_hdr(skb);
+
+	tcp_hdr_size = sizeof(*nth) + synproxy_options_size(opts);
+	nskb = alloc_skb(sizeof(*niph) + tcp_hdr_size + MAX_TCP_HEADER,
+			 GFP_ATOMIC);
+	if (nskb == NULL)
+		return;
+	skb_reserve(nskb, MAX_TCP_HEADER);
+
+	niph = synproxy_build_ip(net, nskb, &iph->daddr, &iph->saddr);
+
+	skb_reset_transport_header(nskb);
+	nth = skb_put(nskb, tcp_hdr_size);
+	nth->source	= th->dest;
+	nth->dest	= th->source;
+	nth->seq	= htonl(__cookie_v6_init_sequence(iph, th, &mss));
+	nth->ack_seq	= htonl(ntohl(th->seq) + 1);
+	tcp_flag_word(nth) = TCP_FLAG_SYN | TCP_FLAG_ACK;
+	if (opts->options & NF_SYNPROXY_OPT_ECN)
+		tcp_flag_word(nth) |= TCP_FLAG_ECE;
+	nth->doff	= tcp_hdr_size / 4;
+	nth->window	= 0;
+	nth->check	= 0;
+	nth->urg_ptr	= 0;
+
+	synproxy_build_options(nth, opts);
+
+	synproxy_send_tcp(net, skb, nskb, skb_nfct(skb),
+			  IP_CT_ESTABLISHED_REPLY, niph, nth, tcp_hdr_size);
+}
+EXPORT_SYMBOL_GPL(synproxy_send_client_synack_ipv6);
+
+static void
+synproxy_send_server_syn(struct net *net,
+			 const struct sk_buff *skb, const struct tcphdr *th,
+			 const struct synproxy_options *opts, u32 recv_seq)
+{
+	struct synproxy_net *snet = synproxy_pernet(net);
+	struct sk_buff *nskb;
+	struct ipv6hdr *iph, *niph;
+	struct tcphdr *nth;
+	unsigned int tcp_hdr_size;
+
+	iph = ipv6_hdr(skb);
+
+	tcp_hdr_size = sizeof(*nth) + synproxy_options_size(opts);
+	nskb = alloc_skb(sizeof(*niph) + tcp_hdr_size + MAX_TCP_HEADER,
+			 GFP_ATOMIC);
+	if (nskb == NULL)
+		return;
+	skb_reserve(nskb, MAX_TCP_HEADER);
+
+	niph = synproxy_build_ip(net, nskb, &iph->saddr, &iph->daddr);
+
+	skb_reset_transport_header(nskb);
+	nth = skb_put(nskb, tcp_hdr_size);
+	nth->source	= th->source;
+	nth->dest	= th->dest;
+	nth->seq	= htonl(recv_seq - 1);
+	/* ack_seq is used to relay our ISN to the synproxy hook to initialize
+	 * sequence number translation once a connection tracking entry exists.
+	 */
+	nth->ack_seq	= htonl(ntohl(th->ack_seq) - 1);
+	tcp_flag_word(nth) = TCP_FLAG_SYN;
+	if (opts->options & NF_SYNPROXY_OPT_ECN)
+		tcp_flag_word(nth) |= TCP_FLAG_ECE | TCP_FLAG_CWR;
+	nth->doff	= tcp_hdr_size / 4;
+	nth->window	= th->window;
+	nth->check	= 0;
+	nth->urg_ptr	= 0;
+
+	synproxy_build_options(nth, opts);
+
+	synproxy_send_tcp(net, skb, nskb, &snet->tmpl->ct_general, IP_CT_NEW,
+			  niph, nth, tcp_hdr_size);
+}
+
+static void
+synproxy_send_server_ack(struct net *net,
+			 const struct ip_ct_tcp *state,
+			 const struct sk_buff *skb, const struct tcphdr *th,
+			 const struct synproxy_options *opts)
+{
+	struct sk_buff *nskb;
+	struct ipv6hdr *iph, *niph;
+	struct tcphdr *nth;
+	unsigned int tcp_hdr_size;
+
+	iph = ipv6_hdr(skb);
+
+	tcp_hdr_size = sizeof(*nth) + synproxy_options_size(opts);
+	nskb = alloc_skb(sizeof(*niph) + tcp_hdr_size + MAX_TCP_HEADER,
+			 GFP_ATOMIC);
+	if (nskb == NULL)
+		return;
+	skb_reserve(nskb, MAX_TCP_HEADER);
+
+	niph = synproxy_build_ip(net, nskb, &iph->daddr, &iph->saddr);
+
+	skb_reset_transport_header(nskb);
+	nth = skb_put(nskb, tcp_hdr_size);
+	nth->source	= th->dest;
+	nth->dest	= th->source;
+	nth->seq	= htonl(ntohl(th->ack_seq));
+	nth->ack_seq	= htonl(ntohl(th->seq) + 1);
+	tcp_flag_word(nth) = TCP_FLAG_ACK;
+	nth->doff	= tcp_hdr_size / 4;
+	nth->window	= htons(state->seen[IP_CT_DIR_ORIGINAL].td_maxwin);
+	nth->check	= 0;
+	nth->urg_ptr	= 0;
+
+	synproxy_build_options(nth, opts);
+
+	synproxy_send_tcp(net, skb, nskb, NULL, 0, niph, nth, tcp_hdr_size);
+}
+
+static void
+synproxy_send_client_ack(struct net *net,
+			 const struct sk_buff *skb, const struct tcphdr *th,
+			 const struct synproxy_options *opts)
+{
+	struct sk_buff *nskb;
+	struct ipv6hdr *iph, *niph;
+	struct tcphdr *nth;
+	unsigned int tcp_hdr_size;
+
+	iph = ipv6_hdr(skb);
+
+	tcp_hdr_size = sizeof(*nth) + synproxy_options_size(opts);
+	nskb = alloc_skb(sizeof(*niph) + tcp_hdr_size + MAX_TCP_HEADER,
+			 GFP_ATOMIC);
+	if (nskb == NULL)
+		return;
+	skb_reserve(nskb, MAX_TCP_HEADER);
+
+	niph = synproxy_build_ip(net, nskb, &iph->saddr, &iph->daddr);
+
+	skb_reset_transport_header(nskb);
+	nth = skb_put(nskb, tcp_hdr_size);
+	nth->source	= th->source;
+	nth->dest	= th->dest;
+	nth->seq	= htonl(ntohl(th->seq) + 1);
+	nth->ack_seq	= th->ack_seq;
+	tcp_flag_word(nth) = TCP_FLAG_ACK;
+	nth->doff	= tcp_hdr_size / 4;
+	nth->window	= htons(ntohs(th->window) >> opts->wscale);
+	nth->check	= 0;
+	nth->urg_ptr	= 0;
+
+	synproxy_build_options(nth, opts);
+
+	synproxy_send_tcp(net, skb, nskb, skb_nfct(skb),
+			  IP_CT_ESTABLISHED_REPLY, niph, nth, tcp_hdr_size);
+}
+
+bool
+synproxy_recv_client_ack_ipv6(struct net *net,
+			      const struct sk_buff *skb, const struct tcphdr *th,
+			      struct synproxy_options *opts, u32 recv_seq)
+{
+	struct synproxy_net *snet = synproxy_pernet(net);
+	int mss;
+
+	mss = __cookie_v6_check(ipv6_hdr(skb), th, ntohl(th->ack_seq) - 1);
+	if (mss == 0) {
+		this_cpu_inc(snet->stats->cookie_invalid);
+		return false;
+	}
+
+	this_cpu_inc(snet->stats->cookie_valid);
+	opts->mss = mss;
+	opts->options |= NF_SYNPROXY_OPT_MSS;
+
+	if (opts->options & NF_SYNPROXY_OPT_TIMESTAMP)
+		synproxy_check_timestamp_cookie(opts);
+
+	synproxy_send_server_syn(net, skb, th, opts, recv_seq);
+	return true;
+}
+EXPORT_SYMBOL_GPL(synproxy_recv_client_ack_ipv6);
+
+unsigned int
+ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
+		   const struct nf_hook_state *nhs)
+{
+	struct net *net = nhs->net;
+	struct synproxy_net *snet = synproxy_pernet(net);
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+	struct nf_conn_synproxy *synproxy;
+	struct synproxy_options opts = {};
+	const struct ip_ct_tcp *state;
+	struct tcphdr *th, _th;
+	__be16 frag_off;
+	u8 nexthdr;
+	int thoff;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct == NULL)
+		return NF_ACCEPT;
+
+	synproxy = nfct_synproxy(ct);
+	if (synproxy == NULL)
+		return NF_ACCEPT;
+
+	if (nf_is_loopback_packet(skb))
+		return NF_ACCEPT;
+
+	nexthdr = ipv6_hdr(skb)->nexthdr;
+	thoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
+				 &frag_off);
+	if (thoff < 0 || nexthdr != IPPROTO_TCP)
+		return NF_ACCEPT;
+
+	th = skb_header_pointer(skb, thoff, sizeof(_th), &_th);
+	if (th == NULL)
+		return NF_DROP;
+
+	state = &ct->proto.tcp;
+	switch (state->state) {
+	case TCP_CONNTRACK_CLOSE:
+		if (th->rst && !test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
+			nf_ct_seqadj_init(ct, ctinfo, synproxy->isn -
+						      ntohl(th->seq) + 1);
+			break;
+		}
+
+		if (!th->syn || th->ack ||
+		    CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL)
+			break;
+
+		/* Reopened connection - reset the sequence number and timestamp
+		 * adjustments, they will get initialized once the connection is
+		 * reestablished.
+		 */
+		nf_ct_seqadj_init(ct, ctinfo, 0);
+		synproxy->tsoff = 0;
+		this_cpu_inc(snet->stats->conn_reopened);
+
+		/* fall through */
+	case TCP_CONNTRACK_SYN_SENT:
+		if (!synproxy_parse_options(skb, thoff, th, &opts))
+			return NF_DROP;
+
+		if (!th->syn && th->ack &&
+		    CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
+			/* Keep-Alives are sent with SEG.SEQ = SND.NXT-1,
+			 * therefore we need to add 1 to make the SYN sequence
+			 * number match the one of first SYN.
+			 */
+			if (synproxy_recv_client_ack_ipv6(net, skb, th, &opts,
+							  ntohl(th->seq) + 1)) {
+				this_cpu_inc(snet->stats->cookie_retrans);
+				consume_skb(skb);
+				return NF_STOLEN;
+			} else {
+				return NF_DROP;
+			}
+		}
+
+		synproxy->isn = ntohl(th->ack_seq);
+		if (opts.options & NF_SYNPROXY_OPT_TIMESTAMP)
+			synproxy->its = opts.tsecr;
+
+		nf_conntrack_event_cache(IPCT_SYNPROXY, ct);
+		break;
+	case TCP_CONNTRACK_SYN_RECV:
+		if (!th->syn || !th->ack)
+			break;
+
+		if (!synproxy_parse_options(skb, thoff, th, &opts))
+			return NF_DROP;
+
+		if (opts.options & NF_SYNPROXY_OPT_TIMESTAMP) {
+			synproxy->tsoff = opts.tsval - synproxy->its;
+			nf_conntrack_event_cache(IPCT_SYNPROXY, ct);
+		}
+
+		opts.options &= ~(NF_SYNPROXY_OPT_MSS |
+				  NF_SYNPROXY_OPT_WSCALE |
+				  NF_SYNPROXY_OPT_SACK_PERM);
+
+		swap(opts.tsval, opts.tsecr);
+		synproxy_send_server_ack(net, state, skb, th, &opts);
+
+		nf_ct_seqadj_init(ct, ctinfo, synproxy->isn - ntohl(th->seq));
+		nf_conntrack_event_cache(IPCT_SEQADJ, ct);
+
+		swap(opts.tsval, opts.tsecr);
+		synproxy_send_client_ack(net, skb, th, &opts);
+
+		consume_skb(skb);
+		return NF_STOLEN;
+	default:
+		break;
+	}
+
+	synproxy_tstamp_adjust(skb, thoff, th, ct, ctinfo, synproxy);
+	return NF_ACCEPT;
+}
+EXPORT_SYMBOL_GPL(ipv6_synproxy_hook);
+
+int
+nf_synproxy_ipv6_init(struct synproxy_net *snet, struct net *net)
+{
+	int err;
+
+        if (snet->hook_ref6 == 0) {
+                err = nf_register_net_hooks(net, ipv6_synproxy_ops,
+                                            ARRAY_SIZE(ipv6_synproxy_ops));
+                if (err)
+                        return err;
+        }
+
+	snet->hook_ref6++;
+	return err;
+}
+EXPORT_SYMBOL_GPL(nf_synproxy_ipv6_init);
+
+void
+nf_synproxy_ipv6_fini(struct synproxy_net *snet, struct net *net)
+{
+        snet->hook_ref6--;
+        if (snet->hook_ref6 == 0)
+                nf_unregister_net_hooks(net, ipv6_synproxy_ops,
+					ARRAY_SIZE(ipv6_synproxy_ops));
+}
+EXPORT_SYMBOL_GPL(nf_synproxy_ipv6_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Fernando Fernandez <ffmancera@riseup.net>");
-- 
2.20.1

