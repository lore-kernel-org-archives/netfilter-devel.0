From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 41/51] netfilter: nf_tables: merge exthdr expression into nft core
Date: Mon,  7 May 2018 00:46:59 +0200
Message-ID: <20180506224709.29100-42-pablo@netfilter.org>
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
   5056     844       0    5900    170c net/netfilter/nft_exthdr.ko
 102456    2316     401  105173   19ad5 net/netfilter/nf_tables.ko

after:
 106410    2392     401  109203   1aa93 net/netfilter/nf_tables.ko

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_core.h |  1 +
 net/netfilter/Kconfig                  |  6 ------
 net/netfilter/Makefile                 |  3 +--
 net/netfilter/nf_tables_core.c         |  1 +
 net/netfilter/nft_exthdr.c             | 23 ++---------------------
 5 files changed, 5 insertions(+), 29 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index d6a358ae3749..cd6915b6c054 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -12,6 +12,7 @@ extern struct nft_expr_type nft_dynset_type;
 extern struct nft_expr_type nft_range_type;
 extern struct nft_expr_type nft_meta_type;
 extern struct nft_expr_type nft_rt_type;
+extern struct nft_expr_type nft_exthdr_type;
 
 int nf_tables_core_module_init(void);
 void nf_tables_core_module_exit(void);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 771f1a4f3376..f66586fb41cd 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -474,12 +474,6 @@ config NF_TABLES_NETDEV
 	help
 	  This option enables support for the "netdev" table.
 
-config NFT_EXTHDR
-	tristate "Netfilter nf_tables exthdr module"
-	help
-	  This option adds the "exthdr" expression that you can use to match
-	  IPv6 extension headers and tcp options.
-
 config NFT_NUMGEN
 	tristate "Netfilter nf_tables number generator module"
 	help
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 128dbcfaa194..b37ce0bc9ab7 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -76,11 +76,10 @@ obj-$(CONFIG_NF_DUP_NETDEV)	+= nf_dup_netdev.o
 nf_tables-objs := nf_tables_core.o nf_tables_api.o nft_chain_filter.o \
 		  nf_tables_trace.o nft_immediate.o nft_cmp.o nft_range.o \
 		  nft_bitwise.o nft_byteorder.o nft_payload.o nft_lookup.o \
-		  nft_dynset.o nft_meta.o nft_rt.o
+		  nft_dynset.o nft_meta.o nft_rt.o nft_exthdr.o
 
 obj-$(CONFIG_NF_TABLES)		+= nf_tables.o
 obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
-obj-$(CONFIG_NFT_EXTHDR)	+= nft_exthdr.o
 obj-$(CONFIG_NFT_NUMGEN)	+= nft_numgen.o
 obj-$(CONFIG_NFT_CT)		+= nft_ct.o
 obj-$(CONFIG_NFT_FLOW_OFFLOAD)	+= nft_flow_offload.o
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 481ce2c0bbbf..9cf47c4cb9d5 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -253,6 +253,7 @@ static struct nft_expr_type *nft_basic_types[] = {
 	&nft_range_type,
 	&nft_meta_type,
 	&nft_rt_type,
+	&nft_exthdr_type,
 };
 
 int __init nf_tables_core_module_init(void)
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 47ec1046ad11..a940c9fd9045 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -10,11 +10,10 @@
 
 #include <asm/unaligned.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/module.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/tcp.h>
 
@@ -353,7 +352,6 @@ static int nft_exthdr_dump_set(struct sk_buff *skb, const struct nft_expr *expr)
 	return nft_exthdr_dump_common(skb, priv);
 }
 
-static struct nft_expr_type nft_exthdr_type;
 static const struct nft_expr_ops nft_exthdr_ipv6_ops = {
 	.type		= &nft_exthdr_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr)),
@@ -407,27 +405,10 @@ nft_exthdr_select_ops(const struct nft_ctx *ctx,
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
-static struct nft_expr_type nft_exthdr_type __read_mostly = {
+struct nft_expr_type nft_exthdr_type __read_mostly = {
 	.name		= "exthdr",
 	.select_ops	= nft_exthdr_select_ops,
 	.policy		= nft_exthdr_policy,
 	.maxattr	= NFTA_EXTHDR_MAX,
 	.owner		= THIS_MODULE,
 };
-
-static int __init nft_exthdr_module_init(void)
-{
-	return nft_register_expr(&nft_exthdr_type);
-}
-
-static void __exit nft_exthdr_module_exit(void)
-{
-	nft_unregister_expr(&nft_exthdr_type);
-}
-
-module_init(nft_exthdr_module_init);
-module_exit(nft_exthdr_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_EXPR("exthdr");
-- 
2.11.0
