From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 12/15] netfilter: ebtables: adapt the filter and nat table to pernet hooks
Date: Mon, 15 Jun 2015 17:46:54 +0200
Message-ID: <1434383217-13732-13-git-send-email-pablo@netfilter.org>
References: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Cc: ebiederm@xmission.com, aschultz@warp10.net, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36894 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517AbbFOPly (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 11:41:54 -0400
In-Reply-To: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adapts the filter and nat tables to register the hooks for each
netnamespace.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netns/x_tables.h          |    2 ++
 net/bridge/netfilter/ebtable_filter.c |   42 +++++++++++++++++++++++----------
 net/bridge/netfilter/ebtable_nat.c    |   42 +++++++++++++++++++++++----------
 3 files changed, 62 insertions(+), 24 deletions(-)

diff --git a/include/net/netns/x_tables.h b/include/net/netns/x_tables.h
index c8a7681..831af42 100644
--- a/include/net/netns/x_tables.h
+++ b/include/net/netns/x_tables.h
@@ -14,7 +14,9 @@ struct netns_xt {
     defined(CONFIG_BRIDGE_NF_EBTABLES_MODULE)
 	struct ebt_table *broute_table;
 	struct ebt_table *frame_filter;
+	struct nf_hook_ops *frame_filter_ops;
 	struct ebt_table *frame_nat;
+	struct nf_hook_ops *frame_nat_ops;
 #endif
 };
 #endif
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index 9a5a798..2ee938c 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -98,12 +98,40 @@ static struct nf_hook_ops ebt_ops_filter[] __read_mostly = {
 
 static int __net_init frame_filter_net_init(struct net *net)
 {
+	int err;
+
 	net->xt.frame_filter = ebt_register_table(net, &frame_filter);
-	return PTR_ERR_OR_ZERO(net->xt.frame_filter);
+	if (IS_ERR(net->xt.frame_filter)) {
+		err = PTR_ERR(net->xt.frame_filter);
+		goto err1;
+	}
+
+	net->xt.frame_filter_ops =
+		kmemdup(ebt_ops_filter, sizeof(ebt_ops_filter), GFP_KERNEL);
+	if (net->xt.frame_filter_ops == NULL) {
+		err = -ENOMEM;
+		goto err2;
+	}
+
+	err = nf_register_hooks(net, net->xt.frame_filter_ops,
+				ARRAY_SIZE(ebt_ops_filter));
+	if (err < 0)
+		goto err3;
+
+	return 0;
+err3:
+	kfree(net->xt.frame_filter_ops);
+err2:
+	ebt_unregister_table(net, net->xt.frame_filter);
+err1:
+	return err;
 }
 
 static void __net_exit frame_filter_net_exit(struct net *net)
 {
+	nf_unregister_hooks(net->xt.frame_filter_ops,
+			    ARRAY_SIZE(ebt_ops_filter));
+	kfree(net->xt.frame_filter_ops);
 	ebt_unregister_table(net, net->xt.frame_filter);
 }
 
@@ -114,21 +142,11 @@ static struct pernet_operations frame_filter_net_ops = {
 
 static int __init ebtable_filter_init(void)
 {
-	int ret;
-
-	ret = register_pernet_subsys(&frame_filter_net_ops);
-	if (ret < 0)
-		return ret;
-	ret = nf_register_hooks(&init_net, ebt_ops_filter,
-				ARRAY_SIZE(ebt_ops_filter));
-	if (ret < 0)
-		unregister_pernet_subsys(&frame_filter_net_ops);
-	return ret;
+	return register_pernet_subsys(&frame_filter_net_ops);
 }
 
 static void __exit ebtable_filter_fini(void)
 {
-	nf_unregister_hooks(ebt_ops_filter, ARRAY_SIZE(ebt_ops_filter));
 	unregister_pernet_subsys(&frame_filter_net_ops);
 }
 
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index 3d2759d..a787126 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -98,12 +98,40 @@ static struct nf_hook_ops ebt_ops_nat[] __read_mostly = {
 
 static int __net_init frame_nat_net_init(struct net *net)
 {
+	int err;
+
 	net->xt.frame_nat = ebt_register_table(net, &frame_nat);
-	return PTR_ERR_OR_ZERO(net->xt.frame_nat);
+	if (IS_ERR(net->xt.frame_nat)) {
+		err = PTR_ERR(net->xt.frame_nat);
+		goto err1;
+	}
+
+	net->xt.frame_nat_ops =
+		kmemdup(ebt_ops_nat, sizeof(ebt_ops_nat), GFP_KERNEL);
+	if (net->xt.frame_nat_ops == NULL) {
+		err = -ENOMEM;
+		goto err2;
+	}
+
+	err = nf_register_hooks(net, net->xt.frame_nat_ops,
+				ARRAY_SIZE(ebt_ops_nat));
+	if (err < 0)
+		goto err3;
+
+	return 0;
+err3:
+	kfree(net->xt.frame_nat_ops);
+err2:
+	ebt_unregister_table(net, net->xt.frame_nat);
+err1:
+	return err;
 }
 
 static void __net_exit frame_nat_net_exit(struct net *net)
 {
+	nf_unregister_hooks(net->xt.frame_nat_ops,
+			    ARRAY_SIZE(ebt_ops_nat));
+	kfree(net->xt.frame_nat_ops);
 	ebt_unregister_table(net, net->xt.frame_nat);
 }
 
@@ -114,21 +142,11 @@ static struct pernet_operations frame_nat_net_ops = {
 
 static int __init ebtable_nat_init(void)
 {
-	int ret;
-
-	ret = register_pernet_subsys(&frame_nat_net_ops);
-	if (ret < 0)
-		return ret;
-	ret = nf_register_hooks(&init_net, ebt_ops_nat,
-				ARRAY_SIZE(ebt_ops_nat));
-	if (ret < 0)
-		unregister_pernet_subsys(&frame_nat_net_ops);
-	return ret;
+	return register_pernet_subsys(&frame_nat_net_ops);
 }
 
 static void __exit ebtable_nat_fini(void)
 {
-	nf_unregister_hooks(ebt_ops_nat, ARRAY_SIZE(ebt_ops_nat));
 	unregister_pernet_subsys(&frame_nat_net_ops);
 }
 
-- 
1.7.10.4

