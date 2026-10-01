Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AF43D34B5;
	Thu,  1 Oct 2026 10:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790850011; cv=none; b=AXrDzyOK4vvDR4RO9q2v7Q7ECkpuhwfok+qhL9CBcviGDGDNuxSgaYTG+4cegCgN6WW8xZ/TEqBlM9ZFR2PtD3kERlLMFt3XOp939OebXSsT46uCsV3qqq96tOSFrbKC09nJyaMfEqkaeAjYxwaz66TmLRupzJPyd0+BS4SvlQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790850011; c=relaxed/simple;
	bh=MxcVaPaX0iNEmypsL0yS/XkK6FcomH9DfpIS6R1JzTg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ofrmDl8KM2ALH6v55kAD97Rb2IMjDJYV6wSibO7FD8fqoc+ETy2zJNOH6LvP5sIC+zC3fcl5O8zTE8uGfI8+/StyCMjBLC+BSk4vd43mHp1VJiKDWbuhohJpFTFWmi4dLNCpZncQ0bY/F5tPGCl6kYOm8WSfO2RdfgMkfFpPxwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NBr9rCoN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NBr9rCoN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804E81F000FF;
	Thu,  1 Oct 2026 10:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790850008;
	bh=6xUTZqjQwyriADZXCJ4QmVJCFXAcUz362WB2NE+83j8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=NBr9rCoNdI6PMjqXY5sB3Wpch4pu0ER7TH/bbg1/kGqzMfEOisM0M1DDQCQ/eabRC
	 zIKRosjpvKMAk+iUeNHm099oAzCDgKQ/A83Zd1g+3JQA6BG0kQRUdG0mnYo3spDctO
	 rhmZY/I5UWhFNE7et2bqMlV0Q1PpDFpm/oOZa1v5aXRqhg3kFTId8GcQMQzYqZLYEd
	 ntYaVXScvxnQndoOZPWS7Egetc8D1HEO1mivpEraO1YJ7W/LjR8ChAH+Uo0tlpFVs8
	 SDVpfnTUSb9hCkdsPvuT9cSzMjgJHzNTFtdYTQdHDG3/aTVNJx0jiUbjjEXgMF3G7l
	 IAmyZ+jX1OlZw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 77530380DBDB;
	Thu,  1 Oct 2026 10:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/10] netfilter: ipset: do not update comments from
 kernel-side adds
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179085000728.2376882.9865371323959649985.git-patchwork-notify@kernel.org>
Date: Thu, 01 Oct 2026 10:20:07 +0000
References: <20260930074142.298353-2-pablo@netfilter.org>
In-Reply-To: <20260930074142.298353-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed, 30 Sep 2026 09:41:32 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> 'Fixes' commit stopped calling ip_set_init_comment() for hash types
> from kernel-side-adds (xtables .. -j SET).  ip_set_init_comment() says:
> 
>    "The kadt functions don't use the comment extensions in any way."
> 
> [...]

Here is the summary with links:
  - [net,01/10] netfilter: ipset: do not update comments from kernel-side adds
    https://git.kernel.org/netdev/net/c/a442c8a89fb9
  - [net,02/10] netfilter: nft_flow_offload: drop flowtable reference on init error path
    https://git.kernel.org/netdev/net/c/747928b5d4ff
  - [net,03/10] ipvs: fix missing counter decrement in lblc
    https://git.kernel.org/netdev/net/c/bdac17779f46
  - [net,04/10] ipvs: bound LBLCR and LBLC cache growth
    https://git.kernel.org/netdev/net/c/2a3c3de660f9
  - [net,05/10] ipvs: do not create invisible templates
    https://git.kernel.org/netdev/net/c/616cf5c06934
  - [net,06/10] ipvs: filter some flags received in the backup server
    https://git.kernel.org/netdev/net/c/f96e91748f63
  - [net,07/10] netfilter: nft_set_rbtree: skip transaction elements during GC
    https://git.kernel.org/netdev/net/c/86b6471e690c
  - [net,08/10] netfilter: bpf: reject invalid NAT manipulation types
    https://git.kernel.org/netdev/net/c/16d464013ec2
  - [net,09/10] netfilter: flowtable: generalize pending status bit
    https://git.kernel.org/netdev/net/c/7c549fb7eecd
  - [net,10/10] netfilter: flowtable: restore ieee80211 forward path
    https://git.kernel.org/netdev/net/c/3ae37eafd366

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


