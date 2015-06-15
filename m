From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 07/15] netfilter: x_tables: adapt tables to pernet hooks
Date: Mon, 15 Jun 2015 17:46:49 +0200
Message-ID: <1434383217-13732-8-git-send-email-pablo@netfilter.org>
References: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Cc: ebiederm@xmission.com, aschultz@warp10.net, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36893 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287AbbFOPly (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 11:41:54 -0400
In-Reply-To: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To achieve this, this patch moves struct nf_hook_ops to the xt_table struct.
This has a nice side effect since this simplifies the boiler plate code that
registers a table.

There is one exception though, since NAT tables are special given that
their hooks have different priorities. To address this, they use the new
__ip{6}t_register_table() and __ip{6}_unregister_table() that don't call
xt_hook_link(). Then, these table manually register the hooks and attach
the nf_hooks_ops to the new xt_table field.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h        |    2 ++
 include/linux/netfilter_arp/arp_tables.h  |    3 +-
 include/linux/netfilter_ipv4/ip_tables.h  |    8 ++++-
 include/linux/netfilter_ipv6/ip6_tables.h |    8 ++++-
 net/ipv4/netfilter/arp_tables.c           |   15 +++++++-
 net/ipv4/netfilter/arptable_filter.c      |   26 +++-----------
 net/ipv4/netfilter/ip_tables.c            |   46 +++++++++++++++++++++---
 net/ipv4/netfilter/iptable_filter.c       |   22 ++----------
 net/ipv4/netfilter/iptable_mangle.c       |   22 ++----------
 net/ipv4/netfilter/iptable_nat.c          |   55 ++++++++++++++++++-----------
 net/ipv4/netfilter/iptable_raw.c          |   20 ++---------
 net/ipv4/netfilter/iptable_security.c     |   25 ++-----------
 net/ipv6/netfilter/ip6_tables.c           |   42 ++++++++++++++++++++--
 net/ipv6/netfilter/ip6table_filter.c      |   26 ++------------
 net/ipv6/netfilter/ip6table_mangle.c      |   25 ++-----------
 net/ipv6/netfilter/ip6table_nat.c         |   55 ++++++++++++++++++-----------
 net/ipv6/netfilter/ip6table_raw.c         |   24 ++-----------
 net/ipv6/netfilter/ip6table_security.c    |   25 ++-----------
 18 files changed, 210 insertions(+), 239 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 8344092..7d6c808 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -192,6 +192,8 @@ struct xt_table {
 	/* Man behind the curtain... */
 	struct xt_table_info *private;
 
+	struct nf_hook_ops *ops;
+
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
 
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index c22a7fb..9d8d25d 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -50,7 +50,8 @@ struct arpt_error {
 extern void *arpt_alloc_initial_table(const struct xt_table *);
 extern struct xt_table *arpt_register_table(struct net *net,
 					    const struct xt_table *table,
-					    const struct arpt_replace *repl);
+					    const struct arpt_replace *repl,
+					    nf_hookfn *hookfn);
 extern void arpt_unregister_table(struct xt_table *table);
 extern unsigned int arpt_do_table(struct sk_buff *skb,
 				  unsigned int hook,
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 4073510..aae5b92 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -26,9 +26,15 @@ extern void ipt_init(void) __init;
 
 extern struct xt_table *ipt_register_table(struct net *net,
 					   const struct xt_table *table,
-					   const struct ipt_replace *repl);
+					   const struct ipt_replace *repl,
+					   nf_hookfn *hookfn);
 extern void ipt_unregister_table(struct net *net, struct xt_table *table);
 
+extern struct xt_table *__ipt_register_table(struct net *net,
+					     const struct xt_table *table,
+					     const struct ipt_replace *repl);
+extern void __ipt_unregister_table(struct net *net, struct xt_table *table);
+
 /* Standard entry. */
 struct ipt_standard {
 	struct ipt_entry entry;
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index b40d2b6..2fdabe2 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -27,8 +27,14 @@ extern void ip6t_init(void) __init;
 extern void *ip6t_alloc_initial_table(const struct xt_table *);
 extern struct xt_table *ip6t_register_table(struct net *net,
 					    const struct xt_table *table,
-					    const struct ip6t_replace *repl);
+					    const struct ip6t_replace *repl,
+					    nf_hookfn *hookfn);
 extern void ip6t_unregister_table(struct net *net, struct xt_table *table);
+extern struct xt_table *__ip6t_register_table(struct net *net,
+					      const struct xt_table *table,
+					      const struct ip6t_replace *repl);
+extern void __ip6t_unregister_table(struct net *net, struct xt_table *table);
+
 extern unsigned int ip6t_do_table(struct sk_buff *skb,
 				  unsigned int hook,
 				  const struct nf_hook_state *state,
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index d75c139..7d1f327 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1779,13 +1779,15 @@ static int do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len
 
 struct xt_table *arpt_register_table(struct net *net,
 				     const struct xt_table *table,
-				     const struct arpt_replace *repl)
+				     const struct arpt_replace *repl,
+				     nf_hookfn *hookfn)
 {
 	int ret;
 	struct xt_table_info *newinfo;
 	struct xt_table_info bootstrap = {0};
 	void *loc_cpu_entry;
 	struct xt_table *new_table;
+	struct nf_hook_ops *ops;
 
 	newinfo = xt_alloc_table_info(repl->size);
 	if (!newinfo) {
@@ -1806,8 +1808,17 @@ struct xt_table *arpt_register_table(struct net *net,
 		ret = PTR_ERR(new_table);
 		goto out_free;
 	}
+
+	ops = xt_hook_link(net, table, hookfn);
+	if (IS_ERR(ops)) {
+		ret = PTR_ERR(ops);
+		goto out_unregister_table;
+	}
+
 	return new_table;
 
+out_unregister_table:
+	xt_unregister_table(new_table);
 out_free:
 	xt_free_table_info(newinfo);
 out:
@@ -1821,6 +1832,8 @@ void arpt_unregister_table(struct xt_table *table)
 	struct module *table_owner = table->me;
 	struct arpt_entry *iter;
 
+	xt_hook_unlink(table, table->ops);
+
 	private = xt_unregister_table(table);
 
 	/* Decrease module usage counts and free resources */
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index c7a7729..eb2c514 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -36,17 +36,16 @@ arptable_filter_hook(const struct nf_hook_ops *ops, struct sk_buff *skb,
 			     net->ipv4.arptable_filter);
 }
 
-static struct nf_hook_ops *arpfilter_ops __read_mostly;
-
 static int __net_init arptable_filter_net_init(struct net *net)
 {
 	struct arpt_replace *repl;
-	
+
 	repl = arpt_alloc_initial_table(&packet_filter);
 	if (repl == NULL)
 		return -ENOMEM;
 	net->ipv4.arptable_filter =
-		arpt_register_table(net, &packet_filter, repl);
+		arpt_register_table(net, &packet_filter, repl,
+				    arptable_filter_hook);
 	kfree(repl);
 	return PTR_ERR_OR_ZERO(net->ipv4.arptable_filter);
 }
@@ -63,28 +62,11 @@ static struct pernet_operations arptable_filter_net_ops = {
 
 static int __init arptable_filter_init(void)
 {
-	int ret;
-
-	ret = register_pernet_subsys(&arptable_filter_net_ops);
-	if (ret < 0)
-		return ret;
-
-	arpfilter_ops = xt_hook_link(&init_net, &packet_filter,
-				     arptable_filter_hook);
-	if (IS_ERR(arpfilter_ops)) {
-		ret = PTR_ERR(arpfilter_ops);
-		goto cleanup_table;
-	}
-	return ret;
-
-cleanup_table:
-	unregister_pernet_subsys(&arptable_filter_net_ops);
-	return ret;
+	return register_pernet_subsys(&arptable_filter_net_ops);
 }
 
 static void __exit arptable_filter_fini(void)
 {
-	xt_hook_unlink(&packet_filter, arpfilter_ops);
 	unregister_pernet_subsys(&arptable_filter_net_ops);
 }
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 6151500..3a3048e 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -2057,9 +2057,10 @@ do_ipt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	return ret;
 }
 
-struct xt_table *ipt_register_table(struct net *net,
-				    const struct xt_table *table,
-				    const struct ipt_replace *repl)
+/* Just like ipt_register_table() but no hook in registered. */
+struct xt_table *__ipt_register_table(struct net *net,
+				      const struct xt_table *table,
+				      const struct ipt_replace *repl)
 {
 	int ret;
 	struct xt_table_info *newinfo;
@@ -2093,8 +2094,38 @@ out_free:
 out:
 	return ERR_PTR(ret);
 }
+EXPORT_SYMBOL_GPL(__ipt_register_table);
 
-void ipt_unregister_table(struct net *net, struct xt_table *table)
+struct xt_table *ipt_register_table(struct net *net,
+				    const struct xt_table *table,
+				    const struct ipt_replace *repl,
+				    nf_hookfn *hookfn)
+{
+	struct xt_table *new_table;
+	struct nf_hook_ops *ops;
+	int ret;
+
+	new_table = __ipt_register_table(net, table, repl);
+	if (IS_ERR(new_table)) {
+		ret = PTR_ERR(new_table);
+		goto out;
+	}
+
+	ops = xt_hook_link(net, table, hookfn);
+	if (IS_ERR(ops)) {
+		ret = PTR_ERR(ops);
+		goto out_free;
+	}
+
+	return new_table;
+out_free:
+	__ipt_unregister_table(net, new_table);
+out:
+	return ERR_PTR(ret);
+}
+
+/* Just like ipt_unregister_table() but no hook in unregistered. */
+void __ipt_unregister_table(struct net *net, struct xt_table *table)
 {
 	struct xt_table_info *private;
 	void *loc_cpu_entry;
@@ -2111,6 +2142,13 @@ void ipt_unregister_table(struct net *net, struct xt_table *table)
 		module_put(table_owner);
 	xt_free_table_info(private);
 }
+EXPORT_SYMBOL_GPL(__ipt_unregister_table);
+
+void ipt_unregister_table(struct net *net, struct xt_table *table)
+{
+	xt_hook_unlink(table, table->ops);
+	__ipt_unregister_table(net, table);
+}
 
 /* Returns 1 if the type and code is matched by the range, 0 otherwise */
 static inline bool
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index f0faa27..4cddbd7 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -48,8 +48,6 @@ iptable_filter_hook(const struct nf_hook_ops *ops, struct sk_buff *skb,
 	return ipt_do_table(skb, ops->hooknum, state, net->ipv4.iptable_filter);
 }
 
-static struct nf_hook_ops *filter_ops __read_mostly;
-
 /* Default to forward because I got too much mail already. */
 static bool forward = true;
 module_param(forward, bool, 0000);
@@ -66,7 +64,8 @@ static int __net_init iptable_filter_net_init(struct net *net)
 		forward ? -NF_ACCEPT - 1 : -NF_DROP - 1;
 
 	net->ipv4.iptable_filter =
-		ipt_register_table(net, &packet_filter, repl);
+		ipt_register_table(net, &packet_filter, repl,
+				   iptable_filter_hook);
 	kfree(repl);
 	return PTR_ERR_OR_ZERO(net->ipv4.iptable_filter);
 }
@@ -83,26 +82,11 @@ static struct pernet_operations iptable_filter_net_ops = {
 
 static int __init iptable_filter_init(void)
 {
-	int ret;
-
-	ret = register_pernet_subsys(&iptable_filter_net_ops);
-	if (ret < 0)
-		return ret;
-
-	/* Register hooks */
-	filter_ops = xt_hook_link(&init_net, &packet_filter,
-				  iptable_filter_hook);
-	if (IS_ERR(filter_ops)) {
-		ret = PTR_ERR(filter_ops);
-		unregister_pernet_subsys(&iptable_filter_net_ops);
-	}
-
-	return ret;
+	return register_pernet_subsys(&iptable_filter_net_ops);
 }
 
 static void __exit iptable_filter_fini(void)
 {
-	xt_hook_unlink(&packet_filter, filter_ops);
 	unregister_pernet_subsys(&iptable_filter_net_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index bd294b4..f97a86b 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -94,8 +94,6 @@ iptable_mangle_hook(const struct nf_hook_ops *ops,
 			    dev_net(state->in)->ipv4.iptable_mangle);
 }
 
-static struct nf_hook_ops *mangle_ops __read_mostly;
-
 static int __net_init iptable_mangle_net_init(struct net *net)
 {
 	struct ipt_replace *repl;
@@ -104,7 +102,8 @@ static int __net_init iptable_mangle_net_init(struct net *net)
 	if (repl == NULL)
 		return -ENOMEM;
 	net->ipv4.iptable_mangle =
-		ipt_register_table(net, &packet_mangler, repl);
+		ipt_register_table(net, &packet_mangler, repl,
+				   iptable_mangle_hook);
 	kfree(repl);
 	return PTR_ERR_OR_ZERO(net->ipv4.iptable_mangle);
 }
@@ -121,26 +120,11 @@ static struct pernet_operations iptable_mangle_net_ops = {
 
 static int __init iptable_mangle_init(void)
 {
-	int ret;
-
-	ret = register_pernet_subsys(&iptable_mangle_net_ops);
-	if (ret < 0)
-		return ret;
-
-	/* Register hooks */
-	mangle_ops = xt_hook_link(&init_net, &packet_mangler,
-				  iptable_mangle_hook);
-	if (IS_ERR(mangle_ops)) {
-		ret = PTR_ERR(mangle_ops);
-		unregister_pernet_subsys(&iptable_mangle_net_ops);
-	}
-
-	return ret;
+	return register_pernet_subsys(&iptable_mangle_net_ops);
 }
 
 static void __exit iptable_mangle_fini(void)
 {
-	xt_hook_unlink(&packet_mangler, mangle_ops);
 	unregister_pernet_subsys(&iptable_mangle_net_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index 5ef83d3..0bb164e 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -104,18 +104,49 @@ static struct nf_hook_ops nf_nat_ipv4_ops[] __read_mostly = {
 static int __net_init iptable_nat_net_init(struct net *net)
 {
 	struct ipt_replace *repl;
+	int err;
 
 	repl = ipt_alloc_initial_table(&nf_nat_ipv4_table);
 	if (repl == NULL)
 		return -ENOMEM;
-	net->ipv4.nat_table = ipt_register_table(net, &nf_nat_ipv4_table, repl);
+
+	net->ipv4.nat_table = __ipt_register_table(net, &nf_nat_ipv4_table,
+						   repl);
+	if (IS_ERR(net->ipv4.nat_table)) {
+		err = PTR_ERR(net->ipv4.nat_table);
+		goto err1;
+	}
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv4.nat_table);
+
+	net->ipv4.nat_table->ops = kmemdup(nf_nat_ipv4_ops,
+					   sizeof(nf_nat_ipv4_ops), GFP_KERNEL);
+	if (net->ipv4.nat_table->ops == NULL) {
+		err = -ENOMEM;
+		goto err2;
+	}
+
+	err = nf_register_hooks(net, net->ipv4.nat_table->ops,
+				ARRAY_SIZE(nf_nat_ipv4_ops));
+	if (err < 0)
+		goto err3;
+
+	return 0;
+err3:
+	kfree(net->ipv4.nat_table->ops);
+err2:
+	__ipt_unregister_table(net, net->ipv4.nat_table);
+err1:
+	kfree(repl);
+
+	return err;
 }
 
 static void __net_exit iptable_nat_net_exit(struct net *net)
 {
-	ipt_unregister_table(net, net->ipv4.nat_table);
+	nf_unregister_hooks(net->ipv4.nat_table->ops,
+			    ARRAY_SIZE(nf_nat_ipv4_ops));
+	kfree(net->ipv4.nat_table->ops);
+	__ipt_unregister_table(net, net->ipv4.nat_table);
 }
 
 static struct pernet_operations iptable_nat_net_ops = {
@@ -125,27 +156,11 @@ static struct pernet_operations iptable_nat_net_ops = {
 
 static int __init iptable_nat_init(void)
 {
-	int err;
-
-	err = register_pernet_subsys(&iptable_nat_net_ops);
-	if (err < 0)
-		goto err1;
-
-	err = nf_register_hooks(&init_net, nf_nat_ipv4_ops,
-				ARRAY_SIZE(nf_nat_ipv4_ops));
-	if (err < 0)
-		goto err2;
-	return 0;
-
-err2:
-	unregister_pernet_subsys(&iptable_nat_net_ops);
-err1:
-	return err;
+	return register_pernet_subsys(&iptable_nat_net_ops);
 }
 
 static void __exit iptable_nat_exit(void)
 {
-	nf_unregister_hooks(nf_nat_ipv4_ops, ARRAY_SIZE(nf_nat_ipv4_ops));
 	unregister_pernet_subsys(&iptable_nat_net_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 2541383..908f34c 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -35,8 +35,6 @@ iptable_raw_hook(const struct nf_hook_ops *ops, struct sk_buff *skb,
 	return ipt_do_table(skb, ops->hooknum, state, net->ipv4.iptable_raw);
 }
 
-static struct nf_hook_ops *rawtable_ops __read_mostly;
-
 static int __net_init iptable_raw_net_init(struct net *net)
 {
 	struct ipt_replace *repl;
@@ -45,7 +43,7 @@ static int __net_init iptable_raw_net_init(struct net *net)
 	if (repl == NULL)
 		return -ENOMEM;
 	net->ipv4.iptable_raw =
-		ipt_register_table(net, &packet_raw, repl);
+		ipt_register_table(net, &packet_raw, repl, iptable_raw_hook);
 	kfree(repl);
 	return PTR_ERR_OR_ZERO(net->ipv4.iptable_raw);
 }
@@ -62,25 +60,11 @@ static struct pernet_operations iptable_raw_net_ops = {
 
 static int __init iptable_raw_init(void)
 {
-	int ret;
-
-	ret = register_pernet_subsys(&iptable_raw_net_ops);
-	if (ret < 0)
-		return ret;
-
-	/* Register hooks */
-	rawtable_ops = xt_hook_link(&init_net, &packet_raw, iptable_raw_hook);
-	if (IS_ERR(rawtable_ops)) {
-		ret = PTR_ERR(rawtable_ops);
-		unregister_pernet_subsys(&iptable_raw_net_ops);
-	}
-
-	return ret;
+	return register_pernet_subsys(&iptable_raw_net_ops);
 }
 
 static void __exit iptable_raw_fini(void)
 {
-	xt_hook_unlink(&packet_raw, rawtable_ops);
 	unregister_pernet_subsys(&iptable_raw_net_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index 0a0ddc7..d4c8729 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -53,8 +53,6 @@ iptable_security_hook(const struct nf_hook_ops *ops, struct sk_buff *skb,
 			    net->ipv4.iptable_security);
 }
 
-static struct nf_hook_ops *sectbl_ops __read_mostly;
-
 static int __net_init iptable_security_net_init(struct net *net)
 {
 	struct ipt_replace *repl;
@@ -63,7 +61,8 @@ static int __net_init iptable_security_net_init(struct net *net)
 	if (repl == NULL)
 		return -ENOMEM;
 	net->ipv4.iptable_security =
-		ipt_register_table(net, &security_table, repl);
+		ipt_register_table(net, &security_table, repl,
+				   iptable_security_hook);
 	kfree(repl);
 	return PTR_ERR_OR_ZERO(net->ipv4.iptable_security);
 }
@@ -80,29 +79,11 @@ static struct pernet_operations iptable_security_net_ops = {
 
 static int __init iptable_security_init(void)
 {
-	int ret;
-
-	ret = register_pernet_subsys(&iptable_security_net_ops);
-        if (ret < 0)
-		return ret;
-
-	sectbl_ops = xt_hook_link(&init_net, &security_table,
-				  iptable_security_hook);
-	if (IS_ERR(sectbl_ops)) {
-		ret = PTR_ERR(sectbl_ops);
-		goto cleanup_table;
-	}
-
-	return ret;
-
-cleanup_table:
-	unregister_pernet_subsys(&iptable_security_net_ops);
-	return ret;
+	return register_pernet_subsys(&iptable_security_net_ops);
 }
 
 static void __exit iptable_security_fini(void)
 {
-	xt_hook_unlink(&security_table, sectbl_ops);
 	unregister_pernet_subsys(&iptable_security_net_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 80a7f0d..3cbc37d 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -2067,7 +2067,8 @@ do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	return ret;
 }
 
-struct xt_table *ip6t_register_table(struct net *net,
+/* Just like ip6t_register_table() but no hook is registered. */
+struct xt_table *__ip6t_register_table(struct net *net,
 				     const struct xt_table *table,
 				     const struct ip6t_replace *repl)
 {
@@ -2102,8 +2103,38 @@ out_free:
 out:
 	return ERR_PTR(ret);
 }
+EXPORT_SYMBOL_GPL(__ip6t_register_table);
 
-void ip6t_unregister_table(struct net *net, struct xt_table *table)
+struct xt_table *ip6t_register_table(struct net *net,
+				     const struct xt_table *table,
+				     const struct ip6t_replace *repl,
+				     nf_hookfn *hookfn)
+{
+	struct xt_table *new_table;
+	struct nf_hook_ops *ops;
+	int err;
+
+	new_table = __ip6t_register_table(net, table, repl);
+	if (IS_ERR(new_table)) {
+		err = PTR_ERR(new_table);
+		goto err1;
+	}
+
+	ops = xt_hook_link(net, table, hookfn);
+	if (IS_ERR(ops)) {
+		err = PTR_ERR(ops);
+		goto err2;
+	}
+
+	return 0;
+err2:
+	__ip6t_unregister_table(net, new_table);
+err1:
+	return ERR_PTR(err);
+}
+
+/* Just like ip6t_unregister_table() but no hook is unregistered. */
+void __ip6t_unregister_table(struct net *net, struct xt_table *table)
 {
 	struct xt_table_info *private;
 	void *loc_cpu_entry;
@@ -2120,6 +2151,13 @@ void ip6t_unregister_table(struct net *net, struct xt_table *table)
 		module_put(table_owner);
 	xt_free_table_info(private);
 }
+EXPORT_SYMBOL_GPL(__ip6t_unregister_table);
+
+void ip6t_unregister_table(struct net *net, struct xt_table *table)
+{
+	__ip6t_unregister_table(net, table);
+	xt_hook_unlink(table, table->ops);
+}
 
 /* Returns 1 if the type and code is matched by the range, 0 otherwise */
 static inline bool
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index fe0bf52..77d237b 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -40,8 +40,6 @@ ip6table_filter_hook(const struct nf_hook_ops *ops, struct sk_buff *skb,
 	return ip6t_do_table(skb, ops->hooknum, state, net->ipv6.ip6table_filter);
 }
 
-static struct nf_hook_ops *filter_ops __read_mostly;
-
 /* Default to forward because I got too much mail already. */
 static bool forward = true;
 module_param(forward, bool, 0000);
@@ -58,7 +56,8 @@ static int __net_init ip6table_filter_net_init(struct net *net)
 		forward ? -NF_ACCEPT - 1 : -NF_DROP - 1;
 
 	net->ipv6.ip6table_filter =
-		ip6t_register_table(net, &packet_filter, repl);
+		ip6t_register_table(net, &packet_filter, repl,
+				    ip6table_filter_hook);
 	kfree(repl);
 	return PTR_ERR_OR_ZERO(net->ipv6.ip6table_filter);
 }
@@ -75,30 +74,11 @@ static struct pernet_operations ip6table_filter_net_ops = {
 
 static int __init ip6table_filter_init(void)
 {
-	int ret;
-
-	ret = register_pernet_subsys(&ip6table_filter_net_ops);
-	if (ret < 0)
-		return ret;
-
-	/* Register hooks */
-	filter_ops = xt_hook_link(&init_net, &packet_filter,
-				  ip6table_filter_hook);
-	if (IS_ERR(filter_ops)) {
-		ret = PTR_ERR(filter_ops);
-		goto cleanup_table;
-	}
-
-	return ret;
-
- cleanup_table:
-	unregister_pernet_subsys(&ip6table_filter_net_ops);
-	return ret;
+	return register_pernet_subsys(&ip6table_filter_net_ops);
 }
 
 static void __exit ip6table_filter_fini(void)
 {
-	xt_hook_unlink(&packet_filter, filter_ops);
 	unregister_pernet_subsys(&ip6table_filter_net_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 50fea9e..f2d7355 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -89,7 +89,6 @@ ip6table_mangle_hook(const struct nf_hook_ops *ops, struct sk_buff *skb,
 			     dev_net(state->in)->ipv6.ip6table_mangle);
 }
 
-static struct nf_hook_ops *mangle_ops __read_mostly;
 static int __net_init ip6table_mangle_net_init(struct net *net)
 {
 	struct ip6t_replace *repl;
@@ -98,7 +97,8 @@ static int __net_init ip6table_mangle_net_init(struct net *net)
 	if (repl == NULL)
 		return -ENOMEM;
 	net->ipv6.ip6table_mangle =
-		ip6t_register_table(net, &packet_mangler, repl);
+		ip6t_register_table(net, &packet_mangler, repl,
+				    ip6table_mangle_hook);
 	kfree(repl);
 	return PTR_ERR_OR_ZERO(net->ipv6.ip6table_mangle);
 }
@@ -115,30 +115,11 @@ static struct pernet_operations ip6table_mangle_net_ops = {
 
 static int __init ip6table_mangle_init(void)
 {
-	int ret;
-
-	ret = register_pernet_subsys(&ip6table_mangle_net_ops);
-	if (ret < 0)
-		return ret;
-
-	/* Register hooks */
-	mangle_ops = xt_hook_link(&init_net, &packet_mangler,
-				  ip6table_mangle_hook);
-	if (IS_ERR(mangle_ops)) {
-		ret = PTR_ERR(mangle_ops);
-		goto cleanup_table;
-	}
-
-	return ret;
-
- cleanup_table:
-	unregister_pernet_subsys(&ip6table_mangle_net_ops);
-	return ret;
+	return register_pernet_subsys(&ip6table_mangle_net_ops);
 }
 
 static void __exit ip6table_mangle_fini(void)
 {
-	xt_hook_unlink(&packet_mangler, mangle_ops);
 	unregister_pernet_subsys(&ip6table_mangle_net_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index ecb0511..44e755a 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -106,18 +106,49 @@ static struct nf_hook_ops nf_nat_ipv6_ops[] __read_mostly = {
 static int __net_init ip6table_nat_net_init(struct net *net)
 {
 	struct ip6t_replace *repl;
+	int err;
 
 	repl = ip6t_alloc_initial_table(&nf_nat_ipv6_table);
 	if (repl == NULL)
 		return -ENOMEM;
-	net->ipv6.ip6table_nat = ip6t_register_table(net, &nf_nat_ipv6_table, repl);
+
+	net->ipv6.ip6table_nat =
+		__ip6t_register_table(net, &nf_nat_ipv6_table, repl);
+	if (IS_ERR(net->ipv6.ip6table_nat)) {
+		err = PTR_ERR(net->ipv6.ip6table_nat);
+		goto err1;
+	}
 	kfree(repl);
-	return PTR_ERR_OR_ZERO(net->ipv6.ip6table_nat);
+
+	net->ipv6.ip6table_nat->ops =
+		kmemdup(nf_nat_ipv6_ops, sizeof(nf_nat_ipv6_ops), GFP_KERNEL);
+	if (net->ipv6.ip6table_nat->ops == NULL) {
+		err = -ENOMEM;
+		goto err2;
+	}
+
+	err = nf_register_hooks(net, net->ipv6.ip6table_nat->ops,
+				ARRAY_SIZE(nf_nat_ipv6_ops));
+	if (err < 0)
+		goto err3;
+
+	return 0;
+err3:
+	kfree(net->ipv6.ip6table_nat->ops);
+err2:
+	__ip6t_unregister_table(net, net->ipv6.ip6table_nat);
+err1:
+	kfree(repl);
+
+	return err;
 }
 
 static void __net_exit ip6table_nat_net_exit(struct net *net)
 {
-	ip6t_unregister_table(net, net->ipv6.ip6table_nat);
+	nf_unregister_hooks(net->ipv6.ip6table_nat->ops,
+			    ARRAY_SIZE(nf_nat_ipv6_ops));
+	kfree(net->ipv6.ip6table_nat->ops);
+	__ip6t_unregister_table(net, net->ipv6.ip6table_nat);
 }
 
 static struct pernet_operations ip6table_nat_net_ops = {
@@ -127,27 +158,11 @@ static struct pernet_operations ip6table_nat_net_ops = {
 
 static int __init ip6table_nat_init(void)
 {
-	int err;
-
-	err = register_pernet_subsys(&ip6table_nat_net_ops);
-	if (err < 0)
-		goto err1;
-
-	err = nf_register_hooks(&init_net, nf_nat_ipv6_ops,
-				ARRAY_SIZE(nf_nat_ipv6_ops));
-	if (err < 0)
-		goto err2;
-	return 0;
-
-err2:
-	unregister_pernet_subsys(&ip6table_nat_net_ops);
-err1:
-	return err;
+	return register_pernet_subsys(&ip6table_nat_net_ops);
 }
 
 static void __exit ip6table_nat_exit(void)
 {
-	nf_unregister_hooks(nf_nat_ipv6_ops, ARRAY_SIZE(nf_nat_ipv6_ops));
 	unregister_pernet_subsys(&ip6table_nat_net_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 141604f..4c7e496 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -27,8 +27,6 @@ ip6table_raw_hook(const struct nf_hook_ops *ops, struct sk_buff *skb,
 	return ip6t_do_table(skb, ops->hooknum, state, net->ipv6.ip6table_raw);
 }
 
-static struct nf_hook_ops *rawtable_ops __read_mostly;
-
 static int __net_init ip6table_raw_net_init(struct net *net)
 {
 	struct ip6t_replace *repl;
@@ -37,7 +35,7 @@ static int __net_init ip6table_raw_net_init(struct net *net)
 	if (repl == NULL)
 		return -ENOMEM;
 	net->ipv6.ip6table_raw =
-		ip6t_register_table(net, &packet_raw, repl);
+		ip6t_register_table(net, &packet_raw, repl, ip6table_raw_hook);
 	kfree(repl);
 	return PTR_ERR_OR_ZERO(net->ipv6.ip6table_raw);
 }
@@ -54,29 +52,11 @@ static struct pernet_operations ip6table_raw_net_ops = {
 
 static int __init ip6table_raw_init(void)
 {
-	int ret;
-
-	ret = register_pernet_subsys(&ip6table_raw_net_ops);
-	if (ret < 0)
-		return ret;
-
-	/* Register hooks */
-	rawtable_ops = xt_hook_link(&init_net, &packet_raw, ip6table_raw_hook);
-	if (IS_ERR(rawtable_ops)) {
-		ret = PTR_ERR(rawtable_ops);
-		goto cleanup_table;
-	}
-
-	return ret;
-
- cleanup_table:
-	unregister_pernet_subsys(&ip6table_raw_net_ops);
-	return ret;
+	return register_pernet_subsys(&ip6table_raw_net_ops);
 }
 
 static void __exit ip6table_raw_fini(void)
 {
-	xt_hook_unlink(&packet_raw, rawtable_ops);
 	unregister_pernet_subsys(&ip6table_raw_net_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 8d252f8..8a224ca 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -45,8 +45,6 @@ ip6table_security_hook(const struct nf_hook_ops *ops, struct sk_buff *skb,
 			     net->ipv6.ip6table_security);
 }
 
-static struct nf_hook_ops *sectbl_ops __read_mostly;
-
 static int __net_init ip6table_security_net_init(struct net *net)
 {
 	struct ip6t_replace *repl;
@@ -55,7 +53,8 @@ static int __net_init ip6table_security_net_init(struct net *net)
 	if (repl == NULL)
 		return -ENOMEM;
 	net->ipv6.ip6table_security =
-		ip6t_register_table(net, &security_table, repl);
+		ip6t_register_table(net, &security_table, repl,
+				    ip6table_security_hook);
 	kfree(repl);
 	return PTR_ERR_OR_ZERO(net->ipv6.ip6table_security);
 }
@@ -72,29 +71,11 @@ static struct pernet_operations ip6table_security_net_ops = {
 
 static int __init ip6table_security_init(void)
 {
-	int ret;
-
-	ret = register_pernet_subsys(&ip6table_security_net_ops);
-	if (ret < 0)
-		return ret;
-
-	sectbl_ops = xt_hook_link(&init_net, &security_table,
-				  ip6table_security_hook);
-	if (IS_ERR(sectbl_ops)) {
-		ret = PTR_ERR(sectbl_ops);
-		goto cleanup_table;
-	}
-
-	return ret;
-
-cleanup_table:
-	unregister_pernet_subsys(&ip6table_security_net_ops);
-	return ret;
+	return register_pernet_subsys(&ip6table_security_net_ops);
 }
 
 static void __exit ip6table_security_fini(void)
 {
-	xt_hook_unlink(&security_table, sectbl_ops);
 	unregister_pernet_subsys(&ip6table_security_net_ops);
 }
 
-- 
1.7.10.4

