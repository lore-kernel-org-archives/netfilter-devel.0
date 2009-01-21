From: Eric Leblond <eric@inl.fr>
Subject: [Resend PATCH 2/2] netfilter: don't track ICMPv6 negotiation message.
Date: Thu, 22 Jan 2009 00:51:52 +0100
Message-ID: <1232581912-19009-1-git-send-email-eric@inl.fr>
References: <1232581791.16003.49.camel@ice-age>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: yasuyuki.kozakai@toshiba.co.jp, kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:35280 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753934AbZAUXwB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Jan 2009 18:52:01 -0500
In-Reply-To: <1232581791.16003.49.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes connection tracking handling for ICMPv6 messages
related to autoconfiguration. They can be tracked because they are
massively using multicast (on pre-defined address). But they are not
invalid.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 4aa80ba..a178270 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -54,6 +54,17 @@ static const u_int8_t invmap[] = {
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
@@ -198,6 +209,17 @@ icmpv6_error(struct net *net, struct sk_buff *skb, unsigned int dataoff,
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

