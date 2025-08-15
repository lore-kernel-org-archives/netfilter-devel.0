Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20712308F15
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Aug 2025 16:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755274185; cv=none; b=e1TrT6IFgCZoCk9ZNyvNlfSXVnE6m8ySQG/B/DMYvkLbR20kJR+CsrDMpUrXAKLj7Bz1J1rX84/tTlu2n7ZsMSjbHVHJdCZAdA8zXklkcL7Dj1vv/NOONSBWLib7Kh2m1wp+Ll01XHvT4iF6Oo6C/HW8q98lnWXuTHSRHwomVns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755274185; c=relaxed/simple;
	bh=pwtBEeHqd924/NuPLvuVltGiFvXPzu6n8S0udJxQqXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xviil6nPrcgBSkKEWGD1slkiJU+9HvLJOdWH4Er3S9+VxZZB+QLta4UdjrYJys9ko50NLruf5o3qCWgPpLs11hAh6Cz7tEEcFe1Zw00OJ0cBPJqNQNaKrWwdd2IydIYKGKzDFAWe6KzD9Kd5L4571jtPTgSYw7CzHFkpIvnFZGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=x8gIlWwe; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=7mwYlMRY; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="x8gIlWwe";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="7mwYlMRY"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1755274182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GSw+OZ9jkdIj93Nqzp4ES3mjWSJZm2SGmCTVE2fP/eg=;
	b=x8gIlWweqDQeoTDZWEbl8xFn/vBvGIELl5x4G4hphO2NQRdw2s7Q05BCGQaWTlVkxM0wdh
	9Bt3VOlGN/xZpkoS/FxAmYgpEGJfUiSAOhlzEaVx0OKux6ezNeaU+uQPg16t2o9rOtVXpA
	k6AlO44RbhHu0uU+ZeYTBuVf1B0Fa8ec2/258vm1LEaio8niCOaYePGDJlEyzQleqb0fqk
	O6vI/yWz9bFtJyJyIvgPtyZOf/Xlm9WPa/Yv2pvdx6FJUZxr7zwJdfcNTu8rSTlCy0ZR1p
	oYd2sqoqTfTcFMfsrKgM+eyE9SVqpqVMWjZumhbOJbJT9Yp+q2XRmBJ6dpAwjA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1755274182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GSw+OZ9jkdIj93Nqzp4ES3mjWSJZm2SGmCTVE2fP/eg=;
	b=7mwYlMRY+3FTQsIa0xocye1Bg9d9Xdq9atcBUW6fJTC+MHJj30moxtrOaTKr1LJBex4JyF
	AUpP73QJnMLqPtCQ==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH nf-next v2 2/3] netfilter: nft_set_pipapo_avx2: Drop the comment regarding protection
Date: Fri, 15 Aug 2025 18:09:36 +0200
Message-ID: <20250815160937.1192748-3-bigeasy@linutronix.de>
In-Reply-To: <20250815160937.1192748-1-bigeasy@linutronix.de>
References: <20250815160937.1192748-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The comment claims that the kernel_fpu_begin_mask() below protects
access to the scratch map. This is not true because the access is only
protected by local_bh_disable() above.

Remove the misleading comment.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/netfilter/nft_set_pipapo_avx2.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pi=
papo_avx2.c
index ed1594c6aeeee..e907e48b474b6 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1171,9 +1171,7 @@ nft_pipapo_avx2_lookup(const struct net *net, const s=
truct nft_set *set,
=20
 	m =3D rcu_dereference(priv->match);
=20
-	/* This also protects access to all data related to scratch maps.
-	 *
-	 * Note that we don't need a valid MXCSR state for any of the
+	/* Note that we don't need a valid MXCSR state for any of the
 	 * operations we use here, so pass 0 as mask and spare a LDMXCSR
 	 * instruction.
 	 */
--=20
2.50.1

