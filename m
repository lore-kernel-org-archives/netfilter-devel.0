From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/15]: tcp conntrack: do liberal tracking for picked up
	connections
Date: Wed,  7 Feb 2007 09:22:34 +0100 (MET)
Message-ID: <20070207082233.27478.22234.sendpatchset@localhost.localdomain>
References: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
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

[NETFILTER]: tcp conntrack: do liberal tracking for picked up connections

Do liberal tracking (only RSTs need to be in-window) for connections picked
up without seeing a SYN to deal with window scaling. Also change logging
of invalid packets not to log packets accepted by liberal tracking to avoid
spamming the logs.

Based on suggestion from James Ralston <ralston@pobox.com>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c37c212ee4396891fef4abdf856f97d024fca206
tree 4281179ae6085fc97acf0431bb9719d35598c91f
parent 75a10dc02458b33d7b14b388ca51ad2b91e81fd4
author Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 07:36:50 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 07:36:50 +0100

 include/linux/netfilter/nf_conntrack_tcp.h  |    4 ++-
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c |   40 ++++++++++-----------------
 net/netfilter/nf_conntrack_proto_tcp.c      |   40 ++++++++++-----------------
 3 files changed, 33 insertions(+), 51 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_tcp.h b/include/linux/netfilter/nf_conntrack_tcp.h
index 2f4e98b..007af4c 100644
--- a/include/linux/netfilter/nf_conntrack_tcp.h
+++ b/include/linux/netfilter/nf_conntrack_tcp.h
@@ -27,6 +27,9 @@ #define IP_CT_TCP_FLAG_SACK_PERM		0x02
 /* This sender sent FIN first */
 #define IP_CT_TCP_FLAG_CLOSE_INIT		0x04
 
+/* Be liberal in window checking */
+#define IP_CT_TCP_FLAG_BE_LIBERAL		0x08
+
 #ifdef __KERNEL__
 
 struct ip_ct_tcp_state {
@@ -34,7 +37,6 @@ struct ip_ct_tcp_state {
 	u_int32_t	td_maxend;	/* max of ack + max(win, 1) */
 	u_int32_t	td_maxwin;	/* max(win) */
 	u_int8_t	td_scale;	/* window scale factor */
-	u_int8_t	loose;		/* used when connection picked up from the middle */
 	u_int8_t	flags;		/* per direction options */
 };
 
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
index 06e4e8a..097d67a 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
@@ -50,12 +50,9 @@ static DEFINE_RWLOCK(tcp_lock);
     If it's non-zero, we mark only out of window RST segments as INVALID. */
 int ip_ct_tcp_be_liberal __read_mostly = 0;
 
-/* When connection is picked up from the middle, how many packets are required
-   to pass in each direction when we assume we are in sync - if any side uses
-   window scaling, we lost the game. 
-   If it is set to zero, we disable picking up already established 
+/* If it is set to zero, we disable picking up already established
    connections. */
-int ip_ct_tcp_loose __read_mostly = 3;
+int ip_ct_tcp_loose __read_mostly = 1;
 
 /* Max number of the retransmitted packets without receiving an (acceptable) 
    ACK from the destination. If this number is reached, a shorter timer 
@@ -694,11 +691,10 @@ static int tcp_in_window(struct ip_ct_tc
 	    	before(sack, receiver->td_end + 1),
 	    	after(ack, receiver->td_end - MAXACKWINDOW(sender)));
 	
-	if (sender->loose || receiver->loose ||
-	    (before(seq, sender->td_maxend + 1) &&
-	     after(end, sender->td_end - receiver->td_maxwin - 1) &&
-	     before(sack, receiver->td_end + 1) &&
-	     after(ack, receiver->td_end - MAXACKWINDOW(sender)))) {
+	if (before(seq, sender->td_maxend + 1) &&
+	    after(end, sender->td_end - receiver->td_maxwin - 1) &&
+	    before(sack, receiver->td_end + 1) &&
+	    after(ack, receiver->td_end - MAXACKWINDOW(sender))) {
 	    	/*
 		 * Take into account window scaling (RFC 1323).
 		 */
@@ -743,15 +739,13 @@ static int tcp_in_window(struct ip_ct_tc
 				state->retrans = 0;
 			}
 		}
-		/*
-		 * Close the window of disabled window tracking :-)
-		 */
-		if (sender->loose)
-			sender->loose--;
-		
 		res = 1;
 	} else {
-		if (LOG_INVALID(IPPROTO_TCP))
+		res = 0;
+		if (sender->flags & IP_CT_TCP_FLAG_BE_LIBERAL ||
+		    ip_ct_tcp_be_liberal)
+			res = 1;
+		if (!res && LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, NULL,
 			"ip_ct_tcp: %s ",
 			before(seq, sender->td_maxend + 1) ?
@@ -762,8 +756,6 @@ static int tcp_in_window(struct ip_ct_tc
 			: "ACK is over the upper bound (ACKed data not seen yet)"
 			: "SEQ is under the lower bound (already ACKed data retransmitted)"
 			: "SEQ is over the upper bound (over the window of the receiver)");
-
-		res = ip_ct_tcp_be_liberal;
   	}
   
 	DEBUGP("tcp_in_window: res=%i sender end=%u maxend=%u maxwin=%u "
@@ -1105,8 +1097,6 @@ #endif
 
 		tcp_options(skb, iph, th, &conntrack->proto.tcp.seen[0]);
 		conntrack->proto.tcp.seen[1].flags = 0;
-		conntrack->proto.tcp.seen[0].loose = 
-		conntrack->proto.tcp.seen[1].loose = 0;
 	} else if (ip_ct_tcp_loose == 0) {
 		/* Don't try to pick up connections. */
 		return 0;
@@ -1127,11 +1117,11 @@ #endif
 			conntrack->proto.tcp.seen[0].td_maxwin;
 		conntrack->proto.tcp.seen[0].td_scale = 0;
 
-		/* We assume SACK. Should we assume window scaling too? */
+		/* We assume SACK and liberal window checking to handle
+		 * window scaling */
 		conntrack->proto.tcp.seen[0].flags =
-		conntrack->proto.tcp.seen[1].flags = IP_CT_TCP_FLAG_SACK_PERM;
-		conntrack->proto.tcp.seen[0].loose = 
-		conntrack->proto.tcp.seen[1].loose = ip_ct_tcp_loose;
+		conntrack->proto.tcp.seen[1].flags = IP_CT_TCP_FLAG_SACK_PERM |
+						     IP_CT_TCP_FLAG_BE_LIBERAL;
 	}
     
 	conntrack->proto.tcp.seen[1].td_end = 0;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 626b001..6fccdcf 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -60,12 +60,9 @@ static DEFINE_RWLOCK(tcp_lock);
     If it's non-zero, we mark only out of window RST segments as INVALID. */
 int nf_ct_tcp_be_liberal __read_mostly = 0;
 
-/* When connection is picked up from the middle, how many packets are required
-   to pass in each direction when we assume we are in sync - if any side uses
-   window scaling, we lost the game. 
-   If it is set to zero, we disable picking up already established 
+/* If it is set to zero, we disable picking up already established
    connections. */
-int nf_ct_tcp_loose __read_mostly = 3;
+int nf_ct_tcp_loose __read_mostly = 1;
 
 /* Max number of the retransmitted packets without receiving an (acceptable) 
    ACK from the destination. If this number is reached, a shorter timer 
@@ -650,11 +647,10 @@ static int tcp_in_window(struct ip_ct_tc
 	    	before(sack, receiver->td_end + 1),
 	    	after(ack, receiver->td_end - MAXACKWINDOW(sender)));
 
-	if (sender->loose || receiver->loose ||
-	    (before(seq, sender->td_maxend + 1) &&
-	     after(end, sender->td_end - receiver->td_maxwin - 1) &&
-	     before(sack, receiver->td_end + 1) &&
-	     after(ack, receiver->td_end - MAXACKWINDOW(sender)))) {
+	if (before(seq, sender->td_maxend + 1) &&
+	    after(end, sender->td_end - receiver->td_maxwin - 1) &&
+	    before(sack, receiver->td_end + 1) &&
+	    after(ack, receiver->td_end - MAXACKWINDOW(sender))) {
 	    	/*
 		 * Take into account window scaling (RFC 1323).
 		 */
@@ -699,15 +695,13 @@ static int tcp_in_window(struct ip_ct_tc
 				state->retrans = 0;
 			}
 		}
-		/*
-		 * Close the window of disabled window tracking :-)
-		 */
-		if (sender->loose)
-			sender->loose--;
-
 		res = 1;
 	} else {
-		if (LOG_INVALID(IPPROTO_TCP))
+		res = 0;
+		if (sender->flags & IP_CT_TCP_FLAG_BE_LIBERAL ||
+		    nf_ct_tcp_be_liberal)
+			res = 1;
+		if (!res && LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
 			"nf_ct_tcp: %s ",
 			before(seq, sender->td_maxend + 1) ?
@@ -718,8 +712,6 @@ static int tcp_in_window(struct ip_ct_tc
 			: "ACK is over the upper bound (ACKed data not seen yet)"
 			: "SEQ is under the lower bound (already ACKed data retransmitted)"
 			: "SEQ is over the upper bound (over the window of the receiver)");
-
-		res = nf_ct_tcp_be_liberal;
   	}
   
 	DEBUGP("tcp_in_window: res=%i sender end=%u maxend=%u maxwin=%u "
@@ -1063,8 +1055,6 @@ #endif
 
 		tcp_options(skb, dataoff, th, &conntrack->proto.tcp.seen[0]);
 		conntrack->proto.tcp.seen[1].flags = 0;
-		conntrack->proto.tcp.seen[0].loose = 
-		conntrack->proto.tcp.seen[1].loose = 0;
 	} else if (nf_ct_tcp_loose == 0) {
 		/* Don't try to pick up connections. */
 		return 0;
@@ -1085,11 +1075,11 @@ #endif
 			conntrack->proto.tcp.seen[0].td_maxwin;
 		conntrack->proto.tcp.seen[0].td_scale = 0;
 
-		/* We assume SACK. Should we assume window scaling too? */
+		/* We assume SACK and liberal window checking to handle
+		 * window scaling */
 		conntrack->proto.tcp.seen[0].flags =
-		conntrack->proto.tcp.seen[1].flags = IP_CT_TCP_FLAG_SACK_PERM;
-		conntrack->proto.tcp.seen[0].loose = 
-		conntrack->proto.tcp.seen[1].loose = nf_ct_tcp_loose;
+		conntrack->proto.tcp.seen[1].flags = IP_CT_TCP_FLAG_SACK_PERM |
+						     IP_CT_TCP_FLAG_BE_LIBERAL;
 	}
     
 	conntrack->proto.tcp.seen[1].td_end = 0;
