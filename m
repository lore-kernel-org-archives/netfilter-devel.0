From: fgao@ikuai8.com
Subject: [PATCH nf-next] netfilter: Enhance the codes used to get random once
Date: Sun, 18 Sep 2016 10:52:25 +0800
Message-ID: <1474167145-10008-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg321.qq.com ([14.17.32.30]:47421 "EHLO smtpbg321.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755618AbcIRCwr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Sep 2016 22:52:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

There are some codes which are used to get one random once in netfilter.
We could use net_get_random_once to simplify these codes.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/xt_RATEEST.c   | 6 +-----
 net/netfilter/xt_connlimit.c | 8 +-------
 net/netfilter/xt_recent.c    | 7 ++-----
 3 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 515131f..dbd6c4a 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -24,7 +24,6 @@ static DEFINE_MUTEX(xt_rateest_mutex);
 #define RATEEST_HSIZE	16
 static struct hlist_head rateest_hash[RATEEST_HSIZE] __read_mostly;
 static unsigned int jhash_rnd __read_mostly;
-static bool rnd_inited __read_mostly;
 
 static unsigned int xt_rateest_hash(const char *name)
 {
@@ -99,10 +98,7 @@ static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 	} cfg;
 	int ret;
 
-	if (unlikely(!rnd_inited)) {
-		get_random_bytes(&jhash_rnd, sizeof(jhash_rnd));
-		rnd_inited = true;
-	}
+	net_get_random_once(&jhash_rnd, sizeof(jhash_rnd));
 
 	est = xt_rateest_lookup(info->name);
 	if (est) {
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 99bbc82..b6dc322 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -366,14 +366,8 @@ static int connlimit_mt_check(const struct xt_mtchk_param *par)
 	unsigned int i;
 	int ret;
 
-	if (unlikely(!connlimit_rnd)) {
-		u_int32_t rand;
+	net_get_random_once(&connlimit_rnd, sizeof(connlimit_rnd));
 
-		do {
-			get_random_bytes(&rand, sizeof(rand));
-		} while (!rand);
-		cmpxchg(&connlimit_rnd, 0, rand);
-	}
 	ret = nf_ct_l3proto_try_module_get(par->family);
 	if (ret < 0) {
 		pr_info("cannot load conntrack support for "
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index d725a27..e3b7a09 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -110,7 +110,6 @@ static const struct file_operations recent_old_fops, recent_mt_fops;
 #endif
 
 static u_int32_t hash_rnd __read_mostly;
-static bool hash_rnd_inited __read_mostly;
 
 static inline unsigned int recent_entry_hash4(const union nf_inet_addr *addr)
 {
@@ -340,10 +339,8 @@ static int recent_mt_check(const struct xt_mtchk_param *par,
 	int ret = -EINVAL;
 	size_t sz;
 
-	if (unlikely(!hash_rnd_inited)) {
-		get_random_bytes(&hash_rnd, sizeof(hash_rnd));
-		hash_rnd_inited = true;
-	}
+	net_get_random_once(&hash_rnd, sizeof(hash_rnd));
+
 	if (info->check_set & ~XT_RECENT_VALID_FLAGS) {
 		pr_info("Unsupported user space flags (%08x)\n",
 			info->check_set);
-- 
1.9.1

