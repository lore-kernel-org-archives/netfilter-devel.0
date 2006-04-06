From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/12]: Clean up hook registration
Date: Thu,  6 Apr 2006 12:04:55 +0200 (MEST)
Message-ID: <20060406100455.17409.91188.sendpatchset@localhost.localdomain>
References: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: Clean up hook registration

Clean up hook registration by makeing use of the new mass registration and
unregistration helpers.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2f8e62d3a554aee067771c5146a1e29feecd2758
tree ea5cdb8d6c319c334007c87c1e859ae0ed41f3f5
parent 3bf0d209e539917efcc5286b8f1cab2856ebdd49
author Patrick McHardy <kaber@trash.net> Thu, 06 Apr 2006 11:34:13 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 06 Apr 2006 11:34:13 +0200

 net/ipv4/netfilter/arptable_filter.c           |   19 +-
 net/ipv4/netfilter/ip_conntrack_standalone.c   |  180 ++++++++---------------
 net/ipv4/netfilter/ip_nat_standalone.c         |  143 +++++++-----------
 net/ipv4/netfilter/iptable_filter.c            |   21 ---
 net/ipv4/netfilter/iptable_mangle.c            |   33 ----
 net/ipv4/netfilter/iptable_raw.c               |   35 ++--
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |  189 ++++++++----------------
 net/ipv6/netfilter/ip6table_filter.c           |   21 ---
 net/ipv6/netfilter/ip6table_mangle.c           |   33 ----
 net/ipv6/netfilter/ip6table_raw.c              |   15 --
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |  143 ++++++------------
 11 files changed, 253 insertions(+), 579 deletions(-)

diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index d0d379c..d7c472f 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -181,33 +181,26 @@ static struct nf_hook_ops arpt_ops[] = {
 
 static int __init arptable_filter_init(void)
 {
-	int ret, i;
+	int ret;
 
 	/* Register table */
 	ret = arpt_register_table(&packet_filter, &initial_table.repl);
 	if (ret < 0)
 		return ret;
 
-	for (i = 0; i < ARRAY_SIZE(arpt_ops); i++)
-		if ((ret = nf_register_hook(&arpt_ops[i])) < 0)
-			goto cleanup_hooks;
+	ret = nf_register_hooks(arpt_ops, ARRAY_SIZE(arpt_ops));
+	if (ret < 0)
+		goto cleanup_table;
 	return ret;
 
-cleanup_hooks:
-	while (--i >= 0)
-		nf_unregister_hook(&arpt_ops[i]);
-
+cleanup_table:
 	arpt_unregister_table(&packet_filter);
 	return ret;
 }
 
 static void __exit arptable_filter_fini(void)
 {
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(arpt_ops); i++)
-		nf_unregister_hook(&arpt_ops[i]);
-
+	nf_unregister_hooks(arpt_ops, ARRAY_SIZE(arpt_ops));
 	arpt_unregister_table(&packet_filter);
 }
 
diff --git a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
index 5207602..adc1a0f 100644
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c
@@ -469,70 +469,63 @@ static unsigned int ip_conntrack_local(u
 
 /* Connection tracking may drop packets, but never alters them, so
    make it the first hook. */
-static struct nf_hook_ops ip_conntrack_defrag_ops = {
-	.hook		= ip_conntrack_defrag,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_PRE_ROUTING,
-	.priority	= NF_IP_PRI_CONNTRACK_DEFRAG,
-};
-
-static struct nf_hook_ops ip_conntrack_in_ops = {
-	.hook		= ip_conntrack_in,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_PRE_ROUTING,
-	.priority	= NF_IP_PRI_CONNTRACK,
-};
-
-static struct nf_hook_ops ip_conntrack_defrag_local_out_ops = {
-	.hook		= ip_conntrack_defrag,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_LOCAL_OUT,
-	.priority	= NF_IP_PRI_CONNTRACK_DEFRAG,
-};
-
-static struct nf_hook_ops ip_conntrack_local_out_ops = {
-	.hook		= ip_conntrack_local,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_LOCAL_OUT,
-	.priority	= NF_IP_PRI_CONNTRACK,
-};
-
-/* helpers */
-static struct nf_hook_ops ip_conntrack_helper_out_ops = {
-	.hook		= ip_conntrack_help,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_POST_ROUTING,
-	.priority	= NF_IP_PRI_CONNTRACK_HELPER,
-};
-
-static struct nf_hook_ops ip_conntrack_helper_in_ops = {
-	.hook		= ip_conntrack_help,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_LOCAL_IN,
-	.priority	= NF_IP_PRI_CONNTRACK_HELPER,
-};
-
-/* Refragmenter; last chance. */
-static struct nf_hook_ops ip_conntrack_out_ops = {
-	.hook		= ip_confirm,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_POST_ROUTING,
-	.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
-};
-
-static struct nf_hook_ops ip_conntrack_local_in_ops = {
-	.hook		= ip_confirm,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_LOCAL_IN,
-	.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
+static struct nf_hook_ops ip_conntrack_ops[] = {
+	{
+		.hook		= ip_conntrack_defrag,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_PRE_ROUTING,
+		.priority	= NF_IP_PRI_CONNTRACK_DEFRAG,
+	},
+	{
+		.hook		= ip_conntrack_in,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_PRE_ROUTING,
+		.priority	= NF_IP_PRI_CONNTRACK,
+	},
+	{
+		.hook		= ip_conntrack_defrag,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_LOCAL_OUT,
+		.priority	= NF_IP_PRI_CONNTRACK_DEFRAG,
+	},
+	{
+		.hook		= ip_conntrack_local,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_LOCAL_OUT,
+		.priority	= NF_IP_PRI_CONNTRACK,
+	},
+	{
+		.hook		= ip_conntrack_help,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_POST_ROUTING,
+		.priority	= NF_IP_PRI_CONNTRACK_HELPER,
+	},
+	{
+		.hook		= ip_conntrack_help,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_LOCAL_IN,
+		.priority	= NF_IP_PRI_CONNTRACK_HELPER,
+	},
+	{
+		.hook		= ip_confirm,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_POST_ROUTING,
+		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
+	},
+	{
+		.hook		= ip_confirm,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_LOCAL_IN,
+		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
+	},
 };
 
 /* Sysctl support */
@@ -813,52 +806,17 @@ static int init_or_cleanup(int init)
 	proc_stat->owner = THIS_MODULE;
 #endif
 
-	ret = nf_register_hook(&ip_conntrack_defrag_ops);
+	ret = nf_register_hooks(ip_conntrack_ops, ARRAY_SIZE(ip_conntrack_ops));
 	if (ret < 0) {
-		printk("ip_conntrack: can't register pre-routing defrag hook.\n");
+		printk("ip_conntrack: can't register hooks.\n");
 		goto cleanup_proc_stat;
 	}
-	ret = nf_register_hook(&ip_conntrack_defrag_local_out_ops);
-	if (ret < 0) {
-		printk("ip_conntrack: can't register local_out defrag hook.\n");
-		goto cleanup_defragops;
-	}
-	ret = nf_register_hook(&ip_conntrack_in_ops);
-	if (ret < 0) {
-		printk("ip_conntrack: can't register pre-routing hook.\n");
-		goto cleanup_defraglocalops;
-	}
-	ret = nf_register_hook(&ip_conntrack_local_out_ops);
-	if (ret < 0) {
-		printk("ip_conntrack: can't register local out hook.\n");
-		goto cleanup_inops;
-	}
-	ret = nf_register_hook(&ip_conntrack_helper_in_ops);
-	if (ret < 0) {
-		printk("ip_conntrack: can't register local in helper hook.\n");
-		goto cleanup_inandlocalops;
-	}
-	ret = nf_register_hook(&ip_conntrack_helper_out_ops);
-	if (ret < 0) {
-		printk("ip_conntrack: can't register postrouting helper hook.\n");
-		goto cleanup_helperinops;
-	}
-	ret = nf_register_hook(&ip_conntrack_out_ops);
-	if (ret < 0) {
-		printk("ip_conntrack: can't register post-routing hook.\n");
-		goto cleanup_helperoutops;
-	}
-	ret = nf_register_hook(&ip_conntrack_local_in_ops);
-	if (ret < 0) {
-		printk("ip_conntrack: can't register local in hook.\n");
-		goto cleanup_inoutandlocalops;
-	}
 #ifdef CONFIG_SYSCTL
 	ip_ct_sysctl_header = register_sysctl_table(ip_ct_net_table, 0);
 	if (ip_ct_sysctl_header == NULL) {
 		printk("ip_conntrack: can't register to sysctl.\n");
 		ret = -ENOMEM;
-		goto cleanup_localinops;
+		goto cleanup_hooks;
 	}
 #endif
 
@@ -868,23 +826,9 @@ static int init_or_cleanup(int init)
 	synchronize_net();
 #ifdef CONFIG_SYSCTL
  	unregister_sysctl_table(ip_ct_sysctl_header);
- cleanup_localinops:
+ cleanup_hooks:
 #endif
-	nf_unregister_hook(&ip_conntrack_local_in_ops);
- cleanup_inoutandlocalops:
-	nf_unregister_hook(&ip_conntrack_out_ops);
- cleanup_helperoutops:
-	nf_unregister_hook(&ip_conntrack_helper_out_ops);
- cleanup_helperinops:
-	nf_unregister_hook(&ip_conntrack_helper_in_ops);
- cleanup_inandlocalops:
-	nf_unregister_hook(&ip_conntrack_local_out_ops);
- cleanup_inops:
-	nf_unregister_hook(&ip_conntrack_in_ops);
- cleanup_defraglocalops:
-	nf_unregister_hook(&ip_conntrack_defrag_local_out_ops);
- cleanup_defragops:
-	nf_unregister_hook(&ip_conntrack_defrag_ops);
+	nf_unregister_hooks(ip_conntrack_ops, ARRAY_SIZE(ip_conntrack_ops));
  cleanup_proc_stat:
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("ip_conntrack", proc_net_stat);
diff --git a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
index 3505b0d..5f02f43 100644
--- a/net/ipv4/netfilter/ip_nat_standalone.c
+++ b/net/ipv4/netfilter/ip_nat_standalone.c
@@ -299,61 +299,57 @@ ip_nat_adjust(unsigned int hooknum,
 
 /* We must be after connection tracking and before packet filtering. */
 
-/* Before packet filtering, change destination */
-static struct nf_hook_ops ip_nat_in_ops = {
-	.hook		= ip_nat_in,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_PRE_ROUTING,
-	.priority	= NF_IP_PRI_NAT_DST,
+static struct nf_hook_ops ip_nat_ops[] = {
+	/* Before packet filtering, change destination */
+	{
+		.hook		= ip_nat_in,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_PRE_ROUTING,
+		.priority	= NF_IP_PRI_NAT_DST,
+	},
+	/* After packet filtering, change source */
+	{
+		.hook		= ip_nat_out,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_POST_ROUTING,
+		.priority	= NF_IP_PRI_NAT_SRC,
+	},
+	/* After conntrack, adjust sequence number */
+	{
+		.hook		= ip_nat_adjust,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_POST_ROUTING,
+		.priority	= NF_IP_PRI_NAT_SEQ_ADJUST,
+	},
+	/* Before packet filtering, change destination */
+	{
+		.hook		= ip_nat_local_fn,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_LOCAL_OUT,
+		.priority	= NF_IP_PRI_NAT_DST,
+	},
+	/* After packet filtering, change source */
+	{
+		.hook		= ip_nat_fn,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_LOCAL_IN,
+		.priority	= NF_IP_PRI_NAT_SRC,
+	},
+	/* After conntrack, adjust sequence number */
+	{
+		.hook		= ip_nat_adjust,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_LOCAL_IN,
+		.priority	= NF_IP_PRI_NAT_SEQ_ADJUST,
+	},
 };
 
-/* After packet filtering, change source */
-static struct nf_hook_ops ip_nat_out_ops = {
-	.hook		= ip_nat_out,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_POST_ROUTING,
-	.priority	= NF_IP_PRI_NAT_SRC,
-};
-
-/* After conntrack, adjust sequence number */
-static struct nf_hook_ops ip_nat_adjust_out_ops = {
-	.hook		= ip_nat_adjust,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_POST_ROUTING,
-	.priority	= NF_IP_PRI_NAT_SEQ_ADJUST,
-};
-
-/* Before packet filtering, change destination */
-static struct nf_hook_ops ip_nat_local_out_ops = {
-	.hook		= ip_nat_local_fn,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_LOCAL_OUT,
-	.priority	= NF_IP_PRI_NAT_DST,
-};
-
-/* After packet filtering, change source for reply packets of LOCAL_OUT DNAT */
-static struct nf_hook_ops ip_nat_local_in_ops = {
-	.hook		= ip_nat_fn,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_LOCAL_IN,
-	.priority	= NF_IP_PRI_NAT_SRC,
-};
-
-/* After conntrack, adjust sequence number */
-static struct nf_hook_ops ip_nat_adjust_in_ops = {
-	.hook		= ip_nat_adjust,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_LOCAL_IN,
-	.priority	= NF_IP_PRI_NAT_SEQ_ADJUST,
-};
-
-
 static int init_or_cleanup(int init)
 {
 	int ret = 0;
@@ -371,50 +367,15 @@ static int init_or_cleanup(int init)
 		printk("ip_nat_init: can't setup rules.\n");
 		goto cleanup_decode_session;
 	}
-	ret = nf_register_hook(&ip_nat_in_ops);
+	ret = nf_register_hooks(ip_nat_ops, ARRAY_SIZE(ip_nat_ops));
 	if (ret < 0) {
-		printk("ip_nat_init: can't register in hook.\n");
+		printk("ip_nat_init: can't register hooks.\n");
 		goto cleanup_rule_init;
 	}
-	ret = nf_register_hook(&ip_nat_out_ops);
-	if (ret < 0) {
-		printk("ip_nat_init: can't register out hook.\n");
-		goto cleanup_inops;
-	}
-	ret = nf_register_hook(&ip_nat_adjust_in_ops);
-	if (ret < 0) {
-		printk("ip_nat_init: can't register adjust in hook.\n");
-		goto cleanup_outops;
-	}
-	ret = nf_register_hook(&ip_nat_adjust_out_ops);
-	if (ret < 0) {
-		printk("ip_nat_init: can't register adjust out hook.\n");
-		goto cleanup_adjustin_ops;
-	}
-	ret = nf_register_hook(&ip_nat_local_out_ops);
-	if (ret < 0) {
-		printk("ip_nat_init: can't register local out hook.\n");
-		goto cleanup_adjustout_ops;
-	}
-	ret = nf_register_hook(&ip_nat_local_in_ops);
-	if (ret < 0) {
-		printk("ip_nat_init: can't register local in hook.\n");
-		goto cleanup_localoutops;
-	}
 	return ret;
 
  cleanup:
-	nf_unregister_hook(&ip_nat_local_in_ops);
- cleanup_localoutops:
-	nf_unregister_hook(&ip_nat_local_out_ops);
- cleanup_adjustout_ops:
-	nf_unregister_hook(&ip_nat_adjust_out_ops);
- cleanup_adjustin_ops:
-	nf_unregister_hook(&ip_nat_adjust_in_ops);
- cleanup_outops:
-	nf_unregister_hook(&ip_nat_out_ops);
- cleanup_inops:
-	nf_unregister_hook(&ip_nat_in_ops);
+	nf_unregister_hooks(ip_nat_ops, ARRAY_SIZE(ip_nat_ops));
  cleanup_rule_init:
 	ip_nat_rule_cleanup();
  cleanup_decode_session:
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 3d80aef..7f41748 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -157,37 +157,20 @@ static int __init iptable_filter_init(vo
 		return ret;
 
 	/* Register hooks */
-	ret = nf_register_hook(&ipt_ops[0]);
+	ret = nf_register_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
 	if (ret < 0)
 		goto cleanup_table;
 
-	ret = nf_register_hook(&ipt_ops[1]);
-	if (ret < 0)
-		goto cleanup_hook0;
-
-	ret = nf_register_hook(&ipt_ops[2]);
-	if (ret < 0)
-		goto cleanup_hook1;
-
 	return ret;
 
- cleanup_hook1:
-	nf_unregister_hook(&ipt_ops[1]);
- cleanup_hook0:
-	nf_unregister_hook(&ipt_ops[0]);
  cleanup_table:
 	ipt_unregister_table(&packet_filter);
-
 	return ret;
 }
 
 static void __exit iptable_filter_fini(void)
 {
-	unsigned int i;
-
-	for (i = 0; i < sizeof(ipt_ops)/sizeof(struct nf_hook_ops); i++)
-		nf_unregister_hook(&ipt_ops[i]);
-
+	nf_unregister_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
 	ipt_unregister_table(&packet_filter);
 }
 
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 412fc96..397b95c 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -211,49 +211,20 @@ static int __init iptable_mangle_init(vo
 		return ret;
 
 	/* Register hooks */
-	ret = nf_register_hook(&ipt_ops[0]);
+	ret = nf_register_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
 	if (ret < 0)
 		goto cleanup_table;
 
-	ret = nf_register_hook(&ipt_ops[1]);
-	if (ret < 0)
-		goto cleanup_hook0;
-
-	ret = nf_register_hook(&ipt_ops[2]);
-	if (ret < 0)
-		goto cleanup_hook1;
-
-	ret = nf_register_hook(&ipt_ops[3]);
-	if (ret < 0)
-		goto cleanup_hook2;
-
-	ret = nf_register_hook(&ipt_ops[4]);
-	if (ret < 0)
-		goto cleanup_hook3;
-
 	return ret;
 
- cleanup_hook3:
-        nf_unregister_hook(&ipt_ops[3]);
- cleanup_hook2:
-        nf_unregister_hook(&ipt_ops[2]);
- cleanup_hook1:
-	nf_unregister_hook(&ipt_ops[1]);
- cleanup_hook0:
-	nf_unregister_hook(&ipt_ops[0]);
  cleanup_table:
 	ipt_unregister_table(&packet_mangler);
-
 	return ret;
 }
 
 static void __exit iptable_mangle_fini(void)
 {
-	unsigned int i;
-
-	for (i = 0; i < sizeof(ipt_ops)/sizeof(struct nf_hook_ops); i++)
-		nf_unregister_hook(&ipt_ops[i]);
-
+	nf_unregister_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
 	ipt_unregister_table(&packet_mangler);
 }
 
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 03cc79a..be43dfb 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -101,18 +101,18 @@ ipt_hook(unsigned int hook,
 /* 'raw' is the very first table. */
 static struct nf_hook_ops ipt_ops[] = {
 	{
-	  .hook = ipt_hook, 
-	  .pf = PF_INET, 
-	  .hooknum = NF_IP_PRE_ROUTING, 
-	  .priority = NF_IP_PRI_RAW,
-	  .owner = THIS_MODULE,
+		.hook = ipt_hook,
+		.pf = PF_INET,
+		.hooknum = NF_IP_PRE_ROUTING,
+		.priority = NF_IP_PRI_RAW,
+		.owner = THIS_MODULE,
 	},
 	{
-	  .hook = ipt_hook, 
-	  .pf = PF_INET, 
-	  .hooknum = NF_IP_LOCAL_OUT, 
-	  .priority = NF_IP_PRI_RAW,
-	  .owner = THIS_MODULE,
+		.hook = ipt_hook,
+		.pf = PF_INET,
+		.hooknum = NF_IP_LOCAL_OUT,
+		.priority = NF_IP_PRI_RAW,
+		.owner = THIS_MODULE,
 	},
 };
 
@@ -126,31 +126,20 @@ static int __init iptable_raw_init(void)
 		return ret;
 
 	/* Register hooks */
-	ret = nf_register_hook(&ipt_ops[0]);
+	ret = nf_register_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
 	if (ret < 0)
 		goto cleanup_table;
 
-	ret = nf_register_hook(&ipt_ops[1]);
-	if (ret < 0)
-		goto cleanup_hook0;
-
 	return ret;
 
- cleanup_hook0:
-	nf_unregister_hook(&ipt_ops[0]);
  cleanup_table:
 	ipt_unregister_table(&packet_raw);
-
 	return ret;
 }
 
 static void __exit iptable_raw_fini(void)
 {
-	unsigned int i;
-
-	for (i = 0; i < sizeof(ipt_ops)/sizeof(struct nf_hook_ops); i++)
-		nf_unregister_hook(&ipt_ops[i]);
-
+	nf_unregister_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
 	ipt_unregister_table(&packet_raw);
 }
 
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 4afbc69..3fadacc 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -210,71 +210,63 @@ static unsigned int ipv4_conntrack_local
 
 /* Connection tracking may drop packets, but never alters them, so
    make it the first hook. */
-static struct nf_hook_ops ipv4_conntrack_defrag_ops = {
-	.hook		= ipv4_conntrack_defrag,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_PRE_ROUTING,
-	.priority	= NF_IP_PRI_CONNTRACK_DEFRAG,
-};
-
-static struct nf_hook_ops ipv4_conntrack_in_ops = {
-	.hook		= ipv4_conntrack_in,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_PRE_ROUTING,
-	.priority	= NF_IP_PRI_CONNTRACK,
-};
-
-static struct nf_hook_ops ipv4_conntrack_defrag_local_out_ops = {
-	.hook           = ipv4_conntrack_defrag,
-	.owner          = THIS_MODULE,
-	.pf             = PF_INET,
-	.hooknum        = NF_IP_LOCAL_OUT,
-	.priority       = NF_IP_PRI_CONNTRACK_DEFRAG,
-};
-
-static struct nf_hook_ops ipv4_conntrack_local_out_ops = {
-	.hook		= ipv4_conntrack_local,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_LOCAL_OUT,
-	.priority	= NF_IP_PRI_CONNTRACK,
-};
-
-/* helpers */
-static struct nf_hook_ops ipv4_conntrack_helper_out_ops = {
-	.hook		= ipv4_conntrack_help,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_POST_ROUTING,
-	.priority	= NF_IP_PRI_CONNTRACK_HELPER,
-};
-
-static struct nf_hook_ops ipv4_conntrack_helper_in_ops = {
-	.hook		= ipv4_conntrack_help,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_LOCAL_IN,
-	.priority	= NF_IP_PRI_CONNTRACK_HELPER,
-};
-
-
-/* Refragmenter; last chance. */
-static struct nf_hook_ops ipv4_conntrack_out_ops = {
-	.hook		= ipv4_confirm,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_POST_ROUTING,
-	.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
-};
-
-static struct nf_hook_ops ipv4_conntrack_local_in_ops = {
-	.hook		= ipv4_confirm,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET,
-	.hooknum	= NF_IP_LOCAL_IN,
-	.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
+static struct nf_hook_ops ipv4_conntrack_ops[] = {
+	{
+		.hook		= ipv4_conntrack_defrag,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_PRE_ROUTING,
+		.priority	= NF_IP_PRI_CONNTRACK_DEFRAG,
+	},
+	{
+		.hook		= ipv4_conntrack_in,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_PRE_ROUTING,
+		.priority	= NF_IP_PRI_CONNTRACK,
+	},
+	{
+		.hook           = ipv4_conntrack_defrag,
+		.owner          = THIS_MODULE,
+		.pf             = PF_INET,
+		.hooknum        = NF_IP_LOCAL_OUT,
+		.priority       = NF_IP_PRI_CONNTRACK_DEFRAG,
+	},
+	{
+		.hook		= ipv4_conntrack_local,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_LOCAL_OUT,
+		.priority	= NF_IP_PRI_CONNTRACK,
+	},
+	{
+		.hook		= ipv4_conntrack_help,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_POST_ROUTING,
+		.priority	= NF_IP_PRI_CONNTRACK_HELPER,
+	},
+	{
+		.hook		= ipv4_conntrack_help,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_LOCAL_IN,
+		.priority	= NF_IP_PRI_CONNTRACK_HELPER,
+	},
+	{
+		.hook		= ipv4_confirm,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_POST_ROUTING,
+		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
+	},
+	{
+		.hook		= ipv4_confirm,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_LOCAL_IN,
+		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
+	},
 };
 
 #ifdef CONFIG_SYSCTL
@@ -476,59 +468,18 @@ static int init_or_cleanup(int init)
 		goto cleanup_icmp;
 	}
 
-	ret = nf_register_hook(&ipv4_conntrack_defrag_ops);
+	ret = nf_register_hooks(ipv4_conntrack_ops,
+				ARRAY_SIZE(ipv4_conntrack_ops));
 	if (ret < 0) {
-		printk("nf_conntrack_ipv4: can't register pre-routing defrag hook.\n");
+		printk("nf_conntrack_ipv4: can't register hooks.\n");
 		goto cleanup_ipv4;
 	}
-	ret = nf_register_hook(&ipv4_conntrack_defrag_local_out_ops);
-	if (ret < 0) {
-		printk("nf_conntrack_ipv4: can't register local_out defrag hook.\n");
-		goto cleanup_defragops;
-	}
-
-	ret = nf_register_hook(&ipv4_conntrack_in_ops);
-	if (ret < 0) {
-		printk("nf_conntrack_ipv4: can't register pre-routing hook.\n");
-		goto cleanup_defraglocalops;
-	}
-
-	ret = nf_register_hook(&ipv4_conntrack_local_out_ops);
-	if (ret < 0) {
-		printk("nf_conntrack_ipv4: can't register local out hook.\n");
-		goto cleanup_inops;
-	}
-
-	ret = nf_register_hook(&ipv4_conntrack_helper_in_ops);
-	if (ret < 0) {
-		printk("nf_conntrack_ipv4: can't register local helper hook.\n");
-		goto cleanup_inandlocalops;
-	}
-
-	ret = nf_register_hook(&ipv4_conntrack_helper_out_ops);
-	if (ret < 0) {
-		printk("nf_conntrack_ipv4: can't register postrouting helper hook.\n");
-		goto cleanup_helperinops;
-	}
-
-	ret = nf_register_hook(&ipv4_conntrack_out_ops);
-	if (ret < 0) {
-		printk("nf_conntrack_ipv4: can't register post-routing hook.\n");
-		goto cleanup_helperoutops;
-	}
-
-	ret = nf_register_hook(&ipv4_conntrack_local_in_ops);
-	if (ret < 0) {
-		printk("nf_conntrack_ipv4: can't register local in hook.\n");
-		goto cleanup_inoutandlocalops;
-	}
-
 #ifdef CONFIG_SYSCTL
 	nf_ct_ipv4_sysctl_header = register_sysctl_table(nf_ct_net_table, 0);
 	if (nf_ct_ipv4_sysctl_header == NULL) {
 		printk("nf_conntrack: can't register to sysctl.\n");
 		ret = -ENOMEM;
-		goto cleanup_localinops;
+		goto cleanup_hooks;
 	}
 #endif
 	return ret;
@@ -537,23 +488,9 @@ static int init_or_cleanup(int init)
 	synchronize_net();
 #ifdef CONFIG_SYSCTL
  	unregister_sysctl_table(nf_ct_ipv4_sysctl_header);
- cleanup_localinops:
+ cleanup_hooks:
 #endif
-	nf_unregister_hook(&ipv4_conntrack_local_in_ops);
- cleanup_inoutandlocalops:
-	nf_unregister_hook(&ipv4_conntrack_out_ops);
- cleanup_helperoutops:
-	nf_unregister_hook(&ipv4_conntrack_helper_out_ops);
- cleanup_helperinops:
-	nf_unregister_hook(&ipv4_conntrack_helper_in_ops);
- cleanup_inandlocalops:
-	nf_unregister_hook(&ipv4_conntrack_local_out_ops);
- cleanup_inops:
-	nf_unregister_hook(&ipv4_conntrack_in_ops);
- cleanup_defraglocalops:
-	nf_unregister_hook(&ipv4_conntrack_defrag_local_out_ops);
- cleanup_defragops:
-	nf_unregister_hook(&ipv4_conntrack_defrag_ops);
+	nf_unregister_hooks(ipv4_conntrack_ops, ARRAY_SIZE(ipv4_conntrack_ops));
  cleanup_ipv4:
 	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv4);
  cleanup_icmp:
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index e5e724d..60976c0 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -177,37 +177,20 @@ static int __init ip6table_filter_init(v
 		return ret;
 
 	/* Register hooks */
-	ret = nf_register_hook(&ip6t_ops[0]);
+	ret = nf_register_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
 	if (ret < 0)
 		goto cleanup_table;
 
-	ret = nf_register_hook(&ip6t_ops[1]);
-	if (ret < 0)
-		goto cleanup_hook0;
-
-	ret = nf_register_hook(&ip6t_ops[2]);
-	if (ret < 0)
-		goto cleanup_hook1;
-
 	return ret;
 
- cleanup_hook1:
-	nf_unregister_hook(&ip6t_ops[1]);
- cleanup_hook0:
-	nf_unregister_hook(&ip6t_ops[0]);
  cleanup_table:
 	ip6t_unregister_table(&packet_filter);
-
 	return ret;
 }
 
 static void __exit ip6table_filter_fini(void)
 {
-	unsigned int i;
-
-	for (i = 0; i < sizeof(ip6t_ops)/sizeof(struct nf_hook_ops); i++)
-		nf_unregister_hook(&ip6t_ops[i]);
-
+	nf_unregister_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
 	ip6t_unregister_table(&packet_filter);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index e1f0f6a..03a13ea 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -238,49 +238,20 @@ static int __init ip6table_mangle_init(v
 		return ret;
 
 	/* Register hooks */
-	ret = nf_register_hook(&ip6t_ops[0]);
+	ret = nf_register_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
 	if (ret < 0)
 		goto cleanup_table;
 
-	ret = nf_register_hook(&ip6t_ops[1]);
-	if (ret < 0)
-		goto cleanup_hook0;
-
-	ret = nf_register_hook(&ip6t_ops[2]);
-	if (ret < 0)
-		goto cleanup_hook1;
-
-	ret = nf_register_hook(&ip6t_ops[3]);
-	if (ret < 0)
-		goto cleanup_hook2;
-
-	ret = nf_register_hook(&ip6t_ops[4]);
-	if (ret < 0)
-		goto cleanup_hook3;
-
 	return ret;
 
- cleanup_hook3:
-        nf_unregister_hook(&ip6t_ops[3]);
- cleanup_hook2:
-	nf_unregister_hook(&ip6t_ops[2]);
- cleanup_hook1:
-	nf_unregister_hook(&ip6t_ops[1]);
- cleanup_hook0:
-	nf_unregister_hook(&ip6t_ops[0]);
  cleanup_table:
 	ip6t_unregister_table(&packet_mangler);
-
 	return ret;
 }
 
 static void __exit ip6table_mangle_fini(void)
 {
-	unsigned int i;
-
-	for (i = 0; i < sizeof(ip6t_ops)/sizeof(struct nf_hook_ops); i++)
-		nf_unregister_hook(&ip6t_ops[i]);
-
+	nf_unregister_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
 	ip6t_unregister_table(&packet_mangler);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 54d1fff..61a7c58 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -152,31 +152,20 @@ static int __init ip6table_raw_init(void
 		return ret;
 
 	/* Register hooks */
-	ret = nf_register_hook(&ip6t_ops[0]);
+	ret = nf_register_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
 	if (ret < 0)
 		goto cleanup_table;
 
-	ret = nf_register_hook(&ip6t_ops[1]);
-	if (ret < 0)
-		goto cleanup_hook0;
-
 	return ret;
 
- cleanup_hook0:
-	nf_unregister_hook(&ip6t_ops[0]);
  cleanup_table:
 	ip6t_unregister_table(&packet_raw);
-
 	return ret;
 }
 
 static void __exit ip6table_raw_fini(void)
 {
-	unsigned int i;
-
-	for (i = 0; i < sizeof(ip6t_ops)/sizeof(struct nf_hook_ops); i++)
-		nf_unregister_hook(&ip6t_ops[i]);
-
+	nf_unregister_hooks(ip6t_ops, ARRAY_SIZE(ip6t_ops));
 	ip6t_unregister_table(&packet_raw);
 }
 
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index c8b5a96..0426ed0 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -286,55 +286,49 @@ static unsigned int ipv6_conntrack_local
 	return ipv6_conntrack_in(hooknum, pskb, in, out, okfn);
 }
 
-/* Connection tracking may drop packets, but never alters them, so
-   make it the first hook. */
-static struct nf_hook_ops ipv6_conntrack_defrag_ops = {
-	.hook		= ipv6_defrag,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET6,
-	.hooknum	= NF_IP6_PRE_ROUTING,
-	.priority	= NF_IP6_PRI_CONNTRACK_DEFRAG,
-};
-
-static struct nf_hook_ops ipv6_conntrack_in_ops = {
-	.hook		= ipv6_conntrack_in,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET6,
-	.hooknum	= NF_IP6_PRE_ROUTING,
-	.priority	= NF_IP6_PRI_CONNTRACK,
-};
-
-static struct nf_hook_ops ipv6_conntrack_local_out_ops = {
-	.hook		= ipv6_conntrack_local,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET6,
-	.hooknum	= NF_IP6_LOCAL_OUT,
-	.priority	= NF_IP6_PRI_CONNTRACK,
-};
-
-static struct nf_hook_ops ipv6_conntrack_defrag_local_out_ops = {
-	.hook		= ipv6_defrag,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET6,
-	.hooknum	= NF_IP6_LOCAL_OUT,
-	.priority	= NF_IP6_PRI_CONNTRACK_DEFRAG,
-};
-
-/* Refragmenter; last chance. */
-static struct nf_hook_ops ipv6_conntrack_out_ops = {
-	.hook		= ipv6_confirm,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET6,
-	.hooknum	= NF_IP6_POST_ROUTING,
-	.priority	= NF_IP6_PRI_LAST,
-};
-
-static struct nf_hook_ops ipv6_conntrack_local_in_ops = {
-	.hook		= ipv6_confirm,
-	.owner		= THIS_MODULE,
-	.pf		= PF_INET6,
-	.hooknum	= NF_IP6_LOCAL_IN,
-	.priority	= NF_IP6_PRI_LAST-1,
+static struct nf_hook_ops ipv6_conntrack_ops[] = {
+	{
+		.hook		= ipv6_defrag,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET6,
+		.hooknum	= NF_IP6_PRE_ROUTING,
+		.priority	= NF_IP6_PRI_CONNTRACK_DEFRAG,
+	},
+	{
+		.hook		= ipv6_conntrack_in,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET6,
+		.hooknum	= NF_IP6_PRE_ROUTING,
+		.priority	= NF_IP6_PRI_CONNTRACK,
+	},
+	{
+		.hook		= ipv6_conntrack_local,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET6,
+		.hooknum	= NF_IP6_LOCAL_OUT,
+		.priority	= NF_IP6_PRI_CONNTRACK,
+	},
+	{
+		.hook		= ipv6_defrag,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET6,
+		.hooknum	= NF_IP6_LOCAL_OUT,
+		.priority	= NF_IP6_PRI_CONNTRACK_DEFRAG,
+	},
+	{
+		.hook		= ipv6_confirm,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET6,
+		.hooknum	= NF_IP6_POST_ROUTING,
+		.priority	= NF_IP6_PRI_LAST,
+	},
+	{
+		.hook		= ipv6_confirm,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET6,
+		.hooknum	= NF_IP6_LOCAL_IN,
+		.priority	= NF_IP6_PRI_LAST-1,
+	},
 };
 
 #ifdef CONFIG_SYSCTL
@@ -505,50 +499,19 @@ static int init_or_cleanup(int init)
 		goto cleanup_icmpv6;
 	}
 
-	ret = nf_register_hook(&ipv6_conntrack_defrag_ops);
+	ret = nf_register_hooks(ipv6_conntrack_ops,
+				ARRAY_SIZE(ipv6_conntrack_ops));
 	if (ret < 0) {
 		printk("nf_conntrack_ipv6: can't register pre-routing defrag "
 		       "hook.\n");
 		goto cleanup_ipv6;
 	}
-
-	ret = nf_register_hook(&ipv6_conntrack_defrag_local_out_ops);
-	if (ret < 0) {
-		printk("nf_conntrack_ipv6: can't register local_out defrag "
-		       "hook.\n");
-		goto cleanup_defragops;
-	}
-
-	ret = nf_register_hook(&ipv6_conntrack_in_ops);
-	if (ret < 0) {
-		printk("nf_conntrack_ipv6: can't register pre-routing hook.\n");
-		goto cleanup_defraglocalops;
-	}
-
-	ret = nf_register_hook(&ipv6_conntrack_local_out_ops);
-	if (ret < 0) {
-		printk("nf_conntrack_ipv6: can't register local out hook.\n");
-		goto cleanup_inops;
-	}
-
-	ret = nf_register_hook(&ipv6_conntrack_out_ops);
-	if (ret < 0) {
-		printk("nf_conntrack_ipv6: can't register post-routing hook.\n");
-		goto cleanup_inandlocalops;
-	}
-
-	ret = nf_register_hook(&ipv6_conntrack_local_in_ops);
-	if (ret < 0) {
-		printk("nf_conntrack_ipv6: can't register local in hook.\n");
-		goto cleanup_inoutandlocalops;
-	}
-
 #ifdef CONFIG_SYSCTL
 	nf_ct_ipv6_sysctl_header = register_sysctl_table(nf_ct_net_table, 0);
 	if (nf_ct_ipv6_sysctl_header == NULL) {
 		printk("nf_conntrack: can't register to sysctl.\n");
 		ret = -ENOMEM;
-		goto cleanup_localinops;
+		goto cleanup_hooks;
 	}
 #endif
 	return ret;
@@ -557,19 +520,9 @@ static int init_or_cleanup(int init)
 	synchronize_net();
 #ifdef CONFIG_SYSCTL
  	unregister_sysctl_table(nf_ct_ipv6_sysctl_header);
- cleanup_localinops:
+ cleanup_hooks:
 #endif
-	nf_unregister_hook(&ipv6_conntrack_local_in_ops);
- cleanup_inoutandlocalops:
-	nf_unregister_hook(&ipv6_conntrack_out_ops);
- cleanup_inandlocalops:
-	nf_unregister_hook(&ipv6_conntrack_local_out_ops);
- cleanup_inops:
-	nf_unregister_hook(&ipv6_conntrack_in_ops);
- cleanup_defraglocalops:
-	nf_unregister_hook(&ipv6_conntrack_defrag_local_out_ops);
- cleanup_defragops:
-	nf_unregister_hook(&ipv6_conntrack_defrag_ops);
+	nf_unregister_hooks(ipv6_conntrack_ops, ARRAY_SIZE(ipv6_conntrack_ops));
  cleanup_ipv6:
 	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv6);
  cleanup_icmpv6:
