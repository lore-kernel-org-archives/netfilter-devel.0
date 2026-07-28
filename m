Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D8A25A2C6;
	Tue, 28 Jul 2026 01:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785201061; cv=none; b=pMgWnhK6VrWLE9OMHc/rEXiBeFnIfQF+a9RAwBx1iQZXFKdE3/Rm6yZ3Y+ZlAlISCTMNUzRXWwRbzbNcY8CB293dvdCeCeQ0sp8bapUtoSnQHjJIriGlU9LeUHUQoBItgbfYRj8+vjVGf7STehHIKytlRqXDWccJIazveQ+mh1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785201061; c=relaxed/simple;
	bh=EWJK+275d8Y5kpFRVaoYI2leK32Gy34KpJfpAzoBDfc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=qxEz1HwBJkzmxwekn/+kTkIGRGbCa82ffMFYA86rarmh3rJ++ZWQuy0nwIMF2dCnSXJOyprntdy2IrFnOCzJw1srG8dDz1jPmnX0sa2XJlCq8G0I+pNj2AfFpT5hVvksHf34OR+ceLRgyfwnUgsiOG3d9LNt8S9H5GMYzDM1mdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PQEBwGrG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PQEBwGrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5105B1F000E9;
	Tue, 28 Jul 2026 01:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785201060;
	bh=KWMwkd3AYgLH0LsXP9ZSVJIRIcnL5ymGE7gN22MWAF0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=PQEBwGrGHIZ/Wpc6jZu9pXCZ/Csrii5UA8lN4pvsE7fKkOvGWBC0FPJKJOfJwmX7Q
	 OUXEdDgL2DKwccaZtDSwj9G9+AdjA8JQ/kHDCvWC5IHVLZ9GFMWZPto5ta72FH7O6w
	 VKVAoV0qNe3BTeTFBAamh3N4Nn6YXmvcTnvAY7bTlQKOquCabrxSz6DuBxrPQRMgi9
	 TF91njlSdD3obEb3AgS7E1OvtbGg1VX3BpLajuDRo22RseNVIAJJhASh4ollZgTxhM
	 /zaURnDOvjM03mfl01q4UXuFAXELPxa3Fdr+MJ7jwq/0l4ki/v1paYr9kZdNz14GYV
	 MBDyYbTVD+uPQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93B6E380CED8;
	Tue, 28 Jul 2026 01:10:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/7] ipvs: Move defense_work and est_reload_work
 to
 system_dfl_long_wq
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178520102513.1486027.6830944309347265032.git-patchwork-notify@kernel.org>
Date: Tue, 28 Jul 2026 01:10:25 +0000
References: <20260724104932.437729-2-pablo@netfilter.org>
In-Reply-To: <20260724104932.437729-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri, 24 Jul 2026 12:49:26 +0200 you wrote:
> From: Ismael Luceno <iluceno@suse.de>
> 
> Under synflood conditions binding these handlers to system_long_wq may
> pin them to a saturated CPU.
> 
> We've observed improved throughtput on a DPDK/VPP application with this
> change, which we attribute to the reduced context switching.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] ipvs: Move defense_work and est_reload_work to system_dfl_long_wq
    https://git.kernel.org/netdev/net-next/c/0a33bdce34c6
  - [net-next,2/7] netfilter: xt_tcpmss: extend checkentry to ipv6
    https://git.kernel.org/netdev/net-next/c/4172fd3697b0
  - [net-next,3/7] netfilter: nf_nat_sip: rewind offset when NAT shrinks the packet
    https://git.kernel.org/netdev/net-next/c/16aecbe3036f
  - [net-next,4/7] netfilter: flowtable: tear down flow entries with stale dst from GC
    https://git.kernel.org/netdev/net-next/c/edd51a233438
  - [net-next,5/7] netfilter: conntrack_helper: pass master conntrack to helper functions
    https://git.kernel.org/netdev/net-next/c/1c66ad76ddd4
  - [net-next,6/7] netfilter: nf_conntrack_expect: store event cache in expectation
    https://git.kernel.org/netdev/net-next/c/874f455c3a29
  - [net-next,7/7] ipvs: use type-safe allocation helpers in ip_vs_rht_alloc
    https://git.kernel.org/netdev/net-next/c/cca2780b6194

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


