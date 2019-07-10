Return-Path: <SRS0=hDGH=VH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB05C73C7C
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Jul 2019 10:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E58C82054F
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Jul 2019 10:06:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="IB3oiTxZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfGJKGk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 Jul 2019 06:06:40 -0400
Received: from mx1.riseup.net ([198.252.153.129]:43876 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfGJKGk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 06:06:40 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 99DED1A0A2D
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2019 03:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1562753199; bh=+B4IGs0dLNKywkNNInoroxIp7fZXoKOsFh9MpDYQ/Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IB3oiTxZ1B2b3PqMFSKSp0QD9jdMkSFeoejp/lX5I6JBYPtm4iPVVeJs+VkTxZZPs
         9ORTfBh5AB1DOe2upH7U+DdkNrOTBFabGBjdQRAoqSyBXuG6pwlz8pkfVVC1MfYVo6
         aUWtr6tlQpWmh+uRumbRxU+ZjAFCf8otNKsLa7Aw=
X-Riseup-User-ID: DA8FDD1EC8D7E18D091FD797E7358B5B57C658F3C860AACFBBB934AE6A0DCCCE
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 2B474223318;
        Wed, 10 Jul 2019 03:06:37 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 1/2 nf-next] netfilter: synproxy: fix erroneous tcp mss option
Date:   Wed, 10 Jul 2019 12:05:57 +0200
Message-Id: <20190710100556.25307-2-ffmancera@riseup.net>
In-Reply-To: <20190710100556.25307-1-ffmancera@riseup.net>
References: <20190710100556.25307-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Now synproxy sends the mss value set by the user on client syn-ack packet
instead of the mss value that client announced.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/net/netfilter/nf_conntrack_synproxy.h | 1 +
 net/ipv4/netfilter/ipt_SYNPROXY.c             | 2 ++
 net/ipv6/netfilter/ip6t_SYNPROXY.c            | 2 ++
 net/netfilter/nf_synproxy_core.c              | 4 ++--
 net/netfilter/nft_synproxy.c                  | 2 ++
 5 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_synproxy.h b/include/net/netfilter/nf_conntrack_synproxy.h
index 8f00125b06f4..44513b93bd55 100644
--- a/include/net/netfilter/nf_conntrack_synproxy.h
+++ b/include/net/netfilter/nf_conntrack_synproxy.h
@@ -68,6 +68,7 @@ struct synproxy_options {
 	u8				options;
 	u8				wscale;
 	u16				mss;
+	u16				mss_encode;
 	u32				tsval;
 	u32				tsecr;
 };
diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYNPROXY.c
index 8e7f84ec783d..0e70f3f65f6f 100644
--- a/net/ipv4/netfilter/ipt_SYNPROXY.c
+++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
@@ -36,6 +36,8 @@ synproxy_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 			opts.options |= XT_SYNPROXY_OPT_ECN;
 
 		opts.options &= info->options;
+		opts.mss_encode = opts.mss;
+		opts.mss = info->mss;
 		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
 			synproxy_init_timestamp_cookie(info, &opts);
 		else
diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index e77ea1ed5edd..5cdb4a69d277 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -36,6 +36,8 @@ synproxy_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 			opts.options |= XT_SYNPROXY_OPT_ECN;
 
 		opts.options &= info->options;
+		opts.mss_encode = opts.mss;
+		opts.mss = info->mss;
 		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
 			synproxy_init_timestamp_cookie(info, &opts);
 		else
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index b101f187eda8..09718e5a9e41 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -470,7 +470,7 @@ synproxy_send_client_synack(struct net *net,
 	struct iphdr *iph, *niph;
 	struct tcphdr *nth;
 	unsigned int tcp_hdr_size;
-	u16 mss = opts->mss;
+	u16 mss = opts->mss_encode;
 
 	iph = ip_hdr(skb);
 
@@ -884,7 +884,7 @@ synproxy_send_client_synack_ipv6(struct net *net,
 	struct ipv6hdr *iph, *niph;
 	struct tcphdr *nth;
 	unsigned int tcp_hdr_size;
-	u16 mss = opts->mss;
+	u16 mss = opts->mss_encode;
 
 	iph = ipv6_hdr(skb);
 
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 80060ade8a5b..928e661d1517 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -31,6 +31,8 @@ static void nft_synproxy_tcp_options(struct synproxy_options *opts,
 		opts->options |= NF_SYNPROXY_OPT_ECN;
 
 	opts->options &= priv->info.options;
+	opts->mss_encode = opts->mss;
+	opts->mss = info->mss;
 	if (opts->options & NF_SYNPROXY_OPT_TIMESTAMP)
 		synproxy_init_timestamp_cookie(info, opts);
 	else
-- 
2.20.1

