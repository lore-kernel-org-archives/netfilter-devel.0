Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAD7301486;
	Sat, 15 Aug 2026 20:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786827535; cv=none; b=bjL7Hg4oS5kGnO9AxQuO+WwU4Cgr6Z1y8Pz1dmzR/GJABCf70ST/E1HsbXgZxNA0SU8rZaLtZ8nklBsMy6IBgmng5fQ9GsNm91JiQb10Y1pvQjvb/yiRa7eRVwpst9ahM+kUAefqicWAwF0YHEjpOQaDKN61mAq6xN6K+vAn2zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786827535; c=relaxed/simple;
	bh=a+UVB2Bnwm4stP7asM1cIn9KPbJM+1njaSHZyHYZz08=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LInKcXym/K2p/JGTUDY5SuHNVERsm3mvsh5BgVEKwC8+kW5bF6ZqMqO7DkELzNapbGL1EkWJjB/lQibxfMMb5fRLqWs7DcZPlIcwMvzhleJYAKW27c2gwxRmTzeyGYVaZkPaSYT3WO7MvN7urt8xlBUzWlEbIdB4Uys7xZbsfXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hvTBwZqI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hvTBwZqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB431F00A3D;
	Sat, 15 Aug 2026 20:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786827533;
	bh=jTPLTySzhTKI3LvXFGQsh5a1kRSEhMypXn99Vw/XsUE=;
	h=From:To:Cc:Subject:Date;
	b=hvTBwZqIcKqUtC+yadUTvUkbB9Rk9Gg+EJrmdHg12mGSRYraqOcSJKKOEq/4y0r8U
	 NnWyiAStFP4n3lxBdzC329bXrWwSff1Sqpr3D7zyGNccYF4BP2+knIhmOHJzv7/K1t
	 zzJnLvdGvvCpj+uTi0nEoKqjPnfNmqFQRpjQko0T5JjgivtYMKXgOvIqPjLgAFny1X
	 //V/Es1hOklYRtvTwvwAX9HhYkWgjIAJw249XdvmqDFRTsiSI8MgTajhtjPAtE9Sd1
	 yL858FNAk4A+XGae3miEIPuIcseWQzL87d9NsVEBlpXsHHCBBHc3tG5B/zH9ugH8pi
	 z/gKTY9fP8OBA==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Taehee Yoo <ap420073@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/6] x86: add missing vzeroupper instructions
Date: Sat, 15 Aug 2026 13:57:44 -0700
Message-ID: <20260815205750.169336-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Assembly code using YMM or ZMM registers is supposed to end with the
vzeroupper instruction in order to avoid degrading the performance of
any later SSE code.  Since this only affects performance and not
correctness, it is sometimes overlooked.  Most kernel code does it
correctly, but a few cases were missed.  This series fixes them.

It should be easiest to take the full series through the x86 tree.

Eric Biggers (6):
  xor: add missing vzeroupper to AVX code
  raid6: add missing vzeroupper to AVX2 code
  raid6: add missing vzeroupper to AVX-512 code
  crypto: x86/aria - add missing vzeroupper in AVX2 code
  crypto: x86/aria - add missing vzeroupper in AVX-512 code
  netfilter: nft_set_pipapo_avx2: add missing vzeroupper

 arch/x86/crypto/aria-aesni-avx2-asm_64.S  |  6 ++++++
 arch/x86/crypto/aria-gfni-avx512-asm_64.S |  3 +++
 lib/raid/raid6/x86/avx2.c                 |  6 ++++++
 lib/raid/raid6/x86/avx512.c               |  6 ++++++
 lib/raid/raid6/x86/recov_avx2.c           |  2 ++
 lib/raid/raid6/x86/recov_avx512.c         |  2 ++
 lib/raid/xor/x86/xor-avx.c                |  1 +
 net/netfilter/nft_set_pipapo_avx2.c       | 17 ++++++++---------
 8 files changed, 34 insertions(+), 9 deletions(-)


base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
-- 
2.55.0

