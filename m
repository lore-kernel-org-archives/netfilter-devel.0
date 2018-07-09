From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] netfilter: NFT_SOCKET don't use NF_SOCKET_IPV6 without NF_TABLES_IPV6
Date: Mon,  9 Jul 2018 23:35:09 +0200
Message-ID: <20180709213537.2748896-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?M=C3=A1t=C3=A9=20Eckl?= <ecklm94@gmail.com>,
        Flavio Leitner <fbl@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

It is now possible to build the nft_socket module as built-in when
NF_TABLES_IPV6 is disabled, and have NF_SOCKET_IPV6=m set manually.

In this case, the NF_SOCKET_IPV6 functionality will be useless according
to the explanation in commit 35bf1ccecaaa ("netfilter: Kconfig: Change
IPv6 select dependencies"), but on top of that it also causes a link
error:

net/netfilter/nft_socket.o: In function `nft_socket_eval':
nft_socket.c:(.text+0x162): undefined reference to `nf_sk_lookup_slow_v6'

This changes the compile-time check so we don't attempt to use
the NF_SOCKET_IPV6 code when it cannot be used, and make it all
compile again. That may lead to unexpected behavior when a user
enables NF_SOCKET_IPV6 but cannot use it, but seems to be the
logical conclusion of the 35bf1ccecaaa change.

Fixes: 35bf1ccecaaa ("netfilter: Kconfig: Change IPv6 select dependencies")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
---
 net/netfilter/nft_socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 998c2b546f6d..e43c1939d25f 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -31,7 +31,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		case NFPROTO_IPV4:
 			sk = nf_sk_lookup_slow_v4(nft_net(pkt), skb, nft_in(pkt));
 			break;
-#if IS_ENABLED(CONFIG_NF_SOCKET_IPV6)
+#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
 		case NFPROTO_IPV6:
 			sk = nf_sk_lookup_slow_v6(nft_net(pkt), skb, nft_in(pkt));
 			break;
@@ -77,7 +77,7 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 
 	switch(ctx->family) {
 	case NFPROTO_IPV4:
-#if IS_ENABLED(CONFIG_NF_SOCKET_IPV6)
+#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
 	case NFPROTO_IPV6:
 #endif
 	case NFPROTO_INET:
-- 
2.9.0
