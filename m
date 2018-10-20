From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/10] Revert "netfilter: xt_quota: fix the behavior of xt_quota module"
Date: Sat, 20 Oct 2018 11:43:17 +0200
Message-ID: <20181020094317.16011-11-pablo@netfilter.org>
References: <20181020094317.16011-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181020094317.16011-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This reverts commit e9837e55b0200da544a095a1fca36efd7fd3ba30.

When talking to Maze and Chenbo, we agreed to keep this back by now
due to problems in the ruleset listing path with 32-bit arches.

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/xt_quota.h |  8 ++---
 net/netfilter/xt_quota.c                | 55 ++++++++++++++++++++-------------
 2 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_quota.h b/include/uapi/linux/netfilter/xt_quota.h
index d72fd52adbba..f3ba5d9e58b6 100644
--- a/include/uapi/linux/netfilter/xt_quota.h
+++ b/include/uapi/linux/netfilter/xt_quota.h
@@ -15,11 +15,9 @@ struct xt_quota_info {
 	__u32 flags;
 	__u32 pad;
 	__aligned_u64 quota;
-#ifdef __KERNEL__
-	atomic64_t counter;
-#else
-	__aligned_u64 remain;
-#endif
+
+	/* Used internally by the kernel */
+	struct xt_quota_priv	*master;
 };
 
 #endif /* _XT_QUOTA_H */
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index fceae245eb03..10d61a6eed71 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -11,6 +11,11 @@
 #include <linux/netfilter/xt_quota.h>
 #include <linux/module.h>
 
+struct xt_quota_priv {
+	spinlock_t	lock;
+	uint64_t	quota;
+};
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sam Johnston <samj@samj.net>");
 MODULE_DESCRIPTION("Xtables: countdown quota match");
@@ -21,48 +26,54 @@ static bool
 quota_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	struct xt_quota_info *q = (void *)par->matchinfo;
-	u64 current_count = atomic64_read(&q->counter);
+	struct xt_quota_priv *priv = q->master;
 	bool ret = q->flags & XT_QUOTA_INVERT;
-	u64 old_count, new_count;
-
-	do {
-		if (current_count == 1)
-			return ret;
-		if (current_count <= skb->len) {
-			atomic64_set(&q->counter, 1);
-			return ret;
-		}
-		old_count = current_count;
-		new_count = current_count - skb->len;
-		current_count = atomic64_cmpxchg(&q->counter, old_count,
-						 new_count);
-	} while (current_count != old_count);
-	return !ret;
+
+	spin_lock_bh(&priv->lock);
+	if (priv->quota >= skb->len) {
+		priv->quota -= skb->len;
+		ret = !ret;
+	} else {
+		/* we do not allow even small packets from now on */
+		priv->quota = 0;
+	}
+	spin_unlock_bh(&priv->lock);
+
+	return ret;
 }
 
 static int quota_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_quota_info *q = par->matchinfo;
 
-	BUILD_BUG_ON(sizeof(atomic64_t) != sizeof(__u64));
-
 	if (q->flags & ~XT_QUOTA_MASK)
 		return -EINVAL;
-	if (atomic64_read(&q->counter) > q->quota + 1)
-		return -ERANGE;
 
-	if (atomic64_read(&q->counter) == 0)
-		atomic64_set(&q->counter, q->quota + 1);
+	q->master = kmalloc(sizeof(*q->master), GFP_KERNEL);
+	if (q->master == NULL)
+		return -ENOMEM;
+
+	spin_lock_init(&q->master->lock);
+	q->master->quota = q->quota;
 	return 0;
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
+	.usersize   = offsetof(struct xt_quota_info, master),
 	.me         = THIS_MODULE,
 };
 
-- 
2.11.0
