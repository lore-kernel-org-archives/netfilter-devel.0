Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2530113E40C;
	Thu, 27 Jun 2024 11:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719486629; cv=none; b=EntqPIldVBisS6gpECYhBOE2ph+PkkEoylnI9ndc9VdaphIn84s5MxW2AkuB3SLkGfTZsHTo9vlOS87F1zB9WPDtLdwwvqljj6xPDSLS4Pz6G73eaeZmw9fPmZnLX2mPTavZqbJ7Fzct+HkerTgdhbblU7Lq5w7N6Xu3YHu3hFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719486629; c=relaxed/simple;
	bh=5Oejg1SsOEtX3szxfJgKeybMK968kT2ShO2aLKqk5EI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=kfGtncxYCVxA+MGE1lmJNo0lvz/3UoBsjG/4hlmmpt6Vd6Ie9kKE0S9dr1Q2JtdZEcup+GDwnB8/Bx3AOikw8x9YYI4LvA5ErqyB26cscdX0B7l7MvonsWDzjxTd/jh2AjJ54YW+quSNYSDO9OXGB/w1dqfZ5uPDdjRXWOjdZHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q2cGsDpK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q2cGsDpK"
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABE4CC32786;
	Thu, 27 Jun 2024 11:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719486628;
	bh=5Oejg1SsOEtX3szxfJgKeybMK968kT2ShO2aLKqk5EI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=q2cGsDpK59TM2TxjHxvHo7hiLwBR1vau8SJN1WLWSKNmH6MLioc5USwdHEhEQgdcX
	 pRhB9qGNElaRldQIIAzNPjciolcvODvwmWo7lcsdQopbJ/MGwbNlCbij2wblnddAGL
	 0N6dyJJ+Kt+D2UyMMEzCQgaAbkWYfyeLyvxdd06Clhzqyig8O4V4TwzPcYl36fykVg
	 DwmYpwPXTYNAWKkxzBjTHt0Ci/qtXwmFMk1GXr48ZA05YunrWuY9xsWMOVuFMIuQDS
	 Y+2UIkXWo7sUa9X0VM/xZcNmx8OaH0ToAR9gVRm+x3e0ebcTa/eGFWZ/+Rm0rfGDfM
	 9vaPOK9KtZNGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9BB5ADE8DE0;
	Thu, 27 Jun 2024 11:10:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: fix undefined reference to
 'netfilter_lwtunnel_*' when CONFIG_SYSCTL=n
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171948662863.18078.5867641588662636382.git-patchwork-notify@kernel.org>
Date: Thu, 27 Jun 2024 11:10:28 +0000
References: <20240626233845.151197-2-pablo@netfilter.org>
In-Reply-To: <20240626233845.151197-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, torvalds@linuxfoundation.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 27 Jun 2024 01:38:44 +0200 you wrote:
> From: Jianguo Wu <wujianguo@chinatelecom.cn>
> 
> if CONFIG_SYSFS is not enabled in config, we get the below compile error,
> 
> All errors (new ones prefixed by >>):
> 
>    csky-linux-ld: net/netfilter/core.o: in function `netfilter_init':
>    core.c:(.init.text+0x42): undefined reference to `netfilter_lwtunnel_init'
> >> csky-linux-ld: core.c:(.init.text+0x56): undefined reference to `netfilter_lwtunnel_fini'
> >> csky-linux-ld: core.c:(.init.text+0x70): undefined reference to `netfilter_lwtunnel_init'
>    csky-linux-ld: core.c:(.init.text+0x78): undefined reference to `netfilter_lwtunnel_fini'
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: fix undefined reference to 'netfilter_lwtunnel_*' when CONFIG_SYSCTL=n
    https://git.kernel.org/netdev/net/c/aef5daa2c49d
  - [net,2/2] netfilter: nf_tables: fully validate NFT_DATA_VALUE on store to data registers
    https://git.kernel.org/netdev/net/c/7931d32955e0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


