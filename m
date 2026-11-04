Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782965;
	b=RhGh9ktUemiDnP2D0vijlkvuBR8e1AZGSZ2XMpaX5rG0pXbtAuBzSH+yZkaGQDWtJD0x
	 6+0ozmj5zuJjW/R4W+9g3nClhDv2IGa4v8SuDlZPlj8PD/mwPRn8qjbuen+KH8lzUbGe7
	 Rrk0JcxCDPbHfiPf2mXqhg1jrf/2o8YlzkUYv79A4atMMyWVJFKZN7onWb02bxRZZnGcW
	 xnb0zcvtCJdUs1OQcmlLsFjessRYnUY2fBVVAg/EVt0EBBiC+95JjVHbWN8bQTOig0lgn
	 s0Zt7o9M+Kl6/DBfoGR+3dQRVGB9mpRMZG+YUvlerkFd5w7ZFvKkZBE/OZ7O/FMxWLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782965;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=eI6BYAMtH8gnpfLqrP2oq7QPLneAgWxxYSCOTNnXMiM=;
	b=003+vOjbZ/j9OR0afVpoGXGKbaam4fK2peXVTd3Bmb/s+j/6cnx9m0HsMkuvRuh+Ls4a
	 dp+nwx4t06phydFFIgwUpNlUGvm5K/Cec49xzF+Pa27ol/rs6G8TtNOKeS1jOAPgPozXG
	 Qc0c/gbMvpAKMCPVxQkFcdfnLajxBSBBQR62LHsfuLDQNgOpJ748MVfxyyXcA/GkXNLSz
	 01wnpMGR35t0pWGjs6krHShGhnFQZEzHUY82DDTaLmtxrqy/zu8U2O9+qfH7aEVQE2XVc
	 y6uPjIkSmYJZIMr4n1aYXlxK3sq+9PFhxSl7OOw7J5Xl6XkzhXebT/sBr+JEQIK0PvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ugiIdkZR;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9B5606D80D;
	Wed,  4 Nov 2026 09:02:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E9B5606D80D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ugiIdkZR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793782962;
	bh=eI6BYAMtH8gnpfLqrP2oq7QPLneAgWxxYSCOTNnXMiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugiIdkZR9K+w5rpSqRC7jjqOl3zNUractnXms+PfPCgJKE7LByvKoOLXJHMQx3vBU
	 xtLatQW+psjSvjSq6iU5PeU8WwfuOO+UbWfvDF0rwVNYERdIPIPvUrGv5yPDymjsDn
	 ovA9vUGosww/YO6vnuqxc4RZlk/k7rv1g3caQsoF43r2GaZ1wHTG27R4yKZuv995Rk
	 /L0+GOYvkPLzSc4OQbglYTfoVCa28S8VD3GnPRxlEtI2I8uGgTIYWeZr46Z4WYPt+C
	 ZmpGBeciYcf/moY/6jXsxd835SHEcLgdHHFbtAyr4y3tyz6DntoUvwN/b3uiGl9HkG
	 Bi2j4oLmuV9tA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F2B476008D;
	Wed,  4 Nov 2026 10:02:41 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 07/13] netfilter: nft_set_rbtree: check catchall_sync return before queue_done
Date: Wed,  4 Nov 2026 10:02:18 +0100
Message-ID: <20261104090224.750548-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104090224.750548-1-pablo@netfilter.org>
References: <20261104090224.750548-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xingyuan Mo <hdthky0@gmail.com>

nft_rbtree_gc_queue() passes the result of nft_trans_gc_catchall_sync()
straight to nft_trans_gc_queue_sync_done(). When the catchall path flushes
a full GC batch and nft_trans_gc_alloc() fails, catchall_sync returns
NULL and queue_sync_done dereferences trans->net (NULL+0x10). Guard the
call like the pipapo GC path already does.

Fixes: 7d259f021aaa ("netfilter: nft_set_rbtree: prefer sync gc to async worker")
Assisted-by: opencode:deepseek-v4
Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index fbe1750f1ca2..9d685899da70 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -953,7 +953,8 @@ static void nft_rbtree_gc_queue(struct nft_set *set)
 	}
 
 	gc = nft_trans_gc_catchall_sync(gc);
-	nft_trans_gc_queue_sync_done(gc);
+	if (gc)
+		nft_trans_gc_queue_sync_done(gc);
 }
 
 static u64 nft_rbtree_privsize(const struct nlattr * const nla[],
-- 
2.47.3

