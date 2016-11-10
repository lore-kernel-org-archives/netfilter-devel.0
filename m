From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 13/22] netfilter: ipset: Simplify mtype_expire() for hash types
Date: Thu, 10 Nov 2016 13:57:47 +0100
Message-ID: <1478782676-9770-14-git-send-email-kadlec@blackhole.kfki.hu>
References: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:48999 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933224AbcKJM6J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2016 07:58:09 -0500
In-Reply-To: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove one leve of intendation by using continue while
iterating over elements in bucket.

Ported from a patch proposed by Sergey Popovich <popovich_sergei@mail.ua>.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index c4877b6..7999e4c 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -487,21 +487,20 @@ struct htype {
 				continue;
 			}
 			data = ahash_data(n, j, dsize);
-			if (ip_set_timeout_expired(ext_timeout(data, set))) {
-				pr_debug("expired %u/%u\n", i, j);
-				clear_bit(j, n->used);
-				smp_mb__after_atomic();
+			if (!ip_set_timeout_expired(ext_timeout(data, set)))
+				continue;
+			pr_debug("expired %u/%u\n", i, j);
+			clear_bit(j, n->used);
+			smp_mb__after_atomic();
 #ifdef IP_SET_HASH_WITH_NETS
-				for (k = 0; k < IPSET_NET_COUNT; k++)
-					mtype_del_cidr(h,
-						NCIDR_PUT(DCIDR_GET(data->cidr,
-								    k)),
-						nets_length, k);
+			for (k = 0; k < IPSET_NET_COUNT; k++)
+				mtype_del_cidr(h,
+					NCIDR_PUT(DCIDR_GET(data->cidr, k)),
+					nets_length, k);
 #endif
-				ip_set_ext_destroy(set, data);
-				set->elements--;
-				d++;
-			}
+			ip_set_ext_destroy(set, data);
+			set->elements--;
+			d++;
 		}
 		if (d >= AHASH_INIT_SIZE) {
 			if (d >= n->size) {
-- 
1.8.5.1

