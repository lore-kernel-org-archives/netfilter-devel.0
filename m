Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0339F55E4B
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jan 2024 09:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706522236; cv=none; b=MJE07gqKeYwPeVaJY9Njlen/2dF2h0gHto6JKEsoQbxgRmFXOUU1Ot4RCbQzIB6W/ZBHjkCMz/2MVuUYVzu6OlSK9WA5WAWVEOEpx4Ol3jArH8velHGEYPau9hJpixOeaEUZsLsvdptBXeRJZgyK4PDmd5pul5yEuk+WSux3xhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706522236; c=relaxed/simple;
	bh=vf57AtTNPOrqR37Ss8K1NaSMs0AvU1N4Hnr7zL7V4aE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hmyBo59DDf/QZDSMjzGFS/Q35m4//mOJ5XpTXMTd+/KnXgp15O0sEuU9WB5SnyajEivbPmmBDciyUwaF6KSjVapiuui8yd6WKXY6zwUW5/Xm/3seDFwxwlz3Uid4Lqz+292l+MVHWJc37f/QzmNQuHCQPUKXsKi0CswEXAtEj7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=h1URALH+; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="h1URALH+"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 1F221CC010D;
	Mon, 29 Jan 2024 10:57:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1706522221; x=1708336622; bh=0snR6qZLFH
	yL9RsbRJwqpdA1RjS267wwqRc19cr3dk8=; b=h1URALH+jm+cM3ACMe3oVu3Vif
	VF35pyLzG974YwQ6VTjpfRr6CGn08gtIA5Ia4Wpox6pKhkItQesoLy2q5Bl/u8sq
	lNZZyWuo1ATbwX6zYGmnC1JVAGs5unD4c46fgtiuuBxFD474A+YLdKeHl0MIueX+
	0mTtNDkEA7vGof2Nc=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Mon, 29 Jan 2024 10:57:01 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id B0F03CC02B0;
	Mon, 29 Jan 2024 10:57:01 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id AC50E343168; Mon, 29 Jan 2024 10:57:01 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Ale Crismani <ale.crismani@automattic.com>,
	David Wang <00107082@163.com>,
	Eric Dumazet <edumazet@google.com>
Subject: [PATCH 1/1] netfilter: ipset: fix performance regression in swap operation
Date: Mon, 29 Jan 2024 10:57:01 +0100
Message-Id: <20240129095701.388482-2-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129095701.388482-1-kadlec@netfilter.org>
References: <20240129095701.388482-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The patch "netfilter: ipset: fix race condition between swap/destroy
and kernel side add/del/test", commit 28628fa9 fixes a race condition.
But the synchronize_rcu() added to the swap function unnecessarily slows
it down: it can safely be moved to destroy and use call_rcu() instead.

Eric Dumazet pointed out that simply calling the destroy functions as
rcu callback does not work: sets with timeout use garbage collectors
which need cancelling at destroy which can wait. Therefore the destroy
functions are split into two: cancelling garbage collectors safely at
executing the command received by netlink and moving the remaining
part only into the rcu callback.

Link: https://lore.kernel.org/lkml/C0829B10-EAA6-4809-874E-E1E9C05A8D84@a=
utomattic.com/
Fixes: 28628fa952fe ("netfilter: ipset: fix race condition between swap/d=
estroy and kernel side add/del/test")
Reported-by: Ale Crismani <ale.crismani@automattic.com>
Reported-by: David Wang <00107082@163.com>
Tested-by: David Wang <00107082@163.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set.h  |  4 +++
 net/netfilter/ipset/ip_set_bitmap_gen.h | 14 ++++++++--
 net/netfilter/ipset/ip_set_core.c       | 37 +++++++++++++++++++------
 net/netfilter/ipset/ip_set_hash_gen.h   | 15 ++++++++--
 net/netfilter/ipset/ip_set_list_set.c   | 13 +++++++--
 5 files changed, 65 insertions(+), 18 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfi=
lter/ipset/ip_set.h
index e8c350a3ade1..e9f4f845d760 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -186,6 +186,8 @@ struct ip_set_type_variant {
 	/* Return true if "b" set is the same as "a"
 	 * according to the create set parameters */
 	bool (*same_set)(const struct ip_set *a, const struct ip_set *b);
+	/* Cancel ongoing garbage collectors before destroying the set*/
+	void (*cancel_gc)(struct ip_set *set);
 	/* Region-locking is used */
 	bool region_lock;
 };
@@ -242,6 +244,8 @@ extern void ip_set_type_unregister(struct ip_set_type=
 *set_type);
=20
 /* A generic IP set */
 struct ip_set {
+	/* For call_cru in destroy */
+	struct rcu_head rcu;
 	/* The name of the set */
 	char name[IPSET_MAXNAMELEN];
 	/* Lock protecting the set data */
diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipse=
t/ip_set_bitmap_gen.h
index 26ab0e9612d8..9523104a90da 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -28,6 +28,7 @@
 #define mtype_del		IPSET_TOKEN(MTYPE, _del)
 #define mtype_list		IPSET_TOKEN(MTYPE, _list)
 #define mtype_gc		IPSET_TOKEN(MTYPE, _gc)
+#define mtype_cancel_gc		IPSET_TOKEN(MTYPE, _cancel_gc)
 #define mtype			MTYPE
=20
 #define get_ext(set, map, id)	((map)->extensions + ((set)->dsize * (id))=
)
@@ -57,9 +58,6 @@ mtype_destroy(struct ip_set *set)
 {
 	struct mtype *map =3D set->data;
=20
-	if (SET_WITH_TIMEOUT(set))
-		del_timer_sync(&map->gc);
-
 	if (set->dsize && set->extensions & IPSET_EXT_DESTROY)
 		mtype_ext_cleanup(set);
 	ip_set_free(map->members);
@@ -288,6 +286,15 @@ mtype_gc(struct timer_list *t)
 	add_timer(&map->gc);
 }
=20
+static void
+mtype_cancel_gc(struct ip_set *set)
+{
+	struct mtype *map =3D set->data;
+
+	if (SET_WITH_TIMEOUT(set))
+		del_timer_sync(&map->gc);
+}
+
 static const struct ip_set_type_variant mtype =3D {
 	.kadt	=3D mtype_kadt,
 	.uadt	=3D mtype_uadt,
@@ -301,6 +308,7 @@ static const struct ip_set_type_variant mtype =3D {
 	.head	=3D mtype_head,
 	.list	=3D mtype_list,
 	.same_set =3D mtype_same_set,
+	.cancel_gc =3D mtype_cancel_gc,
 };
=20
 #endif /* __IP_SET_BITMAP_IP_GEN_H */
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index 4c133e06be1d..bcaad9c009fe 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1182,6 +1182,14 @@ ip_set_destroy_set(struct ip_set *set)
 	kfree(set);
 }
=20
+static void
+ip_set_destroy_set_rcu(struct rcu_head *head)
+{
+	struct ip_set *set =3D container_of(head, struct ip_set, rcu);
+
+	ip_set_destroy_set(set);
+}
+
 static int ip_set_destroy(struct sk_buff *skb, const struct nfnl_info *i=
nfo,
 			  const struct nlattr * const attr[])
 {
@@ -1193,8 +1201,6 @@ static int ip_set_destroy(struct sk_buff *skb, cons=
t struct nfnl_info *info,
 	if (unlikely(protocol_min_failed(attr)))
 		return -IPSET_ERR_PROTOCOL;
=20
-	/* Must wait for flush to be really finished in list:set */
-	rcu_barrier();
=20
 	/* Commands are serialized and references are
 	 * protected by the ip_set_ref_lock.
@@ -1206,8 +1212,10 @@ static int ip_set_destroy(struct sk_buff *skb, con=
st struct nfnl_info *info,
 	 * counter, so if it's already zero, we can proceed
 	 * without holding the lock.
 	 */
-	read_lock_bh(&ip_set_ref_lock);
 	if (!attr[IPSET_ATTR_SETNAME]) {
+		/* Must wait for flush to be really finished in list:set */
+		rcu_barrier();
+		read_lock_bh(&ip_set_ref_lock);
 		for (i =3D 0; i < inst->ip_set_max; i++) {
 			s =3D ip_set(inst, i);
 			if (s && (s->ref || s->ref_netlink)) {
@@ -1221,6 +1229,8 @@ static int ip_set_destroy(struct sk_buff *skb, cons=
t struct nfnl_info *info,
 			s =3D ip_set(inst, i);
 			if (s) {
 				ip_set(inst, i) =3D NULL;
+				/* Must cancel garbage collectors */
+				s->variant->cancel_gc(s);
 				ip_set_destroy_set(s);
 			}
 		}
@@ -1228,6 +1238,9 @@ static int ip_set_destroy(struct sk_buff *skb, cons=
t struct nfnl_info *info,
 		inst->is_destroyed =3D false;
 	} else {
 		u32 flags =3D flag_exist(info->nlh);
+		u16 features =3D 0;
+
+		read_lock_bh(&ip_set_ref_lock);
 		s =3D find_set_and_id(inst, nla_data(attr[IPSET_ATTR_SETNAME]),
 				    &i);
 		if (!s) {
@@ -1238,10 +1251,16 @@ static int ip_set_destroy(struct sk_buff *skb, co=
nst struct nfnl_info *info,
 			ret =3D -IPSET_ERR_BUSY;
 			goto out;
 		}
+		features =3D s->type->features;
 		ip_set(inst, i) =3D NULL;
 		read_unlock_bh(&ip_set_ref_lock);
-
-		ip_set_destroy_set(s);
+		if (features & IPSET_TYPE_NAME) {
+			/* Must wait for flush to be really finished  */
+			rcu_barrier();
+		}
+		/* Must cancel garbage collectors */
+		s->variant->cancel_gc(s);
+		call_rcu(&s->rcu, ip_set_destroy_set_rcu);
 	}
 	return 0;
 out:
@@ -1394,9 +1413,6 @@ static int ip_set_swap(struct sk_buff *skb, const s=
truct nfnl_info *info,
 	ip_set(inst, to_id) =3D from;
 	write_unlock_bh(&ip_set_ref_lock);
=20
-	/* Make sure all readers of the old set pointers are completed. */
-	synchronize_rcu();
-
 	return 0;
 }
=20
@@ -2409,8 +2425,11 @@ ip_set_fini(void)
 {
 	nf_unregister_sockopt(&so_set);
 	nfnetlink_subsys_unregister(&ip_set_netlink_subsys);
-
 	unregister_pernet_subsys(&ip_set_net_ops);
+
+	/* Wait for call_rcu() in destroy */
+	rcu_barrier();
+
 	pr_debug("these are the famous last words\n");
 }
=20
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 7c2399541771..c62998b46f00 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -221,6 +221,7 @@ static const union nf_inet_addr zeromask =3D {};
 #undef mtype_gc_do
 #undef mtype_gc
 #undef mtype_gc_init
+#undef mtype_cancel_gc
 #undef mtype_variant
 #undef mtype_data_match
=20
@@ -265,6 +266,7 @@ static const union nf_inet_addr zeromask =3D {};
 #define mtype_gc_do		IPSET_TOKEN(MTYPE, _gc_do)
 #define mtype_gc		IPSET_TOKEN(MTYPE, _gc)
 #define mtype_gc_init		IPSET_TOKEN(MTYPE, _gc_init)
+#define mtype_cancel_gc		IPSET_TOKEN(MTYPE, _cancel_gc)
 #define mtype_variant		IPSET_TOKEN(MTYPE, _variant)
 #define mtype_data_match	IPSET_TOKEN(MTYPE, _data_match)
=20
@@ -449,9 +451,6 @@ mtype_destroy(struct ip_set *set)
 	struct htype *h =3D set->data;
 	struct list_head *l, *lt;
=20
-	if (SET_WITH_TIMEOUT(set))
-		cancel_delayed_work_sync(&h->gc.dwork);
-
 	mtype_ahash_destroy(set, ipset_dereference_nfnl(h->table), true);
 	list_for_each_safe(l, lt, &h->ad) {
 		list_del(l);
@@ -598,6 +597,15 @@ mtype_gc_init(struct htable_gc *gc)
 	queue_delayed_work(system_power_efficient_wq, &gc->dwork, HZ);
 }
=20
+static void
+mtype_cancel_gc(struct ip_set *set)
+{
+	struct htype *h =3D set->data;
+
+	if (SET_WITH_TIMEOUT(set))
+		cancel_delayed_work_sync(&h->gc.dwork);
+}
+
 static int
 mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	  struct ip_set_ext *mext, u32 flags);
@@ -1440,6 +1448,7 @@ static const struct ip_set_type_variant mtype_varia=
nt =3D {
 	.uref	=3D mtype_uref,
 	.resize	=3D mtype_resize,
 	.same_set =3D mtype_same_set,
+	.cancel_gc =3D mtype_cancel_gc,
 	.region_lock =3D true,
 };
=20
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/=
ip_set_list_set.c
index e162636525cf..6c3f28bc59b3 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -426,9 +426,6 @@ list_set_destroy(struct ip_set *set)
 	struct list_set *map =3D set->data;
 	struct set_elem *e, *n;
=20
-	if (SET_WITH_TIMEOUT(set))
-		timer_shutdown_sync(&map->gc);
-
 	list_for_each_entry_safe(e, n, &map->members, list) {
 		list_del(&e->list);
 		ip_set_put_byindex(map->net, e->id);
@@ -545,6 +542,15 @@ list_set_same_set(const struct ip_set *a, const stru=
ct ip_set *b)
 	       a->extensions =3D=3D b->extensions;
 }
=20
+static void
+list_set_cancel_gc(struct ip_set *set)
+{
+	struct list_set *map =3D set->data;
+
+	if (SET_WITH_TIMEOUT(set))
+		timer_shutdown_sync(&map->gc);
+}
+
 static const struct ip_set_type_variant set_variant =3D {
 	.kadt	=3D list_set_kadt,
 	.uadt	=3D list_set_uadt,
@@ -558,6 +564,7 @@ static const struct ip_set_type_variant set_variant =3D=
 {
 	.head	=3D list_set_head,
 	.list	=3D list_set_list,
 	.same_set =3D list_set_same_set,
+	.cancel_gc =3D list_set_cancel_gc,
 };
=20
 static void
--=20
2.39.2

