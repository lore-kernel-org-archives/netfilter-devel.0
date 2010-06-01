From: Florian Westphal <fwestphal@astaro.com>
Subject: [PATCH xt-addons] xt_geoip: fix possible out-of-bounds access
Date: Tue,  1 Jun 2010 10:51:42 +0200
Message-ID: <1275382302-8857-1-git-send-email-fwestphal@astaro.com>
Cc: Florian Westphal <fwestphal@astaro.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-62.dex002.intermedia.net ([64.78.20.11]:11101 "EHLO
	dhost002-62.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754342Ab0FAJFn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Jun 2010 05:05:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It is possible for geoip_bsearch() to pick mid == sizeof(subnets).

Consider a set with a single entry and a "address to test"
higher than the range:

1st call: lo = 0, hi = 1 -> mid will be 0
2nd call: lo = 1, hi = 1 -> mid will be 1

On the 2nd call, we'll examine random data.

Fix is to use the maximum valid index instead of the number of elements
in the first geoip_bsearch call.
---
 extensions/xt_geoip.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/extensions/xt_geoip.c b/extensions/xt_geoip.c
index 4c6b29f..5b2e237 100644
--- a/extensions/xt_geoip.c
+++ b/extensions/xt_geoip.c
@@ -33,7 +33,7 @@ struct geoip_country_kernel {
 	struct list_head list;
 	struct geoip_subnet *subnets;
 	atomic_t ref;
-	unsigned int count;
+	unsigned int max;
 	unsigned short cc;
 };
 
@@ -51,24 +51,26 @@ geoip_add_node(const struct geoip_country_user __user *umem_ptr)
 	if (copy_from_user(&umem, umem_ptr, sizeof(umem)) != 0)
 		return ERR_PTR(-EFAULT);
 
+	if (umem.count == 0)
+		return ERR_PTR(-EINVAL);
+
 	p = kmalloc(sizeof(struct geoip_country_kernel), GFP_KERNEL);
 	if (p == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	p->count   = umem.count;
-	p->cc      = umem.cc;
-
-	s = vmalloc(p->count * sizeof(struct geoip_subnet));
+	s = vmalloc(umem.count * sizeof(struct geoip_subnet));
 	if (s == NULL) {
 		ret = -ENOMEM;
 		goto free_p;
 	}
 	if (copy_from_user(s, (const void __user *)(unsigned long)umem.subnets,
-	    p->count * sizeof(struct geoip_subnet)) != 0) {
+	    umem.count * sizeof(struct geoip_subnet)) != 0) {
 		ret = -EFAULT;
 		goto free_s;
 	}
 
+	p->max     = umem.count - 1;	/* last valid index in ->subnets[] */
+	p->cc      = umem.cc;
 	p->subnets = s;
 	atomic_set(&p->ref, 1);
 	INIT_LIST_HEAD(&p->list);
@@ -163,7 +165,7 @@ xt_geoip_mt(const struct sk_buff *skb, struct xt_action_param *par)
 			continue;
 		}
 
-		if (geoip_bsearch(node->subnets, ip, 0, node->count)) {
+		if (geoip_bsearch(node->subnets, ip, 0, node->max)) {
 			rcu_read_unlock();
 			return !(info->flags & XT_GEOIP_INV);
 		}
-- 
1.6.3.3

