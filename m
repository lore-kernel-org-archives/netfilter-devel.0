From: pablo@netfilter.org
Subject: [PATCH 5/7] netfilter: nf_tables: x_tables support as a compile time option
Date: Thu, 10 Jan 2013 16:28:39 +0100
Message-ID: <1357831721-10182-5-git-send-email-pablo@netfilter.org>
References: <1357831721-10182-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37143 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907Ab3AJP27 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:28:59 -0500
In-Reply-To: <1357831721-10182-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Restore Make x_tables over nf_tables as optional module at compile
time. The main reason for this is the dependency on x_tables symbols.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_core.h |    3 ---
 net/netfilter/Kconfig                  |    9 +++++++++
 net/netfilter/Makefile                 |    3 ++-
 net/netfilter/nf_tables_core.c         |    6 ------
 net/netfilter/nft_compat.c             |   12 ++++++++++--
 5 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 12a568a..fe7b162 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -39,7 +39,4 @@ extern const struct nft_expr_ops nft_payload_fast_ops;
 extern int nft_payload_module_init(void);
 extern void nft_payload_module_exit(void);
 
-extern int nft_compat_module_init(void);
-extern void nft_compat_module_exit(void);
-
 #endif /* _NET_NF_TABLES_CORE_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 9ba8d0e..7d1c3c0 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -474,6 +474,15 @@ config NFT_NAT
        depends on NF_CONNTRACK
        tristate "Netfilter nf_tables nat module"
 
+config NFT_COMPAT
+       depends on NF_TABLES
+       select NETFILTER_XTABLES
+       tristate "Netfilter x_tables over nf_tables module"
+       help
+	 This is required if you intend to use any of existing
+	 x_tables match/target extensions over the nf_tables
+	 framework.
+
 if NETFILTER_XTABLES
 
 comment "Xtables combined modules"
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 1e9b653..9733bed 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -64,11 +64,12 @@ obj-$(CONFIG_NF_NAT_TFTP) += nf_nat_tftp.o
 obj-$(CONFIG_NETFILTER_TPROXY) += nf_tproxy_core.o
 
 # nf_tables
-nf_tables-objs += nf_tables_core.o nf_tables_api.o nft_compat.o
+nf_tables-objs += nf_tables_core.o nf_tables_api.o
 nf_tables-objs += nft_immediate.o nft_cmp.o nft_lookup.o
 nf_tables-objs += nft_bitwise.o nft_byteorder.o nft_payload.o
 
 obj-$(CONFIG_NF_TABLES)		+= nf_tables.o
+obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
 obj-$(CONFIG_NFT_EXTHDR)	+= nft_exthdr.o
 obj-$(CONFIG_NFT_META)		+= nft_meta.o
 obj-$(CONFIG_NFT_CT)		+= nft_ct.o
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index a87a5b7..b9917b7 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -159,13 +159,8 @@ int __init nf_tables_core_module_init(void)
 	if (err < 0)
 		goto err6;
 
-	err = nft_compat_module_init();
-	if (err < 0)
-		goto err7;
-
 	return 0;
 
-err7:
 	nft_payload_module_exit();
 err6:
 	nft_byteorder_module_exit();
@@ -183,7 +178,6 @@ err1:
 
 void nf_tables_core_module_exit(void)
 {
-	nft_compat_module_exit();
 	nft_payload_module_exit();
 	nft_byteorder_module_exit();
 	nft_bitwise_module_exit();
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 1bd642c..9f84e23 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -548,7 +548,7 @@ static struct nft_expr_type nft_target_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
-int __init nft_compat_module_init(void)
+static int __init nft_compat_module_init(void)
 {
 	int ret;
 
@@ -577,7 +577,7 @@ err_match:
 	return ret;
 }
 
-void nft_compat_module_exit(void)
+static void __exit nft_compat_module_exit(void)
 {
 	nfnetlink_subsys_unregister(&nfnl_compat_subsys);
 	nft_unregister_expr(&nft_target_type);
@@ -587,3 +587,11 @@ void nft_compat_module_exit(void)
 }
 
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_NFTA_COMPAT);
+
+module_init(nft_compat_module_init);
+module_exit(nft_compat_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_ALIAS_NFT_EXPR("match");
+MODULE_ALIAS_NFT_EXPR("target");
-- 
1.7.10.4

