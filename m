Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F01F36493C;
	Thu, 17 Sep 2026 00:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789605679; cv=none; b=mkTwNM4s6ERd5kOlgmRnTy2eUKd/i6aWFWSRlD5lCdooayN0PO3frzVtM5ktB61JyOrGTTjHQPlAjBM3ePiSVQKXTlihwngWzdkUNg68dSj86zG0UdgQkfgpkW8Vm+IztDZXJkQS/mSoHOGB6heuBxQ7e6/aBD/NBR85MogcDVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789605679; c=relaxed/simple;
	bh=cIGG8MrywU06JWY4HtxQRp21kQBKTipQzj1aTbYYqu0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=GxI9xlEOUtj7u7sA3Ao8c23zhuTgoFJBFPu/oT36wFLUOenVWKOPXvkbZNlVmVzulwizLnMPswaIBUm/0QNkRKdRrIgeOwAhe/28aLtQCo/3Bwv2WYf8gIVbJrQmtyWLOgYAhAJZCUbDbEOgO/X3q+1DHqA44FAH5LvNFC5orZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ka9btrc3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ka9btrc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046041F000FF;
	Thu, 17 Sep 2026 00:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789605678;
	bh=wlM0TJObiOt1OgzBhGSGn4AedlVxetW6rGhRumT9QRc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Ka9btrc3xfMNzmm7FPG80EN+OlQKp+owQ5/g1zoKqSPbgFYCQIV684Zyjc5AC+P8G
	 qBrkRh8cjjpt8ur/d8MCBMq/93fy1H1h41h60gP9I6tkckwN/pmbO4kNRIY/GR/XP+
	 38YVBa5eJErv3cGp+Mqu6HljRfPJXck+LEPn1MujK7SwHQUOo+0cBbZBTQsw/hkCTe
	 obh1Qfr/Q2Rl/nAG0WZTLvElEDdDfPeieyvSXVVM2YIVx3RyMnC1NUSbe0kvBQNzcZ
	 Cw5hWJmOV0PYL6cDS+E1ohTxd9Zck6yuisnAoCVO1fJh5L0ppgjHM+eSZ3x7tzDy4j
	 XjMbjdu5ZFBvA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1F08539E9601;
	Thu, 17 Sep 2026 00:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/10] netfilter: flowtable: publish HW_DEAD after
 worker
 is done
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178960561187.3354472.17985830983576758370.git-patchwork-notify@kernel.org>
Date: Thu, 17 Sep 2026 00:40:11 +0000
References: <20260916231652.127456-2-pablo@netfilter.org>
In-Reply-To: <20260916231652.127456-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 17 Sep 2026 01:16:42 +0200 you wrote:
> From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> 
> flow_offload_work_del() sets NF_FLOW_HW_DEAD before the work handler
> clears NF_FLOW_HW_PENDING. Once a flow is both HW_DYING and HW_DEAD, a
> concurrent garbage collection pass can remove it and schedule it for RCU
> freeing.
> 
> [...]

Here is the summary with links:
  - [net,01/10] netfilter: flowtable: publish HW_DEAD after worker is done
    (no matching commit)
  - [net,02/10] netfilter: nfnetlink_queue: hold nfnl mutex in event notifier
    (no matching commit)
  - [net,03/10] netfilter: ip6t_rpfilter: reject routes without inet6_dev
    (no matching commit)
  - [net,04/10] netfilter: ip6t_rt: fix zero-address non-strict match out-of-bounds read
    (no matching commit)
  - [net,05/10] netfilter: nft_synproxy: use the family-aware checksum helper
    (no matching commit)
  - [net,06/10] ipvs: revalidate ihl before icmp_send
    (no matching commit)
  - [net,07/10] ipvs: filter some flags received in the backup server
    (no matching commit)
  - [net,08/10] netfilter: ctnetlink: fix suspicious RCU usage in expect_iter_name
    (no matching commit)
  - [net,09/10] net: remove WARN_ON_ONCE() from the dev_fill_forward_path() loop check
    https://git.kernel.org/netdev/net/c/150dba2c69e9
  - [net,10/10] netfilter: nf_tables: skip expired catchall elements on insert and delete
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


