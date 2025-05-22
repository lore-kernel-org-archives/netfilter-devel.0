Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C99429B761;
	Thu, 22 May 2025 16:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932794; cv=none; b=cFT4G6PN+ZyfNHUK/HPNpfdr6suXXAZmkQjF114XTaIZ/Wrntg6DRja+rm4ZyupqX/heYKvvK2sk1M/n8w4Nm+NfpptkwDBE4oN8o9LlxRukD8loX9SOTy/vSLHfJ21fprr4dXKMNODd9hpAh8pUW72KuOU9CqkIRfkW/MHlJrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932794; c=relaxed/simple;
	bh=pTQVKRvH/7Bw9fY8C3IZ2t3Rk2Fgp4azhsVQPnvUNZg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Pc8HhKYm7O3Qw811OaRopk6V0eILrfZvMvGyp8O5FmujaXOJ4Ty2WTVu5/+F9q1w1m5U+XXogDxsxQQGn0+83me8jVZaKz35TXAludIfr94rq/BUfBIo4DVjRdrce8d+FZSczVlTDWktLeLmXBrnW8Lpgu9qXI6vseHdpQRfaxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ueJ5sqrg; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=F09TwkNO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ueJ5sqrg";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="F09TwkNO"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C388F60741; Thu, 22 May 2025 18:53:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932791;
	bh=aakCYKDbeqNzohCmZk1RknJKRIgHtzmU4dFCNXNNmDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ueJ5sqrggRqPRWJgzO12A3OYBZQ0U+pSMA/FXPu+Xx6gL3wigJNde1l8MxI3AH4Qk
	 q7dT8JayueOumJ9wUF/8RWs90L7BiKgGHCSDrJwi2aDpMlyPiWwS0IYLJ3V8wVosRP
	 clFSxRelZr4IxtybC++32zWu8qQ6Uxlj5XpJynKFu6NjgqNF575k/3DyCH9rWtDjhq
	 iQCfnbIge44JvUUV/ZKWUkWtoh4EJEtYwiujJlIerVIuN4Ou7gMYO7+17lFr3WT40S
	 PmHPpvAlJSN6lIzTnYYYEK23K6d83Sv+hitPuUAnrs3hnpyBwbW4WUodZPmh5gHGuo
	 X005h4rkW66RQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 50C7F6072B;
	Thu, 22 May 2025 18:52:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932773;
	bh=aakCYKDbeqNzohCmZk1RknJKRIgHtzmU4dFCNXNNmDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F09TwkNO6UbA27Q0t96+KgFWjqwWbmAbAE8aK8iWIvx+7t38H9GKkcwhe/QpVMqjH
	 7andGq8qbzjBF9AKaoJ8Q8faXM2YgMO1jlx3LGm9VC0BzPA5ci3XlnnJ9HxS7sqCkZ
	 Fsnp6nBpeoEM8oX0Ke+uTPlIcHUuIRaoJeL3r3+dZY6lhN4zJgsjaTzIukrN64vkIG
	 n/UEVOmjd5b+xkz7kXzIOZerwRIsnUYtZf1rEVvsuL+qhRruhH47e04kkm0P1bpnxA
	 AwdnAQ+LtZwsz4f33nuOSZgLsDq59YIbH+QzP8OSeViQS8hO4p0yM8FGOh1ZBN3rI6
	 9GECdtF0cgvfw==
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
Date: Thu, 22 May 2025 18:52:22 +0200
Message-Id: <20250522165238.378456-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250522165238.378456-1-pablo@netfilter.org>
References: <20250522165238.378456-1-pablo@netfilter.org>
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

