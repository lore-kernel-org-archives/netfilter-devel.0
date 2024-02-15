Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2A7127B41;
	Thu, 15 Feb 2024 12:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998430; cv=none; b=TV0sL9ksLwPjQMEtaF8XYbLG2PrN84se4BhJlJh4R36S9DijwKehfliRTsSWHxLzwYeUo0+vRr1CsvS7nxxOdCFt8ITKmpXMQIlCSM+goILEZXRJ5vMI8s/Gp8pkgEW2Lnbe/0+ppqAez6DG6HEAnbxiiaaHWWtfK/aR2Ho57uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998430; c=relaxed/simple;
	bh=DHW3C+64jmmSfZFOE/8Y4iLv3jCq13zqC85tH3raEyg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=cQmEEcIPq7C4687RkTecMaPSD114Y9cmYa8eUiP2z7JFzIu2Rf7jk9N13t5Ovp5cFo7h+69bHnb3WQ3h7w6spuEo+gVdF3EA3Z5XMmpqd9DGxQWMOKcbGPJ7pqvGN93UZlRbHskSJUm+ixvzn0VjAHtlD8eXKuV8tE2G29wgrcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NkWBCSxI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NkWBCSxI"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F3BFC43394;
	Thu, 15 Feb 2024 12:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998430;
	bh=DHW3C+64jmmSfZFOE/8Y4iLv3jCq13zqC85tH3raEyg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=NkWBCSxIhhzUIjJwDqXNSWq03CneWMtDFpcZ3njLZe/K6B+VpBGHdX2tyrt+hMf14
	 nc4SBG//IAuTTxs72vQ/YQWIxPBoIxhYbza0buV9eSLYzqgMzpqTZwBC0bJIzy8GnP
	 ZG8E6pfWGVqIyiiMJFtYzUNCQz+A4lQI256U6VudgoF2NUax4Rwt0XoE41KZEzx2hS
	 8Buhz/5NUh59r7accEJtKUkRaQ83OQJ6fZeEKvIQbx2oqMTZWZbFlugNW393kUps6o
	 O25cPywXUI3GSgvgBYgqGjVs8NmoELBhwtn9ecDv6OcKPnLrCFCr+v9NQUcHuihD4C
	 Xhfj8sRbVqvRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EAD52DC9A04;
	Thu, 15 Feb 2024 12:00:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nft_set_pipapo: fix missing : in kdoc
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170799842995.25035.6533883181787398770.git-patchwork-notify@kernel.org>
Date: Thu, 15 Feb 2024 12:00:29 +0000
References: <20240214233818.7946-2-pablo@netfilter.org>
In-Reply-To: <20240214233818.7946-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 15 Feb 2024 00:38:16 +0100 you wrote:
> Add missing : in kdoc field names.
> 
> Fixes: 8683f4b9950d ("nft_set_pipapo: Prepare for vectorised implementation: helpers")
> Reported-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nft_set_pipapo.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net,1/3] netfilter: nft_set_pipapo: fix missing : in kdoc
    https://git.kernel.org/netdev/net/c/f6374a82fc85
  - [net,2/3] netfilter: nat: restore default DNAT behavior
    https://git.kernel.org/netdev/net/c/0f1ae2821fa4
  - [net,3/3] netfilter: nf_tables: fix bidirectional offload regression
    https://git.kernel.org/netdev/net/c/84443741faab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


