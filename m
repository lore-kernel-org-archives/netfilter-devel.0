Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51755C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Aug 2021 14:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31E7E60F35
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Aug 2021 14:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236602AbhHCOsG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 10:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236751AbhHCOrz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 10:47:55 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FABC061757
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Aug 2021 07:47:28 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mAvhW-0006i3-84; Tue, 03 Aug 2021 16:47:26 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] x_tables: never register tables by default
Date:   Tue,  3 Aug 2021 16:47:19 +0200
Message-Id: <20210803144719.26735-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For historical reasons x_tables still register tables by default in the
initial namespace.
Only newly created net namespaces add the hook on demand.

This means that the init_net always pays hook cost, even if no filtering
rules are added (e.g. only used inside a single netns).

Note that the hooks are added even when 'iptables -L' is called.
This is because there is no way to tell 'iptables -A' and 'iptables -L'
apart at kernel level.

The only solution would be to register the table, but delay hook
registration until the first rule gets added (or policy gets changed).

That however means that counters are not hooked either, so 'iptables -L'
would always show 0-counters even when traffic is flowing which might be
unexpected.

This keeps table and hook registration consistent with what is already done
in non-init netns: first iptables(-save) invocation registers both table
and hooks.

This applies the same solution adopted for ebtables.
All tables register a template that contains the l3 family, the name
and a constructor function that is called when the initial table has to
be added.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/x_tables.h     |  6 +-
 net/ipv4/netfilter/arptable_filter.c   | 23 +++---
 net/ipv4/netfilter/iptable_filter.c    | 24 ++++---
 net/ipv4/netfilter/iptable_mangle.c    | 17 ++---
 net/ipv4/netfilter/iptable_nat.c       | 20 +++---
 net/ipv4/netfilter/iptable_raw.c       | 21 +++---
 net/ipv4/netfilter/iptable_security.c  | 23 +++---
 net/ipv6/netfilter/ip6table_filter.c   | 23 +++---
 net/ipv6/netfilter/ip6table_mangle.c   | 22 +++---
 net/ipv6/netfilter/ip6table_nat.c      | 16 ++---
 net/ipv6/netfilter/ip6table_raw.c      | 24 +++----
 net/ipv6/netfilter/ip6table_security.c | 22 +++---
 net/netfilter/x_tables.c               | 98 +++++++++++++++++++++-----
 13 files changed, 204 insertions(+), 135 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 28d7027cd460..5897f3dbaf7c 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -238,9 +238,6 @@ struct xt_table {
 	u_int8_t af;		/* address/protocol family */
 	int priority;		/* hook order */
 
-	/* called when table is needed in the given netns */
-	int (*table_init)(struct net *net);
-
 	/* A unique name... */
 	const char name[XT_TABLE_MAXNAMELEN];
 };
@@ -452,6 +449,9 @@ xt_get_per_cpu_counter(struct xt_counters *cnt, unsigned int cpu)
 
 struct nf_hook_ops *xt_hook_ops_alloc(const struct xt_table *, nf_hookfn *);
 
+int xt_register_template(const struct xt_table *t, int(*table_init)(struct net *net));
+void xt_unregister_template(const struct xt_table *t);
+
 #ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 #include <net/compat.h>
 
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 6922612df456..3de78416ec76 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -18,15 +18,12 @@ MODULE_DESCRIPTION("arptables filter table");
 #define FILTER_VALID_HOOKS ((1 << NF_ARP_IN) | (1 << NF_ARP_OUT) | \
 			   (1 << NF_ARP_FORWARD))
 
-static int __net_init arptable_filter_table_init(struct net *net);
-
 static const struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_ARP,
 	.priority	= NF_IP_PRI_FILTER,
-	.table_init	= arptable_filter_table_init,
 };
 
 /* The work comes in here from netfilter.c */
@@ -39,7 +36,7 @@ arptable_filter_hook(void *priv, struct sk_buff *skb,
 
 static struct nf_hook_ops *arpfilter_ops __read_mostly;
 
-static int __net_init arptable_filter_table_init(struct net *net)
+static int arptable_filter_table_init(struct net *net)
 {
 	struct arpt_replace *repl;
 	int err;
@@ -69,30 +66,32 @@ static struct pernet_operations arptable_filter_net_ops = {
 
 static int __init arptable_filter_init(void)
 {
-	int ret;
+	int ret = xt_register_template(&packet_filter,
+				       arptable_filter_table_init);
+
+	if (ret < 0)
+		return ret;
 
 	arpfilter_ops = xt_hook_ops_alloc(&packet_filter, arptable_filter_hook);
-	if (IS_ERR(arpfilter_ops))
+	if (IS_ERR(arpfilter_ops)) {
+		xt_unregister_template(&packet_filter);
 		return PTR_ERR(arpfilter_ops);
+	}
 
 	ret = register_pernet_subsys(&arptable_filter_net_ops);
 	if (ret < 0) {
+		xt_unregister_template(&packet_filter);
 		kfree(arpfilter_ops);
 		return ret;
 	}
 
-	ret = arptable_filter_table_init(&init_net);
-	if (ret) {
-		unregister_pernet_subsys(&arptable_filter_net_ops);
-		kfree(arpfilter_ops);
-	}
-
 	return ret;
 }
 
 static void __exit arptable_filter_fini(void)
 {
 	unregister_pernet_subsys(&arptable_filter_net_ops);
+	xt_unregister_template(&packet_filter);
 	kfree(arpfilter_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 8272df7c6ad5..0eb0e2ab9bfc 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -19,7 +19,6 @@ MODULE_DESCRIPTION("iptables filter table");
 #define FILTER_VALID_HOOKS ((1 << NF_INET_LOCAL_IN) | \
 			    (1 << NF_INET_FORWARD) | \
 			    (1 << NF_INET_LOCAL_OUT))
-static int __net_init iptable_filter_table_init(struct net *net);
 
 static const struct xt_table packet_filter = {
 	.name		= "filter",
@@ -27,7 +26,6 @@ static const struct xt_table packet_filter = {
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV4,
 	.priority	= NF_IP_PRI_FILTER,
-	.table_init	= iptable_filter_table_init,
 };
 
 static unsigned int
@@ -43,7 +41,7 @@ static struct nf_hook_ops *filter_ops __read_mostly;
 static bool forward __read_mostly = true;
 module_param(forward, bool, 0000);
 
-static int __net_init iptable_filter_table_init(struct net *net)
+static int iptable_filter_table_init(struct net *net)
 {
 	struct ipt_replace *repl;
 	int err;
@@ -62,7 +60,7 @@ static int __net_init iptable_filter_table_init(struct net *net)
 
 static int __net_init iptable_filter_net_init(struct net *net)
 {
-	if (net == &init_net || !forward)
+	if (!forward)
 		return iptable_filter_table_init(net);
 
 	return 0;
@@ -86,22 +84,32 @@ static struct pernet_operations iptable_filter_net_ops = {
 
 static int __init iptable_filter_init(void)
 {
-	int ret;
+	int ret = xt_register_template(&packet_filter,
+				       iptable_filter_table_init);
+
+	if (ret < 0)
+		return ret;
 
 	filter_ops = xt_hook_ops_alloc(&packet_filter, iptable_filter_hook);
-	if (IS_ERR(filter_ops))
+	if (IS_ERR(filter_ops)) {
+		xt_unregister_template(&packet_filter);
 		return PTR_ERR(filter_ops);
+	}
 
 	ret = register_pernet_subsys(&iptable_filter_net_ops);
-	if (ret < 0)
+	if (ret < 0) {
+		xt_unregister_template(&packet_filter);
 		kfree(filter_ops);
+		return ret;
+	}
 
-	return ret;
+	return 0;
 }
 
 static void __exit iptable_filter_fini(void)
 {
 	unregister_pernet_subsys(&iptable_filter_net_ops);
+	xt_unregister_template(&packet_filter);
 	kfree(filter_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 2abc3836f391..b52a4c8a14fc 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -25,15 +25,12 @@ MODULE_DESCRIPTION("iptables mangle table");
 			    (1 << NF_INET_LOCAL_OUT) | \
 			    (1 << NF_INET_POST_ROUTING))
 
-static int __net_init iptable_mangle_table_init(struct net *net);
-
 static const struct xt_table packet_mangler = {
 	.name		= "mangle",
 	.valid_hooks	= MANGLE_VALID_HOOKS,
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV4,
 	.priority	= NF_IP_PRI_MANGLE,
-	.table_init	= iptable_mangle_table_init,
 };
 
 static unsigned int
@@ -83,7 +80,7 @@ iptable_mangle_hook(void *priv,
 }
 
 static struct nf_hook_ops *mangle_ops __read_mostly;
-static int __net_init iptable_mangle_table_init(struct net *net)
+static int iptable_mangle_table_init(struct net *net)
 {
 	struct ipt_replace *repl;
 	int ret;
@@ -113,32 +110,30 @@ static struct pernet_operations iptable_mangle_net_ops = {
 
 static int __init iptable_mangle_init(void)
 {
-	int ret;
+	int ret = xt_register_template(&packet_mangler,
+				       iptable_mangle_table_init);
 
 	mangle_ops = xt_hook_ops_alloc(&packet_mangler, iptable_mangle_hook);
 	if (IS_ERR(mangle_ops)) {
+		xt_unregister_template(&packet_mangler);
 		ret = PTR_ERR(mangle_ops);
 		return ret;
 	}
 
 	ret = register_pernet_subsys(&iptable_mangle_net_ops);
 	if (ret < 0) {
+		xt_unregister_template(&packet_mangler);
 		kfree(mangle_ops);
 		return ret;
 	}
 
-	ret = iptable_mangle_table_init(&init_net);
-	if (ret) {
-		unregister_pernet_subsys(&iptable_mangle_net_ops);
-		kfree(mangle_ops);
-	}
-
 	return ret;
 }
 
 static void __exit iptable_mangle_fini(void)
 {
 	unregister_pernet_subsys(&iptable_mangle_net_ops);
+	xt_unregister_template(&packet_mangler);
 	kfree(mangle_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index a9913842ef18..45d7e072e6a5 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -17,8 +17,6 @@ struct iptable_nat_pernet {
 	struct nf_hook_ops *nf_nat_ops;
 };
 
-static int __net_init iptable_nat_table_init(struct net *net);
-
 static unsigned int iptable_nat_net_id __read_mostly;
 
 static const struct xt_table nf_nat_ipv4_table = {
@@ -29,7 +27,6 @@ static const struct xt_table nf_nat_ipv4_table = {
 			  (1 << NF_INET_LOCAL_IN),
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV4,
-	.table_init	= iptable_nat_table_init,
 };
 
 static unsigned int iptable_nat_do_chain(void *priv,
@@ -113,7 +110,7 @@ static void ipt_nat_unregister_lookups(struct net *net)
 	kfree(ops);
 }
 
-static int __net_init iptable_nat_table_init(struct net *net)
+static int iptable_nat_table_init(struct net *net)
 {
 	struct ipt_replace *repl;
 	int ret;
@@ -155,20 +152,25 @@ static struct pernet_operations iptable_nat_net_ops = {
 
 static int __init iptable_nat_init(void)
 {
-	int ret = register_pernet_subsys(&iptable_nat_net_ops);
+	int ret = xt_register_template(&nf_nat_ipv4_table,
+				       iptable_nat_table_init);
+
+	if (ret < 0)
+		return ret;
 
-	if (ret)
+	ret = register_pernet_subsys(&iptable_nat_net_ops);
+	if (ret < 0) {
+		xt_unregister_template(&nf_nat_ipv4_table);
 		return ret;
+	}
 
-	ret = iptable_nat_table_init(&init_net);
-	if (ret)
-		unregister_pernet_subsys(&iptable_nat_net_ops);
 	return ret;
 }
 
 static void __exit iptable_nat_exit(void)
 {
 	unregister_pernet_subsys(&iptable_nat_net_ops);
+	xt_unregister_template(&nf_nat_ipv4_table);
 }
 
 module_init(iptable_nat_init);
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index ceef397c1f5f..b88e0f36cd05 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -12,8 +12,6 @@
 
 #define RAW_VALID_HOOKS ((1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_OUT))
 
-static int __net_init iptable_raw_table_init(struct net *net);
-
 static bool raw_before_defrag __read_mostly;
 MODULE_PARM_DESC(raw_before_defrag, "Enable raw table before defrag");
 module_param(raw_before_defrag, bool, 0000);
@@ -24,7 +22,6 @@ static const struct xt_table packet_raw = {
 	.me = THIS_MODULE,
 	.af = NFPROTO_IPV4,
 	.priority = NF_IP_PRI_RAW,
-	.table_init = iptable_raw_table_init,
 };
 
 static const struct xt_table packet_raw_before_defrag = {
@@ -33,7 +30,6 @@ static const struct xt_table packet_raw_before_defrag = {
 	.me = THIS_MODULE,
 	.af = NFPROTO_IPV4,
 	.priority = NF_IP_PRI_RAW_BEFORE_DEFRAG,
-	.table_init = iptable_raw_table_init,
 };
 
 /* The work comes in here from netfilter.c. */
@@ -89,22 +85,24 @@ static int __init iptable_raw_init(void)
 		pr_info("Enabling raw table before defrag\n");
 	}
 
+	ret = xt_register_template(table,
+				   iptable_raw_table_init);
+	if (ret < 0)
+		return ret;
+
 	rawtable_ops = xt_hook_ops_alloc(table, iptable_raw_hook);
-	if (IS_ERR(rawtable_ops))
+	if (IS_ERR(rawtable_ops)) {
+		xt_unregister_template(table);
 		return PTR_ERR(rawtable_ops);
+	}
 
 	ret = register_pernet_subsys(&iptable_raw_net_ops);
 	if (ret < 0) {
+		xt_unregister_template(table);
 		kfree(rawtable_ops);
 		return ret;
 	}
 
-	ret = iptable_raw_table_init(&init_net);
-	if (ret) {
-		unregister_pernet_subsys(&iptable_raw_net_ops);
-		kfree(rawtable_ops);
-	}
-
 	return ret;
 }
 
@@ -112,6 +110,7 @@ static void __exit iptable_raw_fini(void)
 {
 	unregister_pernet_subsys(&iptable_raw_net_ops);
 	kfree(rawtable_ops);
+	xt_unregister_template(&packet_raw);
 }
 
 module_init(iptable_raw_init);
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index 77973f5fd8f6..f519162a2fa5 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -25,15 +25,12 @@ MODULE_DESCRIPTION("iptables security table, for MAC rules");
 				(1 << NF_INET_FORWARD) | \
 				(1 << NF_INET_LOCAL_OUT)
 
-static int __net_init iptable_security_table_init(struct net *net);
-
 static const struct xt_table security_table = {
 	.name		= "security",
 	.valid_hooks	= SECURITY_VALID_HOOKS,
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV4,
 	.priority	= NF_IP_PRI_SECURITY,
-	.table_init	= iptable_security_table_init,
 };
 
 static unsigned int
@@ -45,7 +42,7 @@ iptable_security_hook(void *priv, struct sk_buff *skb,
 
 static struct nf_hook_ops *sectbl_ops __read_mostly;
 
-static int __net_init iptable_security_table_init(struct net *net)
+static int iptable_security_table_init(struct net *net)
 {
 	struct ipt_replace *repl;
 	int ret;
@@ -75,24 +72,25 @@ static struct pernet_operations iptable_security_net_ops = {
 
 static int __init iptable_security_init(void)
 {
-	int ret;
+	int ret = xt_register_template(&security_table,
+				       iptable_security_table_init);
+
+	if (ret < 0)
+		return ret;
 
 	sectbl_ops = xt_hook_ops_alloc(&security_table, iptable_security_hook);
-	if (IS_ERR(sectbl_ops))
+	if (IS_ERR(sectbl_ops)) {
+		xt_unregister_template(&security_table);
 		return PTR_ERR(sectbl_ops);
+	}
 
 	ret = register_pernet_subsys(&iptable_security_net_ops);
 	if (ret < 0) {
+		xt_unregister_template(&security_table);
 		kfree(sectbl_ops);
 		return ret;
 	}
 
-	ret = iptable_security_table_init(&init_net);
-	if (ret) {
-		unregister_pernet_subsys(&iptable_security_net_ops);
-		kfree(sectbl_ops);
-	}
-
 	return ret;
 }
 
@@ -100,6 +98,7 @@ static void __exit iptable_security_fini(void)
 {
 	unregister_pernet_subsys(&iptable_security_net_ops);
 	kfree(sectbl_ops);
+	xt_unregister_template(&security_table);
 }
 
 module_init(iptable_security_init);
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index bb784ea7bbd3..727ee8097012 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -19,15 +19,12 @@ MODULE_DESCRIPTION("ip6tables filter table");
 			    (1 << NF_INET_FORWARD) | \
 			    (1 << NF_INET_LOCAL_OUT))
 
-static int __net_init ip6table_filter_table_init(struct net *net);
-
 static const struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV6,
 	.priority	= NF_IP6_PRI_FILTER,
-	.table_init	= ip6table_filter_table_init,
 };
 
 /* The work comes in here from netfilter.c. */
@@ -44,7 +41,7 @@ static struct nf_hook_ops *filter_ops __read_mostly;
 static bool forward = true;
 module_param(forward, bool, 0000);
 
-static int __net_init ip6table_filter_table_init(struct net *net)
+static int ip6table_filter_table_init(struct net *net)
 {
 	struct ip6t_replace *repl;
 	int err;
@@ -63,7 +60,7 @@ static int __net_init ip6table_filter_table_init(struct net *net)
 
 static int __net_init ip6table_filter_net_init(struct net *net)
 {
-	if (net == &init_net || !forward)
+	if (!forward)
 		return ip6table_filter_table_init(net);
 
 	return 0;
@@ -87,15 +84,24 @@ static struct pernet_operations ip6table_filter_net_ops = {
 
 static int __init ip6table_filter_init(void)
 {
-	int ret;
+	int ret = xt_register_template(&packet_filter,
+					ip6table_filter_table_init);
+
+	if (ret < 0)
+		return ret;
 
 	filter_ops = xt_hook_ops_alloc(&packet_filter, ip6table_filter_hook);
-	if (IS_ERR(filter_ops))
+	if (IS_ERR(filter_ops)) {
+		xt_unregister_template(&packet_filter);
 		return PTR_ERR(filter_ops);
+	}
 
 	ret = register_pernet_subsys(&ip6table_filter_net_ops);
-	if (ret < 0)
+	if (ret < 0) {
+		xt_unregister_template(&packet_filter);
 		kfree(filter_ops);
+		return ret;
+	}
 
 	return ret;
 }
@@ -103,6 +109,7 @@ static int __init ip6table_filter_init(void)
 static void __exit ip6table_filter_fini(void)
 {
 	unregister_pernet_subsys(&ip6table_filter_net_ops);
+	xt_unregister_template(&packet_filter);
 	kfree(filter_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index c76cffd63041..9b518ce37d6a 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -20,15 +20,12 @@ MODULE_DESCRIPTION("ip6tables mangle table");
 			    (1 << NF_INET_LOCAL_OUT) | \
 			    (1 << NF_INET_POST_ROUTING))
 
-static int __net_init ip6table_mangle_table_init(struct net *net);
-
 static const struct xt_table packet_mangler = {
 	.name		= "mangle",
 	.valid_hooks	= MANGLE_VALID_HOOKS,
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV6,
 	.priority	= NF_IP6_PRI_MANGLE,
-	.table_init	= ip6table_mangle_table_init,
 };
 
 static unsigned int
@@ -76,7 +73,7 @@ ip6table_mangle_hook(void *priv, struct sk_buff *skb,
 }
 
 static struct nf_hook_ops *mangle_ops __read_mostly;
-static int __net_init ip6table_mangle_table_init(struct net *net)
+static int ip6table_mangle_table_init(struct net *net)
 {
 	struct ip6t_replace *repl;
 	int ret;
@@ -106,29 +103,32 @@ static struct pernet_operations ip6table_mangle_net_ops = {
 
 static int __init ip6table_mangle_init(void)
 {
-	int ret;
+	int ret = xt_register_template(&packet_mangler,
+				       ip6table_mangle_table_init);
+
+	if (ret < 0)
+		return ret;
 
 	mangle_ops = xt_hook_ops_alloc(&packet_mangler, ip6table_mangle_hook);
-	if (IS_ERR(mangle_ops))
+	if (IS_ERR(mangle_ops)) {
+		xt_unregister_template(&packet_mangler);
 		return PTR_ERR(mangle_ops);
+	}
 
 	ret = register_pernet_subsys(&ip6table_mangle_net_ops);
 	if (ret < 0) {
+		xt_unregister_template(&packet_mangler);
 		kfree(mangle_ops);
 		return ret;
 	}
 
-	ret = ip6table_mangle_table_init(&init_net);
-	if (ret) {
-		unregister_pernet_subsys(&ip6table_mangle_net_ops);
-		kfree(mangle_ops);
-	}
 	return ret;
 }
 
 static void __exit ip6table_mangle_fini(void)
 {
 	unregister_pernet_subsys(&ip6table_mangle_net_ops);
+	xt_unregister_template(&packet_mangler);
 	kfree(mangle_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index b0292251e655..921c1723a01e 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -19,8 +19,6 @@ struct ip6table_nat_pernet {
 	struct nf_hook_ops *nf_nat_ops;
 };
 
-static int __net_init ip6table_nat_table_init(struct net *net);
-
 static unsigned int ip6table_nat_net_id __read_mostly;
 
 static const struct xt_table nf_nat_ipv6_table = {
@@ -31,7 +29,6 @@ static const struct xt_table nf_nat_ipv6_table = {
 			  (1 << NF_INET_LOCAL_IN),
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV6,
-	.table_init	= ip6table_nat_table_init,
 };
 
 static unsigned int ip6table_nat_do_chain(void *priv,
@@ -115,7 +112,7 @@ static void ip6t_nat_unregister_lookups(struct net *net)
 	kfree(ops);
 }
 
-static int __net_init ip6table_nat_table_init(struct net *net)
+static int ip6table_nat_table_init(struct net *net)
 {
 	struct ip6t_replace *repl;
 	int ret;
@@ -157,20 +154,23 @@ static struct pernet_operations ip6table_nat_net_ops = {
 
 static int __init ip6table_nat_init(void)
 {
-	int ret = register_pernet_subsys(&ip6table_nat_net_ops);
+	int ret = xt_register_template(&nf_nat_ipv6_table,
+				       ip6table_nat_table_init);
 
-	if (ret)
+	if (ret < 0)
 		return ret;
 
-	ret = ip6table_nat_table_init(&init_net);
+	ret = register_pernet_subsys(&ip6table_nat_net_ops);
 	if (ret)
-		unregister_pernet_subsys(&ip6table_nat_net_ops);
+		xt_unregister_template(&nf_nat_ipv6_table);
+
 	return ret;
 }
 
 static void __exit ip6table_nat_exit(void)
 {
 	unregister_pernet_subsys(&ip6table_nat_net_ops);
+	xt_unregister_template(&nf_nat_ipv6_table);
 }
 
 module_init(ip6table_nat_init);
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index f63c106c521e..4f2a04af71d3 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -11,8 +11,6 @@
 
 #define RAW_VALID_HOOKS ((1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_OUT))
 
-static int __net_init ip6table_raw_table_init(struct net *net);
-
 static bool raw_before_defrag __read_mostly;
 MODULE_PARM_DESC(raw_before_defrag, "Enable raw table before defrag");
 module_param(raw_before_defrag, bool, 0000);
@@ -23,7 +21,6 @@ static const struct xt_table packet_raw = {
 	.me = THIS_MODULE,
 	.af = NFPROTO_IPV6,
 	.priority = NF_IP6_PRI_RAW,
-	.table_init = ip6table_raw_table_init,
 };
 
 static const struct xt_table packet_raw_before_defrag = {
@@ -32,7 +29,6 @@ static const struct xt_table packet_raw_before_defrag = {
 	.me = THIS_MODULE,
 	.af = NFPROTO_IPV6,
 	.priority = NF_IP6_PRI_RAW_BEFORE_DEFRAG,
-	.table_init = ip6table_raw_table_init,
 };
 
 /* The work comes in here from netfilter.c. */
@@ -45,7 +41,7 @@ ip6table_raw_hook(void *priv, struct sk_buff *skb,
 
 static struct nf_hook_ops *rawtable_ops __read_mostly;
 
-static int __net_init ip6table_raw_table_init(struct net *net)
+static int ip6table_raw_table_init(struct net *net)
 {
 	struct ip6t_replace *repl;
 	const struct xt_table *table = &packet_raw;
@@ -79,37 +75,39 @@ static struct pernet_operations ip6table_raw_net_ops = {
 
 static int __init ip6table_raw_init(void)
 {
-	int ret;
 	const struct xt_table *table = &packet_raw;
+	int ret;
 
 	if (raw_before_defrag) {
 		table = &packet_raw_before_defrag;
-
 		pr_info("Enabling raw table before defrag\n");
 	}
 
+	ret = xt_register_template(table, ip6table_raw_table_init);
+	if (ret < 0)
+		return ret;
+
 	/* Register hooks */
 	rawtable_ops = xt_hook_ops_alloc(table, ip6table_raw_hook);
-	if (IS_ERR(rawtable_ops))
+	if (IS_ERR(rawtable_ops)) {
+		xt_unregister_template(table);
 		return PTR_ERR(rawtable_ops);
+	}
 
 	ret = register_pernet_subsys(&ip6table_raw_net_ops);
 	if (ret < 0) {
 		kfree(rawtable_ops);
+		xt_unregister_template(table);
 		return ret;
 	}
 
-	ret = ip6table_raw_table_init(&init_net);
-	if (ret) {
-		unregister_pernet_subsys(&ip6table_raw_net_ops);
-		kfree(rawtable_ops);
-	}
 	return ret;
 }
 
 static void __exit ip6table_raw_fini(void)
 {
 	unregister_pernet_subsys(&ip6table_raw_net_ops);
+	xt_unregister_template(&packet_raw);
 	kfree(rawtable_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 8dc335cf450b..931674034d8b 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -24,15 +24,12 @@ MODULE_DESCRIPTION("ip6tables security table, for MAC rules");
 				(1 << NF_INET_FORWARD) | \
 				(1 << NF_INET_LOCAL_OUT)
 
-static int __net_init ip6table_security_table_init(struct net *net);
-
 static const struct xt_table security_table = {
 	.name		= "security",
 	.valid_hooks	= SECURITY_VALID_HOOKS,
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV6,
 	.priority	= NF_IP6_PRI_SECURITY,
-	.table_init     = ip6table_security_table_init,
 };
 
 static unsigned int
@@ -44,7 +41,7 @@ ip6table_security_hook(void *priv, struct sk_buff *skb,
 
 static struct nf_hook_ops *sectbl_ops __read_mostly;
 
-static int __net_init ip6table_security_table_init(struct net *net)
+static int ip6table_security_table_init(struct net *net)
 {
 	struct ip6t_replace *repl;
 	int ret;
@@ -74,29 +71,32 @@ static struct pernet_operations ip6table_security_net_ops = {
 
 static int __init ip6table_security_init(void)
 {
-	int ret;
+	int ret = xt_register_template(&security_table,
+				       ip6table_security_table_init);
+
+	if (ret < 0)
+		return ret;
 
 	sectbl_ops = xt_hook_ops_alloc(&security_table, ip6table_security_hook);
-	if (IS_ERR(sectbl_ops))
+	if (IS_ERR(sectbl_ops)) {
+		xt_unregister_template(&security_table);
 		return PTR_ERR(sectbl_ops);
+	}
 
 	ret = register_pernet_subsys(&ip6table_security_net_ops);
 	if (ret < 0) {
 		kfree(sectbl_ops);
+		xt_unregister_template(&security_table);
 		return ret;
 	}
 
-	ret = ip6table_security_table_init(&init_net);
-	if (ret) {
-		unregister_pernet_subsys(&ip6table_security_net_ops);
-		kfree(sectbl_ops);
-	}
 	return ret;
 }
 
 static void __exit ip6table_security_fini(void)
 {
 	unregister_pernet_subsys(&ip6table_security_net_ops);
+	xt_unregister_template(&security_table);
 	kfree(sectbl_ops);
 }
 
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 84e58ee501a4..25524e393349 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -39,6 +39,20 @@ MODULE_DESCRIPTION("{ip,ip6,arp,eb}_tables backend module");
 #define XT_PCPU_BLOCK_SIZE 4096
 #define XT_MAX_TABLE_SIZE	(512 * 1024 * 1024)
 
+struct xt_template {
+	struct list_head list;
+
+	/* called when table is needed in the given netns */
+	int (*table_init)(struct net *net);
+
+	struct module *me;
+
+	/* A unique name... */
+	char name[XT_TABLE_MAXNAMELEN];
+};
+
+static struct list_head xt_templates[NFPROTO_NUMPROTO];
+
 struct xt_pernet {
 	struct list_head tables[NFPROTO_NUMPROTO];
 };
@@ -1221,48 +1235,43 @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 				    const char *name)
 {
 	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
-	struct xt_table *t, *found = NULL;
+	struct module *owner = NULL;
+	struct xt_template *tmpl;
+	struct xt_table *t;
 
 	mutex_lock(&xt[af].mutex);
 	list_for_each_entry(t, &xt_net->tables[af], list)
 		if (strcmp(t->name, name) == 0 && try_module_get(t->me))
 			return t;
 
-	if (net == &init_net)
-		goto out;
-
-	/* Table doesn't exist in this netns, re-try init */
-	xt_net = net_generic(&init_net, xt_pernet_id);
-	list_for_each_entry(t, &xt_net->tables[af], list) {
+	/* Table doesn't exist in this netns, check larval list */
+	list_for_each_entry(tmpl, &xt_templates[af], list) {
 		int err;
 
-		if (strcmp(t->name, name))
+		if (strcmp(tmpl->name, name))
 			continue;
-		if (!try_module_get(t->me))
+		if (!try_module_get(tmpl->me))
 			goto out;
+
+		owner = tmpl->me;
+
 		mutex_unlock(&xt[af].mutex);
-		err = t->table_init(net);
+		err = tmpl->table_init(net);
 		if (err < 0) {
-			module_put(t->me);
+			module_put(owner);
 			return ERR_PTR(err);
 		}
 
-		found = t;
-
 		mutex_lock(&xt[af].mutex);
 		break;
 	}
 
-	if (!found)
-		goto out;
-
-	xt_net = net_generic(net, xt_pernet_id);
 	/* and once again: */
 	list_for_each_entry(t, &xt_net->tables[af], list)
 		if (strcmp(t->name, name) == 0)
 			return t;
 
-	module_put(found->me);
+	module_put(owner);
  out:
 	mutex_unlock(&xt[af].mutex);
 	return ERR_PTR(-ENOENT);
@@ -1749,6 +1758,58 @@ xt_hook_ops_alloc(const struct xt_table *table, nf_hookfn *fn)
 }
 EXPORT_SYMBOL_GPL(xt_hook_ops_alloc);
 
+int xt_register_template(const struct xt_table *table,
+			 int (*table_init)(struct net *net))
+{
+	int ret = -EEXIST, af = table->af;
+	struct xt_template *t;
+
+	mutex_lock(&xt[af].mutex);
+
+	list_for_each_entry(t, &xt_templates[af], list) {
+		if (WARN_ON_ONCE(strcmp(table->name, t->name) == 0))
+			goto out_unlock;
+	}
+
+	ret = -ENOMEM;
+	t = kzalloc(sizeof(*t), GFP_KERNEL);
+	if (!t)
+		goto out_unlock;
+
+	BUILD_BUG_ON(sizeof(t->name) != sizeof(table->name));
+
+	strscpy(t->name, table->name, sizeof(t->name));
+	t->table_init = table_init;
+	t->me = table->me;
+	list_add(&t->list, &xt_templates[af]);
+	ret = 0;
+out_unlock:
+	mutex_unlock(&xt[af].mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(xt_register_template);
+
+void xt_unregister_template(const struct xt_table *table)
+{
+	struct xt_template *t;
+	int af = table->af;
+
+	mutex_lock(&xt[af].mutex);
+	list_for_each_entry(t, &xt_templates[af], list) {
+		if (strcmp(table->name, t->name))
+			continue;
+
+		list_del(&t->list);
+		mutex_unlock(&xt[af].mutex);
+		kfree(t);
+		return;
+	}
+
+	mutex_unlock(&xt[af].mutex);
+	WARN_ON_ONCE(1);
+}
+EXPORT_SYMBOL_GPL(xt_unregister_template);
+
 int xt_proto_init(struct net *net, u_int8_t af)
 {
 #ifdef CONFIG_PROC_FS
@@ -1937,6 +1998,7 @@ static int __init xt_init(void)
 #endif
 		INIT_LIST_HEAD(&xt[i].target);
 		INIT_LIST_HEAD(&xt[i].match);
+		INIT_LIST_HEAD(&xt_templates[i]);
 	}
 	rv = register_pernet_subsys(&xt_net_ops);
 	if (rv < 0)
-- 
2.31.1

