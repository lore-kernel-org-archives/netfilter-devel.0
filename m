Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BEE244667;
	Wed, 12 Aug 2026 01:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786498869; cv=none; b=QFBWf09Hb0oxdMYIcaDixKQfH15RgA3CJ49cd4ER67CHEAqj9zjvtKLR5352wEzOMhk6CufGgIwNHztCQq7FQOGvhT1kZOfrROjNPcPZMa9xQ0wkdJQnIeE0InGzx2WcqJZ7R3hxGQr6YtIOmtm7DLypDf+hzFXd/vtE7PzJeyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786498869; c=relaxed/simple;
	bh=T+qhZB/2uIcC3qhhu0w/MWaox+C4JaSiRTkN5hcG8lg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=fPDWurWodITvD14OQ7EVqjLEqYhd38hHo82C4nFIGQdYJlDHphykDL/NEnwOXF1ztzvbpXZLEbH6gQ+sDPRI/ezNu8p1PZ/Z7lfiHfvufhrl4FYErN/i1Hp5VHF1p7571neSDA2yQMI8JSjMiUEIgf6xgL2WIRDSKFnLndgTXwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hTIN9dno; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTIN9dno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513371F000E9;
	Wed, 12 Aug 2026 01:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786498868;
	bh=ddCWUmVyP8hp0tbawAOd9Qc7YubzB/SsYlWmcDZsMOE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=hTIN9dnoaqm3i+uCoMXdmeKjxfdHstEjVyEhatr8J1aC0OUzjn2MHCQ29DH+2I2nL
	 I7fKJuv2G3BIjYbIyPw7FMkxOmGLFdPncXRmSxZw/jIXtAeWKftqICxX0apPEHjdYT
	 3uU65DGB7z/Ka7VriO9KAK7nmJjtNb3AJJ8t0zwVrtqr96g+2Eba2KMsewXVYn+ljq
	 j/W2s766qNiR7irV9JkO7Wly8dTrMRZmFaVEVAIzq5EPHjHz7ydLzoZve7qPadr5ae
	 jD4+Ho7SjhXuR7DLNPsgBY7GDDd4AddrkaPkuNR+CE8yt+rOYJ6jnGQLTAXjmXsJbO
	 zFrYfEDP0YAig==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56A0A3809A3C;
	Wed, 12 Aug 2026 01:40:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/13] netfilter: ipset: fix refcount race between
 list:set GC and swap
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178649882389.1230679.84745710900451719.git-patchwork-notify@kernel.org>
Date: Wed, 12 Aug 2026 01:40:23 +0000
References: <20260810190621.894119-2-pablo@netfilter.org>
In-Reply-To: <20260810190621.894119-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Mon, 10 Aug 2026 21:06:09 +0200 you wrote:
> From: "Xiang Mei (Microsoft)" <xmei5@asu.edu>
> 
> __ip_set_put_byindex() resolved the index to a set pointer under RCU,
> then took ip_set_ref_lock in __ip_set_put() to decrement set->ref.
> ip_set_swap() holds that same lock while swapping both the ip_set_list
> slots and the two sets' ref counters, so it can interleave between the
> dereference and the lock acquisition, leaving the caller to decrement a
> set whose reference already moved to the other index and hit
> BUG_ON(set->ref == 0). list_set_gc() reaches this from timer softirq,
> which the nfnl mutex does not serialize against swap: an expiring
> list:set member calls list_set_del() -> ip_set_put_byindex() while
> IPSET_CMD_SWAP runs on the referenced sets.
> 
> [...]

Here is the summary with links:
  - [net,01/13] netfilter: ipset: fix refcount race between list:set GC and swap
    https://git.kernel.org/netdev/net/c/0c8886827165
  - [net,02/13] netfilter: bridge: release template ct on non-IP path
    https://git.kernel.org/netdev/net/c/d45cc8020d7c
  - [net,03/13] ipvs: add totalconns for dest
    https://git.kernel.org/netdev/net/c/04d2feaed8d0
  - [net,04/13] ipvs: properly update the overload flag on dest edit
    https://git.kernel.org/netdev/net/c/8f843441c4e7
  - [net,05/13] ipvs: separate destination availability state
    https://git.kernel.org/netdev/net/c/cdcc4e46180d
  - [net,06/13] netfilter: nf_conntrack: defer invalid log until after unlock
    https://git.kernel.org/netdev/net/c/2d19b95c9723
  - [net,07/13] netfilter: nfnetlink_log: wait for rcu grace period before freeing pernet state
    https://git.kernel.org/netdev/net/c/33d1469b0124
  - [net,08/13] ipvs: clear IPv4 options after rebasing tunnel ICMP errors
    https://git.kernel.org/netdev/net/c/e0ba936287df
  - [net,09/13] ipvs: revalidate ihl to prevent out-of-bounds access
    https://git.kernel.org/netdev/net/c/d93660df4dd1
  - [net,10/13] netfilter: nf_tables_offload: suppress WARN_ON_ONCE for ENOMEM in abort path
    https://git.kernel.org/netdev/net/c/d02f59206434
  - [net,11/13] netfilter: flowtable: publish GC-visible tuple last
    https://git.kernel.org/netdev/net/c/2014ac62df9d
  - [net,12/13] netfilter: ipset: fix list type element drift bug
    https://git.kernel.org/netdev/net/c/4cbd69766b35
  - [net,13/13] netfilter: ipset: let destroy callbacks adjust ext mem size
    https://git.kernel.org/netdev/net/c/490937b88cb5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


