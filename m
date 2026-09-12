Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6682472618;
	Sat, 12 Sep 2026 00:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789171273; cv=none; b=hK7tHbPf7k71/oSrj3XOg8ItUCmzA7sxazyNUPhrjquscYCCY9ibT6yT1IM++1VUHOaNZJxvnlVQnRKOjD3zO/uEjWbXTEC03pf7x2WXL3gyrJzxLTaQaPft6PkoNB/aehSOlaYHF3bB1HfRktcakR5OMFPugV/0tm8UJc4Twao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789171273; c=relaxed/simple;
	bh=ias3orlQOVGhgvtygaq7mlbWlUdw+FHnfAjGlIDxzKQ=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=gK9BFw3CcS5cx4IPs/q0A/L+dm9yvdmOi4PEHRLo72uuLYC23VAyocVZsDVO4JxVW1NibwDDdgrnLvyH/sWxmaPRcjkBcIy+ybtCBjVUwAF20xNbNLZO8gzpJWdqbC/WAmfSqshkMLrdkgFvowKxFB3IotItVpSjfXu4RJOdrGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iSEISiB2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iSEISiB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724071F000FF;
	Sat, 12 Sep 2026 00:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789171269;
	bh=Xye9fWl0NprshaDkSXHnPwGcRpNe4YR+sZgVP06S7k0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=iSEISiB2gv4u+XhCtCGMVQQXZ54zw8gFEcB8BEbfYbD7mPyrZAcyW4hB8pGOgD1es
	 w92ubWeDfTlb4C8mPtkomUoTfv5i0s8EGZFV6oeYUKsCzqbJvD7M8o/LV/HQ5JeYNP
	 VhTWIDM+I9yqq1fQ2/6LwLFAZ0TfPbyT8ygNitIExObvUVRT8KGYU8BzEB5v2VQK6u
	 b5SE/1z5HHBX0Mc3SYMGyCSPpJVVDAsQJMrJWOCpf8uZ2rymy1TTbxG1EyTA2LKQY9
	 L9TAkhXaW5uaJHxqHTJV1EdKrAX0A5M9POw/XkyBKryIhiVQiMUAAVwHkG2Irm5NhC
	 rGIfXJCHqOsaQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 567C8392445B;
	Sat, 12 Sep 2026 00:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] netlink: specs: conntrack: minor spec fixes
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178917120589.3168051.14265843320183598835.git-patchwork-notify@kernel.org>
Date: Sat, 12 Sep 2026 00:00:05 +0000
References: <20260910003852.2184031-1-kuba@kernel.org>
In-Reply-To: <20260910003852.2184031-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, andrew+netdev@lunn.ch, horms@kernel.org,
 donald.hunter@gmail.com, ast@fiberby.net, i.maximets@ovn.org,
 one-d-wide@protonmail.com, fw@strlen.de, pablo@netfilter.org,
 netfilter-devel@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  9 Sep 2026 17:38:44 -0700 you wrote:
> Clashiko raised a bunch of pre-existing issues on a recent series
> from Ilya. Let's fix those and whatever else pops out in AI review
> and looks relatively legitimate.
> 
> Jakub Kicinski (7):
>   netlink: specs: conntrack: timestamp is a nest, not a be64
>   netlink: specs: conntrack: fix the get reply attribute lists
>   netlink: specs: conntrack: fix SCTP conntrack state names
>   netlink: specs: conntrack: fix the nat-attrs attribute IDs
>   netlink: specs: conntrack: describe CTA_HELP_INFO
>   netlink: specs: conntrack: fix the per-CPU stats reply
>   netlink: specs: conntrack: tweak definition of obsolete attrs
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] netlink: specs: conntrack: timestamp is a nest, not a be64
    https://git.kernel.org/netdev/net-next/c/68fd293d99e4
  - [net-next,2/7] netlink: specs: conntrack: fix the get reply attribute lists
    https://git.kernel.org/netdev/net-next/c/19be13c9c1e9
  - [net-next,3/7] netlink: specs: conntrack: fix SCTP conntrack state names
    https://git.kernel.org/netdev/net-next/c/924c8a610d3a
  - [net-next,4/7] netlink: specs: conntrack: fix the nat-attrs attribute IDs
    https://git.kernel.org/netdev/net-next/c/58c7df883ada
  - [net-next,5/7] netlink: specs: conntrack: describe CTA_HELP_INFO
    https://git.kernel.org/netdev/net-next/c/6c98fd455ed5
  - [net-next,6/7] netlink: specs: conntrack: fix the per-CPU stats reply
    https://git.kernel.org/netdev/net-next/c/f869aa4ceaa2
  - [net-next,7/7] netlink: specs: conntrack: tweak definition of obsolete attrs
    https://git.kernel.org/netdev/net-next/c/55edd9e55711

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


