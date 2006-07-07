From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/10][CONNTRACK] introduce the pickup flag to take over
	connections
Date: Fri, 07 Jul 2006 04:16:53 +0200
Message-ID: <44ADC415.5030407@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010008060208030806030004"
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
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
--------------010008060208030806030004
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch introduces a new flag called IPS_PICKUP that forces the
protocol handler to pick up the required information in order to ensure
that the connection will reach a successful state. Currently, the only
client is the TCP protocol helper.

More arguments conntrackd or whatever failover solution need this.

@Jozsef: You know better TCP sequence tracking in-deep details, can you
see any problem with this?

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris


--------------010008060208030806030004
Content-Type: text/plain;
 name="10pickup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="10pickup.patch"

[CONNTRACK] Introduce the pickup flag to take over connections

This patch introduces a new flag called IPS_PICKUP that forces the protocol
handler to pick up the required information in order to ensure that the
connection will reach a successful state. Currently, the only client is the
TCP protocol helper.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
===================================================================
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2006-07-07 02:03:40.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2006-07-07 02:05:06.000000000 +0200
@@ -425,10 +425,10 @@ static unsigned int get_conntrack_index(
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
@@ -890,6 +890,28 @@ static int tcp_error(struct sk_buff *skb
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
+	conntrack->proto.tcp.seen[0].flags =
+	conntrack->proto.tcp.seen[1].flags = IP_CT_TCP_FLAG_SACK_PERM;
+	conntrack->proto.tcp.seen[0].loose = 
+	conntrack->proto.tcp.seen[1].loose = ip_ct_tcp_loose;
+}
+
 /* Returns verdict for packet, or -1 for invalid. */
 static int tcp_packet(struct ip_conntrack *conntrack,
 		      const struct sk_buff *skb,
@@ -907,6 +929,14 @@ static int tcp_packet(struct ip_conntrac
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
@@ -1116,22 +1146,7 @@ static int tcp_new(struct ip_conntrack *
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
--- net-2.6.orig/include/linux/netfilter/nf_conntrack_common.h	2006-07-07 02:03:40.000000000 +0200
+++ net-2.6/include/linux/netfilter/nf_conntrack_common.h	2006-07-07 02:05:06.000000000 +0200
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
--- net-2.6.orig/net/netfilter/nf_conntrack_proto_tcp.c	2006-07-07 02:04:39.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_proto_tcp.c	2006-07-07 02:08:15.000000000 +0200
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
+	conntrack->proto.tcp.seen[0].flags =
+	conntrack->proto.tcp.seen[1].flags = IP_CT_TCP_FLAG_SACK_PERM;
+	conntrack->proto.tcp.seen[0].loose = 
+	conntrack->proto.tcp.seen[1].loose = nf_ct_tcp_loose;
+}
+
 /* Returns verdict for packet, or -1 for invalid. */
 static int tcp_packet(struct nf_conn *conntrack,
 		      const struct sk_buff *skb,
@@ -860,6 +882,7 @@ static int tcp_packet(struct nf_conn *co
 {
 	enum tcp_conntrack new_state, old_state;
 	enum ip_conntrack_dir dir;
+	struct iphdr *iph = skb->nh.iph;
 	struct tcphdr *th, _tcph;
 	unsigned long timeout;
 	unsigned int index;
@@ -868,6 +891,14 @@ static int tcp_packet(struct nf_conn *co
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
@@ -1031,6 +1062,7 @@ static int tcp_new(struct nf_conn *connt
 		   unsigned int dataoff)
 {
 	enum tcp_conntrack new_state;
+	struct iphdr *iph = skb->nh.iph;
 	struct tcphdr *th, _tcph;
 #ifdef DEBUGP_VARS
 	struct ip_ct_tcp_state *sender = &conntrack->proto.tcp.seen[0];
@@ -1075,22 +1107,7 @@ static int tcp_new(struct nf_conn *connt
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
+		tcp_pickup_connection(conntrack, skb, iph, th);
 	}
     
 	conntrack->proto.tcp.seen[1].td_end = 0;

--------------010008060208030806030004--
