Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2F427A12C;
	Thu,  7 Aug 2025 11:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754566217; cv=none; b=OoV5mGetK7siwIjFzGcskwjyFR1vmS5Rl7lRNMS5mRSYAZWrV3DRj0TDkQ+wsPJhNBBuSP61ys45u/EF2BnfPt2M0sG23+quU3SiPpkqPBDiKALu9lsPxjlv2mW7+/NPb5UkP9ZZ7BJFUgbzYrxE4oKnbwyJ14f4VJDQoe0xeVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754566217; c=relaxed/simple;
	bh=HiKN0LMjp2PPUhpEntKvn1DLnRdEi1xzFC6x44bGtNI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WDnzgOrQU/gR5+0NyU/PXHPG/yp063NtU1PeqY7CfbPLe1AzX62bHkX5FCZIA3cfJoXZTtiveKNENOeAdrJQliIJGiaTY59ZNIdIYLlmhvgYFv0dePDfwKrZTRM0csBf7Y3H6WmHs4zFuhwBVNy1Ok0ICDe0pSVECHxTHWvCruo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=npCosgNQ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NzFXlKD7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="npCosgNQ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NzFXlKD7"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6218D609AB; Thu,  7 Aug 2025 13:30:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754566209;
	bh=07e7m6xstUrSU7QmKK0GvteE/JvL+LVL5NlQ4h1VMKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=npCosgNQXnPnkEM73LBZ7FqqBj8URxaAPRz6etCBtLVuYHLmyvCtVOsN14cOYGBI+
	 7PY26zQAvUJb147MKw76A6dbCttcBKF1aL1t/jenHgKNY7gFCQQD7vL1pPHNM6xK+x
	 1eRshm22yTasy2GVDHNBXuv1Da0Kzq7LuRbA1ub31q9bID54/EExb/Z3o+3FBOf96O
	 4dencL+YBI+gPB1deEIoInMTWaH2l/gt/afgulNnwdSeFwElSrwCGZwL7sO5iLP4gs
	 MzleRpGCCK+B9RiUc06PC2qhbUBjCH3CCYgc9KZFw117xpDvBFBr+F2NA4pkY2BH72
	 fmIQ9VJD7dHnQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 46D62607F4;
	Thu,  7 Aug 2025 13:29:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754566199;
	bh=07e7m6xstUrSU7QmKK0GvteE/JvL+LVL5NlQ4h1VMKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NzFXlKD7sqItpjxQvMJhwaBtlSCgIHuW7fNcs2C7/YsGeJPq+ssDgpSdoheI5eLaf
	 5ysjAOWtcSymKEUQuyphlamEb7AsZNz9A82UA9zDxjhA8cXkPp7jhbC1WqFzSPcEZ9
	 vEQia9Ll/B5wyCG6/D7hiIw/PXFuj2wk7Jthp92PCpEqh6CTrCxiL9koBf9rsC/ZB3
	 2x+IaStT+eC/hmKtGAzOrsvlHk4joxnEljONiFEar9xhI6oZLnTsgwsA5NZKqh5FuA
	 Wojmg4JGJwvMZmZheVaDfIz0KJiGhPV/D3bIPzHxoMF2wyk6Ey/YgLPaLKPHG/2A+K
	 ppSXQX4CRsS/w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 7/7] netfilter: nft_socket: remove WARN_ON_ONCE with huge level value
Date: Thu,  7 Aug 2025 13:29:48 +0200
Message-Id: <20250807112948.1400523-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250807112948.1400523-1-pablo@netfilter.org>
References: <20250807112948.1400523-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot managed to reach this WARN_ON_ONCE by passing a huge level
value, remove it.

  WARNING: CPU: 0 PID: 5853 at net/netfilter/nft_socket.c:220 nft_socket_init+0x2f4/0x3d0 net/netfilter/nft_socket.c:220

Reported-by: syzbot+a225fea35d7baf8dbdc3@syzkaller.appspotmail.com
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 35d0409b0095..36affbb697c2 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -217,7 +217,7 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 
 		level += err;
 		/* Implies a giant cgroup tree */
-		if (WARN_ON_ONCE(level > 255))
+		if (level > 255)
 			return -EOPNOTSUPP;
 
 		priv->level = level;
-- 
2.30.2

