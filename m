Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9962B255F31;
	Mon, 17 Nov 2025 21:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763415658; cv=none; b=Nkp+uyA8B3kxC8RuV9H0xsIH1dcxCgcRpI9f8HdKzKZE9oYnvaLz1rwefrgGooqB3BnOQnd/7JB5h0pmCI1nA37uYgy0n9BfiK7EGjy57Y4robBZISt+nz/gO8pRct1Gw/h5Ci965NiHLI0RdfzzXtNGgPx7PLOnfsoLTKm3LjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763415658; c=relaxed/simple;
	bh=6AVP6/waYBCSTk3eM287PleDofD4ie7z+SyLM+INe5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERHU49ptWfL9vm7KoWQBADIr5YHVWYvWug5g//xaiugTTdA7YvKSCI7LvrBoSwWdDrmpqDRZPtmgQQ/TJKJJFE7AIbEnEf+PK6Pi+ENjs8VSF0wvkCz+ZgNn8jFopaRz35KId3rzmfb95WFQ8Bf81bmuSHUCWunm8YgVPUqYoRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=U4owAwzB; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="U4owAwzB"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CED5E6027E;
	Mon, 17 Nov 2025 22:40:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763415655;
	bh=buGRw0thpo1INGuPHZSd/Mn4rfmS50BZCj2ylYCYOQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4owAwzBoef+0+eku42VMAEnnuF0J1UVyXPTbSEyuSRC2F3KPDM9kGnXm3XUISR2V
	 2La0GaygmrqH1a3JgwQcWf6Co8BjTrHfSkyeL99p2jnyfZERsiy4rploNwwE7ZeHgt
	 6y37HwJPkWxWZv8+b/YroOu3CIEITSSdQdS4oeaplw92547JHPYFQMX/HhRE3uGGnz
	 ehmhsKZ94pSCOavPJ1uRxDy2VnpG/g+sYr4gemojn1XTVxFK3PQA/MGe/4xs6/6K6F
	 PQekaTUWdlQhE8lX22FLgxHjFWiDoIhlU7Y4cmZbXQWY087heqWw1MdW7gPzXSUXb2
	 FoV9cgCp+uNtg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.10 1/1] netfilter: nft_socket: fix sk refcount leaks
Date: Mon, 17 Nov 2025 21:40:47 +0000
Message-ID: <20251117214047.858985-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117214047.858985-1-pablo@netfilter.org>
References: <20251117214047.858985-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

commit 8b26ff7af8c32cb4148b3e147c52f9e4c695209c upstream.

We must put 'sk' reference before returning.

Fixes: 039b1f4f24ec ("netfilter: nft_socket: fix erroneous socket assignment")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Backport patch posted by Denis Arefev.

 net/netfilter/nft_socket.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 826e5f8c78f3..07e73e50b713 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -88,13 +88,13 @@ static void nft_socket_eval(const struct nft_expr *expr,
 			*dest = sk->sk_mark;
 		} else {
 			regs->verdict.code = NFT_BREAK;
-			return;
+			goto out_put_sk;
 		}
 		break;
 	case NFT_SOCKET_WILDCARD:
 		if (!sk_fullsock(sk)) {
 			regs->verdict.code = NFT_BREAK;
-			return;
+			goto out_put_sk;
 		}
 		nft_socket_wildcard(pkt, regs, sk, dest);
 		break;
@@ -103,6 +103,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		regs->verdict.code = NFT_BREAK;
 	}
 
+out_put_sk:
 	if (sk != skb->sk)
 		sock_gen_put(sk);
 }
-- 
2.30.2

