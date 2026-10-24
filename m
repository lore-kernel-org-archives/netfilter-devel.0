Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792872705;
	b=JSwlJF1sCGcz9HBZQdhILgFfX3aQzqQygpLNvpL65nQLylblt9Ae5HUb6KcEoEakOSGY
	 e3Zi+bgO4ninxg7QqKydCjDbbmdjcA5gRt+3fnTTAkPaGPYJZJcgZFG6prFgYYLPbxaVA
	 rhFqeF3tViHXOvELK6MZOmFt0eEANFEfQWWpi02cgvvsRat/aTrNWr3pBdksgMXYVszkR
	 1eUgVZvB9b7C0kOhXJsB3LGXH/CTOtNto4ih7k8Af74duIEeYRjWrajS71Ngdonsme//g
	 J01FutOjbvGQqDm7n20eQtqFGRgW4Xr8p0fUTe3JX4kfvyYdNjBvzTHg37hFywPUeQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792872705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=p7it7v3mdWaTKNdsH8gc4wn+k1Jd67X8e06UwbjHFZA=;
	b=fM63rMYmSReqDd/AWNT9pONk5iC6atmKMBgYs12wuqM1fgdESUng3BgWdYUKOL7CM3Dw
	 ix2mlswrCzdKvx7uXFAIXKrKcv1lnyAYLaZdvR3fzfPEqS/L9/c9GkEwkulw7Bp2vQ2EU
	 vbriHDiQdqZUt+1BIkkNTufQ+EQfCCqzfFlinFEUezdmHcsn0Qwc0VwPT7mz0ajczfSwb
	 nqMFl7T6LkJyPpbKb+DDN7ZexlBoHOYCta32JulEnJhPd81HVBwXX4aCXGSJP4kJsfDem
	 wvaCpoDpe7vhvmDL9vjA2rAOfOh4+zXNHbaIMUTppJi2vTjT2Ff/8VfpscGe3Lvqogw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FAIJuPRu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787F0606A328;
	Sat, 24 Oct 2026 20:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FAIJuPRu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EB31F01825;
	Sat, 24 Oct 2026 20:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792872705;
	bh=p7it7v3mdWaTKNdsH8gc4wn+k1Jd67X8e06UwbjHFZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FAIJuPRuRoNkce+R+N1FNWfGqKwD9H2l8++153a+mqTcEScfYiyuuGFV/Wokx1E6O
	 e7i9AbGCPYIueZfzkWyo0rWTrKDf89u1LlwOAjTzlZLZU6kQC5IMwKyL0k7KzZEGpY
	 Y/1CHHaG3o41LLCRriXXQZs/1pIBVpP8ZZB+3Thn/mnKSz7tQ/tqjL5nBGjKwioCIO
	 5BBy0WabBlbaEecQdsLrpTsftPP6TkL7a7rZDRczQML8gyqheGPEWTbVU2kpAlGSgk
	 tW2TvT7n6iJPnQmZyuiVxkH4tAf7pJRePJAhzS0fe+gtQBOhqR+lG5Z3atxJbzQ599
	 vjqSTELiRNPbw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
Subject: Re: [PATCH 5.10.y] netfilter: nf_tables: fix use-after-free in nf_tables_addchain()
Date: Sat, 24 Oct 2026 16:11:18 -0400
Message-ID: <2026-10-24-1-daily-reply-0021-nft-addchain-uaf-5-10-bounce@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261024124930.5397-1-steffen.pfendtner@kernelscan.io>
References: <20261024124930.5397-1-steffen.pfendtner@kernelscan.io>
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

> [ Backport to 5.10.y: 5.10 lacks d472e9853d7b ("netfilter: nf_tables:
>   register hooks last when adding new chain/flowtable"), so the hooks are
>   registered before the chain is added to table->chains and there is no
>   err_register_hook label.

Same as the 5.15 patch: this is a custom stable-only fix rather than a
backport of 71e99ee20fc3 ("netfilter: nf_tables: fix use-after-free in
nf_tables_addchain()"). The synchronize_rcu() goes in the register_hook
failure branch instead of upstream's err_register_hook label, and only the
packet-path half of the upstream commit applies on this tree.

It needs an ack from a netfilter maintainer on the thread before stable takes
it. Pablo, Florian: could you take a look? Please resend with the ack once
you have it.

-- 
Thanks,
Sasha
