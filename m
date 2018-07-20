From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/38] netfilter: nft_tproxy: Move nf_tproxy_assign_sock() to nf_tproxy.h
Date: Fri, 20 Jul 2018 15:08:31 +0200
Message-ID: <20180720130906.27687-4-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Máté Eckl <ecklm94@gmail.com>

This function is also necessary to implement nft tproxy support

Fixes: 45ca4e0cf273 ("netfilter: Libify xt_TPROXY")
Signed-off-by: Máté Eckl <ecklm94@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tproxy.h | 8 ++++++++
 net/netfilter/xt_TPROXY.c         | 9 ---------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_tproxy.h b/include/net/netfilter/nf_tproxy.h
index 9754a50ecde9..d5a80888cbe4 100644
--- a/include/net/netfilter/nf_tproxy.h
+++ b/include/net/netfilter/nf_tproxy.h
@@ -17,6 +17,14 @@ static inline bool nf_tproxy_sk_is_transparent(struct sock *sk)
 	return false;
 }
 
+/* assign a socket to the skb -- consumes sk */
+static inline void nf_tproxy_assign_sock(struct sk_buff *skb, struct sock *sk)
+{
+	skb_orphan(skb);
+	skb->sk = sk;
+	skb->destructor = sock_edemux;
+}
+
 __be32 nf_tproxy_laddr4(struct sk_buff *skb, __be32 user_laddr, __be32 daddr);
 
 /**
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 58fce4e749a9..35df0827e2ca 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -36,15 +36,6 @@
 #include <net/netfilter/nf_tproxy.h>
 #include <linux/netfilter/xt_TPROXY.h>
 
-/* assign a socket to the skb -- consumes sk */
-static void
-nf_tproxy_assign_sock(struct sk_buff *skb, struct sock *sk)
-{
-	skb_orphan(skb);
-	skb->sk = sk;
-	skb->destructor = sock_edemux;
-}
-
 static unsigned int
 tproxy_tg4(struct net *net, struct sk_buff *skb, __be32 laddr, __be16 lport,
 	   u_int32_t mark_mask, u_int32_t mark_value)
-- 
2.11.0
