Return-Path: <SRS0=SfI0=TX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E6DCC282DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 13:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 050DB20881
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 13:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbfEWNnm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 May 2019 09:43:42 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48826 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729698AbfEWNnm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 May 2019 09:43:42 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hTo0R-0007jJ-UF; Thu, 23 May 2019 15:43:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/8] netfilter: conntrack, nat: prefer skb_ensure_writable
Date:   Thu, 23 May 2019 15:44:07 +0200
Message-Id: <20190523134412.3295-4-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523134412.3295-1-fw@strlen.de>
References: <20190523134412.3295-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

like previous patches -- convert conntrack to use the core helper.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_sctp.c |  2 +-
 net/netfilter/nf_conntrack_seqadj.c     |  4 ++--
 net/netfilter/nf_nat_helper.c           |  4 ++--
 net/netfilter/nf_nat_proto.c            | 24 ++++++++++++------------
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 5b8dde266412..07c5208a4ea0 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -339,7 +339,7 @@ static bool sctp_error(struct sk_buff *skb,
 	if (state->hook == NF_INET_PRE_ROUTING &&
 	    state->net->ct.sysctl_checksum &&
 	    skb->ip_summed == CHECKSUM_NONE) {
-		if (!skb_make_writable(skb, dataoff + sizeof(struct sctphdr))) {
+		if (skb_ensure_writable(skb, dataoff + sizeof(*sh))) {
 			logmsg = "nf_ct_sctp: failed to read header ";
 			goto out_invalid;
 		}
diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index 9da303461069..3d7e240295b2 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -125,7 +125,7 @@ static unsigned int nf_ct_sack_adjust(struct sk_buff *skb,
 	optoff = protoff + sizeof(struct tcphdr);
 	optend = protoff + tcph->doff * 4;
 
-	if (!skb_make_writable(skb, optend))
+	if (skb_ensure_writable(skb, optend))
 		return 0;
 
 	tcph = (void *)skb->data + protoff;
@@ -175,7 +175,7 @@ int nf_ct_seq_adjust(struct sk_buff *skb,
 	this_way  = &seqadj->seq[dir];
 	other_way = &seqadj->seq[!dir];
 
-	if (!skb_make_writable(skb, protoff + sizeof(*tcph)))
+	if (skb_ensure_writable(skb, protoff + sizeof(*tcph)))
 		return 0;
 
 	tcph = (void *)skb->data + protoff;
diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.c
index ccc06f7539d7..03e8e2d79375 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -98,7 +98,7 @@ bool __nf_nat_mangle_tcp_packet(struct sk_buff *skb,
 	struct tcphdr *tcph;
 	int oldlen, datalen;
 
-	if (!skb_make_writable(skb, skb->len))
+	if (skb_ensure_writable(skb, skb->len))
 		return false;
 
 	if (rep_len > match_len &&
@@ -148,7 +148,7 @@ nf_nat_mangle_udp_packet(struct sk_buff *skb,
 	struct udphdr *udph;
 	int datalen, oldlen;
 
-	if (!skb_make_writable(skb, skb->len))
+	if (skb_ensure_writable(skb, skb->len))
 		return false;
 
 	if (rep_len > match_len &&
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 84f5c90a7f21..04a6c1ac2526 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -73,7 +73,7 @@ static bool udp_manip_pkt(struct sk_buff *skb,
 	struct udphdr *hdr;
 	bool do_csum;
 
-	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
+	if (skb_ensure_writable(skb, hdroff + sizeof(*hdr)))
 		return false;
 
 	hdr = (struct udphdr *)(skb->data + hdroff);
@@ -91,7 +91,7 @@ static bool udplite_manip_pkt(struct sk_buff *skb,
 #ifdef CONFIG_NF_CT_PROTO_UDPLITE
 	struct udphdr *hdr;
 
-	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
+	if (skb_ensure_writable(skb, hdroff + sizeof(*hdr)))
 		return false;
 
 	hdr = (struct udphdr *)(skb->data + hdroff);
@@ -117,7 +117,7 @@ sctp_manip_pkt(struct sk_buff *skb,
 	if (skb->len >= hdroff + sizeof(*hdr))
 		hdrsize = sizeof(*hdr);
 
-	if (!skb_make_writable(skb, hdroff + hdrsize))
+	if (skb_ensure_writable(skb, hdroff + hdrsize))
 		return false;
 
 	hdr = (struct sctphdr *)(skb->data + hdroff);
@@ -158,7 +158,7 @@ tcp_manip_pkt(struct sk_buff *skb,
 	if (skb->len >= hdroff + sizeof(struct tcphdr))
 		hdrsize = sizeof(struct tcphdr);
 
-	if (!skb_make_writable(skb, hdroff + hdrsize))
+	if (skb_ensure_writable(skb, hdroff + hdrsize))
 		return false;
 
 	hdr = (struct tcphdr *)(skb->data + hdroff);
@@ -198,7 +198,7 @@ dccp_manip_pkt(struct sk_buff *skb,
 	if (skb->len >= hdroff + sizeof(struct dccp_hdr))
 		hdrsize = sizeof(struct dccp_hdr);
 
-	if (!skb_make_writable(skb, hdroff + hdrsize))
+	if (skb_ensure_writable(skb, hdroff + hdrsize))
 		return false;
 
 	hdr = (struct dccp_hdr *)(skb->data + hdroff);
@@ -232,7 +232,7 @@ icmp_manip_pkt(struct sk_buff *skb,
 {
 	struct icmphdr *hdr;
 
-	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
+	if (skb_ensure_writable(skb, hdroff + sizeof(*hdr)))
 		return false;
 
 	hdr = (struct icmphdr *)(skb->data + hdroff);
@@ -250,7 +250,7 @@ icmpv6_manip_pkt(struct sk_buff *skb,
 {
 	struct icmp6hdr *hdr;
 
-	if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
+	if (skb_ensure_writable(skb, hdroff + sizeof(*hdr)))
 		return false;
 
 	hdr = (struct icmp6hdr *)(skb->data + hdroff);
@@ -278,7 +278,7 @@ gre_manip_pkt(struct sk_buff *skb,
 
 	/* pgreh includes two optional 32bit fields which are not required
 	 * to be there.  That's where the magic '8' comes from */
-	if (!skb_make_writable(skb, hdroff + sizeof(*pgreh) - 8))
+	if (skb_ensure_writable(skb, hdroff + sizeof(*pgreh) - 8))
 		return false;
 
 	greh = (void *)skb->data + hdroff;
@@ -350,7 +350,7 @@ static bool nf_nat_ipv4_manip_pkt(struct sk_buff *skb,
 	struct iphdr *iph;
 	unsigned int hdroff;
 
-	if (!skb_make_writable(skb, iphdroff + sizeof(*iph)))
+	if (skb_ensure_writable(skb, iphdroff + sizeof(*iph)))
 		return false;
 
 	iph = (void *)skb->data + iphdroff;
@@ -381,7 +381,7 @@ static bool nf_nat_ipv6_manip_pkt(struct sk_buff *skb,
 	int hdroff;
 	u8 nexthdr;
 
-	if (!skb_make_writable(skb, iphdroff + sizeof(*ipv6h)))
+	if (skb_ensure_writable(skb, iphdroff + sizeof(*ipv6h)))
 		return false;
 
 	ipv6h = (void *)skb->data + iphdroff;
@@ -565,7 +565,7 @@ int nf_nat_icmp_reply_translation(struct sk_buff *skb,
 
 	WARN_ON(ctinfo != IP_CT_RELATED && ctinfo != IP_CT_RELATED_REPLY);
 
-	if (!skb_make_writable(skb, hdrlen + sizeof(*inside)))
+	if (skb_ensure_writable(skb, hdrlen + sizeof(*inside)))
 		return 0;
 	if (nf_ip_checksum(skb, hooknum, hdrlen, 0))
 		return 0;
@@ -787,7 +787,7 @@ int nf_nat_icmpv6_reply_translation(struct sk_buff *skb,
 
 	WARN_ON(ctinfo != IP_CT_RELATED && ctinfo != IP_CT_RELATED_REPLY);
 
-	if (!skb_make_writable(skb, hdrlen + sizeof(*inside)))
+	if (skb_ensure_writable(skb, hdrlen + sizeof(*inside)))
 		return 0;
 	if (nf_ip6_checksum(skb, hooknum, hdrlen, IPPROTO_ICMPV6))
 		return 0;
-- 
2.21.0

