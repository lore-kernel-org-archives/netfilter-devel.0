Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8EC29992B;
	Wed, 30 Sep 2026 01:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790730008; cv=none; b=Pi4JLLbe6saFhcoPQXNrno2rybwADAjHBN0ltAPyXs3bz02U+dTnEJb/QWhVyDZfJwXH22AaCuQGthpvAXFvh89zv0KueOxu1ct9IyRXmaSjlrvRsaSGVkUUBQfHtmroMmM3IHyC30aBOM7qxHKPuBY8luAYAlTpusoS6zjbNtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790730008; c=relaxed/simple;
	bh=g4lqI+UlLP2jTMRtKnIafFUzmgTUXqRcHQxt3HYYiyQ=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=njN5aBVPfIYcH3YtCP/e6PDON7kjZP/ecvuJPrRE3kZkTEgcklbknFnFZTTA1EbD7VfwCO1fy07DA2kjr2eb7IgMK8QKJkEDVM6GOE+dYkgQKx4Ytvss4QsbXeUQLPrfsKs8dKOHnc10qjLG9bn1S0Atki7GyUcgKbYGaf6OPPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kXlQilXt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kXlQilXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C5A1F000FF;
	Wed, 30 Sep 2026 01:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790730006;
	bh=gBwoenYYaanfEUjFb75TeKF849XqV21SDq/Ipm1oCOo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=kXlQilXt/jQ6C/PpMmxLhS1r8ATYgeozIzySOVxGgikqMGTMKm8+h+7s9NtLAW39c
	 OZ9if6LIzi4LTLKWJCPtxS+/6aYKgcw2yNKrMDTJsaS+msNRbx9HqSRi5BgpVeVvlZ
	 2H5MD/4aNFNqrvwDkKGNScjbPnB5LXdDByA/4niw6qgmudNgykF8qhtAsqK4ZpOCNv
	 Ea75DcxjmwvWzr3hKGOMZDObHIVpKQ9MbIA0RFDfXowvLuGd/99wfr6Ue4z5jnLm0i
	 mRhBE0ptvzJPKHB9zaXfE0ifUzfbV+Wtd0HD9gp1VZykDOhtd3ZiZO2hER9n4U/VdD
	 5MEDqbZ1SIGxQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B44C83924FEA;
	Wed, 30 Sep 2026 01:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4] net: cap skb->queue_mapping when the tx queue is
 picked
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179073000531.1189496.11934598043526371680.git-patchwork-notify@kernel.org>
Date: Wed, 30 Sep 2026 01:00:05 +0000
References: <QDISC-9R8V.v4.20260928081529@mojatatu.com>
In-Reply-To: <QDISC-9R8V.v4.20260928081529@mojatatu.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 jiri@resnulli.us, vinicius.gomes@intel.com, horms@kernel.org,
 xiangxia.m.yue@gmail.com, bigeasy@linutronix.de, clrkwllms@kernel.org,
 rostedt@goodmis.org, victor@mojatatu.com, zdi-disclosures@trendmicro.com,
 hybris@mojatatu.ai, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-rt-devel@lists.linux.dev, stable@vger.kernel.org, edumazet@google.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 28 Sep 2026 08:46:16 -0400 you wrote:
> skbedit can set skb->queue_mapping and raise the per-CPU skip_txqueue
> flag so __dev_queue_xmit() honours the mapping. __dev_queue_xmit()
> cleared the flag before sch_handle_egress() and only read it afterwards,
> so the flag was not confined to the xmit that set it: a nested xmit
> (mirred redirect or mirror, or a drop after skbedit) could set the flag
> and the outer xmit would consume it for an skb that never went through
> skbedit.
> 
> [...]

Here is the summary with links:
  - [net,v4] net: cap skb->queue_mapping when the tx queue is picked
    https://git.kernel.org/netdev/net/c/ea4d4b5dddb5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


