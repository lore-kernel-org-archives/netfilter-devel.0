Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629172765C4
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 11:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755514940; cv=none; b=PbYq8oCWXLI7smIQbx9bj0Ewc0Y3quX/Qb2axnNvRfN4sR5ivkc6YunP9Jm5i3A5haNkK50VeRF/qZ79LrGLpqWGLrnUE2jflgDwzRd4K80PLqtTv8fmj5hdSH5LmGVr6tJSXVSrbRdfBbD6YP4tNbGHaTfGZTgU5ZHdyZDiOHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755514940; c=relaxed/simple;
	bh=NhqX7kq7EHdqPg0QMoqxHKq4dvNwf+xo4ZpIYKHkyVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEVOKbiXHA+/A5NAAo5D+3sr2UWLDtiJjSi2pYqTgUO35K7BYLpz9zNNAhWU1SOTLocyMuPeaChnEm8FJZhLJ29os9+rANLRPMdNxmxJ52JGI7etS/opaSlytHtpPtPGAtIMJl+9UFBOrrIJA5KYWFtjeW4MeYtpiwROTotTy8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=StHlSBI2; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=viCm3laH; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="StHlSBI2";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="viCm3laH"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1755514937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QACceNJ33DbSTXtO0ygCmjIrEznRf/pYwB6JFuxkBKA=;
	b=StHlSBI2HLaFjLrnCVTF6k9L9VCLSud0dZOpsA1eqJvt1GuHpu41y2F2oui6/29h0/Kd2A
	jYVgN38byzWlD+f7pffMmDhfCSDo9R9NJxah2B1YNN2WuQxvAC3v7e8sxsMrKwV+J3KWNn
	cT9OMcqlbDW4R5VQK8zTT94uWImAxeo0OZCMJ7F5M6aMqMD8Rzni0HW8D68t6+HMqZ5t6i
	A0n7XxHirJ8/J/OO5mXFlosRBvu0JbShWZLf9ti9aqNx3U+ago4JvXzqvs8q7fOvCz7sMh
	wfNBYGC4jtH52uJgG/OiNa1stp6nqX85X8VZULjYsACFx9/nEV+CkmpuqJQZKQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1755514937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QACceNJ33DbSTXtO0ygCmjIrEznRf/pYwB6JFuxkBKA=;
	b=viCm3laHPqv1vfPsb3FILgf0r7mn6oUPMLuz1BaI/e4cFKkMeeCXHYknlgghdCrf2H1EDN
	B0FCAphSRYblJ5Bg==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH nft-testing v3 1/2] netfilter: nft_set_pipapo*: Move FPU handling to pipapo_get_avx2()
Date: Mon, 18 Aug 2025 13:02:12 +0200
Message-ID: <20250818110213.1319982-2-bigeasy@linutronix.de>
In-Reply-To: <20250818110213.1319982-1-bigeasy@linutronix.de>
References: <20250818110213.1319982-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Move kernel_fpu_begin_mask()/ _end() to pipapo_get_avx2() where it is
required.
This is a preparation for adding local_lock_t to struct
nft_pipapo_scratch in order to protect the __map pointer. The lock can
not be acquired in preemption disabled context which is what
kernel_fpu_begin*() does.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/netfilter/nft_set_pipapo.c      |  2 --
 net/netfilter/nft_set_pipapo_avx2.c | 15 +++++++++------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 515eb64bff9f8..1a1ba0b47696e 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -528,9 +528,7 @@ static struct nft_pipapo_elem *pipapo_get(const struct =
nft_pipapo_match *m,
 #if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
 	if (boot_cpu_has(X86_FEATURE_AVX2) && boot_cpu_has(X86_FEATURE_AVX) &&
 	    irq_fpu_usable()) {
-		kernel_fpu_begin_mask(0);
 		e =3D pipapo_get_avx2(m, data, genmask, tstamp);
-		kernel_fpu_end();
 		local_bh_enable();
 		return e;
 	}
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pi=
papo_avx2.c
index a584ffff73769..951868a904a25 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1170,6 +1170,12 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct=
 nft_pipapo_match *m,
=20
 	pipapo_resmap_init_avx2(m, res);
=20
+	/* Note that we don't need a valid MXCSR state for any of the
+	 * operations we use here, so pass 0 as mask and spare a LDMXCSR
+	 * instruction.
+	 */
+	kernel_fpu_begin_mask(0);
+
 	nft_pipapo_avx2_prepare();
=20
 next_match:
@@ -1221,6 +1227,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct =
nft_pipapo_match *m,
=20
 		if (ret < 0) {
 			scratch->map_index =3D map_index;
+			kernel_fpu_end();
 			return NULL;
 		}
=20
@@ -1233,6 +1240,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct =
nft_pipapo_match *m,
 				goto next_match;
=20
 			scratch->map_index =3D map_index;
+			kernel_fpu_end();
 			return e;
 		}
=20
@@ -1241,6 +1249,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(const struct =
nft_pipapo_match *m,
 		data +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
 	}
=20
+	kernel_fpu_end();
 	return NULL;
 }
=20
@@ -1280,13 +1289,7 @@ nft_pipapo_avx2_lookup(const struct net *net, const =
struct nft_set *set,
=20
 	m =3D rcu_dereference(priv->match);
=20
-	/* Note that we don't need a valid MXCSR state for any of the
-	 * operations we use here, so pass 0 as mask and spare a LDMXCSR
-	 * instruction.
-	 */
-	kernel_fpu_begin_mask(0);
 	e =3D pipapo_get_avx2(m, rp, genmask, get_jiffies_64());
-	kernel_fpu_end();
 	local_bh_enable();
=20
 	return e ? &e->ext : NULL;
--=20
2.50.1

