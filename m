From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 21/39]: xt_MARK: add compat conversion functions
Date: Wed, 20 Sep 2006 10:24:18 +0200 (MEST)
Message-ID: <20060920082510.14636.91397.sendpatchset@localhost.localdomain>
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

[NETFILTER]: xt_MARK: add compat conversion functions

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6bd8301e88d5f11642e183546ce60747901de11c
tree 269043300eb5d79d725c4e0459e35e9962e9e9a4
parent fe51418f5b14027a01508b5e1285610ff001e2b0
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:37:14 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:37:14 +0200

 net/netfilter/xt_MARK.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index 782f8d8..c6e860a 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -108,6 +108,35 @@ checkentry_v1(const char *tablename,
 	return 1;
 }
 
+#ifdef CONFIG_COMPAT
+struct compat_xt_mark_target_info_v1 {
+	compat_ulong_t	mark;
+	u_int8_t	mode;
+	u_int8_t	__pad1;
+	u_int16_t	__pad2;
+};
+
+static void compat_from_user_v1(void *dst, void *src)
+{
+	struct compat_xt_mark_target_info_v1 *cm = src;
+	struct xt_mark_target_info_v1 m = {
+		.mark	= cm->mark,
+		.mode	= cm->mode,
+	};
+	memcpy(dst, &m, sizeof(m));
+}
+
+static int compat_to_user_v1(void __user *dst, void *src)
+{
+	struct xt_mark_target_info_v1 *m = src;
+	struct compat_xt_mark_target_info_v1 cm = {
+		.mark	= m->mark,
+		.mode	= m->mode,
+	};
+	return copy_to_user(dst, &cm, sizeof(cm)) ? -EFAULT : 0;
+}
+#endif /* CONFIG_COMPAT */
+
 static struct xt_target xt_mark_target[] = {
 	{
 		.name		= "MARK",
@@ -126,6 +155,11 @@ static struct xt_target xt_mark_target[]
 		.checkentry	= checkentry_v1,
 		.target		= target_v1,
 		.targetsize	= sizeof(struct xt_mark_target_info_v1),
+#ifdef CONFIG_COMPAT
+		.compatsize	= sizeof(struct compat_xt_mark_target_info_v1),
+		.compat_from_user = compat_from_user_v1,
+		.compat_to_user	= compat_to_user_v1,
+#endif
 		.table		= "mangle",
 		.me		= THIS_MODULE,
 	},
