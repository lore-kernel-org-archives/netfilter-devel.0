Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74D07082D;
	Sun, 12 Apr 2026 18:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776016851; cv=none; b=eL+bNA+AMeFXDo+zxvxqAym0qrtiulLBPGeCb53s4UjYBuprXQOok8/Dz3GxcNElR7tRb3uELmNn/mI/I8upo6hh9kM8HHUVeUZHI3wEf95e3qFSjWzVBqAe7zhxvtwYVbhQiSUDhMDHabdUk1MaALRoyDqVeKe0O3a6DC/g2dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776016851; c=relaxed/simple;
	bh=EQKOFUH1kajAAUiz5DlUKZbbWIzXjtIWhHdGTV1y9O8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=uR91bYixNyZFCnd1i+vHH1Y3bUAm53Sem47ZAIVaRWrRIHnmvX5cX7B0kxNFiNm4Suht+jNu2k0UwrSXIPIFt6fFIx6/4m/drpfXCDLNsvUloQkFq3vzh91NHbCTM6DLjbzJmPFms7zVXG0l9TuotA6mjunbGwLaXIUOGw6LmEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bFadsqnu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bFadsqnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54414C19425;
	Sun, 12 Apr 2026 18:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776016851;
	bh=EQKOFUH1kajAAUiz5DlUKZbbWIzXjtIWhHdGTV1y9O8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=bFadsqnuKpzcH7QW6fSADlIlKOe++wKza5nNeCrwZaBfm5RArLoH3Rcx/xOW8giwo
	 XggiHM0u4ZP8oldRdyU2VVPdFJMwNR1IS2VjAgR3tYYt47RUg8NoEToKSVUfWKJk5O
	 kvwBFzZGesZCL6vFLqKcJQ49bKw7lhjr9SvLjhZIyiz9RGTC62syBK3gx5rt31kMLu
	 o1z/IkoUpX/JQ4gjPGiNMUE4uM5tRiQRyPrT+6PY3YKDfxqDmUsXwt/bMX7S0yFSM5
	 CSex+QuKwlRwGWRJ9lhAPamYAoHlDl2ng1H/E5tcjq9kfLGlBoei35dSEBBrZN3vaF
	 UCGCJ8xH7khBw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02D993809A8C;
	Sun, 12 Apr 2026 18:00:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/11] ipvs: show the current conn_tab size to
 users
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177601682380.3359939.9450580091619442068.git-patchwork-notify@kernel.org>
Date: Sun, 12 Apr 2026 18:00:23 +0000
References: <20260410112352.23599-2-fw@strlen.de>
In-Reply-To: <20260410112352.23599-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Florian Westphal <fw@strlen.de>:

On Fri, 10 Apr 2026 13:23:42 +0200 you wrote:
> From: Julian Anastasov <ja@ssi.bg>
> 
> As conn_tab is per-net, better to show the current hash table size
> to users instead of the ip_vs_conn_tab_size (max).
> 
> Signed-off-by: Julian Anastasov <ja@ssi.bg>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] ipvs: show the current conn_tab size to users
    https://git.kernel.org/netdev/net-next/c/22e620fe8455
  - [net-next,02/11] ipvs: add ip_vs_status info
    https://git.kernel.org/netdev/net-next/c/9a9ccef907a7
  - [net-next,03/11] ipvs: add conn_lfactor and svc_lfactor sysctl vars
    https://git.kernel.org/netdev/net-next/c/8d7de5477e47
  - [net-next,04/11] netfilter: x_physdev: reject empty or not-nul terminated device names
    https://git.kernel.org/netdev/net-next/c/8df772afc9d0
  - [net-next,05/11] netfilter: nfnetlink: prefer skb_mac_header helpers
    https://git.kernel.org/netdev/net-next/c/74feb7d373b3
  - [net-next,06/11] netfilter: xt_HL: add pr_fmt and checkentry validation
    https://git.kernel.org/netdev/net-next/c/24bd5c2679ca
  - [net-next,07/11] netfilter: xt_socket: enable defrag after all other checks
    https://git.kernel.org/netdev/net-next/c/542be3fa5aff
  - [net-next,08/11] netfilter: conntrack: remove UDP-Lite conntrack support
    https://git.kernel.org/netdev/net-next/c/84dee05d9d61
  - [net-next,09/11] netfilter: x_tables: Avoid a couple -Wflex-array-member-not-at-end warnings
    https://git.kernel.org/netdev/net-next/c/f30e5a7291a8
  - [net-next,10/11] netfilter: nft_fwd_netdev: check ttl/hl before forwarding
    https://git.kernel.org/netdev/net-next/c/1dfd95bdf4d1
  - [net-next,11/11] netfilter: require Ethernet MAC header before using eth_hdr()
    https://git.kernel.org/netdev/net-next/c/62443dc21114

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


