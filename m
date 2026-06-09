Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE201A2545
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2026 07:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780990498; cv=none; b=ZwFWJ8iYcYgAPBTDN2FPuxpgLDv1cZvf0hTRcVxS7YYlA4mEKhwMHJUa2Pf+n5gpdRKjvr6cZiy1lUPPGXd2EnJwQGFG5hqw0EtG8WC2nR4IKmF9/PlPnqBxuWOSVa5oV12RJYWmV4Oq3uQLuGxu3YsbfgkSKlWkKlurKsKn2p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780990498; c=relaxed/simple;
	bh=XZSqf3JSL8bO+O7STsQIImUXBOu/REfRXkMlpGsns9g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QcJ1oUXLp2J6NZeoMmdOvBPxaGbEhumqWfkPo7tBv4CmwjjTtUw8ubRKLkxdpvMUGJNbWmYHHc4+wbGQGF2crsUaFmuAGqDH/tfFIaD/BK4lPvoh8WvERwvs5RlHhKREWAsyUkrttI61MnGjZXYzBJBqf8pDWXC4tEr5NvXgShM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=izYCs48y; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="izYCs48y"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4gZL94666VzGFDCV;
	Tue, 09 Jun 2026 09:27:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1780990070; x=1782804471; bh=LOl9W7E1f5
	vzC/mTlt+TAK+M04Z8DAwQGO09WmPE0WI=; b=izYCs48y02mOVYxDesb6zhfO8O
	5sku5k2QAGLHl270hkvJhWyP3Lac0KFKhGKWuTL03oLdDtjBgFYCd0/+bws45cXY
	GKAIVpYeSuMwitcQBYphN+JEf/EHHm1q3IUVPQbgRNJqBdQ8rqWbc6f7IyIm1pT8
	ESTdhY59r9+mxF2MU=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id ZvlZZoH3-Pf2; Tue,  9 Jun 2026 09:27:50 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (254C0692.nat.pool.telekom.hu [37.76.6.146])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4gZL925PPTzGFDCW;
	Tue, 09 Jun 2026 09:27:50 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 46C9B140535; Tue,  9 Jun 2026 09:27:50 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v2 2/9] netfilter: ipset: Don't use test_bit() in lockless RCU readers in bitmap types
Date: Tue,  9 Jun 2026 09:27:43 +0200
Message-Id: <20260609072750.318774-3-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260609072750.318774-1-kadlec@netfilter.org>
References: <20260609072750.318774-1-kadlec@netfilter.org>
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
 net/netfilter/ipset/ip_set_bitmap_gen.h   | 6 ++++--
 net/netfilter/ipset/ip_set_bitmap_ip.c    | 6 +++---
 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 6 +++---
 net/netfilter/ipset/ip_set_bitmap_port.c  | 6 +++---
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipse=
t/ip_set_bitmap_gen.h
index 798c7993635e..3b333c85565f 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -51,7 +51,7 @@ mtype_ext_cleanup(struct ip_set *set)
 	u32 id;
=20
 	for (id =3D 0; id < map->elements; id++)
-		if (test_bit(id, map->members))
+		if (test_bit_acquire(id, map->members))
 			ip_set_ext_destroy(set, get_ext(set, map, id));
 }
=20
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
index 5988b9bb9029..73135e4ebe72 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -67,20 +67,20 @@ static int
 bitmap_ip_do_test(const struct bitmap_ip_adt_elem *e,
 		  struct bitmap_ip *map, size_t dsize)
 {
-	return !!test_bit(e->id, map->members);
+	return !!test_bit_acquire(e->id, map->members);
 }
=20
 static int
 bitmap_ip_gc_test(u16 id, const struct bitmap_ip *map, size_t dsize)
 {
-	return !!test_bit(id, map->members);
+	return !!test_bit_acquire(id, map->members);
 }
=20
 static int
 bitmap_ip_do_add(const struct bitmap_ip_adt_elem *e, struct bitmap_ip *m=
ap,
 		 u32 flags, size_t dsize)
 {
-	return !!test_bit(e->id, map->members);
+	return !!test_bit_acquire(e->id, map->members);
 }
=20
 static int
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ip=
set/ip_set_bitmap_ipmac.c
index 752f59ef8744..6813e2e0dd71 100644
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
@@ -100,7 +100,7 @@ bitmap_ipmac_gc_test(u16 id, const struct bitmap_ipma=
c *map, size_t dsize)
 {
 	const struct bitmap_ipmac_elem *elem;
=20
-	if (!test_bit(id, map->members))
+	if (!test_bit_acquire(id, map->members))
 		return 0;
 	elem =3D get_const_elem(map->extensions, id, dsize);
 	/* Timer not started for the incomplete elements */
@@ -147,7 +147,7 @@ bitmap_ipmac_do_add(const struct bitmap_ipmac_adt_ele=
m *e,
 	struct bitmap_ipmac_elem *elem;
=20
 	elem =3D get_elem(map->extensions, e->id, dsize);
-	if (test_bit(e->id, map->members)) {
+	if (test_bit_acquire(e->id, map->members)) {
 		if (elem->filled =3D=3D MAC_FILLED) {
 			if (e->add_mac &&
 			    (flags & IPSET_FLAG_EXIST) &&
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ips=
et/ip_set_bitmap_port.c
index 7138e080def4..a7131d8dd03e 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -58,20 +58,20 @@ static int
 bitmap_port_do_test(const struct bitmap_port_adt_elem *e,
 		    const struct bitmap_port *map, size_t dsize)
 {
-	return !!test_bit(e->id, map->members);
+	return !!test_bit_acquire(e->id, map->members);
 }
=20
 static int
 bitmap_port_gc_test(u16 id, const struct bitmap_port *map, size_t dsize)
 {
-	return !!test_bit(id, map->members);
+	return !!test_bit_acquire(id, map->members);
 }
=20
 static int
 bitmap_port_do_add(const struct bitmap_port_adt_elem *e,
 		   struct bitmap_port *map, u32 flags, size_t dsize)
 {
-	return !!test_bit(e->id, map->members);
+	return !!test_bit_acquire(e->id, map->members);
 }
=20
 static int
--=20
2.39.5

