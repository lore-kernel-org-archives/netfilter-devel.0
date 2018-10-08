From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 14/31] netfilter: conntrack: pass nf_hook_state to packet and error handlers
Date: Tue,  9 Oct 2018 01:01:08 +0200
Message-ID: <20181008230125.2330-15-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

nf_hook_state contains all the hook meta-information: netns, protocol family,
hook location, and so on.

Instead of only passing selected information, pass a pointer to entire
structure.

This will allow to merge the error and the packet handlers and remove
the ->new() function in followup patches.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_core.h    |  3 +-
 include/net/netfilter/nf_conntrack_l4proto.h |  7 ++--
 net/netfilter/nf_conntrack_core.c            | 49 ++++++++++++-------------
 net/netfilter/nf_conntrack_proto.c           |  8 ++---
 net/netfilter/nf_conntrack_proto_dccp.c      | 17 +++++----
 net/netfilter/nf_conntrack_proto_generic.c   |  3 +-
 net/netfilter/nf_conntrack_proto_gre.c       |  3 +-
 net/netfilter/nf_conntrack_proto_icmp.c      | 36 ++++++++++---------
 net/netfilter/nf_conntrack_proto_icmpv6.c    | 29 ++++++++-------
 net/netfilter/nf_conntrack_proto_sctp.c      | 12 ++++---
 net/netfilter/nf_conntrack_proto_tcp.c       | 28 ++++++++-------
 net/netfilter/nf_conntrack_proto_udp.c       | 54 +++++++++++++++-------------
 net/openvswitch/conntrack.c                  |  8 +++--
 13 files changed, 142 insertions(+), 115 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 2a3e0974a6af..afc9b3620473 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -20,8 +20,7 @@
 /* This header is used to share core functionality between the
    standalone connection tracking module, and the compatibility layer's use
    of connection tracking. */
-unsigned int nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
-			     struct sk_buff *skb);
+unsigned int nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state);
 
 int nf_conntrack_init_net(struct net *net);
 void nf_conntrack_cleanup_net(struct net *net);
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 8465263b297d..a857a0adfb31 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -45,7 +45,8 @@ struct nf_conntrack_l4proto {
 	int (*packet)(struct nf_conn *ct,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
-		      enum ip_conntrack_info ctinfo);
+		      enum ip_conntrack_info ctinfo,
+		      const struct nf_hook_state *state);
 
 	/* Called when a new connection for this protocol found;
 	 * returns TRUE if it's OK.  If so, packet() called next. */
@@ -55,9 +56,9 @@ struct nf_conntrack_l4proto {
 	/* Called when a conntrack entry is destroyed */
 	void (*destroy)(struct nf_conn *ct);
 
-	int (*error)(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
+	int (*error)(struct nf_conn *tmpl, struct sk_buff *skb,
 		     unsigned int dataoff,
-		     u_int8_t pf, unsigned int hooknum);
+		     const struct nf_hook_state *state);
 
 	/* called by gc worker if table is full */
 	bool (*can_early_drop)(const struct nf_conn *ct);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index a676d5f76bdc..8e275f4cdcdd 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1436,12 +1436,12 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 
 /* On success, returns 0, sets skb->_nfct | ctinfo */
 static int
-resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
+resolve_normal_ct(struct nf_conn *tmpl,
 		  struct sk_buff *skb,
 		  unsigned int dataoff,
-		  u_int16_t l3num,
 		  u_int8_t protonum,
-		  const struct nf_conntrack_l4proto *l4proto)
+		  const struct nf_conntrack_l4proto *l4proto,
+		  const struct nf_hook_state *state)
 {
 	const struct nf_conntrack_zone *zone;
 	struct nf_conntrack_tuple tuple;
@@ -1452,17 +1452,18 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 	u32 hash;
 
 	if (!nf_ct_get_tuple(skb, skb_network_offset(skb),
-			     dataoff, l3num, protonum, net, &tuple, l4proto)) {
+			     dataoff, state->pf, protonum, state->net,
+			     &tuple, l4proto)) {
 		pr_debug("Can't get tuple\n");
 		return 0;
 	}
 
 	/* look for tuple match */
 	zone = nf_ct_zone_tmpl(tmpl, skb, &tmp);
-	hash = hash_conntrack_raw(&tuple, net);
-	h = __nf_conntrack_find_get(net, zone, &tuple, hash);
+	hash = hash_conntrack_raw(&tuple, state->net);
+	h = __nf_conntrack_find_get(state->net, zone, &tuple, hash);
 	if (!h) {
-		h = init_conntrack(net, tmpl, &tuple, l4proto,
+		h = init_conntrack(state->net, tmpl, &tuple, l4proto,
 				   skb, dataoff, hash);
 		if (!h)
 			return 0;
@@ -1492,12 +1493,11 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 }
 
 unsigned int
-nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
-		struct sk_buff *skb)
+nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 {
 	const struct nf_conntrack_l4proto *l4proto;
-	struct nf_conn *ct, *tmpl;
 	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct, *tmpl;
 	u_int8_t protonum;
 	int dataoff, ret;
 
@@ -1506,32 +1506,32 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 		/* Previously seen (loopback or untracked)?  Ignore. */
 		if ((tmpl && !nf_ct_is_template(tmpl)) ||
 		     ctinfo == IP_CT_UNTRACKED) {
-			NF_CT_STAT_INC_ATOMIC(net, ignore);
+			NF_CT_STAT_INC_ATOMIC(state->net, ignore);
 			return NF_ACCEPT;
 		}
 		skb->_nfct = 0;
 	}
 
 	/* rcu_read_lock()ed by nf_hook_thresh */
-	dataoff = get_l4proto(skb, skb_network_offset(skb), pf, &protonum);
+	dataoff = get_l4proto(skb, skb_network_offset(skb), state->pf, &protonum);
 	if (dataoff <= 0) {
 		pr_debug("not prepared to track yet or error occurred\n");
-		NF_CT_STAT_INC_ATOMIC(net, error);
-		NF_CT_STAT_INC_ATOMIC(net, invalid);
+		NF_CT_STAT_INC_ATOMIC(state->net, error);
+		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
 		ret = NF_ACCEPT;
 		goto out;
 	}
 
-	l4proto = __nf_ct_l4proto_find(pf, protonum);
+	l4proto = __nf_ct_l4proto_find(state->pf, protonum);
 
 	/* It may be an special packet, error, unclean...
 	 * inverse of the return code tells to the netfilter
 	 * core what to do with the packet. */
 	if (l4proto->error != NULL) {
-		ret = l4proto->error(net, tmpl, skb, dataoff, pf, hooknum);
+		ret = l4proto->error(tmpl, skb, dataoff, state);
 		if (ret <= 0) {
-			NF_CT_STAT_INC_ATOMIC(net, error);
-			NF_CT_STAT_INC_ATOMIC(net, invalid);
+			NF_CT_STAT_INC_ATOMIC(state->net, error);
+			NF_CT_STAT_INC_ATOMIC(state->net, invalid);
 			ret = -ret;
 			goto out;
 		}
@@ -1540,10 +1540,11 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 			goto out;
 	}
 repeat:
-	ret = resolve_normal_ct(net, tmpl, skb, dataoff, pf, protonum, l4proto);
+	ret = resolve_normal_ct(tmpl, skb, dataoff,
+				protonum, l4proto, state);
 	if (ret < 0) {
 		/* Too stressed to deal. */
-		NF_CT_STAT_INC_ATOMIC(net, drop);
+		NF_CT_STAT_INC_ATOMIC(state->net, drop);
 		ret = NF_DROP;
 		goto out;
 	}
@@ -1551,21 +1552,21 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 	ct = nf_ct_get(skb, &ctinfo);
 	if (!ct) {
 		/* Not valid part of a connection */
-		NF_CT_STAT_INC_ATOMIC(net, invalid);
+		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
 		ret = NF_ACCEPT;
 		goto out;
 	}
 
-	ret = l4proto->packet(ct, skb, dataoff, ctinfo);
+	ret = l4proto->packet(ct, skb, dataoff, ctinfo, state);
 	if (ret <= 0) {
 		/* Invalid: inverse of the return code tells
 		 * the netfilter core what to do */
 		pr_debug("nf_conntrack_in: Can't track with proto module\n");
 		nf_conntrack_put(&ct->ct_general);
 		skb->_nfct = 0;
-		NF_CT_STAT_INC_ATOMIC(net, invalid);
+		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
 		if (ret == -NF_DROP)
-			NF_CT_STAT_INC_ATOMIC(net, drop);
+			NF_CT_STAT_INC_ATOMIC(state->net, drop);
 		/* Special case: TCP tracker reports an attempt to reopen a
 		 * closed/aborted connection. We have to go back and create a
 		 * fresh conntrack.
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 51c5d7eec0a3..4896ba44becb 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -455,7 +455,7 @@ static unsigned int ipv4_conntrack_in(void *priv,
 				      struct sk_buff *skb,
 				      const struct nf_hook_state *state)
 {
-	return nf_conntrack_in(state->net, PF_INET, state->hook, skb);
+	return nf_conntrack_in(skb, state);
 }
 
 static unsigned int ipv4_conntrack_local(void *priv,
@@ -477,7 +477,7 @@ static unsigned int ipv4_conntrack_local(void *priv,
 		return NF_ACCEPT;
 	}
 
-	return nf_conntrack_in(state->net, PF_INET, state->hook, skb);
+	return nf_conntrack_in(skb, state);
 }
 
 /* Connection tracking may drop packets, but never alters them, so
@@ -690,14 +690,14 @@ static unsigned int ipv6_conntrack_in(void *priv,
 				      struct sk_buff *skb,
 				      const struct nf_hook_state *state)
 {
-	return nf_conntrack_in(state->net, PF_INET6, state->hook, skb);
+	return nf_conntrack_in(skb, state);
 }
 
 static unsigned int ipv6_conntrack_local(void *priv,
 					 struct sk_buff *skb,
 					 const struct nf_hook_state *state)
 {
-	return nf_conntrack_in(state->net, PF_INET6, state->hook, skb);
+	return nf_conntrack_in(skb, state);
 }
 
 static unsigned int ipv6_helper(void *priv,
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index f3f91ed2c21a..8595c79742a2 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -439,7 +439,8 @@ static u64 dccp_ack_seq(const struct dccp_hdr *dh)
 }
 
 static int dccp_packet(struct nf_conn *ct, const struct sk_buff *skb,
-		       unsigned int dataoff, enum ip_conntrack_info ctinfo)
+		       unsigned int dataoff, enum ip_conntrack_info ctinfo,
+		       const struct nf_hook_state *state)
 {
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	struct dccp_hdr _dh, *dh;
@@ -527,9 +528,9 @@ static int dccp_packet(struct nf_conn *ct, const struct sk_buff *skb,
 	return NF_ACCEPT;
 }
 
-static int dccp_error(struct net *net, struct nf_conn *tmpl,
+static int dccp_error(struct nf_conn *tmpl,
 		      struct sk_buff *skb, unsigned int dataoff,
-		      u_int8_t pf, unsigned int hooknum)
+		      const struct nf_hook_state *state)
 {
 	struct dccp_hdr _dh, *dh;
 	unsigned int dccp_len = skb->len - dataoff;
@@ -557,9 +558,10 @@ static int dccp_error(struct net *net, struct nf_conn *tmpl,
 		}
 	}
 
-	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
-	    nf_checksum_partial(skb, hooknum, dataoff, cscov, IPPROTO_DCCP,
-				pf)) {
+	if (state->hook == NF_INET_PRE_ROUTING &&
+	    state->net->ct.sysctl_checksum &&
+	    nf_checksum_partial(skb, state->hook, dataoff, cscov,
+				IPPROTO_DCCP, state->pf)) {
 		msg = "nf_ct_dccp: bad checksum ";
 		goto out_invalid;
 	}
@@ -572,7 +574,8 @@ static int dccp_error(struct net *net, struct nf_conn *tmpl,
 	return NF_ACCEPT;
 
 out_invalid:
-	nf_l4proto_log_invalid(skb, net, pf, IPPROTO_DCCP, "%s", msg);
+	nf_l4proto_log_invalid(skb, state->net, state->pf,
+			       IPPROTO_DCCP, "%s", msg);
 	return -NF_ACCEPT;
 }
 
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 1df3244ecd07..9940161cfef1 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -46,7 +46,8 @@ static bool generic_pkt_to_tuple(const struct sk_buff *skb,
 static int generic_packet(struct nf_conn *ct,
 			  const struct sk_buff *skb,
 			  unsigned int dataoff,
-			  enum ip_conntrack_info ctinfo)
+			  enum ip_conntrack_info ctinfo,
+			  const struct nf_hook_state *state)
 {
 	const unsigned int *timeout = nf_ct_timeout_lookup(ct);
 
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 650eb4fba2c5..85313a191456 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -235,7 +235,8 @@ static unsigned int *gre_get_timeouts(struct net *net)
 static int gre_packet(struct nf_conn *ct,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
-		      enum ip_conntrack_info ctinfo)
+		      enum ip_conntrack_info ctinfo,
+		      const struct nf_hook_state *state)
 {
 	/* If we've seen traffic both ways, this is a GRE connection.
 	 * Extend timeout. */
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index 43c7e1a217b9..c3a304b53245 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -81,7 +81,8 @@ static unsigned int *icmp_get_timeouts(struct net *net)
 static int icmp_packet(struct nf_conn *ct,
 		       const struct sk_buff *skb,
 		       unsigned int dataoff,
-		       enum ip_conntrack_info ctinfo)
+		       enum ip_conntrack_info ctinfo,
+		       const struct nf_hook_state *state)
 {
 	/* Do not immediately delete the connection after the first
 	   successful reply to avoid excessive conntrackd traffic
@@ -120,8 +121,8 @@ static bool icmp_new(struct nf_conn *ct, const struct sk_buff *skb,
 
 /* Returns conntrack if it dealt with ICMP, and filled in skb fields */
 static int
-icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
-		 unsigned int hooknum)
+icmp_error_message(struct nf_conn *tmpl, struct sk_buff *skb,
+		   const struct nf_hook_state *state)
 {
 	struct nf_conntrack_tuple innertuple, origtuple;
 	const struct nf_conntrack_l4proto *innerproto;
@@ -137,7 +138,7 @@ icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 	if (!nf_ct_get_tuplepr(skb,
 			       skb_network_offset(skb) + ip_hdrlen(skb)
 						       + sizeof(struct icmphdr),
-			       PF_INET, net, &origtuple)) {
+			       PF_INET, state->net, &origtuple)) {
 		pr_debug("icmp_error_message: failed to get tuple\n");
 		return -NF_ACCEPT;
 	}
@@ -154,7 +155,7 @@ icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 
 	ctinfo = IP_CT_RELATED;
 
-	h = nf_conntrack_find_get(net, zone, &innertuple);
+	h = nf_conntrack_find_get(state->net, zone, &innertuple);
 	if (!h) {
 		pr_debug("icmp_error_message: no match\n");
 		return -NF_ACCEPT;
@@ -168,17 +169,19 @@ icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 	return NF_ACCEPT;
 }
 
-static void icmp_error_log(const struct sk_buff *skb, struct net *net,
-			   u8 pf, const char *msg)
+static void icmp_error_log(const struct sk_buff *skb,
+			   const struct nf_hook_state *state,
+			   const char *msg)
 {
-	nf_l4proto_log_invalid(skb, net, pf, IPPROTO_ICMP, "%s", msg);
+	nf_l4proto_log_invalid(skb, state->net, state->pf,
+			       IPPROTO_ICMP, "%s", msg);
 }
 
 /* Small and modified version of icmp_rcv */
 static int
-icmp_error(struct net *net, struct nf_conn *tmpl,
+icmp_error(struct nf_conn *tmpl,
 	   struct sk_buff *skb, unsigned int dataoff,
-	   u8 pf, unsigned int hooknum)
+	   const struct nf_hook_state *state)
 {
 	const struct icmphdr *icmph;
 	struct icmphdr _ih;
@@ -186,14 +189,15 @@ icmp_error(struct net *net, struct nf_conn *tmpl,
 	/* Not enough header? */
 	icmph = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_ih), &_ih);
 	if (icmph == NULL) {
-		icmp_error_log(skb, net, pf, "short packet");
+		icmp_error_log(skb, state, "short packet");
 		return -NF_ACCEPT;
 	}
 
 	/* See ip_conntrack_proto_tcp.c */
-	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
-	    nf_ip_checksum(skb, hooknum, dataoff, 0)) {
-		icmp_error_log(skb, net, pf, "bad hw icmp checksum");
+	if (state->net->ct.sysctl_checksum &&
+	    state->hook == NF_INET_PRE_ROUTING &&
+	    nf_ip_checksum(skb, state->hook, dataoff, 0)) {
+		icmp_error_log(skb, state, "bad hw icmp checksum");
 		return -NF_ACCEPT;
 	}
 
@@ -204,7 +208,7 @@ icmp_error(struct net *net, struct nf_conn *tmpl,
 	 *		  discarded.
 	 */
 	if (icmph->type > NR_ICMP_TYPES) {
-		icmp_error_log(skb, net, pf, "invalid icmp type");
+		icmp_error_log(skb, state, "invalid icmp type");
 		return -NF_ACCEPT;
 	}
 
@@ -216,7 +220,7 @@ icmp_error(struct net *net, struct nf_conn *tmpl,
 	    icmph->type != ICMP_REDIRECT)
 		return NF_ACCEPT;
 
-	return icmp_error_message(net, tmpl, skb, hooknum);
+	return icmp_error_message(tmpl, skb, state);
 }
 
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index 97e40f77d678..bb5c98b0af89 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -94,7 +94,8 @@ static unsigned int *icmpv6_get_timeouts(struct net *net)
 static int icmpv6_packet(struct nf_conn *ct,
 		       const struct sk_buff *skb,
 		       unsigned int dataoff,
-		       enum ip_conntrack_info ctinfo)
+		       enum ip_conntrack_info ctinfo,
+		       const struct nf_hook_state *state)
 {
 	unsigned int *timeout = nf_ct_timeout_lookup(ct);
 
@@ -179,16 +180,19 @@ icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 	return NF_ACCEPT;
 }
 
-static void icmpv6_error_log(const struct sk_buff *skb, struct net *net,
-			     u8 pf, const char *msg)
+static void icmpv6_error_log(const struct sk_buff *skb,
+			     const struct nf_hook_state *state,
+			     const char *msg)
 {
-	nf_l4proto_log_invalid(skb, net, pf, IPPROTO_ICMPV6, "%s", msg);
+	nf_l4proto_log_invalid(skb, state->net, state->pf,
+			       IPPROTO_ICMPV6, "%s", msg);
 }
 
 static int
-icmpv6_error(struct net *net, struct nf_conn *tmpl,
-	     struct sk_buff *skb, unsigned int dataoff,
-	     u8 pf, unsigned int hooknum)
+icmpv6_error(struct nf_conn *tmpl,
+	     struct sk_buff *skb,
+	     unsigned int dataoff,
+	     const struct nf_hook_state *state)
 {
 	const struct icmp6hdr *icmp6h;
 	struct icmp6hdr _ih;
@@ -196,13 +200,14 @@ icmpv6_error(struct net *net, struct nf_conn *tmpl,
 
 	icmp6h = skb_header_pointer(skb, dataoff, sizeof(_ih), &_ih);
 	if (icmp6h == NULL) {
-		icmpv6_error_log(skb, net, pf, "short packet");
+		icmpv6_error_log(skb, state, "short packet");
 		return -NF_ACCEPT;
 	}
 
-	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
-	    nf_ip6_checksum(skb, hooknum, dataoff, IPPROTO_ICMPV6)) {
-		icmpv6_error_log(skb, net, pf, "ICMPv6 checksum failed");
+	if (state->hook == NF_INET_PRE_ROUTING &&
+	    state->net->ct.sysctl_checksum &&
+	    nf_ip6_checksum(skb, state->hook, dataoff, IPPROTO_ICMPV6)) {
+		icmpv6_error_log(skb, state, "ICMPv6 checksum failed");
 		return -NF_ACCEPT;
 	}
 
@@ -217,7 +222,7 @@ icmpv6_error(struct net *net, struct nf_conn *tmpl,
 	if (icmp6h->icmp6_type >= 128)
 		return NF_ACCEPT;
 
-	return icmpv6_error_message(net, tmpl, skb, dataoff);
+	return icmpv6_error_message(state->net, tmpl, skb, dataoff);
 }
 
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index e4d738d34cd0..34b80cea4a56 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -277,7 +277,8 @@ static int sctp_new_state(enum ip_conntrack_dir dir,
 static int sctp_packet(struct nf_conn *ct,
 		       const struct sk_buff *skb,
 		       unsigned int dataoff,
-		       enum ip_conntrack_info ctinfo)
+		       enum ip_conntrack_info ctinfo,
+		       const struct nf_hook_state *state)
 {
 	enum sctp_conntrack new_state, old_state;
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
@@ -471,9 +472,9 @@ static bool sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	return true;
 }
 
-static int sctp_error(struct net *net, struct nf_conn *tpl, struct sk_buff *skb,
+static int sctp_error(struct nf_conn *tpl, struct sk_buff *skb,
 		      unsigned int dataoff,
-		      u8 pf, unsigned int hooknum)
+		      const struct nf_hook_state *state)
 {
 	const struct sctphdr *sh;
 	const char *logmsg;
@@ -482,7 +483,8 @@ static int sctp_error(struct net *net, struct nf_conn *tpl, struct sk_buff *skb,
 		logmsg = "nf_ct_sctp: short packet ";
 		goto out_invalid;
 	}
-	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
+	if (state->hook == NF_INET_PRE_ROUTING &&
+	    state->net->ct.sysctl_checksum &&
 	    skb->ip_summed == CHECKSUM_NONE) {
 		if (!skb_make_writable(skb, dataoff + sizeof(struct sctphdr))) {
 			logmsg = "nf_ct_sctp: failed to read header ";
@@ -497,7 +499,7 @@ static int sctp_error(struct net *net, struct nf_conn *tpl, struct sk_buff *skb,
 	}
 	return NF_ACCEPT;
 out_invalid:
-	nf_l4proto_log_invalid(skb, net, pf, IPPROTO_SCTP, "%s", logmsg);
+	nf_l4proto_log_invalid(skb, state->net, state->pf, IPPROTO_SCTP, "%s", logmsg);
 	return -NF_ACCEPT;
 }
 
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index b4bdf9eda7b7..5128f0a79ed4 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -717,18 +717,18 @@ static const u8 tcp_valid_flags[(TCPHDR_FIN|TCPHDR_SYN|TCPHDR_RST|TCPHDR_ACK|
 	[TCPHDR_ACK|TCPHDR_URG]			= 1,
 };
 
-static void tcp_error_log(const struct sk_buff *skb, struct net *net,
-			  u8 pf, const char *msg)
+static void tcp_error_log(const struct sk_buff *skb,
+			  const struct nf_hook_state *state,
+			  const char *msg)
 {
-	nf_l4proto_log_invalid(skb, net, pf, IPPROTO_TCP, "%s", msg);
+	nf_l4proto_log_invalid(skb, state->net, state->pf, IPPROTO_TCP, "%s", msg);
 }
 
 /* Protect conntrack agaist broken packets. Code taken from ipt_unclean.c.  */
-static int tcp_error(struct net *net, struct nf_conn *tmpl,
+static int tcp_error(struct nf_conn *tmpl,
 		     struct sk_buff *skb,
 		     unsigned int dataoff,
-		     u_int8_t pf,
-		     unsigned int hooknum)
+		     const struct nf_hook_state *state)
 {
 	const struct tcphdr *th;
 	struct tcphdr _tcph;
@@ -738,13 +738,13 @@ static int tcp_error(struct net *net, struct nf_conn *tmpl,
 	/* Smaller that minimal TCP header? */
 	th = skb_header_pointer(skb, dataoff, sizeof(_tcph), &_tcph);
 	if (th == NULL) {
-		tcp_error_log(skb, net, pf, "short packet");
+		tcp_error_log(skb, state, "short packet");
 		return -NF_ACCEPT;
 	}
 
 	/* Not whole TCP header or malformed packet */
 	if (th->doff*4 < sizeof(struct tcphdr) || tcplen < th->doff*4) {
-		tcp_error_log(skb, net, pf, "truncated packet");
+		tcp_error_log(skb, state, "truncated packet");
 		return -NF_ACCEPT;
 	}
 
@@ -753,16 +753,17 @@ static int tcp_error(struct net *net, struct nf_conn *tmpl,
 	 * because the checksum is assumed to be correct.
 	 */
 	/* FIXME: Source route IP option packets --RR */
-	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
-	    nf_checksum(skb, hooknum, dataoff, IPPROTO_TCP, pf)) {
-		tcp_error_log(skb, net, pf, "bad checksum");
+	if (state->net->ct.sysctl_checksum &&
+	    state->hook == NF_INET_PRE_ROUTING &&
+	    nf_checksum(skb, state->hook, dataoff, IPPROTO_TCP, state->pf)) {
+		tcp_error_log(skb, state, "bad checksum");
 		return -NF_ACCEPT;
 	}
 
 	/* Check TCP flags. */
 	tcpflags = (tcp_flag_byte(th) & ~(TCPHDR_ECE|TCPHDR_CWR|TCPHDR_PSH));
 	if (!tcp_valid_flags[tcpflags]) {
-		tcp_error_log(skb, net, pf, "invalid tcp flag combination");
+		tcp_error_log(skb, state, "invalid tcp flag combination");
 		return -NF_ACCEPT;
 	}
 
@@ -773,7 +774,8 @@ static int tcp_error(struct net *net, struct nf_conn *tmpl,
 static int tcp_packet(struct nf_conn *ct,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
-		      enum ip_conntrack_info ctinfo)
+		      enum ip_conntrack_info ctinfo,
+		      const struct nf_hook_state *state)
 {
 	struct net *net = nf_ct_net(ct);
 	struct nf_tcp_net *tn = tcp_pernet(net);
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 3065fb8ef91b..bf59d32bba98 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -46,7 +46,8 @@ static unsigned int *udp_get_timeouts(struct net *net)
 static int udp_packet(struct nf_conn *ct,
 		      const struct sk_buff *skb,
 		      unsigned int dataoff,
-		      enum ip_conntrack_info ctinfo)
+		      enum ip_conntrack_info ctinfo,
+		      const struct nf_hook_state *state)
 {
 	unsigned int *timeouts;
 
@@ -77,16 +78,17 @@ static bool udp_new(struct nf_conn *ct, const struct sk_buff *skb,
 }
 
 #ifdef CONFIG_NF_CT_PROTO_UDPLITE
-static void udplite_error_log(const struct sk_buff *skb, struct net *net,
-			      u8 pf, const char *msg)
+static void udplite_error_log(const struct sk_buff *skb,
+			      const struct nf_hook_state *state,
+			      const char *msg)
 {
-	nf_l4proto_log_invalid(skb, net, pf, IPPROTO_UDPLITE, "%s", msg);
+	nf_l4proto_log_invalid(skb, state->net, state->pf,
+			       IPPROTO_UDPLITE, "%s", msg);
 }
 
-static int udplite_error(struct net *net, struct nf_conn *tmpl,
-			 struct sk_buff *skb,
+static int udplite_error(struct nf_conn *tmpl, struct sk_buff *skb,
 			 unsigned int dataoff,
-			 u8 pf, unsigned int hooknum)
+			 const struct nf_hook_state *state)
 {
 	unsigned int udplen = skb->len - dataoff;
 	const struct udphdr *hdr;
@@ -96,7 +98,7 @@ static int udplite_error(struct net *net, struct nf_conn *tmpl,
 	/* Header is too small? */
 	hdr = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
 	if (!hdr) {
-		udplite_error_log(skb, net, pf, "short packet");
+		udplite_error_log(skb, state, "short packet");
 		return -NF_ACCEPT;
 	}
 
@@ -104,21 +106,22 @@ static int udplite_error(struct net *net, struct nf_conn *tmpl,
 	if (cscov == 0) {
 		cscov = udplen;
 	} else if (cscov < sizeof(*hdr) || cscov > udplen) {
-		udplite_error_log(skb, net, pf, "invalid checksum coverage");
+		udplite_error_log(skb, state, "invalid checksum coverage");
 		return -NF_ACCEPT;
 	}
 
 	/* UDPLITE mandates checksums */
 	if (!hdr->check) {
-		udplite_error_log(skb, net, pf, "checksum missing");
+		udplite_error_log(skb, state, "checksum missing");
 		return -NF_ACCEPT;
 	}
 
 	/* Checksum invalid? Ignore. */
-	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
-	    nf_checksum_partial(skb, hooknum, dataoff, cscov, IPPROTO_UDP,
-				pf)) {
-		udplite_error_log(skb, net, pf, "bad checksum");
+	if (state->hook == NF_INET_PRE_ROUTING &&
+	    state->net->ct.sysctl_checksum &&
+	    nf_checksum_partial(skb, state->hook, dataoff, cscov, IPPROTO_UDP,
+				state->pf)) {
+		udplite_error_log(skb, state, "bad checksum");
 		return -NF_ACCEPT;
 	}
 
@@ -126,16 +129,17 @@ static int udplite_error(struct net *net, struct nf_conn *tmpl,
 }
 #endif
 
-static void udp_error_log(const struct sk_buff *skb, struct net *net,
-			  u8 pf, const char *msg)
+static void udp_error_log(const struct sk_buff *skb,
+			  const struct nf_hook_state *state,
+			  const char *msg)
 {
-	nf_l4proto_log_invalid(skb, net, pf, IPPROTO_UDP, "%s", msg);
+	nf_l4proto_log_invalid(skb, state->net, state->pf,
+			       IPPROTO_UDP, "%s", msg);
 }
 
-static int udp_error(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
+static int udp_error(struct nf_conn *tmpl, struct sk_buff *skb,
 		     unsigned int dataoff,
-		     u_int8_t pf,
-		     unsigned int hooknum)
+		     const struct nf_hook_state *state)
 {
 	unsigned int udplen = skb->len - dataoff;
 	const struct udphdr *hdr;
@@ -144,13 +148,13 @@ static int udp_error(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 	/* Header is too small? */
 	hdr = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
 	if (hdr == NULL) {
-		udp_error_log(skb, net, pf, "short packet");
+		udp_error_log(skb, state, "short packet");
 		return -NF_ACCEPT;
 	}
 
 	/* Truncated/malformed packets */
 	if (ntohs(hdr->len) > udplen || ntohs(hdr->len) < sizeof(*hdr)) {
-		udp_error_log(skb, net, pf, "truncated/malformed packet");
+		udp_error_log(skb, state, "truncated/malformed packet");
 		return -NF_ACCEPT;
 	}
 
@@ -162,9 +166,9 @@ static int udp_error(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 	 * We skip checking packets on the outgoing path
 	 * because the checksum is assumed to be correct.
 	 * FIXME: Source route IP option packets --RR */
-	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
-	    nf_checksum(skb, hooknum, dataoff, IPPROTO_UDP, pf)) {
-		udp_error_log(skb, net, pf, "bad checksum");
+	if (state->net->ct.sysctl_checksum && state->hook == NF_INET_PRE_ROUTING &&
+	    nf_checksum(skb, state->hook, dataoff, IPPROTO_UDP, state->pf)) {
+		udp_error_log(skb, state, "bad checksum");
 		return -NF_ACCEPT;
 	}
 
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 86a75105af1a..9d26ff6caabd 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -933,6 +933,11 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 	struct nf_conn *ct;
 
 	if (!cached) {
+		struct nf_hook_state state = {
+			.hook = NF_INET_PRE_ROUTING,
+			.pf = info->family,
+			.net = net,
+		};
 		struct nf_conn *tmpl = info->ct;
 		int err;
 
@@ -944,8 +949,7 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 			nf_ct_set(skb, tmpl, IP_CT_NEW);
 		}
 
-		err = nf_conntrack_in(net, info->family,
-				      NF_INET_PRE_ROUTING, skb);
+		err = nf_conntrack_in(skb, &state);
 		if (err != NF_ACCEPT)
 			return -ENOENT;
 
-- 
2.11.0
