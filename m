Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715AF2765E6
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 11:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755514941; cv=none; b=JJkdKSwopkGarvYQlQUat6aJxIp7zS1IvuAx/93ZYwFGy8+kEwncwb1z4id57PlgUM9GsO0Nvsa41BKGpAA1PnbPxZAs+a2ovh6UjCIUhBrGLagLTyvghOMZUz6vS9pUfXaHx3IGN/lrsac23h+dVHXNQyIc2G1ivl6BIdpOpng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755514941; c=relaxed/simple;
	bh=5UA3b8NBfZBqdneIyRPewYTo/RHw0HOzdU8VFJq8OF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s54tYkLSCVdRVYwbfrumPMoLsCf9SVnB4jA6lwiT6f7MmbAmHNCgNGZ8s3WkIBvlgndRA5Nl2qWmGkgvglzc758GMURxi0bmldJTeJkwYaRoTxzByaIiThK4pZPR/tzySgpfE9MMxpFnTxAMVAeHxyhMO6pBisHfwT8fUgWJup8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=0KEReYfb; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=axKc2cft; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="0KEReYfb";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="axKc2cft"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1755514937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uhZeEzrq6qOCRGlpOw8HyLUMa+Cbt1wucJZ4tGWRfDk=;
	b=0KEReYfbsuB/fNBdx4Tmy8w2F0nuU2W44gBg+1LvpH5qTh8dusiDOkZSOycHanUIpI1IIF
	/4ymjmCnerf7ZZT5tO3OOg91ZTa/XmIC60YD3CTFLONbch8dIGUSCRufshd7cT3iw54FE9
	+s1KJtZbDa3dp2z6wMpk3DiiY59QlL9jKdpleWDM/zhoYhMQS8bkgaoO9dgbsxmycHa7Bb
	nxQxDr3NhvWBD+YR1E7qrXWlBlR+HXSc/1bvt4l+Rdb7mquOkrcIUKnRvspc5Wk032pCsJ
	7cC8R1Rdw1QctVWoCQ57ZHVRwzFRuBdFdkbJAf/LT15+P6Diuv1I0rlBRPEunw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1755514937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uhZeEzrq6qOCRGlpOw8HyLUMa+Cbt1wucJZ4tGWRfDk=;
	b=axKc2cft2fRJq65qLthodLjI+wxUJ48aqyy0sARbW8dBJRz2kUa1Tl/y3vu23OCvaZEqmG
	e2svnaxatB0jD0DQ==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH nft-testing v3 2/2] netfilter: nft_set_pipapo: Use nested-BH locking for nft_pipapo_scratch
Date: Mon, 18 Aug 2025 13:02:13 +0200
Message-ID: <20250818110213.1319982-3-bigeasy@linutronix.de>
In-Reply-To: <20250818110213.1319982-1-bigeasy@linutronix.de>
References: <20250818110213.1319982-1-bigeasy@linutronix.de>
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
 net/netfilter/nft_set_pipapo.c      | 5 +++++
 net/netfilter/nft_set_pipapo.h      | 1 +
 net/netfilter/nft_set_pipapo_avx2.c | 4 ++++
 3 files changed, 10 insertions(+)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 1a1ba0b47696e..e7c28b009b9a7 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -429,6 +429,7 @@ static struct nft_pipapo_elem *pipapo_get_slow(const st=
ruct nft_pipapo_match *m,
 	scratch =3D *raw_cpu_ptr(m->scratch);
 	if (unlikely(!scratch))
 		goto out;
+	__local_lock_nested_bh(&scratch->bh_lock);
=20
 	map_index =3D scratch->map_index;
=20
@@ -465,6 +466,7 @@ static struct nft_pipapo_elem *pipapo_get_slow(const st=
ruct nft_pipapo_match *m,
 				  last);
 		if (b < 0) {
 			scratch->map_index =3D map_index;
+			__local_unlock_nested_bh(&scratch->bh_lock);
 			local_bh_enable();
=20
 			return NULL;
@@ -484,6 +486,7 @@ static struct nft_pipapo_elem *pipapo_get_slow(const st=
ruct nft_pipapo_match *m,
 			 * *next* bitmap (not initial) for the next packet.
 			 */
 			scratch->map_index =3D map_index;
+			__local_unlock_nested_bh(&scratch->bh_lock);
 			local_bh_enable();
 			return e;
 		}
@@ -498,6 +501,7 @@ static struct nft_pipapo_elem *pipapo_get_slow(const st=
ruct nft_pipapo_match *m,
 		data +=3D NFT_PIPAPO_GROUPS_PADDING(f);
 	}
=20
+	__local_unlock_nested_bh(&scratch->bh_lock);
 out:
 	local_bh_enable();
 	return NULL;
@@ -1215,6 +1219,7 @@ static int pipapo_realloc_scratch(struct nft_pipapo_m=
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
index 951868a904a25..8270a95c8ca27 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1163,6 +1163,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct =
nft_pipapo_match *m,
 	if (unlikely(!scratch))
 		return NULL;
=20
+	__local_lock_nested_bh(&scratch->bh_lock);
 	map_index =3D scratch->map_index;
 	map =3D NFT_PIPAPO_LT_ALIGN(&scratch->__map[0]);
 	res  =3D map + (map_index ? m->bsize_max : 0);
@@ -1228,6 +1229,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct =
nft_pipapo_match *m,
 		if (ret < 0) {
 			scratch->map_index =3D map_index;
 			kernel_fpu_end();
+			__local_unlock_nested_bh(&scratch->bh_lock);
 			return NULL;
 		}
=20
@@ -1241,6 +1243,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct =
nft_pipapo_match *m,
=20
 			scratch->map_index =3D map_index;
 			kernel_fpu_end();
+			__local_unlock_nested_bh(&scratch->bh_lock);
 			return e;
 		}
=20
@@ -1250,6 +1253,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct =
nft_pipapo_match *m,
 	}
=20
 	kernel_fpu_end();
+	__local_unlock_nested_bh(&scratch->bh_lock);
 	return NULL;
 }
=20
--=20
2.50.1

