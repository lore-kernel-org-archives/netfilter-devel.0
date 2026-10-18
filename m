Received: from mail-106117.protonmail.ch (mail-106117.protonmail.ch [79.135.106.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B211C3AFAE3
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Oct 2026 05:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792301036; cv=none; b=dUkw2BmLulykD0WTwOctzCwyVZUA2N/UlrQSOgFXMkpd34aN+W+GYv0v4PeQg0mOMi1S77lKgG9QNjd+E65h4yL/rFPQXVTz/e6FjwP4GKv4m0f0+pN3wkNlmIqeKjbz78ItiJ51CgPO1Ad/c6b4L+KH6UXwe0lTUSJHdf2nO+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792301036; c=relaxed/simple;
	bh=AYLA1eK6MvsrUU+7rsMe2d5a3z3k3C0nwUUncysjajQ=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=U0bqDbdWabK/4vcigZO3o8vAx1OJaihYeqi0grRFjc/cN5eZcWr4sqkSAqAMTTqyA9MSU2L/NMizCfKiS8AV5gzH7i5yV+BhKyEv+Rt8JZVcnZRDj8vpSRnqNO7fyXJKi2Eud/0lC4gNiIVSoVXfppliekV84S64zbXNZ4Rlilo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=000ty.net; spf=pass smtp.mailfrom=000ty.net; dkim=pass (2048-bit key) header.d=000ty.net header.i=@000ty.net header.b=NASFlShP; arc=none smtp.client-ip=79.135.106.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=000ty.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=000ty.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=000ty.net header.i=@000ty.net header.b="NASFlShP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=000ty.net;
	s=protonmail2; t=1792301032; x=1792560232;
	bh=Oicios0xcHzSkuTh3Wq8M+oqJEAXftx9IdU8oTchtC4=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=NASFlShP1uLBkLLiJEf1tdVS0h9ciT/O9ihAEYmNnSOw0Pxj6tYRDeonpbPG+7nOu
	 n6bGAZbub0Kqzngm5Y9rM3/HXCOPvE7y8O6CoX+BITaHQIXhc/Ual4YKCz/NXYL4FT
	 NBOKBMy42pmvXcg3ey1qh36jWK/UDo8Vrhe3Z7o7oo581xX7znNRVAHXdV5QihU0Rf
	 hhroyUb8NpW+M7YP4d2IybUf1T9eFxiFnIW+mrUnp5DVRts/hoREMSgr7GKu/QTOM3
	 TJIAhNGrLPKW3waC2tITfkBmalB/MhbABxNdGdgBDDFZr5/M7/6/V+oAp74jmOw2QI
	 8Zh9HVIsdHWuA==
Date: Sun, 18 Oct 2026 05:23:47 +0000
To: netfilter-devel@vger.kernel.org
From: Tamaki Yanagawa <ty@000ty.net>
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, coreteam@netfilter.org, linux-kernel@vger.kernel.org, ty@000ty.net
Subject: [PATCH nf v2] netfilter: ipset: don't mask the element in place in mtype_test_cidrs()
Message-ID: <20261018052340.29588-1-ty@000ty.net>
Feedback-ID: 168296199:user:proton
X-Pm-Message-ID: 5181db6b60a6da08112c757c2f83389358e54945
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

mtype_test_cidrs() masks the element under test in place with
mtype_data_netmask() while walking the cidr array from the most to the
least specific prefix. Since the walk is restarted on concurrent cidr
array updates, the IPSET_NET_COUNT =3D=3D 1 types (hash:net, hash:net,port,
hash:ip,port,net, hash:net,iface) rescan with an element already masked
to the widest prefix tried, so a lookup can wrongly match a more specific
entry at the network base address (e.g. 10.200.3.4 matching 10.0.0.0/29).
Work on a local copy of the element that is reinitialised on every scan
instead.

Fixes: e80456d79ec8 ("netfilter: ipset: remove need to allocate memory on d=
elete operations")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Tamaki Yanagawa <ty@000ty.net>
Assisted-by: Claude:claude-opus-5-5
---
v2: work on a local copy of the element instead of restoring it before
    rescanning (Florian Westphal)
v1: https://lore.kernel.org/netfilter-devel/20261018035205.1008-1-ty@000ty.=
net/

 net/netfilter/ipset/ip_set_hash_gen.h        | 18 +++++++++---------
 net/netfilter/ipset/ip_set_hash_netnet.c     |  4 ++--
 net/netfilter/ipset/ip_set_hash_netportnet.c |  4 ++--
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip=
_set_hash_gen.h
index 80ca523f30..e0d970a25e 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1298,18 +1298,17 @@ mtype_data_match(struct mtype_elem *data, const str=
uct ip_set_ext *ext,
  * sizes added to the set
  */
 static int
-mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
+mtype_test_cidrs(struct ip_set *set, const struct mtype_elem *orig,
 =09=09 const struct ip_set_ext *ext,
 =09=09 struct ip_set_ext *mext, u32 flags)
 {
 =09struct htype *h =3D set->data;
 =09struct htable *t =3D rcu_dereference_bh(h->table);
 =09struct net_prefixes *nets0;
+=09struct mtype_elem *data, d;
 =09struct hbucket *n;
-=09struct mtype_elem *data;
 #if IPSET_NET_COUNT =3D=3D 2
 =09struct net_prefixes *nets1;
-=09struct mtype_elem orig =3D *d;
 =09unsigned int seq1;
 =09int ret, i, j, k;
 #else
@@ -1322,6 +1321,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_ele=
m *d,
 =09pr_debug("test by nets\n");
 =09rcu_read_lock_bh();
 retry:
+=09d =3D *orig;
 =09multi =3D 0;
 =09nets0 =3D rcu_dereference_bh(h->rnets[0]);
 =09seq0 =3D read_seqcount_begin(&nets0->seq);
@@ -1335,18 +1335,18 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_e=
lem *d,
 =09=09if (!p0.count)
 =09=09=09continue;
 #if IPSET_NET_COUNT =3D=3D 2
-=09=09mtype_data_reset_elem(d, &orig);
-=09=09mtype_data_netmask(d, p0.cidr, false);
+=09=09mtype_data_reset_elem(&d, orig);
+=09=09mtype_data_netmask(&d, p0.cidr, false);
 =09=09for (k =3D 0; k < nets1->len && !multi; k++) {
 =09=09=09struct net_prefix p1 =3D READ_ONCE(nets1->nets[k]);
=20
 =09=09=09if (!p1.count)
 =09=09=09=09continue;
-=09=09=09mtype_data_netmask(d, p1.cidr, true);
+=09=09=09mtype_data_netmask(&d, p1.cidr, true);
 #else
-=09=09mtype_data_netmask(d, p0.cidr);
+=09=09mtype_data_netmask(&d, p0.cidr);
 #endif
-=09=09key =3D HKEY(d, h->initval, t->htable_bits);
+=09=09key =3D HKEY(&d, h->initval, t->htable_bits);
 =09=09n =3D rcu_dereference_bh(hbucket(t, key));
 =09=09if (!n)
 =09=09=09continue;
@@ -1355,7 +1355,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_ele=
m *d,
 =09=09=09if (!test_bit_acquire(i, n->used))
 =09=09=09=09continue;
 =09=09=09data =3D ahash_data(n, i, set->dsize);
-=09=09=09if (!mtype_data_equal(data, d, &multi))
+=09=09=09if (!mtype_data_equal(data, &d, &multi))
 =09=09=09=09continue;
 =09=09=09ret =3D mtype_data_match(data, ext, mext, set, flags);
 =09=09=09if (ret !=3D 0)
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset=
/ip_set_hash_netnet.c
index f7c8a1cc30..522ec51374 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -85,7 +85,7 @@ hash_netnet4_data_reset_flags(struct hash_netnet4_elem *e=
lem, u8 *flags)
=20
 static void
 hash_netnet4_data_reset_elem(struct hash_netnet4_elem *elem,
-=09=09=09     struct hash_netnet4_elem *orig)
+=09=09=09     const struct hash_netnet4_elem *orig)
 {
 =09elem->ip[1] =3D orig->ip[1];
 }
@@ -323,7 +323,7 @@ hash_netnet6_data_reset_flags(struct hash_netnet6_elem =
*elem, u8 *flags)
=20
 static void
 hash_netnet6_data_reset_elem(struct hash_netnet6_elem *elem,
-=09=09=09     struct hash_netnet6_elem *orig)
+=09=09=09     const struct hash_netnet6_elem *orig)
 {
 =09elem->ip[1] =3D orig->ip[1];
 }
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/i=
pset/ip_set_hash_netportnet.c
index 61af1ce271..a170b5dd89 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -88,7 +88,7 @@ hash_netportnet4_data_reset_flags(struct hash_netportnet4=
_elem *elem, u8 *flags)
=20
 static void
 hash_netportnet4_data_reset_elem(struct hash_netportnet4_elem *elem,
-=09=09=09=09 struct hash_netportnet4_elem *orig)
+=09=09=09=09 const struct hash_netportnet4_elem *orig)
 {
 =09elem->ip[1] =3D orig->ip[1];
 }
@@ -382,7 +382,7 @@ hash_netportnet6_data_reset_flags(struct hash_netportne=
t6_elem *elem, u8 *flags)
=20
 static void
 hash_netportnet6_data_reset_elem(struct hash_netportnet6_elem *elem,
-=09=09=09=09 struct hash_netportnet6_elem *orig)
+=09=09=09=09 const struct hash_netportnet6_elem *orig)
 {
 =09elem->ip[1] =3D orig->ip[1];
 }

base-commit: ab699d296e066eb64f51d2a8a1d42237a3b186c8
--=20
2.52.0.windows.1


