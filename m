From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 23/33] netfilter: nf_conntrack: provide modparam to always register conntrack hooks
Date: Tue, 29 Jan 2019 00:57:40 +0100
Message-ID: <20190128235750.18412-24-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The connection tracking hooks can be optionally registered per netns
when conntrack is specifically invoked from the ruleset since
0c66dc1ea3f0 ("netfilter: conntrack: register hooks in netns when needed
by ruleset"). Then, since 4d3a57f23dec ("netfilter: conntrack: do not
enable connection tracking unless needed"), the default behaviour is
changed to always register them on demand.

This patch provides a toggle that allows users to always register them.
Without this toggle, in order to use conntrack for statistics
collection, you need a dummy rule that refers to conntrack, eg.

        iptables -I INPUT -m state --state NEW

This patch allows users to restore the original behaviour via modparam,
ie. always register connection tracking, eg.

        modprobe nf_conntrack enable_hooks=1

Hence, no dummy rule is required.

Reported-by: Laura Garcia <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_standalone.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index ddfca5f1784c..8928a4d0933e 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -24,6 +24,10 @@
 #include <net/netfilter/nf_conntrack_timestamp.h>
 #include <linux/rculist_nulls.h>
 
+static bool enable_hooks __read_mostly;
+MODULE_PARM_DESC(enable_hooks, "Always enable conntrack hooks");
+module_param(enable_hooks, bool, 0000);
+
 unsigned int nf_conntrack_net_id __read_mostly;
 
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
@@ -1075,6 +1079,15 @@ static void nf_conntrack_standalone_fini_sysctl(struct net *net)
 }
 #endif /* CONFIG_SYSCTL */
 
+static void nf_conntrack_fini_net(struct net *net)
+{
+	if (enable_hooks)
+		nf_ct_netns_put(net, NFPROTO_INET);
+
+	nf_conntrack_standalone_fini_proc(net);
+	nf_conntrack_standalone_fini_sysctl(net);
+}
+
 static int nf_conntrack_pernet_init(struct net *net)
 {
 	int ret;
@@ -1093,8 +1106,16 @@ static int nf_conntrack_pernet_init(struct net *net)
 	if (ret < 0)
 		goto out_init_net;
 
+	if (enable_hooks) {
+		ret = nf_ct_netns_get(net, NFPROTO_INET);
+		if (ret < 0)
+			goto out_hooks;
+	}
+
 	return 0;
 
+out_hooks:
+	nf_conntrack_fini_net(net);
 out_init_net:
 	nf_conntrack_standalone_fini_proc(net);
 out_proc:
@@ -1106,10 +1127,9 @@ static void nf_conntrack_pernet_exit(struct list_head *net_exit_list)
 {
 	struct net *net;
 
-	list_for_each_entry(net, net_exit_list, exit_list) {
-		nf_conntrack_standalone_fini_sysctl(net);
-		nf_conntrack_standalone_fini_proc(net);
-	}
+	list_for_each_entry(net, net_exit_list, exit_list)
+		nf_conntrack_fini_net(net);
+
 	nf_conntrack_cleanup_net_list(net_exit_list);
 }
 
-- 
2.11.0
