From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/1] netfilter: Add flags and compatibility revision in order to support aliases.
Date: Mon, 28 Jan 2013 21:44:48 +0100
Message-ID: <1359405888-5090-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1359405888-5090-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:55004 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab3A1Uou (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2013 15:44:50 -0500
In-Reply-To: <1359405888-5090-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The patch adds the flag to denote the "state" alias as of the subset
of the "conntrack" match and the flag and revision for the "NOTRACK"
alias as the subset of the "CT" target.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/uapi/linux/netfilter/xt_CT.h        |    5 ++-
 include/uapi/linux/netfilter/xt_conntrack.h |    1 +
 net/netfilter/xt_CT.c                       |   75 +++++++++++++++++++++++++++
 3 files changed, 80 insertions(+), 1 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_CT.h b/include/uapi/linux/netfilter/xt_CT.h
index a064b8a..54528fd 100644
--- a/include/uapi/linux/netfilter/xt_CT.h
+++ b/include/uapi/linux/netfilter/xt_CT.h
@@ -3,7 +3,10 @@
 
 #include <linux/types.h>
 
-#define XT_CT_NOTRACK	0x1
+enum {
+	XT_CT_NOTRACK		= 1 << 0,
+	XT_CT_NOTRACK_ALIAS	= 1 << 1,
+};
 
 struct xt_ct_target_info {
 	__u16 flags;
diff --git a/include/uapi/linux/netfilter/xt_conntrack.h b/include/uapi/linux/netfilter/xt_conntrack.h
index e3c041d..e5bd308 100644
--- a/include/uapi/linux/netfilter/xt_conntrack.h
+++ b/include/uapi/linux/netfilter/xt_conntrack.h
@@ -31,6 +31,7 @@ enum {
 	XT_CONNTRACK_REPLSRC_PORT = 1 << 10,
 	XT_CONNTRACK_REPLDST_PORT = 1 << 11,
 	XT_CONNTRACK_DIRECTION    = 1 << 12,
+	XT_CONNTRACK_STATE_ALIAS  = 1 << 13,
 };
 
 struct xt_conntrack_mtinfo1 {
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index bde009e..415efdd 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -309,6 +309,70 @@ err1:
 	return ret;
 }
 
+static int xt_ct_tg_check_v2(const struct xt_tgchk_param *par)
+{
+	struct xt_ct_target_info_v1 *info = par->targinfo;
+	struct nf_conntrack_tuple t;
+	struct nf_conn *ct;
+	int ret = -EOPNOTSUPP;
+
+	if (info->flags & XT_CT_NOTRACK) {
+		ct = nf_ct_untracked_get();
+		atomic_inc(&ct->ct_general.use);
+		goto out;
+	}
+
+#ifndef CONFIG_NF_CONNTRACK_ZONES
+	if (info->zone)
+		goto err1;
+#endif
+
+	ret = nf_ct_l3proto_try_module_get(par->family);
+	if (ret < 0)
+		goto err1;
+
+	memset(&t, 0, sizeof(t));
+	ct = nf_conntrack_alloc(par->net, info->zone, &t, &t, GFP_KERNEL);
+	ret = PTR_ERR(ct);
+	if (IS_ERR(ct))
+		goto err2;
+
+	ret = 0;
+	if ((info->ct_events || info->exp_events) &&
+	    !nf_ct_ecache_ext_add(ct, info->ct_events, info->exp_events,
+				  GFP_KERNEL))
+		goto err3;
+
+	if (info->helper[0]) {
+		ret = xt_ct_set_helper(ct, info->helper, par);
+		if (ret < 0)
+			goto err3;
+	}
+
+	if (info->timeout[0]) {
+		ret = xt_ct_set_timeout(ct, par, info->timeout);
+		if (ret < 0)
+			goto err3;
+	}
+
+	__set_bit(IPS_TEMPLATE_BIT, &ct->status);
+	__set_bit(IPS_CONFIRMED_BIT, &ct->status);
+
+	/* Overload tuple linked list to put us in template list. */
+	hlist_nulls_add_head_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
+				 &par->net->ct.tmpl);
+out:
+	info->ct = ct;
+	return 0;
+
+err3:
+	nf_conntrack_free(ct);
+err2:
+	nf_ct_l3proto_module_put(par->family);
+err1:
+	return ret;
+}
+
 static void xt_ct_tg_destroy_v0(const struct xt_tgdtor_param *par)
 {
 	struct xt_ct_target_info *info = par->targinfo;
@@ -383,6 +447,17 @@ static struct xt_target xt_ct_tg_reg[] __read_mostly = {
 		.table		= "raw",
 		.me		= THIS_MODULE,
 	},
+	{
+		.name		= "CT",
+		.family		= NFPROTO_UNSPEC,
+		.revision	= 2,
+		.targetsize	= sizeof(struct xt_ct_target_info_v1),
+		.checkentry	= xt_ct_tg_check_v2,
+		.destroy	= xt_ct_tg_destroy_v1,
+		.target		= xt_ct_target_v1,
+		.table		= "raw",
+		.me		= THIS_MODULE,
+	},
 };
 
 static unsigned int
-- 
1.7.0.4

