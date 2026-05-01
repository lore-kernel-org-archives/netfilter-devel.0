Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1680E2EC0A1;
	Fri,  1 May 2026 23:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777679470; cv=none; b=Mb4j+x9C7SDbMgsyZoI2xtu0lhYvJFSKi79o4c3+lPlDIBBmmtgAb/7wH3ed4WbLpf/OBqOsC6K2s3SDk2HVfUTCTEY4YGyuxipLYRF5uM0kXjyRlKkJI3mozvtMWTOGgBBY8fQ7eXGUohASNjiiw2e35NJZVAoHz+XCmQlboHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777679470; c=relaxed/simple;
	bh=blhZiMz/SgM1lwXzxNwOF/MqFMiwiS0W4iq5pX26ISo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=YLTiNXUBjtFKoE7sUj0Td3phC7x4Jsbr7W6J280UbhdpKI3jxWVA0hfJCzvpkl4UUzCTzaqBLRN1jLORrLAWjh7YfDAcOGXyTjvM2+TY+okGFDMDdjeG0DRIjM0E3wD/DqM3+XtXcsIRujBmVpDPaNF3p9uXRNWxQsOzZ5sXGrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ridUYzzb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ridUYzzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41DBC2BCB4;
	Fri,  1 May 2026 23:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777679469;
	bh=blhZiMz/SgM1lwXzxNwOF/MqFMiwiS0W4iq5pX26ISo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ridUYzzbW5d9KyRTmy9Bv6NTF+Gjw9gTRy5yF0PtQVzQhxnkhBUu/iPKTEP62Cwvp
	 RgOI5LbCokT4ta2HuLNyHbuQWh8/cE48NXkm86tnXsEjVyglB2TQ9AzVwsb9ix2jqm
	 J33bmzLmcz4BEvUk6iT8Jm7rtG9tK5SY7zjaNjlmykJTE/Mi42OpalzU2mCBrBEYlz
	 UiOsw5f+Tb3fsYD0fmBaRuFzKKw3wHHIjo6WsfogsuqXSamoXk18JsxBdeIJYg1Ted
	 PMTNkonPQaa0FSlfBjcT026aY8gkrLXsUAfkpXimfClIxY3j+CwQBN9r3jPhBKrQZB
	 iHSeFbU5//TQQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02DD7380CEF5;
	Fri,  1 May 2026 23:50:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/14] netfilter: replace skb_try_make_writable() by
 skb_ensure_writable()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177767942280.3662469.15016765867771829872.git-patchwork-notify@kernel.org>
Date: Fri, 01 May 2026 23:50:22 +0000
References: <20260501122237.296262-2-pablo@netfilter.org>
In-Reply-To: <20260501122237.296262-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri,  1 May 2026 14:22:24 +0200 you wrote:
> skb_try_make_writable() only works on clones and uncloned packets might
> have their network header in paged fragments.
> 
> nft_fwd needs to work for the ingress and egress hooks, but the egress
> hook where skb->data points to the mac header, use skb_network_offset()
> to include the mac header. The flowtable is fine since it already uses
> the transport offset.
> 
> [...]

Here is the summary with links:
  - [net,01/14] netfilter: replace skb_try_make_writable() by skb_ensure_writable()
    https://git.kernel.org/netdev/net/c/1049970d7583
  - [net,02/14] netfilter: nft_fwd_netdev: add device and headroom validate with neigh forwarding
    https://git.kernel.org/netdev/net/c/0a0b35f0bf10
  - [net,03/14] netfilter: nft_fwd_netdev: use recursion counter in neigh egress path
    https://git.kernel.org/netdev/net/c/1d47b55b36d2
  - [net,04/14] netfilter: x_tables: add .check_hooks to matches and targets
    https://git.kernel.org/netdev/net/c/6813985ca456
  - [net,05/14] netfilter: nft_compat: run xt_check_hooks_{match,target}() from .validate
    https://git.kernel.org/netdev/net/c/2f768d638d97
  - [net,06/14] netfilter: xt_CT: fix usersize for v1 and v2 revision
    https://git.kernel.org/netdev/net/c/8bedb6c46945
  - [net,07/14] netfilter: nf_tables: fix netdev hook allocation memleak with dormant tables
    https://git.kernel.org/netdev/net/c/63bac0278603
  - [net,08/14] netfilter: nf_socket: skip socket lookup for non-first fragments
    https://git.kernel.org/netdev/net/c/0bf00859d7a5
  - [net,09/14] netfilter: nf_tables: skip L4 header parsing for non-first fragments
    https://git.kernel.org/netdev/net/c/009d203e56db
  - [net,10/14] netfilter: xtables: fix L4 header parsing for non-first fragments
    https://git.kernel.org/netdev/net/c/952e121c9613
  - [net,11/14] netfilter: flowtable: ensure sufficient headroom in xmit path
    https://git.kernel.org/netdev/net/c/ef4f741e8627
  - [net,12/14] netfilter: flowtable: fix inline vlan encapsulation in xmit path
    https://git.kernel.org/netdev/net/c/a177ae30f786
  - [net,13/14] netfilter: flowtable: fix inline pppoe encapsulation in xmit path
    https://git.kernel.org/netdev/net/c/69c54f80f4a7
  - [net,14/14] netfilter: flowtable: use skb_pull_rcsum() to pop vlan/pppoe header
    https://git.kernel.org/netdev/net/c/baa3c65435fb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


