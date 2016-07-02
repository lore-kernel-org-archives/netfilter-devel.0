From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 1/3] netfilter: conntrack: fix race between nf_conntrack proc read and hash resize
Date: Sat,  2 Jul 2016 18:59:25 +0800
Message-ID: <1467457167-5363-2-git-send-email-zlpnobody@163.com>
References: <1467457167-5363-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:58573 "EHLO m12-16.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbcGBLAJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Jul 2016 07:00:09 -0400
In-Reply-To: <1467457167-5363-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Liping Zhang <liping.zhang@spreadtrum.com>

When we do "cat /proc/net/nf_conntrack", and meanwhile resize the connt=
rack
hash table via /sys/module/nf_conntrack/parameters/hashsize, race will
happen, because reader can observe a newly allocated hash but the old s=
ize
(or vice versa). So oops will happen like follows=EF=BC=9A

  BUG: unable to handle kernel NULL pointer dereference at 000000000000=
0017
  IP: [<ffffffffa0418e21>] seq_print_acct+0x11/0x50 [nf_conntrack]
  Call Trace:
  [<ffffffffa0412f4e>] ? ct_seq_show+0x14e/0x340 [nf_conntrack]
  [<ffffffff81261a1c>] seq_read+0x2cc/0x390
  [<ffffffff812a8d62>] proc_reg_read+0x42/0x70
  [<ffffffff8123bee7>] __vfs_read+0x37/0x130
  [<ffffffff81347980>] ? security_file_permission+0xa0/0xc0
  [<ffffffff8123cf75>] vfs_read+0x95/0x140
  [<ffffffff8123e475>] SyS_read+0x55/0xc0
  [<ffffffff817c2572>] entry_SYSCALL_64_fastpath+0x1a/0xa4

It is very easy to reproduce this kernel crash.
1. open one shell and input the following cmds:
  while : ; do
    echo $RANDOM > hashsize
  done
2. open more shells and input the following cmds:
  while : ; do
    cat /proc/net/nf_conntrack
  done
3. just wait a monent, oops will happen soon.

The solution in this patch is based on Florian's Commit 5e3c61f98175
("netfilter: conntrack: fix lookup race during hash resize").

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 include/net/netfilter/nf_conntrack_core.h            |  1 +
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c     | 20 ++++++++++++=
++++----
 net/netfilter/nf_conntrack_core.c                    |  4 +++-
 net/netfilter/nf_conntrack_standalone.c              | 20 ++++++++++++=
+++-----
 4 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/ne=
tfilter/nf_conntrack_core.h
index 3e2f332..4f6453a 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -82,6 +82,7 @@ print_tuple(struct seq_file *s, const struct nf_connt=
rack_tuple *tuple,
 #define CONNTRACK_LOCKS 1024
=20
 extern struct hlist_nulls_head *nf_conntrack_hash;
+extern seqcount_t nf_conntrack_generation;
 extern spinlock_t nf_conntrack_locks[CONNTRACK_LOCKS];
 void nf_conntrack_lock(spinlock_t *lock);
=20
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/ne=
t/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index c6f3c40..584899f 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -26,6 +26,8 @@
=20
 struct ct_iter_state {
 	struct seq_net_private p;
+	struct hlist_nulls_head *hash;
+	unsigned int htable_size;
 	unsigned int bucket;
 };
=20
@@ -35,10 +37,10 @@ static struct hlist_nulls_node *ct_get_first(struct=
 seq_file *seq)
 	struct hlist_nulls_node *n;
=20
 	for (st->bucket =3D 0;
-	     st->bucket < nf_conntrack_htable_size;
+	     st->bucket < st->htable_size;
 	     st->bucket++) {
 		n =3D rcu_dereference(
-			hlist_nulls_first_rcu(&nf_conntrack_hash[st->bucket]));
+			hlist_nulls_first_rcu(&st->hash[st->bucket]));
 		if (!is_a_nulls(n))
 			return n;
 	}
@@ -53,11 +55,11 @@ static struct hlist_nulls_node *ct_get_next(struct =
seq_file *seq,
 	head =3D rcu_dereference(hlist_nulls_next_rcu(head));
 	while (is_a_nulls(head)) {
 		if (likely(get_nulls_value(head) =3D=3D st->bucket)) {
-			if (++st->bucket >=3D nf_conntrack_htable_size)
+			if (++st->bucket >=3D st->htable_size)
 				return NULL;
 		}
 		head =3D rcu_dereference(
-			hlist_nulls_first_rcu(&nf_conntrack_hash[st->bucket]));
+			hlist_nulls_first_rcu(&st->hash[st->bucket]));
 	}
 	return head;
 }
@@ -75,7 +77,17 @@ static struct hlist_nulls_node *ct_get_idx(struct se=
q_file *seq, loff_t pos)
 static void *ct_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(RCU)
 {
+	struct ct_iter_state *st =3D seq->private;
+	unsigned int sequence;
+
 	rcu_read_lock();
+
+	do {
+		sequence =3D read_seqcount_begin(&nf_conntrack_generation);
+		st->htable_size =3D nf_conntrack_htable_size;
+		st->hash =3D nf_conntrack_hash;
+	} while (read_seqcount_retry(&nf_conntrack_generation, sequence));
+
 	return ct_get_idx(seq, *pos);
 }
=20
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_connt=
rack_core.c
index f204274..1c39697 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -72,9 +72,11 @@ EXPORT_SYMBOL_GPL(nf_conntrack_expect_lock);
 struct hlist_nulls_head *nf_conntrack_hash __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_hash);
=20
+seqcount_t nf_conntrack_generation __read_mostly;
+EXPORT_SYMBOL_GPL(nf_conntrack_generation);
+
 static __read_mostly struct kmem_cache *nf_conntrack_cachep;
 static __read_mostly spinlock_t nf_conntrack_locks_all_lock;
-static __read_mostly seqcount_t nf_conntrack_generation;
 static __read_mostly DEFINE_SPINLOCK(nf_conntrack_locks_all_lock);
 static __read_mostly bool nf_conntrack_locks_all;
=20
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf=
_conntrack_standalone.c
index c026c47..2cf484b 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -48,6 +48,8 @@ EXPORT_SYMBOL_GPL(print_tuple);
=20
 struct ct_iter_state {
 	struct seq_net_private p;
+	struct hlist_nulls_head *hash;
+	unsigned int htable_size;
 	unsigned int bucket;
 	u_int64_t time_now;
 };
@@ -58,9 +60,10 @@ static struct hlist_nulls_node *ct_get_first(struct =
seq_file *seq)
 	struct hlist_nulls_node *n;
=20
 	for (st->bucket =3D 0;
-	     st->bucket < nf_conntrack_htable_size;
+	     st->bucket < st->htable_size;
 	     st->bucket++) {
-		n =3D rcu_dereference(hlist_nulls_first_rcu(&nf_conntrack_hash[st->b=
ucket]));
+		n =3D rcu_dereference(
+			hlist_nulls_first_rcu(&st->hash[st->bucket]));
 		if (!is_a_nulls(n))
 			return n;
 	}
@@ -75,12 +78,11 @@ static struct hlist_nulls_node *ct_get_next(struct =
seq_file *seq,
 	head =3D rcu_dereference(hlist_nulls_next_rcu(head));
 	while (is_a_nulls(head)) {
 		if (likely(get_nulls_value(head) =3D=3D st->bucket)) {
-			if (++st->bucket >=3D nf_conntrack_htable_size)
+			if (++st->bucket >=3D st->htable_size)
 				return NULL;
 		}
 		head =3D rcu_dereference(
-				hlist_nulls_first_rcu(
-					&nf_conntrack_hash[st->bucket]));
+			hlist_nulls_first_rcu(&st->hash[st->bucket]));
 	}
 	return head;
 }
@@ -99,9 +101,17 @@ static void *ct_seq_start(struct seq_file *seq, lof=
f_t *pos)
 	__acquires(RCU)
 {
 	struct ct_iter_state *st =3D seq->private;
+	unsigned int sequence;
=20
 	st->time_now =3D ktime_get_real_ns();
 	rcu_read_lock();
+
+	do {
+		sequence =3D read_seqcount_begin(&nf_conntrack_generation);
+		st->htable_size =3D nf_conntrack_htable_size;
+		st->hash =3D nf_conntrack_hash;
+	} while (read_seqcount_retry(&nf_conntrack_generation, sequence));
+
 	return ct_get_idx(seq, *pos);
 }
=20
--=20
2.5.5


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
