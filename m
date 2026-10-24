Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792872694;
	b=ulcm8M8MTSyVQstZdzi+/DI9DTai0N+oNW+AZpcn+KMhOR99Wh92l5nBzP7+KslBa0TQ
	 GhdZS3zUR47tgrpq8C/1k7b1GJoZNgfDiobn3Lx7PAyZuIBepZtXDJk+j7EuIfK/OvkNv
	 phs6dqZuqw1TBie8gPu7n7en50U81APLT8QPDbWCFiBQ6vWBuD8wQ3gF23ipcUpBwoA6O
	 TQLQ7vgBQoWMOeD4y+7svbMqKCJs656ekBwz4n/39r2gvRYb7V8wpXW19pwCSq0J3n+Ij
	 5fYfeJ0/RzINpn34Rwgnx4FQiYcb4i9xyTRU8wpxOV6CxboI7jF8gPi5+NMGV3/md4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792872694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=UUHhpdqOP21pU4Hew1aiBw9AHcEoaIUvL7VbapiNBV4=;
	b=BhXBPVF3P27yRxbmGEkqO3HDHKSwch7ZsU/QczUjcPeLaXHCjIcEXoIVXgDtHKTsukIa
	 LhvHYhltCHc7PQPiKFhfKKcq78QyUnCQ9Y9IkK9GsML2KoYQ+RzIA7FiWti+84oW7ZUJn
	 nNWn2yUtq9nIpd+1zh/aJm1HRAzzcpFaRkKqn0RJ6C+iGHAGD1kHa5+EtsjI0pZ7YMalf
	 SsROKgVvubScz076uciUOCIEQvZWHPSeHCJ1T/P0VdrC/2NU2eQbfEecI38Ah5Tv4VhzU
	 9AA5gCfdhy123LAYQhOz54O7fYg03CDnabm4XN/l1hAuWNGKBKkNqDWEdOaRFoVCZAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g9gpEIo9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2D7606A330;
	Sat, 24 Oct 2026 20:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g9gpEIo9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A491F01825;
	Sat, 24 Oct 2026 20:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792872694;
	bh=UUHhpdqOP21pU4Hew1aiBw9AHcEoaIUvL7VbapiNBV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g9gpEIo9biH4AgpPKpmWqHASzBfo04iPTtI4zVD9317Sn27VmQPJOspUQnEdThFbM
	 zaV5wCG/Aaah0ef0OvqpE1ng/E0N5jBYXTXyv9BuWnOob4Hrkp1UqAniK2nVu5lIRX
	 qTXLK0QRthE9whzzTaM7obuIiHqQ/vaHPdgZIUssm/Ne9r2C/f0SvB8NgWZsA4HCqb
	 Yq3Q1wBeNXzMjuYj10n6le3PSLszKyo7rTwbg4mprJqGxeoQsR7c36sWxA1GKT64OA
	 Inmzzpwrccjiy0gQ7Q951sMZy789vsd0pKstOWU56EMYSrjQZLDo/k76Bzk+rDOkiB
	 0CfCDmPXVaK5Q==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
Subject: Re: [PATCH 5.15.y] netfilter: nf_tables: unconditionally bump set->nelems before insertion
Date: Sat, 24 Oct 2026 16:11:07 -0400
Message-ID: <2026-10-24-1-daily-reply-0009-nft-set-nelems-5-15-bounce@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261024111425.50052-1-steffen.pfendtner@kernelscan.io>
References: <20261024111425.50052-1-steffen.pfendtner@kernelscan.io>
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

> [ Backport to 5.15.y: 5.15 has no nft_set_maxsize() helper (introduced by
> 8d738c1869f6 "netfilter: nf_tables: fix set size with rbtree backend",
> not in 5.15), so the per-set ceiling is inlined using 5.15's own
> accounting: max = set->size + set->ndeact, and the element is only
> counted when set->size is non-zero (unlimited sets are untracked, as
> before).

This needs the prerequisite d4b7f29eb85c ("netfilter: nf_tables: always
increment set element count") first, as the 6.1 backport has it. Without it
set->nelems can go negative, and the new unsigned nelems > max comparison can
then return a spurious -ENFILE on dynset-bound sets.

It also needs a rebase on the current 5.15 queue: there is a one line
conflict with 66bda7ca3059 ("netfilter: nf_tables: set->ops->insert returns
opaque set element in case of EEXIST").

Could you send a v2 with the prerequisite included?

-- 
Thanks,
Sasha
