From: pablo@netfilter.org
Subject: [PATCH 2/5] netfilter: ipset: remove unused variable from type_pf_tdel()
Date: Fri, 27 May 2011 13:44:54 +0200
Message-ID: <1306496697-12196-3-git-send-email-pablo@netfilter.org>
References: <1306496697-12196-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57153 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab1E0LpQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 May 2011 07:45:16 -0400
In-Reply-To: <1306496697-12196-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Variable 'ret' is set in type_pf_tdel() but not used, remove.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
1.7.2.5

