From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 4/9]: unifies the definitions in tcp.
Date: Tue, 22 Mar 2005 22:51:30 +0900 (JST)
Message-ID: <200503221351.j2MDpUAB018388@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Tue_Mar_22_22:51:30_2005_146)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
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

----Next_Part(Tue_Mar_22_22:51:30_2005_146)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch unifies the definitions in {ip,nf}_conntrack_tcp.h

Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Tue_Mar_22_22:51:30_2005_146)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="04-defs-tcp.patch"

diff -Nur linux-2.6.11-nfct-defs-ftp/include/linux/netfilter/nf_conntrack.h linux-2.6.11-nfct-defs-tcp/include/linux/netfilter/nf_conntrack.h
--- linux-2.6.11-nfct-defs-ftp/include/linux/netfilter/nf_conntrack.h	2005-03-22 16:48:32.000000000 +0900
+++ linux-2.6.11-nfct-defs-tcp/include/linux/netfilter/nf_conntrack.h	2005-03-22 17:07:24.000000000 +0900
@@ -30,7 +30,7 @@
 union nf_conntrack_proto {
 	/* insert conntrack proto private data here */
 	struct nf_ct_sctp sctp;
-	struct nf_ct_tcp tcp;
+	struct ip_ct_tcp tcp;
 	struct nf_ct_icmp icmp;
 	struct nf_ct_icmpv6 icmpv6;
 };
@@ -190,6 +190,12 @@
 			       unsigned long extra_jiffies);
 
 /* These are for NAT.  Icky. */
+/* Update TCP window tracking data when NAT mangles the packet */
+extern void nf_conntrack_tcp_update(struct sk_buff *skb,
+				    unsigned int dataoff,
+				    struct nf_conn *conntrack,
+				    int dir);
+
 /* Call me when a conntrack is destroyed. */
 extern void (*nf_conntrack_destroyed)(struct nf_conn *conntrack);
 
diff -Nur linux-2.6.11-nfct-defs-ftp/include/linux/netfilter/nf_conntrack_tcp.h linux-2.6.11-nfct-defs-tcp/include/linux/netfilter/nf_conntrack_tcp.h
--- linux-2.6.11-nfct-defs-ftp/include/linux/netfilter/nf_conntrack_tcp.h	2005-03-22 16:46:35.000000000 +0900
+++ linux-2.6.11-nfct-defs-tcp/include/linux/netfilter/nf_conntrack_tcp.h	2005-03-22 16:59:20.000000000 +0900
@@ -1,11 +1,6 @@
-/*
- * TCP tracking.
- *
- * Derived from include/linux/netfiter_ipv4/ip_conntrack_tcp.h
- */
-
 #ifndef _NF_CONNTRACK_TCP_H
 #define _NF_CONNTRACK_TCP_H
+/* TCP tracking. */
 
 enum tcp_conntrack {
 	TCP_CONNTRACK_NONE,
@@ -23,26 +18,29 @@
 };
 
 /* Window scaling is advertised by the sender */
-#define NF_CT_TCP_FLAG_WINDOW_SCALE		0x01
+#define IP_CT_TCP_FLAG_WINDOW_SCALE		0x01
 
 /* SACK is permitted by the sender */
-#define NF_CT_TCP_FLAG_SACK_PERM		0x02
+#define IP_CT_TCP_FLAG_SACK_PERM		0x02
+
+/* This sender sent FIN first */
+#define IP_CT_TCP_FLAG_CLOSE_INIT		0x03
 
-struct nf_ct_tcp_state {
+struct ip_ct_tcp_state {
 	u_int32_t	td_end;		/* max of seq + len */
 	u_int32_t	td_maxend;	/* max of ack + max(win, 1) */
 	u_int32_t	td_maxwin;	/* max(win) */
 	u_int8_t	td_scale;	/* window scale factor */
 	u_int8_t	loose;		/* used when connection picked up from the middle */
-	u_int8_t	flags;		/* per direction state flags */
+	u_int8_t	flags;		/* per direction options */
 };
 
-struct nf_ct_tcp
+struct ip_ct_tcp
 {
-	struct nf_ct_tcp_state seen[2];	/* connection parameters per direction */
+	struct ip_ct_tcp_state seen[2];	/* connection parameters per direction */
 	u_int8_t	state;		/* state of the connection (enum tcp_conntrack) */
 	/* For detecting stale connections */
-	u_int8_t	last_dir;	/* Direction of the last packet (enum nf_conntrack_dir) */
+	u_int8_t	last_dir;	/* Direction of the last packet (enum ip_conntrack_dir) */
 	u_int8_t	retrans;	/* Number of retransmitted packets */
 	u_int8_t	last_index;	/* Index of the last packet */
 	u_int32_t	last_seq;	/* Last sequence number seen in dir */
@@ -50,14 +48,4 @@
 	u_int32_t	last_end;	/* Last seq + len */
 };
 
-/* Need this, since this file is included before the nf_conn definition
- * in nf_conntrack.h */
-struct nf_conn;
-
-/* Update TCP window tracking data when NAT mangles the packet */
-extern void nf_conntrack_tcp_update(struct sk_buff *skb,
-				    unsigned int dataoff,
-				    struct nf_conn *conntrack,
-				    int dir);
-
 #endif /* _NF_CONNTRACK_TCP_H */
diff -Nur linux-2.6.11-nfct-defs-ftp/include/linux/netfilter_ipv4/ip_conntrack_tcp.h linux-2.6.11-nfct-defs-tcp/include/linux/netfilter_ipv4/ip_conntrack_tcp.h
--- linux-2.6.11-nfct-defs-ftp/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2005-03-22 16:46:35.000000000 +0900
+++ linux-2.6.11-nfct-defs-tcp/include/linux/netfilter_ipv4/ip_conntrack_tcp.h	2005-03-22 16:59:51.000000000 +0900
@@ -1,51 +1,6 @@
 #ifndef _IP_CONNTRACK_TCP_H
 #define _IP_CONNTRACK_TCP_H
-/* TCP tracking. */
 
-enum tcp_conntrack {
-	TCP_CONNTRACK_NONE,
-	TCP_CONNTRACK_SYN_SENT,
-	TCP_CONNTRACK_SYN_RECV,
-	TCP_CONNTRACK_ESTABLISHED,
-	TCP_CONNTRACK_FIN_WAIT,
-	TCP_CONNTRACK_CLOSE_WAIT,
-	TCP_CONNTRACK_LAST_ACK,
-	TCP_CONNTRACK_TIME_WAIT,
-	TCP_CONNTRACK_CLOSE,
-	TCP_CONNTRACK_LISTEN,
-	TCP_CONNTRACK_MAX,
-	TCP_CONNTRACK_IGNORE
-};
-
-/* Window scaling is advertised by the sender */
-#define IP_CT_TCP_FLAG_WINDOW_SCALE		0x01
-
-/* SACK is permitted by the sender */
-#define IP_CT_TCP_FLAG_SACK_PERM		0x02
-
-/* This sender sent FIN first */
-#define IP_CT_TCP_FLAG_CLOSE_INIT		0x03
-
-struct ip_ct_tcp_state {
-	u_int32_t	td_end;		/* max of seq + len */
-	u_int32_t	td_maxend;	/* max of ack + max(win, 1) */
-	u_int32_t	td_maxwin;	/* max(win) */
-	u_int8_t	td_scale;	/* window scale factor */
-	u_int8_t	loose;		/* used when connection picked up from the middle */
-	u_int8_t	flags;		/* per direction options */
-};
-
-struct ip_ct_tcp
-{
-	struct ip_ct_tcp_state seen[2];	/* connection parameters per direction */
-	u_int8_t	state;		/* state of the connection (enum tcp_conntrack) */
-	/* For detecting stale connections */
-	u_int8_t	last_dir;	/* Direction of the last packet (enum ip_conntrack_dir) */
-	u_int8_t	retrans;	/* Number of retransmitted packets */
-	u_int8_t	last_index;	/* Index of the last packet */
-	u_int32_t	last_seq;	/* Last sequence number seen in dir */
-	u_int32_t	last_ack;	/* Last sequence number seen in opposite dir */
-	u_int32_t	last_end;	/* Last seq + len */
-};
+#include <linux/netfilter/nf_conntrack_tcp.h>
 
 #endif /* _IP_CONNTRACK_TCP_H */
diff -Nur linux-2.6.11-nfct-defs-ftp/net/netfilter/nf_conntrack_proto_tcp.c linux-2.6.11-nfct-defs-tcp/net/netfilter/nf_conntrack_proto_tcp.c
--- linux-2.6.11-nfct-defs-ftp/net/netfilter/nf_conntrack_proto_tcp.c	2005-03-22 16:46:35.000000000 +0900
+++ linux-2.6.11-nfct-defs-tcp/net/netfilter/nf_conntrack_proto_tcp.c	2005-03-22 17:11:10.000000000 +0900
@@ -399,7 +399,7 @@
 static void tcp_options(const struct sk_buff *skb,
 			unsigned int dataoff,
 			struct tcphdr *tcph, 
-			struct nf_ct_tcp_state *state)
+			struct ip_ct_tcp_state *state)
 {
 	unsigned char buff[(15 * 4) - sizeof(struct tcphdr)];
 	unsigned char *ptr;
@@ -434,7 +434,7 @@
 
 			if (opcode == TCPOPT_SACK_PERM 
 			    && opsize == TCPOLEN_SACK_PERM)
-				state->flags |= NF_CT_TCP_FLAG_SACK_PERM;
+				state->flags |= IP_CT_TCP_FLAG_SACK_PERM;
 			else if (opcode == TCPOPT_WINDOW
 				 && opsize == TCPOLEN_WINDOW) {
 				state->td_scale = *(u_int8_t *)ptr;
@@ -444,7 +444,7 @@
 					state->td_scale = 14;
 				}
 				state->flags |=
-					NF_CT_TCP_FLAG_WINDOW_SCALE;
+					IP_CT_TCP_FLAG_WINDOW_SCALE;
 			}
 			ptr += opsize - 2;
 			length -= opsize;
@@ -513,7 +513,7 @@
 	}
 }
 
-static int tcp_in_window(struct nf_ct_tcp *state, 
+static int tcp_in_window(struct ip_ct_tcp *state, 
                          enum ip_conntrack_dir dir,
                          unsigned int *index,
                          const struct sk_buff *skb,
@@ -521,8 +521,8 @@
                          struct tcphdr *tcph,
 			 int pf)
 {
-	struct nf_ct_tcp_state *sender = &state->seen[dir];
-	struct nf_ct_tcp_state *receiver = &state->seen[!dir];
+	struct ip_ct_tcp_state *sender = &state->seen[dir];
+	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
 	__u32 seq, ack, sack, end, win, swin;
 	int res;
 
@@ -534,7 +534,7 @@
 	win = ntohs(tcph->window);
 	end = segment_seq_plus_len(seq, skb->len, dataoff, tcph);
 
-	if (receiver->flags & NF_CT_TCP_FLAG_SACK_PERM)
+	if (receiver->flags & IP_CT_TCP_FLAG_SACK_PERM)
 		tcp_sack(skb, dataoff, tcph, &sack);
 
 	DEBUGP("tcp_in_window: START\n");
@@ -568,8 +568,8 @@
 			 * Both sides must send the Window Scale option
 			 * to enable window scaling in either direction.
 			 */
-			if (!(sender->flags & NF_CT_TCP_FLAG_WINDOW_SCALE
-			      && receiver->flags & NF_CT_TCP_FLAG_WINDOW_SCALE))
+			if (!(sender->flags & IP_CT_TCP_FLAG_WINDOW_SCALE
+			      && receiver->flags & IP_CT_TCP_FLAG_WINDOW_SCALE))
 				sender->td_scale = 
 				receiver->td_scale = 0;
 		} else {
@@ -734,8 +734,8 @@
 	struct tcphdr *tcph = (void *)skb->data + dataoff;
 	__u32 end;
 #ifdef DEBUGP_VARS
-	struct nf_ct_tcp_state *sender = &conntrack->proto.tcp.seen[dir];
-	struct nf_ct_tcp_state *receiver = &conntrack->proto.tcp.seen[!dir];
+	struct ip_ct_tcp_state *sender = &conntrack->proto.tcp.seen[dir];
+	struct ip_ct_tcp_state *receiver = &conntrack->proto.tcp.seen[!dir];
 #endif
 
 	end = segment_seq_plus_len(ntohl(tcph->seq), skb->len, dataoff, tcph);
@@ -1036,8 +1036,8 @@
 	enum tcp_conntrack new_state;
 	struct tcphdr *th, _tcph;
 #ifdef DEBUGP_VARS
-	struct nf_ct_tcp_state *sender = &conntrack->proto.tcp.seen[0];
-	struct nf_ct_tcp_state *receiver = &conntrack->proto.tcp.seen[1];
+	struct ip_ct_tcp_state *sender = &conntrack->proto.tcp.seen[0];
+	struct ip_ct_tcp_state *receiver = &conntrack->proto.tcp.seen[1];
 #endif
 
 	th = skb_header_pointer(skb, dataoff, sizeof(_tcph), &_tcph);
@@ -1091,7 +1091,7 @@
 
 		/* We assume SACK. Should we assume window scaling too? */
 		conntrack->proto.tcp.seen[0].flags =
-		conntrack->proto.tcp.seen[1].flags = NF_CT_TCP_FLAG_SACK_PERM;
+		conntrack->proto.tcp.seen[1].flags = IP_CT_TCP_FLAG_SACK_PERM;
 		conntrack->proto.tcp.seen[0].loose = 
 		conntrack->proto.tcp.seen[1].loose = nf_ct_tcp_loose;
 	}

----Next_Part(Tue_Mar_22_22:51:30_2005_146)----
