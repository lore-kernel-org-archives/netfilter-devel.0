From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next 1/2] netfilter: nf_defrag: mark xt_table structures 'const' again
Date: Mon, 15 Jan 2018 16:49:05 +0100
Message-ID: <20180115154918.4176669-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

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
---
This might not be the best fix for the issue, please have a look if you
can come up with something nicer, or just apply this version.
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
2.9.0
