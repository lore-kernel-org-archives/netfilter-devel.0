From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 16/31] netfilter: conntrack: deconstify packet callback skb pointer
Date: Tue,  9 Oct 2018 01:01:10 +0200
Message-ID: <20181008230125.2330-17-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Only two protocols need the ->error() function: icmp and icmpv6.
This is because icmp error mssages might be RELATED to an existing
connection (e.g. PMTUD, port unreachable and the like), and their
->error() handlers do this.

The error callback is already optional, so remove it for
udp and call them from ->packet() instead.

As the error() callback can call checksum functions that write to
skb->csum*, the const qualifier has to be removed as well.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h |   2 +-
 net/netfilter/nf_conntrack_proto_dccp.c      |   2 +-
 net/netfilter/nf_conntrack_proto_generic.c   |   2 +-
 net/netfilter/nf_conntrack_proto_gre.c       |   2 +-
 net/netfilter/nf_conntrack_proto_icmp.c      |   2 +-
 net/netfilter/nf_conntrack_proto_icmpv6.c    |   8 +-
 net/netfilter/nf_conntrack_proto_sctp.c      |   2 +-
 net/netfilter/nf_conntrack_proto_tcp.c       |   2 +-
 net/netfilter/nf_conntrack_proto_udp.c       | 137 ++++++++++++++++-----------
 9 files changed, 95 insertions(+), 64 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 016958e67fcc..39f0c84f71b9 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -43,7 +43,7 @@ struct nf_conntrack_l4proto {
 
 	/* Returns verdict for packet, or -1 for invalid. */
 	int (*packet)(struct nf_conn *ct,
-		      const struct sk_buff *skb,
+		      struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
 		      const struct nf_hook_state *state);
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index e7b5449ea883..fdea305c7aa5 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -435,7 +435,7 @@ static u64 dccp_ack_seq(const struct dccp_hdr *dh)
 		     ntohl(dhack->dccph_ack_nr_low);
 }
 
-static int dccp_packet(struct nf_conn *ct, const struct sk_buff *skb,
+static int dccp_packet(struct nf_conn *ct, struct sk_buff *skb,
 		       unsigned int dataoff, enum ip_conntrack_info ctinfo,
 		       const struct nf_hook_state *state)
 {
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index deeb05c50f02..fea952518d0d 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -44,7 +44,7 @@ static bool generic_pkt_to_tuple(const struct sk_buff *skb,
 
 /* Returns verdict for packet, or -1 for invalid. */
 static int generic_packet(struct nf_conn *ct,
-			  const struct sk_buff *skb,
+			  struct sk_buff *skb,
 			  unsigned int dataoff,
 			  enum ip_conntrack_info ctinfo,
 			  const struct nf_hook_state *state)
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index a44bbee271cb..0348aa98950a 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -233,7 +233,7 @@ static unsigned int *gre_get_timeouts(struct net *net)
 
 /* Returns verdict for packet, and may modify conntrack */
 static int gre_packet(struct nf_conn *ct,
-		      const struct sk_buff *skb,
+		      struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
 		      const struct nf_hook_state *state)
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index 19ef0c41602b..a2ca3a739aa3 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -74,7 +74,7 @@ static bool icmp_invert_tuple(struct nf_conntrack_tuple *tuple,
 
 /* Returns verdict for packet, or -1 for invalid. */
 static int icmp_packet(struct nf_conn *ct,
-		       const struct sk_buff *skb,
+		       struct sk_buff *skb,
 		       unsigned int dataoff,
 		       enum ip_conntrack_info ctinfo,
 		       const struct nf_hook_state *state)
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index bb94363818e6..a1933566d53d 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -92,10 +92,10 @@ static unsigned int *icmpv6_get_timeouts(struct net *net)
 
 /* Returns verdict for packet, or -1 for invalid. */
 static int icmpv6_packet(struct nf_conn *ct,
-		       const struct sk_buff *skb,
-		       unsigned int dataoff,
-		       enum ip_conntrack_info ctinfo,
-		       const struct nf_hook_state *state)
+		         struct sk_buff *skb,
+		         unsigned int dataoff,
+		         enum ip_conntrack_info ctinfo,
+		         const struct nf_hook_state *state)
 {
 	unsigned int *timeout = nf_ct_timeout_lookup(ct);
 	static const u8 valid_new[] = {
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 78c115152a78..ea16c1c58483 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -332,7 +332,7 @@ sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 
 /* Returns verdict for packet, or -NF_ACCEPT for invalid. */
 static int sctp_packet(struct nf_conn *ct,
-		       const struct sk_buff *skb,
+		       struct sk_buff *skb,
 		       unsigned int dataoff,
 		       enum ip_conntrack_info ctinfo,
 		       const struct nf_hook_state *state)
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 6d278cdff145..0c3e1f2f9013 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -844,7 +844,7 @@ static noinline bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
 
 /* Returns verdict for packet, or -1 for invalid. */
 static int tcp_packet(struct nf_conn *ct,
-		      const struct sk_buff *skb,
+		      struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
 		      const struct nf_hook_state *state)
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 1119323425e7..da94c967c835 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -42,15 +42,65 @@ static unsigned int *udp_get_timeouts(struct net *net)
 	return udp_pernet(net)->timeouts;
 }
 
+static void udp_error_log(const struct sk_buff *skb,
+			  const struct nf_hook_state *state,
+			  const char *msg)
+{
+	nf_l4proto_log_invalid(skb, state->net, state->pf,
+			       IPPROTO_UDP, "%s", msg);
+}
+
+static bool udp_error(struct sk_buff *skb,
+		      unsigned int dataoff,
+		      const struct nf_hook_state *state)
+{
+	unsigned int udplen = skb->len - dataoff;
+	const struct udphdr *hdr;
+	struct udphdr _hdr;
+
+	/* Header is too small? */
+	hdr = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
+	if (!hdr) {
+		udp_error_log(skb, state, "short packet");
+		return true;
+	}
+
+	/* Truncated/malformed packets */
+	if (ntohs(hdr->len) > udplen || ntohs(hdr->len) < sizeof(*hdr)) {
+		udp_error_log(skb, state, "truncated/malformed packet");
+		return true;
+	}
+
+	/* Packet with no checksum */
+	if (!hdr->check)
+		return false;
+
+	/* Checksum invalid? Ignore.
+	 * We skip checking packets on the outgoing path
+	 * because the checksum is assumed to be correct.
+	 * FIXME: Source route IP option packets --RR */
+	if (state->hook == NF_INET_PRE_ROUTING &&
+	    state->net->ct.sysctl_checksum &&
+	    nf_checksum(skb, state->hook, dataoff, IPPROTO_UDP, state->pf)) {
+		udp_error_log(skb, state, "bad checksum");
+		return true;
+	}
+
+	return false;
+}
+
 /* Returns verdict for packet, and may modify conntracktype */
 static int udp_packet(struct nf_conn *ct,
-		      const struct sk_buff *skb,
+		      struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum ip_conntrack_info ctinfo,
 		      const struct nf_hook_state *state)
 {
 	unsigned int *timeouts;
 
+	if (udp_error(skb, dataoff, state))
+		return -NF_ACCEPT;
+
 	timeouts = nf_ct_timeout_lookup(ct);
 	if (!timeouts)
 		timeouts = udp_get_timeouts(nf_ct_net(ct));
@@ -79,9 +129,9 @@ static void udplite_error_log(const struct sk_buff *skb,
 			       IPPROTO_UDPLITE, "%s", msg);
 }
 
-static int udplite_error(struct nf_conn *tmpl, struct sk_buff *skb,
-			 unsigned int dataoff,
-			 const struct nf_hook_state *state)
+static bool udplite_error(struct sk_buff *skb,
+			  unsigned int dataoff,
+			  const struct nf_hook_state *state)
 {
 	unsigned int udplen = skb->len - dataoff;
 	const struct udphdr *hdr;
@@ -92,7 +142,7 @@ static int udplite_error(struct nf_conn *tmpl, struct sk_buff *skb,
 	hdr = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
 	if (!hdr) {
 		udplite_error_log(skb, state, "short packet");
-		return -NF_ACCEPT;
+		return true;
 	}
 
 	cscov = ntohs(hdr->len);
@@ -100,13 +150,13 @@ static int udplite_error(struct nf_conn *tmpl, struct sk_buff *skb,
 		cscov = udplen;
 	} else if (cscov < sizeof(*hdr) || cscov > udplen) {
 		udplite_error_log(skb, state, "invalid checksum coverage");
-		return -NF_ACCEPT;
+		return true;
 	}
 
 	/* UDPLITE mandates checksums */
 	if (!hdr->check) {
 		udplite_error_log(skb, state, "checksum missing");
-		return -NF_ACCEPT;
+		return true;
 	}
 
 	/* Checksum invalid? Ignore. */
@@ -115,58 +165,43 @@ static int udplite_error(struct nf_conn *tmpl, struct sk_buff *skb,
 	    nf_checksum_partial(skb, state->hook, dataoff, cscov, IPPROTO_UDP,
 				state->pf)) {
 		udplite_error_log(skb, state, "bad checksum");
-		return -NF_ACCEPT;
+		return true;
 	}
 
-	return NF_ACCEPT;
+	return false;
 }
-#endif
 
-static void udp_error_log(const struct sk_buff *skb,
-			  const struct nf_hook_state *state,
-			  const char *msg)
-{
-	nf_l4proto_log_invalid(skb, state->net, state->pf,
-			       IPPROTO_UDP, "%s", msg);
-}
-
-static int udp_error(struct nf_conn *tmpl, struct sk_buff *skb,
-		     unsigned int dataoff,
-		     const struct nf_hook_state *state)
+/* Returns verdict for packet, and may modify conntracktype */
+static int udplite_packet(struct nf_conn *ct,
+			  struct sk_buff *skb,
+			  unsigned int dataoff,
+			  enum ip_conntrack_info ctinfo,
+			  const struct nf_hook_state *state)
 {
-	unsigned int udplen = skb->len - dataoff;
-	const struct udphdr *hdr;
-	struct udphdr _hdr;
-
-	/* Header is too small? */
-	hdr = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
-	if (hdr == NULL) {
-		udp_error_log(skb, state, "short packet");
-		return -NF_ACCEPT;
-	}
+	unsigned int *timeouts;
 
-	/* Truncated/malformed packets */
-	if (ntohs(hdr->len) > udplen || ntohs(hdr->len) < sizeof(*hdr)) {
-		udp_error_log(skb, state, "truncated/malformed packet");
+	if (udplite_error(skb, dataoff, state))
 		return -NF_ACCEPT;
-	}
 
-	/* Packet with no checksum */
-	if (!hdr->check)
-		return NF_ACCEPT;
+	timeouts = nf_ct_timeout_lookup(ct);
+	if (!timeouts)
+		timeouts = udp_get_timeouts(nf_ct_net(ct));
 
-	/* Checksum invalid? Ignore.
-	 * We skip checking packets on the outgoing path
-	 * because the checksum is assumed to be correct.
-	 * FIXME: Source route IP option packets --RR */
-	if (state->net->ct.sysctl_checksum && state->hook == NF_INET_PRE_ROUTING &&
-	    nf_checksum(skb, state->hook, dataoff, IPPROTO_UDP, state->pf)) {
-		udp_error_log(skb, state, "bad checksum");
-		return -NF_ACCEPT;
+	/* If we've seen traffic both ways, this is some kind of UDP
+	   stream.  Extend timeout. */
+	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
+		nf_ct_refresh_acct(ct, ctinfo, skb,
+				   timeouts[UDP_CT_REPLIED]);
+		/* Also, more likely to be important, and not a probe */
+		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
+			nf_conntrack_event_cache(IPCT_ASSURED, ct);
+	} else {
+		nf_ct_refresh_acct(ct, ctinfo, skb,
+				   timeouts[UDP_CT_UNREPLIED]);
 	}
-
 	return NF_ACCEPT;
 }
+#endif
 
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 
@@ -281,7 +316,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 =
 	.l4proto		= IPPROTO_UDP,
 	.allow_clash		= true,
 	.packet			= udp_packet,
-	.error			= udp_error,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
@@ -308,8 +342,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite4 =
 	.l3proto		= PF_INET,
 	.l4proto		= IPPROTO_UDPLITE,
 	.allow_clash		= true,
-	.packet			= udp_packet,
-	.error			= udplite_error,
+	.packet			= udplite_packet,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
@@ -337,7 +370,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 =
 	.l4proto		= IPPROTO_UDP,
 	.allow_clash		= true,
 	.packet			= udp_packet,
-	.error			= udp_error,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
@@ -364,8 +396,7 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6 =
 	.l3proto		= PF_INET6,
 	.l4proto		= IPPROTO_UDPLITE,
 	.allow_clash		= true,
-	.packet			= udp_packet,
-	.error			= udplite_error,
+	.packet			= udplite_packet,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
-- 
2.11.0
