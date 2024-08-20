Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93642745C;
	Tue, 20 Aug 2024 13:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724159694; cv=none; b=g/ySwCkTf3/zRAV6k6d02iu44Yv3SgLNhoF2DKZuLTDfznCWHAG6JAkUTBwJ+X4flX6aRbPlwSzW7DZhwLF95cJ6uw2+eMCCNNXn3al+v5qljIuMjFF2p/M1JUfgzGMhcYKvkCxkk34f6uxzyrCdgXLgFTkCtLfTRHaMZletVJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724159694; c=relaxed/simple;
	bh=NfKJYAEwk4kpIFa+BzkTkgUmdvyr91G+Cajgi3Ah0ik=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=lOeYFVkmB+jWgSfsNW3820uJXiQo5hW6iJvtpHDXowqSh2EtcTuqV7JPJj6mbYzBoy7qC0J9L9IIE4ejKUrtmHmDnwlKbrGzAeXRUfmOfbEx9QnRBQ9aX94zXxaeLvQQDn+ECNGcRUygsSBM9JuhOGkknnThop3a8G9xZ9yU6MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rvB09Y7b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rvB09Y7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D07FC4AF0C;
	Tue, 20 Aug 2024 13:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724159694;
	bh=NfKJYAEwk4kpIFa+BzkTkgUmdvyr91G+Cajgi3Ah0ik=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=rvB09Y7bh+0pHjPXwQ9teZkayU/4/bP1FW2oE4O/QmQcW+Zf1tSr3ADhf/HvdwAyM
	 ekCGa6s072GsOhBjUfCVUA5Zca6vWZTFMEy3Z3vCc1tJsSIRQNiWQ/iYWySzkkH3lg
	 O4omWe69EFAx6J2wI6Y3pBc4+TByuJgWXIGgO/pTC/12eu15QmTOn6n2Rxh1HFdEH6
	 awhpTRyspaW+CADW7oUYiPnbvTc2NqZLady0LrzTSqrm9KKwK95H8sluEnhbmX0gi6
	 i4NfSnWiYRICcyP77n8FuRidPV5jvhHbM/gSc+ruRglvC9dwDSHpak2V269IDQxrsU
	 4x0e27KeHcrOw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAE483804CA6;
	Tue, 20 Aug 2024 13:14:54 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] Preparations for FIB rule DSCP selector
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172415969380.1136834.14357606918643435056.git-patchwork-notify@kernel.org>
Date: Tue, 20 Aug 2024 13:14:53 +0000
References: <20240814125224.972815-1-idosch@nvidia.com>
In-Reply-To: <20240814125224.972815-1-idosch@nvidia.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
 dsahern@kernel.org, gnault@redhat.com, pablo@netfilter.org,
 kadlec@netfilter.org, fw@strlen.de

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 14 Aug 2024 15:52:21 +0300 you wrote:
> This patchset moves the masking of the upper DSCP bits in 'flowi4_tos'
> to the core instead of relying on callers of the FIB lookup API to do
> it.
> 
> This will allow us to start changing users of the API to initialize the
> 'flowi4_tos' field with all six bits of the DSCP field. In turn, this
> will allow us to extend FIB rules with a new DSCP selector.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] ipv4: Mask upper DSCP bits and ECN bits in NETLINK_FIB_LOOKUP family
    https://git.kernel.org/netdev/net-next/c/8fed54758cd2
  - [net-next,v2,2/3] netfilter: nft_fib: Mask upper DSCP bits before FIB lookup
    https://git.kernel.org/netdev/net-next/c/548a2029eb66
  - [net-next,v2,3/3] ipv4: Centralize TOS matching
    https://git.kernel.org/netdev/net-next/c/1fa3314c14c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


