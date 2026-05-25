Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D1C318ED9;
	Mon, 25 May 2026 17:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779730821; cv=none; b=Lh6LVirRKAtXsEdvf1KZ9n4XeYaZoAWnWC/sfbGkxfa7ECe0oCbzaQpH784u/fCuQitwmKuRxy9lPJ5F4janKDZuPk5Q0HzALNWuDQgCmymF3l7ZI3zJBWBkH9aTvhcOp9uswIKPmoB9NNEZx8AN6130P0aoklPSi497L4Hi9JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779730821; c=relaxed/simple;
	bh=LbDXBWGocHy8OeHHbpY3N87v3f7GuOFoop3Y0T9AdXQ=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=TZ7OlKSmZQMe3OgKGzm0HXM/Af6Onjwf2R1pc0HvOhM3XcABX3XUaC6r9PXSDe6R0k2urruTuks1K9G3MnvMomH42o0sV+PMI3JdG6D9fkxOpGAm+IfqncA/8A6gR2kIzIsfu0l5Zyzf7Noz03prPzuJXRj9M4gQh92Z1uO3e5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ixZ6kE+D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ixZ6kE+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A288D1F000E9;
	Mon, 25 May 2026 17:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779730819;
	bh=UXiCMnxFUe8CHzONBwVFJmz85umgFKr1qNQ40S2w5iY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ixZ6kE+D71JnT2fhVeQ7xak/ccLzGWN7lavet8bhl8fSH8a1Vk8EFXF7m7lym0lfv
	 jsSxRp+xJwLpWYkHM59t1D+05R+dNbaB04anP4WbN7LTEBO1nabthtZcENlOfkLZX8
	 yZNp99t6glXVXU3Y2TJxiia6TYER+Vg0Nj/on/U2yChqgDmXR2jbz4FE2Jqso2YvZO
	 tPonRVJgBlmEj6zhX5lJi1kLf7ZHrmtQFPdTXV2q16bhxm8jmTdfkAamGtsyVK6zNh
	 jXUhrjVIYsljFdGtJRDR9QAS0ZkHyvlnctMKFVwEMr1Lt0vsNdT67DjHHgOwzPPxoY
	 8FQU3byZVaoyA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A66380AA75;
	Mon, 25 May 2026 17:40:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/10] netfilter: conntrack: tcp: do not force CLOSE
 on
 invalid-seq RST without direction check
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177973082614.3066906.10837971567418831888.git-patchwork-notify@kernel.org>
Date: Mon, 25 May 2026 17:40:26 +0000
References: <20260522104257.2008-2-fw@strlen.de>
In-Reply-To: <20260522104257.2008-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Fri, 22 May 2026 12:42:48 +0200 you wrote:
> From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
> 
> An unintended behavior in the TCP conntrack state machine allows a
> connection to be forced into the CLOSE state using an RST packet with an
> invalid sequence number.
> 
> Specifically, after a SYN packet is observed, an RST with an invalid SEQ
> can transition the conntrack entry to TCP_CONNTRACK_CLOSE, regardless of
> whether the RST corresponds to the expected reply direction. The relevant
> code path assumes the RST is a response to an outgoing SYN, but does not
> validate packet direction or ensure that a matching SYN was actually sent
> in the opposite direction.
> 
> [...]

Here is the summary with links:
  - [net,01/10] netfilter: conntrack: tcp: do not force CLOSE on invalid-seq RST without direction check
    https://git.kernel.org/netdev/net/c/bed6e04be8e6
  - [net,02/10] netfilter: synproxy: refresh tcphdr after skb_ensure_writable
    https://git.kernel.org/netdev/net/c/92170e6afe92
  - [net,03/10] netfilter: nf_conntrack_gre: fix gre keymap list corruption
    https://git.kernel.org/netdev/net/c/47980b6dbf83
  - [net,04/10] netfilter: xt_cpu: prefer raw_smp_processor_id
    https://git.kernel.org/netdev/net/c/c376f07e16c0
  - [net,05/10] netfilter: disable payload mangling in userns
    https://git.kernel.org/netdev/net/c/968cc2c96390
  - [net,06/10] netfilter: ebtables: fix OOB read in compat_mtw_from_user
    https://git.kernel.org/netdev/net/c/f438d1786d65
  - [net,07/10] netfilter: nft_fib_ipv6: walk fib6_siblings under RCU
    https://git.kernel.org/netdev/net/c/1d001b0a6182
  - [net,08/10] netfilter: nft_fib_ipv6: handle routes via external nexthop
    https://git.kernel.org/netdev/net/c/f81b0c2d281f
  - [net,09/10] selftests: netfilter: add nft_fib_nexthop test
    https://git.kernel.org/netdev/net/c/a40aaaef2f8f
  - [net,10/10] netfilter: nf_tables: fix dst corruption in same register operation
    https://git.kernel.org/netdev/net/c/18014147d3ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


