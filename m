Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC3D128369;
	Thu,  3 Oct 2024 10:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727950230; cv=none; b=ojd8EWkpLxPv7Uh10OEph+O6m08R8b5b6XMLLv9MYjTh6zsIN8EAF3x2ATjnjSSIHwMCVsaPhuJ6xpmYx9oJKHkqZu/8qFg8tqHxEELt61J+EgLSBM+Wh0410YxEw3ZoQcqPbYnnxF96MmUbXNKiY5JT+IVLxywr/Nfwl+/W7TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727950230; c=relaxed/simple;
	bh=wRPK1WcxzmiIIFA2eDBK3CpqGK4FoeB45wgtG/rxBHc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ng3lzeDRwbuoMmnPGNXA/Y80ftAUKPUD/HkKY00SvpLvxEpczFdbdkyXRDeGgwXDEta89LkILY2Ng3IfpTzv5e7waNxJZDjVM90Y5Nn4V4uvdRi1sKlbo0RR9JemDDYJkYxUFDK/U6c6FcVekrGxs5cwJhLuGrnfNYk3oN/LBOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bBl5j9Rd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bBl5j9Rd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF52CC4CEC5;
	Thu,  3 Oct 2024 10:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727950229;
	bh=wRPK1WcxzmiIIFA2eDBK3CpqGK4FoeB45wgtG/rxBHc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=bBl5j9RdaKVLTb61oUS3nDBNnkrE+mLo/XMjUQkL9XAUgeYvHwImR0O42dBkF3IHK
	 WpTl2OSu5JWie96yXqNXFEAwaBI6F/O/CAdS5QSbQ09hoJIdgt6y9sohCr5D8vuiE2
	 f15Ffexjgx9Hb8L+4DH+k0QEo1rz8ao8BkZu88Fvb5NZghGH1aA8Vr+QW66WlLU4eC
	 iFi/yqG9RcFSEkzXjXTNUlDhzGTQjkSTlg/AUBbStlFATyTkZ3xQM15xHP+WobeHUv
	 M9UEZqemqLpdLZJvY4+cVJaAaMe72lUN6zAKZYRMkBsSRKad4R3clu00lifRpHe0TX
	 NMDtSZB5n8+Iw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7280D3803263;
	Thu,  3 Oct 2024 10:10:34 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] netfilter: uapi: NFTA_FLOWTABLE_HOOK is NLA_NESTED
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172795023303.1805052.26262604700429116.git-patchwork-notify@kernel.org>
Date: Thu, 03 Oct 2024 10:10:33 +0000
References: <20241002202421.1281311-2-pablo@netfilter.org>
In-Reply-To: <20241002202421.1281311-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed,  2 Oct 2024 22:24:18 +0200 you wrote:
> From: Phil Sutter <phil@nwl.cc>
> 
> Fix the comment which incorrectly defines it as NLA_U32.
> 
> Fixes: 3b49e2e94e6e ("netfilter: nf_tables: add flow table netlink frontend")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/4] netfilter: uapi: NFTA_FLOWTABLE_HOOK is NLA_NESTED
    https://git.kernel.org/netdev/net/c/76f1ed087b56
  - [net,2/4] selftests: netfilter: Fix nft_audit.sh for newer nft binaries
    https://git.kernel.org/netdev/net/c/8a8901564451
  - [net,3/4] netfilter: nf_tables: prevent nf_skb_duplicated corruption
    https://git.kernel.org/netdev/net/c/92ceba94de6f
  - [net,4/4] selftests: netfilter: Add missing return value
    https://git.kernel.org/netdev/net/c/10dbd23633f0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


