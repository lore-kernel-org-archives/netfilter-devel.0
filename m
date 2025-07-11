Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A3D2BAF4;
	Fri, 11 Jul 2025 00:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752193801; cv=none; b=lJ3/EOAENi13Pr5/sExT5oPs4liEvlZXEmPLJh8tHQEeezZzKcIz78CO5vkPcnNOCty+AH3pJ/zPRNlVssxCX+mwa805l27+BSiW6NOqHcLDIorsoMdwK61KQ7d5I7DyHcxkXr75qeyIYypxxGC+ao6uebj6GhPvuoF74y0xKRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752193801; c=relaxed/simple;
	bh=Ft+4bogiN8iJK6q1YUSLmeCrSfh3XWwtQJd7zoj84Nk=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=DVJTNac3RULctq629P+AnSWVZQkYhoSk3VkF7UojGNnZv6Pt5G0kQYIRCp/31wJOcyESPPNprUmEAY5NtmPp51qvYBaciQgQefGBtQD+REo/D4kAf6MkSQDDKGw13X7ib3BIG5RXV2EU8qwBIXXhP+lK13Ty55DPWTL13mPdcL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=prfmW5Q5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="prfmW5Q5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82ED0C4CEF4;
	Fri, 11 Jul 2025 00:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752193800;
	bh=Ft+4bogiN8iJK6q1YUSLmeCrSfh3XWwtQJd7zoj84Nk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=prfmW5Q5Ou7RiZPWoRErKPUffMDIMSHnkq8qwSe9T1a5b4cYo9zSfHsKI5YQSzoLm
	 wv6eCp0g2bweYoaskvQBUNK6+jXXCbLsUoSe5k0Tm1wLaNk/Yl96yBZk42TQnwUlrS
	 GLJhDfsMhpat+2//WJsaYj7VzmxxG+Q5YjgaT5M4v+KD9eyczD9x8L+gPP/7KWa9Iw
	 x143wh8VlBdSTGjpyRfBN+sm3S8Oej3Lt9OmcjpcGgWjSDLh+7JbYEAruulK9GSgxW
	 LbemVMx+qs02HqVZKBbBcpfX7pU0aJjBiIP2QjGVTV5uHf1ciTbibRX2KcdgFuw5W6
	 TovQbjuRO5LRw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70C16383B266;
	Fri, 11 Jul 2025 00:30:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netfilter: flowtable: account for Ethernet header in
 nf_flow_pppoe_proto()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175219382224.1715084.10590390381407848678.git-patchwork-notify@kernel.org>
Date: Fri, 11 Jul 2025 00:30:22 +0000
References: <20250707124517.614489-1-edumazet@google.com>
In-Reply-To: <20250707124517.614489-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 pablo@netfilter.org, kadlec@netfilter.org, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 eric.dumazet@gmail.com, syzbot+bf6ed459397e307c3ad2@syzkaller.appspotmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  7 Jul 2025 12:45:17 +0000 you wrote:
> syzbot found a potential access to uninit-value in nf_flow_pppoe_proto()
> 
> Blamed commit forgot the Ethernet header.
> 
> BUG: KMSAN: uninit-value in nf_flow_offload_inet_hook+0x7e4/0x940 net/netfilter/nf_flow_table_inet.c:27
>   nf_flow_offload_inet_hook+0x7e4/0x940 net/netfilter/nf_flow_table_inet.c:27
>   nf_hook_entry_hookfn include/linux/netfilter.h:157 [inline]
>   nf_hook_slow+0xe1/0x3d0 net/netfilter/core.c:623
>   nf_hook_ingress include/linux/netfilter_netdev.h:34 [inline]
>   nf_ingress net/core/dev.c:5742 [inline]
>   __netif_receive_skb_core+0x4aff/0x70c0 net/core/dev.c:5837
>   __netif_receive_skb_one_core net/core/dev.c:5975 [inline]
>   __netif_receive_skb+0xcc/0xac0 net/core/dev.c:6090
>   netif_receive_skb_internal net/core/dev.c:6176 [inline]
>   netif_receive_skb+0x57/0x630 net/core/dev.c:6235
>   tun_rx_batched+0x1df/0x980 drivers/net/tun.c:1485
>   tun_get_user+0x4ee0/0x6b40 drivers/net/tun.c:1938
>   tun_chr_write_iter+0x3e9/0x5c0 drivers/net/tun.c:1984
>   new_sync_write fs/read_write.c:593 [inline]
>   vfs_write+0xb4b/0x1580 fs/read_write.c:686
>   ksys_write fs/read_write.c:738 [inline]
>   __do_sys_write fs/read_write.c:749 [inline]
> 
> [...]

Here is the summary with links:
  - [net] netfilter: flowtable: account for Ethernet header in nf_flow_pppoe_proto()
    https://git.kernel.org/netdev/net/c/18cdb3d982da

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


