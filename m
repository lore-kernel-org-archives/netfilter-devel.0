Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87484C433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Feb 2022 01:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbiBYByo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 20:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234235AbiBYByn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 20:54:43 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B492763F1
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 17:54:11 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id n15so1244426plf.4
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 17:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UgIC+6yXO5bdJSlGz1P5mjPZgJVQnaa50T9Ofqgzt6s=;
        b=GKktsy26iRKssStahn68KBnWM3+54HUcCr0IxT7L47T2K1c4iAgyJuxHSxTEEOaws9
         9QbFXTzCnc8vFOE6QU7R0rK0ZvXUmM8n3jcpgxLhhuCcm9CIiayptdqFjSKzbSngpV6O
         GGGEQAursaQarzhgRVApK2WSW9QMFceK4vMjJ5+BPwD/P32k+n522iZquwhL9uSqdMfh
         gHOVqcylJJFFxwmuaK5s6XpPg3ACSUS6gX+oQ2TKLDtzkmT9xnGwPEDNzpMDFsssWnud
         Lgs6Z7G+15h+yaN+kkkmefV80aKrTi6i8h2f4BLt6lBdM4gPVlRdbT19D2KCxTslk0d2
         8U+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UgIC+6yXO5bdJSlGz1P5mjPZgJVQnaa50T9Ofqgzt6s=;
        b=55mdwGXs/UgUrW8PkDAyZJDUa3rqFPUx+oGZtrM7G/Cv+33mZiH4R7qtlBCJUkyr91
         zhdGEUhoCjxEhxCT9HlWjc46ZAMMNyaCM6vAJ90pxS6Rvq9kqoQziaFlhdcPwI4dsalJ
         VW0fdd0uiVbmRrqd3Suvwv214CkYhAyVsLCwvw8ofinZJ8oCrIs5rOs8wD7ZFvW9WrJ1
         TegVbk0i6ZX7slXdT2Hry6U6p2wn2vLYv7wN/yEQSrFjaIiNyMMuVHPDxccmSy55Jlmy
         TEOHUgcBz2qkJYg4tlLOtoXTGBMD1e47bOu5Uqmc7qC4g/GUfcuMunOqPgzG6Apwl+YM
         rUjA==
X-Gm-Message-State: AOAM531JZSI6GMbSf0bIbqkjcN38qBDWVuRXx7A9NIvviMntdF18HLGP
        5nmE2Y62j1iG3tZXUEbdgjA=
X-Google-Smtp-Source: ABdhPJxqgObdqinP98wJWzmuJYU3//k882+ehOrOiC9YNG07/QYQCP8tep9hwHX+JqQfmz211UvyIg==
X-Received: by 2002:a17:902:860a:b0:14b:341e:5ffb with SMTP id f10-20020a170902860a00b0014b341e5ffbmr5180807plo.6.1645754050887;
        Thu, 24 Feb 2022 17:54:10 -0800 (PST)
Received: from e30-rocky8.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id a15-20020a637f0f000000b00372e075b2efsm710980pgd.30.2022.02.24.17.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 17:54:10 -0800 (PST)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     "Saeed Mahameed" <saeedm@nvidia.com>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        "Cong Wang" <xiyou.wangcong@gmail.com>,
        "Jiri Pirko" <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "Jozsef Kadlecsik" <kadlec@netfilter.org>,
        "Florian Westphal" <fw@strlen.de>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Paul Blakey <paulb@nvidia.com>
Subject: [PATCH nf-next v2 1/3] netfilter: flowtable: Support GRE
Date:   Fri, 25 Feb 2022 10:53:07 +0900
Message-Id: <20220225015309.2576980-2-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220225015309.2576980-1-toshiaki.makita1@gmail.com>
References: <20220225015309.2576980-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Support GREv0 without NAT.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 net/netfilter/nf_flow_table_core.c    | 10 ++++--
 net/netfilter/nf_flow_table_ip.c      | 62 +++++++++++++++++++++++++++++------
 net/netfilter/nf_flow_table_offload.c | 22 +++++++++----
 net/netfilter/nft_flow_offload.c      | 13 ++++++++
 4 files changed, 88 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index b90eca7..e66a375 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -39,8 +39,14 @@
 
 	ft->l3proto = ctt->src.l3num;
 	ft->l4proto = ctt->dst.protonum;
-	ft->src_port = ctt->src.u.tcp.port;
-	ft->dst_port = ctt->dst.u.tcp.port;
+
+	switch (ctt->dst.protonum) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+		ft->src_port = ctt->src.u.tcp.port;
+		ft->dst_port = ctt->dst.u.tcp.port;
+		break;
+	}
 }
 
 struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 889cf88..6e9cacf 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -172,6 +172,7 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 	struct flow_ports *ports;
 	unsigned int thoff;
 	struct iphdr *iph;
+	u8 ipproto;
 
 	if (!pskb_may_pull(skb, sizeof(*iph) + offset))
 		return -1;
@@ -185,13 +186,19 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 
 	thoff += offset;
 
-	switch (iph->protocol) {
+	ipproto = iph->protocol;
+	switch (ipproto) {
 	case IPPROTO_TCP:
 		*hdrsize = sizeof(struct tcphdr);
 		break;
 	case IPPROTO_UDP:
 		*hdrsize = sizeof(struct udphdr);
 		break;
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE:
+		*hdrsize = sizeof(struct gre_base_hdr);
+		break;
+#endif
 	default:
 		return -1;
 	}
@@ -202,15 +209,29 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 	if (!pskb_may_pull(skb, thoff + *hdrsize))
 		return -1;
 
+	switch (ipproto) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+		ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
+		tuple->src_port		= ports->source;
+		tuple->dst_port		= ports->dest;
+		break;
+	case IPPROTO_GRE: {
+		struct gre_base_hdr *greh;
+
+		greh = (struct gre_base_hdr *)(skb_network_header(skb) + thoff);
+		if ((greh->flags & GRE_VERSION) != GRE_VERSION_0)
+			return -1;
+		break;
+	}
+	}
+
 	iph = (struct iphdr *)(skb_network_header(skb) + offset);
-	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
 
 	tuple->src_v4.s_addr	= iph->saddr;
 	tuple->dst_v4.s_addr	= iph->daddr;
-	tuple->src_port		= ports->source;
-	tuple->dst_port		= ports->dest;
 	tuple->l3proto		= AF_INET;
-	tuple->l4proto		= iph->protocol;
+	tuple->l4proto		= ipproto;
 	tuple->iifidx		= dev->ifindex;
 	nf_flow_tuple_encap(skb, tuple);
 
@@ -521,6 +542,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	struct flow_ports *ports;
 	struct ipv6hdr *ip6h;
 	unsigned int thoff;
+	u8 nexthdr;
 
 	thoff = sizeof(*ip6h) + offset;
 	if (!pskb_may_pull(skb, thoff))
@@ -528,13 +550,19 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 
 	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
 
-	switch (ip6h->nexthdr) {
+	nexthdr = ip6h->nexthdr;
+	switch (nexthdr) {
 	case IPPROTO_TCP:
 		*hdrsize = sizeof(struct tcphdr);
 		break;
 	case IPPROTO_UDP:
 		*hdrsize = sizeof(struct udphdr);
 		break;
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE:
+		*hdrsize = sizeof(struct gre_base_hdr);
+		break;
+#endif
 	default:
 		return -1;
 	}
@@ -545,15 +573,29 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	if (!pskb_may_pull(skb, thoff + *hdrsize))
 		return -1;
 
+	switch (nexthdr) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+		ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
+		tuple->src_port		= ports->source;
+		tuple->dst_port		= ports->dest;
+		break;
+	case IPPROTO_GRE: {
+		struct gre_base_hdr *greh;
+
+		greh = (struct gre_base_hdr *)(skb_network_header(skb) + thoff);
+		if ((greh->flags & GRE_VERSION) != GRE_VERSION_0)
+			return -1;
+		break;
+	}
+	}
+
 	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
-	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
 
 	tuple->src_v6		= ip6h->saddr;
 	tuple->dst_v6		= ip6h->daddr;
-	tuple->src_port		= ports->source;
-	tuple->dst_port		= ports->dest;
 	tuple->l3proto		= AF_INET6;
-	tuple->l4proto		= ip6h->nexthdr;
+	tuple->l4proto		= nexthdr;
 	tuple->iifidx		= dev->ifindex;
 	nf_flow_tuple_encap(skb, tuple);
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b561e0a..99f6db3 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -170,6 +170,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_TCP);
 		break;
 	case IPPROTO_UDP:
+	case IPPROTO_GRE:
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -178,15 +179,22 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	key->basic.ip_proto = tuple->l4proto;
 	mask->basic.ip_proto = 0xff;
 
-	key->tp.src = tuple->src_port;
-	mask->tp.src = 0xffff;
-	key->tp.dst = tuple->dst_port;
-	mask->tp.dst = 0xffff;
-
 	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_META) |
 				      BIT(FLOW_DISSECTOR_KEY_CONTROL) |
-				      BIT(FLOW_DISSECTOR_KEY_BASIC) |
-				      BIT(FLOW_DISSECTOR_KEY_PORTS);
+				      BIT(FLOW_DISSECTOR_KEY_BASIC);
+
+	switch (tuple->l4proto) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+		key->tp.src = tuple->src_port;
+		mask->tp.src = 0xffff;
+		key->tp.dst = tuple->dst_port;
+		mask->tp.dst = 0xffff;
+
+		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_PORTS);
+		break;
+	}
+
 	return 0;
 }
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 0af34ad..731b5d8 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -298,6 +298,19 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		break;
 	case IPPROTO_UDP:
 		break;
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE: {
+		struct nf_conntrack_tuple *tuple;
+
+		if (ct->status & IPS_NAT_MASK)
+			goto out;
+		tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+		/* No support for GRE v1 */
+		if (tuple->src.u.gre.key || tuple->dst.u.gre.key)
+			goto out;
+		break;
+	}
+#endif
 	default:
 		goto out;
 	}
-- 
1.8.3.1

