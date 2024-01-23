Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0642B9C0;
	Tue, 23 Jan 2024 09:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706000638; cv=none; b=sTDS/nd9OR3d7Vjq8L37aH8q+EFpNwl40Bn4ZgwkWznr8G50Y5nQAt4OMHFpkAD2vhnDD9SWfUpwCIXe0h3nmZ6tLDCT09rnLooXYT/SZ4rrwEXAT+8olmK0tSHf4lk/Hna3OUDxKsI0KTK2e83HHBcCc7+5zY1fWS3lXJ35d+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706000638; c=relaxed/simple;
	bh=UAHegfb25d4VNXDGuf0H9u03FJExWUekncOgVuwvIio=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=kspfbsPKcgPqTi+39Yd+WWWWTh0YoEii1FqgAvyeb4tUWTUoWUwOZoK1xSI0Z9pN+P9VJSg7bcmm6kd7TQZnLou8goy6jfZTyo92uQdjxmo9RhJs5UuYcuLM1MwuI+Euci12iLoR1tBOeihew31u+qVVsy2cfVr9KybVb++/f8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=WlNeNjTY; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="WlNeNjTY"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 2AED1CC02B2;
	Tue, 23 Jan 2024 10:03:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1706000624; x=1707815025; bh=nC7mKaulMn
	/6QdKiOoPiOluTjCpw6qXjTKNStEnW7Mg=; b=WlNeNjTYAnYfeRZ6LeeMnrOAah
	qRyG4kklnAPuRrGc3cWzdmaeMKjM19ra9+1zhsGhZXCN4MIVog6dv42jSEcDM33V
	s6P6AO/4yoOphNZ3cNwokrO8X7iEgE68La9Z6thpnN9F2U1aEpqVmcb1qfjMyQQd
	AujeTFJC5fbqW2vEY=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Tue, 23 Jan 2024 10:03:44 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4D8E1CC02BF;
	Tue, 23 Jan 2024 10:03:42 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 47E76343167; Tue, 23 Jan 2024 10:03:42 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 468F5343166;
	Tue, 23 Jan 2024 10:03:42 +0100 (CET)
Date: Tue, 23 Jan 2024 10:03:42 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Eric Dumazet <edumazet@google.com>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org, 
    David Miller <davem@davemloft.net>, netdev@vger.kernel.org, 
    kuba@kernel.org, pabeni@redhat.com, Florian Westphal <fw@strlen.de>, 
    Ale Crismani <ale.crismani@automattic.com>, David Wang <00107082@163.com>
Subject: Re: [PATCH net 14/14] netfilter: ipset: fix performance regression
 in swap operation
In-Reply-To: <afb39fa8-3b28-27eb-c8ac-22691a064495@netfilter.org>
Message-ID: <1a506719-db2b-c2ce-aaa2-d0067b3d772e@blackhole.kfki.hu>
References: <20240117160030.140264-1-pablo@netfilter.org> <20240117160030.140264-15-pablo@netfilter.org> <CANn89iKtpVy1kSSuk_RSGN0R6L+roNJr81ED4+a2SZ2WKzGsng@mail.gmail.com> <afb39fa8-3b28-27eb-c8ac-22691a064495@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-766840901-1706000622=:2980"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-766840901-1706000622=:2980
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 18 Jan 2024, Jozsef Kadlecsik wrote:

> On Thu, 18 Jan 2024, Eric Dumazet wrote:
>=20
> > On Wed, Jan 17, 2024 at 5:00=E2=80=AFPM Pablo Neira Ayuso <pablo@netf=
ilter.org> wrote:
> > >
> > > The patch "netfilter: ipset: fix race condition between swap/destro=
y
> > > and kernel side add/del/test", commit 28628fa9 fixes a race conditi=
on.
> > > But the synchronize_rcu() added to the swap function unnecessarily =
slows
> > > it down: it can safely be moved to destroy and use call_rcu() inste=
ad.
> > > Thus we can get back the same performance and preventing the race c=
ondition
> > > at the same time.
[...]
> > > +static void
> > > +ip_set_destroy_set_rcu(struct rcu_head *head)
> > > +{
> > > +       struct ip_set *set =3D container_of(head, struct ip_set, rc=
u);
> > > +
> > > +       ip_set_destroy_set(set);
> >=20
> > Calling ip_set_destroy_set() from BH (rcu callbacks) is not working.
>=20
> Yeah, it calls cancel_delayed_work_sync() to handle the garbage collect=
or=20
> and that can wait. The call can be moved into the main destroy function=
=20
> and let the rcu callback do just the minimal job, however it needs a=20
> restructuring. So please skip this patch now.

I reworked the patch to work safely with using call_rcu() and still=20
preventing the race condition. According to my tests the patch works as=20
intended, but it'd be good to receive feedback that it indeed fixes the=20
issue properly.

From 23e85f453da573dd4265e7d1fffd2aeab3369e0d Mon Sep 17 00:00:00 2001
From: Jozsef Kadlecsik <kadlec@netfilter.org>
Date: Tue, 16 Jan 2024 17:10:45 +0100
Subject: [PATCH 1/1] netfilter: ipset: fix performance regression in swap
 operation

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
Reported-by: David Wang <00107082@163.com
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

Best regards,
Jozsef
--=20
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-766840901-1706000622=:2980--
