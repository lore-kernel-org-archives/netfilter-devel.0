From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/04]: {ip,
	nf}_conntrack_netlink: fix expectation notifier unregistration
Date: Fri, 31 Mar 2006 03:09:09 +0200 (MEST)
Message-ID: <20060331010910.20401.33067.sendpatchset@localhost.localdomain>
References: <20060331010905.20401.80847.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060331010905.20401.80847.sendpatchset@localhost.localdomain>
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

[NETFILTER]: {ip,nf}_conntrack_netlink: fix expectation notifier unregistration

This patch fixes expectation notifier unregistration on module unload to
use ip_conntrack_expect_unregister_notifier(). This bug causes a soft
lockup at the first expectation created after a rmmod ; insmod of this
module.

Should go into -stable as well.

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 75032ffac0484237a927b7517fc5926eb9846792
tree fab99dd04115ecd8d3e8f82dbea1b9af613c56d7
parent ea8b4b5661cae27fae57fc5b992730ec2e44d21c
author Martin Josefsson <gandalf@wlug.westbo.se> Wed, 29 Mar 2006 10:08:13 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 29 Mar 2006 10:08:13 +0200

 net/ipv4/netfilter/ip_conntrack_netlink.c |    2 +-
 net/netfilter/nf_conntrack_netlink.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 9b6e19b..01bd7ca 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -1658,7 +1658,7 @@ static void __exit ctnetlink_exit(void)
 	printk("ctnetlink: unregistering from nfnetlink.\n");
 
 #ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
-	ip_conntrack_unregister_notifier(&ctnl_notifier_exp);
+	ip_conntrack_expect_unregister_notifier(&ctnl_notifier_exp);
 	ip_conntrack_unregister_notifier(&ctnl_notifier);
 #endif
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3138ae7..bd10eb9 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1687,7 +1687,7 @@ static void __exit ctnetlink_exit(void)
 	printk("ctnetlink: unregistering from nfnetlink.\n");
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	nf_conntrack_unregister_notifier(&ctnl_notifier_exp);
+	nf_conntrack_expect_unregister_notifier(&ctnl_notifier_exp);
 	nf_conntrack_unregister_notifier(&ctnl_notifier);
 #endif
 
