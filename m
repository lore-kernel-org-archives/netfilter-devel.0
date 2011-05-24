From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/3] netfilter: ipset: remove unused variable from type_pf_tdel()
Date: Tue, 24 May 2011 10:20:18 +0200
Message-ID: <1306225219-1498-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1306225219-1498-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1306225219-1498-2-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:58655 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343Ab1EXIUV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 04:20:21 -0400
In-Reply-To: <1306225219-1498-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Variable 'ret' is set in type_pf_tdel() but not used, remove.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set_ahash.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set_ahash.h b/include/linux/netfilter/ipset/ip_set_ahash.h
index a0196ac..ac3c822 100644
--- a/include/linux/netfilter/ipset/ip_set_ahash.h
+++ b/include/linux/netfilter/ipset/ip_set_ahash.h
@@ -839,7 +839,7 @@ type_pf_tdel(struct ip_set *set, void *value, u32 timeout)
 	struct htable *t = h->table;
 	const struct type_pf_elem *d = value;
 	struct hbucket *n;
-	int i, ret = 0;
+	int i;
 	struct type_pf_elem *data;
 	u32 key;
 
@@ -850,7 +850,7 @@ type_pf_tdel(struct ip_set *set, void *value, u32 timeout)
 		if (!type_pf_data_equal(data, d))
 			continue;
 		if (type_pf_data_expired(data))
-			ret = -IPSET_ERR_EXIST;
+			return -IPSET_ERR_EXIST;
 		if (i != n->pos - 1)
 			/* Not last one */
 			type_pf_data_copy(data, ahash_tdata(n, n->pos - 1));
-- 
1.7.0.4

