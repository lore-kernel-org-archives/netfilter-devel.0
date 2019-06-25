Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60512C48BD5
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 05:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 381E620449
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 05:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbfFYFrZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jun 2019 01:47:25 -0400
Received: from mx2.labristeknoloji.com ([91.93.128.220]:49496 "EHLO
        mx2.labristeknoloji.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbfFYFrZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jun 2019 01:47:25 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jun 2019 01:47:22 EDT
From:   Ibrahim Ercan <ibrahim.ercan@labristeknoloji.com>
To:     netfilter-devel@vger.kernel.org, fw@strlen.de,
        ibrahim.metu@gmail.com
Subject: [PATCH v2] netfilter: synproxy: erroneous TCP mss option fixed.
Date:   Tue, 25 Jun 2019 08:42:04 +0300
Message-Id: <1561441324-19193-1-git-send-email-ibrahim.ercan@labristeknoloji.com>
In-Reply-To: <CAK6Qs9k_bdU9ZL4WRXBGYdtfnP_qhot0hzC=uMQG6C_pkz3+2w@mail.gmail.com>
References: <CAK6Qs9k_bdU9ZL4WRXBGYdtfnP_qhot0hzC=uMQG6C_pkz3+2w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Syn proxy isn't setting mss value correctly on client syn-ack packet.
It was sending same mss value with client send instead of the value user set in iptables rule. This patch fix that wrong behavior by passing client mss information to synproxy_send_client_synack correctly.

Signed-off-by: Ibrahim Ercan <ibrahim.ercan@labristeknoloji.com>
---
 net/ipv4/netfilter/ipt_SYNPROXY.c  | 9 ++++++---
 net/ipv6/netfilter/ip6t_SYNPROXY.c | 9 ++++++---
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYNPROXY.c
index 64d9563..e0bd504 100644
--- a/net/ipv4/netfilter/ipt_SYNPROXY.c
+++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
@@ -69,13 +69,13 @@ synproxy_send_tcp(struct net *net,
 static void
 synproxy_send_client_synack(struct net *net,
 			    const struct sk_buff *skb, const struct tcphdr *th,
-			    const struct synproxy_options *opts)
+			    const struct synproxy_options *opts, const u16 client_mssinfo)
 {
 	struct sk_buff *nskb;
 	struct iphdr *iph, *niph;
 	struct tcphdr *nth;
 	unsigned int tcp_hdr_size;
-	u16 mss = opts->mss;
+	u16 mss = client_mssinfo;
 
 	iph = ip_hdr(skb);
 
@@ -264,6 +264,7 @@ synproxy_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	struct synproxy_net *snet = synproxy_pernet(net);
 	struct synproxy_options opts = {};
 	struct tcphdr *th, _th;
+	u16 client_mssinfo;
 
 	if (nf_ip_checksum(skb, xt_hooknum(par), par->thoff, IPPROTO_TCP))
 		return NF_DROP;
@@ -283,6 +284,8 @@ synproxy_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 			opts.options |= XT_SYNPROXY_OPT_ECN;
 
 		opts.options &= info->options;
+		client_mssinfo = opts.mss;
+		opts.mss = info->mss;
 		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
 			synproxy_init_timestamp_cookie(info, &opts);
 		else
@@ -290,7 +293,7 @@ synproxy_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 					  XT_SYNPROXY_OPT_SACK_PERM |
 					  XT_SYNPROXY_OPT_ECN);
 
-		synproxy_send_client_synack(net, skb, th, &opts);
+		synproxy_send_client_synack(net, skb, th, &opts, client_mssinfo);
 		consume_skb(skb);
 		return NF_STOLEN;
 	} else if (th->ack && !(th->fin || th->rst || th->syn)) {
diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index 41325d5..676de53 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -83,13 +83,13 @@ synproxy_send_tcp(struct net *net,
 static void
 synproxy_send_client_synack(struct net *net,
 			    const struct sk_buff *skb, const struct tcphdr *th,
-			    const struct synproxy_options *opts)
+			    const struct synproxy_options *opts, const u16 client_mssinfo)
 {
 	struct sk_buff *nskb;
 	struct ipv6hdr *iph, *niph;
 	struct tcphdr *nth;
 	unsigned int tcp_hdr_size;
-	u16 mss = opts->mss;
+	u16 mss = client_mssinfo;
 
 	iph = ipv6_hdr(skb);
 
@@ -278,6 +278,7 @@ synproxy_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	struct synproxy_net *snet = synproxy_pernet(net);
 	struct synproxy_options opts = {};
 	struct tcphdr *th, _th;
+	u16 client_mssinfo;
 
 	if (nf_ip6_checksum(skb, xt_hooknum(par), par->thoff, IPPROTO_TCP))
 		return NF_DROP;
@@ -297,6 +298,8 @@ synproxy_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 			opts.options |= XT_SYNPROXY_OPT_ECN;
 
 		opts.options &= info->options;
+		client_mssinfo = opts.mss;
+		opts.mss = info->mss;
 		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
 			synproxy_init_timestamp_cookie(info, &opts);
 		else
@@ -304,7 +307,7 @@ synproxy_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 					  XT_SYNPROXY_OPT_SACK_PERM |
 					  XT_SYNPROXY_OPT_ECN);
 
-		synproxy_send_client_synack(net, skb, th, &opts);
+		synproxy_send_client_synack(net, skb, th, &opts, client_mssinfo);
 		consume_skb(skb);
 		return NF_STOLEN;
 
-- 
2.7.4

