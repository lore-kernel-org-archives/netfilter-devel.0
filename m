From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/6] netfilter: xt_socket: check sk before checking for netns.
Date: Tue,  2 Oct 2018 00:37:45 +0200
Message-ID: <20181001223745.29010-7-pablo@netfilter.org>
References: <20181001223745.29010-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181001223745.29010-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Flavio Leitner <fbl@redhat.com>

Only check for the network namespace if the socket is available.

Fixes: f564650106a6 ("netfilter: check if the socket netns is correct.")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Flavio Leitner <fbl@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 0472f3472842..ada144e5645b 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -56,7 +56,7 @@ socket_match(const struct sk_buff *skb, struct xt_action_param *par,
 	struct sk_buff *pskb = (struct sk_buff *)skb;
 	struct sock *sk = skb->sk;
 
-	if (!net_eq(xt_net(par), sock_net(sk)))
+	if (sk && !net_eq(xt_net(par), sock_net(sk)))
 		sk = NULL;
 
 	if (!sk)
@@ -117,7 +117,7 @@ socket_mt6_v1_v2_v3(const struct sk_buff *skb, struct xt_action_param *par)
 	struct sk_buff *pskb = (struct sk_buff *)skb;
 	struct sock *sk = skb->sk;
 
-	if (!net_eq(xt_net(par), sock_net(sk)))
+	if (sk && !net_eq(xt_net(par), sock_net(sk)))
 		sk = NULL;
 
 	if (!sk)
-- 
2.11.0
