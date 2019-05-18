Return-Path: <SRS0=bWeD=TS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7663DC04AAF
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 May 2019 18:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3357820657
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 May 2019 18:22:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="LiKlDwxk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbfERSWi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 May 2019 14:22:38 -0400
Received: from mx1.riseup.net ([198.252.153.129]:59904 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729269AbfERSWh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 May 2019 14:22:37 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 6613A1A2FE3
        for <netfilter-devel@vger.kernel.org>; Sat, 18 May 2019 11:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1558203756; bh=eSDt09rL/HstxQ9T6dd0No25aCMA/o0zacmLgA+nF4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LiKlDwxkZ9GjlL8hgRfVM99S7jfTs7bAhUyqYm4XsVH9tCoHJxYyjHVATLOvRD39f
         nD5Et3FYnmEbs/C3s6BFX2OPIOvYyZV45O8QZUnedjKqJQCGz6bhjx5CDTo2je7XD/
         okJPPEEZqCxkSiwtrnIpcXAbQwsyxL4QrHct6lJQ=
X-Riseup-User-ID: 5B5B3B6AF70B68EF41A124B61914C9393E5211670746E9D32CE98E97C6E54DDD
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 1AABC120814;
        Sat, 18 May 2019 11:22:34 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 2/5 nf-next] netfilter: synproxy: extract IPv4 SYNPROXY infrastructure from ipt_SYNPROXY
Date:   Sat, 18 May 2019 20:21:50 +0200
Message-Id: <20190518182151.1231-3-ffmancera@riseup.net>
In-Reply-To: <20190518182151.1231-1-ffmancera@riseup.net>
References: <20190518182151.1231-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add common functions into nf_synproxy_ipv4.c to prepare for nftables support.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/net/netfilter/ipv4/nf_synproxy_ipv4.h |  42 ++
 net/ipv4/netfilter/ipt_SYNPROXY.c             | 394 +-----------------
 net/ipv4/netfilter/nf_synproxy_ipv4.c         | 393 +++++++++++++++++
 3 files changed, 441 insertions(+), 388 deletions(-)
 create mode 100644 include/net/netfilter/ipv4/nf_synproxy_ipv4.h
 create mode 100644 net/ipv4/netfilter/nf_synproxy_ipv4.c

diff --git a/include/net/netfilter/ipv4/nf_synproxy_ipv4.h b/include/net/netfilter/ipv4/nf_synproxy_ipv4.h
new file mode 100644
index 000000000000..3a8dff2e58e7
--- /dev/null
+++ b/include/net/netfilter/ipv4/nf_synproxy_ipv4.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NF_SYNPROXY_IPV4_H
+#define _NF_SYNPROXY_IPV4_H
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <net/tcp.h>
+
+#include <net/netfilter/nf_conntrack_seqadj.h>
+#include <net/netfilter/nf_conntrack_synproxy.h>
+
+void synproxy_send_client_synack(struct net *net, const struct sk_buff *skb,
+				 const struct tcphdr *th,
+				 const struct synproxy_options *opts);
+
+bool synproxy_recv_client_ack(struct net *net,
+			      const struct sk_buff *skb,
+			      const struct tcphdr *th,
+			      struct synproxy_options *opts, u32 recv_seq);
+
+unsigned int ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
+				const struct nf_hook_state *nhs);
+int nf_synproxy_ipv4_init(struct synproxy_net *snet, struct net *net);
+void nf_synproxy_ipv4_fini(struct synproxy_net *snet, struct net *net);
+
+/* Hook operations used by {ip,nf}tables SYNPROXY support */
+const struct nf_hook_ops ipv4_synproxy_ops[] = {
+	{
+		.hook		= ipv4_synproxy_hook,
+		.pf		= NFPROTO_IPV4,
+		.hooknum	= NF_INET_LOCAL_IN,
+		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM - 1,
+	},
+	{
+		.hook		= ipv4_synproxy_hook,
+		.pf		= NFPROTO_IPV4,
+		.hooknum	= NF_INET_POST_ROUTING,
+		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM - 1,
+	},
+};
+
+#endif /* _NF_SYNPROXY_IPV4_H */
diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYNPROXY.c
index 690b17ef6a44..eb14c3bcbc15 100644
--- a/net/ipv4/netfilter/ipt_SYNPROXY.c
+++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
@@ -6,258 +6,11 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <net/tcp.h>
-
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_SYNPROXY.h>
-#include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_conntrack_seqadj.h>
-#include <net/netfilter/nf_conntrack_synproxy.h>
-#include <net/netfilter/nf_conntrack_ecache.h>
-
-static struct iphdr *
-synproxy_build_ip(struct net *net, struct sk_buff *skb, __be32 saddr,
-		  __be32 daddr)
-{
-	struct iphdr *iph;
-
-	skb_reset_network_header(skb);
-	iph = skb_put(skb, sizeof(*iph));
-	iph->version	= 4;
-	iph->ihl	= sizeof(*iph) / 4;
-	iph->tos	= 0;
-	iph->id		= 0;
-	iph->frag_off	= htons(IP_DF);
-	iph->ttl	= net->ipv4.sysctl_ip_default_ttl;
-	iph->protocol	= IPPROTO_TCP;
-	iph->check	= 0;
-	iph->saddr	= saddr;
-	iph->daddr	= daddr;
-
-	return iph;
-}
-
-static void
-synproxy_send_tcp(struct net *net,
-		  const struct sk_buff *skb, struct sk_buff *nskb,
-		  struct nf_conntrack *nfct, enum ip_conntrack_info ctinfo,
-		  struct iphdr *niph, struct tcphdr *nth,
-		  unsigned int tcp_hdr_size)
-{
-	nth->check = ~tcp_v4_check(tcp_hdr_size, niph->saddr, niph->daddr, 0);
-	nskb->ip_summed   = CHECKSUM_PARTIAL;
-	nskb->csum_start  = (unsigned char *)nth - nskb->head;
-	nskb->csum_offset = offsetof(struct tcphdr, check);
-
-	skb_dst_set_noref(nskb, skb_dst(skb));
-	nskb->protocol = htons(ETH_P_IP);
-	if (ip_route_me_harder(net, nskb, RTN_UNSPEC))
-		goto free_nskb;
-
-	if (nfct) {
-		nf_ct_set(nskb, (struct nf_conn *)nfct, ctinfo);
-		nf_conntrack_get(nfct);
-	}
-
-	ip_local_out(net, nskb->sk, nskb);
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
-	struct iphdr *iph, *niph;
-	struct tcphdr *nth;
-	unsigned int tcp_hdr_size;
-	u16 mss = opts->mss;
-
-	iph = ip_hdr(skb);
-
-	tcp_hdr_size = sizeof(*nth) + synproxy_options_size(opts);
-	nskb = alloc_skb(sizeof(*niph) + tcp_hdr_size + MAX_TCP_HEADER,
-			 GFP_ATOMIC);
-	if (nskb == NULL)
-		return;
-	skb_reserve(nskb, MAX_TCP_HEADER);
-
-	niph = synproxy_build_ip(net, nskb, iph->daddr, iph->saddr);
-
-	skb_reset_transport_header(nskb);
-	nth = skb_put(nskb, tcp_hdr_size);
-	nth->source	= th->dest;
-	nth->dest	= th->source;
-	nth->seq	= htonl(__cookie_v4_init_sequence(iph, th, &mss));
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
-
-static void
-synproxy_send_server_syn(struct net *net,
-			 const struct sk_buff *skb, const struct tcphdr *th,
-			 const struct synproxy_options *opts, u32 recv_seq)
-{
-	struct synproxy_net *snet = synproxy_pernet(net);
-	struct sk_buff *nskb;
-	struct iphdr *iph, *niph;
-	struct tcphdr *nth;
-	unsigned int tcp_hdr_size;
-
-	iph = ip_hdr(skb);
-
-	tcp_hdr_size = sizeof(*nth) + synproxy_options_size(opts);
-	nskb = alloc_skb(sizeof(*niph) + tcp_hdr_size + MAX_TCP_HEADER,
-			 GFP_ATOMIC);
-	if (nskb == NULL)
-		return;
-	skb_reserve(nskb, MAX_TCP_HEADER);
-
-	niph = synproxy_build_ip(net, nskb, iph->saddr, iph->daddr);
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
-	struct iphdr *iph, *niph;
-	struct tcphdr *nth;
-	unsigned int tcp_hdr_size;
-
-	iph = ip_hdr(skb);
-
-	tcp_hdr_size = sizeof(*nth) + synproxy_options_size(opts);
-	nskb = alloc_skb(sizeof(*niph) + tcp_hdr_size + MAX_TCP_HEADER,
-			 GFP_ATOMIC);
-	if (nskb == NULL)
-		return;
-	skb_reserve(nskb, MAX_TCP_HEADER);
-
-	niph = synproxy_build_ip(net, nskb, iph->daddr, iph->saddr);
 
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
-	struct iphdr *iph, *niph;
-	struct tcphdr *nth;
-	unsigned int tcp_hdr_size;
-
-	iph = ip_hdr(skb);
-
-	tcp_hdr_size = sizeof(*nth) + synproxy_options_size(opts);
-	nskb = alloc_skb(sizeof(*niph) + tcp_hdr_size + MAX_TCP_HEADER,
-			 GFP_ATOMIC);
-	if (nskb == NULL)
-		return;
-	skb_reserve(nskb, MAX_TCP_HEADER);
-
-	niph = synproxy_build_ip(net, nskb, iph->saddr, iph->daddr);
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
-	mss = __cookie_v4_check(ip_hdr(skb), th, ntohl(th->ack_seq) - 1);
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
+#include <net/netfilter/ipv4/nf_synproxy_ipv4.h>
 
 static unsigned int
 synproxy_tg4(struct sk_buff *skb, const struct xt_action_param *par)
@@ -309,135 +62,6 @@ synproxy_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	return XT_CONTINUE;
 }
 
-static unsigned int ipv4_synproxy_hook(void *priv,
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
-	unsigned int thoff;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	if (ct == NULL)
-		return NF_ACCEPT;
-
-	synproxy = nfct_synproxy(ct);
-	if (synproxy == NULL)
-		return NF_ACCEPT;
-
-	if (nf_is_loopback_packet(skb) ||
-	    ip_hdr(skb)->protocol != IPPROTO_TCP)
-		return NF_ACCEPT;
-
-	thoff = ip_hdrlen(skb);
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
-static const struct nf_hook_ops ipv4_synproxy_ops[] = {
-	{
-		.hook		= ipv4_synproxy_hook,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_LOCAL_IN,
-		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM - 1,
-	},
-	{
-		.hook		= ipv4_synproxy_hook,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_POST_ROUTING,
-		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM - 1,
-	},
-};
-
 static int synproxy_tg4_check(const struct xt_tgchk_param *par)
 {
 	struct synproxy_net *snet = synproxy_pernet(par->net);
@@ -452,13 +76,10 @@ static int synproxy_tg4_check(const struct xt_tgchk_param *par)
 	if (err)
 		return err;
 
-	if (snet->hook_ref4 == 0) {
-		err = nf_register_net_hooks(par->net, ipv4_synproxy_ops,
-					    ARRAY_SIZE(ipv4_synproxy_ops));
-		if (err) {
-			nf_ct_netns_put(par->net, par->family);
-			return err;
-		}
+	err = nf_synproxy_ipv4_init(snet, par->net);
+	if (err) {
+		nf_ct_netns_put(par->net, par->family);
+		return err;
 	}
 
 	snet->hook_ref4++;
@@ -469,10 +90,7 @@ static void synproxy_tg4_destroy(const struct xt_tgdtor_param *par)
 {
 	struct synproxy_net *snet = synproxy_pernet(par->net);
 
-	snet->hook_ref4--;
-	if (snet->hook_ref4 == 0)
-		nf_unregister_net_hooks(par->net, ipv4_synproxy_ops,
-					ARRAY_SIZE(ipv4_synproxy_ops));
+	nf_synproxy_ipv4_fini(snet, par->net);
 	nf_ct_netns_put(par->net, par->family);
 }
 
diff --git a/net/ipv4/netfilter/nf_synproxy_ipv4.c b/net/ipv4/netfilter/nf_synproxy_ipv4.c
new file mode 100644
index 000000000000..40c7d7f92ab1
--- /dev/null
+++ b/net/ipv4/netfilter/nf_synproxy_ipv4.c
@@ -0,0 +1,393 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
+#include <net/netfilter/ipv4/nf_synproxy_ipv4.h>
+
+#include <linux/netfilter/nf_SYNPROXY.h>
+
+static struct iphdr *
+synproxy_build_ip(struct net *net, struct sk_buff *skb, __be32 saddr,
+		  __be32 daddr)
+{
+	struct iphdr *iph;
+
+	skb_reset_network_header(skb);
+	iph = skb_put(skb, sizeof(*iph));
+	iph->version	= 4;
+	iph->ihl	= sizeof(*iph) / 4;
+	iph->tos	= 0;
+	iph->id		= 0;
+	iph->frag_off	= htons(IP_DF);
+	iph->ttl	= net->ipv4.sysctl_ip_default_ttl;
+	iph->protocol	= IPPROTO_TCP;
+	iph->check	= 0;
+	iph->saddr	= saddr;
+	iph->daddr	= daddr;
+
+	return iph;
+}
+
+static void
+synproxy_send_tcp(struct net *net,
+		  const struct sk_buff *skb, struct sk_buff *nskb,
+		  struct nf_conntrack *nfct, enum ip_conntrack_info ctinfo,
+		  struct iphdr *niph, struct tcphdr *nth,
+		  unsigned int tcp_hdr_size)
+{
+	nth->check = ~tcp_v4_check(tcp_hdr_size, niph->saddr, niph->daddr, 0);
+	nskb->ip_summed   = CHECKSUM_PARTIAL;
+	nskb->csum_start  = (unsigned char *)nth - nskb->head;
+	nskb->csum_offset = offsetof(struct tcphdr, check);
+
+	skb_dst_set_noref(nskb, skb_dst(skb));
+	nskb->protocol = htons(ETH_P_IP);
+	if (ip_route_me_harder(net, nskb, RTN_UNSPEC))
+		goto free_nskb;
+
+	if (nfct) {
+		nf_ct_set(nskb, (struct nf_conn *)nfct, ctinfo);
+		nf_conntrack_get(nfct);
+	}
+
+	ip_local_out(net, nskb->sk, nskb);
+	return;
+
+free_nskb:
+	kfree_skb(nskb);
+}
+
+void
+synproxy_send_client_synack(struct net *net,
+			    const struct sk_buff *skb, const struct tcphdr *th,
+			    const struct synproxy_options *opts)
+{
+	struct sk_buff *nskb;
+	struct iphdr *iph, *niph;
+	struct tcphdr *nth;
+	unsigned int tcp_hdr_size;
+	u16 mss = opts->mss;
+
+	iph = ip_hdr(skb);
+
+	tcp_hdr_size = sizeof(*nth) + synproxy_options_size(opts);
+	nskb = alloc_skb(sizeof(*niph) + tcp_hdr_size + MAX_TCP_HEADER,
+			 GFP_ATOMIC);
+	if (nskb == NULL)
+		return;
+	skb_reserve(nskb, MAX_TCP_HEADER);
+
+	niph = synproxy_build_ip(net, nskb, iph->daddr, iph->saddr);
+
+	skb_reset_transport_header(nskb);
+	nth = skb_put(nskb, tcp_hdr_size);
+	nth->source	= th->dest;
+	nth->dest	= th->source;
+	nth->seq	= htonl(__cookie_v4_init_sequence(iph, th, &mss));
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
+EXPORT_SYMBOL_GPL(synproxy_send_client_synack);
+
+static void
+synproxy_send_server_syn(struct net *net,
+			 const struct sk_buff *skb, const struct tcphdr *th,
+			 const struct synproxy_options *opts, u32 recv_seq)
+{
+	struct synproxy_net *snet = synproxy_pernet(net);
+	struct sk_buff *nskb;
+	struct iphdr *iph, *niph;
+	struct tcphdr *nth;
+	unsigned int tcp_hdr_size;
+
+	iph = ip_hdr(skb);
+
+	tcp_hdr_size = sizeof(*nth) + synproxy_options_size(opts);
+	nskb = alloc_skb(sizeof(*niph) + tcp_hdr_size + MAX_TCP_HEADER,
+			 GFP_ATOMIC);
+	if (nskb == NULL)
+		return;
+	skb_reserve(nskb, MAX_TCP_HEADER);
+
+	niph = synproxy_build_ip(net, nskb, iph->saddr, iph->daddr);
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
+	struct iphdr *iph, *niph;
+	struct tcphdr *nth;
+	unsigned int tcp_hdr_size;
+
+	iph = ip_hdr(skb);
+
+	tcp_hdr_size = sizeof(*nth) + synproxy_options_size(opts);
+	nskb = alloc_skb(sizeof(*niph) + tcp_hdr_size + MAX_TCP_HEADER,
+			 GFP_ATOMIC);
+	if (nskb == NULL)
+		return;
+	skb_reserve(nskb, MAX_TCP_HEADER);
+
+	niph = synproxy_build_ip(net, nskb, iph->daddr, iph->saddr);
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
+	struct iphdr *iph, *niph;
+	struct tcphdr *nth;
+	unsigned int tcp_hdr_size;
+
+	iph = ip_hdr(skb);
+
+	tcp_hdr_size = sizeof(*nth) + synproxy_options_size(opts);
+	nskb = alloc_skb(sizeof(*niph) + tcp_hdr_size + MAX_TCP_HEADER,
+			 GFP_ATOMIC);
+	if (nskb == NULL)
+		return;
+	skb_reserve(nskb, MAX_TCP_HEADER);
+
+	niph = synproxy_build_ip(net, nskb, iph->saddr, iph->daddr);
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
+synproxy_recv_client_ack(struct net *net,
+			 const struct sk_buff *skb, const struct tcphdr *th,
+			 struct synproxy_options *opts, u32 recv_seq)
+{
+	struct synproxy_net *snet = synproxy_pernet(net);
+	int mss;
+
+	mss = __cookie_v4_check(ip_hdr(skb), th, ntohl(th->ack_seq) - 1);
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
+EXPORT_SYMBOL_GPL(synproxy_recv_client_ack);
+
+unsigned int
+ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
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
+	unsigned int thoff;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct == NULL)
+		return NF_ACCEPT;
+
+	synproxy = nfct_synproxy(ct);
+	if (synproxy == NULL)
+		return NF_ACCEPT;
+
+	if (nf_is_loopback_packet(skb) ||
+	    ip_hdr(skb)->protocol != IPPROTO_TCP)
+		return NF_ACCEPT;
+
+	thoff = ip_hdrlen(skb);
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
+			if (synproxy_recv_client_ack(net, skb, th, &opts,
+						     ntohl(th->seq) + 1)) {
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
+EXPORT_SYMBOL_GPL(ipv4_synproxy_hook);
+
+int nf_synproxy_ipv4_init(struct synproxy_net *snet, struct net *net)
+{
+	int err;
+
+        if (snet->hook_ref4 == 0) {
+                err = nf_register_net_hooks(net, ipv4_synproxy_ops,
+                                            ARRAY_SIZE(ipv4_synproxy_ops));
+                if (err)
+                        return err;
+        }
+
+        snet->hook_ref4++;
+	return err;
+}
+EXPORT_SYMBOL_GPL(nf_synproxy_ipv4_init);
+
+void nf_synproxy_ipv4_fini(struct synproxy_net *snet, struct net *net)
+{
+        snet->hook_ref4--;
+        if (snet->hook_ref4 == 0)
+                nf_unregister_net_hooks(net, ipv4_synproxy_ops,
+                                        ARRAY_SIZE(ipv4_synproxy_ops));
+}
+EXPORT_SYMBOL_GPL(nf_synproxy_ipv4_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Fernando Fernandez <ffmancera@riseup.net>");
-- 
2.20.1

