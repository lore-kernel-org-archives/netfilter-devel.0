From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 01/22] netfilter: ipset: Correct rcu_dereference_bh_nfnl() usage
Date: Sun, 23 Oct 2016 22:37:34 +0200
Message-ID: <1477255075-15255-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:35607 "EHLO smtp0.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756715AbcJWUiC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Oct 2016 16:38:02 -0400
In-Reply-To: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When rcu_dereference_bh_nfnl() macro would be defined on the target
system it will accept pointer and subsystem id.

Check if rcu_dereference_bh_nfnl() is defined and make it accepting two
arguments.

Ported from a patch proposed by Sergey Popovich <popovich_sergei@mail.ua>.

Suggested-by: Sergey Popovich <popovich_sergei@mail.ua>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index d32fd6b..bc54be4 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -17,7 +17,9 @@
 #define ipset_dereference_protected(p, set) \
 	__ipset_dereference_protected(p, spin_is_locked(&(set)->lock))
 
-#define rcu_dereference_bh_nfnl(p)	rcu_dereference_bh_check(p, 1)
+#ifndef rcu_dereference_bh_nfnl
+#define rcu_dereference_bh_nfnl(p, ss)	rcu_dereference_bh_check(p, 1)
+#endif
 
 /* Hashing which uses arrays to resolve clashing. The hash table is resized
  * (doubled) when searching becomes too long.
@@ -580,7 +582,7 @@ struct htype {
 		return -ENOMEM;
 #endif
 	rcu_read_lock_bh();
-	orig = rcu_dereference_bh_nfnl(h->table);
+	orig = rcu_dereference_bh_nfnl(h->table, NFNL_SUBSYS_IPSET);
 	htable_bits = orig->htable_bits;
 	rcu_read_unlock_bh();
 
@@ -1061,7 +1063,7 @@ struct htype {
 	u8 htable_bits;
 
 	rcu_read_lock_bh();
-	t = rcu_dereference_bh_nfnl(h->table);
+	t = rcu_dereference_bh_nfnl(h->table, NFNL_SUBSYS_IPSET);
 	memsize = mtype_ahash_memsize(h, t, NLEN(set->family), set->dsize);
 	htable_bits = t->htable_bits;
 	rcu_read_unlock_bh();
@@ -1103,7 +1105,7 @@ struct htype {
 
 	if (start) {
 		rcu_read_lock_bh();
-		t = rcu_dereference_bh_nfnl(h->table);
+		t = rcu_dereference_bh_nfnl(h->table, NFNL_SUBSYS_IPSET);
 		atomic_inc(&t->uref);
 		cb->args[IPSET_CB_PRIVATE] = (unsigned long)t;
 		rcu_read_unlock_bh();
-- 
1.8.5.1

