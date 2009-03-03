From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter: xtables: avoid pointer to self (2)
Date: Tue, 3 Mar 2009 18:09:48 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903031809220.8887@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0903031806350.8887@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50198 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbZCCRJu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Mar 2009 12:09:50 -0500
In-Reply-To: <alpine.LSU.2.00.0903031806350.8887@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


netfilter: xtables: avoid pointer to self (2/2)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---

 include/linux/netfilter/xt_quota.h |    4 +++-
 net/netfilter/xt_quota.c           |   31 ++++++++++++++++++++++++-------
 2 files changed, 27 insertions(+), 8 deletions(-)


diff --git a/include/linux/netfilter/xt_quota.h b/include/linux/netfilter/xt_quota.h
index 4c8368d..8dc89df 100644
--- a/include/linux/netfilter/xt_quota.h
+++ b/include/linux/netfilter/xt_quota.h
@@ -6,13 +6,15 @@ enum xt_quota_flags {
 };
 #define XT_QUOTA_MASK		0x1
 
+struct xt_quota_priv;
+
 struct xt_quota_info {
 	u_int32_t		flags;
 	u_int32_t		pad;
 
 	/* Used internally by the kernel */
 	aligned_u64		quota;
-	struct xt_quota_info	*master;
+	struct xt_quota_priv	*master;
 };
 
 #endif /* _XT_QUOTA_H */
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index c84fce5..01dd07b 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -9,6 +9,10 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_quota.h>
 
+struct xt_quota_priv {
+	uint64_t quota;
+};
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sam Johnston <samj@samj.net>");
 MODULE_DESCRIPTION("Xtables: countdown quota match");
@@ -20,18 +24,20 @@ static DEFINE_SPINLOCK(quota_lock);
 static bool
 quota_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	struct xt_quota_info *q =
-		((const struct xt_quota_info *)par->matchinfo)->master;
+	struct xt_quota_info *q = (void *)par->matchinfo;
+	struct xt_quota_priv *priv = q->master;
 	bool ret = q->flags & XT_QUOTA_INVERT;
 
 	spin_lock_bh(&quota_lock);
-	if (q->quota >= skb->len) {
-		q->quota -= skb->len;
+	if (priv->quota >= skb->len) {
+		priv->quota -= skb->len;
 		ret = !ret;
 	} else {
 		/* we do not allow even small packets from now on */
-		q->quota = 0;
+		priv->quota = 0;
 	}
+	/* Copy quota back to matchinfo so that iptables can display it */
+	q->quota = priv->quota;
 	spin_unlock_bh(&quota_lock);
 
 	return ret;
@@ -43,17 +49,28 @@ static bool quota_mt_check(const struct xt_mtchk_param *par)
 
 	if (q->flags & ~XT_QUOTA_MASK)
 		return false;
-	/* For SMP, we only want to use one set of counters. */
-	q->master = q;
+
+	q->master = kmalloc(sizeof(*q->master), GFP_KERNEL);
+	if (q->master == NULL)
+		return -ENOMEM;
+
 	return true;
 }
 
+static void quota_mt_destroy(const struct xt_mtdtor_param *par)
+{
+	const struct xt_quota_info *q = par->matchinfo;
+
+	kfree(q->master);
+}
+
 static struct xt_match quota_mt_reg __read_mostly = {
 	.name       = "quota",
 	.revision   = 0,
 	.family     = NFPROTO_UNSPEC,
 	.match      = quota_mt,
 	.checkentry = quota_mt_check,
+	.destroy    = quota_mt_destroy,
 	.matchsize  = sizeof(struct xt_quota_info),
 	.me         = THIS_MODULE,
 };
