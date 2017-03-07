From: Alin Nastac <alin.nastac@gmail.com>
Subject: [PATCH v2] netfilter: Parse ICMPv6 redirects
Date: Tue,  7 Mar 2017 11:00:43 +0100
Message-ID: <1488880843-9352-1-git-send-email-alin.nastac@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36433 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755923AbdCGVb1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2017 16:31:27 -0500
Received: by mail-wr0-f195.google.com with SMTP id l37so1826313wrc.3
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Mar 2017 13:30:56 -0800 (PST)
Received: from cplx250.edegem.eu.thmulti.com (14.125.146.82.ipv4.evonet.be. [82.146.125.14])
        by smtp.gmail.com with ESMTPSA id j74sm15403195wrj.21.2017.03.07.02.00.49
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Mar 2017 02:00:49 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Extract IPv6 packet that triggered the sending of redirect message from
ICMPv6 Redirected Header option and check if conntrack table contain such
connection. Mark redirect packet as RELATED if a matching connection is found.

Signed-off-by: Alin Nastac <alin.nastac@gmail.com>
---
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c | 87 ++++++++++++++++++++++++--
 1 file changed, 82 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index d2c2ccb..f7bae5c 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -144,7 +144,7 @@ static bool icmpv6_new(struct nf_conn *ct, const struct sk_buff *skb,
 static int
 icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 		     struct sk_buff *skb,
-		     unsigned int icmp6off,
+		     unsigned int inneripv6off,
 		     unsigned int hooknum)
 {
 	struct nf_conntrack_tuple intuple, origtuple;
@@ -157,9 +157,7 @@ static bool icmpv6_new(struct nf_conn *ct, const struct sk_buff *skb,
 
 	/* Are they talking about one of our connections? */
 	if (!nf_ct_get_tuplepr(skb,
-			       skb_network_offset(skb)
-				+ sizeof(struct ipv6hdr)
-				+ sizeof(struct icmp6hdr),
+			       inneripv6off,
 			       PF_INET6, net, &origtuple)) {
 		pr_debug("icmpv6_error: Can't get tuple\n");
 		return -NF_ACCEPT;
@@ -194,6 +192,82 @@ static bool icmpv6_new(struct nf_conn *ct, const struct sk_buff *skb,
 }
 
 static int
+icmpv6_redirect_message(struct net *net, struct nf_conn *tmpl,
+		     struct sk_buff *skb,
+		     unsigned int dataoff,
+		     unsigned int hooknum)
+{
+	const struct in6_addr *dst;
+	struct in6_addr _dst;
+	const struct nd_opt_hdr *opt;
+	struct nd_opt_hdr _opt;
+	const struct ipv6hdr *iph;
+	struct ipv6hdr _iph;
+
+	/* skip target address */
+	dataoff += sizeof(_dst);
+
+	/* read destination address */
+	dst = skb_header_pointer(skb, dataoff, sizeof(_dst), &_dst);
+	if (dst == NULL) {
+		if (LOG_INVALID(net, IPPROTO_ICMPV6))
+			nf_log_packet(net, PF_INET6, 0, skb, NULL, NULL, NULL,
+			      "nf_ct_icmpv6: short redirect packet ");
+		return -NF_ACCEPT;
+	}
+	if (ipv6_addr_is_multicast(dst)) {
+		if (LOG_INVALID(net, IPPROTO_ICMPV6))
+			nf_log_packet(net, PF_INET6, 0, skb, NULL, NULL, NULL,
+			      "nf_ct_icmpv6: redirect destination address is multicast ");
+		return -NF_ACCEPT;
+	}
+	dataoff += sizeof(_dst);
+
+	/* find redirected header */
+	while (1) {
+		opt = skb_header_pointer(skb, dataoff, sizeof(_opt), &_opt);
+		if (opt == NULL) {
+			if (LOG_INVALID(net, IPPROTO_ICMPV6))
+				nf_log_packet(net, PF_INET6, 0, skb, NULL, NULL, NULL,
+				      "nf_ct_icmpv6: invalid redirect option ");
+			return -NF_ACCEPT;
+		}
+		if (opt->nd_opt_len == 0) {
+			if (LOG_INVALID(net, IPPROTO_ICMPV6))
+				nf_log_packet(net, PF_INET6, 0, skb, NULL, NULL, NULL,
+				      "nf_ct_icmpv6: invalid redirect option length ");
+			return -NF_ACCEPT;
+		}
+
+		if (opt->nd_opt_type == ND_OPT_REDIRECT_HDR) {
+			dataoff += 8;
+			break;
+		}
+
+		dataoff += opt->nd_opt_len << 3;
+	}
+
+	/* read redirect header */
+	iph = skb_header_pointer(skb, dataoff, sizeof(_iph), &_iph);
+	if (iph == NULL) {
+		if (LOG_INVALID(net, IPPROTO_ICMPV6))
+			nf_log_packet(net, PF_INET6, 0, skb, NULL, NULL, NULL,
+			      "nf_ct_icmpv6: short redirect header ");
+		return -NF_ACCEPT;
+	}
+
+	/* validate destination address */
+	if (!ipv6_addr_equal(&iph->daddr, dst)) {
+		if (LOG_INVALID(net, IPPROTO_ICMPV6))
+			nf_log_packet(net, PF_INET6, 0, skb, NULL, NULL, NULL,
+			      "nf_ct_icmpv6: redirect destination address not matching destination address of redirect header ");
+		return -NF_ACCEPT;
+	}
+	
+	return icmpv6_error_message(net, tmpl, skb, dataoff, hooknum);
+}
+
+static int
 icmpv6_error(struct net *net, struct nf_conn *tmpl,
 	     struct sk_buff *skb, unsigned int dataoff,
 	     u8 pf, unsigned int hooknum)
@@ -225,9 +299,12 @@ static bool icmpv6_new(struct nf_conn *ct, const struct sk_buff *skb,
 		nf_conntrack_get(skb_nfct(skb));
 		return NF_ACCEPT;
 	}
+	dataoff += sizeof(struct icmp6hdr);
 
 	/* is not error message ? */
-	if (icmp6h->icmp6_type >= 128)
+	if (icmp6h->icmp6_type == NDISC_REDIRECT)
+		return icmpv6_redirect_message(net, tmpl, skb, dataoff, hooknum);
+	else if (icmp6h->icmp6_type >= 128)
 		return NF_ACCEPT;
 
 	return icmpv6_error_message(net, tmpl, skb, dataoff, hooknum);
-- 
1.7.12.4

