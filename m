Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C223264CB;
	Thu,  5 Mar 2026 16:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772726424; cv=none; b=QFR+7v9INpf1/VzoTyRhB4siyLocskV9dX0gtCo5LLbL/f9d5LaFy9WP+SxnZmzznZsdsguAE5w2/hvpNPeYz+y4lTJQqddRKNcI1f7v4dCQUKaUrvkSBdvNyk+Bk8EMywVARbk/P+ipa1ldnmfo5tvCWtn7IBC1e/AemYmuU5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772726424; c=relaxed/simple;
	bh=9RE6MctA9CP7+0mRcG6DwecWJ5R464xug6Affduv4hY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=SquD2RA6Nk4Ye88mi8TBVFkdu91OMWvpSpFLtHe+FFjBHqk5rpZoHp3T65NF8UwlDOdMtU9eg24MYsDxoeMLeOKEUsrD67Nt9/+7W4Zn2vsPTC/U/6P4qI86kaPk7i+ZubyE62RsC3a1wNdoOjcaWW1mu95IvCWqZErzPkt46tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FtY4RkOE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FtY4RkOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463C2C2BC87;
	Thu,  5 Mar 2026 16:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772726424;
	bh=9RE6MctA9CP7+0mRcG6DwecWJ5R464xug6Affduv4hY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=FtY4RkOELEuZ7R85qHDV5noF4Ne7qj0ziOkjvVWINARLrT2mDTzx8z7Io1RN+ElQt
	 YKKsDsmAosNWdFk8P8R4uIlNayLPnjlPGyBU9mtgzGu2Wj6wvDNApbs65oU+yUL4Ao
	 hBb5k/7lL2f3PyNVMMCBGbiTRUiriP4JcEjmIS4CCoWZPBtaAiAWa135W8kOTFOaYW
	 kbRW/QATNFMsVzCZGFxTUgoPnGHe/zai7znRsyPg+3bj1POaSHCPYNUZJSLvmC+ubH
	 eY+JL0d9wAsymmIVeriIWRkDpvIsq6Sx0zX/V6Z20gKHB8quo8F7xY0UxO7oTgfD2Q
	 8bE1sYiZQWzJQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D0063808200;
	Thu,  5 Mar 2026 16:00:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/3] netfilter: nf_tables: unconditionally bump
 set->nelems before insertion
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177272642430.3184289.6847138664470686647.git-patchwork-notify@kernel.org>
Date: Thu, 05 Mar 2026 16:00:24 +0000
References: <20260305122635.23525-2-fw@strlen.de>
In-Reply-To: <20260305122635.23525-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Thu,  5 Mar 2026 13:26:33 +0100 you wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> In case that the set is full, a new element gets published then removed
> without waiting for the RCU grace period, while RCU reader can be
> walking over it already.
> 
> To address this issue, add the element transaction even if set is full,
> but toggle the set_full flag to report -ENFILE so the abort path safely
> unwinds the set to its previous state.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] netfilter: nf_tables: unconditionally bump set->nelems before insertion
    https://git.kernel.org/netdev/net/c/def602e498a4
  - [net,v2,2/3] netfilter: nf_tables: clone set on flush only
    https://git.kernel.org/netdev/net/c/fb7fb4016300
  - [net,v2,3/3] netfilter: nft_set_pipapo: split gc into unlink and reclaim phase
    https://git.kernel.org/netdev/net/c/9df95785d3d8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


