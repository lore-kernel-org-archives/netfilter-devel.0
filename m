Return-Path: <SRS0=SfI0=TX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7BDEC282DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 13:43:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9D3220881
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 13:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730601AbfEWNnd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 May 2019 09:43:33 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48822 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729698AbfEWNnd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 May 2019 09:43:33 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hTo0I-0007j3-HZ; Thu, 23 May 2019 15:43:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/8] netfilter: ipvs: prefer skb_ensure_writable
Date:   Thu, 23 May 2019 15:44:06 +0200
Message-Id: <20190523134412.3295-3-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523134412.3295-1-fw@strlen.de>
References: <20190523134412.3295-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It does the same thing, use it instead so we can remove skb_make_writable.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipvs/ip_vs_app.c        |  4 ++--
 net/netfilter/ipvs/ip_vs_core.c       |  4 ++--
 net/netfilter/ipvs/ip_vs_ftp.c        |  4 ++--
 net/netfilter/ipvs/ip_vs_proto_sctp.c |  4 ++--
 net/netfilter/ipvs/ip_vs_proto_tcp.c  |  4 ++--
 net/netfilter/ipvs/ip_vs_proto_udp.c  |  4 ++--
 net/netfilter/ipvs/ip_vs_xmit.c       | 12 ++++++------
 7 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
index 7588aeaa605f..ba34ac25ee7b 100644
--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -363,7 +363,7 @@ static inline int app_tcp_pkt_out(struct ip_vs_conn *cp, struct sk_buff *skb,
 	struct tcphdr *th;
 	__u32 seq;
 
-	if (!skb_make_writable(skb, tcp_offset + sizeof(*th)))
+	if (skb_ensure_writable(skb, tcp_offset + sizeof(*th)))
 		return 0;
 
 	th = (struct tcphdr *)(skb_network_header(skb) + tcp_offset);
@@ -440,7 +440,7 @@ static inline int app_tcp_pkt_in(struct ip_vs_conn *cp, struct sk_buff *skb,
 	struct tcphdr *th;
 	__u32 seq;
 
-	if (!skb_make_writable(skb, tcp_offset + sizeof(*th)))
+	if (skb_ensure_writable(skb, tcp_offset + sizeof(*th)))
 		return 0;
 
 	th = (struct tcphdr *)(skb_network_header(skb) + tcp_offset);
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 14457551bcb4..7b437c57f93d 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -897,7 +897,7 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
 	if (IPPROTO_TCP == protocol || IPPROTO_UDP == protocol ||
 	    IPPROTO_SCTP == protocol)
 		offset += 2 * sizeof(__u16);
-	if (!skb_make_writable(skb, offset))
+	if (skb_ensure_writable(skb, offset))
 		goto out;
 
 #ifdef CONFIG_IP_VS_IPV6
@@ -1287,7 +1287,7 @@ handle_response(int af, struct sk_buff *skb, struct ip_vs_proto_data *pd,
 
 	IP_VS_DBG_PKT(11, af, pp, skb, iph->off, "Outgoing packet");
 
-	if (!skb_make_writable(skb, iph->len))
+	if (skb_ensure_writable(skb, iph->len))
 		goto drop;
 
 	/* mangle the packet */
diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index fe69d46ff779..5cbefa927f09 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -273,7 +273,7 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
 		return 1;
 
 	/* Linear packets are much easier to deal with. */
-	if (!skb_make_writable(skb, skb->len))
+	if (skb_ensure_writable(skb, skb->len))
 		return 0;
 
 	if (cp->app_data == (void *) IP_VS_FTP_PASV) {
@@ -439,7 +439,7 @@ static int ip_vs_ftp_in(struct ip_vs_app *app, struct ip_vs_conn *cp,
 		return 1;
 
 	/* Linear packets are much easier to deal with. */
-	if (!skb_make_writable(skb, skb->len))
+	if (skb_ensure_writable(skb, skb->len))
 		return 0;
 
 	data = data_start = ip_vs_ftp_data_ptr(skb, ipvsh);
diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index b58ddb7dffd1..a0921adc31a9 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -101,7 +101,7 @@ sctp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 #endif
 
 	/* csum_check requires unshared skb */
-	if (!skb_make_writable(skb, sctphoff + sizeof(*sctph)))
+	if (skb_ensure_writable(skb, sctphoff + sizeof(*sctph)))
 		return 0;
 
 	if (unlikely(cp->app != NULL)) {
@@ -148,7 +148,7 @@ sctp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 #endif
 
 	/* csum_check requires unshared skb */
-	if (!skb_make_writable(skb, sctphoff + sizeof(*sctph)))
+	if (skb_ensure_writable(skb, sctphoff + sizeof(*sctph)))
 		return 0;
 
 	if (unlikely(cp->app != NULL)) {
diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index 00ce07dda980..089ee592a955 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -163,7 +163,7 @@ tcp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	oldlen = skb->len - tcphoff;
 
 	/* csum_check requires unshared skb */
-	if (!skb_make_writable(skb, tcphoff+sizeof(*tcph)))
+	if (skb_ensure_writable(skb, tcphoff + sizeof(*tcph)))
 		return 0;
 
 	if (unlikely(cp->app != NULL)) {
@@ -241,7 +241,7 @@ tcp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	oldlen = skb->len - tcphoff;
 
 	/* csum_check requires unshared skb */
-	if (!skb_make_writable(skb, tcphoff+sizeof(*tcph)))
+	if (skb_ensure_writable(skb, tcphoff + sizeof(*tcph)))
 		return 0;
 
 	if (unlikely(cp->app != NULL)) {
diff --git a/net/netfilter/ipvs/ip_vs_proto_udp.c b/net/netfilter/ipvs/ip_vs_proto_udp.c
index 92c078abcb3e..de366aa3c03b 100644
--- a/net/netfilter/ipvs/ip_vs_proto_udp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_udp.c
@@ -153,7 +153,7 @@ udp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	oldlen = skb->len - udphoff;
 
 	/* csum_check requires unshared skb */
-	if (!skb_make_writable(skb, udphoff+sizeof(*udph)))
+	if (skb_ensure_writable(skb, udphoff + sizeof(*udph)))
 		return 0;
 
 	if (unlikely(cp->app != NULL)) {
@@ -236,7 +236,7 @@ udp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	oldlen = skb->len - udphoff;
 
 	/* csum_check requires unshared skb */
-	if (!skb_make_writable(skb, udphoff+sizeof(*udph)))
+	if (skb_ensure_writable(skb, udphoff + sizeof(*udph)))
 		return 0;
 
 	if (unlikely(cp->app != NULL)) {
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 8d6f94b67772..0b41d0504429 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -279,7 +279,7 @@ static inline bool decrement_ttl(struct netns_ipvs *ipvs,
 		}
 
 		/* don't propagate ttl change to cloned packets */
-		if (!skb_make_writable(skb, sizeof(struct ipv6hdr)))
+		if (skb_ensure_writable(skb, sizeof(struct ipv6hdr)))
 			return false;
 
 		ipv6_hdr(skb)->hop_limit--;
@@ -294,7 +294,7 @@ static inline bool decrement_ttl(struct netns_ipvs *ipvs,
 		}
 
 		/* don't propagate ttl change to cloned packets */
-		if (!skb_make_writable(skb, sizeof(struct iphdr)))
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
 			return false;
 
 		/* Decrease ttl */
@@ -796,7 +796,7 @@ ip_vs_nat_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	}
 
 	/* copy-on-write the packet before mangling it */
-	if (!skb_make_writable(skb, sizeof(struct iphdr)))
+	if (skb_ensure_writable(skb, sizeof(struct iphdr)))
 		goto tx_error;
 
 	if (skb_cow(skb, rt->dst.dev->hard_header_len))
@@ -885,7 +885,7 @@ ip_vs_nat_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	}
 
 	/* copy-on-write the packet before mangling it */
-	if (!skb_make_writable(skb, sizeof(struct ipv6hdr)))
+	if (skb_ensure_writable(skb, sizeof(struct ipv6hdr)))
 		goto tx_error;
 
 	if (skb_cow(skb, rt->dst.dev->hard_header_len))
@@ -1404,7 +1404,7 @@ ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	}
 
 	/* copy-on-write the packet before mangling it */
-	if (!skb_make_writable(skb, offset))
+	if (skb_ensure_writable(skb, offset))
 		goto tx_error;
 
 	if (skb_cow(skb, rt->dst.dev->hard_header_len))
@@ -1493,7 +1493,7 @@ ip_vs_icmp_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	}
 
 	/* copy-on-write the packet before mangling it */
-	if (!skb_make_writable(skb, offset))
+	if (skb_ensure_writable(skb, offset))
 		goto tx_error;
 
 	if (skb_cow(skb, rt->dst.dev->hard_header_len))
-- 
2.21.0

