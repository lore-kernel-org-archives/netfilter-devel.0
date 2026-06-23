Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069353B95E3;
	Tue, 23 Jun 2026 22:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782252971; cv=none; b=JOJ6a7KFVKx0YOycWtljRU2CYeWd8fYb0NseJY+P+oj6XkkqP0haqmFImixmYwEN0AWgD0np9Jto4g3IIdib3vq6V1wnSi3e5zfgGr2EHIMP6aPb16icon2bkYIJ7EoRqE/tbkD4u+N4kqzcRynaFzKmXBCmfQLxXEO1AdkZ8rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782252971; c=relaxed/simple;
	bh=gcJ7r0Rk+emwSkMoID38ls+8+FMwhKsvBCZII3jWDcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DODb/92OGztvWW534jZ8fthR7l4RsG8b3cTgd+GmmF6XiH7FTnLiaNrByTaVfQCqUrOSFpnluTehIMMNS52WBL/jYa70Kk9BYlvwPBT5ISj6jkNq8zvvk/DViyFLEMhfB509iAWJ7hY1cdKiNuF2q/G3xCAyJdsIK+VOW8497Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZqjEbLX4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZqjEbLX4"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 17CF960586;
	Wed, 24 Jun 2026 00:16:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782252968;
	bh=3dBrP8MaA39eTKZ2h9cyivMwFirS08+AfOlg0FkjNvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqjEbLX4HIJiPraFsPPbvemHhtAV4C7M8eU5bl1rEJjCe5DwD+q195HcXrRglh/5Z
	 gy/noVdyWQaOu+t/4Mr5rrkdFxWYpAkG9L7iayHDj4K678UUtL/hWiM+cdHheSTN2r
	 HWDaQK7gzWItLbUBn8i/kx/+FuiFv3C4oH2ROtQXX/qqx57GJ2RuRxQwV86C6oRuxa
	 Az8y7Z//TCnwVs5t5jla0DUkNYcIeCoCtC5gfEOdR/3e3YIIsjyoef2uMz3NrvYyEs
	 98RTCn5CWfkXzYLPKwhWbUKm885riF2LImBh7ujA+vvJ49HldIE0hsn02yn8Ll7hxD
	 1p7yKts8hE3UA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 12/14] netfilter: nf_conntrack_expect: run expectation eviction with no helper
Date: Wed, 24 Jun 2026 00:15:45 +0200
Message-ID: <20260623221548.701545-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623221548.701545-1-pablo@netfilter.org>
References: <20260623221548.701545-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Run expectation eviction if no helper is specified to deal with the
nft_ct expectation support.

Cap the maximum expectation limit per master conntrack to
NF_CT_EXPECT_MAX_CNT (255).

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_expect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 9454913e1b33..113bb1cb1683 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -499,6 +499,13 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
 		if (p->max_expected &&
 		    master_help->expecting[expect->class] >= p->max_expected)
 			evict_oldest_expect(master_help, expect, p);
+	} else {
+		const struct nf_conntrack_expect_policy default_exp_policy = {
+			.max_expected = NF_CT_EXPECT_MAX_CNT,
+		};
+
+		if (master_help->expecting[expect->class] >= default_exp_policy.max_expected)
+			evict_oldest_expect(master_help, expect, &default_exp_policy);
 	}
 
 	cnet = nf_ct_pernet(net);
-- 
2.47.3

