From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 40/51] netfilter: nf_tables: merge rt expression into nft core
Date: Mon,  7 May 2018 00:46:58 +0200
Message-ID: <20180506224709.29100-41-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

before:
   text    data     bss     dec     hex filename
   2657     844       0    3501     dad net/netfilter/nft_rt.ko
 100826    2240     401  103467   1942b net/netfilter/nf_tables.ko
after:
   2657     844       0    3501     dad net/netfilter/nft_rt.ko
 102456    2316     401  105173   19ad5 net/netfilter/nf_tables.ko

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_core.h |  1 +
 net/netfilter/Kconfig                  |  6 ------
 net/netfilter/Makefile                 |  3 +--
 net/netfilter/nf_tables_core.c         |  1 +
 net/netfilter/nft_rt.c                 | 22 +---------------------
 5 files changed, 4 insertions(+), 29 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 3339cce8f585..d6a358ae3749 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -11,6 +11,7 @@ extern struct nft_expr_type nft_payload_type;
 extern struct nft_expr_type nft_dynset_type;
 extern struct nft_expr_type nft_range_type;
 extern struct nft_expr_type nft_meta_type;
+extern struct nft_expr_type nft_rt_type;
 
 int nf_tables_core_module_init(void);
 void nf_tables_core_module_exit(void);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 29a13c7a5af2..771f1a4f3376 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -480,12 +480,6 @@ config NFT_EXTHDR
 	  This option adds the "exthdr" expression that you can use to match
 	  IPv6 extension headers and tcp options.
 
-config NFT_RT
-	tristate "Netfilter nf_tables routing module"
-	help
-	  This option adds the "rt" expression that you can use to match
-	  packet routing information such as the packet nexthop.
-
 config NFT_NUMGEN
 	tristate "Netfilter nf_tables number generator module"
 	help
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 89634c389fe7..128dbcfaa194 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -76,12 +76,11 @@ obj-$(CONFIG_NF_DUP_NETDEV)	+= nf_dup_netdev.o
 nf_tables-objs := nf_tables_core.o nf_tables_api.o nft_chain_filter.o \
 		  nf_tables_trace.o nft_immediate.o nft_cmp.o nft_range.o \
 		  nft_bitwise.o nft_byteorder.o nft_payload.o nft_lookup.o \
-		  nft_dynset.o nft_meta.o
+		  nft_dynset.o nft_meta.o nft_rt.o
 
 obj-$(CONFIG_NF_TABLES)		+= nf_tables.o
 obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
 obj-$(CONFIG_NFT_EXTHDR)	+= nft_exthdr.o
-obj-$(CONFIG_NFT_RT)		+= nft_rt.o
 obj-$(CONFIG_NFT_NUMGEN)	+= nft_numgen.o
 obj-$(CONFIG_NFT_CT)		+= nft_ct.o
 obj-$(CONFIG_NFT_FLOW_OFFLOAD)	+= nft_flow_offload.o
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index b67d6577f767..481ce2c0bbbf 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -252,6 +252,7 @@ static struct nft_expr_type *nft_basic_types[] = {
 	&nft_dynset_type,
 	&nft_range_type,
 	&nft_meta_type,
+	&nft_rt_type,
 };
 
 int __init nf_tables_core_module_init(void)
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index 11a2071b6dd4..76dba9f6b6f6 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -7,8 +7,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/module.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
@@ -179,7 +177,6 @@ static int nft_rt_validate(const struct nft_ctx *ctx, const struct nft_expr *exp
 	return nft_chain_validate_hooks(ctx->chain, hooks);
 }
 
-static struct nft_expr_type nft_rt_type;
 static const struct nft_expr_ops nft_rt_get_ops = {
 	.type		= &nft_rt_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_rt)),
@@ -189,27 +186,10 @@ static const struct nft_expr_ops nft_rt_get_ops = {
 	.validate	= nft_rt_validate,
 };
 
-static struct nft_expr_type nft_rt_type __read_mostly = {
+struct nft_expr_type nft_rt_type __read_mostly = {
 	.name		= "rt",
 	.ops		= &nft_rt_get_ops,
 	.policy		= nft_rt_policy,
 	.maxattr	= NFTA_RT_MAX,
 	.owner		= THIS_MODULE,
 };
-
-static int __init nft_rt_module_init(void)
-{
-	return nft_register_expr(&nft_rt_type);
-}
-
-static void __exit nft_rt_module_exit(void)
-{
-	nft_unregister_expr(&nft_rt_type);
-}
-
-module_init(nft_rt_module_init);
-module_exit(nft_rt_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Anders K. Pedersen <akp@cohaesio.com>");
-MODULE_ALIAS_NFT_EXPR("rt");
-- 
2.11.0
