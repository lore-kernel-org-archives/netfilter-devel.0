From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [PATCH 05/13] Handle TCP SYN+ACK/ACK/RST transparency
Date: Sun, 30 Sep 2007 22:52:33 +0200
Message-ID: <20070930205233.10969.32752.stgit@nessa.odu>
References: <20070930205141.10969.27205.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:40440 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbXI3VL5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:11:57 -0400
In-Reply-To: <20070930205141.10969.27205.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The TCP stack sends out SYN+ACK/ACK/RST reply packets in response to
incoming packets. The non-local source address check on output bites
us again, as replies for transparently redirected traffic won't have a
chance to leave the node.

This patch selectively sets the FLOWI_FLAG_ANYSRC flag when doing
the route lookup for those replies. Transparent replies are enabled if
the listening socket has the transparent socket flag set.

Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
---

 include/net/ip.h                |    3 +++
 include/net/request_sock.h      |    3 ++-
 net/ipv4/inet_connection_sock.c |    2 ++
 net/ipv4/ip_output.c            |    6 +++++-
 net/ipv4/syncookies.c           |    2 ++
 net/ipv4/tcp_ipv4.c             |   17 ++++++++++-------
 net/ipv4/tcp_minisocks.c        |    3 ++-
 net/ipv6/tcp_ipv6.c             |    5 +++--
 8 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index abf2820..0084001 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -138,8 +138,11 @@ static inline void ip_tr_mc_map(__be32 addr, char *buf)
 	buf[5]=0x00;
 }
 
+#define IP_REPLY_ARG_NOSRCCHECK 1
+
 struct ip_reply_arg {
 	struct kvec iov[1];   
+	int	    flags;
 	__wsum 	    csum;
 	int	    csumoffset; /* u16 offset of csum in iov[0].iov_base */
 				/* -1 if not needed */ 
diff --git a/include/net/request_sock.h b/include/net/request_sock.h
index 7aed02c..b9c8974 100644
--- a/include/net/request_sock.h
+++ b/include/net/request_sock.h
@@ -34,7 +34,8 @@ struct request_sock_ops {
 				       struct request_sock *req,
 				       struct dst_entry *dst);
 	void		(*send_ack)(struct sk_buff *skb,
-				    struct request_sock *req);
+				    struct request_sock *req,
+				    int reply_flags);
 	void		(*send_reset)(struct sock *sk,
 				      struct sk_buff *skb);
 	void		(*destructor)(struct request_sock *req);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index fbe7714..26b9dbe 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -321,6 +321,8 @@ struct dst_entry* inet_csk_route_req(struct sock *sk,
 					.saddr = ireq->loc_addr,
 					.tos = RT_CONN_FLAGS(sk) } },
 			    .proto = sk->sk_protocol,
+			    .flags = inet_sk(sk)->transparent ?
+					FLOWI_FLAG_ANYSRC : 0,
 			    .uli_u = { .ports =
 				       { .sport = inet_sk(sk)->sport,
 					 .dport = ireq->rmt_port } } };
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 0f1d7be..40cafcd 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -322,6 +322,8 @@ int ip_queue_xmit(struct sk_buff *skb, int ipfragok)
 							.saddr = inet->saddr,
 							.tos = RT_CONN_FLAGS(sk) } },
 					    .proto = sk->sk_protocol,
+					    .flags = inet->transparent ?
+							 FLOWI_FLAG_ANYSRC : 0,
 					    .uli_u = { .ports =
 						       { .sport = inet->sport,
 							 .dport = inet->dport } } };
@@ -1364,7 +1366,9 @@ void ip_send_reply(struct sock *sk, struct sk_buff *skb, struct ip_reply_arg *ar
 				    .uli_u = { .ports =
 					       { .sport = tcp_hdr(skb)->dest,
 						 .dport = tcp_hdr(skb)->source } },
-				    .proto = sk->sk_protocol };
+				    .proto = sk->sk_protocol,
+				    .flags = (arg->flags & IP_REPLY_ARG_NOSRCCHECK) ?
+				    		FLOWI_FLAG_ANYSRC : 0 };
 		security_skb_classify_flow(skb, &fl);
 		if (ip_route_output_key(&rt, &fl))
 			return;
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 2da1be0..f7fad59 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -260,6 +260,8 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb,
 						.saddr = ireq->loc_addr,
 						.tos = RT_CONN_FLAGS(sk) } },
 				    .proto = IPPROTO_TCP,
+				    .flags = inet_sk(sk)->transparent ?
+						FLOWI_FLAG_ANYSRC : 0,
 				    .uli_u = { .ports =
 					       { .sport = th->dest,
 						 .dport = th->source } } };
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index e089a97..7ae47e6 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -612,6 +612,7 @@ static void tcp_v4_send_reset(struct sock *sk, struct sk_buff *skb)
 				      ip_hdr(skb)->saddr, /* XXX */
 				      sizeof(struct tcphdr), IPPROTO_TCP, 0);
 	arg.csumoffset = offsetof(struct tcphdr, check) / 2;
+	arg.flags = (sk && inet_sk(sk)->transparent) ? IP_REPLY_ARG_NOSRCCHECK : 0;
 
 	ip_send_reply(tcp_socket->sk, skb, &arg, arg.iov[0].iov_len);
 
@@ -625,7 +626,7 @@ static void tcp_v4_send_reset(struct sock *sk, struct sk_buff *skb)
 
 static void tcp_v4_send_ack(struct tcp_timewait_sock *twsk,
 			    struct sk_buff *skb, u32 seq, u32 ack,
-			    u32 win, u32 ts)
+			    u32 win, u32 ts, int reply_flags)
 {
 	struct tcphdr *th = tcp_hdr(skb);
 	struct {
@@ -701,36 +702,37 @@ static void tcp_v4_send_ack(struct tcp_timewait_sock *twsk,
 					arg.iov[0].iov_len);
 	}
 #endif
+	arg.flags = reply_flags;
 	arg.csum = csum_tcpudp_nofold(ip_hdr(skb)->daddr,
 				      ip_hdr(skb)->saddr, /* XXX */
 				      arg.iov[0].iov_len, IPPROTO_TCP, 0);
 	arg.csumoffset = offsetof(struct tcphdr, check) / 2;
 	if (twsk)
 		arg.bound_dev_if = twsk->tw_sk.tw_bound_dev_if;
-
 	ip_send_reply(tcp_socket->sk, skb, &arg, arg.iov[0].iov_len);
 
 	TCP_INC_STATS_BH(TCP_MIB_OUTSEGS);
 }
 
-static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb)
+static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb, int reply_flags)
 {
 	struct inet_timewait_sock *tw = inet_twsk(sk);
 	struct tcp_timewait_sock *tcptw = tcp_twsk(sk);
 
 	tcp_v4_send_ack(tcptw, skb, tcptw->tw_snd_nxt, tcptw->tw_rcv_nxt,
 			tcptw->tw_rcv_wnd >> tw->tw_rcv_wscale,
-			tcptw->tw_ts_recent);
+			tcptw->tw_ts_recent, reply_flags);
 
 	inet_twsk_put(tw);
 }
 
 static void tcp_v4_reqsk_send_ack(struct sk_buff *skb,
-				  struct request_sock *req)
+				  struct request_sock *req,
+				  int reply_flags)
 {
 	tcp_v4_send_ack(NULL, skb, tcp_rsk(req)->snt_isn + 1,
 			tcp_rsk(req)->rcv_isn + 1, req->rcv_wnd,
-			req->ts_recent);
+			req->ts_recent, reply_flags);
 }
 
 /*
@@ -1742,7 +1744,8 @@ do_time_wait:
 		/* Fall through to ACK */
 	}
 	case TCP_TW_ACK:
-		tcp_v4_timewait_ack(sk, skb);
+		tcp_v4_timewait_ack(sk, skb, inet_twsk(sk)->tw_transparent ?
+				    IP_REPLY_ARG_NOSRCCHECK : 0);
 		break;
 	case TCP_TW_RST:
 		goto no_tcp_socket;
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index a12b08f..734d119 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -604,7 +604,8 @@ struct sock *tcp_check_req(struct sock *sk,struct sk_buff *skb,
 					  tcp_rsk(req)->rcv_isn + 1, tcp_rsk(req)->rcv_isn + 1 + req->rcv_wnd)) {
 		/* Out of window: send ACK and drop. */
 		if (!(flg & TCP_FLAG_RST))
-			req->rsk_ops->send_ack(skb, req);
+			req->rsk_ops->send_ack(skb, req, inet_sk(sk)->transparent ?
+					       IP_REPLY_ARG_NOSRCCHECK : 0);
 		if (paws_reject)
 			NET_INC_STATS_BH(LINUX_MIB_PAWSESTABREJECTED);
 		return NULL;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 3e06799..b3f3c1d 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -72,7 +72,7 @@
 static struct socket *tcp6_socket;
 
 static void	tcp_v6_send_reset(struct sock *sk, struct sk_buff *skb);
-static void	tcp_v6_reqsk_send_ack(struct sk_buff *skb, struct request_sock *req);
+static void	tcp_v6_reqsk_send_ack(struct sk_buff *skb, struct request_sock *req, int reply_flags);
 static void	tcp_v6_send_check(struct sock *sk, int len,
 				  struct sk_buff *skb);
 
@@ -1183,7 +1183,8 @@ static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
 	inet_twsk_put(tw);
 }
 
-static void tcp_v6_reqsk_send_ack(struct sk_buff *skb, struct request_sock *req)
+static void tcp_v6_reqsk_send_ack(struct sk_buff *skb, struct request_sock *req,
+				  int reply_flags)
 {
 	tcp_v6_send_ack(NULL, skb, tcp_rsk(req)->snt_isn + 1, tcp_rsk(req)->rcv_isn + 1, req->rcv_wnd, req->ts_recent);
 }

