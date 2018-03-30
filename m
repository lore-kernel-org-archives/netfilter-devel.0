From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 29/47] netfilter: xt_conntrack: Support bit-shifting for CONNMARK & MARK targets.
Date: Fri, 30 Mar 2018 13:43:16 +0200
Message-ID: <20180330114334.18664-10-pablo@netfilter.org>
References: <20180330114334.18664-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114334.18664-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jack Ma <jack.ma@alliedtelesis.co.nz>

This patch introduces a new feature that allows bitshifting (left
and right) operations to co-operate with existing iptables options.

Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Jack Ma <jack.ma@alliedtelesis.co.nz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/xt_connmark.h | 10 ++++
 net/netfilter/xt_connmark.c                | 77 +++++++++++++++++++++++-------
 2 files changed, 70 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_connmark.h b/include/uapi/linux/netfilter/xt_connmark.h
index 408a9654f05c..1aa5c955ee1e 100644
--- a/include/uapi/linux/netfilter/xt_connmark.h
+++ b/include/uapi/linux/netfilter/xt_connmark.h
@@ -19,11 +19,21 @@ enum {
 	XT_CONNMARK_RESTORE
 };
 
+enum {
+	D_SHIFT_LEFT = 0,
+	D_SHIFT_RIGHT,
+};
+
 struct xt_connmark_tginfo1 {
 	__u32 ctmark, ctmask, nfmask;
 	__u8 mode;
 };
 
+struct xt_connmark_tginfo2 {
+	__u32 ctmark, ctmask, nfmask;
+	__u8 shift_dir, shift_bits, mode;
+};
+
 struct xt_connmark_mtinfo1 {
 	__u32 mark, mask;
 	__u8 invert;
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 809639ce6f5a..773da82190dc 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -36,9 +36,10 @@ MODULE_ALIAS("ipt_connmark");
 MODULE_ALIAS("ip6t_connmark");
 
 static unsigned int
-connmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
+connmark_tg_shift(struct sk_buff *skb,
+		const struct xt_connmark_tginfo1 *info,
+		u8 shift_bits, u8 shift_dir)
 {
-	const struct xt_connmark_tginfo1 *info = par->targinfo;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
 	u_int32_t newmark;
@@ -50,6 +51,10 @@ connmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	switch (info->mode) {
 	case XT_CONNMARK_SET:
 		newmark = (ct->mark & ~info->ctmask) ^ info->ctmark;
+		if (shift_dir == D_SHIFT_RIGHT)
+			newmark >>= shift_bits;
+		else
+			newmark <<= shift_bits;
 		if (ct->mark != newmark) {
 			ct->mark = newmark;
 			nf_conntrack_event_cache(IPCT_MARK, ct);
@@ -57,7 +62,11 @@ connmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
 		break;
 	case XT_CONNMARK_SAVE:
 		newmark = (ct->mark & ~info->ctmask) ^
-		          (skb->mark & info->nfmask);
+			  (skb->mark & info->nfmask);
+		if (shift_dir == D_SHIFT_RIGHT)
+			newmark >>= shift_bits;
+		else
+			newmark <<= shift_bits;
 		if (ct->mark != newmark) {
 			ct->mark = newmark;
 			nf_conntrack_event_cache(IPCT_MARK, ct);
@@ -65,14 +74,34 @@ connmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
 		break;
 	case XT_CONNMARK_RESTORE:
 		newmark = (skb->mark & ~info->nfmask) ^
-		          (ct->mark & info->ctmask);
+			  (ct->mark & info->ctmask);
+		if (shift_dir == D_SHIFT_RIGHT)
+			newmark >>= shift_bits;
+		else
+			newmark <<= shift_bits;
 		skb->mark = newmark;
 		break;
 	}
-
 	return XT_CONTINUE;
 }
 
+static unsigned int
+connmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_connmark_tginfo1 *info = par->targinfo;
+
+	return connmark_tg_shift(skb, info, 0, 0);
+}
+
+static unsigned int
+connmark_tg_v2(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_connmark_tginfo2 *info = par->targinfo;
+
+	return connmark_tg_shift(skb, (const struct xt_connmark_tginfo1 *)info,
+				 info->shift_bits, info->shift_dir);
+}
+
 static int connmark_tg_check(const struct xt_tgchk_param *par)
 {
 	int ret;
@@ -119,15 +148,27 @@ static void connmark_mt_destroy(const struct xt_mtdtor_param *par)
 	nf_ct_netns_put(par->net, par->family);
 }
 
-static struct xt_target connmark_tg_reg __read_mostly = {
-	.name           = "CONNMARK",
-	.revision       = 1,
-	.family         = NFPROTO_UNSPEC,
-	.checkentry     = connmark_tg_check,
-	.target         = connmark_tg,
-	.targetsize     = sizeof(struct xt_connmark_tginfo1),
-	.destroy        = connmark_tg_destroy,
-	.me             = THIS_MODULE,
+static struct xt_target connmark_tg_reg[] __read_mostly = {
+	{
+		.name           = "CONNMARK",
+		.revision       = 1,
+		.family         = NFPROTO_UNSPEC,
+		.checkentry     = connmark_tg_check,
+		.target         = connmark_tg,
+		.targetsize     = sizeof(struct xt_connmark_tginfo1),
+		.destroy        = connmark_tg_destroy,
+		.me             = THIS_MODULE,
+	},
+	{
+		.name           = "CONNMARK",
+		.revision       = 2,
+		.family         = NFPROTO_UNSPEC,
+		.checkentry     = connmark_tg_check,
+		.target         = connmark_tg_v2,
+		.targetsize     = sizeof(struct xt_connmark_tginfo2),
+		.destroy        = connmark_tg_destroy,
+		.me             = THIS_MODULE,
+	}
 };
 
 static struct xt_match connmark_mt_reg __read_mostly = {
@@ -145,12 +186,14 @@ static int __init connmark_mt_init(void)
 {
 	int ret;
 
-	ret = xt_register_target(&connmark_tg_reg);
+	ret = xt_register_targets(connmark_tg_reg,
+				  ARRAY_SIZE(connmark_tg_reg));
 	if (ret < 0)
 		return ret;
 	ret = xt_register_match(&connmark_mt_reg);
 	if (ret < 0) {
-		xt_unregister_target(&connmark_tg_reg);
+		xt_unregister_targets(connmark_tg_reg,
+				      ARRAY_SIZE(connmark_tg_reg));
 		return ret;
 	}
 	return 0;
@@ -159,7 +202,7 @@ static int __init connmark_mt_init(void)
 static void __exit connmark_mt_exit(void)
 {
 	xt_unregister_match(&connmark_mt_reg);
-	xt_unregister_target(&connmark_tg_reg);
+	xt_unregister_target(connmark_tg_reg);
 }
 
 module_init(connmark_mt_init);
-- 
2.11.0
