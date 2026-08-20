Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7C53B6BEE;
	Thu, 20 Aug 2026 19:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787253699; cv=none; b=O3bspt+/TEQuwwKFp3Fzvqb3asBVXNRRwoqRfg3AS6WOKD0skKxFmMaF9wjtnQyJqLTxoAbQeplvEqmN+trwzhsh3RFit5SKvoa3uE7ZUnK4JK1SJ2t3O11pk0124md35CUBTsIBT8eNQ0YiX65vRRiUU1far839RrANAgGBnK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787253699; c=relaxed/simple;
	bh=+8XCHqy6XMni+PV2WSHAaBn5kyKP+Y8HnO+WTHAUFT8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=msGarS88YwLtKNWzR6sVzClJVauuW5dKHE/GCc3iiPHPFcRwWR4WHgxw1S+w0eK51NGafeExxbOEbM/rzwQLAhpXCb2761oNM1DBwZHyr2IooZ1zJCIzPtXgVAuPAONNtoB8TNfHkmjYsw+l5mV/B16uDTw+SMf2hrRfBL3dru0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hUlp9P4e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hUlp9P4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608F91F00A3A;
	Thu, 20 Aug 2026 19:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787253698;
	bh=3ke803YbDGtkVRlrM1yri7IGu32Rw8qV/NlZLgWKrAc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=hUlp9P4e1blvMBkvZLmPS+NLpVwqcw1IMJSiTbIxQfgCwLzoOBv/OA/KkpLl4zP1V
	 hlEOcWSpR+q8nWNi0BU53fOkl954F7wcCwINAGDvReM49o7fsxFMDBIO2dKIny1zda
	 8Qe+FQdBEvF+MIM1OWNzgDq3jwGpWvSGz4dgIXKiMJBkgzK6EGr/tXBTtbPV3MDiUg
	 ujIHL68KCKr0buiEBmqkk5zuIJSgQry8anEKZs0oxXyIA14ng9jmoFdk0hFfmObd61
	 nf+DnTRg578St1Me/rroUHiVGKWFaHXroTTMd5I4gOwURqx43WJMXhQ/nJJur/Gh1u
	 rX88tIk3fmVGA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D097F392444E;
	Thu, 20 Aug 2026 19:20:49 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/8] netfilter: validate L4 headers after
 userspace
 packet writes
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178725364838.443080.6278729391435867373.git-patchwork-notify@kernel.org>
Date: Thu, 20 Aug 2026 19:20:48 +0000
References: <20260817232957.1281637-2-pablo@netfilter.org>
In-Reply-To: <20260817232957.1281637-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Tue, 18 Aug 2026 01:29:50 +0200 you wrote:
> From: Zhiling Zou <zhilinz@nebusec.ai>
> 
> NFQUEUE and nft_payload can hand packet data modified by userspace back
> to the stack. Recent restrictions keep link and network headers stable,
> but transport header fields can still be changed.
> 
> A packet can therefore keep the same network header and conntrack entry
> while changing the transport header layout. For TCP, increasing doff can
> make later helper or NAT code use a different transport-header base than
> the parser used, and can make offsets point past skb->tail.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] netfilter: validate L4 headers after userspace packet writes
    https://git.kernel.org/netdev/net/c/112e447d17f7
  - [net-next,2/8] netfilter: ipset: remove need to allocate memory on delete operations
    https://git.kernel.org/netdev/net/c/e80456d79ec8
  - [net-next,3/8] netfilter: nf_tables: don't queue packet path object notifications
    https://git.kernel.org/netdev/net/c/7904b94768e9
  - [net-next,4/8] netfilter: nf_conntrack_expect: consolidate check for insertion of dead expectation
    https://git.kernel.org/netdev/net/c/5fc04d4648f4
  - [net-next,5/8] netfilter: ctnetlink: do not expose expectation DEAD flag
    https://git.kernel.org/netdev/net/c/322371b09058
  - [net-next,6/8] netfilter: nf_tables: move set_update_list to nftables per-netns
    https://git.kernel.org/netdev/net/c/b343ededb3f9
  - [net-next,7/8] netfilter: nf_tables: call set ops .commit when building new ruleset blob
    https://git.kernel.org/netdev/net/c/1e3b9e1c77fe
  - [net-next,8/8] ipvs: fix integer overflow in ftp helper port/address parsing
    https://git.kernel.org/netdev/net/c/e625a9477d12

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


