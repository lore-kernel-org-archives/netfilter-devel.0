From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 20/39]: xt_mark: add compat conversion functions
Date: Wed, 20 Sep 2006 10:24:17 +0200 (MEST)
Message-ID: <20060920082508.14636.57160.sendpatchset@localhost.localdomain>
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

[NETFILTER]: xt_mark: add compat conversion functions

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fe51418f5b14027a01508b5e1285610ff001e2b0
tree 9594ed918996a180b28ab37c4999b8042c1ec26f
parent 0e38bba8d1cb49b414eb4301ef89f128974ee059
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:37:10 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:37:10 +0200

 net/netfilter/xt_mark.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index e8059cd..934dddf 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -50,6 +50,37 @@ checkentry(const char *tablename,
 	return 1;
 }
 
+#ifdef CONFIG_COMPAT
+struct compat_xt_mark_info {
+	compat_ulong_t	mark, mask;
+	u_int8_t	invert;
+	u_int8_t	__pad1;
+	u_int16_t	__pad2;
+};
+
+static void compat_from_user(void *dst, void *src)
+{
+	struct compat_xt_mark_info *cm = src;
+	struct xt_mark_info m = {
+		.mark	= cm->mark,
+		.mask	= cm->mask,
+		.invert	= cm->invert,
+	};
+	memcpy(dst, &m, sizeof(m));
+}
+
+static int compat_to_user(void __user *dst, void *src)
+{
+	struct xt_mark_info *m = src;
+	struct compat_xt_mark_info cm = {
+		.mark	= m->mark,
+		.mask	= m->mask,
+		.invert	= m->invert,
+	};
+	return copy_to_user(dst, &cm, sizeof(cm)) ? -EFAULT : 0;
+}
+#endif /* CONFIG_COMPAT */
+
 static struct xt_match xt_mark_match[] = {
 	{
 		.name		= "mark",
@@ -57,6 +88,11 @@ static struct xt_match xt_mark_match[] =
 		.checkentry	= checkentry,
 		.match		= match,
 		.matchsize	= sizeof(struct xt_mark_info),
+#ifdef CONFIG_COMPAT
+		.compatsize	= sizeof(struct compat_xt_mark_info),
+		.compat_from_user = compat_from_user,
+		.compat_to_user	= compat_to_user,
+#endif
 		.me		= THIS_MODULE,
 	},
 	{
