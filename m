From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/3] netfilter: ipset: Make possible to hash some part of the data element only
Date: Mon, 11 Jul 2011 11:52:53 +0200
Message-ID: <1310377975-993-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1310377975-993-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:43302 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab1GKJw5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2011 05:52:57 -0400
In-Reply-To: <1310377975-993-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set_ahash.h |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set_ahash.h b/include/linux/netfilter/ipset/ip_set_ahash.h
index c5b06aa..42b7d25 100644
--- a/include/linux/netfilter/ipset/ip_set_ahash.h
+++ b/include/linux/netfilter/ipset/ip_set_ahash.h
@@ -211,12 +211,16 @@ ip_set_hash_destroy(struct ip_set *set)
 	set->data = NULL;
 }
 
-#define HKEY(data, initval, htable_bits)				 \
-(jhash2((u32 *)(data), sizeof(struct type_pf_elem)/sizeof(u32), initval) \
-	& jhash_mask(htable_bits))
-
 #endif /* _IP_SET_AHASH_H */
 
+#ifndef HKEY_DATALEN
+#define HKEY_DATALEN	sizeof(struct type_pf_elem)
+#endif
+
+#define HKEY(data, initval, htable_bits)			\
+(jhash2((u32 *)(data), HKEY_DATALEN/sizeof(u32), initval)	\
+	& jhash_mask(htable_bits))
+
 #define CONCAT(a, b, c)		a##b##c
 #define TOKEN(a, b, c)		CONCAT(a, b, c)
 
@@ -1054,6 +1058,8 @@ type_pf_gc_init(struct ip_set *set)
 		 IPSET_GC_PERIOD(h->timeout));
 }
 
+#undef HKEY_DATALEN
+#undef HKEY
 #undef type_pf_data_equal
 #undef type_pf_data_isnull
 #undef type_pf_data_copy
-- 
1.7.0.4

