From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] netfilter: don't track ICMPv6 negotiation message.
Date: Sat, 24 Jan 2009 11:32:58 +0100
Message-ID: <1232793178-10922-1-git-send-email-eric@inl.fr>
References: <200901231110.n0NBARDe000646@toshiba.co.jp>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: yasuyuki.kozakai@toshiba.co.jp, kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43558 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751156AbZAXKdE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Jan 2009 05:33:04 -0500
In-Reply-To: <200901231110.n0NBARDe000646@toshiba.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes connection tracking handling for ICMPv6 messages
related to autoconfiguration. They can be tracked because they are
massively using multicast (on pre-defined address). But they are not
invalid.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 6f859c1..94ace19 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -53,6 +53,17 @@ static const u_int8_t invmap[] = {
 	[ICMPV6_NI_REPLY - 128]		= ICMPV6_NI_QUERY +1
 };
 
+static const u_int8_t noct_valid_new[] = {
+	[ICMPV6_MGM_QUERY - 130] = 1,
+	[ICMPV6_MGM_REPORT -130] = 1,
+	[ICMPV6_MGM_REDUCTION - 130] = 1,
+	[NDISC_ROUTER_SOLICITATION - 130] = 1,
+	[NDISC_ROUTER_ADVERTISEMENT - 130] = 1,
+	[NDISC_NEIGHBOUR_SOLICITATION - 130] = 1,
+	[NDISC_NEIGHBOUR_ADVERTISEMENT - 130] = 1,
+	[ICMPV6_MLD2_REPORT - 130] = 1
+};
+
 static bool icmpv6_invert_tuple(struct nf_conntrack_tuple *tuple,
 				const struct nf_conntrack_tuple *orig)
 {
@@ -182,6 +193,7 @@ icmpv6_error(struct net *net, struct sk_buff *skb, unsigned int dataoff,
 {
 	const struct icmp6hdr *icmp6h;
 	struct icmp6hdr _ih;
+	int type;
 
 	icmp6h = skb_header_pointer(skb, dataoff, sizeof(_ih), &_ih);
 	if (icmp6h == NULL) {
@@ -199,6 +211,15 @@ icmpv6_error(struct net *net, struct sk_buff *skb, unsigned int dataoff,
 		return -NF_ACCEPT;
 	}
 
+	type = icmp6h->icmp6_type - 130;
+	if (type >= 0 && type < sizeof(noct_valid_new)
+	    && noct_valid_new[type]) {
+		skb->nfct = &nf_conntrack_untracked.ct_general;
+		skb->nfctinfo = IP_CT_NEW;
+		nf_conntrack_get(skb->nfct);
+		return NF_ACCEPT;
+	}
+
 	/* is not error message ? */
 	if (icmp6h->icmp6_type >= 128)
 		return NF_ACCEPT;
-- 
1.5.6.3

