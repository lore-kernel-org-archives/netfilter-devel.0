Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2310CC43381
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9E2520838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbfCBSf0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:35:26 -0500
Received: from mail.us.es ([193.147.175.20]:35774 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726847AbfCBSfS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:35:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A1A6C1361B4
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:35:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 88D5ADA876
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:35:15 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 88092DA86C; Sat,  2 Mar 2019 19:35:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4B93BDA846;
        Sat,  2 Mar 2019 19:35:13 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:35:13 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id F07B04265A4C;
        Sat,  2 Mar 2019 19:35:12 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 09/29] netfilter: nat: remove csum_update hook
Date:   Sat,  2 Mar 2019 19:34:37 +0100
Message-Id: <20190302183457.3079-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183457.3079-1-pablo@netfilter.org>
References: <20190302183457.3079-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

We can now use direct calls.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat_l3proto.h |  5 ---
 net/netfilter/nf_nat_proto.c           | 69 ++++++++++++++++++----------------
 2 files changed, 36 insertions(+), 38 deletions(-)

diff --git a/include/net/netfilter/nf_nat_l3proto.h b/include/net/netfilter/nf_nat_l3proto.h
index 62ef15eb7594..c1123030c94f 100644
--- a/include/net/netfilter/nf_nat_l3proto.h
+++ b/include/net/netfilter/nf_nat_l3proto.h
@@ -5,11 +5,6 @@
 struct nf_nat_l3proto {
 	u8	l3proto;
 
-	void	(*csum_update)(struct sk_buff *skb, unsigned int iphdroff,
-			       __sum16 *check,
-			       const struct nf_conntrack_tuple *t,
-			       enum nf_nat_manip_type maniptype);
-
 	void	(*csum_recalc)(struct sk_buff *skb, u8 proto,
 			       void *data, __sum16 *check,
 			       int datalen, int oldlen);
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 5a6496dbf1bf..8a306a77914d 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -40,9 +40,13 @@ static const struct nf_nat_l3proto nf_nat_l3proto_ipv4;
 static const struct nf_nat_l3proto nf_nat_l3proto_ipv6;
 #endif
 
+static void nf_csum_update(struct sk_buff *skb,
+			   unsigned int iphdroff, __sum16 *check,
+			   const struct nf_conntrack_tuple *t,
+			   enum nf_nat_manip_type maniptype);
+
 static void
 __udp_manip_pkt(struct sk_buff *skb,
-	        const struct nf_nat_l3proto *l3proto,
 	        unsigned int iphdroff, struct udphdr *hdr,
 	        const struct nf_conntrack_tuple *tuple,
 	        enum nf_nat_manip_type maniptype, bool do_csum)
@@ -59,8 +63,7 @@ __udp_manip_pkt(struct sk_buff *skb,
 		portptr = &hdr->dest;
 	}
 	if (do_csum) {
-		l3proto->csum_update(skb, iphdroff, &hdr->check,
-				     tuple, maniptype);
+		nf_csum_update(skb, iphdroff, &hdr->check, tuple, maniptype);
 		inet_proto_csum_replace2(&hdr->check, skb, *portptr, newport,
 					 false);
 		if (!hdr->check)
@@ -70,7 +73,6 @@ __udp_manip_pkt(struct sk_buff *skb,
 }
 
 static bool udp_manip_pkt(struct sk_buff *skb,
-			  const struct nf_nat_l3proto *l3proto,
 			  unsigned int iphdroff, unsigned int hdroff,
 			  const struct nf_conntrack_tuple *tuple,
 			  enum nf_nat_manip_type maniptype)
@@ -84,12 +86,11 @@ static bool udp_manip_pkt(struct sk_buff *skb,
 	hdr = (struct udphdr *)(skb->data + hdroff);
 	do_csum = hdr->check || skb->ip_summed == CHECKSUM_PARTIAL;
 
-	__udp_manip_pkt(skb, l3proto, iphdroff, hdr, tuple, maniptype, do_csum);
+	__udp_manip_pkt(skb, iphdroff, hdr, tuple, maniptype, do_csum);
 	return true;
 }
 
 static bool udplite_manip_pkt(struct sk_buff *skb,
-			      const struct nf_nat_l3proto *l3proto,
 			      unsigned int iphdroff, unsigned int hdroff,
 			      const struct nf_conntrack_tuple *tuple,
 			      enum nf_nat_manip_type maniptype)
@@ -101,14 +102,13 @@ static bool udplite_manip_pkt(struct sk_buff *skb,
 		return false;
 
 	hdr = (struct udphdr *)(skb->data + hdroff);
-	__udp_manip_pkt(skb, l3proto, iphdroff, hdr, tuple, maniptype, true);
+	__udp_manip_pkt(skb, iphdroff, hdr, tuple, maniptype, true);
 #endif
 	return true;
 }
 
 static bool
 sctp_manip_pkt(struct sk_buff *skb,
-	       const struct nf_nat_l3proto *l3proto,
 	       unsigned int iphdroff, unsigned int hdroff,
 	       const struct nf_conntrack_tuple *tuple,
 	       enum nf_nat_manip_type maniptype)
@@ -151,7 +151,6 @@ sctp_manip_pkt(struct sk_buff *skb,
 
 static bool
 tcp_manip_pkt(struct sk_buff *skb,
-	      const struct nf_nat_l3proto *l3proto,
 	      unsigned int iphdroff, unsigned int hdroff,
 	      const struct nf_conntrack_tuple *tuple,
 	      enum nf_nat_manip_type maniptype)
@@ -187,14 +186,13 @@ tcp_manip_pkt(struct sk_buff *skb,
 	if (hdrsize < sizeof(*hdr))
 		return true;
 
-	l3proto->csum_update(skb, iphdroff, &hdr->check, tuple, maniptype);
+	nf_csum_update(skb, iphdroff, &hdr->check, tuple, maniptype);
 	inet_proto_csum_replace2(&hdr->check, skb, oldport, newport, false);
 	return true;
 }
 
 static bool
 dccp_manip_pkt(struct sk_buff *skb,
-	       const struct nf_nat_l3proto *l3proto,
 	       unsigned int iphdroff, unsigned int hdroff,
 	       const struct nf_conntrack_tuple *tuple,
 	       enum nf_nat_manip_type maniptype)
@@ -226,8 +224,7 @@ dccp_manip_pkt(struct sk_buff *skb,
 	if (hdrsize < sizeof(*hdr))
 		return true;
 
-	l3proto->csum_update(skb, iphdroff, &hdr->dccph_checksum,
-			     tuple, maniptype);
+	nf_csum_update(skb, iphdroff, &hdr->dccph_checksum, tuple, maniptype);
 	inet_proto_csum_replace2(&hdr->dccph_checksum, skb, oldport, newport,
 				 false);
 #endif
@@ -236,7 +233,6 @@ dccp_manip_pkt(struct sk_buff *skb,
 
 static bool
 icmp_manip_pkt(struct sk_buff *skb,
-	       const struct nf_nat_l3proto *l3proto,
 	       unsigned int iphdroff, unsigned int hdroff,
 	       const struct nf_conntrack_tuple *tuple,
 	       enum nf_nat_manip_type maniptype)
@@ -255,7 +251,6 @@ icmp_manip_pkt(struct sk_buff *skb,
 
 static bool
 icmpv6_manip_pkt(struct sk_buff *skb,
-		 const struct nf_nat_l3proto *l3proto,
 		 unsigned int iphdroff, unsigned int hdroff,
 		 const struct nf_conntrack_tuple *tuple,
 		 enum nf_nat_manip_type maniptype)
@@ -266,8 +261,7 @@ icmpv6_manip_pkt(struct sk_buff *skb,
 		return false;
 
 	hdr = (struct icmp6hdr *)(skb->data + hdroff);
-	l3proto->csum_update(skb, iphdroff, &hdr->icmp6_cksum,
-			     tuple, maniptype);
+	nf_csum_update(skb, iphdroff, &hdr->icmp6_cksum, tuple, maniptype);
 	if (hdr->icmp6_type == ICMPV6_ECHO_REQUEST ||
 	    hdr->icmp6_type == ICMPV6_ECHO_REPLY) {
 		inet_proto_csum_replace2(&hdr->icmp6_cksum, skb,
@@ -281,7 +275,6 @@ icmpv6_manip_pkt(struct sk_buff *skb,
 /* manipulate a GRE packet according to maniptype */
 static bool
 gre_manip_pkt(struct sk_buff *skb,
-	      const struct nf_nat_l3proto *l3proto,
 	      unsigned int iphdroff, unsigned int hdroff,
 	      const struct nf_conntrack_tuple *tuple,
 	      enum nf_nat_manip_type maniptype)
@@ -321,35 +314,34 @@ gre_manip_pkt(struct sk_buff *skb,
 }
 
 static bool l4proto_manip_pkt(struct sk_buff *skb,
-			      const struct nf_nat_l3proto *l3proto,
 			      unsigned int iphdroff, unsigned int hdroff,
 			      const struct nf_conntrack_tuple *tuple,
 			      enum nf_nat_manip_type maniptype)
 {
 	switch (tuple->dst.protonum) {
 	case IPPROTO_TCP:
-		return tcp_manip_pkt(skb, l3proto, iphdroff, hdroff,
+		return tcp_manip_pkt(skb, iphdroff, hdroff,
 				     tuple, maniptype);
 	case IPPROTO_UDP:
-		return udp_manip_pkt(skb, l3proto, iphdroff, hdroff,
+		return udp_manip_pkt(skb, iphdroff, hdroff,
 				     tuple, maniptype);
 	case IPPROTO_UDPLITE:
-		return udplite_manip_pkt(skb, l3proto, iphdroff, hdroff,
+		return udplite_manip_pkt(skb, iphdroff, hdroff,
 					 tuple, maniptype);
 	case IPPROTO_SCTP:
-		return sctp_manip_pkt(skb, l3proto, iphdroff, hdroff,
+		return sctp_manip_pkt(skb, iphdroff, hdroff,
 				      tuple, maniptype);
 	case IPPROTO_ICMP:
-		return icmp_manip_pkt(skb, l3proto, iphdroff, hdroff,
+		return icmp_manip_pkt(skb, iphdroff, hdroff,
 				      tuple, maniptype);
 	case IPPROTO_ICMPV6:
-		return icmpv6_manip_pkt(skb, l3proto, iphdroff, hdroff,
+		return icmpv6_manip_pkt(skb, iphdroff, hdroff,
 					tuple, maniptype);
 	case IPPROTO_DCCP:
-		return dccp_manip_pkt(skb, l3proto, iphdroff, hdroff,
+		return dccp_manip_pkt(skb, iphdroff, hdroff,
 				      tuple, maniptype);
 	case IPPROTO_GRE:
-		return gre_manip_pkt(skb, l3proto, iphdroff, hdroff,
+		return gre_manip_pkt(skb, iphdroff, hdroff,
 				     tuple, maniptype);
 	}
 
@@ -371,8 +363,7 @@ static bool nf_nat_ipv4_manip_pkt(struct sk_buff *skb,
 	iph = (void *)skb->data + iphdroff;
 	hdroff = iphdroff + iph->ihl * 4;
 
-	if (!l4proto_manip_pkt(skb, &nf_nat_l3proto_ipv4, iphdroff,
-			       hdroff, target, maniptype))
+	if (!l4proto_manip_pkt(skb, iphdroff, hdroff, target, maniptype))
 		return false;
 	iph = (void *)skb->data + iphdroff;
 
@@ -408,8 +399,7 @@ static bool nf_nat_ipv6_manip_pkt(struct sk_buff *skb,
 		goto manip_addr;
 
 	if ((frag_off & htons(~0x7)) == 0 &&
-	    !l4proto_manip_pkt(skb, &nf_nat_l3proto_ipv6, iphdroff, hdroff,
-			       target, maniptype))
+	    !l4proto_manip_pkt(skb, iphdroff, hdroff, target, maniptype))
 		return false;
 
 	/* must reload, offset might have changed */
@@ -490,6 +480,21 @@ static void nf_nat_ipv6_csum_update(struct sk_buff *skb,
 #endif
 }
 
+static void nf_csum_update(struct sk_buff *skb,
+			   unsigned int iphdroff, __sum16 *check,
+			   const struct nf_conntrack_tuple *t,
+			   enum nf_nat_manip_type maniptype)
+{
+	switch (t->src.l3num) {
+	case NFPROTO_IPV4:
+		nf_nat_ipv4_csum_update(skb, iphdroff, check, t, maniptype);
+		return;
+	case NFPROTO_IPV6:
+		nf_nat_ipv6_csum_update(skb, iphdroff, check, t, maniptype);
+		return;
+	}
+}
+
 static void nf_nat_ipv4_csum_recalc(struct sk_buff *skb,
 				    u8 proto, void *data, __sum16 *check,
 				    int datalen, int oldlen)
@@ -532,7 +537,6 @@ static void nf_nat_ipv6_csum_recalc(struct sk_buff *skb,
 
 static const struct nf_nat_l3proto nf_nat_l3proto_ipv4 = {
 	.l3proto		= NFPROTO_IPV4,
-	.csum_update		= nf_nat_ipv4_csum_update,
 	.csum_recalc		= nf_nat_ipv4_csum_recalc,
 };
 
@@ -784,7 +788,6 @@ void nf_nat_l3proto_exit(void)
 #if IS_ENABLED(CONFIG_IPV6)
 static const struct nf_nat_l3proto nf_nat_l3proto_ipv6 = {
 	.l3proto		= NFPROTO_IPV6,
-	.csum_update		= nf_nat_ipv6_csum_update,
 	.csum_recalc		= nf_nat_ipv6_csum_recalc,
 };
 
-- 
2.11.0


