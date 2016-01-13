From: Alin Nastac <alin.nastac@gmail.com>
Subject: [PATCH] netfilter: nf_conntrack_icmpv6: find conntrack related to ICMPv6 redirect packet
Date: Wed, 13 Jan 2016 15:34:20 +0100
Message-ID: <1452695660-14013-1-git-send-email-alin.nastac@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38827 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbcAMOea (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2016 09:34:30 -0500
Received: by mail-wm0-f54.google.com with SMTP id b14so374950991wmb.1
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 06:34:29 -0800 (PST)
Received: from cplx250.edegem.eu.thmulti.com (14.125.146.82.ipv4.evonet.be. [82.146.125.14])
        by smtp.gmail.com with ESMTPSA id m128sm22429824wma.24.2016.01.13.06.34.27
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Jan 2016 06:34:28 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c | 77 ++++++++++++++++++++++++--
 1 file changed, 72 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 660bc10..699848a 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -144,7 +144,7 @@ static bool icmpv6_new(struct nf_conn *ct, const struct sk_buff *skb,
 static int
 icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 		     struct sk_buff *skb,
-		     unsigned int icmp6off,
+		     unsigned int inneripv6off,
 		     enum ip_conntrack_info *ctinfo,
 		     unsigned int hooknum)
 {
@@ -157,9 +157,7 @@ icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 
 	/* Are they talking about one of our connections? */
 	if (!nf_ct_get_tuplepr(skb,
-			       skb_network_offset(skb)
-				+ sizeof(struct ipv6hdr)
-				+ sizeof(struct icmp6hdr),
+			       inneripv6off,
 			       PF_INET6, net, &origtuple)) {
 		pr_debug("icmpv6_error: Can't get tuple\n");
 		return -NF_ACCEPT;
@@ -227,9 +225,78 @@ icmpv6_error(struct net *net, struct nf_conn *tmpl,
 		nf_conntrack_get(skb->nfct);
 		return NF_ACCEPT;
 	}
+	dataoff += sizeof(struct icmp6hdr);
 
 	/* is not error message ? */
-	if (icmp6h->icmp6_type >= 128)
+	if (icmp6h->icmp6_type == NDISC_REDIRECT) {
+		const struct in6_addr *dst;
+		struct in6_addr _dst;
+		const struct nd_opt_hdr *opt;
+		struct nd_opt_hdr _opt;
+		const struct ipv6hdr *iph;
+		struct ipv6hdr _iph;
+
+		/* skip target address */
+		dataoff += sizeof(_dst);
+
+		/* read destination address */
+		dst = skb_header_pointer(skb, dataoff, sizeof(_dst), &_dst);
+		if (dst == NULL) {
+			if (LOG_INVALID(net, IPPROTO_ICMPV6))
+			nf_log_packet(net, PF_INET6, 0, skb, NULL, NULL, NULL,
+				      "nf_ct_icmpv6: short redirect packet ");
+			return -NF_ACCEPT;
+		}
+		if (ipv6_addr_is_multicast(dst)) {
+			if (LOG_INVALID(net, IPPROTO_ICMPV6))
+			nf_log_packet(net, PF_INET6, 0, skb, NULL, NULL, NULL,
+				      "nf_ct_icmpv6: redirect destination address is multicast ");
+			return -NF_ACCEPT;
+		}
+		dataoff += sizeof(_dst);
+
+		/* find redirected header */
+		while (1) {
+			opt = skb_header_pointer(skb, dataoff, sizeof(_opt), &_opt);
+			if (opt == NULL) {
+				if (LOG_INVALID(net, IPPROTO_ICMPV6))
+				nf_log_packet(net, PF_INET6, 0, skb, NULL, NULL, NULL,
+					      "nf_ct_icmpv6: invalid redirect option ");
+				return -NF_ACCEPT;
+			}
+			if (opt->nd_opt_len == 0) {
+				if (LOG_INVALID(net, IPPROTO_ICMPV6))
+				nf_log_packet(net, PF_INET6, 0, skb, NULL, NULL, NULL,
+					      "nf_ct_icmpv6: invalid redirect option length ");
+				return -NF_ACCEPT;
+			}
+
+			if (opt->nd_opt_type == ND_OPT_REDIRECT_HDR) {
+				dataoff += 8;
+				break;
+			}
+
+			dataoff += opt->nd_opt_len << 3;
+		}
+
+		/* read redirect header */
+		iph = skb_header_pointer(skb, dataoff, sizeof(_iph), &_iph);
+		if (iph == NULL) {
+			if (LOG_INVALID(net, IPPROTO_ICMPV6))
+			nf_log_packet(net, PF_INET6, 0, skb, NULL, NULL, NULL,
+				      "nf_ct_icmpv6: short redirect header ");
+			return -NF_ACCEPT;
+		}
+
+		/* validate destination address */
+		if (!ipv6_addr_equal(&iph->daddr, dst)) {
+			if (LOG_INVALID(net, IPPROTO_ICMPV6))
+			nf_log_packet(net, PF_INET6, 0, skb, NULL, NULL, NULL,
+				      "nf_ct_icmpv6: redirect destination address not matching destination address of redirect header ");
+			return -NF_ACCEPT;
+		}
+	}
+	else if (icmp6h->icmp6_type >= 128)
 		return NF_ACCEPT;
 
 	return icmpv6_error_message(net, tmpl, skb, dataoff, ctinfo, hooknum);
-- 
1.7.12.4

