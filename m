From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/2] netfilter: ipset: remove unused variable from type_pf_tdel()
Date: Fri, 20 May 2011 20:51:43 +0200
Message-ID: <1305917503-14427-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1305917503-14427-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1305917503-14427-2-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	David Miller <davem@davemloft.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:45058 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934847Ab1ETSvp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 May 2011 14:51:45 -0400
In-Reply-To: <1305917503-14427-2-git-send-email-kadlec@blackhole.kfki.hu>
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

