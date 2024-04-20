Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35839DDA8;
	Sat, 20 Apr 2024 03:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713583829; cv=none; b=DtHLlt7ZwFoPEozPzJOXuc0tMySWuSC5Gfgs2MQu9sY1aqwowBcyVGZZwpw86Gm6RqxydLpJPPuq3cGsCX5Ad2m5OpDdhPQZZEVLLjjR10JUZfRatlAUGZripArYBXWlCtl7gPvkqU26zUuInkX8fKwRZsEbcDzm7GsACN5fBdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713583829; c=relaxed/simple;
	bh=SiGMpQbe8ZtWXyfF4V/sR/uPQM8brDvWkx4PDvxfjm0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=cieL8alfRHLebQ7NDXdK3OtA/71LOaa8whqKszs4eSlEh8c0g6uRWMOEJwqVRKgOOTCLqwzurujlh+1ZrlvMdoPnlpYVWtoX3oPSgFomn1Ao01NJHCMOL/+AcT+WLmhXYPYpQiM8AyFUh71f4KaHO9pcrOXN2lYLidK2biroWj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PB4P6sNf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PB4P6sNf"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13469C32783;
	Sat, 20 Apr 2024 03:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713583829;
	bh=SiGMpQbe8ZtWXyfF4V/sR/uPQM8brDvWkx4PDvxfjm0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=PB4P6sNfNtbuGq7Z5ejPY0xryH0mO+4UZZOJAuCovb7jkjgARj0vLFIUo71mB0Hsy
	 NdAeKqTiuhKy/HeYpTAfJVNCC36KDK7xU42Vnhopyn5RZkydtK9eClECUu2But+FAu
	 SzeKZ91xFjB7L4IqC4MDs3eDCCLp3fAZFCXoXLGHAZrNaHDAHh24EHd49r/t9nvWBP
	 8Yln54mDULZeUUf+0uMmfEIRr3tG297e/XtvXIj8sSWXOr32VLLKvBiDZVPaRzpK9L
	 NFRCMmWyQYGf0xZFFgEZ0QUWw3SlsvYg+XVaCDF1KbLb2pTpCAxAyRxnRxJjIARGMc
	 1pDVNm/EJe3hg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 07F7DC433E9;
	Sat, 20 Apr 2024 03:30:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/12] testing: make netfilter selftests
 functional in vng environment
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171358382902.21761.11464327013965926812.git-patchwork-notify@kernel.org>
Date: Sat, 20 Apr 2024 03:30:29 +0000
References: <20240418152744.15105-1-fw@strlen.de>
In-Reply-To: <20240418152744.15105-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 18 Apr 2024 17:27:28 +0200 you wrote:
> This is the second batch of the netfilter selftest move.
> 
> Changes since v1:
> - makefile and kernel config are updated to have all required features
> - fix makefile with missing bits to make kselftest-install work
> - test it via vng as per
>    https://github.com/linux-netdev/nipa/wiki/How-to-run-netdev-selftests-CI-style
>    (Thanks Jakub!)
> - squash a few fixes, e.g. nft_queue.sh v1 had a race w. NFNETLINK_QUEUE=m
> - add a settings file with 8m timeout, for nft_concat_range.sh sake.
>   That script can be sped up a bit, I think, but its not contained in
>   this batch yet.
> - toss the first two bogus rebase artifacts (Matthieu Baerts)
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/12] selftests: netfilter: nft_queue.sh: move to lib.sh infra
    https://git.kernel.org/netdev/net-next/c/03a1a62f3a3c
  - [net-next,v2,02/12] selftests: netfilter: nft_queue.sh: shellcheck cleanups
    https://git.kernel.org/netdev/net-next/c/cebb352269e7
  - [net-next,v2,03/12] selftests: netfilter: nft_synproxy.sh: move to lib.sh infra
    https://git.kernel.org/netdev/net-next/c/a849e06c8025
  - [net-next,v2,04/12] selftests: netfilter: nft_zones_many.sh: move to lib.sh infra
    https://git.kernel.org/netdev/net-next/c/c1a9d47b59d0
  - [net-next,v2,05/12] selftests: netfilter: xt_string.sh: move to lib.sh infra
    https://git.kernel.org/netdev/net-next/c/5067fec09403
  - [net-next,v2,06/12] selftests: netfilter: xt_string.sh: shellcheck cleanups
    https://git.kernel.org/netdev/net-next/c/c0f9a2b705c2
  - [net-next,v2,07/12] selftests: netfilter: nft_nat_zones.sh: shellcheck cleanups
    https://git.kernel.org/netdev/net-next/c/d6905f088d2b
  - [net-next,v2,08/12] selftests: netfilter: conntrack_ipip_mtu.sh: shellcheck cleanups
    https://git.kernel.org/netdev/net-next/c/05af10a88e75
  - [net-next,v2,09/12] selftests: netfilter: nft_fib.sh: shellcheck cleanups
    https://git.kernel.org/netdev/net-next/c/9b443c769b1b
  - [net-next,v2,10/12] selftests: netfilter: nft_meta.sh: small shellcheck cleanup
    https://git.kernel.org/netdev/net-next/c/4d7730154ed5
  - [net-next,v2,11/12] selftests: netfilter: nft_audit.sh: add more skip checks
    https://git.kernel.org/netdev/net-next/c/1f50b0fef936
  - [net-next,v2,12/12] selftests: netfilter: update makefiles and kernel config
    https://git.kernel.org/netdev/net-next/c/0b2e1db97b42

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


