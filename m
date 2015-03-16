From: Sergey Popovich <popovich_sergei@mail.ua>
Subject: netfilter: ipset: Reset flags on private copy on set resize
Date: Mon, 16 Mar 2015 15:40:14 +0200
Message-ID: <235247e6d667917b56d974d1ece91abe4548636b.1426509747.git.popovich_sergei@mail.ua>
References: <cover.1426509747.git.popovich_sergei@mail.ua>
To: netfilter-devel@vger.kernel.org, popovich_sergei@mail.ru
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fallback8.mail.ru ([94.100.181.110]:53814 "EHLO
	fallback8.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730AbbCPOSb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2015 10:18:31 -0400
Received: from smtp32.i.mail.ru (smtp32.i.mail.ru [94.100.177.92])
	by fallback8.mail.ru (mPOP.Fallback_MX) with ESMTP id C42B77E4FA73
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2015 16:40:21 +0300 (MSK)
In-Reply-To: <cover.1426509747.git.popovich_sergei@mail.ua>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Set resizing takes read lock on the hash table, so we should
not modify any data in the original hash table, as this would
disrupt concurrent readers.

Furthermore set resizing could fail, leaving original set data
in inconsistent state: flags (nomatch currently) would be
cleared on all, but the last, where reallocation fails, set
elements.

Fix this by taking private copy of original set entry for
sets, where it is necessary.

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ua>
---
 net/netfilter/ipset/ip_set_hash_gen.h |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 7122cd8..fcf75be 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -541,8 +541,9 @@ mtype_resize(struct ip_set *set, bool retried)
 	u8 htable_bits = orig->htable_bits;
 #ifdef IP_SET_HASH_WITH_NETS
 	u8 flags;
+	u8 _data[set->dsize];
 #endif
-	struct mtype_elem *data;
+	struct mtype_elem *data, *hdata;
 	struct mtype_elem *d;
 	struct hbucket *n, *m;
 	u32 i, j;
@@ -581,15 +582,15 @@ retry:
 		for (j = 0; j < n->pos; j++) {
 			data = ahash_data(n, j, set->dsize);
 #ifdef IP_SET_HASH_WITH_NETS
+			hdata = memcpy(_data, data, set->dsize);
 			flags = 0;
-			mtype_data_reset_flags(data, &flags);
+			mtype_data_reset_flags(hdata, &flags);
+#else
+			hdata = data;
 #endif
-			m = hbucket(t, HKEY(data, h->initval, htable_bits));
+			m = hbucket(t, HKEY(hdata, h->initval, htable_bits));
 			ret = hbucket_elem_add(m, AHASH_MAX(h), set->dsize);
 			if (ret < 0) {
-#ifdef IP_SET_HASH_WITH_NETS
-				mtype_data_reset_flags(data, &flags);
-#endif
 				read_unlock_bh(&set->lock);
 				mtype_ahash_destroy(set, t, false);
 				if (ret == -EAGAIN)
@@ -598,9 +599,6 @@ retry:
 			}
 			d = ahash_data(m, m->pos++, set->dsize);
 			memcpy(d, data, set->dsize);
-#ifdef IP_SET_HASH_WITH_NETS
-			mtype_data_reset_flags(d, &flags);
-#endif
 		}
 	}
 
-- 
1.7.10.4

