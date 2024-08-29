Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F8B18CBE9;
	Thu, 29 Aug 2024 09:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724925024; cv=none; b=XpBopp/K0eHqWRRcch9xzV5CL1TUy8f5J2BYk+/JlbLnABymn8FUbgBBeGWLWhJDOFPP5Ai+m4PYm5PG1CGE+jdS6Fs7yrvOM2y4E96rUqZEmlYxkOZCq5tBePaD808XT3O2z56JH8WczNFIqJpDVbcKQSIWjMoAFGGIPzNQqXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724925024; c=relaxed/simple;
	bh=hs7sKm0U6Yz2qOolLUBqB/IWcmqcYGGMJw3M4eHwXy8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=JyVZCENbnDyzyPSIvh655fyU6VWVVqkJj0dHitEsGKFx5zB0ZtH8lwhkvrlH9bK62POvj/y2fSGNY1DNmYd80VUgFleBTuJ3O5p0l8+8+sM246wcyB4skRj2NlOGI/rmPIIdki/bQDfPcBd4mY1lusZi1fcNP/60Zl5OzAQ5HRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X47FqyQZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X47FqyQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59B3C4CEC5;
	Thu, 29 Aug 2024 09:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724925024;
	bh=hs7sKm0U6Yz2qOolLUBqB/IWcmqcYGGMJw3M4eHwXy8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=X47FqyQZnpNOBr/4C2rYcFYFAEgzOguVAGWGSmX/E1mslDwh+hXt5plrJ2CrnBSMD
	 P1hFp6/egcHURpIHYGThoifqq7FRm46+5jZj08LqjQedAcgsUFLJrLe5C8HWZFAasB
	 WsYld6QprQCgSd3XgtGu2FIjisn4UmqwlmuOJEgO5/vLdR8Co14vfTIaQBr2/I4y2u
	 Bx02LnDPRrRbVITWYbgFs5au+QGFcE9vgs6JZ1AFp6sz2usbsANSp4MQz7JDxOGDCA
	 j4kHBd/rMS/C1kVkLGrcVrbvpNdVgqcFbDPWwuH1aU9iAs6pSUqiphQEwkiVNkmOFv
	 7ekW96a52zXBw==
Received: from ip-10-30-226-235.us-west-2.compute.internal (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 586CD3809A81;
	Thu, 29 Aug 2024 09:50:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: nf_tables: restore IP sanity checks for
 netdev/egress
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172492502535.1887808.17550387443774732604.git-patchwork-notify@kernel.org>
Date: Thu, 29 Aug 2024 09:50:25 +0000
References: <20240828214708.619261-2-pablo@netfilter.org>
In-Reply-To: <20240828214708.619261-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed, 28 Aug 2024 23:47:07 +0200 you wrote:
> Subtract network offset to skb->len before performing IPv4 header sanity
> checks, then adjust transport offset from offset from mac header.
> 
> Jorge Ortiz says:
> 
> When small UDP packets (< 4 bytes payload) are sent from eth0,
> `meta l4proto udp` condition is not met because `NFT_PKTINFO_L4PROTO` is
> not set. This happens because there is a comparison that checks if the
> transport header offset exceeds the total length.  This comparison does
> not take into account the fact that the skb network offset might be
> non-zero in egress mode (e.g., 14 bytes for Ethernet header).
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: nf_tables: restore IP sanity checks for netdev/egress
    https://git.kernel.org/netdev/net/c/5fd062891897
  - [net,2/2] netfilter: nf_tables_ipv6: consider network offset in netdev/egress validation
    https://git.kernel.org/netdev/net/c/70c261d50095

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


