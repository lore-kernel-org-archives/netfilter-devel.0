From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 46/50]: xt_helper: use RCU
Date: Sat,  7 Jul 2007 14:24:05 +0200 (MEST)
Message-ID: <20070707122320.1589.6019.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
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

[NETFILTER]: xt_helper: use RCU

The ->helper pointer is protected by RCU, no need to take
nf_conntrack_lock. Also remove excessive debugging.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a427f588c5a2a74926656e0586717479869ff01c
tree 7fd3ea63409d927ba8a7b0006529ddc7310d2062
parent 312f613cf94327c5e48fb0dbcae03f15397258c6
author Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:16:07 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:16:07 +0200

 net/netfilter/xt_helper.c |   31 ++++++++-----------------------
 1 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index d03acb0..0a1f4c6 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -22,11 +22,6 @@ MODULE_DESCRIPTION("iptables helper match module");
 MODULE_ALIAS("ipt_helper");
 MODULE_ALIAS("ip6t_helper");
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
 
 static bool
 match(const struct sk_buff *skb,
@@ -41,38 +36,28 @@ match(const struct sk_buff *skb,
 	const struct xt_helper_info *info = matchinfo;
 	const struct nf_conn *ct;
 	const struct nf_conn_help *master_help;
+	const struct nf_conntrack_helper *helper;
 	enum ip_conntrack_info ctinfo;
 	bool ret = info->invert;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct) {
-		DEBUGP("xt_helper: Eek! invalid conntrack?\n");
+	if (!ct || !ct->master)
 		return ret;
-	}
-
-	if (!ct->master) {
-		DEBUGP("xt_helper: conntrack %p has no master\n", ct);
-		return ret;
-	}
 
-	read_lock_bh(&nf_conntrack_lock);
 	master_help = nfct_help(ct->master);
-	if (!master_help || !master_help->helper) {
-		DEBUGP("xt_helper: master ct %p has no helper\n",
-			exp->expectant);
-		goto out_unlock;
-	}
+	if (!master_help)
+		return ret;
 
-	DEBUGP("master's name = %s , info->name = %s\n",
-		ct->master->helper->name, info->name);
+	/* rcu_read_lock()ed by nf_hook_slow */
+	helper = rcu_dereference(master_help->helper);
+	if (!helper)
+		return ret;
 
 	if (info->name[0] == '\0')
 		ret = !ret;
 	else
 		ret ^= !strncmp(master_help->helper->name, info->name,
 				strlen(master_help->helper->name));
-out_unlock:
-	read_unlock_bh(&nf_conntrack_lock);
 	return ret;
 }
 
