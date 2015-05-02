From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 15/34] netfilter: ipset: Make sure bit operations are not reordered
Date: Sat,  2 May 2015 19:28:04 +0200
Message-ID: <1430587703-3387-16-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:36696 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbbEBR2H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:07 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sergey Popovich pointed out that {set,clear}_bit() operations
must be protected against instruction reordering.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index cab8857..24a102f 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -478,6 +478,8 @@ mtype_expire(struct ip_set *set, struct htype *h, u8 nets_length, size_t dsize)
 			data = ahash_data(n, j, dsize);
 			if (ip_set_timeout_expired(ext_timeout(data, set))) {
 				pr_debug("expired %u/%u\n", i, j);
+				clear_bit(j, n->used);
+				smp_mb__after_atomic();
 #ifdef IP_SET_HASH_WITH_NETS
 				for (k = 0; k < IPSET_NET_COUNT; k++)
 					mtype_del_cidr(h,
@@ -486,7 +488,6 @@ mtype_expire(struct ip_set *set, struct htype *h, u8 nets_length, size_t dsize)
 						nets_length, k);
 #endif
 				ip_set_ext_destroy(set, data);
-				clear_bit(j, n->used);
 				h->elements--;
 				d++;
 			}
@@ -797,9 +798,10 @@ overwrite_extensions:
 		ip_set_init_comment(ext_comment(data, set), ext);
 	if (SET_WITH_SKBINFO(set))
 		ip_set_init_skbinfo(ext_skbinfo(data, set), ext);
-	/* Must come last */
+	/* Must come last for the case when timed out entry is reused */
 	if (SET_WITH_TIMEOUT(set))
 		ip_set_timeout_set(ext_timeout(data, set), ext->timeout);
+	smp_mb__before_atomic();
 	set_bit(j, n->used);
 	if (old != ERR_PTR(-ENOENT)) {
 		rcu_assign_pointer(hbucket(t, key), n);
@@ -849,6 +851,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 
 		ret = 0;
 		clear_bit(i, n->used);
+		smp_mb__after_atomic();
 		if (i + 1 == n->pos)
 			n->pos--;
 		h->elements--;
-- 
1.8.5.1

