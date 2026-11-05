Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882750;
	b=IQCBNwCKbmj4SjqX/AqmZs4EcgULQYrnO3jAM4q0vkzCAQlNyCuG9wWH+zluxJJIo8MO
	 nAExrEUsIW/MCP1UifHeHGYDxbXT5dMdTESz8JTkBuSEcK5zaKvigN9HPsVCzlHcTRAW4
	 f6loSrg9aLQHRP+GlFYussDbd/elOO5TB4wrqqLoxDbMYGycVVlzSXDFCnfEMlUc1v0D4
	 ondBziabsKpdDWMlqabL/RvJ1fOwF3Iwzg6+2YmmTtxuGSgCLxrxIv4yptCmU3xa8FWY+
	 gWejqGEp5KxaovQcK610B2b/Q68UOB81Ica8jphnwJIvEivpVcbsxd/aeSllYu4AjxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882750;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=eI6BYAMtH8gnpfLqrP2oq7QPLneAgWxxYSCOTNnXMiM=;
	b=SIy5AxtEHJwNde9pib6yjX3lBQHttOkzcJSG34KVB51ji6gR5NnmLNqyLADm32mKtp9c
	 sENsAKLxYy12DMiLfkFM/yoaNSj3/D7NLnebeKdIvqDBK6vLAxfOYQqhtg2cDgRBvh82q
	 0no47E8koHrVo9HKXsorDvFete5dLNhMPhWAWBjU1KefyV4E7N+xrb9bLeOKP7hV1tn7g
	 qRVIQwmmsmZFEFtOkskETI64kBTm8XZhQ5yzW1eApdwDnnaItYk696TXEM+yj6zXhvQNA
	 BhVfyhjccdOePYgGGIJCDkXqquXPUfJqoHkAV6bile/V2n1h0G7xJQgzXQXdJxVr6DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=pqNMmMnY;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60F6606D818;
	Thu,  5 Nov 2026 12:45:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D60F6606D818
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=pqNMmMnY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793882748;
	bh=eI6BYAMtH8gnpfLqrP2oq7QPLneAgWxxYSCOTNnXMiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqNMmMnYthEh4FAMGCPJZUyXa44CWnqm25f1gBs6NhoW2vH0SVnY0hDgHi0j5VeRH
	 Ffdpwb7HwFNs4KSWS3fvNWqRQ2ixjGRV2BlkcEXCP9+eBxlEfwv/6rUVevYSB1PEYY
	 YJXGY6PVV6N6pRLjlvbocsuXPxgEePUo4FctiUU218b29wMITez76tBLox6B9tyOmr
	 Q1gIEyi+oaY99duNoEsADPzco3PcYY3wZG2cGtbjEt4SAFgVC2Vn+WZnk3ElvoS2HV
	 aVMwT4eSGUxbGyGa3ScgHUq8cpTNyF8YsZ0+/myMlNFNUx7eIaMdz9LQkWsmdWYhUL
	 6FWPjfjDHFfxw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B0BC960082;
	Thu,  5 Nov 2026 13:45:47 +0100 (CET)
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
Subject: [PATCH net 06/12] netfilter: nft_set_rbtree: check catchall_sync return before queue_done
Date: Thu,  5 Nov 2026 13:45:30 +0100
Message-ID: <20261105124536.1009301-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261105124536.1009301-1-pablo@netfilter.org>
References: <20261105124536.1009301-1-pablo@netfilter.org>
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

