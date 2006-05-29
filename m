From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/17]: x_tables: add quota match
Date: Tue, 30 May 2006 00:34:10 +0200 (MEST)
Message-ID: <20060529223410.24834.72088.sendpatchset@localhost.localdomain>
References: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: add quota match

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 659702e42d110153954d98e895bdc2236e3d9b98
tree 76dad540e9d720968d4072df155e78f6175b85e6
parent d8913efd2c5ec04b2b0447394c8ecdff37abe3c5
author Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:02:39 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:02:39 +0200

 include/linux/netfilter/xt_quota.h |   16 ++++++
 net/netfilter/Kconfig              |   10 ++++
 net/netfilter/Makefile             |    1 
 net/netfilter/xt_quota.c           |   96 ++++++++++++++++++++++++++++++++++++
 4 files changed, 123 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/xt_quota.h b/include/linux/netfilter/xt_quota.h
new file mode 100644
index 0000000..acd7fd7
--- /dev/null
+++ b/include/linux/netfilter/xt_quota.h
@@ -0,0 +1,16 @@
+#ifndef _XT_QUOTA_H
+#define _XT_QUOTA_H
+
+enum xt_quota_flags {
+	XT_QUOTA_INVERT		= 0x1,
+};
+#define XT_QUOTA_MASK		0x1
+
+struct xt_quota_info {
+	u_int32_t		flags;
+	u_int32_t		pad;
+	aligned_u64		quota;
+	struct xt_quota_info	*master;
+};
+
+#endif /* _XT_QUOTA_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index e2893ef..5543c7b 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -329,6 +329,16 @@ config NETFILTER_XT_MATCH_PKTTYPE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_MATCH_QUOTA
+	tristate '"quota" match support'
+	depends on NETFILTER_XTABLES
+	help
+	  This option adds a `quota' match, which allows to match on a
+	  byte counter.
+
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+
 config NETFILTER_XT_MATCH_REALM
 	tristate  '"realm" match support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 95b7e41..4b6a6ea 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_MARK) +=
 obj-$(CONFIG_NETFILTER_XT_MATCH_MULTIPORT) += xt_multiport.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_POLICY) += xt_policy.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PKTTYPE) += xt_pkttype.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_QUOTA) += xt_quota.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) += xt_realm.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) += xt_sctp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) += xt_state.o
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
new file mode 100644
index 0000000..4cdba74
--- /dev/null
+++ b/net/netfilter/xt_quota.c
@@ -0,0 +1,96 @@
+/*
+ * netfilter module to enforce network quotas
+ *
+ * Sam Johnston <samj@samj.net>
+ */
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_quota.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sam Johnston <samj@samj.net>");
+
+static DEFINE_SPINLOCK(quota_lock);
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in, const struct net_device *out,
+      const struct xt_match *match, const void *matchinfo,
+      int offset, unsigned int protoff, int *hotdrop)
+{
+	struct xt_quota_info *q = ((struct xt_quota_info *)matchinfo)->master;
+	int ret = q->flags & XT_QUOTA_INVERT ? 1 : 0;
+
+	spin_lock_bh(&quota_lock);
+	if (q->quota >= skb->len) {
+		q->quota -= skb->len;
+		ret ^= 1;
+	} else {
+	        /* we do not allow even small packets from now on */
+	        q->quota = 0;
+	}
+	spin_unlock_bh(&quota_lock);
+
+	return ret;
+}
+
+static int
+checkentry(const char *tablename, const void *entry,
+	   const struct xt_match *match, void *matchinfo,
+	   unsigned int matchsize, unsigned int hook_mask)
+{
+	struct xt_quota_info *q = (struct xt_quota_info *)matchinfo;
+
+	if (q->flags & ~XT_QUOTA_MASK)
+		return 0;
+	/* For SMP, we only want to use one set of counters. */
+	q->master = q;
+	return 1;
+}
+
+static struct xt_match quota_match = {
+	.name		= "quota",
+	.family		= AF_INET,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_quota_info),
+	.checkentry	= checkentry,
+	.me		= THIS_MODULE
+};
+
+static struct xt_match quota_match6 = {
+	.name		= "quota",
+	.family		= AF_INET6,
+	.match		= match,
+	.matchsize	= sizeof(struct xt_quota_info),
+	.checkentry	= checkentry,
+	.me		= THIS_MODULE
+};
+
+static int __init xt_quota_init(void)
+{
+	int ret;
+
+	ret = xt_register_match(&quota_match);
+	if (ret)
+		goto err1;
+	ret = xt_register_match(&quota_match6);
+	if (ret)
+		goto err2;
+	return ret;
+
+err2:
+	xt_unregister_match(&quota_match);
+err1:
+	return ret;
+}
+
+static void __exit xt_quota_fini(void)
+{
+	xt_unregister_match(&quota_match6);
+	xt_unregister_match(&quota_match);
+}
+
+module_init(xt_quota_init);
+module_exit(xt_quota_fini);
