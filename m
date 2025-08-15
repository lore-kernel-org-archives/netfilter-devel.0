Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C2D308F2A
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Aug 2025 16:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755274186; cv=none; b=H8IelTw3wLCSdoAE0aYg+UZRk6VSq7uZmSmnE+jY6IYD450cje5Z2DOUu5T41xwfF/8y9rVPRIH+K4/F8ecxhlD90qbNNMmGMP3d5NV6RmD9iCh5jqZPD7RyQSefO+hwk+CaA9tGIXJLSWfUCVLdzDVMPLmjRBwrWXn61Ie0YDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755274186; c=relaxed/simple;
	bh=SYxsvgQKRJNCAlt3xvgyM9sWozjmjgnvgEFukVTsf+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQWY2x3h0nsGIgCfZACdc8NFLVu8FXVE6uB+YSLGg7K9Lr/1iMUSSV2ykuPlbTg7iT0Qcl/QnsdFM4ojn6W5Hyo+wkXmGNMmyfMFOGaLIl+0Fnr3TN5LC7KOEy5qUkeJ2fJzMyPLbudezL7GIh5DPvzrivVZCEqYv0Itbv1XQjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=nOrFSyUG; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=FA+GlXuU; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="nOrFSyUG";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="FA+GlXuU"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1755274182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qUwWUqPGNdRBx+6OsrFSSgnnfwOtSwgGOUf448nWiFs=;
	b=nOrFSyUGz96pAeiqEPD78cCjBCf3fz7aOyeSPwsDta5QAXjp+HYNIQvsZEkF1YvhicKJYv
	+SHYX89eTM8VvGyUIzsRl7IuFMHQuYBXzyOVIgYnWNLvROjia/Q6gLFxI88g7HWiWT4Uyd
	xIH2mLz51WmAODtTqN5uKAoG75RacoYUxot8X7IzAQ+q415aI/P3/Ev3MklLavJYMTK0Ni
	l7zICD3n7hLR7iGFqS+QDp5/1echV71WZj4Wf8LHZJr3QGX9GbNx5W+BVDOt2KW0n94vA9
	oFxtUPrHwKZ8B4BnvwDG89WyXNPI+IfDj0yZDiD0pa1D7+BJ95OCmj7eLtPT5A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1755274182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qUwWUqPGNdRBx+6OsrFSSgnnfwOtSwgGOUf448nWiFs=;
	b=FA+GlXuUqGTr3o1mExmWlca+dfTgJ5oOolBAFt1ctExQpvZJ+5fY1D8MXCEQEFLd80cvKL
	ACCoMXkZrYdcxHCQ==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH nf-next v2 3/3] netfilter: nft_set_pipapo: Use nested-BH locking for nft_pipapo_scratch
Date: Fri, 15 Aug 2025 18:09:37 +0200
Message-ID: <20250815160937.1192748-4-bigeasy@linutronix.de>
In-Reply-To: <20250815160937.1192748-1-bigeasy@linutronix.de>
References: <20250815160937.1192748-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

nft_pipapo_scratch is a per-CPU variable and relies on disabled BH for
its locking. Without per-CPU locking in local_bh_disable() on PREEMPT_RT
this data structure requires explicit locking.

Add a local_lock_t to the data structure and use local_lock_nested_bh() for
locking. This change adds only lockdep coverage and does not alter the
functional behaviour for !PREEMPT_RT.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/netfilter/nft_set_pipapo.c      |  5 +++++
 net/netfilter/nft_set_pipapo.h      |  1 +
 net/netfilter/nft_set_pipapo_avx2.c | 15 +++++++--------
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 364b9abcce13b..5220a050c5025 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -429,6 +429,7 @@ static struct nft_pipapo_elem *pipapo_get(const struct =
nft_pipapo_match *m,
 	scratch =3D *raw_cpu_ptr(m->scratch);
 	if (unlikely(!scratch))
 		goto out;
+	__local_lock_nested_bh(&scratch->bh_lock);
=20
 	map_index =3D scratch->map_index;
=20
@@ -465,6 +466,7 @@ static struct nft_pipapo_elem *pipapo_get(const struct =
nft_pipapo_match *m,
 				  last);
 		if (b < 0) {
 			scratch->map_index =3D map_index;
+			__local_unlock_nested_bh(&scratch->bh_lock);
 			local_bh_enable();
=20
 			return NULL;
@@ -484,6 +486,7 @@ static struct nft_pipapo_elem *pipapo_get(const struct =
nft_pipapo_match *m,
 			 * *next* bitmap (not initial) for the next packet.
 			 */
 			scratch->map_index =3D map_index;
+			__local_unlock_nested_bh(&scratch->bh_lock);
 			local_bh_enable();
 			return e;
 		}
@@ -498,6 +501,7 @@ static struct nft_pipapo_elem *pipapo_get(const struct =
nft_pipapo_match *m,
 		data +=3D NFT_PIPAPO_GROUPS_PADDING(f);
 	}
=20
+	__local_unlock_nested_bh(&scratch->bh_lock);
 out:
 	local_bh_enable();
 	return NULL;
@@ -1180,6 +1184,7 @@ static int pipapo_realloc_scratch(struct nft_pipapo_m=
atch *clone,
 		}
=20
 		pipapo_free_scratch(clone, i);
+		local_lock_init(&scratch->bh_lock);
 		*per_cpu_ptr(clone->scratch, i) =3D scratch;
 	}
=20
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index 3655aa41fa949..4d9addea854c4 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -129,6 +129,7 @@ struct nft_pipapo_field {
  * @__map:	store partial matching results during lookup
  */
 struct nft_pipapo_scratch {
+	local_lock_t bh_lock;
 	u8 map_index;
 	unsigned long __map[];
 };
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pi=
papo_avx2.c
index e907e48b474b6..4515aa0a49984 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1170,20 +1170,18 @@ nft_pipapo_avx2_lookup(const struct net *net, const=
 struct nft_set *set,
 	}
=20
 	m =3D rcu_dereference(priv->match);
-
+	scratch =3D *raw_cpu_ptr(m->scratch);
+	if (unlikely(!scratch)) {
+		local_bh_enable();
+		return false;
+	}
+	__local_lock_nested_bh(&scratch->bh_lock);
 	/* Note that we don't need a valid MXCSR state for any of the
 	 * operations we use here, so pass 0 as mask and spare a LDMXCSR
 	 * instruction.
 	 */
 	kernel_fpu_begin_mask(0);
=20
-	scratch =3D *raw_cpu_ptr(m->scratch);
-	if (unlikely(!scratch)) {
-		kernel_fpu_end();
-		local_bh_enable();
-		return NULL;
-	}
-
 	map_index =3D scratch->map_index;
 	map =3D NFT_PIPAPO_LT_ALIGN(&scratch->__map[0]);
 	res  =3D map + (map_index ? m->bsize_max : 0);
@@ -1262,6 +1260,7 @@ nft_pipapo_avx2_lookup(const struct net *net, const s=
truct nft_set *set,
 	if (i % 2)
 		scratch->map_index =3D !map_index;
 	kernel_fpu_end();
+	__local_unlock_nested_bh(&scratch->bh_lock);
 	local_bh_enable();
=20
 	return ext;
--=20
2.50.1

