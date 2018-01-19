From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 20/32] netfilter: nf_defrag: mark xt_table structures 'const' again
Date: Fri, 19 Jan 2018 20:10:29 +0100
Message-ID: <20180119191041.25804-21-pablo@netfilter.org>
References: <20180119191041.25804-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45194 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932456AbeASTLL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 14:11:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A20192EFECB
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:11:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 84A81DA859
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:11:06 +0100 (CET)
In-Reply-To: <20180119191041.25804-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

As a side-effect of adding the module option, we now get a section
mismatch warning:

WARNING: net/ipv4/netfilter/iptable_raw.o(.data+0x1c): Section mismatch in reference from the variable packet_raw to the function .init.text:iptable_raw_table_init()
The variable packet_raw references
the function __init iptable_raw_table_init()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Apparently it's ok to link to a __net_init function from .rodata but not
from .data. We can address this by rearranging the logic so that the
structure is read-only again. Instead of writing to the .priority field
later, we have an extra copies of the structure with that flag. An added
advantage is that that we don't have writable function pointers with this
approach.

Fixes: 902d6a4c2a4f ("netfilter: nf_defrag: Skip defrag if NOTRACK is set")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/iptable_raw.c  | 24 +++++++++++++++++++-----
 net/ipv6/netfilter/ip6table_raw.c | 24 +++++++++++++++++++-----
 2 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 29b64d3024e0..960625aabf04 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -17,7 +17,7 @@ static bool raw_before_defrag __read_mostly;
 MODULE_PARM_DESC(raw_before_defrag, "Enable raw table before defrag");
 module_param(raw_before_defrag, bool, 0000);
 
-static struct xt_table packet_raw = {
+static const struct xt_table packet_raw = {
 	.name = "raw",
 	.valid_hooks =  RAW_VALID_HOOKS,
 	.me = THIS_MODULE,
@@ -26,6 +26,15 @@ static struct xt_table packet_raw = {
 	.table_init = iptable_raw_table_init,
 };
 
+static const struct xt_table packet_raw_before_defrag = {
+	.name = "raw",
+	.valid_hooks =  RAW_VALID_HOOKS,
+	.me = THIS_MODULE,
+	.af = NFPROTO_IPV4,
+	.priority = NF_IP_PRI_RAW_BEFORE_DEFRAG,
+	.table_init = iptable_raw_table_init,
+};
+
 /* The work comes in here from netfilter.c. */
 static unsigned int
 iptable_raw_hook(void *priv, struct sk_buff *skb,
@@ -39,15 +48,19 @@ static struct nf_hook_ops *rawtable_ops __read_mostly;
 static int __net_init iptable_raw_table_init(struct net *net)
 {
 	struct ipt_replace *repl;
+	const struct xt_table *table = &packet_raw;
 	int ret;
 
+	if (raw_before_defrag)
+		table = &packet_raw_before_defrag;
+
 	if (net->ipv4.iptable_raw)
 		return 0;
 
-	repl = ipt_alloc_initial_table(&packet_raw);
+	repl = ipt_alloc_initial_table(table);
 	if (repl == NULL)
 		return -ENOMEM;
-	ret = ipt_register_table(net, &packet_raw, repl, rawtable_ops,
+	ret = ipt_register_table(net, table, repl, rawtable_ops,
 				 &net->ipv4.iptable_raw);
 	kfree(repl);
 	return ret;
@@ -68,14 +81,15 @@ static struct pernet_operations iptable_raw_net_ops = {
 static int __init iptable_raw_init(void)
 {
 	int ret;
+	const struct xt_table *table = &packet_raw;
 
 	if (raw_before_defrag) {
-		packet_raw.priority = NF_IP_PRI_RAW_BEFORE_DEFRAG;
+		table = &packet_raw_before_defrag;
 
 		pr_info("Enabling raw table before defrag\n");
 	}
 
-	rawtable_ops = xt_hook_ops_alloc(&packet_raw, iptable_raw_hook);
+	rawtable_ops = xt_hook_ops_alloc(table, iptable_raw_hook);
 	if (IS_ERR(rawtable_ops))
 		return PTR_ERR(rawtable_ops);
 
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 3df7383f96d0..710fa0806c37 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -16,7 +16,7 @@ static bool raw_before_defrag __read_mostly;
 MODULE_PARM_DESC(raw_before_defrag, "Enable raw table before defrag");
 module_param(raw_before_defrag, bool, 0000);
 
-static struct xt_table packet_raw = {
+static const struct xt_table packet_raw = {
 	.name = "raw",
 	.valid_hooks = RAW_VALID_HOOKS,
 	.me = THIS_MODULE,
@@ -25,6 +25,15 @@ static struct xt_table packet_raw = {
 	.table_init = ip6table_raw_table_init,
 };
 
+static const struct xt_table packet_raw_before_defrag = {
+	.name = "raw",
+	.valid_hooks = RAW_VALID_HOOKS,
+	.me = THIS_MODULE,
+	.af = NFPROTO_IPV6,
+	.priority = NF_IP6_PRI_RAW_BEFORE_DEFRAG,
+	.table_init = ip6table_raw_table_init,
+};
+
 /* The work comes in here from netfilter.c. */
 static unsigned int
 ip6table_raw_hook(void *priv, struct sk_buff *skb,
@@ -38,15 +47,19 @@ static struct nf_hook_ops *rawtable_ops __read_mostly;
 static int __net_init ip6table_raw_table_init(struct net *net)
 {
 	struct ip6t_replace *repl;
+	const struct xt_table *table = &packet_raw;
 	int ret;
 
+	if (raw_before_defrag)
+		table = &packet_raw_before_defrag;
+
 	if (net->ipv6.ip6table_raw)
 		return 0;
 
-	repl = ip6t_alloc_initial_table(&packet_raw);
+	repl = ip6t_alloc_initial_table(table);
 	if (repl == NULL)
 		return -ENOMEM;
-	ret = ip6t_register_table(net, &packet_raw, repl, rawtable_ops,
+	ret = ip6t_register_table(net, table, repl, rawtable_ops,
 				  &net->ipv6.ip6table_raw);
 	kfree(repl);
 	return ret;
@@ -67,15 +80,16 @@ static struct pernet_operations ip6table_raw_net_ops = {
 static int __init ip6table_raw_init(void)
 {
 	int ret;
+	const struct xt_table *table = &packet_raw;
 
 	if (raw_before_defrag) {
-		packet_raw.priority = NF_IP6_PRI_RAW_BEFORE_DEFRAG;
+		table = &packet_raw_before_defrag;
 
 		pr_info("Enabling raw table before defrag\n");
 	}
 
 	/* Register hooks */
-	rawtable_ops = xt_hook_ops_alloc(&packet_raw, ip6table_raw_hook);
+	rawtable_ops = xt_hook_ops_alloc(table, ip6table_raw_hook);
 	if (IS_ERR(rawtable_ops))
 		return PTR_ERR(rawtable_ops);
 
-- 
2.11.0

