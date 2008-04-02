From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 14/24] [NETFILTER]: Use bool in nf_conntrack_l4proto
Date: Wed,  2 Apr 2008 13:11:56 +0200
Message-ID: <3fe7a3dd723a0f2c303559ef46e3d7d67702db57.1207134547.git.jengelh@computergmbh.de>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43169 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059AbYDBLML (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:12:11 -0400
In-Reply-To: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
References: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/net/netfilter/nf_conntrack_l4proto.h   |   13 ++--
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   25 ++++----
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   27 ++++-----
 net/netfilter/nf_conntrack_proto_generic.c     |   20 +++---
 net/netfilter/nf_conntrack_proto_gre.c         |   25 ++++----
 net/netfilter/nf_conntrack_proto_sctp.c        |   33 +++++------
 net/netfilter/nf_conntrack_proto_tcp.c         |   48 +++++++---------
 net/netfilter/nf_conntrack_proto_udp.c         |   21 +++----
 net/netfilter/nf_conntrack_proto_udplite.c     |   22 ++++----
 9 files changed, 111 insertions(+), 123 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 1d2f8fd..f3676c4 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -25,15 +25,14 @@ struct nf_conntrack_l4proto
 
 	/* Try to fill in the third arg: dataoff is offset past network protocol
            hdr.  Return true if possible. */
-	int (*pkt_to_tuple)(const struct sk_buff *skb,
-			    unsigned int dataoff,
-			    struct nf_conntrack_tuple *tuple);
+	bool (*pkt_to_tuple)(const struct sk_buff *skb, unsigned int dataoff,
+	                     struct nf_conntrack_tuple *tuple);
 
 	/* Invert the per-proto part of the tuple: ie. turn xmit into reply.
 	 * Some packets can't be inverted: return 0 in that case.
 	 */
-	int (*invert_tuple)(struct nf_conntrack_tuple *inverse,
-			    const struct nf_conntrack_tuple *orig);
+	bool (*invert_tuple)(struct nf_conntrack_tuple *inverse,
+	                     const struct nf_conntrack_tuple *orig);
 
 	/* Returns verdict for packet, or -1 for invalid. */
 	int (*packet)(struct nf_conn *ct,
@@ -45,8 +44,8 @@ struct nf_conntrack_l4proto
 
 	/* Called when a new connection for this protocol found;
 	 * returns TRUE if it's OK.  If so, packet() called next. */
-	int (*new)(struct nf_conn *ct, const struct sk_buff *skb,
-		   unsigned int dataoff);
+	bool (*new)(struct nf_conn *ct, const struct sk_buff *skb,
+	            unsigned int dataoff);
 
 	/* Called when a conntrack entry is destroyed */
 	void (*destroy)(struct nf_conn *ct);
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 999f305..3b0591f 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -22,22 +22,21 @@
 
 static unsigned long nf_ct_icmp_timeout __read_mostly = 30*HZ;
 
-static int icmp_pkt_to_tuple(const struct sk_buff *skb,
-			     unsigned int dataoff,
-			     struct nf_conntrack_tuple *tuple)
+static bool icmp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
+                              struct nf_conntrack_tuple *tuple)
 {
 	const struct icmphdr *hp;
 	struct icmphdr _hdr;
 
 	hp = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
 	if (hp == NULL)
-		return 0;
+		return false;
 
 	tuple->dst.u.icmp.type = hp->type;
 	tuple->src.u.icmp.id = hp->un.echo.id;
 	tuple->dst.u.icmp.code = hp->code;
 
-	return 1;
+	return true;
 }
 
 /* Add 1; spaces filled with 0. */
@@ -52,17 +51,17 @@ static const u_int8_t invmap[] = {
 	[ICMP_ADDRESSREPLY] = ICMP_ADDRESS + 1
 };
 
-static int icmp_invert_tuple(struct nf_conntrack_tuple *tuple,
-			     const struct nf_conntrack_tuple *orig)
+static bool icmp_invert_tuple(struct nf_conntrack_tuple *tuple,
+                              const struct nf_conntrack_tuple *orig)
 {
 	if (orig->dst.u.icmp.type >= sizeof(invmap)
 	    || !invmap[orig->dst.u.icmp.type])
-		return 0;
+		return false;
 
 	tuple->src.u.icmp.id = orig->src.u.icmp.id;
 	tuple->dst.u.icmp.type = invmap[orig->dst.u.icmp.type] - 1;
 	tuple->dst.u.icmp.code = orig->dst.u.icmp.code;
-	return 1;
+	return true;
 }
 
 /* Print out the per-protocol part of the tuple. */
@@ -101,8 +100,8 @@ static int icmp_packet(struct nf_conn *ct,
 }
 
 /* Called when a new connection for this protocol found. */
-static int icmp_new(struct nf_conn *ct,
-		    const struct sk_buff *skb, unsigned int dataoff)
+static bool icmp_new(struct nf_conn *ct, const struct sk_buff *skb,
+                     unsigned int dataoff)
 {
 	static const u_int8_t valid_new[] = {
 		[ICMP_ECHO] = 1,
@@ -117,10 +116,10 @@ static int icmp_new(struct nf_conn *ct,
 		pr_debug("icmp: can't create new conn with type %u\n",
 			 ct->tuplehash[0].tuple.dst.u.icmp.type);
 		NF_CT_DUMP_TUPLE(&ct->tuplehash[0].tuple);
-		return 0;
+		return false;
 	}
 	atomic_set(&ct->proto.icmp.count, 0);
-	return 1;
+	return true;
 }
 
 /* Returns conntrack if it dealt with ICMP, and filled in skb fields */
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index a7551ad..7b88299 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -28,21 +28,21 @@
 
 static unsigned long nf_ct_icmpv6_timeout __read_mostly = 30*HZ;
 
-static int icmpv6_pkt_to_tuple(const struct sk_buff *skb,
-			       unsigned int dataoff,
-			       struct nf_conntrack_tuple *tuple)
+static bool
+icmpv6_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
+                    struct nf_conntrack_tuple *tuple)
 {
 	const struct icmp6hdr *hp;
 	struct icmp6hdr _hdr;
 
 	hp = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
 	if (hp == NULL)
-		return 0;
+		return false;
 	tuple->dst.u.icmp.type = hp->icmp6_type;
 	tuple->src.u.icmp.id = hp->icmp6_identifier;
 	tuple->dst.u.icmp.code = hp->icmp6_code;
 
-	return 1;
+	return true;
 }
 
 /* Add 1; spaces filled with 0. */
@@ -53,17 +53,17 @@ static const u_int8_t invmap[] = {
 	[ICMPV6_NI_REPLY - 128]		= ICMPV6_NI_REPLY +1
 };
 
-static int icmpv6_invert_tuple(struct nf_conntrack_tuple *tuple,
-			       const struct nf_conntrack_tuple *orig)
+static bool icmpv6_invert_tuple(struct nf_conntrack_tuple *tuple,
+                                const struct nf_conntrack_tuple *orig)
 {
 	int type = orig->dst.u.icmp.type - 128;
 	if (type < 0 || type >= sizeof(invmap) || !invmap[type])
-		return 0;
+		return false;
 
 	tuple->src.u.icmp.id   = orig->src.u.icmp.id;
 	tuple->dst.u.icmp.type = invmap[type] - 1;
 	tuple->dst.u.icmp.code = orig->dst.u.icmp.code;
-	return 1;
+	return true;
 }
 
 /* Print out the per-protocol part of the tuple. */
@@ -102,9 +102,8 @@ static int icmpv6_packet(struct nf_conn *ct,
 }
 
 /* Called when a new connection for this protocol found. */
-static int icmpv6_new(struct nf_conn *ct,
-		      const struct sk_buff *skb,
-		      unsigned int dataoff)
+static bool icmpv6_new(struct nf_conn *ct, const struct sk_buff *skb,
+                       unsigned int dataoff)
 {
 	static const u_int8_t valid_new[] = {
 		[ICMPV6_ECHO_REQUEST - 128] = 1,
@@ -117,10 +116,10 @@ static int icmpv6_new(struct nf_conn *ct,
 		pr_debug("icmpv6: can't create new conn with type %u\n",
 			 type + 128);
 		NF_CT_DUMP_TUPLE(&ct->tuplehash[0].tuple);
-		return 0;
+		return false;
 	}
 	atomic_set(&ct->proto.icmp.count, 0);
-	return 1;
+	return true;
 }
 
 static int
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 6470194..395a6c6 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -14,23 +14,23 @@
 
 static unsigned int nf_ct_generic_timeout __read_mostly = 600*HZ;
 
-static int generic_pkt_to_tuple(const struct sk_buff *skb,
-				unsigned int dataoff,
-				struct nf_conntrack_tuple *tuple)
+static bool
+generic_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
+                     struct nf_conntrack_tuple *tuple)
 {
 	tuple->src.u.all = 0;
 	tuple->dst.u.all = 0;
 
-	return 1;
+	return true;
 }
 
-static int generic_invert_tuple(struct nf_conntrack_tuple *tuple,
-				const struct nf_conntrack_tuple *orig)
+static bool generic_invert_tuple(struct nf_conntrack_tuple *tuple,
+                                 const struct nf_conntrack_tuple *orig)
 {
 	tuple->src.u.all = 0;
 	tuple->dst.u.all = 0;
 
-	return 1;
+	return true;
 }
 
 /* Print out the per-protocol part of the tuple. */
@@ -53,10 +53,10 @@ static int packet(struct nf_conn *ct,
 }
 
 /* Called when a new connection for this protocol found. */
-static int new(struct nf_conn *ct, const struct sk_buff *skb,
-	       unsigned int dataoff)
+static bool new(struct nf_conn *ct, const struct sk_buff *skb,
+                unsigned int dataoff)
 {
-	return 1;
+	return true;
 }
 
 #ifdef CONFIG_SYSCTL
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index e85096e..7f82933 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -148,18 +148,17 @@ EXPORT_SYMBOL_GPL(nf_ct_gre_keymap_destroy);
 /* PUBLIC CONNTRACK PROTO HELPER FUNCTIONS */
 
 /* invert gre part of tuple */
-static int gre_invert_tuple(struct nf_conntrack_tuple *tuple,
-			    const struct nf_conntrack_tuple *orig)
+static bool gre_invert_tuple(struct nf_conntrack_tuple *tuple,
+                             const struct nf_conntrack_tuple *orig)
 {
 	tuple->dst.u.gre.key = orig->src.u.gre.key;
 	tuple->src.u.gre.key = orig->dst.u.gre.key;
-	return 1;
+	return true;
 }
 
 /* gre hdr info to tuple */
-static int gre_pkt_to_tuple(const struct sk_buff *skb,
-			   unsigned int dataoff,
-			   struct nf_conntrack_tuple *tuple)
+static bool gre_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
+                             struct nf_conntrack_tuple *tuple)
 {
 	const struct gre_hdr_pptp *pgrehdr;
 	struct gre_hdr_pptp _pgrehdr;
@@ -173,24 +172,24 @@ static int gre_pkt_to_tuple(const struct sk_buff *skb,
 		/* try to behave like "nf_conntrack_proto_generic" */
 		tuple->src.u.all = 0;
 		tuple->dst.u.all = 0;
-		return 1;
+		return true;
 	}
 
 	/* PPTP header is variable length, only need up to the call_id field */
 	pgrehdr = skb_header_pointer(skb, dataoff, 8, &_pgrehdr);
 	if (!pgrehdr)
-		return 1;
+		return true;
 
 	if (ntohs(grehdr->protocol) != GRE_PROTOCOL_PPTP) {
 		pr_debug("GRE_VERSION_PPTP but unknown proto\n");
-		return 0;
+		return false;
 	}
 
 	tuple->dst.u.gre.key = pgrehdr->call_id;
 	srckey = gre_keymap_lookup(tuple);
 	tuple->src.u.gre.key = srckey;
 
-	return 1;
+	return true;
 }
 
 /* print gre part of tuple */
@@ -235,8 +234,8 @@ static int gre_packet(struct nf_conn *ct,
 }
 
 /* Called when a new connection for this protocol found. */
-static int gre_new(struct nf_conn *ct, const struct sk_buff *skb,
-		   unsigned int dataoff)
+static bool gre_new(struct nf_conn *ct, const struct sk_buff *skb,
+                    unsigned int dataoff)
 {
 	pr_debug(": ");
 	NF_CT_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
@@ -246,7 +245,7 @@ static int gre_new(struct nf_conn *ct, const struct sk_buff *skb,
 	ct->proto.gre.stream_timeout = GRE_STREAM_TIMEOUT;
 	ct->proto.gre.timeout = GRE_TIMEOUT;
 
-	return 1;
+	return true;
 }
 
 /* Called when a conntrack entry has already been removed from the hashes
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index d61f83e..e7dab58 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -130,28 +130,27 @@ static const u8 sctp_conntracks[2][9][SCTP_CONNTRACK_MAX] = {
 	}
 };
 
-static int sctp_pkt_to_tuple(const struct sk_buff *skb,
-			     unsigned int dataoff,
-			     struct nf_conntrack_tuple *tuple)
+static bool sctp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
+                              struct nf_conntrack_tuple *tuple)
 {
 	sctp_sctphdr_t _hdr, *hp;
 
 	/* Actually only need first 8 bytes. */
 	hp = skb_header_pointer(skb, dataoff, 8, &_hdr);
 	if (hp == NULL)
-		return 0;
+		return false;
 
 	tuple->src.u.sctp.port = hp->source;
 	tuple->dst.u.sctp.port = hp->dest;
-	return 1;
+	return true;
 }
 
-static int sctp_invert_tuple(struct nf_conntrack_tuple *tuple,
-			     const struct nf_conntrack_tuple *orig)
+static bool sctp_invert_tuple(struct nf_conntrack_tuple *tuple,
+                              const struct nf_conntrack_tuple *orig)
 {
 	tuple->src.u.sctp.port = orig->dst.u.sctp.port;
 	tuple->dst.u.sctp.port = orig->src.u.sctp.port;
-	return 1;
+	return true;
 }
 
 /* Print out the per-protocol part of the tuple. */
@@ -390,8 +389,8 @@ out:
 }
 
 /* Called when a new connection for this protocol found. */
-static int sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
-		    unsigned int dataoff)
+static bool sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
+                     unsigned int dataoff)
 {
 	enum sctp_conntrack new_state;
 	sctp_sctphdr_t _sctph, *sh;
@@ -401,16 +400,16 @@ static int sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 
 	sh = skb_header_pointer(skb, dataoff, sizeof(_sctph), &_sctph);
 	if (sh == NULL)
-		return 0;
+		return false;
 
 	if (do_basic_checks(ct, skb, dataoff, map) != 0)
-		return 0;
+		return false;
 
 	/* If an OOTB packet has any of these chunks discard (Sec 8.4) */
 	if (test_bit(SCTP_CID_ABORT, map) ||
 	    test_bit(SCTP_CID_SHUTDOWN_COMPLETE, map) ||
 	    test_bit(SCTP_CID_COOKIE_ACK, map))
-		return 0;
+		return false;
 
 	new_state = SCTP_CONNTRACK_MAX;
 	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
@@ -422,7 +421,7 @@ static int sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 		if (new_state == SCTP_CONNTRACK_NONE ||
 		    new_state == SCTP_CONNTRACK_MAX) {
 			pr_debug("nf_conntrack_sctp: invalid new deleting.\n");
-			return 0;
+			return false;
 		}
 
 		/* Copy the vtag into the state info */
@@ -433,7 +432,7 @@ static int sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 				ih = skb_header_pointer(skb, offset + sizeof(sctp_chunkhdr_t),
 							sizeof(_inithdr), &_inithdr);
 				if (ih == NULL)
-					return 0;
+					return false;
 
 				pr_debug("Setting vtag %x for new conn\n",
 					 ih->init_tag);
@@ -442,7 +441,7 @@ static int sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 								ih->init_tag;
 			} else {
 				/* Sec 8.5.1 (A) */
-				return 0;
+				return false;
 			}
 		}
 		/* If it is a shutdown ack OOTB packet, we expect a return
@@ -456,7 +455,7 @@ static int sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 		ct->proto.sctp.state = new_state;
 	}
 
-	return 1;
+	return true;
 }
 
 #ifdef CONFIG_SYSCTL
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index b3e557d..67caddc 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -257,9 +257,8 @@ static const u8 tcp_conntracks[2][6][TCP_CONNTRACK_MAX] = {
 	}
 };
 
-static int tcp_pkt_to_tuple(const struct sk_buff *skb,
-			    unsigned int dataoff,
-			    struct nf_conntrack_tuple *tuple)
+static bool tcp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
+                             struct nf_conntrack_tuple *tuple)
 {
 	const struct tcphdr *hp;
 	struct tcphdr _hdr;
@@ -267,20 +266,20 @@ static int tcp_pkt_to_tuple(const struct sk_buff *skb,
 	/* Actually only need first 8 bytes. */
 	hp = skb_header_pointer(skb, dataoff, 8, &_hdr);
 	if (hp == NULL)
-		return 0;
+		return false;
 
 	tuple->src.u.tcp.port = hp->source;
 	tuple->dst.u.tcp.port = hp->dest;
 
-	return 1;
+	return true;
 }
 
-static int tcp_invert_tuple(struct nf_conntrack_tuple *tuple,
-			    const struct nf_conntrack_tuple *orig)
+static bool tcp_invert_tuple(struct nf_conntrack_tuple *tuple,
+                             const struct nf_conntrack_tuple *orig)
 {
 	tuple->src.u.tcp.port = orig->dst.u.tcp.port;
 	tuple->dst.u.tcp.port = orig->src.u.tcp.port;
-	return 1;
+	return true;
 }
 
 /* Print out the per-protocol part of the tuple. */
@@ -478,20 +477,16 @@ static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
 	}
 }
 
-static int tcp_in_window(const struct nf_conn *ct,
-			 struct ip_ct_tcp *state,
-			 enum ip_conntrack_dir dir,
-			 unsigned int index,
-			 const struct sk_buff *skb,
-			 unsigned int dataoff,
-			 const struct tcphdr *tcph,
-			 unsigned int pf)
+static bool tcp_in_window(const struct nf_conn *ct, struct ip_ct_tcp *state,
+                          enum ip_conntrack_dir dir, unsigned int index,
+                          const struct sk_buff *skb, unsigned int dataoff,
+                          const struct tcphdr *tcph, unsigned int pf)
 {
 	struct ip_ct_tcp_state *sender = &state->seen[dir];
 	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
 	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
 	__u32 seq, ack, sack, end, win, swin;
-	int res;
+	bool res;
 
 	/*
 	 * Get the required data from the packet.
@@ -657,12 +652,12 @@ static int tcp_in_window(const struct nf_conn *ct,
 				state->retrans = 0;
 			}
 		}
-		res = 1;
+		res = true;
 	} else {
-		res = 0;
+		res = false;
 		if (sender->flags & IP_CT_TCP_FLAG_BE_LIBERAL ||
 		    nf_ct_tcp_be_liberal)
-			res = 1;
+			res = true;
 		if (!res && LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
 			"nf_ct_tcp: %s ",
@@ -676,7 +671,7 @@ static int tcp_in_window(const struct nf_conn *ct,
 			: "SEQ is over the upper bound (over the window of the receiver)");
 	}
 
-	pr_debug("tcp_in_window: res=%i sender end=%u maxend=%u maxwin=%u "
+	pr_debug("tcp_in_window: res=%u sender end=%u maxend=%u maxwin=%u "
 		 "receiver end=%u maxend=%u maxwin=%u\n",
 		 res, sender->td_end, sender->td_maxend, sender->td_maxwin,
 		 receiver->td_end, receiver->td_maxend, receiver->td_maxwin);
@@ -982,9 +977,8 @@ static int tcp_packet(struct nf_conn *ct,
 }
 
 /* Called when a new connection for this protocol found. */
-static int tcp_new(struct nf_conn *ct,
-		   const struct sk_buff *skb,
-		   unsigned int dataoff)
+static bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
+                    unsigned int dataoff)
 {
 	enum tcp_conntrack new_state;
 	const struct tcphdr *th;
@@ -1003,7 +997,7 @@ static int tcp_new(struct nf_conn *ct,
 	/* Invalid: delete conntrack */
 	if (new_state >= TCP_CONNTRACK_MAX) {
 		pr_debug("nf_ct_tcp: invalid new deleting.\n");
-		return 0;
+		return false;
 	}
 
 	if (new_state == TCP_CONNTRACK_SYN_SENT) {
@@ -1021,7 +1015,7 @@ static int tcp_new(struct nf_conn *ct,
 		ct->proto.tcp.seen[1].flags = 0;
 	} else if (nf_ct_tcp_loose == 0) {
 		/* Don't try to pick up connections. */
-		return 0;
+		return false;
 	} else {
 		/*
 		 * We are in the middle of a connection,
@@ -1061,7 +1055,7 @@ static int tcp_new(struct nf_conn *ct,
 		 sender->td_scale,
 		 receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
 		 receiver->td_scale);
-	return 1;
+	return true;
 }
 
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index f86aba3..a474c28 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -26,9 +26,8 @@
 static unsigned int nf_ct_udp_timeout __read_mostly = 30*HZ;
 static unsigned int nf_ct_udp_timeout_stream __read_mostly = 180*HZ;
 
-static int udp_pkt_to_tuple(const struct sk_buff *skb,
-			     unsigned int dataoff,
-			     struct nf_conntrack_tuple *tuple)
+static bool udp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
+                             struct nf_conntrack_tuple *tuple)
 {
 	const struct udphdr *hp;
 	struct udphdr _hdr;
@@ -36,20 +35,20 @@ static int udp_pkt_to_tuple(const struct sk_buff *skb,
 	/* Actually only need first 8 bytes. */
 	hp = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
 	if (hp == NULL)
-		return 0;
+		return false;
 
 	tuple->src.u.udp.port = hp->source;
 	tuple->dst.u.udp.port = hp->dest;
 
-	return 1;
+	return true;
 }
 
-static int udp_invert_tuple(struct nf_conntrack_tuple *tuple,
-			    const struct nf_conntrack_tuple *orig)
+static bool udp_invert_tuple(struct nf_conntrack_tuple *tuple,
+                             const struct nf_conntrack_tuple *orig)
 {
 	tuple->src.u.udp.port = orig->dst.u.udp.port;
 	tuple->dst.u.udp.port = orig->src.u.udp.port;
-	return 1;
+	return true;
 }
 
 /* Print out the per-protocol part of the tuple. */
@@ -83,10 +82,10 @@ static int udp_packet(struct nf_conn *ct,
 }
 
 /* Called when a new connection for this protocol found. */
-static int udp_new(struct nf_conn *ct, const struct sk_buff *skb,
-		   unsigned int dataoff)
+static bool udp_new(struct nf_conn *ct, const struct sk_buff *skb,
+                    unsigned int dataoff)
 {
-	return 1;
+	return true;
 }
 
 static int udp_error(struct sk_buff *skb, unsigned int dataoff,
diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
index 2bf4cf0..afb6768 100644
--- a/net/netfilter/nf_conntrack_proto_udplite.c
+++ b/net/netfilter/nf_conntrack_proto_udplite.c
@@ -27,28 +27,28 @@
 static unsigned int nf_ct_udplite_timeout __read_mostly = 30*HZ;
 static unsigned int nf_ct_udplite_timeout_stream __read_mostly = 180*HZ;
 
-static int udplite_pkt_to_tuple(const struct sk_buff *skb,
-				unsigned int dataoff,
-				struct nf_conntrack_tuple *tuple)
+static bool
+udplite_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
+                     struct nf_conntrack_tuple *tuple)
 {
 	const struct udphdr *hp;
 	struct udphdr _hdr;
 
 	hp = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
 	if (hp == NULL)
-		return 0;
+		return false;
 
 	tuple->src.u.udp.port = hp->source;
 	tuple->dst.u.udp.port = hp->dest;
-	return 1;
+	return true;
 }
 
-static int udplite_invert_tuple(struct nf_conntrack_tuple *tuple,
-				const struct nf_conntrack_tuple *orig)
+static bool udplite_invert_tuple(struct nf_conntrack_tuple *tuple,
+                                 const struct nf_conntrack_tuple *orig)
 {
 	tuple->src.u.udp.port = orig->dst.u.udp.port;
 	tuple->dst.u.udp.port = orig->src.u.udp.port;
-	return 1;
+	return true;
 }
 
 /* Print out the per-protocol part of the tuple. */
@@ -83,10 +83,10 @@ static int udplite_packet(struct nf_conn *ct,
 }
 
 /* Called when a new connection for this protocol found. */
-static int udplite_new(struct nf_conn *ct, const struct sk_buff *skb,
-		       unsigned int dataoff)
+static bool udplite_new(struct nf_conn *ct, const struct sk_buff *skb,
+                        unsigned int dataoff)
 {
-	return 1;
+	return true;
 }
 
 static int udplite_error(struct sk_buff *skb, unsigned int dataoff,
-- 
1.5.4.4

