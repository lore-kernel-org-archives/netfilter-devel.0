From: Jan Engelhardt <jengelh@medozas.de>
Subject: netfilter: xtables: avoid pointer to self
Date: Tue, 3 Mar 2009 18:09:20 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903031806350.8887@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50195 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbZCCRJX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Mar 2009 12:09:23 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


(There is a 2nd patch as reply, could you please fold that.)

---8<---
netfilter: xtables: avoid pointer to self

Commit 784544739a25c30637397ace5489eeb6e15d7d49 (netfilter: iptables: 
lock free counters) broke a number of modules whose rule data referenced 
itself. A reallocation would not reestablish the correct references, so 
it is best to use a separate struct that does not fall under RCU.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---

 include/linux/netfilter/xt_limit.h     |    9 ++++---
 include/linux/netfilter/xt_statistic.h |    7 +++---
 net/netfilter/xt_limit.c               |   40 +++++++++++++++++++++++---------
 net/netfilter/xt_statistic.c           |   28 ++++++++++++++++++----
 4 files changed, 61 insertions(+), 23 deletions(-)


diff --git a/include/linux/netfilter/xt_limit.h b/include/linux/netfilter/xt_limit.h
index b3ce653..fda222c 100644
--- a/include/linux/netfilter/xt_limit.h
+++ b/include/linux/netfilter/xt_limit.h
@@ -4,6 +4,8 @@
 /* timings are in milliseconds. */
 #define XT_LIMIT_SCALE 10000
 
+struct xt_limit_priv;
+
 /* 1/10,000 sec period => max of 10,000/sec.  Min rate is then 429490
    seconds, or one every 59 hours. */
 struct xt_rateinfo {
@@ -11,11 +13,10 @@ struct xt_rateinfo {
 	u_int32_t burst;  /* Period multiplier for upper limit. */
 
 	/* Used internally by the kernel */
-	unsigned long prev;
-	u_int32_t credit;
+	unsigned long prev; /* moved to xt_limit_priv */
+	u_int32_t credit; /* moved to xt_limit_priv */
 	u_int32_t credit_cap, cost;
 
-	/* Ugly, ugly fucker. */
-	struct xt_rateinfo *master;
+	struct xt_limit_priv *master;
 };
 #endif /*_XT_RATE_H*/
diff --git a/include/linux/netfilter/xt_statistic.h b/include/linux/netfilter/xt_statistic.h
index 3d38bc9..8f521ab 100644
--- a/include/linux/netfilter/xt_statistic.h
+++ b/include/linux/netfilter/xt_statistic.h
@@ -13,6 +13,8 @@ enum xt_statistic_flags {
 };
 #define XT_STATISTIC_MASK		0x1
 
+struct xt_statistic_priv;
+
 struct xt_statistic_info {
 	u_int16_t			mode;
 	u_int16_t			flags;
@@ -23,11 +25,10 @@ struct xt_statistic_info {
 		struct {
 			u_int32_t	every;
 			u_int32_t	packet;
-			/* Used internally by the kernel */
-			u_int32_t	count;
+			u_int32_t	count; /* unused */
 		} nth;
 	} u;
-	struct xt_statistic_info	*master __attribute__((aligned(8)));
+	struct xt_statistic_priv *master __attribute__((aligned(8)));
 };
 
 #endif /* _XT_STATISTIC_H */
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index c908d69..2e8089e 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -14,6 +14,11 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_limit.h>
 
+struct xt_limit_priv {
+	unsigned long prev;
+	uint32_t credit;
+};
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Herve Eychenne <rv@wallfire.org>");
 MODULE_DESCRIPTION("Xtables: rate-limit match");
@@ -60,18 +65,18 @@ static DEFINE_SPINLOCK(limit_lock);
 static bool
 limit_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	struct xt_rateinfo *r =
-		((const struct xt_rateinfo *)par->matchinfo)->master;
+	const struct xt_rateinfo *r = par->matchinfo;
+	struct xt_limit_priv *priv = r->master;
 	unsigned long now = jiffies;
 
 	spin_lock_bh(&limit_lock);
-	r->credit += (now - xchg(&r->prev, now)) * CREDITS_PER_JIFFY;
-	if (r->credit > r->credit_cap)
-		r->credit = r->credit_cap;
+	priv->credit += (now - xchg(&priv->prev, now)) * CREDITS_PER_JIFFY;
+	if (priv->credit > r->credit_cap)
+		priv->credit = r->credit_cap;
 
-	if (r->credit >= r->cost) {
+	if (priv->credit >= r->cost) {
 		/* We're not limited. */
-		r->credit -= r->cost;
+		priv->credit -= r->cost;
 		spin_unlock_bh(&limit_lock);
 		return true;
 	}
@@ -95,6 +100,7 @@ user2credits(u_int32_t user)
 static bool limit_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_rateinfo *r = par->matchinfo;
+	struct xt_limit_priv *priv;
 
 	/* Check for overflow. */
 	if (r->burst == 0
@@ -104,19 +110,30 @@ static bool limit_mt_check(const struct xt_mtchk_param *par)
 		return false;
 	}
 
-	/* For SMP, we only want to use one set of counters. */
-	r->master = r;
+	priv = kmalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv == NULL)
+		return -ENOMEM;
+
+	/* For SMP, we only want to use one set of state. */
+	r->master = priv;
 	if (r->cost == 0) {
 		/* User avg in seconds * XT_LIMIT_SCALE: convert to jiffies *
 		   128. */
-		r->prev = jiffies;
-		r->credit = user2credits(r->avg * r->burst);	 /* Credits full. */
+		priv->prev = jiffies;
+		priv->credit = user2credits(r->avg * r->burst); /* Credits full. */
 		r->credit_cap = user2credits(r->avg * r->burst); /* Credits full. */
 		r->cost = user2credits(r->avg);
 	}
 	return true;
 }
 
+static void limit_mt_destroy(const struct xt_mtdtor_param *par)
+{
+	const struct xt_rateinfo *info = par->matchinfo;
+
+	kfree(info->master);
+}
+
 #ifdef CONFIG_COMPAT
 struct compat_xt_rateinfo {
 	u_int32_t avg;
@@ -167,6 +184,7 @@ static struct xt_match limit_mt_reg __read_mostly = {
 	.family           = NFPROTO_UNSPEC,
 	.match            = limit_mt,
 	.checkentry       = limit_mt_check,
+	.destroy          = limit_mt_destroy,
 	.matchsize        = sizeof(struct xt_rateinfo),
 #ifdef CONFIG_COMPAT
 	.compatsize       = sizeof(struct compat_xt_rateinfo),
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index 0d75141..d8c0f8f 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -16,6 +16,10 @@
 #include <linux/netfilter/xt_statistic.h>
 #include <linux/netfilter/x_tables.h>
 
+struct xt_statistic_priv {
+	uint32_t count;
+};
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_DESCRIPTION("Xtables: statistics-based matching (\"Nth\", random)");
@@ -27,7 +31,7 @@ static DEFINE_SPINLOCK(nth_lock);
 static bool
 statistic_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	struct xt_statistic_info *info = (void *)par->matchinfo;
+	const struct xt_statistic_info *info = par->matchinfo;
 	bool ret = info->flags & XT_STATISTIC_INVERT;
 
 	switch (info->mode) {
@@ -36,10 +40,9 @@ statistic_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 			ret = !ret;
 		break;
 	case XT_STATISTIC_MODE_NTH:
-		info = info->master;
 		spin_lock_bh(&nth_lock);
-		if (info->u.nth.count++ == info->u.nth.every) {
-			info->u.nth.count = 0;
+		if (info->master->count++ == info->u.nth.every) {
+			info->master->count = 0;
 			ret = !ret;
 		}
 		spin_unlock_bh(&nth_lock);
@@ -56,16 +59,31 @@ static bool statistic_mt_check(const struct xt_mtchk_param *par)
 	if (info->mode > XT_STATISTIC_MODE_MAX ||
 	    info->flags & ~XT_STATISTIC_MASK)
 		return false;
-	info->master = info;
+
+	info->master = kzalloc(sizeof(*info->master), GFP_KERNEL);
+	if (info->master == NULL) {
+		printk(KERN_ERR KBUILD_MODNAME ": Out of memory\n");
+		return false;
+	}
+	info->master->count = info->u.nth.count;
+
 	return true;
 }
 
+static void statistic_mt_destroy(const struct xt_mtdtor_param *par)
+{
+	const struct xt_statistic_info *info = par->matchinfo;
+
+	kfree(info->master);
+}
+
 static struct xt_match xt_statistic_mt_reg __read_mostly = {
 	.name       = "statistic",
 	.revision   = 0,
 	.family     = NFPROTO_UNSPEC,
 	.match      = statistic_mt,
 	.checkentry = statistic_mt_check,
+	.destroy    = statistic_mt_destroy,
 	.matchsize  = sizeof(struct xt_statistic_info),
 	.me         = THIS_MODULE,
 };
