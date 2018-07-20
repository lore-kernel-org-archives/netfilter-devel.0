From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 16/38] netfilter: Kconfig: Change select IPv6 dependencies
Date: Fri, 20 Jul 2018 15:08:44 +0200
Message-ID: <20180720130906.27687-17-pablo@netfilter.org>
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

... from IPV6 to NF_TABLES_IPV6 and IP6_NF_IPTABLES.

In some cases module selects depend on IPV6, but this means that they
select another module even if eg. NF_TABLES_IPV6 is not set in which
case the selected module is useless due to the lack of IPv6 nf_tables
functionality.

The same applies for IP6_NF_IPTABLES and iptables.

Joint work with: Arnd Bermann <arnd@arndb.de>

Signed-off-by: Máté Eckl <ecklm94@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig      | 6 +++---
 net/netfilter/nft_socket.c | 4 ++--
 net/netfilter/xt_TEE.c     | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 9eab519b403a..e0ab50c58dc4 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -628,7 +628,7 @@ config NFT_SOCKET
 	tristate "Netfilter nf_tables socket match support"
 	depends on IPV6 || IPV6=n
 	select NF_SOCKET_IPV4
-	select NF_SOCKET_IPV6 if IPV6
+	select NF_SOCKET_IPV6 if NF_TABLES_IPV6
 	help
 	  This option allows matching for the presence or absence of a
 	  corresponding socket and its attributes.
@@ -894,7 +894,7 @@ config NETFILTER_XT_TARGET_LOG
 	tristate "LOG target support"
 	select NF_LOG_COMMON
 	select NF_LOG_IPV4
-	select NF_LOG_IPV6 if IPV6
+	select NF_LOG_IPV6 if IP6_NF_IPTABLES
 	default m if NETFILTER_ADVANCED=n
 	help
 	  This option adds a `LOG' target, which allows you to create rules in
@@ -986,7 +986,7 @@ config NETFILTER_XT_TARGET_TEE
 	depends on IPV6 || IPV6=n
 	depends on !NF_CONNTRACK || NF_CONNTRACK
 	select NF_DUP_IPV4
-	select NF_DUP_IPV6 if IPV6
+	select NF_DUP_IPV6 if IP6_NF_IPTABLES
 	---help---
 	This option adds a "TEE" target with which a packet can be cloned and
 	this clone be rerouted to another nexthop.
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
diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index 475957cfcf50..0d0d68c989df 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -38,7 +38,7 @@ tee_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	return XT_CONTINUE;
 }
 
-#if IS_ENABLED(CONFIG_IPV6)
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 static unsigned int
 tee_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -141,7 +141,7 @@ static struct xt_target tee_tg_reg[] __read_mostly = {
 		.destroy    = tee_tg_destroy,
 		.me         = THIS_MODULE,
 	},
-#if IS_ENABLED(CONFIG_IPV6)
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	{
 		.name       = "TEE",
 		.revision   = 1,
-- 
2.11.0
