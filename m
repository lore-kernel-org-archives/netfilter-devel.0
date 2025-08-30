Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE6B19E7F7;
	Sat, 30 Aug 2025 02:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756519804; cv=none; b=XA40UgSrDZXsi1uYEi83sCM6IOD/ksMUmTpenynb4P38PoMDmZv4IEMfeCFRUDp3A1msgtjw7Dy2VZdGJW3P+t/sjzbr/AWfnw3g2ZdDCPnBQ+/RpZXpiAsB9p8p3oNibuaWF0mFPq0IyrBCr4QSX2XWu3F/CfmJxsq0Q9ISbro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756519804; c=relaxed/simple;
	bh=Fs53JZEDfA/JmT11uACI+B8/Fr8Vhu81kw6rlTcmkA4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=YYxpmShBJErdUu1KcbvS+FymddCadjFv2fe7jSPI1H+EGZgu9TSNzJJ2cm8656dKIPalyjY3MvbhqDumMChMvlPJGBR7lWg4RcsFN0jiCSLFL0t38KrSL0W0esddDoK11mk5CFzOfLKgJwIfwsj6/Uj3UIMXzLGTxe8BV2VTaeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQ4ONx+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQ4ONx+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B693C4CEF0;
	Sat, 30 Aug 2025 02:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756519801;
	bh=Fs53JZEDfA/JmT11uACI+B8/Fr8Vhu81kw6rlTcmkA4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=XQ4ONx+N3aYEf6qeXvOA3Yge2+775F9MWChNk03TEif3jokP0e5vZzuQkUmXCnhP5
	 QbVoCUrumBT0ak8cYLg5x2q0wB52UrbtJVlwKFLiQZ3VDWnX2CpeoUED3xa0W8DpnC
	 lDI306l3dGQLrRrFeraNYoqpWq/m1pjvpb1lylxOoNOXln9XF5x6Z3YH/SyiZlclkU
	 0VFMmtl+PBGm43SFTf0bQqvU50lR/yhsBkMCqb9mJPg7QNEj/wxTl9GML9kFvLvjBU
	 hkXWBpUIaZAmUotiwvYZ1Lf7X7KZAGOzCYv1ExztsOIRyqowWMjbeCjehtS7h35O3A
	 kV5G3H+aY+PPw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3408B383BF75;
	Sat, 30 Aug 2025 02:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: br_netfilter: do not check confirmed
 bit
 in br_nf_local_in() after confirm
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175651980801.2396653.1420643484668912116.git-patchwork-notify@kernel.org>
Date: Sat, 30 Aug 2025 02:10:08 +0000
References: <20250827133900.16552-2-fw@strlen.de>
In-Reply-To: <20250827133900.16552-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org, wangliang74@huawei.com

Hello:

This series was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Wed, 27 Aug 2025 15:38:59 +0200 you wrote:
> From: Wang Liang <wangliang74@huawei.com>
> 
> When send a broadcast packet to a tap device, which was added to a bridge,
> br_nf_local_in() is called to confirm the conntrack. If another conntrack
> with the same hash value is added to the hash table, which can be
> triggered by a normal packet to a non-bridge device, the below warning
> may happen.
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: br_netfilter: do not check confirmed bit in br_nf_local_in() after confirm
    https://git.kernel.org/netdev/net/c/479a54ab9208
  - [net,2/2] netfilter: conntrack: helper: Replace -EEXIST by -EBUSY
    https://git.kernel.org/netdev/net/c/54416fd76770

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


