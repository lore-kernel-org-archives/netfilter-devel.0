Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19BFD512;
	Sat,  7 Sep 2024 02:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725675037; cv=none; b=QOmnfYVOCThgQLYf6kwNOanhe17aEgBHOsYTnSK9W53ZhD4jxtLeiIBLm9yYhQ2ybl1cGWUQfahgHYBV9AI/yLUK1sPMK756jnB5EB5hyH13wwKOg6mUW4f2XB7B22fAJY9f8fTaYPjxYmaLKvaE/UbWuwiOsQTQbwgjS3Vz8/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725675037; c=relaxed/simple;
	bh=Bvw0uTGaeVaD5TLnxxP5vTYTRvv6zuVKsP458cctXM0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Ut/XJmrO1k7TFV0xy9WfqVyK2fN+38BsdHqp+ETUSW7iapwGM+hOrnr5BVAjWeNkPOVQiNGKZB/h8ycziZ+MXr69j9VOqXmA5Ok+p9OVAwRzb0vp/LILKI2/cfC4uIbqyOxJeS4ulqZlafcorrmT0JZvwaU3MMIVdzuPti01OQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kbzvLyyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kbzvLyyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58605C4CEC4;
	Sat,  7 Sep 2024 02:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725675036;
	bh=Bvw0uTGaeVaD5TLnxxP5vTYTRvv6zuVKsP458cctXM0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=kbzvLyykRv9+4+z0OSkpU1LhMA/M7tc6vQWMhKHVNos5BNM3W7221lS3l8oasu3X7
	 3d4a+Hrsc8PlEbEMdDb9+P8qt8Z/wB7/q8WotxXTHQ33rb48GoCqHu43bbDDqpDDxu
	 38Zfvi/qJo0+GkjNd2oESUvbWDP3Xgd2l0nW6G5FTL/SgSQQ1DyorImKY/wtTk6xkK
	 1064uffPVaCmqD4QQM0irKPVMK/Lfoos9awv0CJZa5umrlbckjN5ucP/piE8g1vQ0R
	 BrgidqjhvFksXK9280UisRhQvsXq6Rrw044ueH1S6y8TGJvodIhkezLvQNrkWZXFAl
	 xh02qmQ6mFL5g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70CAE3805D82;
	Sat,  7 Sep 2024 02:10:38 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/16] netfilter: ctnetlink: support CTA_FILTER for
 flush
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172567503731.2582309.1861250019019937607.git-patchwork-notify@kernel.org>
Date: Sat, 07 Sep 2024 02:10:37 +0000
References: <20240905232920.5481-2-pablo@netfilter.org>
In-Reply-To: <20240905232920.5481-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri,  6 Sep 2024 01:29:05 +0200 you wrote:
> From: Changliang Wu <changliang.wu@smartx.com>
> 
> From cb8aa9a, we can use kernel side filtering for dump, but
> this capability is not available for flush.
> 
> This Patch allows advanced filter with CTA_FILTER for flush
> 
> [...]

Here is the summary with links:
  - [net-next,01/16] netfilter: ctnetlink: support CTA_FILTER for flush
    https://git.kernel.org/netdev/net-next/c/1ef7f50ccc6e
  - [net-next,02/16] netfilter: nft_counter: Use u64_stats_t for statistic.
    https://git.kernel.org/netdev/net-next/c/4a1d3acd6ea8
  - [net-next,03/16] netfilter: Use kmemdup_array instead of kmemdup for multiple allocation
    https://git.kernel.org/netdev/net-next/c/20eb5e7cb78c
  - [net-next,04/16] netfilter: conntrack: Convert to use ERR_CAST()
    https://git.kernel.org/netdev/net-next/c/09c0d0aef56b
  - [net-next,05/16] netfilter: nf_tables: drop unused 3rd argument from validate callback ops
    https://git.kernel.org/netdev/net-next/c/eaf9b2c875ec
  - [net-next,06/16] netfilter: nf_tables: Correct spelling in nf_tables.h
    https://git.kernel.org/netdev/net-next/c/85dfb34bb7d2
  - [net-next,07/16] netfilter: nf_tables: Add missing Kernel doc
    https://git.kernel.org/netdev/net-next/c/c362646b6fc1
  - [net-next,08/16] netfilter: nf_tables: elements with timeout below CONFIG_HZ never expire
    https://git.kernel.org/netdev/net-next/c/e0c47281723f
  - [net-next,09/16] netfilter: nf_tables: reject element expiration with no timeout
    https://git.kernel.org/netdev/net-next/c/d2dc429ecb4e
  - [net-next,10/16] netfilter: nf_tables: reject expiration higher than timeout
    https://git.kernel.org/netdev/net-next/c/c0f38a8c6017
  - [net-next,11/16] netfilter: nf_tables: remove annotation to access set timeout while holding lock
    https://git.kernel.org/netdev/net-next/c/15d8605c0cf4
  - [net-next,12/16] netfilter: nft_dynset: annotate data-races around set timeout
    https://git.kernel.org/netdev/net-next/c/c5ad8ed61fa8
  - [net-next,13/16] netfilter: nf_tables: annotate data-races around element expiration
    https://git.kernel.org/netdev/net-next/c/73d3c04b710f
  - [net-next,14/16] netfilter: nf_tables: consolidate timeout extension for elements
    https://git.kernel.org/netdev/net-next/c/4c5daea9af4f
  - [net-next,15/16] netfilter: nf_tables: zero timeout means element never times out
    https://git.kernel.org/netdev/net-next/c/8bfb74ae12fa
  - [net-next,16/16] netfilter: nf_tables: set element timeout update support
    https://git.kernel.org/netdev/net-next/c/4201f3938914

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


