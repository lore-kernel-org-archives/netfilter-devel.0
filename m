From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 24/39]: xt_limit: add compat conversion functions
Date: Wed, 20 Sep 2006 10:24:22 +0200 (MEST)
Message-ID: <20060920082513.14636.70408.sendpatchset@localhost.localdomain>
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

[NETFILTER]: xt_limit: add compat conversion functions

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 04bbf99594fdd99e6eb70ad78f532d3e1ca88750
tree 2edef62b3efcb300407739e4a6e8f5a984695b6b
parent 7474394e41d53dc236b955bc3d3fd2fa11804ea4
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:37:29 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:37:29 +0200

 net/netfilter/xt_limit.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 8bfcbdf..fe1cb3a 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -135,6 +135,50 @@ ipt_limit_checkentry(const char *tablena
 	return 1;
 }
 
+#ifdef CONFIG_COMPAT
+struct compat_xt_rateinfo {
+	u_int32_t avg;
+	u_int32_t burst;
+
+	compat_ulong_t prev;
+	u_int32_t credit;
+	u_int32_t credit_cap, cost;
+
+	u_int32_t master;
+};
+
+/* To keep the full "prev" timestamp, the upper 32 bits are stored in the
+ * master pointer, which does not need to be preserved. */
+static void compat_from_user(void *dst, void *src)
+{
+	struct compat_xt_rateinfo *cm = src;
+	struct xt_rateinfo m = {
+		.avg		= cm->avg,
+		.burst		= cm->burst,
+		.prev		= cm->prev | (unsigned long)cm->master << 32,
+		.credit		= cm->credit,
+		.credit_cap	= cm->credit_cap,
+		.cost		= cm->cost,
+	};
+	memcpy(dst, &m, sizeof(m));
+}
+
+static int compat_to_user(void __user *dst, void *src)
+{
+	struct xt_rateinfo *m = src;
+	struct compat_xt_rateinfo cm = {
+		.avg		= m->avg,
+		.burst		= m->burst,
+		.prev		= m->prev,
+		.credit		= m->credit,
+		.credit_cap	= m->credit_cap,
+		.cost		= m->cost,
+		.master		= m->prev >> 32,
+	};
+	return copy_to_user(dst, &cm, sizeof(cm)) ? -EFAULT : 0;
+}
+#endif /* CONFIG_COMPAT */
+
 static struct xt_match xt_limit_match[] = {
 	{
 		.name		= "limit",
@@ -142,6 +186,11 @@ static struct xt_match xt_limit_match[] 
 		.checkentry	= ipt_limit_checkentry,
 		.match		= ipt_limit_match,
 		.matchsize	= sizeof(struct xt_rateinfo),
+#ifdef CONFIG_COMPAT
+		.compatsize	= sizeof(struct compat_xt_rateinfo),
+		.compat_from_user = compat_from_user,
+		.compat_to_user	= compat_to_user,
+#endif
 		.me		= THIS_MODULE,
 	},
 	{
