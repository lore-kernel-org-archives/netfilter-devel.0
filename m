From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 15/31] netfilter: conntrack: remove the l4proto->new() function
Date: Tue,  9 Oct 2018 01:01:09 +0200
Message-ID: <20181008230125.2330-16-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

->new() gets invoked after ->error() and before ->packet() if
a conntrack lookup has found no result for the tuple.

We can fold it into ->packet() -- the packet() implementations
can check if the conntrack is confirmed (new) or not
(already in hash).

If its unconfirmed, the conntrack isn't in the hash yet so current
skb created a new conntrack entry.

Only relevant side effect -- if packet() doesn't return NF_ACCEPT
but -NF_ACCEPT (or drop), while the conntrack was just created,
then the newly allocated conntrack is freed right away, rather than not
created in the first place.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h |   5 -
 net/netfilter/nf_conntrack_core.c            |   6 --
 net/netfilter/nf_conntrack_proto_dccp.c      |  17 ++-
 net/netfilter/nf_conntrack_proto_generic.c   |  20 ++--
 net/netfilter/nf_conntrack_proto_gre.c       |  33 +++---
 net/netfilter/nf_conntrack_proto_icmp.c      |  28 ++---
 net/netfilter/nf_conntrack_proto_icmpv6.c    |  37 +++----
 net/netfilter/nf_conntrack_proto_sctp.c      | 144 ++++++++++++-------------
 net/netfilter/nf_conntrack_proto_tcp.c       | 156 +++++++++++++--------------
 net/netfilter/nf_conntrack_proto_udp.c       |  11 --
 10 files changed, 194 insertions(+), 263 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index a857a0adfb31..016958e67fcc 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -48,11 +48,6 @@ struct nf_conntrack_l4proto {
 		      enum ip_conntrack_info ctinfo,
 		      const struct nf_hook_state *state);
 
-	/* Called when a new connection for this protocol found;
-	 * returns TRUE if it's OK.  If so, packet() called next. */
-	bool (*new)(struct nf_conn *ct, const struct sk_buff *skb,
-		    unsigned int dataoff);
-
 	/* Called when a conntrack entry is destroyed */
 	void (*destroy)(struct nf_conn *ct);
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8e275f4cdcdd..dccc96e94d7c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1370,12 +1370,6 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 
 	timeout_ext = tmpl ? nf_ct_timeout_find(tmpl) : NULL;
 
-	if (!l4proto->new(ct, skb, dataoff)) {
-		nf_conntrack_free(ct);
-		pr_debug("can't track with proto module\n");
-		return NULL;
-	}
-
 	if (timeout_ext)
 		nf_ct_timeout_ext_add(ct, rcu_dereference(timeout_ext->timeout),
 				      GFP_ATOMIC);
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 8595c79742a2..e7b5449ea883 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -389,18 +389,15 @@ static inline struct nf_dccp_net *dccp_pernet(struct net *net)
 	return &net->ct.nf_ct_proto.dccp;
 }
 
-static bool dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
-		     unsigned int dataoff)
+static noinline bool
+dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
+	 const struct dccp_hdr *dh)
 {
 	struct net *net = nf_ct_net(ct);
 	struct nf_dccp_net *dn;
-	struct dccp_hdr _dh, *dh;
 	const char *msg;
 	u_int8_t state;
 
-	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
-	BUG_ON(dh == NULL);
-
 	state = dccp_state_table[CT_DCCP_ROLE_CLIENT][dh->dccph_type][CT_DCCP_NONE];
 	switch (state) {
 	default:
@@ -449,8 +446,12 @@ static int dccp_packet(struct nf_conn *ct, const struct sk_buff *skb,
 	unsigned int *timeouts;
 
 	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
-	BUG_ON(dh == NULL);
+	if (!dh)
+		return NF_DROP;
+
 	type = dh->dccph_type;
+	if (!nf_ct_is_confirmed(ct) && !dccp_new(ct, skb, dh))
+		return -NF_ACCEPT;
 
 	if (type == DCCP_PKT_RESET &&
 	    !test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
@@ -850,7 +851,6 @@ static struct nf_proto_net *dccp_get_net_proto(struct net *net)
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp4 = {
 	.l3proto		= AF_INET,
 	.l4proto		= IPPROTO_DCCP,
-	.new			= dccp_new,
 	.packet			= dccp_packet,
 	.error			= dccp_error,
 	.can_early_drop		= dccp_can_early_drop,
@@ -883,7 +883,6 @@ EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_dccp4);
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp6 = {
 	.l3proto		= AF_INET6,
 	.l4proto		= IPPROTO_DCCP,
-	.new			= dccp_new,
 	.packet			= dccp_packet,
 	.error			= dccp_error,
 	.can_early_drop		= dccp_can_early_drop,
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 9940161cfef1..deeb05c50f02 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -51,6 +51,12 @@ static int generic_packet(struct nf_conn *ct,
 {
 	const unsigned int *timeout = nf_ct_timeout_lookup(ct);
 
+	if (!nf_generic_should_process(nf_ct_protonum(ct))) {
+		pr_warn_once("conntrack: generic helper won't handle protocol %d. Please consider loading the specific helper module.\n",
+			     nf_ct_protonum(ct));
+		return -NF_ACCEPT;
+	}
+
 	if (!timeout)
 		timeout = &generic_pernet(nf_ct_net(ct))->timeout;
 
@@ -58,19 +64,6 @@ static int generic_packet(struct nf_conn *ct,
 	return NF_ACCEPT;
 }
 
-/* Called when a new connection for this protocol found. */
-static bool generic_new(struct nf_conn *ct, const struct sk_buff *skb,
-			unsigned int dataoff)
-{
-	bool ret;
-
-	ret = nf_generic_should_process(nf_ct_protonum(ct));
-	if (!ret)
-		pr_warn_once("conntrack: generic helper won't handle protocol %d. Please consider loading the specific helper module.\n",
-			     nf_ct_protonum(ct));
-	return ret;
-}
-
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 
 #include <linux/netfilter/nfnetlink.h>
@@ -164,7 +157,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic =
 	.l4proto		= 255,
 	.pkt_to_tuple		= generic_pkt_to_tuple,
 	.packet			= generic_packet,
-	.new			= generic_new,
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout		= {
 		.nlattr_to_obj	= generic_timeout_nlattr_to_obj,
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 85313a191456..a44bbee271cb 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -238,6 +238,18 @@ static int gre_packet(struct nf_conn *ct,
 		      enum ip_conntrack_info ctinfo,
 		      const struct nf_hook_state *state)
 {
+	if (!nf_ct_is_confirmed(ct)) {
+		unsigned int *timeouts = nf_ct_timeout_lookup(ct);
+
+		if (!timeouts)
+			timeouts = gre_get_timeouts(nf_ct_net(ct));
+
+		/* initialize to sane value.  Ideally a conntrack helper
+		 * (e.g. in case of pptp) is increasing them */
+		ct->proto.gre.stream_timeout = timeouts[GRE_CT_REPLIED];
+		ct->proto.gre.timeout = timeouts[GRE_CT_UNREPLIED];
+	}
+
 	/* If we've seen traffic both ways, this is a GRE connection.
 	 * Extend timeout. */
 	if (ct->status & IPS_SEEN_REPLY) {
@@ -253,26 +265,6 @@ static int gre_packet(struct nf_conn *ct,
 	return NF_ACCEPT;
 }
 
-/* Called when a new connection for this protocol found. */
-static bool gre_new(struct nf_conn *ct, const struct sk_buff *skb,
-		    unsigned int dataoff)
-{
-	unsigned int *timeouts = nf_ct_timeout_lookup(ct);
-
-	if (!timeouts)
-		timeouts = gre_get_timeouts(nf_ct_net(ct));
-
-	pr_debug(": ");
-	nf_ct_dump_tuple(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-
-	/* initialize to sane value.  Ideally a conntrack helper
-	 * (e.g. in case of pptp) is increasing them */
-	ct->proto.gre.stream_timeout = timeouts[GRE_CT_REPLIED];
-	ct->proto.gre.timeout = timeouts[GRE_CT_UNREPLIED];
-
-	return true;
-}
-
 /* Called when a conntrack entry has already been removed from the hashes
  * and is about to be deleted from memory */
 static void gre_destroy(struct nf_conn *ct)
@@ -359,7 +351,6 @@ static const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre4 = {
 	.print_conntrack = gre_print_conntrack,
 #endif
 	.packet		 = gre_packet,
-	.new		 = gre_new,
 	.destroy	 = gre_destroy,
 	.me 		 = THIS_MODULE,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index c3a304b53245..19ef0c41602b 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -72,11 +72,6 @@ static bool icmp_invert_tuple(struct nf_conntrack_tuple *tuple,
 	return true;
 }
 
-static unsigned int *icmp_get_timeouts(struct net *net)
-{
-	return &icmp_pernet(net)->timeout;
-}
-
 /* Returns verdict for packet, or -1 for invalid. */
 static int icmp_packet(struct nf_conn *ct,
 		       const struct sk_buff *skb,
@@ -88,19 +83,6 @@ static int icmp_packet(struct nf_conn *ct,
 	   successful reply to avoid excessive conntrackd traffic
 	   and also to handle correctly ICMP echo reply duplicates. */
 	unsigned int *timeout = nf_ct_timeout_lookup(ct);
-
-	if (!timeout)
-		timeout = icmp_get_timeouts(nf_ct_net(ct));
-
-	nf_ct_refresh_acct(ct, ctinfo, skb, *timeout);
-
-	return NF_ACCEPT;
-}
-
-/* Called when a new connection for this protocol found. */
-static bool icmp_new(struct nf_conn *ct, const struct sk_buff *skb,
-		     unsigned int dataoff)
-{
 	static const u_int8_t valid_new[] = {
 		[ICMP_ECHO] = 1,
 		[ICMP_TIMESTAMP] = 1,
@@ -114,9 +96,14 @@ static bool icmp_new(struct nf_conn *ct, const struct sk_buff *skb,
 		pr_debug("icmp: can't create new conn with type %u\n",
 			 ct->tuplehash[0].tuple.dst.u.icmp.type);
 		nf_ct_dump_tuple_ip(&ct->tuplehash[0].tuple);
-		return false;
+		return -NF_ACCEPT;
 	}
-	return true;
+
+	if (!timeout)
+		timeout = &icmp_pernet(nf_ct_net(ct))->timeout;
+
+	nf_ct_refresh_acct(ct, ctinfo, skb, *timeout);
+	return NF_ACCEPT;
 }
 
 /* Returns conntrack if it dealt with ICMP, and filled in skb fields */
@@ -368,7 +355,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp =
 	.pkt_to_tuple		= icmp_pkt_to_tuple,
 	.invert_tuple		= icmp_invert_tuple,
 	.packet			= icmp_packet,
-	.new			= icmp_new,
 	.error			= icmp_error,
 	.destroy		= NULL,
 	.me			= NULL,
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index bb5c98b0af89..bb94363818e6 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -98,6 +98,22 @@ static int icmpv6_packet(struct nf_conn *ct,
 		       const struct nf_hook_state *state)
 {
 	unsigned int *timeout = nf_ct_timeout_lookup(ct);
+	static const u8 valid_new[] = {
+		[ICMPV6_ECHO_REQUEST - 128] = 1,
+		[ICMPV6_NI_QUERY - 128] = 1
+	};
+
+	if (!nf_ct_is_confirmed(ct)) {
+		int type = ct->tuplehash[0].tuple.dst.u.icmp.type - 128;
+
+		if (type < 0 || type >= sizeof(valid_new) || !valid_new[type]) {
+			/* Can't create a new ICMPv6 `conn' with this. */
+			pr_debug("icmpv6: can't create new conn with type %u\n",
+				 type + 128);
+			nf_ct_dump_tuple_ipv6(&ct->tuplehash[0].tuple);
+			return -NF_ACCEPT;
+		}
+	}
 
 	if (!timeout)
 		timeout = icmpv6_get_timeouts(nf_ct_net(ct));
@@ -110,26 +126,6 @@ static int icmpv6_packet(struct nf_conn *ct,
 	return NF_ACCEPT;
 }
 
-/* Called when a new connection for this protocol found. */
-static bool icmpv6_new(struct nf_conn *ct, const struct sk_buff *skb,
-		       unsigned int dataoff)
-{
-	static const u_int8_t valid_new[] = {
-		[ICMPV6_ECHO_REQUEST - 128] = 1,
-		[ICMPV6_NI_QUERY - 128] = 1
-	};
-	int type = ct->tuplehash[0].tuple.dst.u.icmp.type - 128;
-
-	if (type < 0 || type >= sizeof(valid_new) || !valid_new[type]) {
-		/* Can't create a new ICMPv6 `conn' with this. */
-		pr_debug("icmpv6: can't create new conn with type %u\n",
-			 type + 128);
-		nf_ct_dump_tuple_ipv6(&ct->tuplehash[0].tuple);
-		return false;
-	}
-	return true;
-}
-
 static int
 icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 		     struct sk_buff *skb,
@@ -370,7 +366,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 =
 	.pkt_to_tuple		= icmpv6_pkt_to_tuple,
 	.invert_tuple		= icmpv6_invert_tuple,
 	.packet			= icmpv6_packet,
-	.new			= icmpv6_new,
 	.error			= icmpv6_error,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= icmpv6_tuple_to_nlattr,
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 34b80cea4a56..78c115152a78 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -273,6 +273,63 @@ static int sctp_new_state(enum ip_conntrack_dir dir,
 	return sctp_conntracks[dir][i][cur_state];
 }
 
+/* Don't need lock here: this conntrack not in circulation yet */
+static noinline bool
+sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
+	 const struct sctphdr *sh, unsigned int dataoff)
+{
+	enum sctp_conntrack new_state;
+	const struct sctp_chunkhdr *sch;
+	struct sctp_chunkhdr _sch;
+	u32 offset, count;
+
+	memset(&ct->proto.sctp, 0, sizeof(ct->proto.sctp));
+	new_state = SCTP_CONNTRACK_MAX;
+	for_each_sctp_chunk(skb, sch, _sch, offset, dataoff, count) {
+		new_state = sctp_new_state(IP_CT_DIR_ORIGINAL,
+					   SCTP_CONNTRACK_NONE, sch->type);
+
+		/* Invalid: delete conntrack */
+		if (new_state == SCTP_CONNTRACK_NONE ||
+		    new_state == SCTP_CONNTRACK_MAX) {
+			pr_debug("nf_conntrack_sctp: invalid new deleting.\n");
+			return false;
+		}
+
+		/* Copy the vtag into the state info */
+		if (sch->type == SCTP_CID_INIT) {
+			struct sctp_inithdr _inithdr, *ih;
+			/* Sec 8.5.1 (A) */
+			if (sh->vtag)
+				return false;
+
+			ih = skb_header_pointer(skb, offset + sizeof(_sch),
+						sizeof(_inithdr), &_inithdr);
+			if (!ih)
+				return false;
+
+			pr_debug("Setting vtag %x for new conn\n",
+				 ih->init_tag);
+
+			ct->proto.sctp.vtag[IP_CT_DIR_REPLY] = ih->init_tag;
+		} else if (sch->type == SCTP_CID_HEARTBEAT) {
+			pr_debug("Setting vtag %x for secondary conntrack\n",
+				 sh->vtag);
+			ct->proto.sctp.vtag[IP_CT_DIR_ORIGINAL] = sh->vtag;
+		} else {
+		/* If it is a shutdown ack OOTB packet, we expect a return
+		   shutdown complete, otherwise an ABORT Sec 8.4 (5) and (8) */
+			pr_debug("Setting vtag %x for new conn OOTB\n",
+				 sh->vtag);
+			ct->proto.sctp.vtag[IP_CT_DIR_REPLY] = sh->vtag;
+		}
+
+		ct->proto.sctp.state = new_state;
+	}
+
+	return true;
+}
+
 /* Returns verdict for packet, or -NF_ACCEPT for invalid. */
 static int sctp_packet(struct nf_conn *ct,
 		       const struct sk_buff *skb,
@@ -297,6 +354,17 @@ static int sctp_packet(struct nf_conn *ct,
 	if (do_basic_checks(ct, skb, dataoff, map) != 0)
 		goto out;
 
+	if (!nf_ct_is_confirmed(ct)) {
+		/* If an OOTB packet has any of these chunks discard (Sec 8.4) */
+		if (test_bit(SCTP_CID_ABORT, map) ||
+		    test_bit(SCTP_CID_SHUTDOWN_COMPLETE, map) ||
+		    test_bit(SCTP_CID_COOKIE_ACK, map))
+			return -NF_ACCEPT;
+
+		if (!sctp_new(ct, skb, sh, dataoff))
+			return -NF_ACCEPT;
+	}
+
 	/* Check the verification tag (Sec 8.5) */
 	if (!test_bit(SCTP_CID_INIT, map) &&
 	    !test_bit(SCTP_CID_SHUTDOWN_COMPLETE, map) &&
@@ -398,80 +466,6 @@ static int sctp_packet(struct nf_conn *ct,
 	return -NF_ACCEPT;
 }
 
-/* Called when a new connection for this protocol found. */
-static bool sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
-		     unsigned int dataoff)
-{
-	enum sctp_conntrack new_state;
-	const struct sctphdr *sh;
-	struct sctphdr _sctph;
-	const struct sctp_chunkhdr *sch;
-	struct sctp_chunkhdr _sch;
-	u_int32_t offset, count;
-	unsigned long map[256 / sizeof(unsigned long)] = { 0 };
-
-	sh = skb_header_pointer(skb, dataoff, sizeof(_sctph), &_sctph);
-	if (sh == NULL)
-		return false;
-
-	if (do_basic_checks(ct, skb, dataoff, map) != 0)
-		return false;
-
-	/* If an OOTB packet has any of these chunks discard (Sec 8.4) */
-	if (test_bit(SCTP_CID_ABORT, map) ||
-	    test_bit(SCTP_CID_SHUTDOWN_COMPLETE, map) ||
-	    test_bit(SCTP_CID_COOKIE_ACK, map))
-		return false;
-
-	memset(&ct->proto.sctp, 0, sizeof(ct->proto.sctp));
-	new_state = SCTP_CONNTRACK_MAX;
-	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
-		/* Don't need lock here: this conntrack not in circulation yet */
-		new_state = sctp_new_state(IP_CT_DIR_ORIGINAL,
-					   SCTP_CONNTRACK_NONE, sch->type);
-
-		/* Invalid: delete conntrack */
-		if (new_state == SCTP_CONNTRACK_NONE ||
-		    new_state == SCTP_CONNTRACK_MAX) {
-			pr_debug("nf_conntrack_sctp: invalid new deleting.\n");
-			return false;
-		}
-
-		/* Copy the vtag into the state info */
-		if (sch->type == SCTP_CID_INIT) {
-			struct sctp_inithdr _inithdr, *ih;
-			/* Sec 8.5.1 (A) */
-			if (sh->vtag)
-				return false;
-
-			ih = skb_header_pointer(skb, offset + sizeof(_sch),
-						sizeof(_inithdr), &_inithdr);
-			if (!ih)
-				return false;
-
-			pr_debug("Setting vtag %x for new conn\n",
-				 ih->init_tag);
-
-			ct->proto.sctp.vtag[IP_CT_DIR_REPLY] = ih->init_tag;
-		} else if (sch->type == SCTP_CID_HEARTBEAT) {
-			pr_debug("Setting vtag %x for secondary conntrack\n",
-				 sh->vtag);
-			ct->proto.sctp.vtag[IP_CT_DIR_ORIGINAL] = sh->vtag;
-		}
-		/* If it is a shutdown ack OOTB packet, we expect a return
-		   shutdown complete, otherwise an ABORT Sec 8.4 (5) and (8) */
-		else {
-			pr_debug("Setting vtag %x for new conn OOTB\n",
-				 sh->vtag);
-			ct->proto.sctp.vtag[IP_CT_DIR_REPLY] = sh->vtag;
-		}
-
-		ct->proto.sctp.state = new_state;
-	}
-
-	return true;
-}
-
 static int sctp_error(struct nf_conn *tpl, struct sk_buff *skb,
 		      unsigned int dataoff,
 		      const struct nf_hook_state *state)
@@ -769,7 +763,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 = {
 	.print_conntrack	= sctp_print_conntrack,
 #endif
 	.packet 		= sctp_packet,
-	.new 			= sctp_new,
 	.error			= sctp_error,
 	.can_early_drop		= sctp_can_early_drop,
 	.me 			= THIS_MODULE,
@@ -803,7 +796,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 = {
 	.print_conntrack	= sctp_print_conntrack,
 #endif
 	.packet 		= sctp_packet,
-	.new 			= sctp_new,
 	.error			= sctp_error,
 	.can_early_drop		= sctp_can_early_drop,
 	.me 			= THIS_MODULE,
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 5128f0a79ed4..6d278cdff145 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -770,6 +770,78 @@ static int tcp_error(struct nf_conn *tmpl,
 	return NF_ACCEPT;
 }
 
+static noinline bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
+			     unsigned int dataoff,
+			     const struct tcphdr *th)
+{
+	enum tcp_conntrack new_state;
+	struct net *net = nf_ct_net(ct);
+	const struct nf_tcp_net *tn = tcp_pernet(net);
+	const struct ip_ct_tcp_state *sender = &ct->proto.tcp.seen[0];
+	const struct ip_ct_tcp_state *receiver = &ct->proto.tcp.seen[1];
+
+	/* Don't need lock here: this conntrack not in circulation yet */
+	new_state = tcp_conntracks[0][get_conntrack_index(th)][TCP_CONNTRACK_NONE];
+
+	/* Invalid: delete conntrack */
+	if (new_state >= TCP_CONNTRACK_MAX) {
+		pr_debug("nf_ct_tcp: invalid new deleting.\n");
+		return false;
+	}
+
+	if (new_state == TCP_CONNTRACK_SYN_SENT) {
+		memset(&ct->proto.tcp, 0, sizeof(ct->proto.tcp));
+		/* SYN packet */
+		ct->proto.tcp.seen[0].td_end =
+			segment_seq_plus_len(ntohl(th->seq), skb->len,
+					     dataoff, th);
+		ct->proto.tcp.seen[0].td_maxwin = ntohs(th->window);
+		if (ct->proto.tcp.seen[0].td_maxwin == 0)
+			ct->proto.tcp.seen[0].td_maxwin = 1;
+		ct->proto.tcp.seen[0].td_maxend =
+			ct->proto.tcp.seen[0].td_end;
+
+		tcp_options(skb, dataoff, th, &ct->proto.tcp.seen[0]);
+	} else if (tn->tcp_loose == 0) {
+		/* Don't try to pick up connections. */
+		return false;
+	} else {
+		memset(&ct->proto.tcp, 0, sizeof(ct->proto.tcp));
+		/*
+		 * We are in the middle of a connection,
+		 * its history is lost for us.
+		 * Let's try to use the data from the packet.
+		 */
+		ct->proto.tcp.seen[0].td_end =
+			segment_seq_plus_len(ntohl(th->seq), skb->len,
+					     dataoff, th);
+		ct->proto.tcp.seen[0].td_maxwin = ntohs(th->window);
+		if (ct->proto.tcp.seen[0].td_maxwin == 0)
+			ct->proto.tcp.seen[0].td_maxwin = 1;
+		ct->proto.tcp.seen[0].td_maxend =
+			ct->proto.tcp.seen[0].td_end +
+			ct->proto.tcp.seen[0].td_maxwin;
+
+		/* We assume SACK and liberal window checking to handle
+		 * window scaling */
+		ct->proto.tcp.seen[0].flags =
+		ct->proto.tcp.seen[1].flags = IP_CT_TCP_FLAG_SACK_PERM |
+					      IP_CT_TCP_FLAG_BE_LIBERAL;
+	}
+
+	/* tcp_packet will set them */
+	ct->proto.tcp.last_index = TCP_NONE_SET;
+
+	pr_debug("%s: sender end=%u maxend=%u maxwin=%u scale=%i "
+		 "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
+		 __func__,
+		 sender->td_end, sender->td_maxend, sender->td_maxwin,
+		 sender->td_scale,
+		 receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
+		 receiver->td_scale);
+	return true;
+}
+
 /* Returns verdict for packet, or -1 for invalid. */
 static int tcp_packet(struct nf_conn *ct,
 		      const struct sk_buff *skb,
@@ -788,7 +860,11 @@ static int tcp_packet(struct nf_conn *ct,
 	unsigned long timeout;
 
 	th = skb_header_pointer(skb, dataoff, sizeof(_tcph), &_tcph);
-	BUG_ON(th == NULL);
+	if (th == NULL)
+		return -NF_ACCEPT;
+
+	if (!nf_ct_is_confirmed(ct) && !tcp_new(ct, skb, dataoff, th))
+		return -NF_ACCEPT;
 
 	spin_lock_bh(&ct->lock);
 	old_state = ct->proto.tcp.state;
@@ -1069,82 +1145,6 @@ static int tcp_packet(struct nf_conn *ct,
 	return NF_ACCEPT;
 }
 
-/* Called when a new connection for this protocol found. */
-static bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
-		    unsigned int dataoff)
-{
-	enum tcp_conntrack new_state;
-	const struct tcphdr *th;
-	struct tcphdr _tcph;
-	struct net *net = nf_ct_net(ct);
-	struct nf_tcp_net *tn = tcp_pernet(net);
-	const struct ip_ct_tcp_state *sender = &ct->proto.tcp.seen[0];
-	const struct ip_ct_tcp_state *receiver = &ct->proto.tcp.seen[1];
-
-	th = skb_header_pointer(skb, dataoff, sizeof(_tcph), &_tcph);
-	BUG_ON(th == NULL);
-
-	/* Don't need lock here: this conntrack not in circulation yet */
-	new_state = tcp_conntracks[0][get_conntrack_index(th)][TCP_CONNTRACK_NONE];
-
-	/* Invalid: delete conntrack */
-	if (new_state >= TCP_CONNTRACK_MAX) {
-		pr_debug("nf_ct_tcp: invalid new deleting.\n");
-		return false;
-	}
-
-	if (new_state == TCP_CONNTRACK_SYN_SENT) {
-		memset(&ct->proto.tcp, 0, sizeof(ct->proto.tcp));
-		/* SYN packet */
-		ct->proto.tcp.seen[0].td_end =
-			segment_seq_plus_len(ntohl(th->seq), skb->len,
-					     dataoff, th);
-		ct->proto.tcp.seen[0].td_maxwin = ntohs(th->window);
-		if (ct->proto.tcp.seen[0].td_maxwin == 0)
-			ct->proto.tcp.seen[0].td_maxwin = 1;
-		ct->proto.tcp.seen[0].td_maxend =
-			ct->proto.tcp.seen[0].td_end;
-
-		tcp_options(skb, dataoff, th, &ct->proto.tcp.seen[0]);
-	} else if (tn->tcp_loose == 0) {
-		/* Don't try to pick up connections. */
-		return false;
-	} else {
-		memset(&ct->proto.tcp, 0, sizeof(ct->proto.tcp));
-		/*
-		 * We are in the middle of a connection,
-		 * its history is lost for us.
-		 * Let's try to use the data from the packet.
-		 */
-		ct->proto.tcp.seen[0].td_end =
-			segment_seq_plus_len(ntohl(th->seq), skb->len,
-					     dataoff, th);
-		ct->proto.tcp.seen[0].td_maxwin = ntohs(th->window);
-		if (ct->proto.tcp.seen[0].td_maxwin == 0)
-			ct->proto.tcp.seen[0].td_maxwin = 1;
-		ct->proto.tcp.seen[0].td_maxend =
-			ct->proto.tcp.seen[0].td_end +
-			ct->proto.tcp.seen[0].td_maxwin;
-
-		/* We assume SACK and liberal window checking to handle
-		 * window scaling */
-		ct->proto.tcp.seen[0].flags =
-		ct->proto.tcp.seen[1].flags = IP_CT_TCP_FLAG_SACK_PERM |
-					      IP_CT_TCP_FLAG_BE_LIBERAL;
-	}
-
-	/* tcp_packet will set them */
-	ct->proto.tcp.last_index = TCP_NONE_SET;
-
-	pr_debug("tcp_new: sender end=%u maxend=%u maxwin=%u scale=%i "
-		 "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
-		 sender->td_end, sender->td_maxend, sender->td_maxwin,
-		 sender->td_scale,
-		 receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
-		 receiver->td_scale);
-	return true;
-}
-
 static bool tcp_can_early_drop(const struct nf_conn *ct)
 {
 	switch (ct->proto.tcp.state) {
@@ -1548,7 +1548,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 =
 	.print_conntrack 	= tcp_print_conntrack,
 #endif
 	.packet 		= tcp_packet,
-	.new 			= tcp_new,
 	.error			= tcp_error,
 	.can_early_drop		= tcp_can_early_drop,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
@@ -1583,7 +1582,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6 =
 	.print_conntrack 	= tcp_print_conntrack,
 #endif
 	.packet 		= tcp_packet,
-	.new 			= tcp_new,
 	.error			= tcp_error,
 	.can_early_drop		= tcp_can_early_drop,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index bf59d32bba98..1119323425e7 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -70,13 +70,6 @@ static int udp_packet(struct nf_conn *ct,
 	return NF_ACCEPT;
 }
 
-/* Called when a new connection for this protocol found. */
-static bool udp_new(struct nf_conn *ct, const struct sk_buff *skb,
-		    unsigned int dataoff)
-{
-	return true;
-}
-
 #ifdef CONFIG_NF_CT_PROTO_UDPLITE
 static void udplite_error_log(const struct sk_buff *skb,
 			      const struct nf_hook_state *state,
@@ -288,7 +281,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 =
 	.l4proto		= IPPROTO_UDP,
 	.allow_clash		= true,
 	.packet			= udp_packet,
-	.new			= udp_new,
 	.error			= udp_error,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
@@ -317,7 +309,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4 =
 	.l4proto		= IPPROTO_UDPLITE,
 	.allow_clash		= true,
 	.packet			= udp_packet,
-	.new			= udp_new,
 	.error			= udplite_error,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
@@ -346,7 +337,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 =
 	.l4proto		= IPPROTO_UDP,
 	.allow_clash		= true,
 	.packet			= udp_packet,
-	.new			= udp_new,
 	.error			= udp_error,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
@@ -375,7 +365,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6 =
 	.l4proto		= IPPROTO_UDPLITE,
 	.allow_clash		= true,
 	.packet			= udp_packet,
-	.new			= udp_new,
 	.error			= udplite_error,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
-- 
2.11.0
