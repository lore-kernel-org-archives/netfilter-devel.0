From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 39/51] netfilter: nf_tables: make meta expression builtin
Date: Mon,  7 May 2018 00:46:57 +0200
Message-ID: <20180506224709.29100-40-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

size net/netfilter/nft_meta.ko
   text    data     bss     dec     hex filename
   5826     936       1    6763    1a6b net/netfilter/nft_meta.ko
  96407    2064     400   98871   18237 net/netfilter/nf_tables.ko

after:
 100826    2240     401  103467   1942b net/netfilter/nf_tables.ko

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_core.h |  1 +
 net/netfilter/Kconfig                  |  6 ------
 net/netfilter/Makefile                 |  3 +--
 net/netfilter/nf_tables_core.c         |  1 +
 net/netfilter/nft_meta.c               | 22 +---------------------
 5 files changed, 4 insertions(+), 29 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index ea5aab568be8..3339cce8f585 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -10,6 +10,7 @@ extern struct nft_expr_type nft_byteorder_type;
 extern struct nft_expr_type nft_payload_type;
 extern struct nft_expr_type nft_dynset_type;
 extern struct nft_expr_type nft_range_type;
+extern struct nft_expr_type nft_meta_type;
 
 int nf_tables_core_module_init(void);
 void nf_tables_core_module_exit(void);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index d20664b02ae4..29a13c7a5af2 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -480,12 +480,6 @@ config NFT_EXTHDR
 	  This option adds the "exthdr" expression that you can use to match
 	  IPv6 extension headers and tcp options.
 
-config NFT_META
-	tristate "Netfilter nf_tables meta module"
-	help
-	  This option adds the "meta" expression that you can use to match and
-	  to set packet metainformation such as the packet mark.
-
 config NFT_RT
 	tristate "Netfilter nf_tables routing module"
 	help
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 3103ed1efe17..89634c389fe7 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -76,12 +76,11 @@ obj-$(CONFIG_NF_DUP_NETDEV)	+= nf_dup_netdev.o
 nf_tables-objs := nf_tables_core.o nf_tables_api.o nft_chain_filter.o \
 		  nf_tables_trace.o nft_immediate.o nft_cmp.o nft_range.o \
 		  nft_bitwise.o nft_byteorder.o nft_payload.o nft_lookup.o \
-		  nft_dynset.o
+		  nft_dynset.o nft_meta.o
 
 obj-$(CONFIG_NF_TABLES)		+= nf_tables.o
 obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
 obj-$(CONFIG_NFT_EXTHDR)	+= nft_exthdr.o
-obj-$(CONFIG_NFT_META)		+= nft_meta.o
 obj-$(CONFIG_NFT_RT)		+= nft_rt.o
 obj-$(CONFIG_NFT_NUMGEN)	+= nft_numgen.o
 obj-$(CONFIG_NFT_CT)		+= nft_ct.o
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index dfd0bf3810d2..b67d6577f767 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -251,6 +251,7 @@ static struct nft_expr_type *nft_basic_types[] = {
 	&nft_payload_type,
 	&nft_dynset_type,
 	&nft_range_type,
+	&nft_meta_type,
 };
 
 int __init nf_tables_core_module_init(void)
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 6c0b82628117..5348bd058c88 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -11,8 +11,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/module.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
@@ -495,7 +493,6 @@ static void nft_meta_set_destroy(const struct nft_ctx *ctx,
 		static_branch_dec(&nft_trace_enabled);
 }
 
-static struct nft_expr_type nft_meta_type;
 static const struct nft_expr_ops nft_meta_get_ops = {
 	.type		= &nft_meta_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
@@ -534,27 +531,10 @@ nft_meta_select_ops(const struct nft_ctx *ctx,
 	return ERR_PTR(-EINVAL);
 }
 
-static struct nft_expr_type nft_meta_type __read_mostly = {
+struct nft_expr_type nft_meta_type __read_mostly = {
 	.name		= "meta",
 	.select_ops	= nft_meta_select_ops,
 	.policy		= nft_meta_policy,
 	.maxattr	= NFTA_META_MAX,
 	.owner		= THIS_MODULE,
 };
-
-static int __init nft_meta_module_init(void)
-{
-	return nft_register_expr(&nft_meta_type);
-}
-
-static void __exit nft_meta_module_exit(void)
-{
-	nft_unregister_expr(&nft_meta_type);
-}
-
-module_init(nft_meta_module_init);
-module_exit(nft_meta_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_EXPR("meta");
-- 
2.11.0
