Return-Path: <SRS0=2jko=VQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 032A2C7618F
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 16:46:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9AA52186A
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 16:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732083AbfGSQqB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Jul 2019 12:46:01 -0400
Received: from mail.us.es ([193.147.175.20]:49906 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731902AbfGSQps (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 12:45:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7A9C4BAEE6
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jul 2019 18:45:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 60045DA732
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jul 2019 18:45:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 57BB91150DE; Fri, 19 Jul 2019 18:45:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A3C65115111;
        Fri, 19 Jul 2019 18:45:30 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 19 Jul 2019 18:45:30 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.47.94])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2600E4265A2F;
        Fri, 19 Jul 2019 18:45:30 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/14] netfilter: synproxy: fix erroneous tcp mss option
Date:   Fri, 19 Jul 2019 18:45:09 +0200
Message-Id: <20190719164517.29496-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190719164517.29496-1-pablo@netfilter.org>
References: <20190719164517.29496-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

Now synproxy sends the mss value set by the user on client syn-ack packet
instead of the mss value that client announced.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.11.0


