Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF9A2C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Feb 2022 01:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236575AbiBYByp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 20:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234235AbiBYByp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 20:54:45 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CAD2763F1
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 17:54:14 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id bd1so3467560plb.13
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 17:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xhh8kK72AweAOeZD6K411eN/3kt1qDqLRoh7XJh6hhU=;
        b=T3zMW29RS4aSxDj7C/HG31P8HjbKTHjK0l2dhG+Sm2V9NwH2JWqx/+H98xpilcQlB3
         XoXKoBe/7FCvBxF7qI58a+rAxoXzAoMmO+Ur2rxtWhfFVsVwP15VsKfWa7v6RefVGE4B
         y1O33xKbpja+tOhOk9QQa55gxWJdElZTSpUtoRMhzTy44GpRNhgXaXyP3oFo8gYi7fU4
         FaqXi1MHlVnVzyLkwMyXODzZK+7rEybv/J3+b3EO7edZr1GFkHzytwivtcrs6OlLRXdW
         4vHNvdFwUGLWol1K58JYLo/uaKEn+mA4ge9r1uljzfVz/FGCemjOAZXSm+PnBA8u0D4X
         hqYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xhh8kK72AweAOeZD6K411eN/3kt1qDqLRoh7XJh6hhU=;
        b=IP6aGFUWcUluXnVBewAMcFed+KNkDb+BrTvSlmFF1UocO20N+iq2Owoxi85biK9tXT
         BbXEYCDe3+9eK5fvMzc3Htkt2nTxAmFc9+VOh7DdJUkD1m11P2L4viizr56VkWg4adxt
         eR8w+84fCRRSYYqA8bsrSsTWLH/9wX7NNctgXXVm5q9vuZtaWAptQ39SMWQ301S5Tduo
         xH3wfYb2RoVSq6DzZqEizaYUse8UTXGkb/xhBSbp2Qe78Tr4y5ZZIl4tOztT5YOe84Qp
         5tpUJXFiQMUfuVU59gvnxuiMloV2nLTnPJMaGpzMXgMEwyMrIim+yDQyC9tsNKHjWTzn
         8yFA==
X-Gm-Message-State: AOAM532tkH3Xn65mw9AXvUrNCR/BaPErvlVyLQgsR1y8tmTaxwlYbL1w
        yoZGFX95TtfYhkVAd85/Txc=
X-Google-Smtp-Source: ABdhPJxmfyNIQaF0ZIr/Rkiv3dQVkfBS3wTiB3MS5IvI+oZw1lidVmyoIrp1Hp0ci7XFAc+6BGj4JA==
X-Received: by 2002:a17:902:e88e:b0:150:25e3:739c with SMTP id w14-20020a170902e88e00b0015025e3739cmr1723444plg.13.1645754053977;
        Thu, 24 Feb 2022 17:54:13 -0800 (PST)
Received: from e30-rocky8.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id a15-20020a637f0f000000b00372e075b2efsm710980pgd.30.2022.02.24.17.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 17:54:13 -0800 (PST)
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
Subject: [PATCH nf-next v2 2/3] act_ct: Support GRE offload
Date:   Fri, 25 Feb 2022 10:53:08 +0900
Message-Id: <20220225015309.2576980-3-toshiaki.makita1@gmail.com>
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
Acked-by: Paul Blakey <paulb@nvidia.com>
---
 net/sched/act_ct.c | 115 ++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 91 insertions(+), 24 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 7108e71..3fe36d1 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -415,6 +415,19 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 		break;
 	case IPPROTO_UDP:
 		break;
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE: {
+		struct nf_conntrack_tuple *tuple;
+
+		if (ct->status & IPS_NAT_MASK)
+			return;
+		tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+		/* No support for GRE v1 */
+		if (tuple->src.u.gre.key || tuple->dst.u.gre.key)
+			return;
+		break;
+	}
+#endif
 	default:
 		return;
 	}
@@ -434,6 +447,8 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 	struct flow_ports *ports;
 	unsigned int thoff;
 	struct iphdr *iph;
+	size_t hdrsize;
+	u8 ipproto;
 
 	if (!pskb_network_may_pull(skb, sizeof(*iph)))
 		return false;
@@ -445,29 +460,54 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 	    unlikely(thoff != sizeof(struct iphdr)))
 		return false;
 
-	if (iph->protocol != IPPROTO_TCP &&
-	    iph->protocol != IPPROTO_UDP)
+	ipproto = iph->protocol;
+	switch (ipproto) {
+	case IPPROTO_TCP:
+		hdrsize = sizeof(struct tcphdr);
+		break;
+	case IPPROTO_UDP:
+		hdrsize = sizeof(*ports);
+		break;
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE:
+		hdrsize = sizeof(struct gre_base_hdr);
+		break;
+#endif
+	default:
 		return false;
+	}
 
 	if (iph->ttl <= 1)
 		return false;
 
-	if (!pskb_network_may_pull(skb, iph->protocol == IPPROTO_TCP ?
-					thoff + sizeof(struct tcphdr) :
-					thoff + sizeof(*ports)))
+	if (!pskb_network_may_pull(skb, thoff + hdrsize))
 		return false;
 
-	iph = ip_hdr(skb);
-	if (iph->protocol == IPPROTO_TCP)
+	switch (ipproto) {
+	case IPPROTO_TCP:
 		*tcph = (void *)(skb_network_header(skb) + thoff);
+		fallthrough;
+	case IPPROTO_UDP:
+		ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
+		tuple->src_port = ports->source;
+		tuple->dst_port = ports->dest;
+		break;
+	case IPPROTO_GRE: {
+		struct gre_base_hdr *greh;
+
+		greh = (struct gre_base_hdr *)(skb_network_header(skb) + thoff);
+		if ((greh->flags & GRE_VERSION) != GRE_VERSION_0)
+			return false;
+		break;
+	}
+	}
+
+	iph = ip_hdr(skb);
 
-	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
 	tuple->src_v4.s_addr = iph->saddr;
 	tuple->dst_v4.s_addr = iph->daddr;
-	tuple->src_port = ports->source;
-	tuple->dst_port = ports->dest;
 	tuple->l3proto = AF_INET;
-	tuple->l4proto = iph->protocol;
+	tuple->l4proto = ipproto;
 
 	return true;
 }
@@ -480,36 +520,63 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 	struct flow_ports *ports;
 	struct ipv6hdr *ip6h;
 	unsigned int thoff;
+	size_t hdrsize;
+	u8 nexthdr;
 
 	if (!pskb_network_may_pull(skb, sizeof(*ip6h)))
 		return false;
 
 	ip6h = ipv6_hdr(skb);
+	thoff = sizeof(*ip6h);
 
-	if (ip6h->nexthdr != IPPROTO_TCP &&
-	    ip6h->nexthdr != IPPROTO_UDP)
-		return false;
+	nexthdr = ip6h->nexthdr;
+	switch (nexthdr) {
+	case IPPROTO_TCP:
+		hdrsize = sizeof(struct tcphdr);
+		break;
+	case IPPROTO_UDP:
+		hdrsize = sizeof(*ports);
+		break;
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE:
+		hdrsize = sizeof(struct gre_base_hdr);
+		break;
+#endif
+	default:
+		return -1;
+	}
 
 	if (ip6h->hop_limit <= 1)
 		return false;
 
-	thoff = sizeof(*ip6h);
-	if (!pskb_network_may_pull(skb, ip6h->nexthdr == IPPROTO_TCP ?
-					thoff + sizeof(struct tcphdr) :
-					thoff + sizeof(*ports)))
+	if (!pskb_network_may_pull(skb, thoff + hdrsize))
 		return false;
 
-	ip6h = ipv6_hdr(skb);
-	if (ip6h->nexthdr == IPPROTO_TCP)
+	switch (nexthdr) {
+	case IPPROTO_TCP:
 		*tcph = (void *)(skb_network_header(skb) + thoff);
+		fallthrough;
+	case IPPROTO_UDP:
+		ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
+		tuple->src_port = ports->source;
+		tuple->dst_port = ports->dest;
+		break;
+	case IPPROTO_GRE: {
+		struct gre_base_hdr *greh;
+
+		greh = (struct gre_base_hdr *)(skb_network_header(skb) + thoff);
+		if ((greh->flags & GRE_VERSION) != GRE_VERSION_0)
+			return false;
+		break;
+	}
+	}
+
+	ip6h = ipv6_hdr(skb);
 
-	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
 	tuple->src_v6 = ip6h->saddr;
 	tuple->dst_v6 = ip6h->daddr;
-	tuple->src_port = ports->source;
-	tuple->dst_port = ports->dest;
 	tuple->l3proto = AF_INET6;
-	tuple->l4proto = ip6h->nexthdr;
+	tuple->l4proto = nexthdr;
 
 	return true;
 }
-- 
1.8.3.1

