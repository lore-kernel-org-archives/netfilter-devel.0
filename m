Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B2A26D4FB;
	Wed, 20 Aug 2025 03:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755659503; cv=none; b=t0D0sG5VXlYe2btJJL0BmiKunQCaGjQXv6YIe1tXcAaIcHkKZNOJvcP6cPmHf0Z24GQiU4IP/Fb1vjulR20F7Xebt6gMeJeemPAdmREdJtFwCz2XRmXfeqelgYfUGgMN86A5vS/QKgXynAts0u5WrNVEkJkm5MQZeJpgRDU+lDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755659503; c=relaxed/simple;
	bh=9s/5VxVNdQxhkf/qAlrxc4K30roBXgIz6GG233jUOfM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=d+vZxDakOLUXABIpejPW+fuvAkBd3aCCfEc+lEkd4HrkUzYk9LhJnXOf4uJX4ToOLwMoXGDR2Wg0n//K5vJaWdDrHQSbK5Ni4hD9DFvTNzzdPLfsiD8QWQZFIzHCLX8L1qKJmqg/SuOfTovm9+xiR1ah0yXCZJVcYMhDlQDGzzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hU+5giPO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hU+5giPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791F1C16AAE;
	Wed, 20 Aug 2025 03:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755659502;
	bh=9s/5VxVNdQxhkf/qAlrxc4K30roBXgIz6GG233jUOfM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=hU+5giPOHyRNrJ2yyY8g7D/72PTQZXTjInkrdHqY7AJlQJ0qxrfxxdEmG+emAfm3a
	 qRHkXMCFfMuJ3xLXtwJTxAxexzWYRRfxr7PqWOOJVda0FfyO4BV0iUvBC4kBb+BRIe
	 BHzxlrkOyXoJhTaigxiZyVINCJD9Qzce99z3j8A9nzGq0LrQ6b7VnjwLZBP+MGqWAz
	 cFMCOIX0xdBapFlj8OeFEeG0nZQWMtBQYt/I4JIQnXLr1Zry6V2dC3ifNyhwOgTxiK
	 Ed7l91MTtAY1A5okA4kfVC9TOXrI5yXD9GIly7bTSkxwN8uuXpKUXgBnEGUPOESR+P
	 Re+peDXhUQTgA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70D74383BF58;
	Wed, 20 Aug 2025 03:11:53 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/7] net: Convert to skb_dstref_steal and
 skb_dstref_restore
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175565951224.3753798.14794372578854364006.git-patchwork-notify@kernel.org>
Date: Wed, 20 Aug 2025 03:11:52 +0000
References: <20250818154032.3173645-1-sdf@fomichev.me>
In-Reply-To: <20250818154032.3173645-1-sdf@fomichev.me>
To: Stanislav Fomichev <sdf@fomichev.me>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, ayush.sawal@chelsio.com,
 andrew+netdev@lunn.ch, gregkh@linuxfoundation.org, horms@kernel.org,
 dsahern@kernel.org, pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
 steffen.klassert@secunet.com, mhal@rbox.co, abhishektamboli9@gmail.com,
 linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 herbert@gondor.apana.org.au

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 18 Aug 2025 08:40:25 -0700 you wrote:
> To diagnose and prevent issues similar to [0], emit warning
> (CONFIG_DEBUG_NET) from skb_dst_set and skb_dst_set_noref when
> overwriting non-null reference-counted entry. Two new helpers
> are added to handle special cases where the entry needs to be
> reset and restored: skb_dstref_steal/skb_dstref_restore. The bulk of
> the patches in the series converts manual _skb_refst manipulations
> to these new helpers.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/7] net: Add skb_dstref_steal and skb_dstref_restore
    https://git.kernel.org/netdev/net-next/c/c3f0c02997c7
  - [net-next,v2,2/7] xfrm: Switch to skb_dstref_steal to clear dst_entry
    https://git.kernel.org/netdev/net-next/c/c829aab21ed5
  - [net-next,v2,3/7] netfilter: Switch to skb_dstref_steal to clear dst_entry
    https://git.kernel.org/netdev/net-next/c/15488d4d8dc1
  - [net-next,v2,4/7] net: Switch to skb_dstref_steal/skb_dstref_restore for ip_route_input callers
    https://git.kernel.org/netdev/net-next/c/e97e6a1830dd
  - [net-next,v2,5/7] staging: octeon: Convert to skb_dst_drop
    https://git.kernel.org/netdev/net-next/c/da3b9d493ba2
  - [net-next,v2,6/7] chtls: Convert to skb_dst_reset
    https://git.kernel.org/netdev/net-next/c/3e31075a1194
  - [net-next,v2,7/7] net: Add skb_dst_check_unset
    https://git.kernel.org/netdev/net-next/c/a890348adcc9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


