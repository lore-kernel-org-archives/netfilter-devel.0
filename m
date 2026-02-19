Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55C41F37D3;
	Thu, 19 Feb 2026 01:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771464025; cv=none; b=FE6vO7vCYpl5xRrB+GE3TbVDMT7Pp67KzdNFA/zE9tWYJcJUIl+PlDmfk8pb1OuPMbliYKEow4C2YFo06LVDSPlrvrbIVUjOuZRtgTNviTO4JSn2nzZvZHeXGxKPgk55G3GAhK6okGpKPe8rmskoXASxFRs3k15KVd3FaMiczEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771464025; c=relaxed/simple;
	bh=opx5HQqNWXsOMj+26IePzG4gQnO0sFQCgThHDAvQObU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=gcEhjP4yL9QNL8Ha2xJLjSEdw/NAGWW6pZBUtSWUV/UxN/WkUjWa2chXapxXk53A9vykU6RSjvBEAJj/2Ozd56HMhLpZMwaqDZ+zgFiUbRvws6wbJc50Nk19q8BmyJ6mnqX1hiUh3WzGIwlO472Qze8M1ZLen/1/VLZ/WS0LESY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MkZclhtl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MkZclhtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600AEC116D0;
	Thu, 19 Feb 2026 01:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771464025;
	bh=opx5HQqNWXsOMj+26IePzG4gQnO0sFQCgThHDAvQObU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=MkZclhtl7Gi+zzxJHYXdO7AtqKZzIqJbSieMALUX2WtX+u3Xx5egkCu833r4iYTvd
	 rq5u6CEhzklAgb2Ehy3TjOiFuPxYqjOU/l2NH2QOWz5ucdLLcG96VMBLjH9aqmObhq
	 4FUVDICqdoyHBnXYzf05YqyTOZk1Mqbw4kPFRrkUdTmDIBZU92N8yWP3ghW9OvH4q/
	 RdUUynMZMowLKtBLDYXWAhjOi1qZZRvEV2BtMNICwd7SP8NaaEVPQNS9aHjttnojP+
	 +9JoFk848Jg1P2NiZYirspjPJsUmNAyage1ZusihrmdYS7g9Wn23Rsy4pT7+Sr2h+f
	 PgJH3+M0DKxKg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id C2291380CEE0;
	Thu, 19 Feb 2026 01:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/10] netfilter: annotate NAT helper hook pointers
 with
 __rcu
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177146401658.1625981.7919315366165441134.git-patchwork-notify@kernel.org>
Date: Thu, 19 Feb 2026 01:20:16 +0000
References: <20260217163233.31455-2-fw@strlen.de>
In-Reply-To: <20260217163233.31455-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Tue, 17 Feb 2026 17:32:24 +0100 you wrote:
> From: Sun Jian <sun.jian.kdev@gmail.com>
> 
> The NAT helper hook pointers are updated and dereferenced under RCU rules,
> but lack the proper __rcu annotation.
> 
> This makes sparse report address space mismatches when the hooks are used
> with rcu_dereference().
> 
> [...]

Here is the summary with links:
  - [net,01/10] netfilter: annotate NAT helper hook pointers with __rcu
    https://git.kernel.org/netdev/net/c/07919126ecfc
  - [net,02/10] netfilter: nft_counter: serialize reset with spinlock
    https://git.kernel.org/netdev/net/c/779c60a5190c
  - [net,03/10] netfilter: nft_quota: use atomic64_xchg for reset
    https://git.kernel.org/netdev/net/c/30c4d7fb59ac
  - [net,04/10] netfilter: nf_tables: revert commit_mutex usage in reset path
    https://git.kernel.org/netdev/net/c/7f261bb906bf
  - [net,05/10] netfilter: nf_conntrack_h323: don't pass uninitialised l3num value
    https://git.kernel.org/netdev/net/c/a6d28eb8efe9
  - [net,06/10] include: uapi: netfilter_bridge.h: Cover for musl libc
    https://git.kernel.org/netdev/net/c/4edd4ba71ce0
  - [net,07/10] ipvs: skip ipv6 extension headers for csum checks
    https://git.kernel.org/netdev/net/c/05cfe9863ef0
  - [net,08/10] ipvs: do not keep dest_dst if dev is going down
    https://git.kernel.org/netdev/net/c/8fde939b0206
  - [net,09/10] net: remove WARN_ON_ONCE when accessing forward path array
    https://git.kernel.org/netdev/net/c/008e7a7c293b
  - [net,10/10] netfilter: nf_tables: fix use-after-free in nf_tables_addchain()
    https://git.kernel.org/netdev/net/c/71e99ee20fc3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


