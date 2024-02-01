Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F791649AE;
	Thu,  1 Feb 2024 17:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706808028; cv=none; b=EhhO4R1NvAE+1NOP1ykARlfGEVQgzm/nobpzesfaBpbnQugErljfGHmwgXUhoZcsxt8zZOFpm+cBsgI85AsUgI6QPOTguJyffCMYjF/50JUbfRWWezH3vogbkqrt/CpSqUyw5r62CY90XdMBjp8grJOgQmq40GFF/JWUm8nHBJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706808028; c=relaxed/simple;
	bh=qBK8IEEC/YqjJg3DzlG/+3uVXL6f6ACc/jMCidzB0OE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=nut1zX/pzHW4mIQlYaV6431bkHm8hm3ewPPVHqxT/R1TIU04XMNgW1vbhzjRT+IjXUcD+KXWRbg4DqhHNfyj2kuUK1Mzh70smr16G5ZHH5zlhQAuT5feLMZBPQZHeh3TnJJKrsS5vAyM2sfor+apvHY5eFiE24ztlPEa/o/gQEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C1SRyX6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C1SRyX6b"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 140E3C433F1;
	Thu,  1 Feb 2024 17:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706808028;
	bh=qBK8IEEC/YqjJg3DzlG/+3uVXL6f6ACc/jMCidzB0OE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=C1SRyX6bo1jQ0HLoQl92kq2lkiqTe0SDYMWA6cCWZskHYDv4HPmE6LmsQ67N31UWN
	 fy+o3H5cIyP45KvmsETVd4U/PxciQ7E3Mo3R7rbALNtor9MxyfMCzjZikw/yTy9KQ+
	 i+gZLyqo8US8BCMPFf4iEii4DX8iGMor/c6EjMOSpXzRCbONkR1dbKPDRwanQ0P5yq
	 Dyb2OO2qX0Sycph2rdOEzRkXgE24zQmK6mrqn/nDbxrLHdpHwrFMyAPqM9kneyeLX/
	 E+TylEpVb0+s+0jE7hoqV8DhWsKSn0OotTk8eb5CqFbEwGKDoHEv003DzB+UFS6wB7
	 j70CB2bxoLz7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E784AE3237E;
	Thu,  1 Feb 2024 17:20:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/6] netfilter: conntrack: correct window scaling with
 retransmitted SYN
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170680802794.24895.1311935985185271736.git-patchwork-notify@kernel.org>
Date: Thu, 01 Feb 2024 17:20:27 +0000
References: <20240131225943.7536-2-pablo@netfilter.org>
In-Reply-To: <20240131225943.7536-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed, 31 Jan 2024 23:59:38 +0100 you wrote:
> From: Ryan Schaefer <ryanschf@amazon.com>
> 
> commit c7aab4f17021 ("netfilter: nf_conntrack_tcp: re-init for syn packets
> only") introduces a bug where SYNs in ORIGINAL direction on reused 5-tuple
> result in incorrect window scale negotiation. This commit merged the SYN
> re-initialization and simultaneous open or SYN retransmits cases. Merging
> this block added the logic in tcp_init_sender() that performed window scale
> negotiation to the retransmitted syn case. Previously. this would only
> result in updating the sender's scale and flags. After the merge the
> additional logic results in improperly clearing the scale in ORIGINAL
> direction before any packets in the REPLY direction are received. This
> results in packets incorrectly being marked invalid for being
> out-of-window.
> 
> [...]

Here is the summary with links:
  - [net,1/6] netfilter: conntrack: correct window scaling with retransmitted SYN
    https://git.kernel.org/netdev/net/c/fb366fc7541a
  - [net,2/6] netfilter: nf_tables: restrict tunnel object to NFPROTO_NETDEV
    https://git.kernel.org/netdev/net/c/776d45164844
  - [net,3/6] netfilter: conntrack: check SCTP_CID_SHUTDOWN_ACK for vtag setting in sctp_new
    https://git.kernel.org/netdev/net/c/6e348067ee4b
  - [net,4/6] netfilter: ipset: fix performance regression in swap operation
    https://git.kernel.org/netdev/net/c/97f7cf1cd80e
  - [net,5/6] netfilter: nf_log: replace BUG_ON by WARN_ON_ONCE when putting logger
    https://git.kernel.org/netdev/net/c/259eb32971e9
  - [net,6/6] netfilter: nft_ct: sanitize layer 3 and 4 protocol number in custom expectations
    https://git.kernel.org/netdev/net/c/8059918a1377

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


