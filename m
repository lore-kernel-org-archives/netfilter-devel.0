Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D488E2EF2B5;
	Fri, 25 Jul 2025 17:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463068; cv=none; b=sgMgDkd4SA72kASc63tuDThx0sRPxjbCJWPSsXRmRN9xQ/6asPAyr08HMvS1eWmhjqZ696sgjr789xCcEKw/byA7/UxXxipIKjrMsPSL/9YT0efte2MxLQOS8kr5pmAIaTTSMjrw1sXHp1BJToZ6TEDYzJ7cjVQjkWB8LWiRcR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463068; c=relaxed/simple;
	bh=YrtjrX84KfgvPoByGatJSq6cGQrDDGeydVQhBwuKXU8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ur/9P5l0QrMD0JtAiN1oPTiuWybOYS7IzqlGAmGnhY78cwubk7CkFq3K0Bgh8YFxMv6PPCyChO8351E/ZQd4K4/+7quhWU0IDqtEhtDGX4c7PfUCimUYA72aZjcOMhLppAVp8ho+S+CaaZ1quhjy4sCjoFmrRcDJvf1w2XoBf6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rxLe4/Fm; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UWIPPJf0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rxLe4/Fm";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UWIPPJf0"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 60CA460285; Fri, 25 Jul 2025 19:04:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463065;
	bh=4S0ARwWIUkkblDff655F6VZtGiitOAJw66FoeE/WBwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxLe4/Fmsv6kLfxmggrxGJqKQj0afG9uF2lwBp5Yyy9f88DZgy02qAoJPqeQChKou
	 6rbOirFnumtUn01x5TXbKe56zazfzgoGlD7gkERzcme+gYGxC/H32nx6KrKbcyhDED
	 A2XtnmQ9VhgKzfwXrQce986B9h6vrvQ70Ti2uOxNsETkago/+QivlSUJM6eCNoQrHR
	 3m84yWB7zmK4rI0YqntQLDpwvz7bBpkdXJs1Z6C7THjyB41PaWQWef3Mc1B5qYnXHc
	 RXcug/+CXiYp0DP+05tJNB1qBsgTCwmVniYTTZCdRSP7Mv8MCpH80Pte0N2uIMogKh
	 ME1NVm4xvdIow==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 93FB460279;
	Fri, 25 Jul 2025 19:04:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463057;
	bh=4S0ARwWIUkkblDff655F6VZtGiitOAJw66FoeE/WBwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWIPPJf02HL4cyqTTc56EFTVjHGtXDKRoUoKv3oXaA+bambr1JdONhBVQemyVJbbQ
	 XEHeMqq38OVNJhLK70V0TBRfmsrNFJ29ejVVnCow2CgJVmH48/hNfKbVJZdh0gVDTW
	 /zXThVfHHYGv+QIvHrms9ZrRjfkuemWAEDJ6bxbPKbD32YZLqIcGLrbpqV2RrcYxEt
	 mwKjflBVQsJognF3/2tEkS4LE5Hij3jyJlUFeCSURwTxcwjmIdOt/XefifmW+o2yvy
	 sVgOEDG71LP0aLvi3Vz3F5mJxdRZiqpcoHqNtSQgg2IGVHV8IaQk0Gq11eCY4YDi+R
	 X+GKrOTkR87gw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 16/19] netfilter: nft_set_pipapo: prefer kvmalloc for scratch maps
Date: Fri, 25 Jul 2025 19:03:37 +0200
Message-Id: <20250725170340.21327-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250725170340.21327-1-pablo@netfilter.org>
References: <20250725170340.21327-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

The scratchmap size depends on the number of elements in the set.
For huge sets, each scratch map can easily require very large
allocations, e.g. for 100k entries each scratch map will require
close to 64kbyte of memory.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 28e67c4d7132..1a19649c2851 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1152,7 +1152,7 @@ static void pipapo_free_scratch(const struct nft_pipapo_match *m, unsigned int c
 
 	mem = s;
 	mem -= s->align_off;
-	kfree(mem);
+	kvfree(mem);
 }
 
 /**
@@ -1173,10 +1173,9 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
 		void *scratch_aligned;
 		u32 align_off;
 #endif
-		scratch = kzalloc_node(struct_size(scratch, map,
-						   bsize_max * 2) +
-				       NFT_PIPAPO_ALIGN_HEADROOM,
-				       GFP_KERNEL_ACCOUNT, cpu_to_node(i));
+		scratch = kvzalloc_node(struct_size(scratch, map, bsize_max * 2) +
+					NFT_PIPAPO_ALIGN_HEADROOM,
+					GFP_KERNEL_ACCOUNT, cpu_to_node(i));
 		if (!scratch) {
 			/* On failure, there's no need to undo previous
 			 * allocations: this means that some scratch maps have
-- 
2.30.2

