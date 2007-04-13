From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/06]: ipt_ULOG: add compat conversion functions
Date: Fri, 13 Apr 2007 05:00:16 +0200 (MEST)
Message-ID: <20070413025931.29875.79601.sendpatchset@localhost.localdomain>
References: <20070413025923.29875.68909.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070413025923.29875.68909.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ipt_ULOG: add compat conversion functions

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e50514026143f6a528f8a13f3ede23850c5f75bf
tree bdede48e4a7ee3c693c864b9a41ff5b6ccae5e92
parent 3f1fbdbe77db881eb7bbcf30d806fae6109cda52
author Patrick McHardy <kaber@trash.net> Fri, 13 Apr 2007 04:43:40 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 13 Apr 2007 04:43:40 +0200

 net/ipv4/netfilter/ipt_ULOG.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index a36bf24..60dcf86 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -348,12 +348,52 @@ static int ipt_ulog_checkentry(const char *tablename,
 	return 1;
 }
 
+#ifdef CONFIG_COMPAT
+struct compat_ipt_ulog_info {
+	compat_uint_t	nl_group;
+	compat_size_t	copy_range;
+	compat_size_t	qthreshold;
+	char		prefix[ULOG_PREFIX_LEN];
+};
+
+static void compat_from_user(void *dst, void *src)
+{
+	struct compat_ipt_ulog_info *cl = src;
+	struct ipt_ulog_info l = {
+		.nl_group	= cl->nl_group,
+		.copy_range	= cl->copy_range,
+		.qthreshold	= cl->qthreshold,
+	};
+
+	memcpy(l.prefix, cl->prefix, sizeof(l.prefix));
+	memcpy(dst, &l, sizeof(l));
+}
+
+static int compat_to_user(void __user *dst, void *src)
+{
+	struct ipt_ulog_info *l = src;
+	struct compat_ipt_ulog_info cl = {
+		.nl_group	= l->nl_group,
+		.copy_range	= l->copy_range,
+		.qthreshold	= l->qthreshold,
+	};
+
+	memcpy(cl.prefix, l->prefix, sizeof(cl.prefix));
+	return copy_to_user(dst, &cl, sizeof(cl)) ? -EFAULT : 0;
+}
+#endif /* CONFIG_COMPAT */
+
 static struct xt_target ipt_ulog_reg = {
 	.name		= "ULOG",
 	.family		= AF_INET,
 	.target		= ipt_ulog_target,
 	.targetsize	= sizeof(struct ipt_ulog_info),
 	.checkentry	= ipt_ulog_checkentry,
+#ifdef CONFIG_COMPAT
+	.compatsize	= sizeof(struct compat_ipt_ulog_info),
+	.compat_from_user = compat_from_user,
+	.compat_to_user	= compat_to_user,
+#endif
 	.me		= THIS_MODULE,
 };
 
