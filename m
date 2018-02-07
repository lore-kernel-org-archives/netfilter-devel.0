From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/11] netfilter: x_tables: make allocation less aggressive
Date: Wed,  7 Feb 2018 18:42:19 +0100
Message-ID: <20180207174229.4098-2-pablo@netfilter.org>
References: <20180207174229.4098-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180207174229.4098-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Michal Hocko <mhocko@kernel.org>

syzbot has noticed that xt_alloc_table_info can allocate a lot of memory.
This is an admin only interface but an admin in a namespace is sufficient
as well.  eacd86ca3b03 ("net/netfilter/x_tables.c: use kvmalloc() in
xt_alloc_table_info()") has changed the opencoded kmalloc->vmalloc
fallback into kvmalloc.  It has dropped __GFP_NORETRY on the way because
vmalloc has simply never fully supported __GFP_NORETRY semantic.  This is
still the case because e.g.  page tables backing the vmalloc area are
hardcoded GFP_KERNEL.

Revert back to __GFP_NORETRY as a poors man defence against excessively
large allocation request here.  We will not rule out the OOM killer
completely but __GFP_NORETRY should at least stop the large request in
most cases.

[akpm@linux-foundation.org: coding-style fixes]
Fixes: eacd86ca3b03 ("net/netfilter/x_tables.c: use kvmalloc() in xt_alloc_tableLink: http://lkml.kernel.org/r/20180130140104.GE21609@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 8fa4d37141a7..2f685ee1f9c8 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1008,7 +1008,12 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
 	if ((size >> PAGE_SHIFT) + 2 > totalram_pages)
 		return NULL;
 
-	info = kvmalloc(sz, GFP_KERNEL);
+	/* __GFP_NORETRY is not fully supported by kvmalloc but it should
+	 * work reasonably well if sz is too large and bail out rather
+	 * than shoot all processes down before realizing there is nothing
+	 * more to reclaim.
+	 */
+	info = kvmalloc(sz, GFP_KERNEL | __GFP_NORETRY);
 	if (!info)
 		return NULL;
 
-- 
2.11.0
