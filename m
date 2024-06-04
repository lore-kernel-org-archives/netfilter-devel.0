Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368E779C0
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Jun 2024 14:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717509958; cv=none; b=EVtMKqwJujgIGU7fMin8YHTtjota81D1/Pz8HhmRB0EB6okQjx2oBO4D+yvHc9OFFFBx1EHpvQREb1RofQBecfqxWq1VY4eQlza3oDe/eUb3D6x0Q+AIzNeF+lKO17LaMDU57sNfieUK9Ie2t9dlYWbmX1bSLmFvNviNBoBwaKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717509958; c=relaxed/simple;
	bh=erGRSpurWLpZB7NYO1dlsJdffg7fZCZY732fB8O7gEg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qCebDUH+JA6JYSAZgkNUgLuahSTsbq77wu38nXLcJrTVRpnIWN8FplP38QZoJJOrDg0TUbK1KmOD3sg6ipLTl0smMXkAnGm0i0BUROQaZp7bIwpQEk1Cvx9c81xPsPh6ox01Dpiqo7348FiHxc5gmdfyarM5tLKjNwGxHeXHSRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=cziSbiGd; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="cziSbiGd"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id B9198CC010B;
	Tue,  4 Jun 2024 15:58:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1717509483; x=1719323884; bh=JiY3eplLOz
	qJ4BjqnCiXoWlvi+v/s8SdFVXTo7WEAic=; b=cziSbiGd0IoDja6RG1jKJizWmV
	L+QmH0ptuSSLhGzOabpHOB+osORig9gJLgJgO1Q2dRKYx6Z0YQgdEEv+G2GHjsPM
	MEY2w30D8w//KPHaNi2WZiMLG7ueqtHFjMMkD9QZNyzcluqwYJwK9N8DgpBERHaN
	7WIXRL5rytQK1hPKs=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Tue,  4 Jun 2024 15:58:03 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id A5FF0CC0110;
	Tue,  4 Jun 2024 15:58:03 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id A0A5434316C; Tue,  4 Jun 2024 15:58:03 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Lion Ackermann <nnamrec@gmail.com>
Subject: [PATCH 1/1] netfilter: ipset: Fix race between namespace cleanup and gc in the list:set type
Date: Tue,  4 Jun 2024 15:58:03 +0200
Message-Id: <20240604135803.2462674-2-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240604135803.2462674-1-kadlec@netfilter.org>
References: <20240604135803.2462674-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Lion Ackermann reported that there is a race condition between namespace =
cleanup
in ipset and the garbage collection of the list:set type. The namespace
cleanup can destroy the list:set type of sets while the gc of the set typ=
e is
waiting to run in rcu cleanup. The latter uses data from the destroyed se=
t which
thus leads use after free. The patch contains the following parts:

- When destroying all sets, first remove the garbage collectors, then wai=
t
  if needed and then destroy the sets.
- Fix the badly ordered "wait then remove gc" for the destroy a single se=
t
  case.
- Fix the missing rcu locking in the list:set type in the userspace test
  case.
- Use proper RCU list handlings in the list:set type.

The patch depends on c1193d9bbbd3 (netfilter: ipset: Add list flush to ca=
ncel_gc).

Fixes: 97f7cf1cd80e (netfilter: ipset: fix performance regression in swap=
 operation)
Reported-by: Lion Ackermann <nnamrec@gmail.com>
Tested-by: Lion Ackermann <nnamrec@gmail.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c     | 81 +++++++++++++++------------
 net/netfilter/ipset/ip_set_list_set.c | 30 +++++-----
 2 files changed, 60 insertions(+), 51 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index 3184cc6be4c9..c7ae4d9bf3d2 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1172,23 +1172,50 @@ ip_set_setname_policy[IPSET_ATTR_CMD_MAX + 1] =3D=
 {
 				    .len =3D IPSET_MAXNAMELEN - 1 },
 };
=20
+/* In order to return quickly when destroying a single set, it is split
+ * into two stages:
+ * - Cancel garbage collector
+ * - Destroy the set itself via call_rcu()
+ */
+
 static void
-ip_set_destroy_set(struct ip_set *set)
+ip_set_destroy_set_rcu(struct rcu_head *head)
 {
-	pr_debug("set: %s\n",  set->name);
+	struct ip_set *set =3D container_of(head, struct ip_set, rcu);
=20
-	/* Must call it without holding any lock */
 	set->variant->destroy(set);
 	module_put(set->type->me);
 	kfree(set);
 }
=20
 static void
-ip_set_destroy_set_rcu(struct rcu_head *head)
+_destroy_all_sets(struct ip_set_net *inst)
 {
-	struct ip_set *set =3D container_of(head, struct ip_set, rcu);
+	struct ip_set *set;
+	ip_set_id_t i;
+	bool need_wait =3D false;
=20
-	ip_set_destroy_set(set);
+	/* First cancel gc's: set:list sets are flushed as well */
+	for (i =3D 0; i < inst->ip_set_max; i++) {
+		set =3D ip_set(inst, i);
+		if (set) {
+			set->variant->cancel_gc(set);
+			if (set->type->features & IPSET_TYPE_NAME)
+				need_wait =3D true;
+		}
+	}
+	/* Must wait for flush to be really finished  */
+	if (need_wait)
+		rcu_barrier();
+	for (i =3D 0; i < inst->ip_set_max; i++) {
+		set =3D ip_set(inst, i);
+		if (set) {
+			ip_set(inst, i) =3D NULL;
+			set->variant->destroy(set);
+			module_put(set->type->me);
+			kfree(set);
+		}
+	}
 }
=20
 static int ip_set_destroy(struct sk_buff *skb, const struct nfnl_info *i=
nfo,
@@ -1202,11 +1229,10 @@ static int ip_set_destroy(struct sk_buff *skb, co=
nst struct nfnl_info *info,
 	if (unlikely(protocol_min_failed(attr)))
 		return -IPSET_ERR_PROTOCOL;
=20
-
 	/* Commands are serialized and references are
 	 * protected by the ip_set_ref_lock.
 	 * External systems (i.e. xt_set) must call
-	 * ip_set_put|get_nfnl_* functions, that way we
+	 * ip_set_nfnl_get_* functions, that way we
 	 * can safely check references here.
 	 *
 	 * list:set timer can only decrement the reference
@@ -1214,8 +1240,6 @@ static int ip_set_destroy(struct sk_buff *skb, cons=
t struct nfnl_info *info,
 	 * without holding the lock.
 	 */
 	if (!attr[IPSET_ATTR_SETNAME]) {
-		/* Must wait for flush to be really finished in list:set */
-		rcu_barrier();
 		read_lock_bh(&ip_set_ref_lock);
 		for (i =3D 0; i < inst->ip_set_max; i++) {
 			s =3D ip_set(inst, i);
@@ -1226,15 +1250,7 @@ static int ip_set_destroy(struct sk_buff *skb, con=
st struct nfnl_info *info,
 		}
 		inst->is_destroyed =3D true;
 		read_unlock_bh(&ip_set_ref_lock);
-		for (i =3D 0; i < inst->ip_set_max; i++) {
-			s =3D ip_set(inst, i);
-			if (s) {
-				ip_set(inst, i) =3D NULL;
-				/* Must cancel garbage collectors */
-				s->variant->cancel_gc(s);
-				ip_set_destroy_set(s);
-			}
-		}
+		_destroy_all_sets(inst);
 		/* Modified by ip_set_destroy() only, which is serialized */
 		inst->is_destroyed =3D false;
 	} else {
@@ -1255,12 +1271,12 @@ static int ip_set_destroy(struct sk_buff *skb, co=
nst struct nfnl_info *info,
 		features =3D s->type->features;
 		ip_set(inst, i) =3D NULL;
 		read_unlock_bh(&ip_set_ref_lock);
+		/* Must cancel garbage collectors */
+		s->variant->cancel_gc(s);
 		if (features & IPSET_TYPE_NAME) {
 			/* Must wait for flush to be really finished  */
 			rcu_barrier();
 		}
-		/* Must cancel garbage collectors */
-		s->variant->cancel_gc(s);
 		call_rcu(&s->rcu, ip_set_destroy_set_rcu);
 	}
 	return 0;
@@ -2365,30 +2381,25 @@ ip_set_net_init(struct net *net)
 }
=20
 static void __net_exit
-ip_set_net_exit(struct net *net)
+ip_set_net_pre_exit(struct net *net)
 {
 	struct ip_set_net *inst =3D ip_set_pernet(net);
=20
-	struct ip_set *set =3D NULL;
-	ip_set_id_t i;
-
 	inst->is_deleted =3D true; /* flag for ip_set_nfnl_put */
+}
=20
-	nfnl_lock(NFNL_SUBSYS_IPSET);
-	for (i =3D 0; i < inst->ip_set_max; i++) {
-		set =3D ip_set(inst, i);
-		if (set) {
-			ip_set(inst, i) =3D NULL;
-			set->variant->cancel_gc(set);
-			ip_set_destroy_set(set);
-		}
-	}
-	nfnl_unlock(NFNL_SUBSYS_IPSET);
+static void __net_exit
+ip_set_net_exit(struct net *net)
+{
+	struct ip_set_net *inst =3D ip_set_pernet(net);
+
+	_destroy_all_sets(inst);
 	kvfree(rcu_dereference_protected(inst->ip_set_list, 1));
 }
=20
 static struct pernet_operations ip_set_net_ops =3D {
 	.init	=3D ip_set_net_init,
+	.pre_exit =3D ip_set_net_pre_exit,
 	.exit   =3D ip_set_net_exit,
 	.id	=3D &ip_set_net_id,
 	.size	=3D sizeof(struct ip_set_net),
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/=
ip_set_list_set.c
index 54e2a1dd7f5f..4ff57e1327d7 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -79,7 +79,7 @@ list_set_kadd(struct ip_set *set, const struct sk_buff =
*skb,
 	struct set_elem *e;
 	int ret;
=20
-	list_for_each_entry(e, &map->members, list) {
+	list_for_each_entry_rcu(e, &map->members, list) {
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(e, set)))
 			continue;
@@ -99,7 +99,7 @@ list_set_kdel(struct ip_set *set, const struct sk_buff =
*skb,
 	struct set_elem *e;
 	int ret;
=20
-	list_for_each_entry(e, &map->members, list) {
+	list_for_each_entry_rcu(e, &map->members, list) {
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(e, set)))
 			continue;
@@ -188,9 +188,10 @@ list_set_utest(struct ip_set *set, void *value, cons=
t struct ip_set_ext *ext,
 	struct list_set *map =3D set->data;
 	struct set_adt_elem *d =3D value;
 	struct set_elem *e, *next, *prev =3D NULL;
-	int ret;
+	int ret =3D 0;
=20
-	list_for_each_entry(e, &map->members, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(e, &map->members, list) {
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(e, set)))
 			continue;
@@ -201,6 +202,7 @@ list_set_utest(struct ip_set *set, void *value, const=
 struct ip_set_ext *ext,
=20
 		if (d->before =3D=3D 0) {
 			ret =3D 1;
+			goto out;
 		} else if (d->before > 0) {
 			next =3D list_next_entry(e, list);
 			ret =3D !list_is_last(&e->list, &map->members) &&
@@ -208,9 +210,11 @@ list_set_utest(struct ip_set *set, void *value, cons=
t struct ip_set_ext *ext,
 		} else {
 			ret =3D prev && prev->id =3D=3D d->refid;
 		}
-		return ret;
+		goto out;
 	}
-	return 0;
+out:
+	rcu_read_unlock();
+	return ret;
 }
=20
 static void
@@ -239,7 +243,7 @@ list_set_uadd(struct ip_set *set, void *value, const =
struct ip_set_ext *ext,
=20
 	/* Find where to add the new entry */
 	n =3D prev =3D next =3D NULL;
-	list_for_each_entry(e, &map->members, list) {
+	list_for_each_entry_rcu(e, &map->members, list) {
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(e, set)))
 			continue;
@@ -316,9 +320,9 @@ list_set_udel(struct ip_set *set, void *value, const =
struct ip_set_ext *ext,
 {
 	struct list_set *map =3D set->data;
 	struct set_adt_elem *d =3D value;
-	struct set_elem *e, *next, *prev =3D NULL;
+	struct set_elem *e, *n, *next, *prev =3D NULL;
=20
-	list_for_each_entry(e, &map->members, list) {
+	list_for_each_entry_safe(e, n, &map->members, list) {
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(e, set)))
 			continue;
@@ -424,14 +428,8 @@ static void
 list_set_destroy(struct ip_set *set)
 {
 	struct list_set *map =3D set->data;
-	struct set_elem *e, *n;
=20
-	list_for_each_entry_safe(e, n, &map->members, list) {
-		list_del(&e->list);
-		ip_set_put_byindex(map->net, e->id);
-		ip_set_ext_destroy(set, e);
-		kfree(e);
-	}
+	BUG_ON(!list_empty(&map->members));
 	kfree(map);
=20
 	set->data =3D NULL;
--=20
2.39.2

