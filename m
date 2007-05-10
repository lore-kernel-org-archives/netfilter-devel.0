From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/09]: xt_conntrack: add compat support
Date: Thu, 10 May 2007 15:41:22 +0200 (MEST)
Message-ID: <20070510134039.8559.90741.sendpatchset@localhost.localdomain>
References: <20070510134027.8559.40540.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070510134027.8559.40540.sendpatchset@localhost.localdomain>
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

[NETFILTER]: xt_conntrack: add compat support

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 18a31ce74f45310a1133fadd17f36b879fd0221b
tree 2b0e1102cbb2625a350309348ac0b15a7b54db5d
parent e319b2005352790a24e1a91dc1af4b2f8643a876
author Patrick McHardy <kaber@trash.net> Thu, 10 May 2007 15:39:08 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 10 May 2007 15:39:08 +0200

 net/netfilter/xt_conntrack.c |   54 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index f4ea8fe..189ded5 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -134,12 +134,66 @@ static void destroy(const struct xt_match *match, void *matchinfo)
 	nf_ct_l3proto_module_put(match->family);
 }
 
+#ifdef CONFIG_COMPAT
+struct compat_xt_conntrack_info
+{
+	compat_uint_t			statemask;
+	compat_uint_t			statusmask;
+	struct ip_conntrack_old_tuple	tuple[IP_CT_DIR_MAX];
+	struct in_addr			sipmsk[IP_CT_DIR_MAX];
+	struct in_addr			dipmsk[IP_CT_DIR_MAX];
+	compat_ulong_t			expires_min;
+	compat_ulong_t			expires_max;
+	u_int8_t			flags;
+	u_int8_t			invflags;
+};
+
+static void compat_from_user(void *dst, void *src)
+{
+	struct compat_xt_conntrack_info *cm = src;
+	struct xt_conntrack_info m = {
+		.statemask	= cm->statemask,
+		.statusmask	= cm->statusmask,
+		.expires_min	= cm->expires_min,
+		.expires_max	= cm->expires_max,
+		.flags		= cm->flags,
+		.invflags	= cm->invflags,
+	};
+	memcpy(m.tuple, cm->tuple, sizeof(m.tuple));
+	memcpy(m.sipmsk, cm->sipmsk, sizeof(m.sipmsk));
+	memcpy(m.dipmsk, cm->dipmsk, sizeof(m.dipmsk));
+	memcpy(dst, &m, sizeof(m));
+}
+
+static int compat_to_user(void __user *dst, void *src)
+{
+	struct xt_conntrack_info *m = src;
+	struct compat_xt_conntrack_info cm = {
+		.statemask	= m->statemask,
+		.statusmask	= m->statusmask,
+		.expires_min	= m->expires_min,
+		.expires_max	= m->expires_max,
+		.flags		= m->flags,
+		.invflags	= m->invflags,
+	};
+	memcpy(cm.tuple, m->tuple, sizeof(cm.tuple));
+	memcpy(cm.sipmsk, m->sipmsk, sizeof(cm.sipmsk));
+	memcpy(cm.dipmsk, m->dipmsk, sizeof(cm.dipmsk));
+	return copy_to_user(dst, &cm, sizeof(cm)) ? -EFAULT : 0;
+}
+#endif
+
 static struct xt_match conntrack_match = {
 	.name		= "conntrack",
 	.match		= match,
 	.checkentry	= checkentry,
 	.destroy	= destroy,
 	.matchsize	= sizeof(struct xt_conntrack_info),
+#ifdef CONFIG_COMPAT
+	.compatsize	= sizeof(struct compat_xt_conntrack_info),
+	.compat_from_user = compat_from_user,
+	.compat_to_user	= compat_to_user,
+#endif
 	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
