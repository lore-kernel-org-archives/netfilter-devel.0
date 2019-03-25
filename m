Return-Path: <SRS0=irZF=R4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D724C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Mar 2019 22:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EA2920811
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Mar 2019 22:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbfCYWVM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Mar 2019 18:21:12 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:58550 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726217AbfCYWVL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Mar 2019 18:21:11 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1h8Xxq-00075T-EV; Mon, 25 Mar 2019 23:21:06 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     luca.moro@synacktiv.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/2] netfilter: conntrack: don't set related state for different outer address
Date:   Mon, 25 Mar 2019 23:11:54 +0100
Message-Id: <20190325221154.6874-2-fw@strlen.de>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190325221154.6874-1-fw@strlen.de>
References: <20190325221154.6874-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Luca Moro says:
 ------
The issue lies in the filtering of ICMP and ICMPv6 errors that include an
inner IP datagram.
For these packets, icmp_error_message() extract the ICMP error and inner
layer to search of a known state.
If a state is found the packet is tagged as related (IP_CT_RELATED).

The problem is that there is no correlation check between the inner and
outer layer of the packet.
So one can encapsulate an error with an inner layer matching a known state,
while its outer layer is directed to a filtered host.
In this case the whole packet will be tagged as related.
This has various implications from a rule bypass (if a rule to related
trafic is allow), to a known state oracle.

Unfortunately, we could not find a real statement in a RFC on how this case
should be filtered.
The closest we found is RFC5927 (Section 4.3) but it is not very clear.

A possible fix would be to check that the inner IP source is the same than
the outer destination.

We believed this kind of attack was not documented yet, so we started to
write a blog post about it.
You can find it attached to this mail (sorry for the extract quality).
It contains more technical details, PoC and discussion about the identified
behavior.
We discovered later that
https://www.gont.com.ar/papers/filtering-of-icmp-error-messages.pdf
described a similar attack concept in 2004 but without the stateful
filtering in mind.
 -----

This implements above suggested fix:
In icmp(v6) error handler, take outer destination address, then pass
that into the common function that does the "related" association.

After obtaining the nf_conn of the matching inner-headers connection,
check that the destination address of the opposite direction tuple
is the same as the outer address and only set RELATED if thats the case.

Reported-by: Luca Moro <luca.moro@synacktiv.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_l4proto.h |  6 ++
 net/netfilter/nf_conntrack_proto_icmp.c      | 93 +++++++++++++++-----
 net/netfilter/nf_conntrack_proto_icmpv6.c    | 52 ++---------
 3 files changed, 84 insertions(+), 67 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 778087591983..a49edfdf47e8 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -75,6 +75,12 @@ bool nf_conntrack_invert_icmp_tuple(struct nf_conntrack_tuple *tuple,
 bool nf_conntrack_invert_icmpv6_tuple(struct nf_conntrack_tuple *tuple,
 				      const struct nf_conntrack_tuple *orig);
 
+int nf_conntrack_inet_error(struct nf_conn *tmpl, struct sk_buff *skb,
+			    unsigned int dataoff,
+			    const struct nf_hook_state *state,
+			    u8 l4proto,
+			    union nf_inet_addr *outer_daddr);
+
 int nf_conntrack_icmpv4_error(struct nf_conn *tmpl,
 			      struct sk_buff *skb,
 			      unsigned int dataoff,
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index 7df477996b16..9becac953587 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -103,49 +103,94 @@ int nf_conntrack_icmp_packet(struct nf_conn *ct,
 	return NF_ACCEPT;
 }
 
-/* Returns conntrack if it dealt with ICMP, and filled in skb fields */
-static int
-icmp_error_message(struct nf_conn *tmpl, struct sk_buff *skb,
-		   const struct nf_hook_state *state)
+/* Check inner header is related to any of the existing connections */
+int nf_conntrack_inet_error(struct nf_conn *tmpl, struct sk_buff *skb,
+			    unsigned int dataoff,
+			    const struct nf_hook_state *state,
+			    u8 l4proto, union nf_inet_addr *outer_daddr)
 {
 	struct nf_conntrack_tuple innertuple, origtuple;
 	const struct nf_conntrack_tuple_hash *h;
 	const struct nf_conntrack_zone *zone;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conntrack_zone tmp;
+	union nf_inet_addr *ct_daddr;
+	enum ip_conntrack_dir dir;
+	struct nf_conn *ct;
 
 	WARN_ON(skb_nfct(skb));
 	zone = nf_ct_zone_tmpl(tmpl, skb, &tmp);
 
 	/* Are they talking about one of our connections? */
-	if (!nf_ct_get_tuplepr(skb,
-			       skb_network_offset(skb) + ip_hdrlen(skb)
-						       + sizeof(struct icmphdr),
-			       PF_INET, state->net, &origtuple)) {
-		pr_debug("icmp_error_message: failed to get tuple\n");
+	if (!nf_ct_get_tuplepr(skb, dataoff,
+			       state->pf, state->net, &origtuple))
 		return -NF_ACCEPT;
-	}
 
 	/* Ordinarily, we'd expect the inverted tupleproto, but it's
 	   been preserved inside the ICMP. */
-	if (!nf_ct_invert_tuple(&innertuple, &origtuple)) {
-		pr_debug("icmp_error_message: no match\n");
+	if (!nf_ct_invert_tuple(&innertuple, &origtuple))
 		return -NF_ACCEPT;
-	}
-
-	ctinfo = IP_CT_RELATED;
 
 	h = nf_conntrack_find_get(state->net, zone, &innertuple);
-	if (!h) {
-		pr_debug("icmp_error_message: no match\n");
+	if (!h)
+		return -NF_ACCEPT;
+
+	/* Consider: A -> T (=This machine) -> B
+	 *   Conntrack entry will look like this:
+	 *      Original:  A->B
+	 *      Reply:     B->T (SNAT case) OR A
+	 *
+	 * When this function runs, we got packet that looks like this:
+	 * iphdr|icmphdr|inner_iphdr|l4header (tcp, udp, ..).
+	 *
+	 * Above nf_conntrack_find_get() makes lookup based on inner_hdr,
+	 * so we should expect that destination of the found connection
+	 * matches outer header destination address.
+	 *
+	 * In above example, we can consider these two cases:
+	 *  1. Error coming in reply direction from B or M (middle box) to
+	 *     T (SNAT case) or A.
+	 *     Inner saddr will be B, dst will be T or A.
+	 *     The found conntrack will be reply tuple (B->T/A).
+	 *  2. Error coming in original direction from A or M to B.
+	 *     Inner saddr will be A, inner daddr will be B.
+	 *     The found conntrack will be original tuple (A->B).
+	 *
+	 * In both cases, conntrack[dir].dst == inner.dst.
+	 *
+	 * A bogus packet could look like this:
+	 *   Inner: B->T
+	 *   Outer: B->X (other machine reachable by T).
+	 *
+	 * In this case, lookup yields connection A->B and will
+	 * set packet from B->X as *RELATED*, even though no connection
+	 * from X was ever seen.
+	 */
+	ct = nf_ct_tuplehash_to_ctrack(h);
+	dir = NF_CT_DIRECTION(h);
+	ct_daddr = &ct->tuplehash[dir].tuple.dst.u3;
+	if (!nf_inet_addr_cmp(outer_daddr, ct_daddr)) {
+		if (state->pf == AF_INET) {
+			nf_l4proto_log_invalid(skb, state->net, state->pf,
+					       l4proto,
+					       "outer daddr %pI4 != inner %pI4",
+					       &outer_daddr->ip, &ct_daddr->ip);
+		} else if (state->pf == AF_INET6) {
+			nf_l4proto_log_invalid(skb, state->net, state->pf,
+					       l4proto,
+					       "outer daddr %pI6 != inner %pI6",
+					       &outer_daddr->ip6, &ct_daddr->ip6);
+		}
+		nf_ct_put(ct);
 		return -NF_ACCEPT;
 	}
 
-	if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY)
+	ctinfo = IP_CT_RELATED;
+	if (dir == IP_CT_DIR_REPLY)
 		ctinfo += IP_CT_IS_REPLY;
 
 	/* Update skb to refer to this connection */
-	nf_ct_set(skb, nf_ct_tuplehash_to_ctrack(h), ctinfo);
+	nf_ct_set(skb, ct, ctinfo);
 	return NF_ACCEPT;
 }
 
@@ -162,11 +207,12 @@ int nf_conntrack_icmpv4_error(struct nf_conn *tmpl,
 			      struct sk_buff *skb, unsigned int dataoff,
 			      const struct nf_hook_state *state)
 {
+	union nf_inet_addr outer_daddr;
 	const struct icmphdr *icmph;
 	struct icmphdr _ih;
 
 	/* Not enough header? */
-	icmph = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_ih), &_ih);
+	icmph = skb_header_pointer(skb, dataoff, sizeof(_ih), &_ih);
 	if (icmph == NULL) {
 		icmp_error_log(skb, state, "short packet");
 		return -NF_ACCEPT;
@@ -199,7 +245,12 @@ int nf_conntrack_icmpv4_error(struct nf_conn *tmpl,
 	    icmph->type != ICMP_REDIRECT)
 		return NF_ACCEPT;
 
-	return icmp_error_message(tmpl, skb, state);
+	memset(&outer_daddr, 0, sizeof(outer_daddr));
+	outer_daddr.ip = ip_hdr(skb)->daddr;
+
+	dataoff += sizeof(*icmph);
+	return nf_conntrack_inet_error(tmpl, skb, dataoff, state,
+				       IPPROTO_ICMP, &outer_daddr);
 }
 
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index bec4a3211658..c63ee3612855 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -123,51 +123,6 @@ int nf_conntrack_icmpv6_packet(struct nf_conn *ct,
 	return NF_ACCEPT;
 }
 
-static int
-icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
-		     struct sk_buff *skb,
-		     unsigned int icmp6off)
-{
-	struct nf_conntrack_tuple intuple, origtuple;
-	const struct nf_conntrack_tuple_hash *h;
-	enum ip_conntrack_info ctinfo;
-	struct nf_conntrack_zone tmp;
-
-	WARN_ON(skb_nfct(skb));
-
-	/* Are they talking about one of our connections? */
-	if (!nf_ct_get_tuplepr(skb,
-			       skb_network_offset(skb)
-				+ sizeof(struct ipv6hdr)
-				+ sizeof(struct icmp6hdr),
-			       PF_INET6, net, &origtuple)) {
-		pr_debug("icmpv6_error: Can't get tuple\n");
-		return -NF_ACCEPT;
-	}
-
-	/* Ordinarily, we'd expect the inverted tupleproto, but it's
-	   been preserved inside the ICMP. */
-	if (!nf_ct_invert_tuple(&intuple, &origtuple)) {
-		pr_debug("icmpv6_error: Can't invert tuple\n");
-		return -NF_ACCEPT;
-	}
-
-	ctinfo = IP_CT_RELATED;
-
-	h = nf_conntrack_find_get(net, nf_ct_zone_tmpl(tmpl, skb, &tmp),
-				  &intuple);
-	if (!h) {
-		pr_debug("icmpv6_error: no match\n");
-		return -NF_ACCEPT;
-	} else {
-		if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY)
-			ctinfo += IP_CT_IS_REPLY;
-	}
-
-	/* Update skb to refer to this connection */
-	nf_ct_set(skb, nf_ct_tuplehash_to_ctrack(h), ctinfo);
-	return NF_ACCEPT;
-}
 
 static void icmpv6_error_log(const struct sk_buff *skb,
 			     const struct nf_hook_state *state,
@@ -182,6 +137,7 @@ int nf_conntrack_icmpv6_error(struct nf_conn *tmpl,
 			      unsigned int dataoff,
 			      const struct nf_hook_state *state)
 {
+	union nf_inet_addr outer_daddr;
 	const struct icmp6hdr *icmp6h;
 	struct icmp6hdr _ih;
 	int type;
@@ -210,7 +166,11 @@ int nf_conntrack_icmpv6_error(struct nf_conn *tmpl,
 	if (icmp6h->icmp6_type >= 128)
 		return NF_ACCEPT;
 
-	return icmpv6_error_message(state->net, tmpl, skb, dataoff);
+	memcpy(&outer_daddr.ip6, &ipv6_hdr(skb)->daddr,
+	       sizeof(outer_daddr.ip6));
+	dataoff += sizeof(*icmp6h);
+	return nf_conntrack_inet_error(tmpl, skb, dataoff, state,
+				       IPPROTO_ICMPV6, &outer_daddr);
 }
 
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-- 
2.19.2

