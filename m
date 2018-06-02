From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/9] netfilter: Decrease code duplication regarding transparent socket option
Date: Sun,  3 Jun 2018 01:14:05 +0200
Message-ID: <20180602231413.31974-2-pablo@netfilter.org>
References: <20180602231413.31974-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602231413.31974-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Máté Eckl <ecklm94@gmail.com>

There is a function in include/net/netfilter/nf_socket.h to decide if a
socket has IP(V6)_TRANSPARENT socket option set or not. However this
does the same as inet_sk_transparent() in include/net/tcp.h

include/net/tcp.h:1733
/* This helper checks if socket has IP_TRANSPARENT set */
static inline bool inet_sk_transparent(const struct sock *sk)
{
	switch (sk->sk_state) {
	case TCP_TIME_WAIT:
		return inet_twsk(sk)->tw_transparent;
	case TCP_NEW_SYN_RECV:
		return inet_rsk(inet_reqsk(sk))->no_srccheck;
	}
	return inet_sk(sk)->transparent;
}

tproxy_sk_is_transparent has also been refactored to use this function
instead of reimplementing it.

Signed-off-by: Máté Eckl <ecklm94@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_socket.h | 13 -------------
 net/netfilter/nft_socket.c        |  3 ++-
 net/netfilter/xt_TPROXY.c         | 15 ++-------------
 net/netfilter/xt_socket.c         |  4 ++--
 4 files changed, 6 insertions(+), 29 deletions(-)

diff --git a/include/net/netfilter/nf_socket.h b/include/net/netfilter/nf_socket.h
index 29b6313f0557..f9d7bee9bd4e 100644
--- a/include/net/netfilter/nf_socket.h
+++ b/include/net/netfilter/nf_socket.h
@@ -3,19 +3,6 @@
 #define _NF_SOCK_H_
 
 #include <net/sock.h>
-#include <net/inet_timewait_sock.h>
-
-static inline bool nf_sk_is_transparent(struct sock *sk)
-{
-	switch (sk->sk_state) {
-	case TCP_TIME_WAIT:
-		return inet_twsk(sk)->tw_transparent;
-	case TCP_NEW_SYN_RECV:
-		return inet_rsk(inet_reqsk(sk))->no_srccheck;
-	default:
-		return inet_sk(sk)->transparent;
-	}
-}
 
 struct sock *nf_sk_lookup_slow_v4(struct net *net, const struct sk_buff *skb,
 				  const struct net_device *indev);
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index d86337068ecb..f28a0b944087 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -5,6 +5,7 @@
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_socket.h>
 #include <net/inet_sock.h>
+#include <net/tcp.h>
 
 struct nft_socket {
 	enum nft_socket_keys		key:8;
@@ -48,7 +49,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 
 	switch(priv->key) {
 	case NFT_SOCKET_TRANSPARENT:
-		nft_reg_store8(dest, nf_sk_is_transparent(sk));
+		nft_reg_store8(dest, inet_sk_transparent(sk));
 		break;
 	default:
 		WARN_ON(1);
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 8c89323c06af..74df7977c17c 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -42,19 +42,8 @@ enum nf_tproxy_lookup_t {
 
 static bool tproxy_sk_is_transparent(struct sock *sk)
 {
-	switch (sk->sk_state) {
-	case TCP_TIME_WAIT:
-		if (inet_twsk(sk)->tw_transparent)
-			return true;
-		break;
-	case TCP_NEW_SYN_RECV:
-		if (inet_rsk(inet_reqsk(sk))->no_srccheck)
-			return true;
-		break;
-	default:
-		if (inet_sk(sk)->transparent)
-			return true;
-	}
+	if (inet_sk_transparent(sk))
+		return true;
 
 	sock_gen_put(sk);
 	return false;
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 2ac7f674d19b..5c0779c4fa3c 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -73,7 +73,7 @@ socket_match(const struct sk_buff *skb, struct xt_action_param *par,
 		 * if XT_SOCKET_TRANSPARENT is used
 		 */
 		if (info->flags & XT_SOCKET_TRANSPARENT)
-			transparent = nf_sk_is_transparent(sk);
+			transparent = inet_sk_transparent(sk);
 
 		if (info->flags & XT_SOCKET_RESTORESKMARK && !wildcard &&
 		    transparent && sk_fullsock(sk))
@@ -130,7 +130,7 @@ socket_mt6_v1_v2_v3(const struct sk_buff *skb, struct xt_action_param *par)
 		 * if XT_SOCKET_TRANSPARENT is used
 		 */
 		if (info->flags & XT_SOCKET_TRANSPARENT)
-			transparent = nf_sk_is_transparent(sk);
+			transparent = inet_sk_transparent(sk);
 
 		if (info->flags & XT_SOCKET_RESTORESKMARK && !wildcard &&
 		    transparent && sk_fullsock(sk))
-- 
2.11.0
