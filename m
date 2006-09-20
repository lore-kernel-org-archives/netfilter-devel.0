From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 22/39]: xt_connmark: add compat conversion functions
Date: Wed, 20 Sep 2006 10:24:19 +0200 (MEST)
Message-ID: <20060920082511.14636.90243.sendpatchset@localhost.localdomain>
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

[NETFILTER]: xt_connmark: add compat conversion functions

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f0934e232d6e3db2091a14f3acccf2c53a0638dd
tree 954ed7f838b56351e8e80492296f051a3dc4dd13
parent 6bd8301e88d5f11642e183546ce60747901de11c
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:37:18 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:37:18 +0200

 net/netfilter/xt_connmark.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index c9104d0..92a5726 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -81,6 +81,37 @@ #if defined(CONFIG_NF_CONNTRACK) || defi
 #endif
 }
 
+#ifdef CONFIG_COMPAT
+struct compat_xt_connmark_info {
+	compat_ulong_t	mark, mask;
+	u_int8_t	invert;
+	u_int8_t	__pad1;
+	u_int16_t	__pad2;
+};
+
+static void compat_from_user(void *dst, void *src)
+{
+	struct compat_xt_connmark_info *cm = src;
+	struct xt_connmark_info m = {
+		.mark	= cm->mark,
+		.mask	= cm->mask,
+		.invert	= cm->invert,
+	};
+	memcpy(dst, &m, sizeof(m));
+}
+
+static int compat_to_user(void __user *dst, void *src)
+{
+	struct xt_connmark_info *m = src;
+	struct compat_xt_connmark_info cm = {
+		.mark	= m->mark,
+		.mask	= m->mask,
+		.invert	= m->invert,
+	};
+	return copy_to_user(dst, &cm, sizeof(cm)) ? -EFAULT : 0;
+}
+#endif /* CONFIG_COMPAT */
+
 static struct xt_match xt_connmark_match[] = {
 	{
 		.name		= "connmark",
@@ -89,6 +120,11 @@ static struct xt_match xt_connmark_match
 		.match		= match,
 		.destroy	= destroy,
 		.matchsize	= sizeof(struct xt_connmark_info),
+#ifdef CONFIG_COMPAT
+		.compatsize	= sizeof(struct compat_xt_connmark_info),
+		.compat_from_user = compat_from_user,
+		.compat_to_user	= compat_to_user,
+#endif
 		.me		= THIS_MODULE
 	},
 	{
