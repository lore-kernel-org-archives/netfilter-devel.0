Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C263156C6A;
	Tue, 15 Sep 2026 00:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789431071; cv=none; b=QJvDAbR1A/zTM7XY7MtrQPGIqWP/+z8rOBz8z3o4WMBzpPBnnyaagXsPEwDSXtdTRCk1vXuo9WmTREMN4VTHZKzvZt80FOrJNQrbM5R/fNxH6P1+xeTnv5QfcjqpWY08hroWPkdxw4grCZpf0hGJsl3h9aSJC47yDYvOVL6KzgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789431071; c=relaxed/simple;
	bh=Z4Hz7JBQ5tJagP+ExIFAifZln9PTSf/VEZlcidtaVWk=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ZzvXZg46EsitKN3eZggbnzvbUoRTFh6uZv2OLVWTLC3SCo6Yj9yJc+HslyDYuGIjWglXgEhsg/VF/N4d814IW5p6X9Klfo66bLxBwwDLeXIl75+ZyNYQ97D9fAaiIJeHXTw3VqBtSbodDjrewSAUOtydHsb18gDMkmIyRkvlnwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VGOdJ3th; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VGOdJ3th"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF461F000FF;
	Tue, 15 Sep 2026 00:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789431069;
	bh=6u3AXribY+xOVzl9JQAbttDg3drbzNDZQOK4h/VGwkk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=VGOdJ3thBGY3ZzHHzDqn8LWrpgmdL6GD2l/skpXKBJV78GqjBS3ZFKKzyQjXXSKWF
	 JDR1uX/nslFsXZiaMlpmT8osTHEAC/mORHBGYa4NY1EZjd7TpL56dpaMb1wv7wygrp
	 YKe0u5T3tgCck7m51iSiSTj2UFljq8pj6LoX6WvGFbBwUZaGg9YJuD9ZFpl/p/axLd
	 ODnKEjm0vKv7jRrwK1bZ/XOSRkVsje2IkudRqUt+7+19H2LkNqeOC3Dsfk36xOpwPs
	 ttHL/cW6vRhWl3EVCT7QjdyfNUIH7/0xW+AC0fMvoPxADW6MTrK1+1I13fb3ArIA8r
	 +nsX+NYDfAoKQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1982B3924FFC;
	Tue, 15 Sep 2026 00:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] netfilter: nft_nat: fully initialise new_addr in
 netmap setup
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178943100488.1280100.17140596783862403759.git-patchwork-notify@kernel.org>
Date: Tue, 15 Sep 2026 00:10:04 +0000
References: <20260913205447.1889203-2-pablo@netfilter.org>
In-Reply-To: <20260913205447.1889203-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Sun, 13 Sep 2026 22:54:44 +0200 you wrote:
> From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
> 
> nft_nat_setup_netmap() builds the mapped address in an on-stack
> union nf_inet_addr. For an IPv4 mapping it writes only the 4-byte .ip
> member and the loop runs a single 32-bit iteration, but it then copies
> the whole 16-byte union into range->min_addr and range->max_addr, so the
> upper 12 bytes reach nf_nat_setup_info() uninitialised.
> 
> [...]

Here is the summary with links:
  - [net,1/4] netfilter: nft_nat: fully initialise new_addr in netmap setup
    https://git.kernel.org/netdev/net/c/d313499df661
  - [net,2/4] netfilter: nf_tables: fix device name and prefix match in hook lookup
    https://git.kernel.org/netdev/net/c/444e4c88c9c6
  - [net,3/4] netfilter: nf_nat: unregister and release hooks on error
    https://git.kernel.org/netdev/net/c/cbdd39ce4253
  - [net,4/4] netfilter: flowtable: hold reference on ct until flow is released
    https://git.kernel.org/netdev/net/c/e75a9fa1d44b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


