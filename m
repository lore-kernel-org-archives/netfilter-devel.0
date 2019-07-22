Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A8BC76188
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 12:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBBAE218DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 12:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbfGVMGc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 08:06:32 -0400
Received: from mx2.labristeknoloji.com ([91.93.128.220]:33976 "EHLO
        mx2.labristeknoloji.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728266AbfGVMGc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 08:06:32 -0400
From:   Ibrahim Ercan <ibrahim.ercan@labristeknoloji.com>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, ffmancera@riseup.net, pablo@netfilter.org,
        ibrahim.metu@gmail.com,
        Ibrahim Ercan <ibrahim.ercan@labrisnetworks.com>
Subject: [PATCH v3] netfilter: synproxy: erroneous TCP mss option fixed.
Date:   Mon, 22 Jul 2019 15:06:26 +0300
Message-Id: <1563797186-27042-1-git-send-email-ibrahim.ercan@labristeknoloji.com>
In-Reply-To: <CAK6Qs9mp7E3Wr4Zo8mLgsbLMwZRCaQoy=3nRx3XDJP4mcgNSEA@mail.gmail.com>
References: <CAK6Qs9mp7E3Wr4Zo8mLgsbLMwZRCaQoy=3nRx3XDJP4mcgNSEA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

synproxy_options has been modified as recommended by Pablo.

Signed-off-by: Ibrahim Ercan <ibrahim.ercan@labrisnetworks.com>
---
 include/net/netfilter/nf_conntrack_synproxy.h | 3 ++-
 net/ipv4/netfilter/ipt_SYNPROXY.c             | 6 ++++--
 net/ipv6/netfilter/ip6t_SYNPROXY.c            | 6 ++++--
 net/netfilter/nf_synproxy_core.c              | 4 ++--
 4 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_synproxy.h b/include/net/netfilter/nf_conntrack_synproxy.h
index 2c7559a..d4b44b3 100644
--- a/include/net/netfilter/nf_conntrack_synproxy.h
+++ b/include/net/netfilter/nf_conntrack_synproxy.h
@@ -66,7 +66,8 @@ static inline struct synproxy_net *synproxy_pernet(struct net *net)
 struct synproxy_options {
 	u8				options;
 	u8				wscale;
-	u16				mss;
+	u16				mss_option;
+	u16				mss_encode;
 	u32				tsval;
 	u32				tsecr;
 };
diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYNPROXY.c
index 64d9563..6e230a6 100644
--- a/net/ipv4/netfilter/ipt_SYNPROXY.c
+++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
@@ -75,7 +75,7 @@ synproxy_send_client_synack(struct net *net,
 	struct iphdr *iph, *niph;
 	struct tcphdr *nth;
 	unsigned int tcp_hdr_size;
-	u16 mss = opts->mss;
+	u16 mss = opts->mss_encode;
 
 	iph = ip_hdr(skb);
 
@@ -246,7 +246,7 @@ synproxy_recv_client_ack(struct net *net,
 	}
 
 	this_cpu_inc(snet->stats->cookie_valid);
-	opts->mss = mss;
+	opts->mss_option = mss;
 	opts->options |= XT_SYNPROXY_OPT_MSS;
 
 	if (opts->options & XT_SYNPROXY_OPT_TIMESTAMP)
@@ -283,6 +283,8 @@ synproxy_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 			opts.options |= XT_SYNPROXY_OPT_ECN;
 
 		opts.options &= info->options;
+		opts.mss_encode = opts.mss_option;
+		opts.mss_option = info->mss;
 		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
 			synproxy_init_timestamp_cookie(info, &opts);
 		else
diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index 41325d5..36313b0 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -89,7 +89,7 @@ synproxy_send_client_synack(struct net *net,
 	struct ipv6hdr *iph, *niph;
 	struct tcphdr *nth;
 	unsigned int tcp_hdr_size;
-	u16 mss = opts->mss;
+	u16 mss = opts->mss_encode;
 
 	iph = ipv6_hdr(skb);
 
@@ -260,7 +260,7 @@ synproxy_recv_client_ack(struct net *net,
 	}
 
 	this_cpu_inc(snet->stats->cookie_valid);
-	opts->mss = mss;
+	opts->mss_option = mss;
 	opts->options |= XT_SYNPROXY_OPT_MSS;
 
 	if (opts->options & XT_SYNPROXY_OPT_TIMESTAMP)
@@ -297,6 +297,8 @@ synproxy_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 			opts.options |= XT_SYNPROXY_OPT_ECN;
 
 		opts.options &= info->options;
+		opts.mss_encode = opts.mss_option;
+		opts.mss_option = info->mss;
 		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
 			synproxy_init_timestamp_cookie(info, &opts);
 		else
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 8ce74ed..74ff90a 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -56,7 +56,7 @@ synproxy_parse_options(const struct sk_buff *skb, unsigned int doff,
 			switch (opcode) {
 			case TCPOPT_MSS:
 				if (opsize == TCPOLEN_MSS) {
-					opts->mss = get_unaligned_be16(ptr);
+					opts->mss_option = get_unaligned_be16(ptr);
 					opts->options |= XT_SYNPROXY_OPT_MSS;
 				}
 				break;
@@ -115,7 +115,7 @@ synproxy_build_options(struct tcphdr *th, const struct synproxy_options *opts)
 	if (options & XT_SYNPROXY_OPT_MSS)
 		*ptr++ = htonl((TCPOPT_MSS << 24) |
 			       (TCPOLEN_MSS << 16) |
-			       opts->mss);
+			       opts->mss_option);
 
 	if (options & XT_SYNPROXY_OPT_TIMESTAMP) {
 		if (options & XT_SYNPROXY_OPT_SACK_PERM)
-- 
2.7.4

