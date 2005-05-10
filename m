From: Patrick McHardy <kaber@trash.net>
Subject: [netfilter socket hooks 2/5]: Add protocol hooks
Date: Tue, 10 May 2005 18:00:34 +0200
Message-ID: <4280DAA2.2030708@trash.net>
References: <Xine.LNX.4.44.0504270037490.16008-100000@thoron.boston.redhat.com>	<426F64C8.1070601@trash.net>	<426FA44A.2010008@evtek.fi>	<426FA73E.3090605@trash.net>	<20050427114926.45a91b5e.davem@davemloft.net>
	<426FE9DD.80201@trash.net> <4280DA51.8090201@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Cc: juha.heljoranta@evtek.fi, Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4280DA51.8090201@trash.net>
Content-Disposition: inline;
 filename="02.diff"
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

[NETFILTER]: Add protocol hooks

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 03a2e97e71c3c9bfbfc3d357544348d393551658
tree b53df6f327c03ec282a1b75326db321dbd2f0bc0
parent 4ca9ffc0b58dd44e91cbaaa2de3c27faa220e047
author Patrick McHardy <kaber@trash.net> Mon, 09 May 2005 18:34:53 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 09 May 2005 18:34:53 +0200

 net/ipv4/raw.c      |    8 ++-
 net/ipv4/tcp_ipv4.c |  123 +++++++++++++++++++++++++++++++++-------------------
 net/ipv4/udp.c      |  109 +++++++++++++++++++++++++++-------------------
 3 files changed, 151 insertions(+), 89 deletions(-)

Index: net/ipv4/raw.c
===================================================================
--- e97143c76936d02bb1817a1e109e36707202a6bb/net/ipv4/raw.c  (mode:100644)
+++ b53df6f327c03ec282a1b75326db321dbd2f0bc0/net/ipv4/raw.c  (mode:100644)
@@ -246,7 +246,7 @@
 	return NET_RX_SUCCESS;
 }
 
-int raw_rcv(struct sock *sk, struct sk_buff *skb)
+static inline int raw_rcv_finish(struct sock *sk, struct sk_buff *skb)
 {
 	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb)) {
 		kfree_skb(skb);
@@ -259,6 +259,12 @@
 	return 0;
 }
 
+int raw_rcv(struct sock *sk, struct sk_buff *skb)
+{
+	return NF_SK_HOOK(AF_INET, NF_IP_LOCAL_IN, sk, skb, skb->dev, NULL,
+	                  raw_rcv_finish, NULL);
+}
+
 static int raw_send_hdrinc(struct sock *sk, void *from, int length,
 			struct rtable *rt, 
 			unsigned int flags)
Index: net/ipv4/tcp_ipv4.c
===================================================================
--- e97143c76936d02bb1817a1e109e36707202a6bb/net/ipv4/tcp_ipv4.c  (mode:100644)
+++ b53df6f327c03ec282a1b75326db321dbd2f0bc0/net/ipv4/tcp_ipv4.c  (mode:100644)
@@ -62,6 +62,8 @@
 #include <linux/jhash.h>
 #include <linux/init.h>
 #include <linux/times.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
 
 #include <net/icmp.h>
 #include <net/tcp.h>
@@ -1713,52 +1715,24 @@
 	goto discard;
 }
 
-/*
- *	From tcp_input.c
- */
-
-int tcp_v4_rcv(struct sk_buff *skb)
+/* Dummy outfn for netfilter - caller still owns the skb */
+static inline int tcp_v4_rcv_finish2(struct sock *sk, struct sk_buff *skb)
 {
-	struct tcphdr *th;
-	struct sock *sk;
-	int ret;
-
-	if (skb->pkt_type != PACKET_HOST)
-		goto discard_it;
-
-	/* Count it even if it's bad */
-	TCP_INC_STATS_BH(TCP_MIB_INSEGS);
-
-	if (!pskb_may_pull(skb, sizeof(struct tcphdr)))
-		goto discard_it;
-
-	th = skb->h.th;
-
-	if (th->doff < sizeof(struct tcphdr) / 4)
-		goto bad_packet;
-	if (!pskb_may_pull(skb, th->doff * 4))
-		goto discard_it;
-
-	/* An explanation is required here, I think.
-	 * Packet length and doff are validated by header prediction,
-	 * provided case of th->doff==0 is elimineted.
-	 * So, we defer the checks. */
-	if ((skb->ip_summed != CHECKSUM_UNNECESSARY &&
-	     tcp_v4_checksum_init(skb) < 0))
-		goto bad_packet;
+	return 0;
+}
 
-	th = skb->h.th;
-	TCP_SKB_CB(skb)->seq = ntohl(th->seq);
-	TCP_SKB_CB(skb)->end_seq = (TCP_SKB_CB(skb)->seq + th->syn + th->fin +
-				    skb->len - th->doff * 4);
-	TCP_SKB_CB(skb)->ack_seq = ntohl(th->ack_seq);
-	TCP_SKB_CB(skb)->when	 = 0;
-	TCP_SKB_CB(skb)->flags	 = skb->nh.iph->tos;
-	TCP_SKB_CB(skb)->sacked	 = 0;
+static inline void tcp_sock_put(struct sock *sk)
+{
+	if (sk->sk_state == TCP_TIME_WAIT)
+		tcp_tw_put((struct tcp_tw_bucket *)sk);
+	else
+		sock_put(sk);
+}
 
-	sk = __tcp_v4_lookup(skb->nh.iph->saddr, th->source,
-			     skb->nh.iph->daddr, ntohs(th->dest),
-			     tcp_v4_iif(skb));
+static inline int tcp_v4_rcv_finish(struct sock *sk, struct sk_buff *skb)
+{
+	struct tcphdr *th = skb->h.th;
+	int ret;
 
 	if (!sk)
 		goto no_tcp_socket;
@@ -1793,7 +1767,6 @@
 		goto discard_it;
 
 	if (skb->len < (th->doff << 2) || tcp_checksum_complete(skb)) {
-bad_packet:
 		TCP_INC_STATS_BH(TCP_MIB_INERRS);
 	} else {
 		tcp_v4_send_reset(skb);
@@ -1829,6 +1802,11 @@
 			tcp_tw_deschedule((struct tcp_tw_bucket *)sk);
 			tcp_tw_put((struct tcp_tw_bucket *)sk);
 			sk = sk2;
+			ret = NF_SK_HOOK(AF_INET, NF_IP_LOCAL_IN, sk, skb,
+			                 skb->dev, NULL, tcp_v4_rcv_finish2,
+			                 tcp_sock_put);
+			if (ret)
+				return ret;
 			goto process;
 		}
 		/* Fall through to ACK */
@@ -1843,6 +1821,63 @@
 	goto discard_it;
 }
 
+/*
+ *	From tcp_input.c
+ */
+
+int tcp_v4_rcv(struct sk_buff *skb)
+{
+	struct tcphdr *th;
+	struct sock *sk;
+
+	if (skb->pkt_type != PACKET_HOST)
+		goto discard_it;
+
+	/* Count it even if it's bad */
+	TCP_INC_STATS_BH(TCP_MIB_INSEGS);
+
+	if (!pskb_may_pull(skb, sizeof(struct tcphdr)))
+		goto discard_it;
+
+	th = skb->h.th;
+
+	if (th->doff < sizeof(struct tcphdr) / 4)
+		goto bad_packet;
+	if (!pskb_may_pull(skb, th->doff * 4))
+		goto discard_it;
+
+	/* An explanation is required here, I think.
+	 * Packet length and doff are validated by header prediction,
+	 * provided case of th->doff==0 is elimineted.
+	 * So, we defer the checks. */
+	if ((skb->ip_summed != CHECKSUM_UNNECESSARY &&
+	     tcp_v4_checksum_init(skb) < 0))
+		goto bad_packet;
+
+	th = skb->h.th;
+	TCP_SKB_CB(skb)->seq = ntohl(th->seq);
+	TCP_SKB_CB(skb)->end_seq = (TCP_SKB_CB(skb)->seq + th->syn + th->fin +
+				    skb->len - th->doff * 4);
+	TCP_SKB_CB(skb)->ack_seq = ntohl(th->ack_seq);
+	TCP_SKB_CB(skb)->when	 = 0;
+	TCP_SKB_CB(skb)->flags	 = skb->nh.iph->tos;
+	TCP_SKB_CB(skb)->sacked	 = 0;
+
+	sk = __tcp_v4_lookup(skb->nh.iph->saddr, th->source,
+			     skb->nh.iph->daddr, ntohs(th->dest),
+			     tcp_v4_iif(skb));
+
+	return NF_SK_HOOK(AF_INET, NF_IP_LOCAL_IN, sk, skb, skb->dev, NULL,
+	                  tcp_v4_rcv_finish, tcp_sock_put);
+
+bad_packet:
+	TCP_INC_STATS_BH(TCP_MIB_INERRS);
+discard_it:
+	/* Discard frame. */
+	kfree_skb(skb);
+  	return 0;
+}
+
 /* With per-bucket locks this operation is not-atomic, so that
  * this version is not worse.
  */
Index: net/ipv4/udp.c
===================================================================
--- e97143c76936d02bb1817a1e109e36707202a6bb/net/ipv4/udp.c  (mode:100644)
+++ b53df6f327c03ec282a1b75326db321dbd2f0bc0/net/ipv4/udp.c  (mode:100644)
@@ -94,6 +94,8 @@
 #include <linux/inet.h>
 #include <linux/ipv6.h>
 #include <linux/netdevice.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
 #include <net/snmp.h>
 #include <net/tcp.h>
 #include <net/protocol.h>
@@ -1113,6 +1115,55 @@
 	return 0;
 }
 
+static inline int udp_rcv_finish(struct sock *sk, struct sk_buff *skb)
+{
+	if (sk != NULL) {
+		int ret = udp_queue_rcv_skb(sk, skb);
+		sock_put(sk);
+
+		/* a return value > 0 means to resubmit the input, but
+		 * it it wants the return to be -protocol, or 0
+		 */
+		if (ret > 0)
+			return -ret;
+		return 0;
+	}
+
+	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
+		goto drop;
+
+	/* No socket. Drop packet silently, if checksum is wrong */
+	if (udp_checksum_complete(skb))
+		goto csum_error;
+
+	UDP_INC_STATS_BH(UDP_MIB_NOPORTS);
+	icmp_send(skb, ICMP_DEST_UNREACH, ICMP_PORT_UNREACH, 0);
+
+	/*
+	 * Hmm.  We got an UDP packet to a port to which we
+	 * don't wanna listen.  Ignore it.
+	 */
+	kfree_skb(skb);
+	return(0);
+
+csum_error:
+	/* 
+	 * RFC1122: OK.  Discards the bad packet silently (as far as 
+	 * the network is concerned, anyway) as per 4.1.3.4 (MUST). 
+	 */
+	NETDEBUG(if (net_ratelimit())
+		 printk(KERN_DEBUG "UDP: bad checksum. From %d.%d.%d.%d:%d to %d.%d.%d.%d:%d ulen %d\n",
+			NIPQUAD(skb->nh.iph->saddr),
+			ntohs(skb->h.uh->source),
+			NIPQUAD(skb->nh.iph->daddr),
+			ntohs(skb->h.uh->dest),
+			ntohs(skb->h.uh->len)));
+drop:
+	UDP_INC_STATS_BH(UDP_MIB_INERRORS);
+	kfree_skb(skb);
+	return(0);
+}
+
 /*
  *	All we need to do is get the socket, and then do a checksum. 
  */
@@ -1151,35 +1202,21 @@
 
 	sk = udp_v4_lookup(saddr, uh->source, daddr, uh->dest, skb->dev->ifindex);
 
-	if (sk != NULL) {
-		int ret = udp_queue_rcv_skb(sk, skb);
-		sock_put(sk);
-
-		/* a return value > 0 means to resubmit the input, but
-		 * it it wants the return to be -protocol, or 0
-		 */
-		if (ret > 0)
-			return -ret;
-		return 0;
-	}
-
-	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
-		goto drop;
-
-	/* No socket. Drop packet silently, if checksum is wrong */
-	if (udp_checksum_complete(skb))
-		goto csum_error;
-
-	UDP_INC_STATS_BH(UDP_MIB_NOPORTS);
-	icmp_send(skb, ICMP_DEST_UNREACH, ICMP_PORT_UNREACH, 0);
-
-	/*
-	 * Hmm.  We got an UDP packet to a port to which we
-	 * don't wanna listen.  Ignore it.
+	return NF_SK_HOOK(AF_INET, NF_IP_LOCAL_IN, sk, skb, skb->dev, NULL,
+	                  udp_rcv_finish, sock_put);
+csum_error:
+	/* 
+	 * RFC1122: OK.  Discards the bad packet silently (as far as 
+	 * the network is concerned, anyway) as per 4.1.3.4 (MUST). 
 	 */
-	kfree_skb(skb);
-	return(0);
-
+	NETDEBUG(if (net_ratelimit())
+		 printk(KERN_DEBUG "UDP: bad checksum. From %d.%d.%d.%d:%d to %d.%d.%d.%d:%d ulen %d\n",
+			NIPQUAD(skb->nh.iph->saddr),
+			ntohs(skb->h.uh->source),
+			NIPQUAD(skb->nh.iph->daddr),
+			ntohs(skb->h.uh->dest),
+			ntohs(skb->h.uh->len)));
+	goto drop;
 short_packet:
 	NETDEBUG(if (net_ratelimit())
 		printk(KERN_DEBUG "UDP: short packet: From %u.%u.%u.%u:%u %d/%d to %u.%u.%u.%u:%u\n",
@@ -1191,23 +1228,7 @@
 			ntohs(uh->dest)));
 no_header:
 	UDP_INC_STATS_BH(UDP_MIB_INERRORS);
-	kfree_skb(skb);
-	return(0);
-
-csum_error:
-	/* 
-	 * RFC1122: OK.  Discards the bad packet silently (as far as 
-	 * the network is concerned, anyway) as per 4.1.3.4 (MUST). 
-	 */
-	NETDEBUG(if (net_ratelimit())
-		 printk(KERN_DEBUG "UDP: bad checksum. From %d.%d.%d.%d:%d to %d.%d.%d.%d:%d ulen %d\n",
-			NIPQUAD(saddr),
-			ntohs(uh->source),
-			NIPQUAD(daddr),
-			ntohs(uh->dest),
-			ulen));
 drop:
-	UDP_INC_STATS_BH(UDP_MIB_INERRORS);
 	kfree_skb(skb);
 	return(0);
 }
