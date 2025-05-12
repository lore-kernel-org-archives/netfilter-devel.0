Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CCD26563B
	for <netfilter-devel@vger.kernel.org>; Mon, 12 May 2025 10:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747045734; cv=none; b=gh/AtFvbp6rfHbbCptXu4q27JBUbtq42w4/5hTlr7rOUTfNBkbM5zu6NGYm467kLLpYVUNfN9nxigTv4TAAsYSJQn9+re6e4Zkk+2iEcwjs97sYYdrGFT/7nOAuGsFM0o532uA5ZgYCRc5pUhEvZH5TGQP/yWfeVgxZlsTyMlEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747045734; c=relaxed/simple;
	bh=bU8PGrfMt2/AvvfI91EXRw4wb+9qdvP/jQcT4r8LERg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYawiRLexqfVR5XuUm/yxeIjH5rcwdme4OkpQdBg8DXzD3VEd0IxL3alSCnlWLBzR2QcR6yvh0txabpEBQIjje3Dp7uYhbj87ZDFxKpp53jDocQyPSwm47Hvnk0krhbogcUSkA6IEiHq7fg+MhHpgcgkMo/6h287DJSGM5bTdZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=mgshkFao; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=YiMiOK/k; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="mgshkFao";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="YiMiOK/k"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1747045731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DH6SP4n+2JcZbMs/WSD72cvGg+5OZ5qCHCr76oBEkB8=;
	b=mgshkFaoakbXk+arswv2hZRaKZwAlf7S/K5+A67gHB2710HK3gtho+6dSNhw/zGe8380yk
	cz2S0sMkoqzckEW1LD5vyLQyQIcOVS3tkdxh8C97ccGuLEf6LQw6p0eS8g5Y678B/Um1Qz
	dUg8ZXpzKW3T/tZql6LlA/EaJAwaNbz6msJx9DFE4+f7LpTZX5mUq7HCF0DkgLcMcHKYK0
	DNBq3bq7frYKHAA7qm+APhxY1eHLw6iV/tm4tQCY8jPRTR+4fhthFujahQx1UEWwZYnnt+
	lpsbDPEqbee/Fw6QN31AXZMS3zUKumRC1c+nIV541Ndqc4ZYTP9IkITTdK87qw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1747045731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DH6SP4n+2JcZbMs/WSD72cvGg+5OZ5qCHCr76oBEkB8=;
	b=YiMiOK/keGpxhC36KO5wWgjROtnfkhjy1ycZk/f7l67gj5qFPfu7L8hjaw6RmU1mVjkwhE
	++EKahcTr+Ieu8Aw==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH nf-next v1 2/3] netfilter: nft_inner: Use nested-BH locking for nft_pcpu_tun_ctx
Date: Mon, 12 May 2025 12:28:45 +0200
Message-ID: <20250512102846.234111-3-bigeasy@linutronix.de>
In-Reply-To: <20250512102846.234111-1-bigeasy@linutronix.de>
References: <20250512102846.234111-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

nft_pcpu_tun_ctx is a per-CPU variable and relies on disabled BH for its
locking. Without per-CPU locking in local_bh_disable() on PREEMPT_RT
this data structure requires explicit locking.

Make a struct with a nft_inner_tun_ctx member (original
nft_pcpu_tun_ctx) and a local_lock_t and use local_lock_nested_bh() for
locking. This change adds only lockdep coverage and does not alter the
functional behaviour for !PREEMPT_RT.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/netfilter/nft_inner.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index 817ab978d24a1..c4569d4b92285 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -23,7 +23,14 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
=20
-static DEFINE_PER_CPU(struct nft_inner_tun_ctx, nft_pcpu_tun_ctx);
+struct nft_inner_tun_ctx_locked {
+	struct nft_inner_tun_ctx ctx;
+	local_lock_t bh_lock;
+};
+
+static DEFINE_PER_CPU(struct nft_inner_tun_ctx_locked, nft_pcpu_tun_ctx) =
=3D {
+	.bh_lock =3D INIT_LOCAL_LOCK(bh_lock),
+};
=20
 /* Same layout as nft_expr but it embeds the private expression data area.=
 */
 struct __nft_expr {
@@ -237,12 +244,15 @@ static bool nft_inner_restore_tun_ctx(const struct nf=
t_pktinfo *pkt,
 	struct nft_inner_tun_ctx *this_cpu_tun_ctx;
=20
 	local_bh_disable();
-	this_cpu_tun_ctx =3D this_cpu_ptr(&nft_pcpu_tun_ctx);
+	local_lock_nested_bh(&nft_pcpu_tun_ctx.bh_lock);
+	this_cpu_tun_ctx =3D this_cpu_ptr(&nft_pcpu_tun_ctx.ctx);
 	if (this_cpu_tun_ctx->cookie !=3D (unsigned long)pkt->skb) {
 		local_bh_enable();
+		local_unlock_nested_bh(&nft_pcpu_tun_ctx.bh_lock);
 		return false;
 	}
 	*tun_ctx =3D *this_cpu_tun_ctx;
+	local_unlock_nested_bh(&nft_pcpu_tun_ctx.bh_lock);
 	local_bh_enable();
=20
 	return true;
@@ -254,9 +264,11 @@ static void nft_inner_save_tun_ctx(const struct nft_pk=
tinfo *pkt,
 	struct nft_inner_tun_ctx *this_cpu_tun_ctx;
=20
 	local_bh_disable();
-	this_cpu_tun_ctx =3D this_cpu_ptr(&nft_pcpu_tun_ctx);
+	local_lock_nested_bh(&nft_pcpu_tun_ctx.bh_lock);
+	this_cpu_tun_ctx =3D this_cpu_ptr(&nft_pcpu_tun_ctx.ctx);
 	if (this_cpu_tun_ctx->cookie !=3D tun_ctx->cookie)
 		*this_cpu_tun_ctx =3D *tun_ctx;
+	local_unlock_nested_bh(&nft_pcpu_tun_ctx.bh_lock);
 	local_bh_enable();
 }
=20
--=20
2.49.0

