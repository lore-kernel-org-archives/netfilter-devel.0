Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC12437A497;
	Thu, 29 Jan 2026 14:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769695819; cv=none; b=HcTi4UyjvfoTfliKBAy2Pb7s9jGyT4rYoUeZ4+rvvTUSHJJf9g586CVkViMjpmhJILzh5s7IFxZJCFGbGD1RxW3yF7XGobeWPpWxNbwL+Ily5rZnDD2Z7CkXB7YSJFdV5/Uyn+QYj+bshHWfEKfC2Iw+HNTYVHjdv5AK1WTdCZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769695819; c=relaxed/simple;
	bh=15ALhzaU3lhjZQWrJedQtDV1gqtXCsRHP8nr+trK/Pw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=r7lTGOTRGxl+fbGEneMnvnL3KaJC2x2bV28Bgi22XDSI0uDi9TrF/r3ezg2EZOviuQ+5BniG19H6Z8o9nAoY+C+aem9/pnBwEJh7C0XoZq8nqIRZX5k5yLjqEWQpqwdx9lg/biBYrKyheUSXBE4p3bmD0TaDOSVei8Dt1GXBxR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XFVypFFf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XFVypFFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590D2C4CEF7;
	Thu, 29 Jan 2026 14:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769695819;
	bh=15ALhzaU3lhjZQWrJedQtDV1gqtXCsRHP8nr+trK/Pw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=XFVypFFfM2Q8JWJ+Ve7pttPkUvnVsZ5S4vhAT1rlKog/kTNIyosXv04RG60WKCEpU
	 RLExXrfv1t6XH8O+BT1j3O2WaqQ/CkDqls8KCyLSZKPjUrqkP2ihR5s/86l+AtbhEr
	 L1GvSIvAPLBtf0CF/Zd9mVGvVRsnAsXaq5pJaw58dR5ecemPQijGiFHZt+x8AdkMye
	 ttNUrC/kmpfEGohQJ3BZNciVH6T3/Bu8k0JS/FYV+IcR2fW2gOBNzzz3/hBTyCrBSu
	 oz+bzUHJJTKcDVe//FvvaPOkulbMh3JnXZVo4tiPRnLOGzFfR+I9WL+PepY4aa/l3I
	 dWcKJ0AAQeW2w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 8BC52380CEC7;
	Thu, 29 Jan 2026 14:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 1/7] netfilter: Add ctx pointer in
 nf_flow_skb_encap_protocol/nf_flow_ip4_tunnel_proto signature
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176969581236.2514880.12957541064070579896.git-patchwork-notify@kernel.org>
Date: Thu, 29 Jan 2026 14:10:12 +0000
References: <20260129105427.12494-2-fw@strlen.de>
In-Reply-To: <20260129105427.12494-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Florian Westphal <fw@strlen.de>:

On Thu, 29 Jan 2026 11:54:21 +0100 you wrote:
> From: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> Rely on nf_flowtable_ctx struct pointer in nf_flow_ip4_tunnel_proto and
> nf_flow_skb_encap_protocol routine signature. This is a preliminary patch
> to introduce IP6IP6 flowtable acceleration since nf_flowtable_ctx will
> be used to store IP6IP6 tunnel info.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/7] netfilter: Add ctx pointer in nf_flow_skb_encap_protocol/nf_flow_ip4_tunnel_proto signature
    https://git.kernel.org/netdev/net-next/c/baa501b12a48
  - [v2,net-next,2/7] netfilter: Introduce tunnel metadata info in nf_flowtable_ctx struct
    https://git.kernel.org/netdev/net-next/c/c64436daf675
  - [v2,net-next,3/7] netfilter: flowtable: Add IP6IP6 rx sw acceleration
    https://git.kernel.org/netdev/net-next/c/d98103575dcd
  - [v2,net-next,4/7] netfilter: flowtable: Add IP6IP6 tx sw acceleration
    https://git.kernel.org/netdev/net-next/c/93cf357fa797
  - [v2,net-next,5/7] selftests: netfilter: nft_flowtable.sh: Add IP6IP6 flowtable selftest
    https://git.kernel.org/netdev/net-next/c/5e5180352193
  - [v2,net-next,6/7] netfilter: xt_time: use is_leap_year() helper
    https://git.kernel.org/netdev/net-next/c/77fd1b4c6e08
  - [v2,net-next,7/7] netfilter: nfnetlink_queue: optimize verdict lookup with hash table
    https://git.kernel.org/netdev/net-next/c/e19079adcd26

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


