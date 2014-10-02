From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: explicit module dependency between br_netfilter and physdev
Date: Thu,  2 Oct 2014 11:41:52 +0200
Message-ID: <1412242912-3622-1-git-send-email-pablo@netfilter.org>
Cc: stephen@networkplumber.org, fw@strlen.de, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48927 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaJBJkm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Oct 2014 05:40:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

You can use physdev to match the physical interface enslaved to the
bridge device. This information is stored in skb->nf_bridge and it is
set up by br_netfilter. So, this is only available when iptables is
used from the bridge netfilter path.

Since 34666d4 ("netfilter: bridge: move br_netfilter out of the core"),
the br_netfilter code is modular. To reduce the impact of this change,
we can autoload the br_netfilter if the physdev match is used since
we assume that the users need br_netfilter in place.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/br_netfilter.h |    7 +++++++
 net/bridge/br_netfilter.c            |   17 +++++++++++++++++
 net/netfilter/xt_physdev.c           |   10 ++++++++++
 3 files changed, 34 insertions(+)
 create mode 100644 include/net/netfilter/br_netfilter.h

diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
new file mode 100644
index 0000000..13e7359
--- /dev/null
+++ b/include/net/netfilter/br_netfilter.h
@@ -0,0 +1,7 @@
+#ifndef _BR_NETFILTER_H_
+#define _BR_NETFILTER_H_
+
+bool br_netfilter_module_get(void);
+void br_netfilter_module_put(void);
+
+#endif /* _BR_NETFILTER_H_ */
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 97e4393..fa96627 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -856,6 +856,23 @@ static unsigned int ip_sabotage_in(const struct nf_hook_ops *ops,
 	return NF_ACCEPT;
 }
 
+static struct module *me = THIS_MODULE;
+
+bool br_netfilter_module_get(void)
+{
+	if (!try_module_get(me))
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(br_netfilter_module_get);
+
+void br_netfilter_module_put(void)
+{
+	module_put(me);
+}
+EXPORT_SYMBOL_GPL(br_netfilter_module_put);
+
 /* For br_nf_post_routing, we need (prio = NF_BR_PRI_LAST), because
  * br_dev_queue_push_xmit is called afterwards */
 static struct nf_hook_ops br_nf_ops[] __read_mostly = {
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index d7ca16b..403fd44 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -13,6 +13,7 @@
 #include <linux/netfilter_bridge.h>
 #include <linux/netfilter/xt_physdev.h>
 #include <linux/netfilter/x_tables.h>
+#include <net/netfilter/br_netfilter.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
@@ -87,6 +88,9 @@ static int physdev_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_physdev_info *info = par->matchinfo;
 
+	if (!br_netfilter_module_get())
+		return -EOPNOTSUPP;
+
 	if (!(info->bitmask & XT_PHYSDEV_OP_MASK) ||
 	    info->bitmask & ~XT_PHYSDEV_OP_MASK)
 		return -EINVAL;
@@ -104,11 +108,17 @@ static int physdev_mt_check(const struct xt_mtchk_param *par)
 	return 0;
 }
 
+static void physdev_mt_destroy(const struct xt_mtdtor_param *par)
+{
+	br_netfilter_module_put();
+}
+
 static struct xt_match physdev_mt_reg __read_mostly = {
 	.name       = "physdev",
 	.revision   = 0,
 	.family     = NFPROTO_UNSPEC,
 	.checkentry = physdev_mt_check,
+	.destroy    = physdev_mt_destroy,
 	.match      = physdev_mt,
 	.matchsize  = sizeof(struct xt_physdev_info),
 	.me         = THIS_MODULE,
-- 
1.7.10.4

