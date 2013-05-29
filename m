From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next] Revert "netfilter: tproxy: do not assign timewait sockets to skb->sk"
Date: Wed, 29 May 2013 03:58:39 +0200
Message-ID: <1369792719-3945-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43593 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934826Ab3E2CAD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 May 2013 22:00:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This reverts commit d503b30bd648b3cb4e5f50b65d27e389960cc6d9.

Nowadays we have early socket demux; all the input code paths
should handle "skb->sk points to timewait sock" properly.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tproxy_core.h |   12 +++++++++++-
 net/netfilter/nf_tproxy_core.c         |   27 +++++++++++++++------------
 net/netfilter/xt_TPROXY.c              |   22 ++--------------------
 net/netfilter/xt_socket.c              |   13 ++-----------
 4 files changed, 30 insertions(+), 44 deletions(-)

diff --git a/include/net/netfilter/nf_tproxy_core.h b/include/net/netfilter/nf_tproxy_core.h
index 36d9379..08b9a8f 100644
--- a/include/net/netfilter/nf_tproxy_core.h
+++ b/include/net/netfilter/nf_tproxy_core.h
@@ -203,8 +203,18 @@ nf_tproxy_get_sock_v6(struct net *net, const u8 protocol,
 }
 #endif
 
+static inline void
+nf_tproxy_put_sock(struct sock *sk)
+{
+	/* TIME_WAIT inet sockets have to be handled differently */
+	if ((sk->sk_protocol == IPPROTO_TCP) && (sk->sk_state == TCP_TIME_WAIT))
+		inet_twsk_put(inet_twsk(sk));
+	else
+		sock_put(sk);
+}
+
 /* assign a socket to the skb -- consumes sk */
-void
+int
 nf_tproxy_assign_sock(struct sk_buff *skb, struct sock *sk);
 
 #endif
diff --git a/net/netfilter/nf_tproxy_core.c b/net/netfilter/nf_tproxy_core.c
index 474d621..4d87bef 100644
--- a/net/netfilter/nf_tproxy_core.c
+++ b/net/netfilter/nf_tproxy_core.c
@@ -28,23 +28,26 @@ nf_tproxy_destructor(struct sk_buff *skb)
 	skb->destructor = NULL;
 
 	if (sk)
-		sock_put(sk);
+		nf_tproxy_put_sock(sk);
 }
 
 /* consumes sk */
-void
+int
 nf_tproxy_assign_sock(struct sk_buff *skb, struct sock *sk)
 {
-	/* assigning tw sockets complicates things; most
-	 * skb->sk->X checks would have to test sk->sk_state first */
-	if (sk->sk_state == TCP_TIME_WAIT) {
-		inet_twsk_put(inet_twsk(sk));
-		return;
-	}
-
-	skb_orphan(skb);
-	skb->sk = sk;
-	skb->destructor = nf_tproxy_destructor;
+	bool transparent = (sk->sk_state == TCP_TIME_WAIT) ?
+				inet_twsk(sk)->tw_transparent :
+				inet_sk(sk)->transparent;
+
+	if (transparent) {
+		skb_orphan(skb);
+		skb->sk = sk;
+		skb->destructor = nf_tproxy_destructor;
+		return 1;
+	} else
+		nf_tproxy_put_sock(sk);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_tproxy_assign_sock);
 
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index d7f1953..c33b305 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -33,20 +33,6 @@
 #include <net/netfilter/nf_tproxy_core.h>
 #include <linux/netfilter/xt_TPROXY.h>
 
-static bool tproxy_sk_is_transparent(struct sock *sk)
-{
-	if (sk->sk_state != TCP_TIME_WAIT) {
-		if (inet_sk(sk)->transparent)
-			return true;
-		sock_put(sk);
-	} else {
-		if (inet_twsk(sk)->tw_transparent)
-			return true;
-		inet_twsk_put(inet_twsk(sk));
-	}
-	return false;
-}
-
 static inline __be32
 tproxy_laddr4(struct sk_buff *skb, __be32 user_laddr, __be32 daddr)
 {
@@ -155,7 +141,7 @@ tproxy_tg4(struct sk_buff *skb, __be32 laddr, __be16 lport,
 					   skb->dev, NFT_LOOKUP_LISTENER);
 
 	/* NOTE: assign_sock consumes our sk reference */
-	if (sk && tproxy_sk_is_transparent(sk)) {
+	if (sk && nf_tproxy_assign_sock(skb, sk)) {
 		/* This should be in a separate target, but we don't do multiple
 		   targets on the same rule yet */
 		skb->mark = (skb->mark & ~mark_mask) ^ mark_value;
@@ -163,8 +149,6 @@ tproxy_tg4(struct sk_buff *skb, __be32 laddr, __be16 lport,
 		pr_debug("redirecting: proto %hhu %pI4:%hu -> %pI4:%hu, mark: %x\n",
 			 iph->protocol, &iph->daddr, ntohs(hp->dest),
 			 &laddr, ntohs(lport), skb->mark);
-
-		nf_tproxy_assign_sock(skb, sk);
 		return NF_ACCEPT;
 	}
 
@@ -322,7 +306,7 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
 					   par->in, NFT_LOOKUP_LISTENER);
 
 	/* NOTE: assign_sock consumes our sk reference */
-	if (sk && tproxy_sk_is_transparent(sk)) {
+	if (sk && nf_tproxy_assign_sock(skb, sk)) {
 		/* This should be in a separate target, but we don't do multiple
 		   targets on the same rule yet */
 		skb->mark = (skb->mark & ~tgi->mark_mask) ^ tgi->mark_value;
@@ -330,8 +314,6 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
 		pr_debug("redirecting: proto %hhu %pI6:%hu -> %pI6:%hu, mark: %x\n",
 			 tproto, &iph->saddr, ntohs(hp->source),
 			 laddr, ntohs(lport), skb->mark);
-
-		nf_tproxy_assign_sock(skb, sk);
 		return NF_ACCEPT;
 	}
 
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 0270424..0eb2b13 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -35,15 +35,6 @@
 #include <net/netfilter/nf_conntrack.h>
 #endif
 
-static void
-xt_socket_put_sk(struct sock *sk)
-{
-	if (sk->sk_state == TCP_TIME_WAIT)
-		inet_twsk_put(inet_twsk(sk));
-	else
-		sock_put(sk);
-}
-
 static int
 extract_icmp4_fields(const struct sk_buff *skb,
 		    u8 *protocol,
@@ -176,7 +167,7 @@ socket_match(const struct sk_buff *skb, struct xt_action_param *par,
 					inet_twsk(sk)->tw_transparent));
 
 		if (sk != skb->sk)
-			xt_socket_put_sk(sk);
+			nf_tproxy_put_sock(sk);
 
 		if (wildcard || !transparent)
 			sk = NULL;
@@ -315,7 +306,7 @@ socket_mt6_v1(const struct sk_buff *skb, struct xt_action_param *par)
 					inet_twsk(sk)->tw_transparent));
 
 		if (sk != skb->sk)
-			xt_socket_put_sk(sk);
+			nf_tproxy_put_sock(sk);
 
 		if (wildcard || !transparent)
 			sk = NULL;
-- 
1.7.8.6

