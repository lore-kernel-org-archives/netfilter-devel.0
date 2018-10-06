From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] netfilter: xt_quota: Don't use aligned attribute in sizeof
Date: Sat,  6 Oct 2018 16:33:31 -0700
Message-ID: <20181006233331.13150-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Clang warns:

net/netfilter/xt_quota.c:47:44: warning: 'aligned' attribute ignored
when parsing type [-Wignored-attributes]
        BUILD_BUG_ON(sizeof(atomic64_t) != sizeof(__aligned_u64));
                                                  ^~~~~~~~~~~~~

Use 'sizeof(__u64)' instead, as the alignment doesn't affect the size
of the type.

Fixes: e9837e55b020 ("netfilter: xt_quota: fix the behavior of xt_quota module")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 net/netfilter/xt_quota.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index 6afa7f468a73..fceae245eb03 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -44,7 +44,7 @@ static int quota_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_quota_info *q = par->matchinfo;
 
-	BUILD_BUG_ON(sizeof(atomic64_t) != sizeof(__aligned_u64));
+	BUILD_BUG_ON(sizeof(atomic64_t) != sizeof(__u64));
 
 	if (q->flags & ~XT_QUOTA_MASK)
 		return -EINVAL;
-- 
2.19.0
