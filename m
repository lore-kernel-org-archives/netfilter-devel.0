Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC251C6B2
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2024 16:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="kzc8rk1j"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 9A3ECCC02BD;
	Tue, 16 Jan 2024 17:29:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1705422597; x=1707236998; bh=IbGVm/lpJP
	RUdM7jSX5ETZqulT0Z5QSO2EAhy7m3Z3Q=; b=kzc8rk1jLZaM3kLu44o0vmQq/i
	H8/zIXFr1D0fc/dPtMhm1Fk0y56FykDVgep0lCviFb4CyKFvoP44yDkfwInh15xZ
	4lEFaqb1MX7idYODgtkbB+/CiZOef1Igte1+6C+4piiQMk5c/E6XxG3Y+STjEIfH
	Le4H8VsVWroIfvvQQ=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Tue, 16 Jan 2024 17:29:57 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 0E232CC02BE;
	Tue, 16 Jan 2024 17:29:57 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 083E0343168; Tue, 16 Jan 2024 17:29:57 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Ale Crismani <ale.crismani@automattic.com>,
	David Wang <00107082@163.com>
Subject: [PATCH 1/1] netfilter: ipset: fix performance regression in swap operation
Date: Tue, 16 Jan 2024 17:29:56 +0100
Message-Id: <20240116162956.2517197-2-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240116162956.2517197-1-kadlec@netfilter.org>
References: <20240116162956.2517197-1-kadlec@netfilter.org>
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
Thus we can get back the same performance and preventing the race conditi=
on
at the same time.

Link: https://lore.kernel.org/lkml/C0829B10-EAA6-4809-874E-E1E9C05A8D84@a=
utomattic.com/
Reported-by: Ale Crismani <ale.crismani@automattic.com>
Reported-by: David Wang <00107082@163.com
Tested-by: Ale Crismani <ale.crismani@automattic.com>
Tested-by: David Wang <00107082@163.com
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set.h |  2 ++
 net/netfilter/ipset/ip_set_core.c      | 31 +++++++++++++++++++-------
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfi=
lter/ipset/ip_set.h
index e8c350a3ade1..912f750d0bea 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -242,6 +242,8 @@ extern void ip_set_type_unregister(struct ip_set_type=
 *set_type);
=20
 /* A generic IP set */
 struct ip_set {
+	/* For call_cru in destroy */
+	struct rcu_head rcu;
 	/* The name of the set */
 	char name[IPSET_MAXNAMELEN];
 	/* Lock protecting the set data */
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index 4c133e06be1d..3bf9bb345809 100644
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
@@ -1228,6 +1236,9 @@ static int ip_set_destroy(struct sk_buff *skb, cons=
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
@@ -1238,10 +1249,14 @@ static int ip_set_destroy(struct sk_buff *skb, co=
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
+		call_rcu(&s->rcu, ip_set_destroy_set_rcu);
 	}
 	return 0;
 out:
@@ -1394,9 +1409,6 @@ static int ip_set_swap(struct sk_buff *skb, const s=
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
@@ -2357,6 +2369,9 @@ ip_set_net_exit(struct net *net)
=20
 	inst->is_deleted =3D true; /* flag for ip_set_nfnl_put */
=20
+	/* Wait for call_rcu() in destroy */
+	rcu_barrier();
+
 	nfnl_lock(NFNL_SUBSYS_IPSET);
 	for (i =3D 0; i < inst->ip_set_max; i++) {
 		set =3D ip_set(inst, i);
--=20
2.39.2

