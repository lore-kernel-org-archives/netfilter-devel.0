From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/15]: bridge-netfilter: use
	nf_register_hooks/nf_unregister_hooks
Date: Wed,  7 Feb 2007 09:22:45 +0100 (MET)
Message-ID: <20070207082244.27478.94508.sendpatchset@localhost.localdomain>
References: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
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

[NETFILTER]: bridge-netfilter: use nf_register_hooks/nf_unregister_hooks

Additionally mark the init function __init.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit bcefbe8fd50b101d89a8cab0a7fe251213a88e70
tree cfb8bc1f59cdd8c21eb935701c146a07fbb8a282
parent cbc5f2f9419e2ef388ce01f9ace8cbb76ff8e357
author Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 07:36:54 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 08:37:36 +0100

 net/bridge/br_netfilter.c |   29 +++++++----------------------
 1 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index ea3337a..a25fa8c 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -949,44 +949,29 @@ static ctl_table brnf_net_table[] = {
 };
 #endif
 
-int br_netfilter_init(void)
+int __init br_netfilter_init(void)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(br_nf_ops); i++) {
-		int ret;
-
-		if ((ret = nf_register_hook(&br_nf_ops[i])) >= 0)
-			continue;
-
-		while (i--)
-			nf_unregister_hook(&br_nf_ops[i]);
+	int ret;
 
+	ret = nf_register_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
+	if (ret < 0)
 		return ret;
-	}
-
 #ifdef CONFIG_SYSCTL
 	brnf_sysctl_header = register_sysctl_table(brnf_net_table, 0);
 	if (brnf_sysctl_header == NULL) {
 		printk(KERN_WARNING
 		       "br_netfilter: can't register to sysctl.\n");
-		for (i = 0; i < ARRAY_SIZE(br_nf_ops); i++)
-			nf_unregister_hook(&br_nf_ops[i]);
-		return -EFAULT;
+		nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
+		return -ENOMEM;
 	}
 #endif
-
 	printk(KERN_NOTICE "Bridge firewalling registered\n");
-
 	return 0;
 }
 
 void br_netfilter_fini(void)
 {
-	int i;
-
-	for (i = ARRAY_SIZE(br_nf_ops) - 1; i >= 0; i--)
-		nf_unregister_hook(&br_nf_ops[i]);
+	nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
 #ifdef CONFIG_SYSCTL
 	unregister_sysctl_table(brnf_sysctl_header);
 #endif
