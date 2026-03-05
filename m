Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107DF281503;
	Thu,  5 Mar 2026 10:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772707916; cv=none; b=jYI0NZkE/ZEgRbatdRyvNG/KBvvzJ1iWpgEFLVV7EcW05HqpDpvY0itONf9V1jhdYyqHregX6VGe+vHZSZa/2p5BdEyQKSCsavxCs8W9M2qPhB/XRdqwY9Qlfhr2xuIEevsNpVc7UhD1tlZM0a1ZGMB2cBCW6b6a68jWcVwYJnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772707916; c=relaxed/simple;
	bh=4c1epKkFsV74Msuv0gsotVAH83GwgolgavSsSMFv0/o=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=b++Xg5iiumC7kPGQh6JPBx31jcoQXJwudZZkm13qd426a7v5wZ+CjZCZ6OcmUMKhi9GzrtylKf6x1p2/6ioL+jcvXR5MSR4QNUOKeJbljVm5T685VIELTGGC3Bzr0f8o32lcqxWjeodiFJpLTiYjALg+fPxGVN0sLa9nu0cfWmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f4HLNxn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f4HLNxn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECC3C116C6;
	Thu,  5 Mar 2026 10:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772707915;
	bh=4c1epKkFsV74Msuv0gsotVAH83GwgolgavSsSMFv0/o=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=f4HLNxn/RRJSvY5zJ9FR0e4corL+qynssAJ60JiA326+NfB6sDpRuGfhXM36lOy52
	 xHg15ovhLtULXuSo9Bl/MSObSVpJ/CAYG3ofOPobQ8CPIdVL8nemE/sM11Z+Y8o0Zk
	 E3Vf62slXkelhJGwMT55Wdth6A+3LSsnh9w000bNF3KpyRQ5bQ+b7sjvwIkjiwozD3
	 mYNM6icdwFlIwvcKcJM5OvnjOKeyq0d+H//mhb/RH0v7TFC5e3IFst/QUZYfmK83Ua
	 JytElZOvwPb7CtU5WGKbxh3bW1yfHyZHS5oMeyinHZ5J1jwqs7LDF6INMtT8ww/Aqb
	 +CMyxPgrS4R5w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02D883808200;
	Thu,  5 Mar 2026 10:51:57 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/14] ipv6: export fib6_lookup for nft_fib_ipv6
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177270791580.2645044.17553607953991454452.git-patchwork-notify@kernel.org>
Date: Thu, 05 Mar 2026 10:51:55 +0000
References: <20260304114921.31042-2-fw@strlen.de>
In-Reply-To: <20260304114921.31042-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Florian Westphal <fw@strlen.de>:

On Wed,  4 Mar 2026 12:49:08 +0100 you wrote:
> Upcoming patch will call fib6_lookup from nft_fib_ipv6.  The EXPORT_SYMBOL is
> added twice because there are two implementations of the function, one
> is a small stub for MULTIPLE_TABLES=n, only one is compiled into the
> kernel depending on .config settings.
> 
> Alternative to EXPORT_SYMBOL is to use an indirect call via the
> ipv6_stub->fib6_lookup() indirection, but thats more expensive than the
> direct call.
> 
> [...]

Here is the summary with links:
  - [net-next,01/14] ipv6: export fib6_lookup for nft_fib_ipv6
    https://git.kernel.org/netdev/net-next/c/7a135bf9903f
  - [net-next,02/14] ipv6: make ipv6_anycast_destination logic usable without dst_entry
    https://git.kernel.org/netdev/net-next/c/831fb31b76ae
  - [net-next,03/14] netfilter: nft_fib_ipv6: switch to fib6_lookup
    https://git.kernel.org/netdev/net-next/c/1c32b24c234b
  - [net-next,04/14] netfilter: nf_log_syslog: no longer acquire sk_callback_lock in nf_log_dump_sk_uid_gid()
    https://git.kernel.org/netdev/net-next/c/5663ac3e5481
  - [net-next,05/14] netfilter: xt_owner: no longer acquire sk_callback_lock in mt_owner()
    https://git.kernel.org/netdev/net-next/c/cdec942ac200
  - [net-next,06/14] netfilter: nft_meta: no longer acquire sk_callback_lock in nft_meta_get_eval_skugid()
    https://git.kernel.org/netdev/net-next/c/afc2125de741
  - [net-next,07/14] netfilter: nfnetlink_log: no longer acquire sk_callback_lock
    https://git.kernel.org/netdev/net-next/c/b297aaefc648
  - [net-next,08/14] netfilter: nfnetlink_queue: no longer acquire sk_callback_lock
    https://git.kernel.org/netdev/net-next/c/013e2f91d0a4
  - [net-next,09/14] netfilter: nfnetlink_queue: remove locking in nfqnl_get_sk_secctx
    https://git.kernel.org/netdev/net-next/c/34a6a003d4e4
  - [net-next,10/14] rculist_bl: add hlist_bl_for_each_entry_continue_rcu
    https://git.kernel.org/netdev/net-next/c/1ac252ad036c
  - [net-next,11/14] ipvs: add resizable hash tables
    https://git.kernel.org/netdev/net-next/c/b655388111cf
  - [net-next,12/14] ipvs: use resizable hash table for services
    https://git.kernel.org/netdev/net-next/c/840aac3d900d
  - [net-next,13/14] ipvs: switch to per-net connection table
    https://git.kernel.org/netdev/net-next/c/2fa7cc9c7025
  - [net-next,14/14] ipvs: use more keys for connection hashing
    https://git.kernel.org/netdev/net-next/c/f20c73b0460d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


