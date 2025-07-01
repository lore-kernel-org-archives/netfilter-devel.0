Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695992FE386
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Jul 2025 22:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751407994; cv=none; b=HUUbzkcwjKInjtYVno8b5E5Jk3gT+eoyqZBh7isV8OVpemVG+7yLuUSCHd4/z8ddnYyENvsDNqZWT5MPHk+8viB7kTtWdm5uTbZFmf/7tWSDjpTYmE9/LofgYOMnvIZwNP48AMTrKfoLDZJ1Ektt06i/F14i94Zi89dZ0gvbK3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751407994; c=relaxed/simple;
	bh=ca7olJKc4iUI0sQbRtQFYJsIhhzpUxFtv+R3WC8+APg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmBJVnSEH182SfqHiK0Z+mNaXUZLxw5wWBqvRW8FJqqEC2ivMjjto8cs+oeKCHleI157PNTB2YDLNZ61GcEE/ahodQjd29jibIirYWN1HnH5no1tODVbDFxnp8tzSEPzizG/hd+SNsw857s+qGkAxx6kY1cyvvZDXlT1AFyQ+ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=GrAiWpca; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=8kfEbQrv; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="GrAiWpca";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="8kfEbQrv"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1751407991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=neeUz8O0dj6mJCB5bHmEmL2RnIN3mBM+S0JOpNX4fGU=;
	b=GrAiWpca98oo2VveSzMfpA+n+0JQM9ConMyrTPwkO9aasWO9tuFU2X1GY60sQfJX/Yzm7K
	mnn0LF9f00zAuA1cwceRkVD+mmSBXzyJcq+9IuGGsJzDlo5lIx9hpiWnqbgCDB7PY7hMZz
	GbIJSG3pKCJrbJVyeR5Njbez6qgG2lTD+R73ayrd8pDy9NkRr2gUkzWootODBY9M0nR1+o
	6+zuG8RFiNqg2NjE8RHiyBtgHVAIw87oVX07TTUvKDFMPRgYSkWPzKUoY4mP+Tf4pj9oh8
	GW778OL5KZQZao6i76HLPieVZsfhnI+YH6LIKpTA1JjahDI596o99XM/po4OUQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1751407991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=neeUz8O0dj6mJCB5bHmEmL2RnIN3mBM+S0JOpNX4fGU=;
	b=8kfEbQrv8fzYKJ2MUGLykQqfHR3vaeYCbY22pT1va2biPIfDrhtdS+LJi87YRVODiD5eWx
	U7ZNttweIRt1scAA==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH nf-next 3/3] netfilter: nft_set_pipapo: Use nested-BH locking for nft_pipapo_scratch
Date: Wed,  2 Jul 2025 00:13:04 +0200
Message-ID: <20250701221304.3846333-4-bigeasy@linutronix.de>
In-Reply-To: <20250701221304.3846333-1-bigeasy@linutronix.de>
References: <20250701221304.3846333-1-bigeasy@linutronix.de>
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
index 8b71a4630aa86..35edaed4170db 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -428,6 +428,7 @@ bool nft_pipapo_lookup(const struct net *net, const str=
uct nft_set *set,
 		goto out;
=20
 	scratch =3D *raw_cpu_ptr(m->scratch);
+	__local_lock_nested_bh(&scratch->bh_lock);
=20
 	map_index =3D scratch->map_index;
=20
@@ -464,6 +465,7 @@ bool nft_pipapo_lookup(const struct net *net, const str=
uct nft_set *set,
 				  last);
 		if (b < 0) {
 			scratch->map_index =3D map_index;
+			__local_unlock_nested_bh(&scratch->bh_lock);
 			local_bh_enable();
=20
 			return false;
@@ -481,6 +483,7 @@ bool nft_pipapo_lookup(const struct net *net, const str=
uct nft_set *set,
 			 * *next* bitmap (not initial) for the next packet.
 			 */
 			scratch->map_index =3D map_index;
+			__local_unlock_nested_bh(&scratch->bh_lock);
 			local_bh_enable();
=20
 			return true;
@@ -496,6 +499,7 @@ bool nft_pipapo_lookup(const struct net *net, const str=
uct nft_set *set,
 		rp +=3D NFT_PIPAPO_GROUPS_PADDING(f);
 	}
=20
+	__local_unlock_nested_bh(&scratch->bh_lock);
 out:
 	local_bh_enable();
 	return false;
@@ -1249,6 +1253,7 @@ static int pipapo_realloc_scratch(struct nft_pipapo_m=
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
index daf23a996e612..69af6eaf8a630 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1169,20 +1169,18 @@ bool nft_pipapo_avx2_lookup(const struct net *net, =
const struct nft_set *set,
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
-		return false;
-	}
-
 	map_index =3D scratch->map_index;
 	map =3D NFT_PIPAPO_LT_ALIGN(&scratch->__map[0]);
 	res  =3D map + (map_index ? m->bsize_max : 0);
@@ -1260,6 +1258,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, co=
nst struct nft_set *set,
 	if (i % 2)
 		scratch->map_index =3D !map_index;
 	kernel_fpu_end();
+	__local_unlock_nested_bh(&scratch->bh_lock);
 	local_bh_enable();
=20
 	return ret >=3D 0;
--=20
2.50.0

