From: Sergey Popovich <popovich_sergei@mail.ua>
Subject: netfilter: ipset: Destroy extensions before moving non-last entry
Date: Mon, 16 Mar 2015 15:40:13 +0200
Message-ID: <cb541e8503344c1dd6762540419934f62d2ddc16.1426509747.git.popovich_sergei@mail.ua>
References: <cover.1426509747.git.popovich_sergei@mail.ua>
To: netfilter-devel@vger.kernel.org, popovich_sergei@mail.ru
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fallback7.mail.ru ([94.100.181.128]:53968 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbbCPOFs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2015 10:05:48 -0400
Received: from smtp32.i.mail.ru (smtp32.i.mail.ru [94.100.177.92])
	by fallback7.mail.ru (mPOP.Fallback_MX) with ESMTP id 95E28133E109A
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2015 16:40:21 +0300 (MSK)
In-Reply-To: <cover.1426509747.git.popovich_sergei@mail.ua>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If set created with comment extension we should destroy it
prior to reusing removed entry slot. Overwise we freeing
valid entry comment string and leaking one in removed entry.

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ua>
---
 net/netfilter/ipset/ip_set_hash_gen.h |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index c55bbbf..7122cd8 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -751,19 +751,18 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(data, set)))
 			goto out;
-		if (i != n->pos - 1)
-			/* Not last one */
-			memcpy(data, ahash_data(n, n->pos - 1, set->dsize),
-			       set->dsize);
-
-		n->pos--;
-		h->elements--;
 #ifdef IP_SET_HASH_WITH_NETS
 		for (j = 0; j < IPSET_NET_COUNT; j++)
 			mtype_del_cidr(h, SCIDR(d->cidr, j), NLEN(set->family),
 				       j);
 #endif
 		ip_set_ext_destroy(set, data);
+		if (i != n->pos - 1)
+			/* Not last one */
+			memcpy(data, ahash_data(n, n->pos - 1, set->dsize),
+			       set->dsize);
+		n->pos--;
+		h->elements--;
 		if (n->pos + AHASH_INIT_SIZE < n->size) {
 			void *tmp = kzalloc((n->size - AHASH_INIT_SIZE)
 					    * set->dsize,
-- 
1.7.10.4

