Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F55292921;
	Fri, 23 May 2025 13:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006870; cv=none; b=NloArmkmnQsYUPk9renk/54Tg1dtvA12oi27wdO10BQF+zlql24/GrgFUXXp9mSJXUyJrJle+Ci8lqI4UaAlbpy8ALxvXn+yu4ySVSCh+YtfxLZHESdujo7o94vOarxer5G8eArqmKBYnWsT/uCg0zYbg02VZx0cWXxFs1GkJTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006870; c=relaxed/simple;
	bh=pTQVKRvH/7Bw9fY8C3IZ2t3Rk2Fgp4azhsVQPnvUNZg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IkFI507aHvtrjH7lJdUDEt/H2HjMkyv1/Voexs9EtrfTeYprPCRTrczBNc/v6ed1XU4UkFSx/QuO5U8bzVKAw73Cky4NCkNPM9iIGP7y41q5rX2ELyy10Eh1+jVYHNeoI0pX+DI0kYgb2dvWNqPKbuz7BJSSj5xoVtj/yWoZPgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=apOD6QAe; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=P271TYm3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="apOD6QAe";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="P271TYm3"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B7B9960779; Fri, 23 May 2025 15:27:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006867;
	bh=aakCYKDbeqNzohCmZk1RknJKRIgHtzmU4dFCNXNNmDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apOD6QAes5ghw0RdGZOXsyShgzp7TcFw6Kc3/peJydmPBR0wDCcbNGFhDvZXYgZn9
	 +oLJmwpoyD/maco81iallaKblLNiEmfP+LMmtnRAXzCmSAOyy6UTKO/pcyIW628txI
	 lz7fqT4r2gBsGaQFiPhFvo59Arc5jA2jJ5O3pII8+1eKyZU0MMvDVWvkD0BDvGpKKV
	 P2cRodA/M6fjACdbVQpbPHM18YmYRle/nIMfHatPUk/g1QRdu6WFgKDo4DFs5utZDC
	 HZhOXS7nOaIR+wQe5wRQ32Lu7lfUZj7csu9HRVfKtYgCzckleFgLT0M21wnBrw+S/U
	 fBAoUYFqdn0dw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8682A60770;
	Fri, 23 May 2025 15:27:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006846;
	bh=aakCYKDbeqNzohCmZk1RknJKRIgHtzmU4dFCNXNNmDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P271TYm3Wqe/DnXi5V1UTVHTjyHKlaaC9TD0tEkQdzVnZ5IelKC2biPVyXHQexWGj
	 DwjcLaXae1OLuKEVy0NBtQmhFOHPHj6zQeOI8rDeg/2i/HBff1JCMCYhnzzQEKpdoi
	 U0iR5bI/13OT8mXnbm5uwus6twrFKTV5BlyrUIQFgVZyIIWoDQTiBXJ7VFHmAgQuJa
	 E1neVMMovV1JD8+LSrYy1wBrR6fhb6o6wA/GbwSBIU1pmlVp5EmDZ1+m7AR049Z1AF
	 gJQkL8V8efJRXCQUvbA3qQhh+SeTBrX/YM8rAzJSfAisxHUAnG1bSuNjmHf+ucTpJa
	 UG77mTj4DulSg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 10/26] netfilter: nft_inner: Use nested-BH locking for nft_pcpu_tun_ctx
Date: Fri, 23 May 2025 15:26:56 +0200
Message-Id: <20250523132712.458507-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250523132712.458507-1-pablo@netfilter.org>
References: <20250523132712.458507-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

nft_pcpu_tun_ctx is a per-CPU variable and relies on disabled BH for its
locking. Without per-CPU locking in local_bh_disable() on PREEMPT_RT
this data structure requires explicit locking.

Make a struct with a nft_inner_tun_ctx member (original
nft_pcpu_tun_ctx) and a local_lock_t and use local_lock_nested_bh() for
locking. This change adds only lockdep coverage and does not alter the
functional behaviour for !PREEMPT_RT.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_inner.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index 817ab978d24a..c4569d4b9228 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -23,7 +23,14 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 
-static DEFINE_PER_CPU(struct nft_inner_tun_ctx, nft_pcpu_tun_ctx);
+struct nft_inner_tun_ctx_locked {
+	struct nft_inner_tun_ctx ctx;
+	local_lock_t bh_lock;
+};
+
+static DEFINE_PER_CPU(struct nft_inner_tun_ctx_locked, nft_pcpu_tun_ctx) = {
+	.bh_lock = INIT_LOCAL_LOCK(bh_lock),
+};
 
 /* Same layout as nft_expr but it embeds the private expression data area. */
 struct __nft_expr {
@@ -237,12 +244,15 @@ static bool nft_inner_restore_tun_ctx(const struct nft_pktinfo *pkt,
 	struct nft_inner_tun_ctx *this_cpu_tun_ctx;
 
 	local_bh_disable();
-	this_cpu_tun_ctx = this_cpu_ptr(&nft_pcpu_tun_ctx);
+	local_lock_nested_bh(&nft_pcpu_tun_ctx.bh_lock);
+	this_cpu_tun_ctx = this_cpu_ptr(&nft_pcpu_tun_ctx.ctx);
 	if (this_cpu_tun_ctx->cookie != (unsigned long)pkt->skb) {
 		local_bh_enable();
+		local_unlock_nested_bh(&nft_pcpu_tun_ctx.bh_lock);
 		return false;
 	}
 	*tun_ctx = *this_cpu_tun_ctx;
+	local_unlock_nested_bh(&nft_pcpu_tun_ctx.bh_lock);
 	local_bh_enable();
 
 	return true;
@@ -254,9 +264,11 @@ static void nft_inner_save_tun_ctx(const struct nft_pktinfo *pkt,
 	struct nft_inner_tun_ctx *this_cpu_tun_ctx;
 
 	local_bh_disable();
-	this_cpu_tun_ctx = this_cpu_ptr(&nft_pcpu_tun_ctx);
+	local_lock_nested_bh(&nft_pcpu_tun_ctx.bh_lock);
+	this_cpu_tun_ctx = this_cpu_ptr(&nft_pcpu_tun_ctx.ctx);
 	if (this_cpu_tun_ctx->cookie != tun_ctx->cookie)
 		*this_cpu_tun_ctx = *tun_ctx;
+	local_unlock_nested_bh(&nft_pcpu_tun_ctx.bh_lock);
 	local_bh_enable();
 }
 
-- 
2.30.2

