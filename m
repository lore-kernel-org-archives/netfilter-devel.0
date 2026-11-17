Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794914409;
	b=n5tRx/IURG74bMxj250Ho5kIeqJBN9zTskqFsVmIfcxgu7Pc2tDDG0XBNTOkaoDAZHBj
	 /CLUn+0c7b1JEHtcO1v2XxDaTioTgliS00DnSg8r6oDdtUj49yKchPHIMT5fvva1nEhh1
	 XFRspAum/Fg7jr1hCkUsnIGrQaT9Od+q8fQyb6X/UvueavBfXdEYyMd6HZA4g6S8D4wH+
	 +jQFj80r+bacN3mlH7+KlywhpfkTHTkAJqodPj63Ze6TAY2TEBnW7noBUGW4c3JMH8w/O
	 5zAgoUa42uWUXb/KZ7VBFSVoODZlhG2oNFj8ZhCCaRfQCiLH6RriFVOZNomIel6zL4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794914409;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=3QISyfluSWeK3oqNp9QI7n3lx/wBWLiQ5O5kI6oT/ys=;
	b=hM0sichkX/xnrXpmw0zp54TlS14NuF3ICHCsDCaA45XkToftH86i/CU17FuwKYrwQjeP
	 yK1TTnpyz+usGlqeTW0ssQT9v250U5y+ntQjVHIThA0nAUh8j3Xs7/Rs1IDAqVHF/ojPl
	 8nky4USCRutnr4D7sJT2gFsqM0hJPqhZodIiX2lVHHpTGhDz7uswuJw8PSMSGamFITgc5
	 XE0alQ5B82xEUF/knrYe7yLBlWl8+S3UT+U6jOkYfrgesg4kNSHhpvm+CqfCghToHOr22
	 dgIDRT8Wtt8evvxX9sM/CXsQH+ckNrAEnUtc0yHlKOncCYH//S9uhMUMG8I1sHua2Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Hg/F06sf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44FB606A33D;
	Tue, 17 Nov 2026 11:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hg/F06sf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4801F000C4;
	Tue, 17 Nov 2026 11:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794914408;
	bh=3QISyfluSWeK3oqNp9QI7n3lx/wBWLiQ5O5kI6oT/ys=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Hg/F06sfTWfaJWN7o1Dn96e+3Uskfd67754EJkWCS871ZCwlbPJmTUCdZcdALfbms
	 zHECvi/1ItNh2tyALO4EcTiHRODocYGo739yKwyVB4yy2H/CfsmH0aWUDX1mqOA8ni
	 yHyA4fOtTk8LGWm1yA+eJZGCa4tGfNTfEOXaMjg7MRu0yQYFJh+usjDtnC2t1XVC9/
	 H/kz8PKTeoJC1NYZ8kiwngsQKBbJXhRYvCnfDmnh0jtxBNG3yW2vN4+wFDiFLwC9Vp
	 pHtLdb3cKon0+yNAhFBeXyfMnWO5lCxcQxAG8MjyGffez/ceK3Pk93rpVfYgcbdErL
	 W7bA3lh++/EXg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B449E392665D;
	Tue, 17 Nov 2026 11:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/13] netfilter: flowtable: do not hw offload
 flows
 in teardown state
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179491440753.514086.6452925778003138386.git-patchwork-notify@kernel.org>
Date: Tue, 17 Nov 2026 11:20:07 +0000
References: <20261116001612.2806263-2-pablo@netfilter.org>
In-Reply-To: <20261116001612.2806263-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Mon, 16 Nov 2026 01:16:00 +0100 you wrote:
> Sashiko reports that refreshing hw offload from packet path is racy
> since the flow might be already torn down.
> 
> Since commit 7c549fb7eecd ("netfilter: flowtable: generalize pending
> status bit"), GC skips flow entries that are still pending to be
> offloaded. Let's just check for the teardown status bit after the
> pending bit is set on to address this race.
> 
> [...]

Here is the summary with links:
  - [net-next,01/13] netfilter: flowtable: do not hw offload flows in teardown state
    https://git.kernel.org/netdev/net-next/c/0abb54363974
  - [net-next,02/13] netfilter: flowtable: retrieve stats on flow deletion
    https://git.kernel.org/netdev/net-next/c/2785eca574b0
  - [net-next,03/13] net: ethernet: mtk_ppe: update stats on flow deletion
    https://git.kernel.org/netdev/net-next/c/272435e43f1c
  - [net-next,04/13] net: airoha: update stats on flow deletion
    https://git.kernel.org/netdev/net-next/c/0602fe6ca35c
  - [net-next,05/13] netfilter: xt_time: fix monthday computation for dates past 2039
    https://git.kernel.org/netdev/net-next/c/71d4a4199524
  - [net-next,06/13] netfilter: nft_flow_offload: do not offload multicast
    https://git.kernel.org/netdev/net-next/c/b0ca1ef87626
  - [net-next,07/13] netfilter: flowtable: purge entries immediately when destroying the flowtable
    https://git.kernel.org/netdev/net-next/c/1ba460c8e20b
  - [net-next,08/13] selftests: netfilter: nf_queue: drop the no-op loop initializer
    https://git.kernel.org/netdev/net-next/c/f1eaa9155e69
  - [net-next,09/13] netfilter: flowtable: do not scrub as crossing netns
    https://git.kernel.org/netdev/net-next/c/4733af7f19e7
  - [net-next,10/13] netfilter: flowtable: tunnel device poisons h_source of fast-path frames
    https://git.kernel.org/netdev/net-next/c/ada5902116b4
  - [net-next,11/13] netfilter: flowtable: do not clear the offload bit twice
    https://git.kernel.org/netdev/net-next/c/8147f6e61e16
  - [net-next,12/13] netfilter: nfnetlink_queue: make skb writable before writing NFQA_L2HDR
    https://git.kernel.org/netdev/net-next/c/3abad1970ab4
  - [net-next,13/13] selftests: netfilter: add UDP flowtable offload test
    https://git.kernel.org/netdev/net-next/c/03b7948d634a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


