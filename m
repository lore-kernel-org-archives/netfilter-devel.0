Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C251F7569;
	Thu,  9 Oct 2025 08:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759998021; cv=none; b=B+V5B83Q8yonwBha4T4HDwxtSNBEKn8f1cv/sWyHIdo5Ot3y9mDcBBb9dGnFVdnvxRC81nm0bR9kt5ZHg5yccQwfBJR4oFj1PSFlVZ8Vjf8Fp2vfmxd27SNKpiTPKw2VhRYKr4z3rgv207O7xORuomgtTbcetpzZQmp1yQHDQ7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759998021; c=relaxed/simple;
	bh=+LilCkN8Rg/+FE6al4QbLxMtRzCZS/9knQIipOo+qGw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=sTOQuq+TUNLYOYGeHuWLDn6AQ3s+tndPtcwjFx2OohS8HFxlBwTm1AW88SkFBNbmtZzDsfdhoUhzmpRfc56JY4uY73NHCJAG3gW/8scQBx82IDzqBzvDRX/7JNuM8opgcQPkbYJWuMs63GnrHil4SJLvHIFLPEabq2NyL782NUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EZ32/4sI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EZ32/4sI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411F2C4CEE7;
	Thu,  9 Oct 2025 08:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759998021;
	bh=+LilCkN8Rg/+FE6al4QbLxMtRzCZS/9knQIipOo+qGw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=EZ32/4sInmVutnElkHLlbY7Mm9CMbp5mExAuh3Xanv/ivS+/fEZm9Gp99NggEyye4
	 V/f3vgpOFD95GBsdnk/8qD5WQE2r5NzgY0r4W1JPl9u2SLiDFI4rbLyjqmeCmbnWV/
	 +Pr1fW7VBgMPCfBe0voWVXPd9uUBTbJWWKnBv648YQmrjfrZAjcQ6gS7Qif0FTX5Aq
	 s/QhuIT00HaXqS92Z9YMlprP18P1Okkm27hh3SZ2ZwJUWPBH5p+YLMUKUve/GrfUMP
	 HEbXvUoQlZEi5EVwzyLmbm5tjRLmWgPulb0j8YgkczBlM8qanuqSmTPYij33bcjlCc
	 NzQvNSWp74y0Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADF693A41039;
	Thu,  9 Oct 2025 08:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] netfilter: nft_objref: validate objref and
 objrefmap
 expressions
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175999800951.3823315.17284395638131592357.git-patchwork-notify@kernel.org>
Date: Thu, 09 Oct 2025 08:20:09 +0000
References: <20251008125942.25056-2-fw@strlen.de>
In-Reply-To: <20251008125942.25056-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Wed,  8 Oct 2025 14:59:39 +0200 you wrote:
> From: Fernando Fernandez Mancera <fmancera@suse.de>
> 
> Referencing a synproxy stateful object from OUTPUT hook causes kernel
> crash due to infinite recursive calls:
> 
> BUG: TASK stack guard page was hit at 000000008bda5b8c (stack is 000000003ab1c4a5..00000000494d8b12)
> [...]
> Call Trace:
>  __find_rr_leaf+0x99/0x230
>  fib6_table_lookup+0x13b/0x2d0
>  ip6_pol_route+0xa4/0x400
>  fib6_rule_lookup+0x156/0x240
>  ip6_route_output_flags+0xc6/0x150
>  __nf_ip6_route+0x23/0x50
>  synproxy_send_tcp_ipv6+0x106/0x200
>  synproxy_send_client_synack_ipv6+0x1aa/0x1f0
>  nft_synproxy_do_eval+0x263/0x310
>  nft_do_chain+0x5a8/0x5f0 [nf_tables
>  nft_do_chain_inet+0x98/0x110
>  nf_hook_slow+0x43/0xc0
>  __ip6_local_out+0xf0/0x170
>  ip6_local_out+0x17/0x70
>  synproxy_send_tcp_ipv6+0x1a2/0x200
>  synproxy_send_client_synack_ipv6+0x1aa/0x1f0
> [...]
> 
> [...]

Here is the summary with links:
  - [net,1/4] netfilter: nft_objref: validate objref and objrefmap expressions
    https://git.kernel.org/netdev/net/c/f359b809d54c
  - [net,2/4] bridge: br_vlan_fill_forward_path_pvid: use br_vlan_group_rcu()
    https://git.kernel.org/netdev/net/c/bbf0c98b3ad9
  - [net,3/4] selftests: netfilter: nft_fib.sh: fix spurious test failures
    https://git.kernel.org/netdev/net/c/a126ab6b26f1
  - [net,4/4] selftests: netfilter: query conntrack state to check for port clash resolution
    https://git.kernel.org/netdev/net/c/e84945bdc619

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


