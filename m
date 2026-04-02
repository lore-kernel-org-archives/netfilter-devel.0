Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829D3CA6F;
	Thu,  2 Apr 2026 02:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775097033; cv=none; b=Rl/WcRACKv/5GGx8zEEi9ATDWgI0VfZlhJUs9zIhY+b5O6d9jEbXgFWBthsLM+EWpDjOeJC/Kd9QFWon0dhjxMERI4PdsTCoyQt+4O4vW0CtCfgz9a3QsbXhB3a9NeOyfzebis8AY14SpZlpaTVXfmT4FUih4SIcRjZvlLvaNB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775097033; c=relaxed/simple;
	bh=0t2FTGPpUs8MIzO5VovB547dkJjFvPxp7Cug6WWD60I=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=dyqGJHgAkL2vtZiSC0r3yvtrp1uxX+RfhQBCPewcSubTH1fumY/Wx8wR8pko1aD9UU4FMGWfzdhnkg1RofLlqA33gTCfmdn6WVEHFEqZIGhyhHl4jwrOK02VWYuItyDMvy1U1x3DYyMYgXcoWIoG3kft8cI6RLLg0Oi9mE7hZJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tc0skWy9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tc0skWy9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C39C4CEF7;
	Thu,  2 Apr 2026 02:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775097033;
	bh=0t2FTGPpUs8MIzO5VovB547dkJjFvPxp7Cug6WWD60I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=tc0skWy9NtWVgafam0nyP7sKy7W734ZMjZy2O088/BeKASmhmbr+qaxOwnkZdaYw2
	 f7EZgtHwo2arUzZ2InnJxjUZ6czyrsrqrpTl3xCwuyG9x/HzutqLdY0uwoQXke3+3e
	 VK90V40lgJWYAUtl3iJk0E28GZmO3TrWXSB6MECPax6UhMesBzWb+ycmxeHyTP8Ks5
	 2o+VOS8nQvW339qugUhQY2msIK2yEYinH2IsgmJXDPkktohlDYMwXj/KCfoae/pEMc
	 GmI77MX7atD48GIiZYGV7EqXVCQDweVCFpvvji4URmaGHT71Z1AeaKW0KD+jRxQhqn
	 iTGlTyRMbKG+w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02F273808203;
	Thu,  2 Apr 2026 02:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/10] netfilter: flowtable: strictly check for
 maximum
 number of actions
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177509701579.3957493.7764709553225868642.git-patchwork-notify@kernel.org>
Date: Thu, 02 Apr 2026 02:30:15 +0000
References: <20260401103646.1015423-2-pablo@netfilter.org>
In-Reply-To: <20260401103646.1015423-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed,  1 Apr 2026 12:36:37 +0200 you wrote:
> The maximum number of flowtable hardware offload actions in IPv6 is:
> 
> * ethernet mangling (4 payload actions, 2 for each ethernet address)
> * SNAT (4 payload actions)
> * DNAT (4 payload actions)
> * Double VLAN (4 vlan actions, 2 for popping vlan, and 2 for pushing)
>   for QinQ.
> * Redirect (1 action)
> 
> [...]

Here is the summary with links:
  - [net,01/10] netfilter: flowtable: strictly check for maximum number of actions
    https://git.kernel.org/netdev/net/c/76522fcdbc3a
  - [net,02/10] netfilter: nfnetlink_log: account for netlink header size
    https://git.kernel.org/netdev/net/c/6d52a4a0520a
  - [net,03/10] netfilter: x_tables: ensure names are nul-terminated
    https://git.kernel.org/netdev/net/c/a958a4f90ddd
  - [net,04/10] netfilter: ipset: use nla_strcmp for IPSET_ATTR_NAME attr
    https://git.kernel.org/netdev/net/c/b7e8590987aa
  - [net,05/10] netfilter: nf_conntrack_helper: pass helper to expect cleanup
    https://git.kernel.org/netdev/net/c/a242a9ae58aa
  - [net,06/10] netfilter: ctnetlink: zero expect NAT fields when CTA_EXPECT_NAT absent
    https://git.kernel.org/netdev/net/c/35177c687713
  - [net,07/10] netfilter: ctnetlink: ignore explicit helper on new expectations
    https://git.kernel.org/netdev/net/c/917b61fa2042
  - [net,08/10] netfilter: ipset: drop logically empty buckets in mtype_del
    https://git.kernel.org/netdev/net/c/9862ef9ab0a1
  - [net,09/10] netfilter: x_tables: restrict xt_check_match/xt_check_target extensions for NFPROTO_ARP
    https://git.kernel.org/netdev/net/c/3d5d488f1177
  - [net,10/10] netfilter: nf_tables: reject immediate NF_QUEUE verdict
    https://git.kernel.org/netdev/net/c/da107398cbd4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


