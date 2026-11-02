Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793581040;
	b=t/cWcUYHMD9MrAx+j072yFZzjPbq/RcFzGwMBG7BCk22TamkQaSEK3MyNBXiJNYUFtA1
	 Ig32zGFpjKtnE8m5eJiCM1PEClWZSt6Ub6pJ3CbUgO7AxfoWmbE7hhdhVorOZqw1m5OQb
	 wEZjDPcO84mU6kXpJBduiHQALZfKxqUL86nGdoP/0WwtD3dc/eBxpv3YKM0zyu2Kfoc/+
	 WCb4ZcNCtEFKg4pGx+icAvIKQZSHjCglRWO7tqv18uUR9MVkmtL+0D4VeaM21B3s1jmeK
	 LOJ0VORnBJt1LdRTiRFzV0ExDYB/2F/ne43loKpnm9LcojSjG8nfFjd4nSIarPj0iig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793581040;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=eI6BYAMtH8gnpfLqrP2oq7QPLneAgWxxYSCOTNnXMiM=;
	b=Qsgf/LgC5AVqtH5HEfntwQQhUyDy9FyAK+iB3lxIAwcMAWZKU5dD3BERQsZR1UPYKysH
	 3QNel6LkmrEnzrSdu1a/X80JsZ3lhM+sNKyV2tqSTNM7PEg7ILHN5vTiVPzE818uoM9p0
	 QPDCbVYwwMRNyFCACazXnMfFXxZ7xqa7w3ej56MVTkdMxSZ1b+Cb9ps6SBix8TIx05I9p
	 5ZvFk6j+UCn4YODqcdTKvyfXqP8w9vDhHQ4ULRalbS3TSIiUDTjL83hVPsicOQ8xfXgHT
	 mRHyObPUh2GbJFgcHlevV8QsOiSqXKmD7gW030QMZsuYmkzpNn/+Chau1pftr7WdBtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=OszmStZL;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337C760A2617;
	Mon,  2 Nov 2026 00:57:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 337C760A2617
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=OszmStZL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793581038;
	bh=eI6BYAMtH8gnpfLqrP2oq7QPLneAgWxxYSCOTNnXMiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OszmStZLi3eINtv6doc+ivC20sRsk4JWGO1t7l0jQXN8qQ+vtzg69T+L1zsHm1j/d
	 Svzciav4w6/trye5oOpDEFD3kTVQ6OVYuXixowNKE6mPPaEJY8vUXsrQiqh/WALrrD
	 xWbf96sxzZ/f5kNrgTZE9/p8ZpVgp3rBzwtygd2NUDCPUd4BJFwtEk9ipE/ModOjV6
	 yIuO9nrttv0NLTzF6NxW6lSDL8RBGPDpg6YRrwn43I5c/9bmFOvvTUe/8WodR5H4uF
	 6Y2KxYYQDs8W0WSSWZPNQyW3Bn/8QUgFwAcPaoiBohEsVEanPFMUA1FWy3RVRsyqx/
	 A9u3Ixqh5N7lg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F0D0F6005D;
	Mon,  2 Nov 2026 01:57:17 +0100 (CET)
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
Subject: [PATCH net 09/15] netfilter: nft_set_rbtree: check catchall_sync return before queue_done
Date: Mon,  2 Nov 2026 01:56:48 +0100
Message-ID: <20261102005654.532438-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102005654.532438-1-pablo@netfilter.org>
References: <20261102005654.532438-1-pablo@netfilter.org>
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

