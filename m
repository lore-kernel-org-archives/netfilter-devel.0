Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E5872608;
	Wed, 25 Jun 2025 00:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750810935; cv=none; b=rwK63tO2TiCSXPC1u/RSHDMcLgK3DxogKhhIB3EM0DhU4+F7TPe29ww65yPQmjx+DrnTJfvAyPAiNbAWFX+bhArARND6g2AC0eNaMQEzTTY0VrabcRkbJ5D0Lh8Zd2+z7K3vKx4XcgI3bqttF6das9p0EqhTlfwnpoR9TLt3NVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750810935; c=relaxed/simple;
	bh=r1QOunjZnN8JSSXJJERAc15DOyMsH0n/c0OAcrYsaOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C15/V0BwL8N2OJxE9+sQkD8jTjoB2H0wC/J1lTkmc48R5cyuNEbW0qM1/dei9Z1X0UcOOhCdATLs5uEwzhMQrhy68sQwbPhH94Wh66TKp7groTwR7VCRrI0159Rp5eq21fLnMzcNF7VW49449PV2ukYlV7MqOo/dce0xEFeyIMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B0l+yFss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B0l+yFss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B0EC4CEE3;
	Wed, 25 Jun 2025 00:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750810934;
	bh=r1QOunjZnN8JSSXJJERAc15DOyMsH0n/c0OAcrYsaOQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=B0l+yFssagYlFC2aeW0shi8Bbgf7SFG+3hT9EinAXIr9AWIXyxahPmM2186MRRERm
	 KeV2UnieRfni5DxQfJT3Z+5L3EGxCcD8aQ49T+ro5Ft74XlaAd0p8Ie5xxj/PuBOpR
	 +mfSJb4vgIHF7K8fvBhvjO2KPWRKkJ/9Yhcl7RVLNIVvJTi9bkOOyBacSLWhbSVRiA
	 gz9qTjKBb2elBoXZdyFZWjdnFBjQyszTowJmeh9Wupyaq9jFMX1+sFlGNA0ZMubsLB
	 44djEDL3TGXEk+vNWEWFYlMm9zYm8KoKEa7YAhyJfhy+hSnGBeX5Q+AXkkQIj6qcfc
	 paJ73BDpvFyzA==
Date: Tue, 24 Jun 2025 17:22:13 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, David Ahern
 <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Pablo Neira Ayuso
 <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>,
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org
Subject: Re: [PATCH net-next] net: netfilter: Add IPIP flowtable SW
 acceleration
Message-ID: <20250624172213.67768427@kernel.org>
In-Reply-To: <20250623-nf-flowtable-ipip-v1-1-2853596e3941@kernel.org>
References: <20250623-nf-flowtable-ipip-v1-1-2853596e3941@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Jun 2025 15:15:51 +0200 Lorenzo Bianconi wrote:
> Introduce SW acceleration for IPIP tunnels in the netfilter flowtable
> infrastructure.

=46rom a look at this patch and the code in nf_flow_table_ip.c
I'm a little unclear on whether the header push/pop happens
if we "offload" the forwarding.

> IPIP SW acceleration can be tested...

I think it's time we start to ask for selftest that can both run in SW
mode and be offload if appropriate devices are pass in via env.
--=20
pw-bot: cr
