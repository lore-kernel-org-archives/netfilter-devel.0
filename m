From: Chenbo Feng <chenbofeng.kernel@gmail.com>
Subject: [PATCH iptables] extensions: libxt_quota: Allow setting the remaining quota
Date: Mon,  1 Oct 2018 18:23:07 -0700
Message-ID: <1538443388-6881-2-git-send-email-chenbofeng.kernel@gmail.com>
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

The current xt_quota module cannot track the current remaining quota
of a specific rule. Everytime an unrelated rule is updated in the same
iptables table, the quota will be reset. This is not a very useful
function for iptables that get changed at run time. This patch fixes the
above problem by adding a new field in the struct that records the
current remaining quota.

Fixed a print out bug in verbose print out wrt. inversion.

Signed-off-by: Chenbo Feng <fengc@google.com>
Suggested-by: Maciej Żenczykowski <maze@google.com>
Reviewed-by: Maciej Żenczykowski <maze@google.com>
---
 extensions/libxt_quota.c           | 25 +++++++++++++++++++++++--
 include/linux/netfilter/xt_quota.h |  8 +++++---
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index bad77d2..6371aa0 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -9,26 +9,36 @@
 
 enum {
 	O_QUOTA = 0,
+	O_REMAIN = 1,
 };
 
 static const struct xt_option_entry quota_opts[] = {
 	{.name = "quota", .id = O_QUOTA, .type = XTTYPE_UINT64,
 	 .flags = XTOPT_MAND | XTOPT_INVERT | XTOPT_PUT,
 	 XTOPT_POINTER(struct xt_quota_info, quota)},
+	{.name = "remain", .id = O_REMAIN, .type = XTTYPE_UINT64,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(struct xt_quota_info, remain)},
 	XTOPT_TABLEEND,
 };
 
 static void quota_help(void)
 {
 	printf("quota match options:\n"
-	       "[!] --quota quota		quota (bytes)\n");
+	       "[!] --quota quota		quota (bytes)\n"
+	       "    --remain remain		remain (bytes)\n");
 }
 
 static void
 quota_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_quota_info *q = (const void *)match->data;
+	if (q->flags & XT_QUOTA_INVERT)
+		printf(" !");
 	printf(" quota: %llu bytes", (unsigned long long)q->quota);
+	if (q->remain) {
+		printf(" remain: %llu bytes",
+			(unsigned long long)q->remain - 1);
+	}
 }
 
 static void
@@ -39,6 +49,10 @@ quota_save(const void *ip, const struct xt_entry_match *match)
 	if (q->flags & XT_QUOTA_INVERT)
 		printf(" !");
 	printf(" --quota %llu", (unsigned long long) q->quota);
+	if (q->remain) {
+		printf(" --remain %llu",
+			(unsigned long long) q->remain - 1);
+	}
 }
 
 static void quota_parse(struct xt_option_call *cb)
@@ -48,6 +62,8 @@ static void quota_parse(struct xt_option_call *cb)
 	xtables_option_parse(cb);
 	if (cb->invert)
 		info->flags |= XT_QUOTA_INVERT;
+	if (cb->entry->id == O_REMAIN)
+		info->remain++;
 }
 
 static int quota_xlate(struct xt_xlate *xl,
@@ -66,7 +82,12 @@ static struct xtables_match quota_match = {
 	.name		= "quota",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof (struct xt_quota_info)),
-	.userspacesize	= offsetof(struct xt_quota_info, master),
+	/*
+	 * This size is only used for rule matching purpose when deleting
+	 * rules. The real size copied out from new kernel xt_quota module
+	 * is the whole struct xt_quota_info.
+	 */
+	.userspacesize	= offsetof(struct xt_quota_info, remain),
 	.help		= quota_help,
 	.print		= quota_print,
 	.save		= quota_save,
diff --git a/include/linux/netfilter/xt_quota.h b/include/linux/netfilter/xt_quota.h
index 9314723..d817aab 100644
--- a/include/linux/netfilter/xt_quota.h
+++ b/include/linux/netfilter/xt_quota.h
@@ -14,9 +14,11 @@ struct xt_quota_info {
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
-- 
2.7.4
