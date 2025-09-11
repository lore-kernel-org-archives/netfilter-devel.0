Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574631F237A;
	Thu, 11 Sep 2025 02:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757558419; cv=none; b=LMJHfJ9glgTFz5rPTiRujSa2aaK2I2r4lRcnw2rhJvM78KRJQSv57+BLkEo2C0iRV8HPDiHsqXdlXBMckUdczWEQ/XkXnT+iaAXA7qM6Xj9S3sfvvtijwUL3lBh7xBw5AVD0qikl3nypVYiCWDM2tIQdZA10F6iIpzJb4MioRgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757558419; c=relaxed/simple;
	bh=RQOgV1eS3YTOprcVPno0fvBC6uOLR5vpfdCCT3POqTc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=kUWgkvezGUm5iAeODMppFlx/rDoMp8TKtGGy9wlVU4lVbT7Cp0XxqRvWgMw+BmEKN7XMoNhcAwi/yERTTErm5WuLtSnEbnQm/+MVsj5T/J6eOf1UnhOimZXhMOAAxnu10CjpvKfiXQ+2shq2G7kPIOPXkB6ztmAp/93t1xGuHEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=byyGa4p7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="byyGa4p7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC435C4CEEB;
	Thu, 11 Sep 2025 02:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757558418;
	bh=RQOgV1eS3YTOprcVPno0fvBC6uOLR5vpfdCCT3POqTc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=byyGa4p7B9pProBNxs5UGUqmqcPtk0thqpWj9sHCdlb9XYke9g9AUHv+NcW49NnCe
	 2p7C85LHryVUU2heFCTMkZJ7Aq+MKKknSJv5SKqEB5jLuWDeOJ6zDaWAiNw+Qdq6Es
	 iHia10PUX+4NAB/3WFAYbfM5SaLdCNxnFjy3LoKnRid1KBVnI5Hi2zquhIcm8icORM
	 HfkGluUwwY8c8KipWK6MsSjjNuzMIMUOK2Rb6VmSCDz0TPT8nxal7Eh6RU8HxCzRE4
	 ZYy5omZp04PXg2mSK16ZttcfkyyS9Vu4/jyhxn5n0DMQBcJLvt2973FFDccbScr5Iv
	 8uwriW9/38ODg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB133383BF69;
	Thu, 11 Sep 2025 02:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/7] netfilter: nft_set_bitmap: fix lockdep splat due
 to
 missing annotation
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175755842175.1636514.17155715324715666470.git-patchwork-notify@kernel.org>
Date: Thu, 11 Sep 2025 02:40:21 +0000
References: <20250910190308.13356-2-fw@strlen.de>
In-Reply-To: <20250910190308.13356-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Wed, 10 Sep 2025 21:03:02 +0200 you wrote:
> Running new 'set_flush_add_atomic_bitmap' test case for nftables.git
> with CONFIG_PROVE_RCU_LIST=y yields:
> 
> net/netfilter/nft_set_bitmap.c:231 RCU-list traversed in non-reader section!!
> rcu_scheduler_active = 2, debug_locks = 1
> 1 lock held by nft/4008:
>  #0: ffff888147f79cd8 (&nft_net->commit_mutex){+.+.}-{4:4}, at: nf_tables_valid_genid+0x2f/0xd0
> 
> [...]

Here is the summary with links:
  - [net,1/7] netfilter: nft_set_bitmap: fix lockdep splat due to missing annotation
    https://git.kernel.org/netdev/net/c/5e13f2c491a4
  - [net,2/7] netfilter: nft_set_pipapo: don't check genbit from packetpath lookups
    https://git.kernel.org/netdev/net/c/c4eaca2e1052
  - [net,3/7] netfilter: nft_set_rbtree: continue traversal if element is inactive
    https://git.kernel.org/netdev/net/c/a60f7bf4a152
  - [net,4/7] netfilter: nf_tables: place base_seq in struct net
    https://git.kernel.org/netdev/net/c/64102d9bbc3d
  - [net,5/7] netfilter: nf_tables: make nft_set_do_lookup available unconditionally
    https://git.kernel.org/netdev/net/c/11fe5a82e53a
  - [net,6/7] netfilter: nf_tables: restart set lookup on base_seq change
    https://git.kernel.org/netdev/net/c/b2f742c846ca
  - [net,7/7] MAINTAINERS: add Phil as netfilter reviewer
    https://git.kernel.org/netdev/net/c/37a9675e61a2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


