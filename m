From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3][CONNTRACK] Introduce flag facilities to take over TCP
 connections
Date: Tue, 28 Nov 2006 18:09:16 +0100
Message-ID: <456C6D3C.9060909@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090406060008000405010006"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------090406060008000405010006
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Patrick,

I reworked the previous patch based on some of your suggestions. Let me
know what you think.

Description:

This patch introduces two new flags called IPS_PICKUP that forces the
protocol handler to pick up the window of valid TCP packets and
IPS_IN_WINDOW to by pass window checkings.

Moreover, four new attributes to inject the window scale factor and
internal TCP flags handling. These new facilities provide the appropiate
mechanisms to take over TCP connections in failover settings with TCP
tracking enabled.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------090406060008000405010006
Content-Type: text/plain;
 name="01pickup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01pickup.patch"

[CONNTRACK] Introduce flag facilities to take over TCP connections

This patch introduces two new flags called IPS_PICKUP that forces the protocol
handler to pick up the window of valid TCP packets and IPS_IN_WINDOW to by 
pass window checkings.

Moreover, four new attributes to inject the window scale factor and
internal TCP flags handling. These new facilities provide the appropiate
mechanisms to take over TCP connections in failover settings with TCP
tracking enabled.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: linux-2.6.git/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
===================================================================
--- linux-2.6.git.orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2006-11-28 01:09:26.000000000 +0100
+++ linux-2.6.git/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2006-11-28 03:06:05.000000000 +0100
@@ -345,8 +345,25 @@ static int tcp_to_nfattr(struct sk_buff 
 	nest_parms = NFA_NEST(skb, CTA_PROTOINFO_TCP);
 	NFA_PUT(skb, CTA_PROTOINFO_TCP_STATE, sizeof(u_int8_t),
 		&ct->proto.tcp.state);
-	read_unlock_bh(&tcp_lock);
 
+	/* skip window scale and flags dump if hard tracking is by passed */
+	if (test_bit(IPS_IN_WINDOW, &ct->status))
+		goto out;
+
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_WSCALE_ORIGINAL, sizeof(u_int8_t),
+		&ct->proto.tcp.seen[0].td_scale);
+
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_WSCALE_REPLY, sizeof(u_int8_t),
+		&ct->proto.tcp.seen[1].td_scale);
+
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_FLAGS_ORIGINAL, sizeof(u_int8_t),
+		&ct->proto.tcp.seen[0].flags);
+	
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_FLAGS_REPLY, sizeof(u_int8_t),
+		&ct->proto.tcp.seen[1].flags);
+
+out:
+	read_unlock_bh(&tcp_lock);
 	NFA_NEST_END(skb, nest_parms);
 
 	return 0;
@@ -357,7 +374,11 @@ nfattr_failure:
 }
 
 static const size_t cta_min_tcp[CTA_PROTOINFO_TCP_MAX] = {
-	[CTA_PROTOINFO_TCP_STATE-1]	= sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_STATE-1]	      = sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1] = sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]    = sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL-1]  = sizeof(struct nf_ct_tcp_flags),
+	[CTA_PROTOINFO_TCP_FLAGS_REPLY-1]     = sizeof(struct nf_ct_tcp_flags)
 };
 
 static int nfattr_to_tcp(struct nfattr *cda[], struct ip_conntrack *ct)
@@ -381,6 +402,30 @@ static int nfattr_to_tcp(struct nfattr *
 	write_lock_bh(&tcp_lock);
 	ct->proto.tcp.state = 
 		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_STATE-1]);
+
+	if (tb[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL-1]) {
+		struct nf_ct_tcp_flags *attr =
+			NFA_DATA(tb[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL-1]);
+		ct->proto.tcp.seen[0].flags &= ~attr->mask;
+		ct->proto.tcp.seen[0].flags |= attr->flags & attr->mask;
+	}
+
+	if (tb[CTA_PROTOINFO_TCP_FLAGS_REPLY-1]) {
+		struct nf_ct_tcp_flags *attr =
+			NFA_DATA(tb[CTA_PROTOINFO_TCP_FLAGS_REPLY-1]);
+		ct->proto.tcp.seen[1].flags &= ~attr->mask;
+		ct->proto.tcp.seen[1].flags |= attr->flags & attr->mask;
+	}
+
+	if (tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1] &&
+	    tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1] &&
+	    ct->proto.tcp.seen[0].flags & IP_CT_TCP_FLAG_WINDOW_SCALE &&
+	    ct->proto.tcp.seen[1].flags & IP_CT_TCP_FLAG_WINDOW_SCALE) {
+		ct->proto.tcp.seen[0].td_scale = *(u_int8_t *)
+			NFA_DATA(tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1]);
+		ct->proto.tcp.seen[1].td_scale = *(u_int8_t *)
+			NFA_DATA(tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]);
+	}
 	write_unlock_bh(&tcp_lock);
 
 	return 0;
@@ -424,10 +469,10 @@ static unsigned int get_conntrack_index(
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
@@ -890,6 +935,22 @@ static int tcp_error(struct sk_buff *skb
 	return NF_ACCEPT;
 }
 
+static inline void tcp_pickup_window(struct ip_conntrack *conntrack,
+				     const struct sk_buff *skb,
+				     const struct iphdr *iph,
+				     const struct tcphdr *th)
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
+}
+
 /* Returns verdict for packet, or -1 for invalid. */
 static int tcp_packet(struct ip_conntrack *conntrack,
 		      const struct sk_buff *skb,
@@ -912,6 +973,12 @@ static int tcp_packet(struct ip_conntrac
 	index = get_conntrack_index(th);
 	new_state = tcp_conntracks[dir][index][old_state];
 
+	/* pick up or by-pass window tracking */
+	if (test_bit(IPS_IN_WINDOW, &conntrack->status))
+		goto in_window;
+	else if (test_and_clear_bit(IPS_PICKUP, &conntrack->status))
+		tcp_pickup_window(conntrack, skb, iph, th);
+
 	switch (new_state) {
 	case TCP_CONNTRACK_IGNORE:
 		/* Ignored packets:
@@ -1116,16 +1183,7 @@ static int tcp_new(struct ip_conntrack *
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
+		tcp_pickup_window(conntrack, skb, iph, th);
 
 		/* We assume SACK. Should we assume window scaling too? */
 		conntrack->proto.tcp.seen[0].flags =
Index: linux-2.6.git/include/linux/netfilter/nf_conntrack_common.h
===================================================================
--- linux-2.6.git.orig/include/linux/netfilter/nf_conntrack_common.h	2006-11-28 01:09:26.000000000 +0100
+++ linux-2.6.git/include/linux/netfilter/nf_conntrack_common.h	2006-11-28 01:10:57.000000000 +0100
@@ -73,6 +73,14 @@ enum ip_conntrack_status {
 	/* Connection has fixed timeout. */
 	IPS_FIXED_TIMEOUT_BIT = 10,
 	IPS_FIXED_TIMEOUT = (1 << IPS_FIXED_TIMEOUT_BIT),
+
+	/* Pick up connection information. */
+	IPS_PICKUP_BIT = 11,
+	IPS_PICKUP = (1 << IPS_PICKUP_BIT),
+
+	/* Ignore in-window checkings. */
+	IPS_IN_WINDOW_BIT = 12,
+	IPS_IN_WINDOW = (1 << IPS_IN_WINDOW_BIT),
 };
 
 /* Connection tracking event bits */
Index: linux-2.6.git/net/netfilter/nf_conntrack_proto_tcp.c
===================================================================
--- linux-2.6.git.orig/net/netfilter/nf_conntrack_proto_tcp.c	2006-11-28 01:09:26.000000000 +0100
+++ linux-2.6.git/net/netfilter/nf_conntrack_proto_tcp.c	2006-11-28 03:05:35.000000000 +0100
@@ -380,10 +380,10 @@ static unsigned int get_conntrack_index(
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
@@ -850,6 +850,22 @@ static int tcp_error(struct sk_buff *skb
 	return NF_ACCEPT;
 }
 
+static inline void tcp_pickup_window(struct nf_conn *conntrack,
+				     const struct sk_buff *skb,
+				     const unsigned int dataoff,
+				     const struct tcphdr *th)
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
+}
+
 /* Returns verdict for packet, or -1 for invalid. */
 static int tcp_packet(struct nf_conn *conntrack,
 		      const struct sk_buff *skb,
@@ -873,6 +889,12 @@ static int tcp_packet(struct nf_conn *co
 	index = get_conntrack_index(th);
 	new_state = tcp_conntracks[dir][index][old_state];
 
+	/* pick up or by-pass window tracking */
+	if (test_bit(IPS_IN_WINDOW, &conntrack->status))
+		goto in_window;
+	else if (test_and_clear_bit(IPS_PICKUP, &conntrack->status))
+		tcp_pickup_window(conntrack, skb, dataoff, th);
+
 	switch (new_state) {
 	case TCP_CONNTRACK_IGNORE:
 		/* Ignored packets:
@@ -1075,16 +1097,7 @@ static int tcp_new(struct nf_conn *connt
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
+		tcp_pickup_window(conntrack, skb, dataoff, th);
 
 		/* We assume SACK. Should we assume window scaling too? */
 		conntrack->proto.tcp.seen[0].flags =
@@ -1126,8 +1139,25 @@ static int tcp_to_nfattr(struct sk_buff 
 	nest_parms = NFA_NEST(skb, CTA_PROTOINFO_TCP);
 	NFA_PUT(skb, CTA_PROTOINFO_TCP_STATE, sizeof(u_int8_t),
 		&ct->proto.tcp.state);
-	read_unlock_bh(&tcp_lock);
 
+	/* do not dump sack information if in-window checkings are by-passed */
+	if (test_bit(IPS_IN_WINDOW, &ct->status))
+		goto out;
+
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_WSCALE_ORIGINAL, sizeof(u_int8_t),
+		&ct->proto.tcp.seen[0].td_scale);
+	
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_WSCALE_REPLY, sizeof(u_int8_t),
+		&ct->proto.tcp.seen[1].td_scale);
+
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_FLAGS_ORIGINAL, sizeof(u_int8_t),
+		&ct->proto.tcp.seen[0].flags);
+	
+	NFA_PUT(skb, CTA_PROTOINFO_TCP_FLAGS_REPLY, sizeof(u_int8_t),
+		&ct->proto.tcp.seen[1].flags);
+
+out:
+	read_unlock_bh(&tcp_lock);
 	NFA_NEST_END(skb, nest_parms);
 
 	return 0;
@@ -1138,7 +1168,11 @@ nfattr_failure:
 }
 
 static const size_t cta_min_tcp[CTA_PROTOINFO_TCP_MAX] = {
-	[CTA_PROTOINFO_TCP_STATE-1]	= sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_STATE-1]	      = sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1] = sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]    = sizeof(u_int8_t),
+	[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL-1]  = sizeof(struct nf_ct_tcp_flags),
+	[CTA_PROTOINFO_TCP_FLAGS_REPLY-1]     = sizeof(struct nf_ct_tcp_flags)
 };
 
 static int nfattr_to_tcp(struct nfattr *cda[], struct nf_conn *ct)
@@ -1162,6 +1196,30 @@ static int nfattr_to_tcp(struct nfattr *
 	write_lock_bh(&tcp_lock);
 	ct->proto.tcp.state = 
 		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_STATE-1]);
+
+	if (tb[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL-1]) {
+		struct nf_ct_tcp_flags *attr =
+			NFA_DATA(tb[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL-1]);
+		ct->proto.tcp.seen[0].flags &= ~attr->mask;
+		ct->proto.tcp.seen[0].flags |= attr->flags & attr->mask;
+	}
+
+	if (tb[CTA_PROTOINFO_TCP_FLAGS_REPLY-1]) {
+		struct nf_ct_tcp_flags *attr =
+			NFA_DATA(tb[CTA_PROTOINFO_TCP_FLAGS_REPLY-1]);
+		ct->proto.tcp.seen[1].flags &= ~attr->mask;
+		ct->proto.tcp.seen[1].flags |= attr->flags & attr->mask;
+	}
+
+	if (tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1] &&
+	    tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1] &&
+	    ct->proto.tcp.seen[0].flags & IP_CT_TCP_FLAG_WINDOW_SCALE &&
+	    ct->proto.tcp.seen[1].flags & IP_CT_TCP_FLAG_WINDOW_SCALE) {
+		ct->proto.tcp.seen[0].td_scale = *(u_int8_t *)
+			NFA_DATA(tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1]);
+		ct->proto.tcp.seen[1].td_scale = *(u_int8_t *)
+			NFA_DATA(tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]);
+	}
 	write_unlock_bh(&tcp_lock);
 
 	return 0;
Index: linux-2.6.git/include/linux/netfilter/nfnetlink_conntrack.h
===================================================================
--- linux-2.6.git.orig/include/linux/netfilter/nfnetlink_conntrack.h	2006-11-28 01:09:26.000000000 +0100
+++ linux-2.6.git/include/linux/netfilter/nfnetlink_conntrack.h	2006-11-28 02:10:46.000000000 +0100
@@ -83,6 +83,10 @@ enum ctattr_protoinfo {
 enum ctattr_protoinfo_tcp {
 	CTA_PROTOINFO_TCP_UNSPEC,
 	CTA_PROTOINFO_TCP_STATE,
+	CTA_PROTOINFO_TCP_WSCALE_ORIGINAL,
+	CTA_PROTOINFO_TCP_WSCALE_REPLY,
+	CTA_PROTOINFO_TCP_FLAGS_ORIGINAL,
+	CTA_PROTOINFO_TCP_FLAGS_REPLY,
 	__CTA_PROTOINFO_TCP_MAX
 };
 #define CTA_PROTOINFO_TCP_MAX (__CTA_PROTOINFO_TCP_MAX - 1)
Index: linux-2.6.git/include/linux/netfilter/nf_conntrack_tcp.h
===================================================================
--- linux-2.6.git.orig/include/linux/netfilter/nf_conntrack_tcp.h	2006-11-28 01:57:31.000000000 +0100
+++ linux-2.6.git/include/linux/netfilter/nf_conntrack_tcp.h	2006-11-28 02:47:20.000000000 +0100
@@ -27,6 +27,11 @@ enum tcp_conntrack {
 /* This sender sent FIN first */
 #define IP_CT_TCP_FLAG_CLOSE_INIT		0x03
 
+struct nf_ct_tcp_flags {
+	u_int8_t flags;
+	u_int8_t mask;
+};
+
 #ifdef __KERNEL__
 
 struct ip_ct_tcp_state {

--------------090406060008000405010006--
