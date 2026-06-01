Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF19374E46;
	Mon,  1 Jun 2026 11:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780315179; cv=none; b=uw8y02xAfKwktHLHkDuLSgKepe5dRV0/VkwGn6k/rk0CIyaAcWIPz2x8h5rm6Mgmoa2ZnjBzAeJ8/x4oX7La6wHQVIFfHvi9f7leU9yk7LHeIFkBsRPl99SpccEsh8YNdRhvGmjcInv0Fv2N2eIVeOPXXgun1Y32YkMdmoDahpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780315179; c=relaxed/simple;
	bh=BKMKkLa38ObJ3fGH8jYdT53HwZs05a1ZpdPC06WZvbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dW55M+mCzPPKKln5Ukkt0tFmDRhCfSsTLkWpBeAKvCFgFLLwXkko5wrpE+0vG2S2ZTnBr7zYEI9gMKo2qo0lWg66tC+O+CFB53pn+slgg+URNfaB0Ronm8QeSXW3vkyq7xWcaIXFYuyDueoVQ6ZgIPP5UqM2aOgJin2QK+36Luo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Db9AiSIV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Db9AiSIV"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E5970601BF;
	Mon,  1 Jun 2026 13:59:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780315172;
	bh=pJiPgiGPc3fDuqyp3kJk2QiN8nrGOfnOFOPgbzgp4u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Db9AiSIVDPqo+l7fyz3WKHbxeoWDGk6Q1bCcMls0McU2Y5P/u/xoZNECI7ayFP1XB
	 TU7Cub+koUCOpmMw6RkDzT1EbpNUSbODAVhXhRfkajjQbzi5YQJe60QttWZblGD/XI
	 9whRj5n0UwknDm+gcF/iJ+KQ5CyqGIolJmYKQn09haf4LmQJ6AY3gz0YRrwEzJ24vA
	 wo6CyWVJA9BCH2jWHmWSpEwVpypQyjccB5F+arTkoud0xXmAj5Bx9FSE08ADAdtNYT
	 FUWHYRmjezD82muQ5zrvR1oTaS9zPcsiiKYUGRte26A9AlHMEUN5FtnJFZ0sAki2WT
	 b5cer8qdV+BHw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 3/9] netfilter: nft_fib_ipv6: bail out of sibling walk if rt got unlinked
Date: Mon,  1 Jun 2026 13:59:17 +0200
Message-ID: <20260601115923.433946-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260601115923.433946-1-pablo@netfilter.org>
References: <20260601115923.433946-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiayuan Chen <jiayuan.chen@linux.dev>

This was reported by Sashiko [1].

The RCU walk over rt->fib6_siblings can spin forever if rt is unlinked
mid-iteration: rt->fib6_siblings.next still points into the old ring,
so the loop never meets &rt->fib6_siblings as its terminator.

fib6_purge_rt() always does WRITE_ONCE(rt->fib6_nsiblings, 0) before
list_del_rcu(), so readers can use rt->fib6_nsiblings == 0 as the
detach signal. The same pattern is used in fib6_info_uses_dev() and
rt6_nlmsg_size().

[1]: https://sashiko.dev/#/patchset/20260520023411.391233-1-jiayuan.chen%40linux.dev
Suggested-by: Florian Westphal <fw@strlen.de>
Fixes: 1c32b24c234b ("netfilter: nft_fib_ipv6: switch to fib6_lookup")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/nft_fib_ipv6.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index c0a0075e2590..2dbe44715df3 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -191,6 +191,9 @@ static bool nft_fib6_info_nh_uses_dev(struct fib6_info *rt,
 
 		if (nft_fib6_info_nh_dev_match(nh_dev, dev))
 			return true;
+
+		if (!READ_ONCE(rt->fib6_nsiblings))
+			return false;
 	}
 
 	return false;
-- 
2.47.3

