Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9984F22FE0E;
	Wed,  5 Aug 2026 23:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785973874; cv=none; b=u/4A9fVPIjpbKo8zmBCY3LBhUaNX6lv9SG8e+2eqyhNTF0mwOUWjXXnpDZH2wAO8BwYMEicdZRXtkXMEzGxRslMUBVKa6qNd8WXxzYPxo96LY+LKVpQNAHh6Z0rms3QskJT6VY1yzH/d/Jf9fsif8QqUqooxXm9nOUGMgL0l5ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785973874; c=relaxed/simple;
	bh=5bh9bF8EQwbNC2RCeRXDIYkwJuoBmNsasa7XWMZezSw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=QBrBAKA7KJI1Gy7/+2O/niDqeQZ7b1V7QlOWAhBC8FXG8bNVGfAS3UJ/0laSS6Lh2avLcbWSRsgItxlEnpCzddrRd8O34qofWbdjMAmKmMFD7X+Sd3/ZMS+i+ipsc6BrXxT5iAAkc8uVYSlBrPyBioTZFgJBQkIZYT7BR417xbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ld9BMXD9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ld9BMXD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274A41F000E9;
	Wed,  5 Aug 2026 23:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785973873;
	bh=OeTYL1qcMHRxHljvnv2trtnECcdQYdHf+WiYN3CgoU4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Ld9BMXD9fQKInIJzoffX+y03AXdZ+tWmW/gr35jUWOMKwjavnbprbvs4LwlN+SA6O
	 WLrCXdJ0TWQfoilMrS4T3dP1qi9zhNYtGryUvnF+JTxSQs63Pwuw0YlMCWMdCAjqrU
	 Ru+Q0W90/3KuAOo/pPjDWCkMz0sdEIEWpYx5iLsTKHaeEvc95MhDlAFXDUx883HBfO
	 9ajOISwTyE6H+InmjH6x2sE/8636o74h2IZPmHeAgvWQaIPScHxNQ7rKNhWLK3m8om
	 uyxxBViEHJcipRz+GD00Iqmw5i1Wcg8fpoPVaCmx0sfbC+mtUgbwib3bEfEEeNwWxv
	 J4LkHUB4BfpRQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1977C392FFD8;
	Wed,  5 Aug 2026 23:50:34 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/9] netfilter: conncount: normalize tuple and
 zone
 on successful ct lookup
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178597383266.567483.8728487954347201602.git-patchwork-notify@kernel.org>
Date: Wed, 05 Aug 2026 23:50:32 +0000
References: <20260731153402.851224-2-pablo@netfilter.org>
In-Reply-To: <20260731153402.851224-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri, 31 Jul 2026 17:33:54 +0200 you wrote:
> From: Fernando Fernandez Mancera <fmancera@suse.de>
> 
> When get_ct_or_tuple_from_skb() falls back to looking for a connection
> via nf_conntrack_find_get(), a successful lookup sets ct but leaves
> tuple and zone unupdated.
> 
> If the packet belongs to a reply flow, tuple will remain in the reply
> direction. As conncount relies on the original direction tuple to count
> the connections consistenly, passing an unnormalized reply tuple could
> lead to problems.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] netfilter: conncount: normalize tuple and zone on successful ct lookup
    https://git.kernel.org/netdev/net-next/c/e53932f0e5de
  - [net-next,2/9] netfilter: flowtable: consolidate net_device field in nft_forward_info struct
    https://git.kernel.org/netdev/net-next/c/f19fd12143db
  - [net-next,3/9] netfilter: flowtable: consolidate flowtable device check
    https://git.kernel.org/netdev/net-next/c/df1705f289ba
  - [net-next,4/9] net: dsa: stop at the user device in .fill_forward_path
    https://git.kernel.org/netdev/net-next/c/5be6e044bea6
  - [net-next,5/9] net: do not advance stack index from dev_fwd_path()
    https://git.kernel.org/netdev/net-next/c/5deda60c56ee
  - [net-next,6/9] net: pass dst via net_device_path in dev_fill_forward_path()
    https://git.kernel.org/netdev/net-next/c/0ad8404e7766
  - [net-next,7/9] netfilter: flowtable: release tunnel route on error when building forward path
    https://git.kernel.org/netdev/net-next/c/806273fcaffb
  - [net-next,8/9] netfilter: nf_tables: call skb_valid_dst() before skb_dst()
    https://git.kernel.org/netdev/net-next/c/689db98e535b
  - [net-next,9/9] netfilter: conntrack: tcp: use UNACK timeout for non-closing RST packets
    https://git.kernel.org/netdev/net-next/c/bf80e6802273

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


