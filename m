Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFAA1632E7;
	Wed, 29 Apr 2026 01:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777426278; cv=none; b=dZTnpsdLzWw+HmZJuQI/Rb67znWMDg8Ctoq1+L4Y8rVeeS+Hya4T1x2yb1OVg+4yO3Kc0E4zu6Y3D2AkFsbOo5VbdWWqYoUUaQWUeNT/9gh6xWSAaMGI6mVbnpX9v93X0bvD7Ju1RCpMTP9jZUmoMgmWdA6ci3Imb7l2dhvnU3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777426278; c=relaxed/simple;
	bh=NCMZLx8sYMUyhVw5Hbi5tg3zr+32Ft1ypN9wltbOFuY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=bVno4W+KNEMEbYkSBgzeuLnJHJp80IefngJyLhE6zXFCzIcq9pQiLTvOilpoMwFgXDndVkgWxmlgb+DIbVCtTv4j1qD1phmoUpgkHu3+01j5jVOpPZqwzE1GBCLtppvy8tkBr16B9w7rdOPrUWXDjMvvGZRL6l6eXPx+K4V8zOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eM3mdhX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eM3mdhX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874D2C2BCC7;
	Wed, 29 Apr 2026 01:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777426278;
	bh=NCMZLx8sYMUyhVw5Hbi5tg3zr+32Ft1ypN9wltbOFuY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=eM3mdhX8q/om4W03SkwEd3oXHhYMZ1sMFkiipMwB8Ku6HzGQW84SSwHKUGB94UsAl
	 4jy+2WssLq8JLt6K/DNGBhHboIfETmtAaGswP+pM93+lthJNfSqlyMUSw/tvMrHbbU
	 P2U2VycCSAhsOPTwqN0zYPHT0e5SmM3T3tAqUlYDzvkn7SW8Lrb10YUgTJIX+jeW9C
	 bzorljICBmwY6+Mj+zABZpH4O2GjlZhcSYoN43uaJTXssNCZhWmMPHPDDyEexWrPcW
	 EA7C9jkeKlUKLKGwOgTexfA30VMZrJdGVz7TX4Oe4tRxmmefcwwPICKYA25eED5eDL
	 B/FU3XMryrURg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02E6439302C2;
	Wed, 29 Apr 2026 01:30:36 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/8] netfilter: arp_tables: fix IEEE1394 ARP payload
 parsing
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177742623454.1288483.14161188350974885235.git-patchwork-notify@kernel.org>
Date: Wed, 29 Apr 2026 01:30:34 +0000
References: <20260428095840.51961-2-pablo@netfilter.org>
In-Reply-To: <20260428095840.51961-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Tue, 28 Apr 2026 11:58:32 +0200 you wrote:
> Weiming Shi says:
> 
> "arp_packet_match() unconditionally parses the ARP payload assuming two
> hardware addresses are present (source and target). However,
> IPv4-over-IEEE1394 ARP (RFC 2734) omits the target hardware address
> field, and arp_hdr_len() already accounts for this by returning a
> shorter length for ARPHRD_IEEE1394 devices.
> 
> [...]

Here is the summary with links:
  - [net,1/8] netfilter: arp_tables: fix IEEE1394 ARP payload parsing
    https://git.kernel.org/netdev/net/c/1e8e3f449b1e
  - [net,2/8] netfilter: nf_tables: use list_del_rcu for netlink hooks
    https://git.kernel.org/netdev/net/c/f3224ee463f8
  - [net,3/8] rculist: add list_splice_rcu() for private lists
    https://git.kernel.org/netdev/net/c/f902877b6355
  - [net,4/8] netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase
    https://git.kernel.org/netdev/net/c/a6134e62dba2
  - [net,5/8] netfilter: nf_tables: add hook transactions for device deletions
    https://git.kernel.org/netdev/net/c/10f79dbd7719
  - [net,6/8] netfilter: xt_policy: fix strict mode inbound policy matching
    https://git.kernel.org/netdev/net/c/4b2b4d7d4e20
  - [net,7/8] netfilter: reject zero shift in nft_bitwise
    https://git.kernel.org/netdev/net/c/fe11e5c40817
  - [net,8/8] netfilter: nf_conntrack_sip: don't use simple_strtoul
    https://git.kernel.org/netdev/net/c/8cf6809cddcb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


