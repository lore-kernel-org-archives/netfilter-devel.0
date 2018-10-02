From: Chenbo Feng <chenbofeng.kernel@gmail.com>
Subject: [PATCH net-next] netfilter: xt_quota: fix the behavior of xt_quota module
Date: Mon,  1 Oct 2018 18:23:08 -0700
Message-ID: <1538443388-6881-3-git-send-email-chenbofeng.kernel@gmail.com>
References: <1538443388-6881-1-git-send-email-chenbofeng.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: kernel-team@android.com, Lorenzo Colitti <lorenzo@google.com>,
        maze@google.com, Chenbo Feng <fengc@google.com>
To: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1538443388-6881-1-git-send-email-chenbofeng.kernel@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Chenbo Feng <fengc@google.com>

A major flaw of the current xt_quota module is that quota in a specific
rule gets reset every time there is a rule change in the same table. It
makes the xt_quota module not very useful in a table in which iptables
rules are changed at run time. This fix introduces a new counter that is
visible to userspace as the remaining quota of the current rule. When
userspace restores the rules in a table, it can restore the counter to
the remaining quota instead of resetting it to the full quota.

Signed-off-by: Chenbo Feng <fengc@google.com>
Suggested-by: Maciej Żenczykowski <maze@google.com>
Reviewed-by: Maciej Żenczykowski <maze@google.com>
---
 include/uapi/linux/netfilter/xt_quota.h |  8 +++--
 net/netfilter/xt_quota.c                | 55 +++++++++++++--------------------
 2 files changed, 27 insertions(+), 36 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_quota.h b/include/uapi/linux/netfilter/xt_quota.h
index f3ba5d9..d72fd52 100644
--- a/include/uapi/linux/netfilter/xt_quota.h
+++ b/include/uapi/linux/netfilter/xt_quota.h
@@ -15,9 +15,11 @@ struct xt_quota_info {
 	__u32 flags;
 	__u32 pad;
 	__aligned_u64 quota;
-
-	/* Used internally by the kernel */
-	struct xt_quota_priv	*master;
+#ifdef __KERNEL__
+	atomic64_t counter;
+#else
+	__aligned_u64 remain;
+#endif
 };
 
 #endif /* _XT_QUOTA_H */
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index 10d61a6..6afa7f4 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -11,11 +11,6 @@
 #include <linux/netfilter/xt_quota.h>
 #include <linux/module.h>
 
-struct xt_quota_priv {
-	spinlock_t	lock;
-	uint64_t	quota;
-};
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sam Johnston <samj@samj.net>");
 MODULE_DESCRIPTION("Xtables: countdown quota match");
@@ -26,54 +21,48 @@ static bool
 quota_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	struct xt_quota_info *q = (void *)par->matchinfo;
-	struct xt_quota_priv *priv = q->master;
+	u64 current_count = atomic64_read(&q->counter);
 	bool ret = q->flags & XT_QUOTA_INVERT;
-
-	spin_lock_bh(&priv->lock);
-	if (priv->quota >= skb->len) {
-		priv->quota -= skb->len;
-		ret = !ret;
-	} else {
-		/* we do not allow even small packets from now on */
-		priv->quota = 0;
-	}
-	spin_unlock_bh(&priv->lock);
-
-	return ret;
+	u64 old_count, new_count;
+
+	do {
+		if (current_count == 1)
+			return ret;
+		if (current_count <= skb->len) {
+			atomic64_set(&q->counter, 1);
+			return ret;
+		}
+		old_count = current_count;
+		new_count = current_count - skb->len;
+		current_count = atomic64_cmpxchg(&q->counter, old_count,
+						 new_count);
+	} while (current_count != old_count);
+	return !ret;
 }
 
 static int quota_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_quota_info *q = par->matchinfo;
 
+	BUILD_BUG_ON(sizeof(atomic64_t) != sizeof(__aligned_u64));
+
 	if (q->flags & ~XT_QUOTA_MASK)
 		return -EINVAL;
+	if (atomic64_read(&q->counter) > q->quota + 1)
+		return -ERANGE;
 
-	q->master = kmalloc(sizeof(*q->master), GFP_KERNEL);
-	if (q->master == NULL)
-		return -ENOMEM;
-
-	spin_lock_init(&q->master->lock);
-	q->master->quota = q->quota;
+	if (atomic64_read(&q->counter) == 0)
+		atomic64_set(&q->counter, q->quota + 1);
 	return 0;
 }
 
-static void quota_mt_destroy(const struct xt_mtdtor_param *par)
-{
-	const struct xt_quota_info *q = par->matchinfo;
-
-	kfree(q->master);
-}
-
 static struct xt_match quota_mt_reg __read_mostly = {
 	.name       = "quota",
 	.revision   = 0,
 	.family     = NFPROTO_UNSPEC,
 	.match      = quota_mt,
 	.checkentry = quota_mt_check,
-	.destroy    = quota_mt_destroy,
 	.matchsize  = sizeof(struct xt_quota_info),
-	.usersize   = offsetof(struct xt_quota_info, master),
 	.me         = THIS_MODULE,
 };
 
-- 
2.7.4
