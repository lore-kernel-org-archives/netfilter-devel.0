Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2071519B5A3;
	Thu, 27 Nov 2025 12:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764246835; cv=none; b=Hb+4yrAfdv/AoMKEFE312vHOb207nrf/C5XC+JH2zqf6AWxbCBrBlRWylhgUQR9RuWhfd2xgysJNeWtRc3d4EInBZb6wzlD76yiaV+SF+4BYF+fEksuuJPgVrNYGpsctkd2agaTrZu0SQAKWoMPpJK+axaLGYSK3xZjh4v1BmcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764246835; c=relaxed/simple;
	bh=9XpFaoSIL1kTn6eFjQgnB+mcw8pcb+2pZRRAZG57Zqk=;
	h=Subject:From:To:Cc:Date:Message-ID:MIME-Version:Content-Type; b=adBf+98haXFLLKyFGh7qxhcVRaDZ/pIH+kH740MDKRSMldgA7RTLVTc7ZEXzG3vmpeNaT6G7MvSAmhze/eu9Yx97QvCOjYk5sVwAnNpVP4duct3HuKUV7kGwU+AaCxtIerrnbx3ZqGDyngIrmwYiMwJJQPkHpPpA4uu30NAGyIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dA0QO9u4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dA0QO9u4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A902C4CEF8;
	Thu, 27 Nov 2025 12:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764246834;
	bh=9XpFaoSIL1kTn6eFjQgnB+mcw8pcb+2pZRRAZG57Zqk=;
	h=Subject:From:To:Cc:Date:From;
	b=dA0QO9u4WYmpZZcK+9psjV3OaBgajeD5sunxdM4w5czH8k7RsKONihD6RaB7Rrakb
	 BwfbbJN0SSYWPmKPHFIG4VWpKR8VAI0Q3I+qPdU5FmF1HYUn7KBQA3hfWy0A6FOCbs
	 8jjL/2VvhLoQRkj+BshLim/SHPWdfbOGpSATd0DSlDVhjvoRAtpaw3LPHpaIGoG+uM
	 ZX8fnKWEChEjwxNr3UjxtKRwz+C+pEKDF4Pqc5w/pJFLnvF8jegnpCxAV4hi//EIwW
	 lSpauYRDgTfMIDrQZKnFkX5CArDyR0kN6TZUW6OJvUd646M+cOrbZQkU9mTD46YUFx
	 pAIkIjGy8QmCA==
Subject: [PATCH nf-next RFC 0/3] netfilter: x_tables: statistic nth match
 account GRO/GSO packets
From: Jesper Dangaard Brouer <hawk@kernel.org>
To: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
 phil@nwl.cc, Eric Dumazet <eric.dumazet@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, kernel-team@cloudflare.com,
 mfleming@cloudflare.com, matt@readmodwrite.com
Date: Thu, 27 Nov 2025 13:33:49 +0100
Message-ID: <176424680115.194326.6611149743733067162.stgit@firesoul>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In production we have a service that does sampling of 1 in every 10000 nth
packets. This is leveraging the iptables statistic module for reducing the
samples send to userspace via NFLOG target.

This part worked nicely until a mathematician noticed that we were under
sampling GRO/GSO packets. This is an example of a Bernoulli trial. When wanted
to sample one packet every nth packet. When a GRO packet contains e.g. just 2
packets then we should have sampled that at 5000. At 10 packets this is
1000. This caused enough under sampling of GRO/GSO to make statistics wrong in
our backend systems consuming this.

The production workaround is simply send all packets larger than the MTU to
userspace (via NFLOG). Then let the userspace sampler daemon pick 1 in 10000 nth
packets to be logged to the backend. Needless to say, this solution doesn't
scale. In production if enough CPUs participate this results in lock contention,
and in general this is limiting through to 20Gbit/s out of 25Gbit/s.

This patchset avoids having to send all GRO/GSO packet to userspace, by letting
the statistics nth mode account for the number of GRO/GSO fragments.

---

Jesper Dangaard Brouer (3):
      xt_statistic: taking GRO/GSO into account for nth-match
      xt_statistic: do nth-mode accounting per CPU
      xt_statistic: DEBUG patch


 include/uapi/linux/netfilter/xt_statistic.h |  1 +
 net/netfilter/xt_statistic.c                | 94 +++++++++++++++++++--
 2 files changed, 89 insertions(+), 6 deletions(-)

--

