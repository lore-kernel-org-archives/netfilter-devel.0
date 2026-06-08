Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8353B38AD;
	Mon,  8 Jun 2026 22:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780958429; cv=none; b=owJJIxgQjp1EXc2SrueDGugnzXifGMnKFKZA0oHl7xZjfnbj78DCJ3k/PcbLhC1d+rsVbEy19aAq10F+KDfIO9Amtnq8KZteGIs9N+RgG+skl3DuUs3xUEUcHj95sT2e1g/xHDkDPd/pXn9dsvxkOSjM9jfaCmhX830pGYFskQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780958429; c=relaxed/simple;
	bh=aMq1M0qj69R787Xj/nNYV7UAw9xL2+KDIudtfsITjac=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=s6Odf0R6BAj8/cPnPbprSzSpynWEd3sXyzBPIsEbNAZhHPRiGOW3M8hXZFF3I9wlEWVrfEqt7geTklHIT1jC19K93Ljorz44GhhMDYbbDQd8iH14OkfZotPzlE9EJhxIbxvdnRNrxgFmUr3y/nazDwJKk+d8zd1jQnHH15zElSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iYjANFud; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iYjANFud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA661F00893;
	Mon,  8 Jun 2026 22:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780958427;
	bh=GO0S1HJOm9SytwG0IXA8LplGvaWiiJfn5vaj56IKxxw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=iYjANFud7AqA/21sjkYOKNiu8nNwwgBYYEzXqwGBFDEBQsEATrxWJTCp4BeL5Htb0
	 6zVZZxVHE71wqLUJY0dHieLLIVZ752hC5ug3l7cfrB89fDFumxkIZchEL74SoJ+aL4
	 rNFByKGx4mr1yBEgIRMqM8+dxeRQg0BZawOaGLxSNQmKZXLbzswOqYHLEzKSleiP+o
	 SVN//UxpjC3JJ6Tsc0mT44/NiLUXtSjoOPRDM17EAhbH19t5CzagvCJOV1l/7+Qwb/
	 8jTz+gjMYyA64DYVWZCL6IJT0d2CU3gWI+lVo0gil7Bcn6FiFzaOwltPgrULe4S1n4
	 WFDrn5pdqvWFQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A893812FD9;
	Mon,  8 Jun 2026 22:40:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/15] ipvs: add conn_max sysctl to limit
 connections
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178095842640.1698449.18158593378133036098.git-patchwork-notify@kernel.org>
Date: Mon, 08 Jun 2026 22:40:26 +0000
References: <20260607094954.48892-2-pablo@netfilter.org>
In-Reply-To: <20260607094954.48892-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Sun,  7 Jun 2026 11:49:40 +0200 you wrote:
> From: Julian Anastasov <ja@ssi.bg>
> 
> Currently, we are using atomic_t to track the number of
> connections. On 64-bit setups with large memory there is
> a risk this counter to overflow. Also, setups with many
> containers may need to tune the limit for connections.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] ipvs: add conn_max sysctl to limit connections
    https://git.kernel.org/netdev/net-next/c/4a15044a2b06
  - [net-next,02/15] netfilter: nfnetlink_osf: fix mss parsing on big-endian architectures
    https://git.kernel.org/netdev/net-next/c/a625c94144c9
  - [net-next,03/15] netfilter: nfnetlink_cthelper: use {READ,WRITE}_ONCE for accessing helper flags
    https://git.kernel.org/netdev/net-next/c/f8bf5edf7157
  - [net-next,04/15] netfilter: synproxy: drop packets if timestamp adjustment fails
    https://git.kernel.org/netdev/net-next/c/63d29ee95c4a
  - [net-next,05/15] netfilter: synproxy: adjust duplicate timestamp options
    https://git.kernel.org/netdev/net-next/c/22bb132cfb9b
  - [net-next,06/15] netfilter: synproxy: fix unaligned memory access in timestamp adjustment
    https://git.kernel.org/netdev/net-next/c/992c20bc8a4a
  - [net-next,07/15] netfilter: synproxy: protect nf_ct_seqadj_init() with conntrack lock
    https://git.kernel.org/netdev/net-next/c/9e37388b8070
  - [net-next,08/15] netfilter: cttimeout: detach dataplane timeout policy and repurpose refcount
    https://git.kernel.org/netdev/net-next/c/7d6a9cdb8d3a
  - [net-next,09/15] netfilter: nf_conntrack_helper: dynamically allocate struct nf_conntrack_helper
    https://git.kernel.org/netdev/net-next/c/6031487d4e27
  - [net-next,10/15] netfilter: nf_conntrack_pptp: move GRE specific cleanup to GRE tracker
    https://git.kernel.org/netdev/net-next/c/fe97fd540a03
  - [net-next,11/15] netfilter: nf_conntrack_helper: add refcounting from datapath
    https://git.kernel.org/netdev/net-next/c/ac46f3f35b6e
  - [net-next,12/15] netfilter: conntrack: revert ct extension genid infrastructure
    https://git.kernel.org/netdev/net-next/c/35e21a4dccc5
  - [net-next,13/15] netfilter: conntrack: call nf_ct_gre_keymap_destroy() if master helper is pptp
    https://git.kernel.org/netdev/net-next/c/b0f02608fbcd
  - [net-next,14/15] netfilter: flowtable: avoid num_encaps underflow on bridge VLAN untag
    https://git.kernel.org/netdev/net-next/c/e052f920773b
  - [net-next,15/15] netfilter: nf_conntrack: use get_unaligned_be32() in tcp_sack()
    https://git.kernel.org/netdev/net-next/c/d3bf9eae4864

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


