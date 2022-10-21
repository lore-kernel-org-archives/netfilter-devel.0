Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AFB2C433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Oct 2022 14:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiJUOSJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Oct 2022 10:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiJUOSI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2022 10:18:08 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB98B27C97A
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2022 07:18:07 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1olsqb-0006YU-Dn; Fri, 21 Oct 2022 16:18:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nf_tables: nft_objref: make it builtin
Date:   Fri, 21 Oct 2022 16:17:53 +0200
Message-Id: <20221021141753.106524-1-fw@strlen.de>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft_objref is needed to reference named objects, it makes
no sense to disable it.

Before:
   text	   data	    bss	    dec	 filename
  4014	    424	      0	   4438	 nft_objref.o
  4174	   1128	      0	   5302	 nft_objref.ko
359351	  15276	    864	 375491	 nf_tables.ko
After:
  text	   data	    bss	    dec	 filename
  3815	    408	      0	   4223	 nft_objref.o
363161	  15692	    864	 379717	 nf_tables.ko

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables_core.h |  1 +
 net/netfilter/Kconfig                  |  6 ------
 net/netfilter/Makefile                 |  3 +--
 net/netfilter/nf_tables_core.c         |  1 +
 net/netfilter/nft_objref.c             | 22 +---------------------
 5 files changed, 4 insertions(+), 29 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 1223af68cd9a..33b959d74620 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -18,6 +18,7 @@ extern struct nft_expr_type nft_meta_type;
 extern struct nft_expr_type nft_rt_type;
 extern struct nft_expr_type nft_exthdr_type;
 extern struct nft_expr_type nft_last_type;
+extern struct nft_expr_type nft_objref_type;
 
 #ifdef CONFIG_NETWORK_SECMARK
 extern struct nft_object_type nft_secmark_obj_type;
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 4b8d04640ff3..0846bd75b1da 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -568,12 +568,6 @@ config NFT_TUNNEL
 	  This option adds the "tunnel" expression that you can use to set
 	  tunneling policies.
 
-config NFT_OBJREF
-	tristate "Netfilter nf_tables stateful object reference module"
-	help
-	  This option adds the "objref" expression that allows you to refer to
-	  stateful objects, such as counters and quotas.
-
 config NFT_QUEUE
 	depends on NETFILTER_NETLINK_QUEUE
 	tristate "Netfilter nf_tables queue module"
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 0f060d100880..c49a317194f4 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -88,7 +88,7 @@ nf_tables-objs := nf_tables_core.o nf_tables_api.o nft_chain_filter.o \
 		  nft_dynset.o nft_meta.o nft_rt.o nft_exthdr.o nft_last.o \
 		  nft_counter.o nft_chain_route.o nf_tables_offload.o \
 		  nft_set_hash.o nft_set_bitmap.o nft_set_rbtree.o \
-		  nft_set_pipapo.o
+		  nft_set_pipapo.o nft_objref.o
 
 ifdef CONFIG_X86_64
 ifndef CONFIG_UML
@@ -104,7 +104,6 @@ obj-$(CONFIG_NFT_CT)		+= nft_ct.o
 obj-$(CONFIG_NFT_FLOW_OFFLOAD)	+= nft_flow_offload.o
 obj-$(CONFIG_NFT_LIMIT)		+= nft_limit.o
 obj-$(CONFIG_NFT_NAT)		+= nft_nat.o
-obj-$(CONFIG_NFT_OBJREF)	+= nft_objref.o
 obj-$(CONFIG_NFT_QUEUE)		+= nft_queue.o
 obj-$(CONFIG_NFT_QUOTA)		+= nft_quota.o
 obj-$(CONFIG_NFT_REJECT) 	+= nft_reject.o
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index cee3e4e905ec..6dcead50208c 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -340,6 +340,7 @@ static struct nft_expr_type *nft_basic_types[] = {
 	&nft_exthdr_type,
 	&nft_last_type,
 	&nft_counter_type,
+	&nft_objref_type,
 };
 
 static struct nft_object_type *nft_basic_objects[] = {
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 5d8d91b3904d..74e0eea4abac 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -82,7 +82,6 @@ static void nft_objref_activate(const struct nft_ctx *ctx,
 	obj->use++;
 }
 
-static struct nft_expr_type nft_objref_type;
 static const struct nft_expr_ops nft_objref_ops = {
 	.type		= &nft_objref_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_object *)),
@@ -195,7 +194,6 @@ static void nft_objref_map_destroy(const struct nft_ctx *ctx,
 	nf_tables_destroy_set(ctx, priv->set);
 }
 
-static struct nft_expr_type nft_objref_type;
 static const struct nft_expr_ops nft_objref_map_ops = {
 	.type		= &nft_objref_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_objref_map)),
@@ -233,28 +231,10 @@ static const struct nla_policy nft_objref_policy[NFTA_OBJREF_MAX + 1] = {
 	[NFTA_OBJREF_SET_ID]	= { .type = NLA_U32 },
 };
 
-static struct nft_expr_type nft_objref_type __read_mostly = {
+struct nft_expr_type nft_objref_type __read_mostly = {
 	.name		= "objref",
 	.select_ops	= nft_objref_select_ops,
 	.policy		= nft_objref_policy,
 	.maxattr	= NFTA_OBJREF_MAX,
 	.owner		= THIS_MODULE,
 };
-
-static int __init nft_objref_module_init(void)
-{
-	return nft_register_expr(&nft_objref_type);
-}
-
-static void __exit nft_objref_module_exit(void)
-{
-	nft_unregister_expr(&nft_objref_type);
-}
-
-module_init(nft_objref_module_init);
-module_exit(nft_objref_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
-MODULE_ALIAS_NFT_EXPR("objref");
-MODULE_DESCRIPTION("nftables stateful object reference module");
-- 
2.37.3

