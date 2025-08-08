Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0692C1F1317;
	Fri,  8 Aug 2025 18:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754679003; cv=none; b=O7mwodBp0LZf3aSqxwBfYEncSWbn79EGoRDL2jTanggQC2zmNRdAU3/x5N3kt7LkYGyNY3Cp1nK3vTyAigzAqy5oKeTG2pXVIWrYSGnBwieAWhM1n0hOgdPBa1lx5Z+H2eo6/PCwcJrq66KTQ3tPBF5w6yLWtkjx18uV0iWydaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754679003; c=relaxed/simple;
	bh=fnWtwW0wfggDVHKFx3Huq8TZ0yT+EucVO8J2pjU5PBI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=c+tTm3DwTHBeKHu6nRXY0yBUt5G3DeBZYTelVrXn2PtzHGBKTp3oU6ORIrEdmJxy4JuhkHkpy8VXDMJKgvrYgKKxTibX0tJ8bhRlQIElRezhetLGujTxGp/X72ScmJtdz5EHQi17kVjOVcqPoDQlDNVNsF1h9BQH5+05r0MNkHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I/fWEduk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I/fWEduk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82180C4CEED;
	Fri,  8 Aug 2025 18:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754679002;
	bh=fnWtwW0wfggDVHKFx3Huq8TZ0yT+EucVO8J2pjU5PBI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=I/fWEdukJ+XYaeB0+zkq4tqb4/3xPDsdmSCxzfqdw4shrPTrhSXwCKmLsxIZq9qky
	 IRrielCw40h/vX+NKnm4qeQdau+1vd0uXlWkTAFzvhmAAn+eASHaLO1iaRslg/e3ML
	 NA8/yMJ1DzAsV/BRNA/Ye/acorOyBFXM0waMJSR6JXktY49tdiOOVkWGSmtHN0K0/4
	 v6+2yP4AbtBiJem5cgkPvk4ckd2Jw5PomXqoEmqXiRGupuXaddy5udaNocEUBAVu5v
	 1n9WCAwD/d+JR70fOCrYcY3JaZAJLGOqqzIFUJsDKsnIFHq3ruCoVn1ttb5uHfQkl/
	 FPe5qwpDvs9mQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAF20383BF5A;
	Fri,  8 Aug 2025 18:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/7] MAINTAINERS: resurrect my netfilter maintainer
 entry
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175467901577.231968.2283299992667493309.git-patchwork-notify@kernel.org>
Date: Fri, 08 Aug 2025 18:50:15 +0000
References: <20250807112948.1400523-2-pablo@netfilter.org>
In-Reply-To: <20250807112948.1400523-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu,  7 Aug 2025 13:29:42 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> This reverts commit b5048d27872a9734d142540ea23c3e897e47e05c.
> Its been more than a year, hope my motivation lasts a bit longer than
> last time :-)
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/7] MAINTAINERS: resurrect my netfilter maintainer entry
    https://git.kernel.org/netdev/net/c/f752adfaf5f7
  - [net,2/7] netfilter: add back NETFILTER_XTABLES dependencies
    https://git.kernel.org/netdev/net/c/25a8b88f000c
  - [net,3/7] netfilter: ctnetlink: fix refcount leak on table dump
    https://git.kernel.org/netdev/net/c/de788b2e6227
  - [net,4/7] netfilter: ctnetlink: remove refcounting in expectation dumpers
    https://git.kernel.org/netdev/net/c/1492e3dcb2be
  - [net,5/7] netfilter: nft_set_pipapo: don't return bogus extension pointer
    https://git.kernel.org/netdev/net/c/c8a7c2c60818
  - [net,6/7] netfilter: conntrack: clean up returns in nf_conntrack_log_invalid_sysctl()
    https://git.kernel.org/netdev/net/c/f54186df806f
  - [net,7/7] netfilter: nft_socket: remove WARN_ON_ONCE with huge level value
    https://git.kernel.org/netdev/net/c/1dee968d22ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


