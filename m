Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3353B52F8;
	Fri, 24 Jul 2026 10:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890188; cv=none; b=r1k7ynaLohhgPBvAnj5qFuD4i8riJTP2/DqrGp2OZl7IQaZs2OddLEnsImdd8uKqFgIqom+UMi9gonBLZVG90e+SBpB0lKFuaVa3+flN8KkUaazcnBRUD/bu8XkOOwrbjuRrVnEUjoNdlbJjPwfEPgX7T+lL9Z8+CYZC6lStKzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890188; c=relaxed/simple;
	bh=kAi0WmXHrt2WwgGYbecykDZKEmIY6rzZHbntpjlWWcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJVrSeMq6HhU+2h+j+valdeMrAbFhG4s7klbgN6rwM+QYyWNYdi20At7VI0J4EXIVBEm5VSNC5HsHrZUQtqmnekhSemuU6Ywz+zMKHmvblJ+thAXAPWxF7Wgp1ukGP1R8GKWTVKaihvHFB3NpZ3Wz2wssFffzlRrTUsTOC32JFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=X78KpR+H; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="X78KpR+H"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0EFCD601A1;
	Fri, 24 Jul 2026 12:49:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784890184;
	bh=sEtPiDlXa3jUo7zCgYLR762kzgw/OqdbAM0cb77b8Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X78KpR+HhLLc0n0XTJ25yby2IzCcUuxlB+b+DfB02udDF3Cbu6kWjHPQT6rNpnH0y
	 msnw8h0j3d+qvNg6CIgtRfjnEXxvyD+9j0EeQ3Njj+4HNkOmIGDnJ4DbyBTH6qp8ct
	 U/Sn2pNbfmCJcGAASeMiat/BwN0S16K6Ijm7WM/aANQD0++g2K2S3GGgdAY4+q2duP
	 TGLLfCu35zHbMiRRWyjE1twyxyEpzJ9hKAAi3Uvg0jCUAHrxcGyxQWocQ9sOcUIYs5
	 LyRz1575aI9zjnuOBIflAiDHT/74lR0S+TcTqdqwHoQDz1vLC+QHhTb/OFjsZxo9Dr
	 RWcDcGDFNVcoQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 2/7] netfilter: xt_tcpmss: extend checkentry to ipv6
Date: Fri, 24 Jul 2026 12:49:27 +0200
Message-ID: <20260724104932.437729-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724104932.437729-1-pablo@netfilter.org>
References: <20260724104932.437729-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

sashiko reports:
 Is it intentional that the new parameter validation callback is applied
 only to the NFPROTO_IPV4 match?

Fixes: 68fc6c6470d6 ("netfilter: xt_tcpmss: add checkentry for parameter validation")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_tcpmss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index b08b077d7f0a..5f7f97dbace5 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -103,6 +103,7 @@ static struct xt_match tcpmss_mt_reg[] __read_mostly = {
 	{
 		.name		= "tcpmss",
 		.family		= NFPROTO_IPV6,
+		.checkentry	= tcpmss_mt_check,
 		.match		= tcpmss_mt,
 		.matchsize	= sizeof(struct xt_tcpmss_match_info),
 		.proto		= IPPROTO_TCP,
-- 
2.47.3

