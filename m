Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4A0284679;
	Mon, 14 Apr 2025 16:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744646896; cv=none; b=Ss5hY8LS6n80TnyUE4H6dPQC6lVBIrC5SAL9rB6ryXTUuYIO4elc1wi2r8+JlE76fMaenj+Ta/4DL+NtG+CSZWKs6crS2v5Q4TYgkvRzYJclc2Cr0CujlpDjUbUxBpEpyzNkeErTlG1prfIbnT/TN1EXAVWJnCPKoIlNnxK5GVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744646896; c=relaxed/simple;
	bh=Uk33jFZKOfaMLGhcGn8nbFMZJr4Y+ka3dnevkCrTwvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGSR4Bug2/b6lMvRKksKN1WMOwaL43x9RILm/UjDANLaVRAyYNZgjEcCbwj+njbGDyFLIkLU2nnB1CiCufn35nEiIXdjzuOKfCVoDri2AoAFmoi6Gbcdawpkn4L/WJN7ONWVJlf77KiMZ2QsWKyiQxeRBDAvEsaHGyjx4CNv5bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=J67oUugk; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=2jYsGbD+; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="J67oUugk";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="2jYsGbD+"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1744646890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jIoZaVO5iMo/IzztrbNw0WYdjKIA8wg/j9DCE9fgn3Q=;
	b=J67oUugkU98RVhdwvk3ONFIVoGOpSB5LHHUwW0oBABNyH0TLJLknQ6cjvh8joKIaxm9y0O
	KhsK7rDo1KKkAvZMSjFrZnPuLzOQ9G1GJFJe7ZFVOKekrNly/qgzLmX8iVUKY2B5opsYxs
	cWmP2d1IcKlWCLj08GxDLSIljIW4wAHhHlW/LpD1wHc4YM9OTtq8CCTZlxM3Uv+05IdsTC
	skgKTJgm2ncuKmZL4f/n+xROAnEAZxfhc3cGZITXtd+g+4shUi0+6rFwcr4bOlBi3CL17i
	2InUcvRthYNZR4frhZCfSRjDucHQxKpfdIzhxipyCuhgZJkuJ7d44N7lTjycGA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1744646890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jIoZaVO5iMo/IzztrbNw0WYdjKIA8wg/j9DCE9fgn3Q=;
	b=2jYsGbD+3tobYgZvtOhcSmBWA5YnOGzP65WYlq3Z/wGCH19+tPM1AqR1BPDTDZn8Xpj7lc
	zWMYHSOGzGBYTDAg==
To: netdev@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH net-next v2 07/18] netfilter: nft_inner: Use nested-BH locking for nft_pcpu_tun_ctx
Date: Mon, 14 Apr 2025 18:07:43 +0200
Message-ID: <20250414160754.503321-8-bigeasy@linutronix.de>
In-Reply-To: <20250414160754.503321-1-bigeasy@linutronix.de>
References: <20250414160754.503321-1-bigeasy@linutronix.de>
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

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
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

