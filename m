Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0F5405ABA;
	Thu, 26 Mar 2026 15:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774539040; cv=none; b=t08+BHlK9p/G0MhONvdm4WI49lWMjZMNH+jfpgKnRCcIsB+awP5GcmTX7xdelMIIifsJ3ZDUZVI6Vw8oL1ekgYAL6EWjgO+Oelo0FX2H3Qn9UNGz2SCFmPWrUXKekLHyogVcda/lKa5JuOzub5u211j34e1rawz3LLx19LK7WUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774539040; c=relaxed/simple;
	bh=ZQwez07XLSJsXDc9l7YfbnM/Xp0EDdsgP+/RzA+qKew=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=TuP2+vNjFGEqrhVndyZoWcPPGzMCC7ho8MO2ujBlStWCd2fs3Rn6xE4zvkz/m/o1zBvtIJCsnwzfPACek/fnHliyNyUPoh0c9tXoTAmV1O//AT+VqvSc9DkPbzJ+2aPWftCDBk/JoF3Tl/HTq7OHJAcgM3ghUzHl6FBQddqPl18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PMxUwqvs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PMxUwqvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A16C116C6;
	Thu, 26 Mar 2026 15:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774539039;
	bh=ZQwez07XLSJsXDc9l7YfbnM/Xp0EDdsgP+/RzA+qKew=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=PMxUwqvsjs13g3BlZymlEsUxk8eCNIoOR+5lyVythsSxd3WY7YhyfLGcjqQDjR84y
	 D1b14EYNN4MbvgcqivTxDn9eLfdnPCAQhGT2pxpyOb+nEm0ww3r4QBXtxKzhlHl5JN
	 4+1XiJUxn6l1a3k23IYoIOt5kLvfOMoLsxNGw+XXmXadp9cBC7WjSBsWKWnZLYveV7
	 DuROvl7sVLGH3WmPwgey+DCWOdhe9uCgwnXOCE7TVsdnNVP6vqDsvJ9S61A98/Wue1
	 MwIng9VIGINNp/c7kAjwFjnxXT+TMjg2Nk1gLQ+OlaEOArHpZG8OtMfe02VC1RQ591
	 U0W2UYzxzSTbA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FF2F39EFA69;
	Thu, 26 Mar 2026 15:30:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/12] netfilter: nft_set_pipapo_avx2: don't return
 non-matching entry on expiry
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177453902605.2636466.17922004373589340158.git-patchwork-notify@kernel.org>
Date: Thu, 26 Mar 2026 15:30:26 +0000
References: <20260326125153.685915-2-pablo@netfilter.org>
In-Reply-To: <20260326125153.685915-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 26 Mar 2026 13:51:42 +0100 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> New test case fails unexpectedly when avx2 matching functions are used.
> 
> The test first loads a ranomly generated pipapo set
> with 'ipv4 . port' key, i.e.  nft -f foo.
> 
> [...]

Here is the summary with links:
  - [net,01/12] netfilter: nft_set_pipapo_avx2: don't return non-matching entry on expiry
    https://git.kernel.org/netdev/net/c/d3c0037ffe12
  - [net,02/12] selftests: netfilter: nft_concat_range.sh: add check for flush+reload bug
    https://git.kernel.org/netdev/net/c/6caefcd9491c
  - [net,03/12] netfilter: nfnetlink_log: fix uninitialized padding leak in NFULA_PAYLOAD
    https://git.kernel.org/netdev/net/c/52025ebaa29f
  - [net,04/12] netfilter: ip6t_rt: reject oversized addrnr in rt_mt6_check()
    https://git.kernel.org/netdev/net/c/9d3f027327c2
  - [net,05/12] netfilter: nft_set_rbtree: revisit array resize logic
    https://git.kernel.org/netdev/net/c/fafdd92b9e30
  - [net,06/12] netfilter: nf_conntrack_expect: honor expectation helper field
    https://git.kernel.org/netdev/net/c/9c42bc9db90a
  - [net,07/12] netfilter: nf_conntrack_expect: use expect->helper
    https://git.kernel.org/netdev/net/c/f01794106042
  - [net,08/12] netfilter: ctnetlink: ensure safe access to master conntrack
    https://git.kernel.org/netdev/net/c/bffcaad9afdf
  - [net,09/12] netfilter: nf_conntrack_expect: store netns and zone in expectation
    https://git.kernel.org/netdev/net/c/02a3231b6d82
  - [net,10/12] netfilter: nf_conntrack_expect: skip expectations in other netns via proc
    https://git.kernel.org/netdev/net/c/3db5647984de
  - [net,11/12] netfilter: nf_conntrack_sip: fix use of uninitialized rtp_addr in process_sdp
    https://git.kernel.org/netdev/net/c/6a2b724460cb
  - [net,12/12] netfilter: ctnetlink: use netlink policy range checks
    https://git.kernel.org/netdev/net/c/8f15b5071b45

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


