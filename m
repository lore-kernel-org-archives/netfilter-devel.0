From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: conntrack: avoid integer overflow when resizing
Date: Sun, 24 Apr 2016 01:18:21 +0200
Message-ID: <1461453501-4428-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58653 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120AbcDWXSH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Apr 2016 19:18:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Can overflow so we might allocate very small table when bucket count is
high on a 32bit platform.

Note: resize is only possible from init_netns.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2bbb962..11daca5 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1563,8 +1563,15 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
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
2.7.3

