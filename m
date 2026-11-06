Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793997618;
	b=jyzr40O8MyZeT5/dXvNSKUrPZ0NJjcm7ICF/ewUacWu+tEkJiw2PWeW4bVmpZrz+LI5k
	 sGmOajcA28pzLoCETYrmEvDVMDRfGfjDR+KgfygiLVjVr/mv/nthQIuP/3qMO5YumLFrM
	 7rA2SokBt1JBxGpa/FEFA680ARVlxyrOPOWhmABi/iPwBYDkMPhRk1/V5R5S5ta25C5/k
	 qNaV6PXH3zbOWYXmk5uniZ0vj5gL3sX8fl2BNfNbV0x5qmdSvxSdDpR/u3jvK72OxR+eh
	 2ABfM4T0dJ6pCedfgdRwN+TioNWshf1vO7BO67KCHPw3Q80zBadq12aigEeHIF+7SQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793997618;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=mIUbe6fcF91HcT1UswK+wMpzvR7MDuAa6exAKta0fKQ=;
	b=R7+YgUZ8czWqzkdmJe3r/fiKTKhsFYIAtquEj5ke/B9yrdbzo7VSc+XpEIHa12CZd/fY
	 IsLxlI/uMjTOA9IUCW+xgqWLHOvatNYJ2UBUbPNS7ZZTYVBXVW8GJIa1f5ET6LNU/Y30q
	 yWjf8nI0k4e8/iqoRcF4EHHLcsYt4uDp9OEclByrBfq6OEbLL4qLHfameM8TtIQ5RdTvn
	 rZ5X5+C791ghxwWPTbTYPxUb/TD98325Hf0eHAlctBnr6lRTYyyI61DUoETev0dwzqVYz
	 YvS4F7lZL/3+Iu1N3ZSB75Qu8ZymfLYQoH6cft6mVhbWRRaGauiNa5uF53YnwvEZN7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="GS//Ttmx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55455606A326;
	Fri,  6 Nov 2026 20:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GS//Ttmx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CF31F0089F;
	Fri,  6 Nov 2026 20:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793997617;
	bh=mIUbe6fcF91HcT1UswK+wMpzvR7MDuAa6exAKta0fKQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=GS//Ttmxj9mGEbvdlQMSJhepK5bPm/9ZLH1H6t+UqagEknDOYJBC4lxtcIzVDpwYB
	 HJS5Xy88lDBgd8ZaZwUjvQbCI1Di/VTbgWTznwUPozWMJhg+YtUvRI2e/uji+TJ0hb
	 A8XbFTw3UP/gM/4DAdxKhYFxbX5xYW9aFWEDSUbPUYe9dhywLgGYExZhc776tNW47l
	 iaO6J/fU37OOA7+Aoi2OgxXGxTLYy4VuvL70zF+/YAIXGxPnKi3gow1Hw/FqgUy98g
	 lGvyz2jcq5BrxnOQDm0KVhgZzIfyLE0Tb+K4f7GwJGz5vc4afhtshOnxQBZFFMdg+e
	 UT2N5lJEhl/5g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D830B3A5499A;
	Fri,  6 Nov 2026 20:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/12] netfilter: nft_reject: prevent unbounded
 recursion
 in output hooks
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179399761642.859444.1171675852948516756.git-patchwork-notify@kernel.org>
Date: Fri, 06 Nov 2026 20:40:16 +0000
References: <20261105124536.1009301-2-pablo@netfilter.org>
In-Reply-To: <20261105124536.1009301-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu,  5 Nov 2026 13:45:25 +0100 you wrote:
> From: Fernando Fernandez Mancera <fmancera@suse.de>
> 
> nftables payload-mangling rules can rewrite packet contents (such as TCP
> flags) before they are evaluated by reject targets. This defeats the
> content-based loop guards, allowing unbounded hook recursion that leads
> to kernel stack exhaustion and panics.
> 
> [...]

Here is the summary with links:
  - [net,01/12] netfilter: nft_reject: prevent unbounded recursion in output hooks
    https://git.kernel.org/netdev/net/c/d6c18cadfc6c
  - [net,02/12] ipvs: Defer application parent freeing until after RCU readers
    https://git.kernel.org/netdev/net/c/1e0808008e44
  - [net,03/12] ipvs: fix protocol data lifetime during namespace teardown
    https://git.kernel.org/netdev/net/c/832aa3e89e80
  - [net,04/12] netfilter: nf_dup: preserve guard across NFQUEUE reinjection
    https://git.kernel.org/netdev/net/c/82052e5b5ec3
  - [net,05/12] netfilter: flowtable: extend ct timeout of offloaded GRE flows
    https://git.kernel.org/netdev/net/c/46ecda278f6e
  - [net,06/12] netfilter: nft_set_rbtree: check catchall_sync return before queue_done
    https://git.kernel.org/netdev/net/c/1cec19d70bc2
  - [net,07/12] netfilter: bridge: use DEBUG_NET_WARN_ON_ONCE in nf_ct_bridge_refrag()
    https://git.kernel.org/netdev/net/c/683ff28ab18a
  - [net,08/12] netfilter: x_tables: check target name before accessing verdict
    https://git.kernel.org/netdev/net/c/364b200285bb
  - [net,09/12] netfilter: nf_conntrack_sip: fix OOB read in ct_sip_parse_transport()
    https://git.kernel.org/netdev/net/c/7af52bda65c0
  - [net,10/12] netfilter: nf_tables: fix memleak when rule deletion fails with hardware offload
    https://git.kernel.org/netdev/net/c/e95b3be75ae0
  - [net,11/12] netfilter: xt_recent: do not call remove_proc_entry() under recent_lock
    https://git.kernel.org/netdev/net/c/17c2e41736b6
  - [net,12/12] netfilter: nat: zero newrange before filling it in
    https://git.kernel.org/netdev/net/c/d1bb235aa409

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


