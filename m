Return-Path: <SRS0=eCuo=7L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 212D6C433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 11:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E63BA2075A
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 11:03:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B7qfvGiN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgE2LDd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 May 2020 07:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgE2LDd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 May 2020 07:03:33 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB2FC03E969
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2020 04:03:32 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id f7so1652658ejq.6
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2020 04:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=kwjqPPGDPEIjzUpWGvcx3AwoYvYpEqj6y7BkMcQE8gg=;
        b=B7qfvGiN0av5rnb4gdcD1JQYJADt28Y4JVbSktf4hmsVVriZYEw089oLWOxXbk3XQh
         OIyslVW8HutGyvuq+Q4prosxDtVCLe8lSU0Iy1HYXznRBuc67HUxwtuzOrc0n8iSRz5q
         FzskjFRqTQ30ExjCrIAPMSYCyyzsXWzXa0L7rdJRDiGgGru+LjaBVf8umEL+3JwvBQn6
         9LPtO0d/rS11Oh00g9nor6aeusR1s76vZPnWnij2F+aEZAVEoL4rmFoFLxW6XBiudW/S
         Za8dsSN+DgiLL+d0j9T1I7jTv+2RKgnBMeC/Kzil6aVcXAVNgOD9AmQ0Tci9GB0wLjV/
         Ntnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=kwjqPPGDPEIjzUpWGvcx3AwoYvYpEqj6y7BkMcQE8gg=;
        b=Sv6SkqGTriPLv0hGGGvMLerbU5DfvqpW/OcfxYyOgvG/iBV20Vwd4DDRs/5pruPV/L
         C0+rukHwfbZPuFUkMaHdi3zHDbbOdygEIMrrcLeB+pz9Ljrs7hjTuz9dcfQTO3yRDQBZ
         5chJAYmxB88hKoxRpmYmeeszvA2TiFugd43cCrwza+zAwuf++sPlRTj1youNVcyh5tb+
         8OLQp/rIeuDA/s9OWJhBjNLaBc+GSRsiQ4ZcJn4eLruq29M4TUQV62chqwRoUdhO5BBj
         z5lo8Rqm0/NLRj3kEOKFh5O97XeXOJp9qRGoIF1mn223qcIGQGhD5l9ZCSsyBaGhb3KJ
         VbTw==
X-Gm-Message-State: AOAM530ruAJH5RAtAj2L+9tvPSxoXMKxNclefP2C9m+lIWMzEhIcyD2S
        LHu0v4FQluNA44+1RDiOExcc2znFE91lGw==
X-Google-Smtp-Source: ABdhPJzcvLFno+8mypjAYFvuGEiDK48XL1oKBOplSmO0OF61T3krOIcBQIvb62IFSDAcu84nr4Pj2w==
X-Received: by 2002:a17:906:6a1b:: with SMTP id o27mr6608857ejr.271.1590750211223;
        Fri, 29 May 2020 04:03:31 -0700 (PDT)
Received: from nevthink ([91.126.71.247])
        by smtp.gmail.com with ESMTPSA id fi9sm7158489ejb.5.2020.05.29.04.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 04:03:30 -0700 (PDT)
Date:   Fri, 29 May 2020 13:03:28 +0200
From:   Laura Garcia Liebana <nevola@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, devel@zevenet.com
Subject: [PATCH v2 nf-next] netfilter: introduce support for reject at
 prerouting stage
Message-ID: <20200529110328.GA20367@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

REJECT statement can be only used in INPUT, FORWARD and OUTPUT
chains. This patch adds support of REJECT, both icmp and tcp
reset, at PREROUTING stage.

The need for this patch comes from the requirement of some
forwarding devices to reject traffic before the natting and
routing decisions.

The main use case is to be able to send a graceful termination
to legitimate clients that, under any circumstances, the NATed
endpoints are not available. This option allows clients to
decide either to perform a reconnection or manage the error in
their side, instead of just dropping the connection and let
them die due to timeout.

It is supported ipv4, ipv6 and inet families for nft
infrastructure.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
v2:
 - Add error handling in nf_route(), suggested by Florian Westphal.
 - Add use case description, suggested by Reindl Harald.

 net/ipv4/netfilter/nf_reject_ipv4.c | 22 ++++++++++++++++++++++
 net/ipv6/netfilter/nf_reject_ipv6.c | 27 +++++++++++++++++++++++++++
 net/netfilter/nft_reject.c          |  3 ++-
 3 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 2361fdac2c43..b5b7633d9433 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -96,6 +96,22 @@ void nf_reject_ip_tcphdr_put(struct sk_buff *nskb, const struct sk_buff *oldskb,
 }
 EXPORT_SYMBOL_GPL(nf_reject_ip_tcphdr_put);
 
+static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
+{
+	struct dst_entry *dst = NULL;
+	struct flowi fl;
+	struct flowi4 *fl4 = &fl.u.ip4;
+
+	memset(fl4, 0, sizeof(*fl4));
+	fl4->daddr = ip_hdr(skb_in)->saddr;
+	nf_route(dev_net(skb_in->dev), &dst, &fl, false, AF_INET);
+	if (!dst)
+		return -1;
+
+	skb_dst_set(skb_in, dst);
+	return 0;
+}
+
 /* Send RST reply */
 void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
 {
@@ -109,6 +125,9 @@ void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
 	if (!oth)
 		return;
 
+	if (hook == NF_INET_PRE_ROUTING && nf_reject_fill_skb_dst(oldskb))
+		return;
+
 	if (skb_rtable(oldskb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
 		return;
 
@@ -175,6 +194,9 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 	if (iph->frag_off & htons(IP_OFFSET))
 		return;
 
+	if (hook == NF_INET_PRE_ROUTING && nf_reject_fill_skb_dst(skb_in))
+		return;
+
 	if (skb_csum_unnecessary(skb_in) || !nf_reject_verify_csum(proto)) {
 		icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
 		return;
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 5fae66f66671..df1ac768cadc 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -126,6 +126,22 @@ void nf_reject_ip6_tcphdr_put(struct sk_buff *nskb,
 }
 EXPORT_SYMBOL_GPL(nf_reject_ip6_tcphdr_put);
 
+static int nf_reject6_fill_skb_dst(struct sk_buff *skb_in)
+{
+	struct dst_entry *dst = NULL;
+	struct flowi fl;
+	struct flowi6 *fl6 = &fl.u.ip6;
+
+	memset(fl6, 0, sizeof(*fl6));
+	fl6->daddr = ipv6_hdr(skb_in)->saddr;
+	nf_route(dev_net(skb_in->dev), &dst, &fl, false, AF_INET6);
+	if (!dst)
+		return -1;
+
+	skb_dst_set(skb_in, dst);
+	return 0;
+}
+
 void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook)
 {
 	struct net_device *br_indev __maybe_unused;
@@ -154,6 +170,14 @@ void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook)
 	fl6.daddr = oip6h->saddr;
 	fl6.fl6_sport = otcph->dest;
 	fl6.fl6_dport = otcph->source;
+
+	if (hook == NF_INET_PRE_ROUTING) {
+		nf_route(dev_net(oldskb->dev), &dst, flowi6_to_flowi(&fl6), false, AF_INET6);
+		if (!dst)
+			return;
+		skb_dst_set(oldskb, dst);
+	}
+
 	fl6.flowi6_oif = l3mdev_master_ifindex(skb_dst(oldskb)->dev);
 	fl6.flowi6_mark = IP6_REPLY_MARK(net, oldskb->mark);
 	security_skb_classify_flow(oldskb, flowi6_to_flowi(&fl6));
@@ -245,6 +269,9 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
 		skb_in->dev = net->loopback_dev;
 
+	if (hooknum == NF_INET_PRE_ROUTING && nf_reject6_fill_skb_dst(skb_in))
+		return;
+
 	icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0);
 }
 EXPORT_SYMBOL_GPL(nf_send_unreach6);
diff --git a/net/netfilter/nft_reject.c b/net/netfilter/nft_reject.c
index 00f865fb80ca..5eac28269bdb 100644
--- a/net/netfilter/nft_reject.c
+++ b/net/netfilter/nft_reject.c
@@ -30,7 +30,8 @@ int nft_reject_validate(const struct nft_ctx *ctx,
 	return nft_chain_validate_hooks(ctx->chain,
 					(1 << NF_INET_LOCAL_IN) |
 					(1 << NF_INET_FORWARD) |
-					(1 << NF_INET_LOCAL_OUT));
+					(1 << NF_INET_LOCAL_OUT) |
+					(1 << NF_INET_PRE_ROUTING));
 }
 EXPORT_SYMBOL_GPL(nft_reject_validate);
 
-- 
2.20.1

