Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864592594;
	Thu, 20 Jun 2024 09:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718877031; cv=none; b=mLnvQR6e1RyKePMgYsaccNPTCfEcJo9eXzkRC8PNHemeRpPLLCjMh26wUurbtNmioW4SzL/6wIpyJmczqAby7Wme52Ljkt3zt/wdUh+c6ToP/HbbrsyRFz4GQzOVIGW1EUKb2mG+AvB2HlgKdzXlG9C8xKjW+V7h+5bx9/x3JiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718877031; c=relaxed/simple;
	bh=QM4AWPRAmU66BJkQ2o3/X9nt9L9MzrenZv8eHQz1Ieo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=A9O3DEfDQmlvhlBSa0yghgwQlFZ7377IvsXrZuY4IG+RG6cagMTgbYEWEDc+CGp8PuDEHGfglheMxriRsVPrInmj9SbBpKAdz9nzkAqbuDyVOvTMG/obxBAYaJF5GjFad5LHWlzvKTe+evBv3v0fXvEi9CKksQkqu1GA1v0vWiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ty2qyrsI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ty2qyrsI"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D16C1C32786;
	Thu, 20 Jun 2024 09:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718877029;
	bh=QM4AWPRAmU66BJkQ2o3/X9nt9L9MzrenZv8eHQz1Ieo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Ty2qyrsIm+QruKBzN6FAeYgNuIcg3DpW4/wwh637AjZJsPIJPPhULIdKCE1BcRPsu
	 5D8s61CalOpkaSyurXfgdHjg8xuuaOLwYr4u00OBgxXt+sp6N+e1z1XNrbwWcEA1eR
	 6ng/SVVot3/sw7rT+m+PRRJt2OkY3Dj8WTG5T0o5uOMUCjDmd0k+zIooLxBBk6vVal
	 iHzRYIl3U8+buHyrRHdXVGWA23vesKhPZp6SK/5BhgLDc/u1ma1+Cgorc6UlEA8hwI
	 dzZPAJNQlEh8BYgOXugrDkcXBUoX59/RC9qc9Rkk8vqPrjVGMDfR/d9g0h1l8/vVfu
	 p4wMHAVyLuYwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BDE90C4361B;
	Thu, 20 Jun 2024 09:50:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/5] netfilter: ipset: Fix suspicious
 rcu_dereference_protected()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171887702977.31092.1392589394885079396.git-patchwork-notify@kernel.org>
Date: Thu, 20 Jun 2024 09:50:29 +0000
References: <20240619170537.2846-2-pablo@netfilter.org>
In-Reply-To: <20240619170537.2846-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed, 19 Jun 2024 19:05:33 +0200 you wrote:
> From: Jozsef Kadlecsik <kadlec@netfilter.org>
> 
> When destroying all sets, we are either in pernet exit phase or
> are executing a "destroy all sets command" from userspace. The latter
> was taken into account in ip_set_dereference() (nfnetlink mutex is held),
> but the former was not. The patch adds the required check to
> rcu_dereference_protected() in ip_set_dereference().
> 
> [...]

Here is the summary with links:
  - [net,1/5] netfilter: ipset: Fix suspicious rcu_dereference_protected()
    https://git.kernel.org/netdev/net/c/8ecd06277a76
  - [net,2/5] seg6: fix parameter passing when calling NF_HOOK() in End.DX4 and End.DX6 behaviors
    https://git.kernel.org/netdev/net/c/9a3bc8d16e0a
  - [net,3/5] netfilter: move the sysctl nf_hooks_lwtunnel into the netfilter core
    https://git.kernel.org/netdev/net/c/a2225e0250c5
  - [net,4/5] selftests: add selftest for the SRv6 End.DX4 behavior with netfilter
    https://git.kernel.org/netdev/net/c/72e50ef99431
  - [net,5/5] selftests: add selftest for the SRv6 End.DX6 behavior with netfilter
    https://git.kernel.org/netdev/net/c/221200ffeb06

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


