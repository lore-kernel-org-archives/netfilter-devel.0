Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8804AA575;
	Thu, 24 Sep 2026 17:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790269880; cv=none; b=aR1CUrY6LKLids1Ybpt0GTGqpFGtTbObMk6Rp4ezEX0BYZ7MqNxL7wWZJy6f9Mhg4onwNV14e8NWZvjiP80NGlhNPYT5uzqSXOyNIEao5L4NHhIeg96pWV6SCwwNKummfiSYRsWtFrW7dgQwLaEQFKVb5xgZPmpc87YbmfNAeBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790269880; c=relaxed/simple;
	bh=H2RZtwN55iyUndRZIvhI3hlFl4/WerD7LUZ4A+Rrqf0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=k4B04e2XmhC/AEeJGQ8HA090Zx8jlgZyPfd8VLoKjlx3xuFIXuaHV9ckzWNPw15ajLmYffSWYe9/L3kzhh0+ijrG2PLBLk99D8UIKil5L52wrk867N8EkPaLAynwHSpmDWbZBU6MaqEtmjbTOdrvLtNMIJ03GhMWn0Makw2UAtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VvOiq9iW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VvOiq9iW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A461F000FF;
	Thu, 24 Sep 2026 17:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790269878;
	bh=sQ4jIrGAyy+sXSCY67d4ivfb4HhGDucvidn4UM9zLik=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=VvOiq9iWICgH1eUexCIx/Vw9UIoEgbAl7KN/UAWYcVAqOPjpTNH/LlK+uTs/bLvc4
	 FEq3wprOipwVUCFQtc9OUKYnrMyJs+X9X7UNGlckXmoYA1YVqDf0BwYdMP8gSWcYMs
	 p+d3+2bRq/3Ij3nPrC9ysPeXi+bJh1XcK7BzlwcKVKQxwFRoyIiI5DpeH85hbovCmj
	 HdARdgkOcHMhLfjs3Ur9Vjpox5Xl13TcBXConYg3VVxpfzf1hdEwUJpngtv32iBkGD
	 e/4rRS/+AldgeGERjxrnYFHV5k3TzS6yoaKA8b9iCax0PoXaUoGXochifksDK2t4cG
	 1ox/7e1LtiHOw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 197E83A566D8;
	Thu, 24 Sep 2026 17:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/6] ovs,
 net/sched: fixes for UAF after conntrack extension realloc
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179026980789.1660211.3594166480320457976.git-patchwork-notify@kernel.org>
Date: Thu, 24 Sep 2026 17:10:07 +0000
References: <20260921145655.3167436-1-i.maximets@ovn.org>
In-Reply-To: <20260921145655.3167436-1-i.maximets@ovn.org>
To: Ilya Maximets <i.maximets@ovn.org>
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, aconole@redhat.com, echaudro@redhat.com, jhs@mojatatu.com,
 jiri@resnulli.us, lucien.xin@gmail.com, marcelo.leitner@gmail.com,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, dev@openvswitch.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 21 Sep 2026 16:55:42 +0200 you wrote:
> One clean up change plus two fixes for the UAF on helper extension
> realloc x 2.  First half for OVS and the second half for the similar
> code in act_ct.  This should cover all the known cases of this problem
> in these two modules.
> 
> 
> Ilya Maximets (6):
>   net: openvswitch: conntrack: avoid modifying shared unconfirmed ct
>     entry
>   net: openvswitch: conntrack: remove 'add_helper' dead code
>   net: openvswitch: conntrack: fix helper UAF due to extensions realloc
>   net/sched: act_ct: avoid modifying shared unconfirmed ct entry
>   net/sched: act_ct: remove 'add_helper' dead code
>   net/sched: act_ct: fix helper UAF due to extensions realloc
> 
> [...]

Here is the summary with links:
  - [net,1/6] net: openvswitch: conntrack: avoid modifying shared unconfirmed ct entry
    https://git.kernel.org/netdev/net/c/26b2bd70d224
  - [net,2/6] net: openvswitch: conntrack: remove 'add_helper' dead code
    https://git.kernel.org/netdev/net/c/5e6c14dd42a1
  - [net,3/6] net: openvswitch: conntrack: fix helper UAF due to extensions realloc
    https://git.kernel.org/netdev/net/c/1a4151e6be57
  - [net,4/6] net/sched: act_ct: avoid modifying shared unconfirmed ct entry
    https://git.kernel.org/netdev/net/c/f85009dfcd65
  - [net,5/6] net/sched: act_ct: remove 'add_helper' dead code
    https://git.kernel.org/netdev/net/c/00df72e39f30
  - [net,6/6] net/sched: act_ct: fix helper UAF due to extensions realloc
    https://git.kernel.org/netdev/net/c/dad19b59da05

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


