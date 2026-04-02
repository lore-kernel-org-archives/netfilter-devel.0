Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826561C84DC;
	Thu,  2 Apr 2026 00:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775089444; cv=none; b=XBUniX78UKo8nSrivRohKff0Ee6w2DsP8cUDl+hVNG7j6UVpxw0P1uqhkF1IOTrn0istbqHFXFzJPoGan+xL+38LLgZspuPfqNeVAwKgY+jq3LbZUrc1bXCQJZZLenZNXoxYk2H1QPFGN+ZMh7/lmH/PkWKG3oJE0OGBIQIl1bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775089444; c=relaxed/simple;
	bh=EOi2ONHFkZ7HVDG2V6IsB9nDlSSaQOiYvCtTGJCt0B4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s9adWhEZ2ajuyK31iJJBq2C9+VlxBxz1BbC0hugvKBlS1MQvCbuwUJaRiM2Hhulie6/41omxR6/6JkyqCDSSoYmICLLBRQ7zrUy0aDmMqFllsJgx3DoniWlp0kj8yW60pRRAFltmFurISeza+DuUG3ey5dbD4vIGZQRoZ+YsMTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bSE4OCdp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bSE4OCdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3554C4CEF7;
	Thu,  2 Apr 2026 00:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775089444;
	bh=EOi2ONHFkZ7HVDG2V6IsB9nDlSSaQOiYvCtTGJCt0B4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bSE4OCdphnhOFz1IR/oaKM/RcfetOMfwYEzuiGQkh4hYOFrGSlut7d9/Dtm8fefds
	 B3eDUkHReirOO4ZRAMM5c5sMO72LL0pEZLENcDGyGwLCgwEWmwKZimlTqiBTQj7RIa
	 P9qqPOGrCWy6cI3RaXjY4I5KK8dve1YNL5rzsL6KAOlJcAJTwKB6u1dAE+hrv0xs+t
	 sVu6aEPpSRc1R2s681WT+pYodXzXGgYFIDRFAmPoNoJ0F9QgKfd9Xr9yNxAknk42eT
	 5c/YNeNtjPK8Y07qpI28SqpDVQp5kdFQzA921ADZlaldO+F8ETnM3BASXxWBG25Fhx
	 DXLpdvQqWa5HQ==
Date: Wed, 1 Apr 2026 17:24:00 -0700
From: patchwork-bot+netdevbpf <kuba@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Andrew
 Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, Nikolay Aleksandrov <razor@blackwall.org>, Ido
 Schimmel <idosch@nvidia.com>, Martin KaFai Lau <martin.lau@linux.dev>,
 Daniel Borkmann <daniel@iogearbox.net>, John Fastabend
 <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@fomichev.me>, Alexei
 Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Eduard
 Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>, Yonghong Song
 <yonghong.song@linux.dev>, KP Singh <kpsingh@kernel.org>, Hao Luo
 <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Kuniyuki Iwashima
 <kuniyu@google.com>, Willem de Bruijn <willemb@google.com>, David Ahern
 <dsahern@kernel.org>, Neal Cardwell <ncardwell@google.com>, Johannes Berg
 <johannes@sipsolutions.net>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, Guillaume Nault
 <gnault@redhat.com>, David Woodhouse <dwmw@amazon.co.uk>, Kees Cook
 <kees@kernel.org>, Alexei Lazar <alazar@nvidia.com>, Gal Pressman
 <gal@nvidia.com>, Paul Moore <paul@paul-moore.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 oss-drivers@corigine.com, bridge@lists.linux.dev, bpf@vger.kernel.org,
 linux-wireless@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, torvalds@linux-foundation.org,
 jon.maddog.hall@gmail.com
Subject: Re: [PATCH 0/6] Deprecate Legacy IP
Message-ID: <20260401172400.41df7edf@kernel.org>
In-Reply-To: <20260401074509.1897527-1-dwmw2@infradead.org>
References: <20260401074509.1897527-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  1 Apr 2026 08:44:14 +0100 David Woodhouse wrote:
> RFC1883, the IPv6 standard, was published in the final decade of the 1900s.
> That's closer in time to the Apollo 11 moon landing than it was to today.
> 
> Even our esteemed Maddog has worked with computers for longer in the IPv6
> era, than he ever did before it.
> [...]

Here is the summary with links:
  - [net-next,v4,1/6] net: Simplify tautological CONFIG_INET/CONFIG_IPV6 guards
    https://git.kernel.org/netdev/net-next/c/8888bf4fb980
  - [net-next,v4,2/6] net: Add CONFIG_LEGACY_IP option
    https://git.kernel.org/netdev/net-next/c/9b29afa11660
  - [net-next,v4,3/6] net: Guard Legacy IP entry points with CONFIG_LEGACY_IP
    https://git.kernel.org/netdev/net-next/c/f26d43acf12f
  - [net-next,v4,4/6] net: Make IPv4-only Kconfig options depend on LEGACY_IP
    https://git.kernel.org/netdev/net-next/c/ba5d4128fca8
  - [net-next,v4,5/6] net: Change CONFIG_INET to CONFIG_LEGACY_IP for IPv4-only code
    https://git.kernel.org/netdev/net-next/c/ff1cb3ad2abc
  - [net-next,v4,6/6] net: Warn when processes listen on AF_INET sockets
    https://git.kernel.org/netdev/net-next/c/7dae8ffb0987

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


