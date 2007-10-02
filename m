From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [PATCH 02/13] Implement IP_TRANSPARENT socket option
Date: Tue, 02 Oct 2007 22:40:45 +0200
Message-ID: <20071002204045.11052.34269.stgit@nessa.odu>
References: <20071002203942.11052.7303.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from balu.sch.bme.hu ([152.66.208.40]:51126 "EHLO balu.sch.bme.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbXJBUkp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2007 16:40:45 -0400
Received: from nessa.odu ([152.66.208.5])
 by balu.sch.bme.hu (Sun Java System Messaging Server 6.2-7.05 (built Sep  5
 2006)) with ESMTP id <0JPA007Q3XDCQF70@balu.sch.bme.hu> for
 netfilter-devel@vger.kernel.org; Tue, 02 Oct 2007 22:39:12 +0200 (CEST)
In-reply-to: <20071002203942.11052.7303.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch introduces the IP_TRANSPARENT socket option: enabling that will make
the IPv4 routing omit the non-local source address check on output. Setting
IP_TRANSPARENT requires NET_ADMIN capability.

Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
Acked-by: Patrick McHardy <kaber@trash.net>
---

 include/linux/in.h               |    1 +
 include/net/inet_sock.h          |    3 ++-
 include/net/inet_timewait_sock.h |    3 ++-
 include/net/route.h              |    1 +
 net/ipv4/inet_timewait_sock.c    |    1 +
 net/ipv4/ip_sockglue.c           |   12 +++++++++++-
 6 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/in.h b/include/linux/in.h
index 3975cbf..d8c55ab 100644
--- a/include/linux/in.h
+++ b/include/linux/in.h
@@ -75,6 +75,7 @@ struct in_addr {
 #define IP_IPSEC_POLICY	16
 #define IP_XFRM_POLICY	17
 #define IP_PASSSEC	18
+#define IP_TRANSPARENT	19
 
 /* BSD compatibility */
 #define IP_RECVRETOPTS	IP_RETOPTS
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 62daf21..e86832d 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -128,7 +128,8 @@ struct inet_sock {
 				is_icsk:1,
 				freebind:1,
 				hdrincl:1,
-				mc_loop:1;
+				mc_loop:1,
+				transparent:1;
 	int			mc_index;
 	__be32			mc_addr;
 	struct ip_mc_socklist	*mc_list;
diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
index 47d52b2..23e2fba 100644
--- a/include/net/inet_timewait_sock.h
+++ b/include/net/inet_timewait_sock.h
@@ -126,7 +126,8 @@ struct inet_timewait_sock {
 	__be16			tw_dport;
 	__u16			tw_num;
 	/* And these are ours. */
-	__u8			tw_ipv6only:1;
+	__u8			tw_ipv6only:1,
+				tw_transparent:1;
 	/* 15 bits hole, try to pack */
 	__u16			tw_ipv6_offset;
 	int			tw_timeout;
diff --git a/include/net/route.h b/include/net/route.h
index f7ce625..88fed3c 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -27,6 +27,7 @@
 #include <net/dst.h>
 #include <net/inetpeer.h>
 #include <net/flow.h>
+#include <net/inet_sock.h>
 #include <linux/in_route.h>
 #include <linux/rtnetlink.h>
 #include <linux/route.h>
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 2586df0..cf057a3 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -107,6 +107,7 @@ struct inet_timewait_sock *inet_twsk_alloc(const struct sock *sk, const int stat
 		tw->tw_reuse	    = sk->sk_reuse;
 		tw->tw_hash	    = sk->sk_hash;
 		tw->tw_ipv6only	    = 0;
+		tw->tw_transparent  = inet->transparent;
 		tw->tw_prot	    = sk->sk_prot_creator;
 		atomic_set(&tw->tw_refcnt, 1);
 		inet_twsk_dead_node_init(tw);
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 6b420ae..282b187 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -420,7 +420,7 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 			     (1<<IP_TTL) | (1<<IP_HDRINCL) |
 			     (1<<IP_MTU_DISCOVER) | (1<<IP_RECVERR) |
 			     (1<<IP_ROUTER_ALERT) | (1<<IP_FREEBIND) |
-			     (1<<IP_PASSSEC))) ||
+			     (1<<IP_PASSSEC) | (1<<IP_TRANSPARENT))) ||
 	    optname == IP_MULTICAST_TTL ||
 	    optname == IP_MULTICAST_LOOP) {
 		if (optlen >= sizeof(int)) {
@@ -885,6 +885,16 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 		err = xfrm_user_policy(sk, optname, optval, optlen);
 		break;
 
+	case IP_TRANSPARENT:
+		if (!capable(CAP_NET_ADMIN)) {
+			err = -EPERM;
+			break;
+		}
+		if (optlen < 1)
+			goto e_inval;
+		inet->transparent = !!val;
+		break;
+
 	default:
 		err = -ENOPROTOOPT;
 		break;

