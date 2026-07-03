Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0526266EE9;
	Fri,  3 Jul 2026 20:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783109439; cv=none; b=rqBEvEVhWbWaqmHyGXdDiD0fgzw/I3R0ABfmIDy23AEGERSGEKlz6JQj/S5TwQfaMGAe26bMc09NxObKPHp8L8EWAsjcqR3sYpH5WdJq4hWVJfQdKMJXbK+nBEvydkMG2X0xnDJdgpKLlvW67Ud559kIGAU73R2sGjdC4aAkGaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783109439; c=relaxed/simple;
	bh=ju6NgtYE51olZg52+d4SdiK5bCgde9MImpVZHbjyyw8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=n4A4jDL8hTSVC31+QFE6zB5eh4+14q+cW0WUnD6T85o2M67OA2W96rioVYnxDilcsdyyMxXxCQaSayqczN5gt6PFFXlElch+IZdHONnEgmgyGizU+LdJ3rMKjVxEEnJxbLR0P0QkENoUnna4QxXs/xDzIxKC8EJ57R8yvQf3dNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z6S3/m4F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z6S3/m4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FA61F000E9;
	Fri,  3 Jul 2026 20:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783109437;
	bh=sz35GCAgNVQfxcb9eu/6N2KbvkLh5PYLawSBVTeF+sw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Z6S3/m4FAb7TOpULjuRMY2eVb/8FTx+51DtBTlfIVKdwB8HVupUEFoPRh9FkcFAVl
	 2XgJ5LPYPRQKIW2n/Czo5jM5WoaCEair82oBCjfJfma7HXTMMQI6WcRuGAEljBxlDt
	 lNFwB+Mfm3NZUXIqMp/B4UySRfMOS+GQH9D3HFeMZSLpK6Nqdphr3OgETPOelqTyec
	 KO/KAv/yNoDGTYeA0JyZ/3yEehRinlHycuCQa4JrA3sSiM86rH2TG6lTXEoHD927F/
	 QGq8JQTbpS24pedT2/BZDwS5u4S1LQZKHPuIiUApYJ6ejgBbPhit2phbcZgLW5xN5z
	 H5qF5R55vteaA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 568F43939F01;
	Fri,  3 Jul 2026 20:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/12] netfilter: nfnetlink_hook: Dump nat type
 chains
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178310942014.3307503.7292006064345183764.git-patchwork-notify@kernel.org>
Date: Fri, 03 Jul 2026 20:10:20 +0000
References: <20260702105003.13550-2-fw@strlen.de>
In-Reply-To: <20260702105003.13550-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Florian Westphal <fw@strlen.de>:

On Thu,  2 Jul 2026 12:49:52 +0200 you wrote:
> From: Phil Sutter <phil@nwl.cc>
> 
> These chains are indirectly attached to the hook since they are
> not called for packets belonging to an established connection.
> 
> Introduce NF_HOOK_OP_NAT to identify the container and dump attached
> entries instead of the container itself.
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] netfilter: nfnetlink_hook: Dump nat type chains
    https://git.kernel.org/netdev/net-next/c/b010e2a4a9ac
  - [net-next,02/12] netfilter: x_tables: replace strlcat() with snprintf()
    https://git.kernel.org/netdev/net-next/c/9cc4d9720d70
  - [net-next,03/12] netfilter: replace u_int8_t and u_int16t with u8 and u16
    https://git.kernel.org/netdev/net-next/c/32b00984e002
  - [net-next,04/12] netfilter: avoid strcpy usage
    https://git.kernel.org/netdev/net-next/c/1501ab0701fd
  - [net-next,05/12] netfilter: remove redundant null check before kvfree()
    https://git.kernel.org/netdev/net-next/c/5efbced92ec1
  - [net-next,06/12] netfilter: xt_tcpmss: add checkentry for parameter validation
    https://git.kernel.org/netdev/net-next/c/68fc6c6470d6
  - [net-next,07/12] netfilter: xt_dscp: add checkentry for tos match
    https://git.kernel.org/netdev/net-next/c/60aee97fc7f8
  - [net-next,08/12] netfilter: nf_conntrack_helper: do not hash by tuple
    https://git.kernel.org/netdev/net-next/c/26fb502773bc
  - [net-next,09/12] netfilter: conntrack: get rid of tuple in helper definitions
    https://git.kernel.org/netdev/net-next/c/5de6c8ad0bcc
  - [net-next,10/12] netfilter: conntrack: remove obsolete module parameters
    https://git.kernel.org/netdev/net-next/c/78217fb2ccf9
  - [net-next,11/12] netfilter: ebtables: bound num_counters like nentries in do_replace()
    https://git.kernel.org/netdev/net-next/c/43ae85af154b
  - [net-next,12/12] netfilter: nft_ct: support expectation creation for natted flows
    https://git.kernel.org/netdev/net-next/c/d4beefc90a66

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


