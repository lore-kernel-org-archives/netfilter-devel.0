From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 2/2] netfilter: don't track ICMPv6 negotiation message.
Date: Thu, 22 Jan 2009 00:43:51 +0100
Message-ID: <1232581431-15130-2-git-send-email-eric@inl.fr>
References: <1232581287.16003.47.camel@ice-age>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: yasuyuki.kozakai@toshiba.co.jp, kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:53960 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755523AbZAUXoB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Jan 2009 18:44:01 -0500
In-Reply-To: <1232581287.16003.47.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes connection tracking handling for ICMPv6 messages
related to autoconfiguration. They can be tracked because they are
massively using multicast (on pre-defined address). But they are not
invalid.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   27 +++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 4aa80ba..34548c3 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -54,12 +54,25 @@ static const u_int8_t invmap[] = {
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
 	int type = orig->dst.u.icmp.type - 128;
-	if (type < 0 || type >= sizeof(invmap) || !invmap[type])
+
+	if (type < 0 || type >= sizeof(invmap) || !invmap[type]) {
 		return false;
+	}
 
 	tuple->src.u.icmp.id   = orig->src.u.icmp.id;
 	tuple->dst.u.icmp.type = invmap[type] - 1;
@@ -109,6 +122,7 @@ static bool icmpv6_new(struct nf_conn *ct, const struct sk_buff *skb,
 		[ICMPV6_ECHO_REQUEST - 128] = 1,
 		[ICMPV6_NI_QUERY - 128] = 1
 	};
+
 	int type = ct->tuplehash[0].tuple.dst.u.icmp.type - 128;
 
 	if (type < 0 || type >= sizeof(valid_new) || !valid_new[type]) {
@@ -198,6 +212,17 @@ icmpv6_error(struct net *net, struct sk_buff *skb, unsigned int dataoff,
 		return -NF_ACCEPT;
 	}
 
+	/* autoconf message handling */
+	if (nf_ct_icmpv6_autoconf) {
+		int type = icmp6h->icmp6_type - 130;
+		if (type >= 0 && type < sizeof(noct_valid_new)
+		    && noct_valid_new[type]) {
+			skb->nfct = &nf_conntrack_untracked.ct_general;
+			skb->nfctinfo = IP_CT_NEW;
+			nf_conntrack_get(skb->nfct);
+			return -NF_ACCEPT;
+		}
+	}
 	/* is not error message ? */
 	if (icmp6h->icmp6_type >= 128)
 		return NF_ACCEPT;
-- 
1.5.6.3

