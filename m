From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/6] netfilter: conntrack: avoid integer overflow when resizing
Date: Tue, 12 Jul 2016 18:10:59 +0200
Message-ID: <1468339862-4028-4-git-send-email-pablo@netfilter.org>
References: <1468339862-4028-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1468339862-4028-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Can overflow so we might allocate very small table when bucket count is
high on a 32bit platform.

Note: resize is only possible from init_netns.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f204274..62c42e9 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1601,8 +1601,15 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
 	unsigned int nr_slots, i;
 	size_t sz;
 
+	if (*sizep > (UINT_MAX / sizeof(struct hlist_nulls_head)))
+		return NULL;
+
 	BUILD_BUG_ON(sizeof(struct hlist_nulls_head) != sizeof(struct hlist_head));
 	nr_slots = *sizep = roundup(*sizep, PAGE_SIZE / sizeof(struct hlist_nulls_head));
+
+	if (nr_slots > (UINT_MAX / sizeof(struct hlist_nulls_head)))
+		return NULL;
+
 	sz = nr_slots * sizeof(struct hlist_nulls_head);
 	hash = (void *)__get_free_pages(GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO,
 					get_order(sz));
-- 
2.1.4
