Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC354779F;
	Fri,  6 Sep 2024 03:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725593461; cv=none; b=H7UEGYY6gUkrSZNV4xzzVlGcykiDDgAAnpoqnnCDBaya3sDIRPccJYqLBSC0yhPf9KvzTy/CWB8H6tSnhVt/giTEX/wBvxKZOGP3sAcB6ykYkL30J/s/j+er9yV4FtaEaLs5OPq5xmGL02lMdiNI9pD5J4Ty7uFQUsPvcfvPsPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725593461; c=relaxed/simple;
	bh=Jn85Flmv/JtoTFvit5tYDcNgzkMJ2/wjWasPOnbf16s=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=hZ99BMYBpaK5M87xLAxfxt18gKVtgxosBxCi41Nagodil0gz90aAXe/Mv6BNsw0Y6IngohoyMWRuYFcUrlzurHWXMimIQh7mDgPQl6d9ZES4Hxr0aM12H1GmeJz4wb864lgVIbIoMjiCoofPjc47tdLHvCuTe8HoalC+403lCfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BXIP2sB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BXIP2sB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C54C4CEC3;
	Fri,  6 Sep 2024 03:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725593460;
	bh=Jn85Flmv/JtoTFvit5tYDcNgzkMJ2/wjWasPOnbf16s=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=BXIP2sB3rLw0d3xy7c1W3ZK2oZwN2jrZv9QrjCrFmUEKonDd4X4H944HoWGXahEXF
	 RtPnQy2r0O3vBH+eEk+kmeVf+rHsuW8ayBa/dPx/n/g7acQhfB38L/PNjuHoxuuZvn
	 zt75EVD7TYfl4xhaPBcRSolSmnmVLVCk4LCGmpfTVpwm+E2Pdf0xroRfd5FZcxtKkf
	 jm1rnxYFWG8zCDSc3Kesr+Pz2N1VdyPLHjsRGbpGztG3bYCX3sCxh9ff8OOEHeuNFu
	 wmd9MJFUKUu1cDSDORElhKhKzNuGld+DiCV7AznDU94k565YvTm5jaY6LoqlffmmVk
	 kg/S5rPjpjzuA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 015E33806654;
	Fri,  6 Sep 2024 03:31:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] netlink: specs: nftables: allow decode of
 tailscale ruleset
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172559346184.1921528.8439228299104942792.git-patchwork-notify@kernel.org>
Date: Fri, 06 Sep 2024 03:31:01 +0000
References: <20240904091024.3138-1-donald.hunter@gmail.com>
In-Reply-To: <20240904091024.3138-1-donald.hunter@gmail.com>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, fw@strlen.de,
 netfilter-devel@vger.kernel.org, donald.hunter@redhat.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  4 Sep 2024 10:10:24 +0100 you wrote:
> Fill another small gap in the nftables spec so that it is possible to
> dump a tailscale ruleset with:
> 
>   tools/net/ynl/cli.py --spec \
>      Documentation/netlink/specs/nftables.yaml --dump getrule
> 
> This adds support for the 'target' expression.
> 
> [...]

Here is the summary with links:
  - [net-next,v1] netlink: specs: nftables: allow decode of tailscale ruleset
    https://git.kernel.org/netdev/net-next/c/e10034e38e9d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


