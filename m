From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 23/39]: xt_CONNMARK: add compat conversion functions
Date: Wed, 20 Sep 2006 10:24:21 +0200 (MEST)
Message-ID: <20060920082512.14636.44122.sendpatchset@localhost.localdomain>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
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

[NETFILTER]: xt_CONNMARK: add compat conversion functions

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7474394e41d53dc236b955bc3d3fd2fa11804ea4
tree ec46e54209d259ec89e82b5bfb256e06184caef5
parent f0934e232d6e3db2091a14f3acccf2c53a0638dd
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:37:25 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:37:25 +0200

 net/netfilter/xt_CONNMARK.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index 6ccb45e..c01524f 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -108,6 +108,37 @@ checkentry(const char *tablename,
 	return 1;
 }
 
+#ifdef CONFIG_COMPAT
+struct compat_xt_connmark_target_info {
+	compat_ulong_t	mark, mask;
+	u_int8_t	mode;
+	u_int8_t	__pad1;
+	u_int16_t	__pad2;
+};
+
+static void compat_from_user(void *dst, void *src)
+{
+	struct compat_xt_connmark_target_info *cm = src;
+	struct xt_connmark_target_info m = {
+		.mark	= cm->mark,
+		.mask	= cm->mask,
+		.mode	= cm->mode,
+	};
+	memcpy(dst, &m, sizeof(m));
+}
+
+static int compat_to_user(void __user *dst, void *src)
+{
+	struct xt_connmark_target_info *m = src;
+	struct compat_xt_connmark_target_info cm = {
+		.mark	= m->mark,
+		.mask	= m->mask,
+		.mode	= m->mode,
+	};
+	return copy_to_user(dst, &cm, sizeof(cm)) ? -EFAULT : 0;
+}
+#endif /* CONFIG_COMPAT */
+
 static struct xt_target xt_connmark_target[] = {
 	{
 		.name		= "CONNMARK",
@@ -115,6 +146,11 @@ static struct xt_target xt_connmark_targ
 		.checkentry	= checkentry,
 		.target		= target,
 		.targetsize	= sizeof(struct xt_connmark_target_info),
+#ifdef CONFIG_COMPAT
+		.compatsize	= sizeof(struct compat_xt_connmark_target_info),
+		.compat_from_user = compat_from_user,
+		.compat_to_user	= compat_to_user,
+#endif
 		.me		= THIS_MODULE
 	},
 	{
