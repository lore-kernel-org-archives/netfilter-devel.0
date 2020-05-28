Return-Path: <SRS0=RvX8=7K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7664C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 May 2020 17:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5BA520721
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 May 2020 17:14:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iGvKoeA2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405353AbgE1ROq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 May 2020 13:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405335AbgE1ROp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 May 2020 13:14:45 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018E8C08C5C6
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2020 10:14:44 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id m21so662157eds.13
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2020 10:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=Zf6fm9OIAD+PGWfxME0fRwRsAtlULjcGCcKodAbMm1Q=;
        b=iGvKoeA25Ud6HIb+YbB/ek2LXQueJAJX0pi3ra0iNE0n7a2vuWExZjN5JIuz4KoG5L
         N9L46pRpSboo2LpKVovulUJUdVJSClSiSp8O2UtaHcqXDcsy8f6aHD/AvI6ULK7bsedM
         2SXV9faD7YnEHAUUeICG/JY0xSCWPUZnxy2t2Ka8ddS43Xgou/zy+ge4oBg7L+AjBV+q
         QK2ZFzt8k57Cjgxr0jKyyUB1EiSrr+GOweykhLRMwFpyH0iUdx9wcRTDRfjIPOoZQoKI
         /ZKHVpRJhsKV4sc8oTVhiIqaXX7BmnorFO6n4WstlQp8fMpyZ/yvIakah9+1uczxMNnz
         g87Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Zf6fm9OIAD+PGWfxME0fRwRsAtlULjcGCcKodAbMm1Q=;
        b=Ye15WvIc1NwKobQJgCEfZPdpY5zRcmhs+vaXPxqWdQZyeQgEliCYiBCiZQc4VNFnTn
         xsIBSjUvYFznSCw03goQPA33/SMVjJDU+B93BiUpRZmbsShMBJGBfadGENBdDC86Ndw4
         edbSv7ln+g5tUOs/TFRJ+rry+w3H3/VckEoMsMjNQPdUmFqX6RB9YFKptmked5mV2h8W
         8+RO4A+Bk9DTl5rn4oTgp2Uu9XPW4SGPzO1V2U2UysnHMaqVRbfGLXx/5sbiKt7ekl2x
         ZMXYmGsZ4l5eEx3aHeraJ/tWRAFFQpHjysl98ASCr/Bsm9zwgAmdGr7YsiTFuzLX3zwK
         /BCw==
X-Gm-Message-State: AOAM5314hCIQQs7WYLciIbHhg3Y8UIDYxD5Bhnp7oH3yTK3o7KPBerZR
        sh467FxoDmLRxwmeyJwKNMGlJBL2PWQ=
X-Google-Smtp-Source: ABdhPJzLdaIsF8RE7pCFkiwzWfeJWQYAPzKVX4NGTUCKvA21k1Iw2Cg8S2r2u2WDiJ6SkwQpO3xFzA==
X-Received: by 2002:a50:bb41:: with SMTP id y59mr4111517ede.311.1590686083286;
        Thu, 28 May 2020 10:14:43 -0700 (PDT)
Received: from nevthink ([91.126.71.247])
        by smtp.gmail.com with ESMTPSA id o24sm5666691ejb.72.2020.05.28.10.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 10:14:42 -0700 (PDT)
Date:   Thu, 28 May 2020 19:14:38 +0200
From:   Laura Garcia Liebana <nevola@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, devel@zevenet.com
Subject: [PATCH nf-next] netfilter: introduce support for reject at
 prerouting stage
Message-ID: <20200528171438.GA27622@nevthink>
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

The need for this patch becomes from the requirement of some
forwarding devices to reject traffic before the natting and
routing decisions.

It is supported ipv4, ipv6 and inet families for nft
infrastructure.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 18 ++++++++++++++++++
 net/ipv6/netfilter/nf_reject_ipv6.c | 21 +++++++++++++++++++++
 net/netfilter/nft_reject.c          |  3 ++-
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 2361fdac2c43..c6b46b7bca8b 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -96,6 +96,18 @@ void nf_reject_ip_tcphdr_put(struct sk_buff *nskb, const struct sk_buff *oldskb,
 }
 EXPORT_SYMBOL_GPL(nf_reject_ip_tcphdr_put);
 
+static void nf_reject_fill_skb_dst(struct sk_buff *skb_in)
+{
+	struct dst_entry *dst = NULL;
+	struct flowi fl;
+	struct flowi4 *fl4 = &fl.u.ip4;
+
+	memset(fl4, 0, sizeof(*fl4));
+	fl4->daddr = ip_hdr(skb_in)->saddr;
+	nf_route(dev_net(skb_in->dev), &dst, &fl, false, AF_INET);
+	skb_dst_set(skb_in, dst);
+}
+
 /* Send RST reply */
 void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
 {
@@ -109,6 +121,9 @@ void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
 	if (!oth)
 		return;
 
+	if (hook == NF_INET_PRE_ROUTING)
+		nf_reject_fill_skb_dst(oldskb);
+
 	if (skb_rtable(oldskb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
 		return;
 
@@ -175,6 +190,9 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 	if (iph->frag_off & htons(IP_OFFSET))
 		return;
 
+	if (hook == NF_INET_PRE_ROUTING)
+		nf_reject_fill_skb_dst(skb_in);
+
 	if (skb_csum_unnecessary(skb_in) || !nf_reject_verify_csum(proto)) {
 		icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
 		return;
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 5fae66f66671..d59b38a16eaa 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -126,6 +126,18 @@ void nf_reject_ip6_tcphdr_put(struct sk_buff *nskb,
 }
 EXPORT_SYMBOL_GPL(nf_reject_ip6_tcphdr_put);
 
+static void nf_reject6_fill_skb_dst(struct sk_buff *skb_in)
+{
+	struct dst_entry *dst = NULL;
+	struct flowi fl;
+	struct flowi6 *fl6 = &fl.u.ip6;
+
+	memset(fl6, 0, sizeof(*fl6));
+	fl6->daddr = ipv6_hdr(skb_in)->saddr;
+	nf_route(dev_net(skb_in->dev), &dst, &fl, false, AF_INET6);
+	skb_dst_set(skb_in, dst);
+}
+
 void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook)
 {
 	struct net_device *br_indev __maybe_unused;
@@ -154,6 +166,12 @@ void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook)
 	fl6.daddr = oip6h->saddr;
 	fl6.fl6_sport = otcph->dest;
 	fl6.fl6_dport = otcph->source;
+
+	if (hook == NF_INET_PRE_ROUTING) {
+		nf_route(dev_net(oldskb->dev), &dst, flowi6_to_flowi(&fl6), false, AF_INET6);
+		skb_dst_set(oldskb, dst);
+	}
+
 	fl6.flowi6_oif = l3mdev_master_ifindex(skb_dst(oldskb)->dev);
 	fl6.flowi6_mark = IP6_REPLY_MARK(net, oldskb->mark);
 	security_skb_classify_flow(oldskb, flowi6_to_flowi(&fl6));
@@ -245,6 +263,9 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
 		skb_in->dev = net->loopback_dev;
 
+	if (hooknum == NF_INET_PRE_ROUTING)
+		nf_reject6_fill_skb_dst(skb_in);
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

