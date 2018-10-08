From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 31/31] netfilter: xt_quota: Don't use aligned attribute in sizeof
Date: Tue,  9 Oct 2018 01:01:25 +0200
Message-ID: <20181008230125.2330-32-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

Clang warns:

net/netfilter/xt_quota.c:47:44: warning: 'aligned' attribute ignored
when parsing type [-Wignored-attributes]
        BUILD_BUG_ON(sizeof(atomic64_t) != sizeof(__aligned_u64));
                                                  ^~~~~~~~~~~~~

Use 'sizeof(__u64)' instead, as the alignment doesn't affect the size
of the type.

Fixes: e9837e55b020 ("netfilter: xt_quota: fix the behavior of xt_quota module")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.11.0
