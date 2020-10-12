Return-Path: <SRS0=LXG+=DT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 038AAC433E7
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Oct 2020 01:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD62620782
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Oct 2020 01:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgJLBie (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 11 Oct 2020 21:38:34 -0400
Received: from correo.us.es ([193.147.175.20]:41738 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727386AbgJLBid (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Oct 2020 21:38:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BF12BE7810
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2020 03:38:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AEFB4DA73F
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2020 03:38:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A4990DA722; Mon, 12 Oct 2020 03:38:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A258DA704;
        Mon, 12 Oct 2020 03:38:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 12 Oct 2020 03:38:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 6C97741FF201;
        Mon, 12 Oct 2020 03:38:29 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 6/6] netfilter: flowtable: reduce calls to pskb_may_pull()
Date:   Mon, 12 Oct 2020 03:38:19 +0200
Message-Id: <20201012013819.23128-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201012013819.23128-1-pablo@netfilter.org>
References: <20201012013819.23128-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make two unfront calls to pskb_may_pull() to linearize the network and
transport header.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 12 +++-----
 net/netfilter/nf_flow_table_ip.c   | 45 +++++++++++++++++-------------
 2 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 4f7a567c536e..513f78db3cb2 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -395,8 +395,7 @@ static int nf_flow_nat_port_tcp(struct sk_buff *skb, unsigned int thoff,
 {
 	struct tcphdr *tcph;
 
-	if (!pskb_may_pull(skb, thoff + sizeof(*tcph)) ||
-	    skb_try_make_writable(skb, thoff + sizeof(*tcph)))
+	if (skb_try_make_writable(skb, thoff + sizeof(*tcph)))
 		return -1;
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
@@ -410,8 +409,7 @@ static int nf_flow_nat_port_udp(struct sk_buff *skb, unsigned int thoff,
 {
 	struct udphdr *udph;
 
-	if (!pskb_may_pull(skb, thoff + sizeof(*udph)) ||
-	    skb_try_make_writable(skb, thoff + sizeof(*udph)))
+	if (skb_try_make_writable(skb, thoff + sizeof(*udph)))
 		return -1;
 
 	udph = (void *)(skb_network_header(skb) + thoff);
@@ -449,8 +447,7 @@ int nf_flow_snat_port(const struct flow_offload *flow,
 	struct flow_ports *hdr;
 	__be16 port, new_port;
 
-	if (!pskb_may_pull(skb, thoff + sizeof(*hdr)) ||
-	    skb_try_make_writable(skb, thoff + sizeof(*hdr)))
+	if (skb_try_make_writable(skb, thoff + sizeof(*hdr)))
 		return -1;
 
 	hdr = (void *)(skb_network_header(skb) + thoff);
@@ -481,8 +478,7 @@ int nf_flow_dnat_port(const struct flow_offload *flow,
 	struct flow_ports *hdr;
 	__be16 port, new_port;
 
-	if (!pskb_may_pull(skb, thoff + sizeof(*hdr)) ||
-	    skb_try_make_writable(skb, thoff + sizeof(*hdr)))
+	if (skb_try_make_writable(skb, thoff + sizeof(*hdr)))
 		return -1;
 
 	hdr = (void *)(skb_network_header(skb) + thoff);
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index a3bca758b849..a698dbe28ef5 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -25,9 +25,6 @@ static int nf_flow_state_check(struct flow_offload *flow, int proto,
 	if (proto != IPPROTO_TCP)
 		return 0;
 
-	if (!pskb_may_pull(skb, thoff + sizeof(*tcph)))
-		return -1;
-
 	tcph = (void *)(skb_network_header(skb) + thoff);
 	if (unlikely(tcph->fin || tcph->rst)) {
 		flow_offload_teardown(flow);
@@ -42,8 +39,7 @@ static int nf_flow_nat_ip_tcp(struct sk_buff *skb, unsigned int thoff,
 {
 	struct tcphdr *tcph;
 
-	if (!pskb_may_pull(skb, thoff + sizeof(*tcph)) ||
-	    skb_try_make_writable(skb, thoff + sizeof(*tcph)))
+	if (skb_try_make_writable(skb, thoff + sizeof(*tcph)))
 		return -1;
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
@@ -57,8 +53,7 @@ static int nf_flow_nat_ip_udp(struct sk_buff *skb, unsigned int thoff,
 {
 	struct udphdr *udph;
 
-	if (!pskb_may_pull(skb, thoff + sizeof(*udph)) ||
-	    skb_try_make_writable(skb, thoff + sizeof(*udph)))
+	if (skb_try_make_writable(skb, thoff + sizeof(*udph)))
 		return -1;
 
 	udph = (void *)(skb_network_header(skb) + thoff);
@@ -167,8 +162,8 @@ static bool ip_has_options(unsigned int thoff)
 static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 			    struct flow_offload_tuple *tuple)
 {
+	unsigned int thoff, hdrsize;
 	struct flow_ports *ports;
-	unsigned int thoff;
 	struct iphdr *iph;
 
 	if (!pskb_may_pull(skb, sizeof(*iph)))
@@ -181,15 +176,22 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 	    unlikely(ip_has_options(thoff)))
 		return -1;
 
-	if (iph->protocol != IPPROTO_TCP &&
-	    iph->protocol != IPPROTO_UDP)
+	switch (iph->protocol) {
+	case IPPROTO_TCP:
+		hdrsize = sizeof(struct tcphdr);
+		break;
+	case IPPROTO_UDP:
+		hdrsize = sizeof(struct udphdr);
+		break;
+	default:
 		return -1;
+	}
 
 	if (iph->ttl <= 1)
 		return -1;
 
 	thoff = iph->ihl * 4;
-	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
+	if (!pskb_may_pull(skb, thoff + hdrsize))
 		return -1;
 
 	iph = ip_hdr(skb);
@@ -315,8 +317,7 @@ static int nf_flow_nat_ipv6_tcp(struct sk_buff *skb, unsigned int thoff,
 {
 	struct tcphdr *tcph;
 
-	if (!pskb_may_pull(skb, thoff + sizeof(*tcph)) ||
-	    skb_try_make_writable(skb, thoff + sizeof(*tcph)))
+	if (skb_try_make_writable(skb, thoff + sizeof(*tcph)))
 		return -1;
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
@@ -332,8 +333,7 @@ static int nf_flow_nat_ipv6_udp(struct sk_buff *skb, unsigned int thoff,
 {
 	struct udphdr *udph;
 
-	if (!pskb_may_pull(skb, thoff + sizeof(*udph)) ||
-	    skb_try_make_writable(skb, thoff + sizeof(*udph)))
+	if (skb_try_make_writable(skb, thoff + sizeof(*udph)))
 		return -1;
 
 	udph = (void *)(skb_network_header(skb) + thoff);
@@ -439,24 +439,31 @@ static int nf_flow_nat_ipv6(const struct flow_offload *flow,
 static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 			      struct flow_offload_tuple *tuple)
 {
+	unsigned int thoff, hdrsize;
 	struct flow_ports *ports;
 	struct ipv6hdr *ip6h;
-	unsigned int thoff;
 
 	if (!pskb_may_pull(skb, sizeof(*ip6h)))
 		return -1;
 
 	ip6h = ipv6_hdr(skb);
 
-	if (ip6h->nexthdr != IPPROTO_TCP &&
-	    ip6h->nexthdr != IPPROTO_UDP)
+	switch (ip6h->nexthdr) {
+	case IPPROTO_TCP:
+		hdrsize = sizeof(struct tcphdr);
+		break;
+	case IPPROTO_UDP:
+		hdrsize = sizeof(struct udphdr);
+		break;
+	default:
 		return -1;
+	}
 
 	if (ip6h->hop_limit <= 1)
 		return -1;
 
 	thoff = sizeof(*ip6h);
-	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
+	if (!pskb_may_pull(skb, thoff + hdrsize))
 		return -1;
 
 	ip6h = ipv6_hdr(skb);
-- 
2.20.1

