Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A48C332918;
	Sat, 13 Jun 2026 17:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781372423; cv=none; b=DF5pAVn4bc/SrMaJi8S4Wq46DL84Ebt3vzqsSKKVRx9hoRg07xJWLrZ5SmF/+61x9gOYt4aaOBFFRu1i8NxiJ8McB+ehmsLgJ6zLfGUOdhSrqCiz+foAmdc0PLNHodFDi8dYLMfG2cSiCzFTDBXIUq5UdSdxn3H5ItryZ1lS2Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781372423; c=relaxed/simple;
	bh=rUeg1ZKNDg4sZMy1M00+36OnPn0IldEcIoI9eh/dCE4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=anollupq5Zv6ilgy2o6rSBsxKq5eLnz9oYXxSXjppsWWYv4tjuwhQ6Ndkdy4wGOgbdLTvlXlnj8GCygcMkuEcGVM1tFZ8xsX7OWC+3isYn/t6nZXD6rbfJAnJ1E10iG9ItmRctcdwZG+eg9Vw15KT08axeQoeB8vgWV3lL9eGh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fz3vbeFc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fz3vbeFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242A41F00A3A;
	Sat, 13 Jun 2026 17:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781372422;
	bh=dxcPUJbOUwkArImBh9pKeG1lbvw/ZkyJ0GIqD1Q+2xU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Fz3vbeFc+6NlhgIa/UqkGW2TtuJ36sPv5uwEHdYk3ta0Xz1+HsoRBzE1Kg6Xn3yww
	 q5qVI1/3CRT2ERKf2LCkvXvd8Cekg6zU+MTJeYavpmvquB5Vp6ZIQhfqwxu0jGEclV
	 7b5zBH0MbSLLU8+jMLTS28HnzocF/y/heTul7UERrbSN0DYgk7ztuOlzC+P3sWiZIe
	 mMz6UM5JTnbVSZ1nm9O9ef8GKoj5uAg+zPicM1tXqC/juHWgm6yO5OsH516lC5P7kt
	 kFrlGnHCpcTEVkNxDc7lEa8MUnvAIG1SnP36pV0nac3tEfLUYPKYNyET+iBmlZLwoG
	 QQBAj5iggsI2g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 939713A40FD9;
	Sat, 13 Jun 2026 17:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/2] netdevsim: add fake FT/CLS_FLOWER offload
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178137241813.1545867.485015591993745968.git-patchwork-notify@kernel.org>
Date: Sat, 13 Jun 2026 17:40:18 +0000
References: <20260612092209.11966-1-fw@strlen.de>
In-Reply-To: <20260612092209.11966-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 12 Jun 2026 11:22:07 +0200 you wrote:
> v2: fix up error reporting via extack
>     shellcheck cleanups
>     sort config toggles
> 
> 1) Enable nf_tables offload control plane testing in netdevsim. Tag
>    existing offload fn to allow error injection for testing rollback and abort
>    logic.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] netdevsim: tc: allow to test nf_tables offload control plane code
    https://git.kernel.org/netdev/net-next/c/07ca2ab4ce84
  - [v2,net-next,2/2] selftests: netfilter: add phony nft_offload test
    https://git.kernel.org/netdev/net-next/c/5394aa0bb00d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


