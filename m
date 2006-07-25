From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/8][CONNTRACK] Introduce the pickup facilities to take over
 TCP connections
Date: Tue, 25 Jul 2006 15:25:46 +0200
Message-ID: <44C61BDA.7050505@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020905070907060101090804"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020905070907060101090804
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch introduces a new flag called IPS_PICKUP that forces the 
protocol handler to pick up the required information in order to ensure 
that the connection will reach a successful state.

Two new ctnetlink attributes are also introduced to inject the window 
scale factor since TCP window tracking could need it to take over the 
connection properly.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------020905070907060101090804
Content-Type: text/plain;
 name="05pickup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05pickup.patch"

[CONNTRACK] Introduce the pickup facilities to take over TCP connections

This patch introduces a new flag called IPS_PICKUP that forces the protocol
handler to pick up the required information in order to ensure that the
connection will reach a successful state.

Two new ctnetlink attributes are also introduced to inject the window scale
factor since TCP window tracking could need it to take over the connection
properly.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
===================================================================
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2006-07-14 17:01:02.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2006-07-14 17:46:59.000000000 +0200
@@ -346,6 +346,12 @@ static int tcp_to_nfattr(struct sk_buff 
 	nest_parms = NFA_NEST(skb, CTA_PROTOINFO_TCP);
 	NFA_PUT(skb, CTA_PROTOINFO_TCP_STATE, sizeof(u_int8_t),
 		&ct->proto.tcp.state);
+	/* window scale factor: original direction (SYN) */
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_WSCALE_ORIGINAL, sizeof(u_int8_t),
+		&ct->proto.tcp.seen[0].td_scale);
+	/* window scale factor: reply direction (SYN+ACK) */
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_WSCALE_REPLY, sizeof(u_int8_t),
+		&ct->proto.tcp.seen[1].td_scale);
 	read_unlock_bh(&tcp_lock);
 
 	NFA_NEST_END(skb, nest_parms);
@@ -358,7 +364,9 @@ nfattr_failure:
 }
 
 static const size_t cta_min_tcp[CTA_PROTOINFO_TCP_MAX] = {
-	[CTA_PROTOINFO_TCP_STATE-1]	= sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_STATE-1]		= sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1]	= sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]	= sizeof(u_int8_t),
 };
 
 static int nfattr_to_tcp(struct nfattr *cda[], struct ip_conntrack *ct)
@@ -382,6 +390,24 @@ static int nfattr_to_tcp(struct nfattr *
 	write_lock_bh(&tcp_lock);
 	ct->proto.tcp.state = 
 		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_STATE-1]);
+	/* window scale factor: original direction (SYN) */
+	if (tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1])
+		ct->proto.tcp.seen[0].td_scale = 
+		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1]);
+	/* window scale factor: reply direction (SYN+ACK) */
+	if (tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1])
+		ct->proto.tcp.seen[1].td_scale = 
+		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]);
+	/* set WINDOW_SCALE flag */
+	if (tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1] ||
+	    tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]) {
+		/*
+		 * we have to assume that both sides have
+		 * sent Window Scale options (RFC 1323)
+		 */
+		ct->proto.tcp.seen[0].flags |=
+		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_WINDOW_SCALE;
+	}
 	write_unlock_bh(&tcp_lock);
 
 	return 0;
@@ -425,10 +451,10 @@ static unsigned int get_conntrack_index(
    we doesn't have to deal with fragments. 
 */
 
-static inline __u32 segment_seq_plus_len(__u32 seq,
-					 size_t len,
-					 struct iphdr *iph,
-					 struct tcphdr *tcph)
+static inline __u32 segment_seq_plus_len(const __u32 seq,
+					 const size_t len,
+					 const struct iphdr *iph,
+					 const struct tcphdr *tcph)
 {
 	return (seq + len - (iph->ihl + tcph->doff)*4
 		+ (tcph->syn ? 1 : 0) + (tcph->fin ? 1 : 0));
@@ -890,6 +916,28 @@ static int tcp_error(struct sk_buff *skb
 	return NF_ACCEPT;
 }
 
+static void tcp_pickup_connection(struct ip_conntrack *conntrack,
+				  const struct sk_buff *skb,
+				  const struct iphdr *iph,
+				  const struct tcphdr *th)
+{
+	conntrack->proto.tcp.seen[0].td_end =
+		segment_seq_plus_len(ntohl(th->seq), skb->len, iph, th);
+	conntrack->proto.tcp.seen[0].td_maxwin = ntohs(th->window);
+	if (conntrack->proto.tcp.seen[0].td_maxwin == 0)
+		conntrack->proto.tcp.seen[0].td_maxwin = 1;
+	conntrack->proto.tcp.seen[0].td_maxend =
+		conntrack->proto.tcp.seen[0].td_end + 
+		conntrack->proto.tcp.seen[0].td_maxwin;
+		conntrack->proto.tcp.seen[0].td_scale = 0;
+
+	/* We assume SACK. Should we assume window scaling too? */
+	conntrack->proto.tcp.seen[0].flags |=
+	conntrack->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_SACK_PERM;
+	conntrack->proto.tcp.seen[0].loose = 
+	conntrack->proto.tcp.seen[1].loose = ip_ct_tcp_loose;
+}
+
 /* Returns verdict for packet, or -1 for invalid. */
 static int tcp_packet(struct ip_conntrack *conntrack,
 		      const struct sk_buff *skb,
@@ -907,6 +955,14 @@ static int tcp_packet(struct ip_conntrac
 	BUG_ON(th == NULL);
 	
 	write_lock_bh(&tcp_lock);
+
+	/*
+	 * This conntrack was added via ctnetlink or ct_sync and needs to
+	 * take over sequence tracking in order to work properly.
+	 */
+	if (test_and_clear_bit(IPS_PICKUP, &conntrack->status))
+		tcp_pickup_connection(conntrack, skb, iph, th);
+
 	old_state = conntrack->proto.tcp.state;
 	dir = CTINFO2DIR(ctinfo);
 	index = get_conntrack_index(th);
@@ -1116,22 +1172,7 @@ static int tcp_new(struct ip_conntrack *
 		 * its history is lost for us.
 		 * Let's try to use the data from the packet.
 		 */
-		conntrack->proto.tcp.seen[0].td_end =
-			segment_seq_plus_len(ntohl(th->seq), skb->len,
-					     iph, th);
-		conntrack->proto.tcp.seen[0].td_maxwin = ntohs(th->window);
-		if (conntrack->proto.tcp.seen[0].td_maxwin == 0)
-			conntrack->proto.tcp.seen[0].td_maxwin = 1;
-		conntrack->proto.tcp.seen[0].td_maxend =
-			conntrack->proto.tcp.seen[0].td_end + 
-			conntrack->proto.tcp.seen[0].td_maxwin;
-		conntrack->proto.tcp.seen[0].td_scale = 0;
-
-		/* We assume SACK. Should we assume window scaling too? */
-		conntrack->proto.tcp.seen[0].flags =
-		conntrack->proto.tcp.seen[1].flags = IP_CT_TCP_FLAG_SACK_PERM;
-		conntrack->proto.tcp.seen[0].loose = 
-		conntrack->proto.tcp.seen[1].loose = ip_ct_tcp_loose;
+		tcp_pickup_connection(conntrack, skb, iph, th);
 	}
     
 	conntrack->proto.tcp.seen[1].td_end = 0;
Index: net-2.6/include/linux/netfilter/nf_conntrack_common.h
===================================================================
--- net-2.6.orig/include/linux/netfilter/nf_conntrack_common.h	2006-07-14 17:01:02.000000000 +0200
+++ net-2.6/include/linux/netfilter/nf_conntrack_common.h	2006-07-14 17:02:02.000000000 +0200
@@ -73,6 +73,10 @@ enum ip_conntrack_status {
 	/* Connection has fixed timeout. */
 	IPS_FIXED_TIMEOUT_BIT = 10,
 	IPS_FIXED_TIMEOUT = (1 << IPS_FIXED_TIMEOUT_BIT),
+
+	/* Pick up connection information if required */
+	IPS_PICKUP_BIT = 11,
+	IPS_PICKUP = (1 << IPS_PICKUP_BIT),
 };
 
 /* Connection tracking event bits */
Index: net-2.6/net/netfilter/nf_conntrack_proto_tcp.c
===================================================================
--- net-2.6.orig/net/netfilter/nf_conntrack_proto_tcp.c	2006-07-14 17:01:02.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_proto_tcp.c	2006-07-14 18:02:45.000000000 +0200
@@ -381,10 +381,10 @@ static unsigned int get_conntrack_index(
    we doesn't have to deal with fragments. 
 */
 
-static inline __u32 segment_seq_plus_len(__u32 seq,
-					 size_t len,
-					 unsigned int dataoff,
-					 struct tcphdr *tcph)
+static inline __u32 segment_seq_plus_len(const __u32 seq,
+					 const size_t len,
+					 const unsigned int dataoff,
+					 const struct tcphdr *tcph)
 {
 	/* XXX Should I use payload length field in IP/IPv6 header ?
 	 * - YK */
@@ -850,6 +850,28 @@ static int tcp_error(struct sk_buff *skb
 	return NF_ACCEPT;
 }
 
+static void tcp_pickup_connection(struct nf_conn *conntrack,
+				  const struct sk_buff *skb,
+				  const unsigned int dataoff,
+				  const struct tcphdr *th)
+{
+	conntrack->proto.tcp.seen[0].td_end =
+		segment_seq_plus_len(ntohl(th->seq), skb->len, dataoff, th);
+	conntrack->proto.tcp.seen[0].td_maxwin = ntohs(th->window);
+	if (conntrack->proto.tcp.seen[0].td_maxwin == 0)
+		conntrack->proto.tcp.seen[0].td_maxwin = 1;
+	conntrack->proto.tcp.seen[0].td_maxend =
+		conntrack->proto.tcp.seen[0].td_end + 
+		conntrack->proto.tcp.seen[0].td_maxwin;
+		conntrack->proto.tcp.seen[0].td_scale = 0;
+
+	/* We assume SACK. Should we assume window scaling too? */
+	conntrack->proto.tcp.seen[0].flags |=
+	conntrack->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_SACK_PERM;
+	conntrack->proto.tcp.seen[0].loose = 
+	conntrack->proto.tcp.seen[1].loose = nf_ct_tcp_loose;
+}
+
 /* Returns verdict for packet, or -1 for invalid. */
 static int tcp_packet(struct nf_conn *conntrack,
 		      const struct sk_buff *skb,
@@ -868,6 +890,14 @@ static int tcp_packet(struct nf_conn *co
 	BUG_ON(th == NULL);
 
 	write_lock_bh(&tcp_lock);
+
+	/*
+	 * This conntrack was added via ctnetlink or ct_sync and needs to
+	 * take over sequence tracking in order to work properly.
+	 */
+	if (test_and_clear_bit(IPS_PICKUP, &conntrack->status))
+		tcp_pickup_connection(conntrack, skb, dataoff, th);
+
 	old_state = conntrack->proto.tcp.state;
 	dir = CTINFO2DIR(ctinfo);
 	index = get_conntrack_index(th);
@@ -1075,22 +1105,7 @@ static int tcp_new(struct nf_conn *connt
 		 * its history is lost for us.
 		 * Let's try to use the data from the packet.
 		 */
-		conntrack->proto.tcp.seen[0].td_end =
-			segment_seq_plus_len(ntohl(th->seq), skb->len,
-					     dataoff, th);
-		conntrack->proto.tcp.seen[0].td_maxwin = ntohs(th->window);
-		if (conntrack->proto.tcp.seen[0].td_maxwin == 0)
-			conntrack->proto.tcp.seen[0].td_maxwin = 1;
-		conntrack->proto.tcp.seen[0].td_maxend =
-			conntrack->proto.tcp.seen[0].td_end + 
-			conntrack->proto.tcp.seen[0].td_maxwin;
-		conntrack->proto.tcp.seen[0].td_scale = 0;
-
-		/* We assume SACK. Should we assume window scaling too? */
-		conntrack->proto.tcp.seen[0].flags =
-		conntrack->proto.tcp.seen[1].flags = IP_CT_TCP_FLAG_SACK_PERM;
-		conntrack->proto.tcp.seen[0].loose = 
-		conntrack->proto.tcp.seen[1].loose = nf_ct_tcp_loose;
+		tcp_pickup_connection(conntrack, skb, dataoff, th);
 	}
     
 	conntrack->proto.tcp.seen[1].td_end = 0;
@@ -1126,6 +1141,12 @@ static int tcp_to_nfattr(struct sk_buff 
 	nest_parms = NFA_NEST(skb, CTA_PROTOINFO_TCP);
 	NFA_PUT(skb, CTA_PROTOINFO_TCP_STATE, sizeof(u_int8_t),
 		&ct->proto.tcp.state);
+	/* window scale factor: original direction (SYN) */
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_WSCALE_ORIGINAL, sizeof(u_int8_t),
+		&ct->proto.tcp.seen[0].td_scale);
+	/* window scale factor: reply direction (SYN+ACK) */
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_WSCALE_REPLY, sizeof(u_int8_t),
+		&ct->proto.tcp.seen[1].td_scale);
 	read_unlock_bh(&tcp_lock);
 
 	NFA_NEST_END(skb, nest_parms);
@@ -1138,7 +1159,9 @@ nfattr_failure:
 }
 
 static const size_t cta_min_tcp[CTA_PROTOINFO_TCP_MAX] = {
-	[CTA_PROTOINFO_TCP_STATE-1]	= sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_STATE-1]		= sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1] 	= sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]	= sizeof(u_int8_t),
 };
 
 static int nfattr_to_tcp(struct nfattr *cda[], struct nf_conn *ct)
@@ -1162,6 +1185,24 @@ static int nfattr_to_tcp(struct nfattr *
 	write_lock_bh(&tcp_lock);
 	ct->proto.tcp.state = 
 		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_STATE-1]);
+	/* window scale factor: original direction (SYN) */
+	if (tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1])
+		ct->proto.tcp.seen[0].td_scale = 
+		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1]);
+	/* window scale factor: reply direction (SYN+ACK) */
+	if (tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1])
+		ct->proto.tcp.seen[1].td_scale = 
+		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]);
+	/* set WINDOW_SCALE flag */
+	if (tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1] ||
+	    tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]) {
+		/*
+		 * we have to assume that both sides have
+		 * sent Window Scale options (RFC 1323)
+		 */
+		ct->proto.tcp.seen[0].flags |=
+		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_WINDOW_SCALE;
+	}
 	write_unlock_bh(&tcp_lock);
 
 	return 0;
Index: net-2.6/include/linux/netfilter/nfnetlink_conntrack.h
===================================================================
--- net-2.6.orig/include/linux/netfilter/nfnetlink_conntrack.h	2006-07-14 17:01:02.000000000 +0200
+++ net-2.6/include/linux/netfilter/nfnetlink_conntrack.h	2006-07-14 17:16:17.000000000 +0200
@@ -83,6 +83,8 @@ enum ctattr_protoinfo {
 enum ctattr_protoinfo_tcp {
 	CTA_PROTOINFO_TCP_UNSPEC,
 	CTA_PROTOINFO_TCP_STATE,
+	CTA_PROTOINFO_TCP_WSCALE_ORIGINAL,
+	CTA_PROTOINFO_TCP_WSCALE_REPLY,
 	__CTA_PROTOINFO_TCP_MAX
 };
 #define CTA_PROTOINFO_TCP_MAX (__CTA_PROTOINFO_TCP_MAX - 1)

--------------020905070907060101090804--
