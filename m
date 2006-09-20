From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 25/39]: ipt_hashlimit: add compat conversion functions
Date: Wed, 20 Sep 2006 10:24:23 +0200 (MEST)
Message-ID: <20060920082515.14636.21080.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ipt_hashlimit: add compat conversion functions

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6e24611afad533e7fe460dafcb14812a5591ce17
tree 5d5cb3167a069b4add7f434c59a6b36c9e5096ec
parent 04bbf99594fdd99e6eb70ad78f532d3e1ca88750
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:37:33 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:37:33 +0200

 net/ipv4/netfilter/ipt_hashlimit.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_hashlimit.c b/net/ipv4/netfilter/ipt_hashlimit.c
index b5b74b0..4f73a61 100644
--- a/net/ipv4/netfilter/ipt_hashlimit.c
+++ b/net/ipv4/netfilter/ipt_hashlimit.c
@@ -535,10 +535,39 @@ hashlimit_destroy(const struct xt_match 
 	htable_put(r->hinfo);
 }
 
+#ifdef CONFIG_COMPAT
+struct compat_ipt_hashlimit_info {
+	char name[IFNAMSIZ];
+	struct hashlimit_cfg cfg;
+	compat_uptr_t hinfo;
+	compat_uptr_t master;
+};
+
+static void compat_from_user(void *dst, void *src)
+{
+	int off = offsetof(struct compat_ipt_hashlimit_info, hinfo);
+
+	memcpy(dst, src, off);
+	memset(dst + off, 0, sizeof(struct compat_ipt_hashlimit_info) - off);
+}
+
+static int compat_to_user(void __user *dst, void *src)
+{
+	int off = offsetof(struct compat_ipt_hashlimit_info, hinfo);
+
+	return copy_to_user(dst, src, off) ? -EFAULT : 0;
+}
+#endif
+
 static struct ipt_match ipt_hashlimit = {
 	.name		= "hashlimit",
 	.match		= hashlimit_match,
 	.matchsize	= sizeof(struct ipt_hashlimit_info),
+#ifdef CONFIG_COMPAT
+	.compatsize	= sizeof(struct compat_ipt_hashlimit_info),
+	.compat_from_user = compat_from_user,
+	.compat_to_user	= compat_to_user,
+#endif
 	.checkentry	= hashlimit_checkentry,
 	.destroy	= hashlimit_destroy,
 	.me		= THIS_MODULE
