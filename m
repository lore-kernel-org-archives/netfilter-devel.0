Return-Path: <SRS0=hDGH=VH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 728BEC73C7C
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Jul 2019 10:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45B4320838
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Jul 2019 10:07:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="S7HfQkqF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfGJKHX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 Jul 2019 06:07:23 -0400
Received: from mx1.riseup.net ([198.252.153.129]:44198 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfGJKHX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 06:07:23 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id D8CD61A0A81
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2019 03:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1562753242; bh=uL8d+JN+THR1rRLHiBQMabtFtNGf8EgOhMLaeb2+cyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7HfQkqFGBKK5dos/4hESn/L919yD9ZXAO2Rcexnp5m86Xw60pKvL3ee7C3MvCn/V
         4nG7/OZSXvouDun4tVXCKpFyMaSY61MSzAqS4ulo4mrYXcyH5IOrgkf8Y4s4Hl4IsB
         tl2KyTgANmHeM/FZvAt5+mtBqAgdaJZV2fdhtCtE=
X-Riseup-User-ID: 58268A83AE738F85D5832E76647A6E06288BBF948F6715810FD3AF4BFB056931
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 2912B223318;
        Wed, 10 Jul 2019 03:07:20 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 2/2 nf-next] netfilter: synproxy: rename mss synproxy_options field
Date:   Wed, 10 Jul 2019 12:05:59 +0200
Message-Id: <20190710100556.25307-3-ffmancera@riseup.net>
In-Reply-To: <20190710100556.25307-1-ffmancera@riseup.net>
References: <20190710100556.25307-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

After introduce "mss_encode" field in the synproxy_options struct the field
"mss" is a little confusing. It has been renamed to "mss_option".

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/net/netfilter/nf_conntrack_synproxy.h | 2 +-
 net/ipv4/netfilter/ipt_SYNPROXY.c             | 4 ++--
 net/ipv6/netfilter/ip6t_SYNPROXY.c            | 4 ++--
 net/netfilter/nf_synproxy_core.c              | 8 ++++----
 net/netfilter/nft_synproxy.c                  | 4 ++--
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_synproxy.h b/include/net/netfilter/nf_conntrack_synproxy.h
index 44513b93bd55..2f0171d24997 100644
--- a/include/net/netfilter/nf_conntrack_synproxy.h
+++ b/include/net/netfilter/nf_conntrack_synproxy.h
@@ -67,7 +67,7 @@ static inline struct synproxy_net *synproxy_pernet(struct net *net)
 struct synproxy_options {
 	u8				options;
 	u8				wscale;
-	u16				mss;
+	u16				mss_option;
 	u16				mss_encode;
 	u32				tsval;
 	u32				tsecr;
diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYNPROXY.c
index 0e70f3f65f6f..748dc3ce58d3 100644
--- a/net/ipv4/netfilter/ipt_SYNPROXY.c
+++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
@@ -36,8 +36,8 @@ synproxy_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 			opts.options |= XT_SYNPROXY_OPT_ECN;
 
 		opts.options &= info->options;
-		opts.mss_encode = opts.mss;
-		opts.mss = info->mss;
+		opts.mss_encode = opts.mss_option;
+		opts.mss_option = info->mss;
 		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
 			synproxy_init_timestamp_cookie(info, &opts);
 		else
diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index 5cdb4a69d277..fd1f52a21bf1 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -36,8 +36,8 @@ synproxy_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 			opts.options |= XT_SYNPROXY_OPT_ECN;
 
 		opts.options &= info->options;
-		opts.mss_encode = opts.mss;
-		opts.mss = info->mss;
+		opts.mss_encode = opts.mss_option;
+		opts.mss_option = info->mss;
 		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
 			synproxy_init_timestamp_cookie(info, &opts);
 		else
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 09718e5a9e41..6676a3842a0c 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -56,7 +56,7 @@ synproxy_parse_options(const struct sk_buff *skb, unsigned int doff,
 			switch (opcode) {
 			case TCPOPT_MSS:
 				if (opsize == TCPOLEN_MSS) {
-					opts->mss = get_unaligned_be16(ptr);
+					opts->mss_option = get_unaligned_be16(ptr);
 					opts->options |= NF_SYNPROXY_OPT_MSS;
 				}
 				break;
@@ -115,7 +115,7 @@ synproxy_build_options(struct tcphdr *th, const struct synproxy_options *opts)
 	if (options & NF_SYNPROXY_OPT_MSS)
 		*ptr++ = htonl((TCPOPT_MSS << 24) |
 			       (TCPOLEN_MSS << 16) |
-			       opts->mss);
+			       opts->mss_option);
 
 	if (options & NF_SYNPROXY_OPT_TIMESTAMP) {
 		if (options & NF_SYNPROXY_OPT_SACK_PERM)
@@ -642,7 +642,7 @@ synproxy_recv_client_ack(struct net *net,
 	}
 
 	this_cpu_inc(snet->stats->cookie_valid);
-	opts->mss = mss;
+	opts->mss_option = mss;
 	opts->options |= NF_SYNPROXY_OPT_MSS;
 
 	if (opts->options & NF_SYNPROXY_OPT_TIMESTAMP)
@@ -1060,7 +1060,7 @@ synproxy_recv_client_ack_ipv6(struct net *net,
 	}
 
 	this_cpu_inc(snet->stats->cookie_valid);
-	opts->mss = mss;
+	opts->mss_option = mss;
 	opts->options |= NF_SYNPROXY_OPT_MSS;
 
 	if (opts->options & NF_SYNPROXY_OPT_TIMESTAMP)
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 928e661d1517..db4c23f5dfcb 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -31,8 +31,8 @@ static void nft_synproxy_tcp_options(struct synproxy_options *opts,
 		opts->options |= NF_SYNPROXY_OPT_ECN;
 
 	opts->options &= priv->info.options;
-	opts->mss_encode = opts->mss;
-	opts->mss = info->mss;
+	opts->mss_encode = opts->mss_option;
+	opts->mss_option = info->mss;
 	if (opts->options & NF_SYNPROXY_OPT_TIMESTAMP)
 		synproxy_init_timestamp_cookie(info, opts);
 	else
-- 
2.20.1

