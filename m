Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC3D3CE0A3;
	Thu, 11 Jun 2026 10:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781174419; cv=none; b=YfndnQOwMJOvTss+jO376b7JvGHacVkb8iFOdhXZ/GsM25S2W54xFf635uDcw54r3u+NbMekXSrDi4ZEyMdvd8TWzSN6fdnL21xO263gIu/GVhbj4EYahTiVuuBsIKZiskK9wrI8hZgAOV41DhphXOHObyf+0vhGyq+Nf7OGJLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781174419; c=relaxed/simple;
	bh=CtI1MaLi9PcEuQdw+0OwSgRnN20SXOqElSAtwppKGrI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=epGBFw2karQZeRPyAhp0QtQgxb2OvMrciE8go8fJL3x6SRYwARRASAeXuYR4jn9d+5pE6Z6YEAdTTPeOYtB+H4aXgx8/TRs2+iIepL1oi7/hDP2RnaqAEjA1ZtfbMBnrsiuv+7MKTrn+DQZc/+EibSAmGiaPSXmxiZCWPW+UBhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jlgUWe0b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jlgUWe0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62491F00893;
	Thu, 11 Jun 2026 10:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781174417;
	bh=lb5yR6kKw15NIkhKjlAVivaFIso9k3T093nzjy6Tiqk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=jlgUWe0bTXe0c/qdZyLSvX76essm9z4hi6gizBOqwN0ELLxmKNHGDgJLWTZVphUbp
	 CY9aHMRRoc4hhg60zRNS/h7TChmSzoPx7S/nc27HAvMMLyi3QXI0389qhK6m93jzFV
	 d/moGTbEx4n2O3qM9Zl2LPOVnAQG74+OEm5S2TnRnw/rJ1cFThtA6ahj0/V/lAShc2
	 ZjqKj8GgqM5N6l+J/R3pyE2judurIn5Tq3kahFvMkmyQXdxbzGB/QUYJUsEkVeY/Tp
	 7b4JebysjWdX6U1Fj4POg51ABGDMKI4G7w7jdVOgyo7smWSY7SqV7y+46kYR5CnPCN
	 uijnfpbnSX9ew==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 568873930E4A;
	Thu, 11 Jun 2026 10:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/8] netfilter: revalidate bridge ports
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178117441489.3886909.15763136255322020254.git-patchwork-notify@kernel.org>
Date: Thu, 11 Jun 2026 10:40:14 +0000
References: <20260610161629.214092-2-pablo@netfilter.org>
In-Reply-To: <20260610161629.214092-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed, 10 Jun 2026 18:16:21 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> ebt_redirect_tg() dereferences br_port_get_rcu() return without a
> NULL check, causing a kernel panic when the bridge port has been
> removed between the original hook invocation and an NFQUEUE
> reinject.
> 
> [...]

Here is the summary with links:
  - [net,1/8] netfilter: revalidate bridge ports
    https://git.kernel.org/netdev/net/c/ccb9fd4b8753
  - [net,2/8] netfilter: nf_tables_offload: drop device refcount on error
    https://git.kernel.org/netdev/net/c/efc542561729
  - [net,3/8] netfilter: nf_conntrack: destroy stale expectfn expectations on unregister
    https://git.kernel.org/netdev/net/c/c3009418f9fa
  - [net,4/8] netfilter: x_tables: avoid leaking percpu counter pointers
    https://git.kernel.org/netdev/net/c/f7f2fbb0e893
  - [net,5/8] netfilter: nf_log: validate MAC header was set before dumping it
    https://git.kernel.org/netdev/net/c/a84b6fedbc97
  - [net,6/8] netfilter: nft_exthdr: fix register tracking for F_PRESENT flag
    https://git.kernel.org/netdev/net/c/772cecf198da
  - [net,7/8] netfilter: nft_fib: fix stale stack leak via the OIFNAME register
    https://git.kernel.org/netdev/net/c/ab185e0c4fb8
  - [net,8/8] netfilter: nft_meta_bridge: fix stale stack leak via IIFHWADDR register
    https://git.kernel.org/netdev/net/c/c7d573551f92

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


