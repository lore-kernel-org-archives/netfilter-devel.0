From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 39/47] netfilter: nf_tables: nft_register_chain_type() returns void
Date: Fri, 30 Mar 2018 13:45:01 +0200
Message-ID: <20180330114509.18738-10-pablo@netfilter.org>
References: <20180330114509.18738-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114509.18738-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Use WARN_ON() instead since it should not happen that neither family
goes over NFPROTO_NUMPROTO nor there is already a chain of this type
already registered.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h         |  2 +-
 net/bridge/netfilter/nf_tables_bridge.c   |  4 +++-
 net/ipv4/netfilter/nf_tables_arp.c        |  4 +++-
 net/ipv4/netfilter/nf_tables_ipv4.c       |  4 +++-
 net/ipv4/netfilter/nft_chain_nat_ipv4.c   |  6 +-----
 net/ipv4/netfilter/nft_chain_route_ipv4.c |  4 +++-
 net/ipv6/netfilter/nf_tables_ipv6.c       |  4 +++-
 net/ipv6/netfilter/nft_chain_nat_ipv6.c   |  6 +-----
 net/ipv6/netfilter/nft_chain_route_ipv6.c |  4 +++-
 net/netfilter/nf_tables_api.c             | 14 +++++---------
 net/netfilter/nf_tables_inet.c            |  4 +++-
 net/netfilter/nf_tables_netdev.c          |  4 +---
 12 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4a304997c304..1f7148fe0504 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -970,7 +970,7 @@ struct nft_table {
 	char				*name;
 };
 
-int nft_register_chain_type(const struct nft_chain_type *);
+void nft_register_chain_type(const struct nft_chain_type *);
 void nft_unregister_chain_type(const struct nft_chain_type *);
 
 int nft_register_expr(struct nft_expr_type *);
diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index 73a1ec556a0a..ffb8580dfdac 100644
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ b/net/bridge/netfilter/nf_tables_bridge.c
@@ -63,7 +63,9 @@ static const struct nft_chain_type filter_bridge = {
 
 static int __init nf_tables_bridge_init(void)
 {
-	return nft_register_chain_type(&filter_bridge);
+	nft_register_chain_type(&filter_bridge);
+
+	return 0;
 }
 
 static void __exit nf_tables_bridge_exit(void)
diff --git a/net/ipv4/netfilter/nf_tables_arp.c b/net/ipv4/netfilter/nf_tables_arp.c
index 5b0be2a10b69..c2ee64208743 100644
--- a/net/ipv4/netfilter/nf_tables_arp.c
+++ b/net/ipv4/netfilter/nf_tables_arp.c
@@ -42,7 +42,9 @@ static const struct nft_chain_type filter_arp = {
 
 static int __init nf_tables_arp_init(void)
 {
-	return nft_register_chain_type(&filter_arp);
+	nft_register_chain_type(&filter_arp);
+
+	return 0;
 }
 
 static void __exit nf_tables_arp_exit(void)
diff --git a/net/ipv4/netfilter/nf_tables_ipv4.c b/net/ipv4/netfilter/nf_tables_ipv4.c
index 13bae5cfa257..c09667de0d68 100644
--- a/net/ipv4/netfilter/nf_tables_ipv4.c
+++ b/net/ipv4/netfilter/nf_tables_ipv4.c
@@ -51,7 +51,9 @@ static const struct nft_chain_type filter_ipv4 = {
 
 static int __init nf_tables_ipv4_init(void)
 {
-	return nft_register_chain_type(&filter_ipv4);
+	nft_register_chain_type(&filter_ipv4);
+
+	return 0;
 }
 
 static void __exit nf_tables_ipv4_exit(void)
diff --git a/net/ipv4/netfilter/nft_chain_nat_ipv4.c b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
index 167f377eb1cb..9864f5b3279c 100644
--- a/net/ipv4/netfilter/nft_chain_nat_ipv4.c
+++ b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
@@ -86,11 +86,7 @@ static const struct nft_chain_type nft_chain_nat_ipv4 = {
 
 static int __init nft_chain_nat_init(void)
 {
-	int err;
-
-	err = nft_register_chain_type(&nft_chain_nat_ipv4);
-	if (err < 0)
-		return err;
+	nft_register_chain_type(&nft_chain_nat_ipv4);
 
 	return 0;
 }
diff --git a/net/ipv4/netfilter/nft_chain_route_ipv4.c b/net/ipv4/netfilter/nft_chain_route_ipv4.c
index 48cf1f892314..7d82934c46f4 100644
--- a/net/ipv4/netfilter/nft_chain_route_ipv4.c
+++ b/net/ipv4/netfilter/nft_chain_route_ipv4.c
@@ -71,7 +71,9 @@ static const struct nft_chain_type nft_chain_route_ipv4 = {
 
 static int __init nft_chain_route_init(void)
 {
-	return nft_register_chain_type(&nft_chain_route_ipv4);
+	nft_register_chain_type(&nft_chain_route_ipv4);
+
+	return 0;
 }
 
 static void __exit nft_chain_route_exit(void)
diff --git a/net/ipv6/netfilter/nf_tables_ipv6.c b/net/ipv6/netfilter/nf_tables_ipv6.c
index d99f9ac6f1b6..496f69453457 100644
--- a/net/ipv6/netfilter/nf_tables_ipv6.c
+++ b/net/ipv6/netfilter/nf_tables_ipv6.c
@@ -49,7 +49,9 @@ static const struct nft_chain_type filter_ipv6 = {
 
 static int __init nf_tables_ipv6_init(void)
 {
-	return nft_register_chain_type(&filter_ipv6);
+	nft_register_chain_type(&filter_ipv6);
+
+	return 0;
 }
 
 static void __exit nf_tables_ipv6_exit(void)
diff --git a/net/ipv6/netfilter/nft_chain_nat_ipv6.c b/net/ipv6/netfilter/nft_chain_nat_ipv6.c
index c498aaa8056b..c95d9a97d425 100644
--- a/net/ipv6/netfilter/nft_chain_nat_ipv6.c
+++ b/net/ipv6/netfilter/nft_chain_nat_ipv6.c
@@ -84,11 +84,7 @@ static const struct nft_chain_type nft_chain_nat_ipv6 = {
 
 static int __init nft_chain_nat_ipv6_init(void)
 {
-	int err;
-
-	err = nft_register_chain_type(&nft_chain_nat_ipv6);
-	if (err < 0)
-		return err;
+	nft_register_chain_type(&nft_chain_nat_ipv6);
 
 	return 0;
 }
diff --git a/net/ipv6/netfilter/nft_chain_route_ipv6.c b/net/ipv6/netfilter/nft_chain_route_ipv6.c
index d5c7fdc34256..da3f1f8cb325 100644
--- a/net/ipv6/netfilter/nft_chain_route_ipv6.c
+++ b/net/ipv6/netfilter/nft_chain_route_ipv6.c
@@ -73,7 +73,9 @@ static const struct nft_chain_type nft_chain_route_ipv6 = {
 
 static int __init nft_chain_route_init(void)
 {
-	return nft_register_chain_type(&nft_chain_route_ipv6);
+	nft_register_chain_type(&nft_chain_route_ipv6);
+
+	return 0;
 }
 
 static void __exit nft_chain_route_exit(void)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bf564f491085..9e4b1614ee39 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -859,22 +859,18 @@ static void nf_tables_table_destroy(struct nft_ctx *ctx)
 	kfree(ctx->table);
 }
 
-int nft_register_chain_type(const struct nft_chain_type *ctype)
+void nft_register_chain_type(const struct nft_chain_type *ctype)
 {
-	int err = 0;
-
 	if (WARN_ON(ctype->family >= NFPROTO_NUMPROTO))
-		return -EINVAL;
+		return;
 
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
-	if (chain_type[ctype->family][ctype->type] != NULL) {
-		err = -EBUSY;
-		goto out;
+	if (WARN_ON(chain_type[ctype->family][ctype->type] != NULL)) {
+		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
+		return;
 	}
 	chain_type[ctype->family][ctype->type] = ctype;
-out:
 	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
-	return err;
 }
 EXPORT_SYMBOL_GPL(nft_register_chain_type);
 
diff --git a/net/netfilter/nf_tables_inet.c b/net/netfilter/nf_tables_inet.c
index 0aefe66ce558..202c4219969b 100644
--- a/net/netfilter/nf_tables_inet.c
+++ b/net/netfilter/nf_tables_inet.c
@@ -59,7 +59,9 @@ static const struct nft_chain_type filter_inet = {
 
 static int __init nf_tables_inet_init(void)
 {
-	return nft_register_chain_type(&filter_inet);
+	nft_register_chain_type(&filter_inet);
+
+	return 0;
 }
 
 static void __exit nf_tables_inet_exit(void)
diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
index 88ea959211ac..4c3835bca63e 100644
--- a/net/netfilter/nf_tables_netdev.c
+++ b/net/netfilter/nf_tables_netdev.c
@@ -112,9 +112,7 @@ static int __init nf_tables_netdev_init(void)
 {
 	int ret;
 
-	ret = nft_register_chain_type(&nft_filter_chain_netdev);
-	if (ret)
-		return ret;
+	nft_register_chain_type(&nft_filter_chain_netdev);
 
 	ret = register_netdevice_notifier(&nf_tables_netdev_notifier);
 	if (ret)
-- 
2.11.0
