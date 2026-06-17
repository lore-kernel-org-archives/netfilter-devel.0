Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFC33DE424
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jun 2026 08:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781686159; cv=none; b=WGvM8tJDRZiIzk2x1yMnj/4Rq+cMug1DrB4pNNF+EskXpM0vCUETLNv+kY0Q9UVIvj9ytg/2WCSjBo86RyABP6H1jC27aNUg1yF0TLz24FhmJTyBOSKLnhipYVHcDi1ixCoh192vRVAq8yT1DLympOm9Z5JNlgIFPZkO88OelE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781686159; c=relaxed/simple;
	bh=XtzjSMkNoeuWEwU5Y5sUt5sfWaa3bb/AbulbsrJBXn4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BHqASsjk0UIMbr/esyv/4XkcuedwuA6Ak4U+uXuFg8kMl8GNaUilp8p0kL7w4lWFNpnlD1jCfM1hYJV1hbOBNqSBjej+WqGUSVF3VaCfRo8Ks7z1PJsQpKiqy3EWDcqGPLU3x3L6MKBYF81CI/7yMd1BmdKqAv2IUNVsNNECylI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=V7p8cbQW; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="V7p8cbQW"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4ggHQL5nzPz3sb0q;
	Wed, 17 Jun 2026 10:41:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1781685688; x=1783500089; bh=O8dC+I8CJ9
	keVEGMYboSepei/pahSohoEKjZMkcDqvw=; b=V7p8cbQWCS5AbB4BgIsiQl2P2w
	DPKEwPps+cwHJTn9mbznmhwC+uoG2b7ctFaI+oojbR7baVYV0gp1AjzVDWO1CQMj
	oH/DcbIAY5eYsZHkW95jamZ2/hGTTqZq6LGTZNT1UvdR7KuMFoDs+GdEK/dg+ff7
	JqmHQwJqMRbVLAsL8=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id z0SkhuQMio8h; Wed, 17 Jun 2026 10:41:28 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (unknown [148.6.40.64])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 4ggHQJ63bFz3sb0W;
	Wed, 17 Jun 2026 10:41:28 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id A80941406DA; Wed, 17 Jun 2026 10:41:28 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v3 2/7] netfilter: ipset: Don't use test_bit() in lockless RCU readers in bitmap types
Date: Wed, 17 Jun 2026 10:41:23 +0200
Message-Id: <20260617084128.6603-3-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260617084128.6603-1-kadlec@netfilter.org>
References: <20260617084128.6603-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The pair of the patch "netfilter: ipset: Don't use test_bit() in lockless
RCU readers in hash types" for the bitmap types.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h   | 4 +++-
 net/netfilter/ipset/ip_set_bitmap_ip.c    | 2 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 2 +-
 net/netfilter/ipset/ip_set_bitmap_port.c  | 2 +-
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipse=
t/ip_set_bitmap_gen.h
index 798c7993635e..bb9b5bed10e1 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -165,6 +165,7 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 		ip_set_init_skbinfo(ext_skbinfo(x, set), ext);
=20
 	/* Activate element */
+	smp_mb__before_atomic();
 	set_bit(e->id, map->members);
 	set->elements++;
=20
@@ -219,7 +220,7 @@ mtype_list(const struct ip_set *set,
 		cond_resched_rcu();
 		id =3D cb->args[IPSET_CB_ARG0];
 		x =3D get_ext(set, map, id);
-		if (!test_bit(id, map->members) ||
+		if (!test_bit_acquire(id, map->members) ||
 		    (SET_WITH_TIMEOUT(set) &&
 #ifdef IP_SET_BITMAP_STORED_TIMEOUT
 		     mtype_is_filled(x) &&
@@ -278,6 +279,7 @@ mtype_gc(struct timer_list *t)
 			x =3D get_ext(set, map, id);
 			if (ip_set_timeout_expired(ext_timeout(x, set))) {
 				clear_bit(id, map->members);
+				smp_mb__after_atomic();
 				ip_set_ext_destroy(set, x);
 				set->elements--;
 			}
diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset=
/ip_set_bitmap_ip.c
index 5988b9bb9029..ac7febce074f 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -67,7 +67,7 @@ static int
 bitmap_ip_do_test(const struct bitmap_ip_adt_elem *e,
 		  struct bitmap_ip *map, size_t dsize)
 {
-	return !!test_bit(e->id, map->members);
+	return !!test_bit_acquire(e->id, map->members);
 }
=20
 static int
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ip=
set/ip_set_bitmap_ipmac.c
index 752f59ef8744..5921fd9d2dca 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -86,7 +86,7 @@ bitmap_ipmac_do_test(const struct bitmap_ipmac_adt_elem=
 *e,
 {
 	const struct bitmap_ipmac_elem *elem;
=20
-	if (!test_bit(e->id, map->members))
+	if (!test_bit_acquire(e->id, map->members))
 		return 0;
 	elem =3D get_const_elem(map->extensions, e->id, dsize);
 	if (e->add_mac && elem->filled =3D=3D MAC_FILLED)
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ips=
et/ip_set_bitmap_port.c
index 7138e080def4..ca875c982424 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -58,7 +58,7 @@ static int
 bitmap_port_do_test(const struct bitmap_port_adt_elem *e,
 		    const struct bitmap_port *map, size_t dsize)
 {
-	return !!test_bit(e->id, map->members);
+	return !!test_bit_acquire(e->id, map->members);
 }
=20
 static int
--=20
2.39.5

