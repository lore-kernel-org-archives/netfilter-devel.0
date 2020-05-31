Return-Path: <SRS0=6iZG=7N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0521FC433E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 31 May 2020 20:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5C8C204EA
	for <netfilter-devel@archiver.kernel.org>; Sun, 31 May 2020 20:26:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="baFqY6d0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgEaU0e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 31 May 2020 16:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbgEaU0e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 31 May 2020 16:26:34 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A868EC061A0E
        for <netfilter-devel@vger.kernel.org>; Sun, 31 May 2020 13:26:28 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f5so9373241wmh.2
        for <netfilter-devel@vger.kernel.org>; Sun, 31 May 2020 13:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=qsRaktXId/FtcrvV8KBwbP2n+XnOMGKFzEvHzDvl9HQ=;
        b=baFqY6d0XGLczemlnpDgohLel9DmW9XNvCORXbtRnRYbn3wXdGY4cxYE+6dw4421mz
         JGkyDGINdQLjvJ6QPqtFNqBR9DbYkzxtCNDZB6yRsKchQboFhDL9vvNZhbAksV6sLdqJ
         5e+JPvENhgY5ydlWIkNr0Wd4BKuUoTcFEk6+M4UWa2xo146AMkJT5xXuoANZPv/utw4F
         HCHtgivVEEFTkrw6fuC25E46R9zEjFxggDSMHJM+Z8T4aJdqIqOg+BUuXBk4QVNxDmje
         iqC73VpU7FHmUSlla6RlykriDHexrpqrPeTUqUFCj8mFYe1X0HqQvlaz2EwPnCOPVvPe
         J7RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=qsRaktXId/FtcrvV8KBwbP2n+XnOMGKFzEvHzDvl9HQ=;
        b=UGU3w2pDaaLRnLwzoywIKZdsxEKalon7oJdHXAS2qeOSRMRg1OB4Rq9trcSjM2ox0w
         FRMJBg3J+aKnGBbXuvQ75SLbc8NGNaAClHWPn1ndO2Vp5QrV2Irw0jtpbyfbSkeO0Sb+
         f7BtX3F+nGl8ArVA70YvfAh86SMQrYjD/Vp+UTg1CI4oebnQ/ewQddl0WuNeLQzugWiC
         nBxb8zwD2FmeooD/EDBPhdfdLutVemWhDGeWmgYooaY2Fy7jWroBo/ft3bUb4F1thwuV
         TgZgvn5TybHsb6VHDcH/puMs1YES9nG4DC09/qg0vzYtlOO6dWSysKO6fE02wj8C+2F1
         rwJg==
X-Gm-Message-State: AOAM532TiQ2q5haGcVzZpG/5jIK4Tp9mLmiBVf3lzPfDKT4madZlP7Bp
        9pN6ZzExX3s1Wt/f3mZZR0RcFNNhD6o=
X-Google-Smtp-Source: ABdhPJyBc0okfFRnxjqdj6v73wyGA//fF52fO7YRXakX45va7628yA4w/jmi/iigPkz7Su6mdHvRgw==
X-Received: by 2002:a7b:c353:: with SMTP id l19mr19120910wmj.187.1590956787003;
        Sun, 31 May 2020 13:26:27 -0700 (PDT)
Received: from nevthink ([91.126.71.34])
        by smtp.gmail.com with ESMTPSA id a15sm19033466wra.86.2020.05.31.13.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 13:26:26 -0700 (PDT)
Date:   Sun, 31 May 2020 22:26:23 +0200
From:   Laura Garcia Liebana <nevola@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, devel@zevenet.com
Subject: [PATCH v3 nf-next] netfilter: introduce support for reject at
 prerouting stage
Message-ID: <20200531202623.GA27861@nevthink>
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
v3:
 - Simplify flowi structure and do not use nf_route() wrapper, suggested by Pablo Ne$
v2:
 - Add error handling in nf_route(), suggested by Florian Westphal.
 - Add use case description, suggested by Reindl Harald.

 net/ipv4/netfilter/nf_reject_ipv4.c | 21 +++++++++++++++++++++
 net/ipv6/netfilter/nf_reject_ipv6.c | 26 ++++++++++++++++++++++++++
 net/netfilter/nft_reject.c          |  3 ++-
 3 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 2361fdac2c43..9dcfa4e461b6 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -96,6 +96,21 @@ void nf_reject_ip_tcphdr_put(struct sk_buff *nskb, const struct sk_buff *oldskb,
 }
 EXPORT_SYMBOL_GPL(nf_reject_ip_tcphdr_put);
 
+static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
+{
+	struct dst_entry *dst = NULL;
+	struct flowi fl;
+
+	memset(&fl, 0, sizeof(struct flowi));
+	fl.u.ip4.daddr = ip_hdr(skb_in)->saddr;
+	nf_ip_route(dev_net(skb_in->dev), &dst, &fl, false);
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
@@ -109,6 +124,9 @@ void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
 	if (!oth)
 		return;
 
+	if (hook == NF_INET_PRE_ROUTING && nf_reject_fill_skb_dst(oldskb))
+		return;
+
 	if (skb_rtable(oldskb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
 		return;
 
@@ -175,6 +193,9 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 	if (iph->frag_off & htons(IP_OFFSET))
 		return;
 
+	if (hook == NF_INET_PRE_ROUTING && nf_reject_fill_skb_dst(skb_in))
+		return;
+
 	if (skb_csum_unnecessary(skb_in) || !nf_reject_verify_csum(proto)) {
 		icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
 		return;
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 5fae66f66671..25f50f636273 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -126,6 +126,21 @@ void nf_reject_ip6_tcphdr_put(struct sk_buff *nskb,
 }
 EXPORT_SYMBOL_GPL(nf_reject_ip6_tcphdr_put);
 
+static int nf_reject6_fill_skb_dst(struct sk_buff *skb_in)
+{
+	struct dst_entry *dst = NULL;
+	struct flowi fl;
+
+	memset(&fl, 0, sizeof(struct flowi));
+	fl.u.ip6.daddr = ipv6_hdr(skb_in)->saddr;
+	nf_ip6_route(dev_net(skb_in->dev), &dst, &fl, false);
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
@@ -154,6 +169,14 @@ void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook)
 	fl6.daddr = oip6h->saddr;
 	fl6.fl6_sport = otcph->dest;
 	fl6.fl6_dport = otcph->source;
+
+	if (hook == NF_INET_PRE_ROUTING) {
+		nf_ip6_route(dev_net(oldskb->dev), &dst, flowi6_to_flowi(&fl6), false);
+		if (!dst)
+			return;
+		skb_dst_set(oldskb, dst);
+	}
+
 	fl6.flowi6_oif = l3mdev_master_ifindex(skb_dst(oldskb)->dev);
 	fl6.flowi6_mark = IP6_REPLY_MARK(net, oldskb->mark);
 	security_skb_classify_flow(oldskb, flowi6_to_flowi(&fl6));
@@ -245,6 +268,9 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
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

