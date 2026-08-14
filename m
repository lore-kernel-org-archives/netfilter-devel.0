Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0983C1419;
	Fri, 14 Aug 2026 19:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786737106; cv=none; b=urTZIqVpjT3/nraSgAzX59Wf17qGCyNmwkfFHQ/zDhHFi6uq/4mYQbiy+78956NvFUtADlhUp9QOgs5kfE+/RTn5lMb5QjhTqLNfCT3aCc7WpP7EPEJPY3GEHOJEf2o8s1nBsjSdoJHMYVoaat+lEOnqCl4VX6p4p+r0sf+0Uh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786737106; c=relaxed/simple;
	bh=5luuNCYz1S3rdbs+UXN8MgyVk7Z0ZBCexGlgixTcno8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=tDSxKb85SPtRFWD1DW6jift39aJnQI21hbQhLoaeBDbjllDhRzUtyMz9YznkxYo8mFRmjSoJ8KzZOJ7E8EF6VXbfvwoGn5IVveJD7o4slopNqnFxk8U7qyPe74BeuT4aLSQbb7YFYDlbtG+STRDizWOKJl06Cnql26L1qg0O3Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bqDWEZsM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bqDWEZsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70F81F000E9;
	Fri, 14 Aug 2026 19:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786737104;
	bh=nQdORJPsl59O9gjz5kXj78lVSaq+cwhNNSX78QWvA90=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=bqDWEZsMu2td+afb+38A7zVC6n6/oCr7ZOLR7rBj30fUJG7IKQmPsMh7rULK36grz
	 cErnLJlmIKDCLR2Sw4Isqua1MGqNOkhggo+g0aM91ge2b4Q/46noa/0+/E9vwX6IUT
	 PL3WY2LaYoe3Si951qaHjGiffq96OU7KXKGr6J6CMLbTY317x0sf2dVmCZ6q45aeqK
	 dIoa+6bCErp3JUqQV6Rod3fuz6EFCDgSSzBdulZBXfuL/ZHtGUg8PEZsGu6GXidjzb
	 9ZGpcXH0GcBfda1LNdYhgyvqt/vVtfpKh0EX1HJNoZ19SopW41jkQHxFOF0MbZTXM5
	 oYN+Lnxxd0pZQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19AA8392445C;
	Fri, 14 Aug 2026 19:51:00 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/12] netfilter: add DEBUG_NET_WARN_ON_ONCE to
 skb_set_nfct()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178673705875.3935546.3916108497020415562.git-patchwork-notify@kernel.org>
Date: Fri, 14 Aug 2026 19:50:58 +0000
References: <20260810194015.932627-2-pablo@netfilter.org>
In-Reply-To: <20260810194015.932627-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Mon, 10 Aug 2026 21:40:04 +0200 you wrote:
> Trigger a warning if nf_ct_set() overlaps an existing ct object leading
> to refcount leak. Add this warning to skb_set_nfct() whose only user is
> nf_ct_set() instead.
> 
> Update existing nf_ct_set() callers to use nf_reset_ct() first to clean
> up stale pointer to conntrack object which migh trigger false positive
> warnings.
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] netfilter: add DEBUG_NET_WARN_ON_ONCE to skb_set_nfct()
    https://git.kernel.org/netdev/net-next/c/5546b082fa7c
  - [net-next,02/12] net: pass net_device_path_ctx to dev_fill_forward_path()
    https://git.kernel.org/netdev/net-next/c/95133a416809
  - [net-next,03/12] net: netfilter: add ether_type to net_device_path_ctx and use it
    https://git.kernel.org/netdev/net-next/c/5592223f3d4e
  - [net-next,04/12] netfilter: flowtable: rename tun.l3_proto to tun.inner_proto
    https://git.kernel.org/netdev/net-next/c/cb1d3ae6a785
  - [net-next,05/12] netfilter: flowtable: rename ctx.tun.proto to ctx.tun.inner_proto
    https://git.kernel.org/netdev/net-next/c/548c0fbcc381
  - [net-next,06/12] netfilter: flowtable: store ethertype in flowtable context
    https://git.kernel.org/netdev/net-next/c/ec7a0f285041
  - [net-next,07/12] netfilter: flowtable: move ipv4 and ipv6 xmit path to function
    https://git.kernel.org/netdev/net-next/c/609268d93dd1
  - [net-next,08/12] netfilter: flowtable: detach layer 2 encapsulation parser from lookup
    https://git.kernel.org/netdev/net-next/c/0e42d4039cb4
  - [net-next,09/12] netfilter: nft_ct: move custom expectation support to helper
    https://git.kernel.org/netdev/net-next/c/3679da4ad8be
  - [net-next,10/12] netfilter: conntrack: always lower timeout for non-closing RST packets
    https://git.kernel.org/netdev/net-next/c/73df81b38cb7
  - [net-next,11/12] netfilter: nf_conntrack_expect: bail out on insert dead expectations
    https://git.kernel.org/netdev/net-next/c/e765c95faa10
  - [net-next,12/12] selftests: netfilter: conntrack_dump_flush: remove unused variables and fix typo
    https://git.kernel.org/netdev/net-next/c/736fb8632217

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


