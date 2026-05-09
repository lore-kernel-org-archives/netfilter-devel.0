Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515F2278156;
	Sat,  9 May 2026 01:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778290873; cv=none; b=DwEcyjT8dzjSej1tFKhXr2pLU+oLk1RICh35cPIug1VH9/u9LF5FcM3yc9VZ6kR7i3xtmStxio79N9wEtvwFLQ/Fl9NoVDnBm3MGL9aeWOEInNtDhAvZSV/esIub2NOpzU3qjs+XpwcjRMwchSd2JIudJ3yVHllktNxbarrgJgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778290873; c=relaxed/simple;
	bh=LPHO7mWMRRT8fu6h/79gWlYEjg9jE+RXDoObQaxTUSk=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=nsraXsBj3iET8Z66g6zwZBdaLs3vTZC0D7vHKTONUtVKAipgzo/rBJad1A1Uotpj/rMMaWeh4TmXhGn0TA5QfcL1YIHtb6S0sVJi1h8wsVRGqNlzXkA69BqZynlWiHaHnKNyucab4sWhlmYGye51vZbCbjkqhyssVE2V8A5sKkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lNSqAgvs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lNSqAgvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED232C2BCB0;
	Sat,  9 May 2026 01:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778290873;
	bh=LPHO7mWMRRT8fu6h/79gWlYEjg9jE+RXDoObQaxTUSk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=lNSqAgvsqnAMn0JbjXmj1zhPby6CXnj9hhdr6cGkCv0HSYT3IWeGyApFL2FokkEtV
	 dzFaRDt75KtH4QJCL12PGxvZqDQuprlGo5F2KiMk/YioYX4LfH3w6dTVEDXEQzEPsY
	 8LYTK+Iortxhlq3Yt4eq41oiBV5XltdHDcfFncRApHD7t4BEhe0k6cp+dw+j58BlJg
	 9zA5c4cD/LbaY2J22PwxnygdB+rwPy8jaPUreBzVSGHf0HFtwxpydPZ1Saez0sYwWL
	 YlDpZJt5U01T7ONSSgnwPwQjzdEoxrrQea3yMtsfRPnvgHlw49adrwkbNWHTHsw497
	 /3svYnNM45tLA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CEF738119E4;
	Sat,  9 May 2026 01:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/13] netfilter: x_tables: allow initial table
 replace
 without emitting audit log message
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177829082130.929250.13481267199654221976.git-patchwork-notify@kernel.org>
Date: Sat, 09 May 2026 01:40:21 +0000
References: <20260507234509.603182-2-pablo@netfilter.org>
In-Reply-To: <20260507234509.603182-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri,  8 May 2026 01:44:57 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> At the moment we emit the audit log a bit too early, which makes it
> necessary to also emit an unregister log in case we have to unwind
> errors after possible hook register failure.
> 
> Followup patch will be slightly simpler if we can delay the
> register message until after the hooks have been wired up.
> 
> [...]

Here is the summary with links:
  - [net,01/13] netfilter: x_tables: allow initial table replace without emitting audit log message
    https://git.kernel.org/netdev/net/c/8e72510db9fa
  - [net,02/13] netfilter: x_tables: allocate hook ops while under mutex
    https://git.kernel.org/netdev/net/c/b62eb8dcf2c4
  - [net,03/13] netfilter: x_tables: add and use xt_unregister_table_pre_exit
    https://git.kernel.org/netdev/net/c/527d6931473b
  - [net,04/13] netfilter: x_tables: unregister the templates first
    https://git.kernel.org/netdev/net/c/d338693d7785
  - [net,05/13] netfilter: x_tables: add and use xtables_unregister_table_exit
    https://git.kernel.org/netdev/net/c/b4597d5fd7d2
  - [net,06/13] netfilter: ebtables: move to two-stage removal scheme
    https://git.kernel.org/netdev/net/c/b7f0544d86d4
  - [net,07/13] netfilter: ebtables: close dangling table module init race
    https://git.kernel.org/netdev/net/c/92c603fa07bc
  - [net,08/13] netfilter: x_tables: close dangling table module init race
    https://git.kernel.org/netdev/net/c/16bc4b6686b2
  - [net,09/13] netfilter: bridge: eb_tables: close module init race
    https://git.kernel.org/netdev/net/c/27414ff1b287
  - [net,10/13] netfilter: nf_conntrack_expect: restore helper propagation via expectation
    https://git.kernel.org/netdev/net/c/dcb0f9aefdd6
  - [net,11/13] netfilter: ctnetlink: check tuple and mask in expectations created via nfqueue
    https://git.kernel.org/netdev/net/c/d8ef54c83ad7
  - [net,12/13] netfilter: nf_conntrack_sip: get helper before allocating expectation
    https://git.kernel.org/netdev/net/c/eb6317739b1e
  - [net,13/13] netfilter: nft_ct: fix missing expect put in obj eval
    https://git.kernel.org/netdev/net/c/19f94b6fee75

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


