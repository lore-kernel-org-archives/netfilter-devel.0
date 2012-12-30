From: pablo@netfilter.org
Subject: [PATCH 1/4] netfilter: nf_tables: rise maximum number of expressions from 12 to 128
Date: Mon, 31 Dec 2012 00:23:13 +0100
Message-ID: <1356909796-3143-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56035 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205Ab2L3XX1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Dec 2012 18:23:27 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Use kmalloc'ed memory area to store the parsed expressions instead of
using the stack. This allows us to raise the maximum number of
expressions in one rule.

In 64-bits arch, this requires 17408 bytes for our allocated
struct nft_expr_info.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fc596b5..a847375 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1332,7 +1332,9 @@ static void nf_tables_rule_destroy(struct nft_rule *rule)
 	call_rcu(&rule->rcu_head, nf_tables_rcu_rule_destroy);
 }
 
-#define NFT_RULE_MAXEXPRS	12
+#define NFT_RULE_MAXEXPRS	128
+
+static struct nft_expr_info *info;
 
 static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 			     const struct nlmsghdr *nlh,
@@ -1343,7 +1345,6 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_table *table;
 	struct nft_chain *chain;
 	struct nft_rule *rule, *old_rule = NULL;
-	struct nft_expr_info info[NFT_RULE_MAXEXPRS];
 	struct nft_expr *expr;
 	struct nft_ctx ctx;
 	struct nlattr *tmp;
@@ -2859,22 +2860,30 @@ static int __init nf_tables_module_init(void)
 {
 	int err;
 
+	info = kmalloc(sizeof(struct nft_expr_info) * NFT_RULE_MAXEXPRS,
+		       GFP_KERNEL);
+	if (info == NULL) {
+		err = -ENOMEM;
+		goto err1;
+	}
+
 	err = nf_tables_core_module_init();
 	if (err < 0)
-		goto err1;
+		goto err2;
 
 	err = nfnetlink_subsys_register(&nf_tables_subsys);
 	if (err < 0)
-		goto err2;
+		goto err3;
 
 	nft_register_chain_type(&filter_ipv4);
 	nft_register_chain_type(&filter_ipv6);
 
 	pr_info("nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>\n");
 	return 0;
-
-err2:
+err3:
 	nf_tables_core_module_exit();
+err2:
+	kfree(info);
 err1:
 	return err;
 }
@@ -2885,6 +2894,7 @@ static void __exit nf_tables_module_exit(void)
 	nft_unregister_chain_type(&filter_ipv6);
 	nfnetlink_subsys_unregister(&nf_tables_subsys);
 	nf_tables_core_module_exit();
+	kfree(info);
 }
 
 module_init(nf_tables_module_init);
-- 
1.7.10.4

