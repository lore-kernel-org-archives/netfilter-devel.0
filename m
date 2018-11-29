From: Xiaozhou Liu <liuxiaozhou@bytedance.com>
Subject: [PATCH] netfilter: update comment about get_unique_tuple()
Date: Thu, 29 Nov 2018 11:29:05 +0800
Message-ID: <20181129032905.1148062-1-liuxiaozhou@bytedance.com>
Cc: Xiaozhou Liu <liuxiaozhou@bytedance.com>
To: pablo@netfilter.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

`__ip_conntrack_confirm' in the comment is a bit confusing since
it has long been replaced with __nf_conntrack_confirm in the code.
Just update the comment.

Signed-off-by: Xiaozhou Liu <liuxiaozhou@bytedance.com>
---
 net/netfilter/nf_nat_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index e2b196054dfc..527d125964d1 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -315,7 +315,8 @@ find_best_ips_proto(const struct nf_conntrack_zone *zone,
  * and NF_INET_LOCAL_OUT, we change the destination to map into the
  * range. It might not be possible to get a unique tuple, but we try.
  * At worst (or if we race), we will end up with a final duplicate in
- * __ip_conntrack_confirm and drop the packet. */
+ * __nf_conntrack_confirm and drop the packet.
+ */
 static void
 get_unique_tuple(struct nf_conntrack_tuple *tuple,
 		 const struct nf_conntrack_tuple *orig_tuple,
-- 
2.11.0
