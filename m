Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7933A3E5577;
	Tue,  8 Sep 2026 21:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788901274; cv=none; b=b98sFKDZ4/E+qvVZ8VEYFSFNISUcRH4/RYu+sedZ/3b+65+WcixB05AIiXmXQQPhx5/zZlsUujrmG0em1vyzvtHKLzw/8PKCghfnZfYeeTqwM1X/U+SYn8CwZKEyJPq8dA9Tryk6vL0XYAAzLI21v+DuEsnRbyMEU37kv+f+qCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788901274; c=relaxed/simple;
	bh=z5U6wbiPwtoaP/AkrT6DTGYDY6ya46MOiTGTstGuOZw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=bfIjaHOvdonbY8FdG2w18nPmD3e4Rx8p92fn5th//ce3MMc4y5pZ3UeBANnXrCI2N08X/bDc0jHpkYylNhFEBU6K188zQmMCYhqUb0GcITOj6X4AFiYeKIxFdnWfXiAeflsyMQOMlbnqaCg9SkECTeDmf2b6lsjAz7KETz0ZTtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WjOVYhFx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WjOVYhFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7DE1F00A3A;
	Tue,  8 Sep 2026 21:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788901269;
	bh=ri2PULpietH3vpI8AOL4JNOQHG8SmDJmaWGd1kUS6T8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=WjOVYhFxQAgN4vfKTlngor4mU6LvUnPzdIqxQb365dzi1qUghfZ8buHbLBQ0MVMo+
	 4l/omzKJMhiZWaw54MF7CWsb19aftOLcUNIyX7ylncPaZigYrIFsE1clCo1nG21ndF
	 7O2XxnoHFD/KZOaX7FEjyywrnD19igKyq1S+3BhO+gKFADg3K2n9wT5zmdXAHPdUhl
	 EMNp/2dFFn+cTGgSLe9YBq5MKuqefhpYcoxsAzZ3g0IcL76LhmqdERHkwRx4zfIcg/
	 R1JAqI6CpnzRIG/d6vF6PNTFTyWCY2n28XGFvQhehyAtxsuT8lih21ZzBuA7RFKiqe
	 6sfl3sJKR1P5w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 198F3380820D;
	Tue,  8 Sep 2026 21:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/9] ipvs: reject invalid states in connection
 template
 sync records
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178890120764.4166699.5576956918061082530.git-patchwork-notify@kernel.org>
Date: Tue, 08 Sep 2026 21:00:07 +0000
References: <20260907171732.1407739-2-pablo@netfilter.org>
In-Reply-To: <20260907171732.1407739-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Mon,  7 Sep 2026 19:17:24 +0200 you wrote:
> From: Kyle Zeng <kylebot@openai.com>
> 
> IPVS sync receivers validate protocol states before creating or updating a
> connection. For connection templates, however, they only log states outside
> the template state range and still store the value in the connection.
> 
> A template can be returned by ordinary connection lookup. TCP and SCTP then
> use the invalid state as an index into their transition tables.
> 
> [...]

Here is the summary with links:
  - [net,1/9] ipvs: reject invalid states in connection template sync records
    https://git.kernel.org/netdev/net/c/74cb39735b6c
  - [net,2/9] ipvs: fix reversed sequence option serialization
    https://git.kernel.org/netdev/net/c/b04578b74f2d
  - [net,3/9] netfilter: nf_conntrack_sip: fix OOB read in sip_skip_whitespace()
    https://git.kernel.org/netdev/net/c/e8f8231824b5
  - [net,4/9] netfilter: cttimeout: prevent UAF during module unload
    https://git.kernel.org/netdev/net/c/fec9b1de0d02
  - [net,5/9] netfilter: nf_log: unregister loggers before per-net teardown
    https://git.kernel.org/netdev/net/c/2c018cc4842c
  - [net,6/9] netfilter: nfnetlink_log: cope with concurrent instance destruction
    https://git.kernel.org/netdev/net/c/387d744fa7e4
  - [net,7/9] netfilter: arp_tables: remove the 32bit compat interface
    https://git.kernel.org/netdev/net/c/0bd7ed1a3263
  - [net,8/9] netfilter: ip6_tables: set F_PROTO when proto value is nonzero
    https://git.kernel.org/netdev/net/c/da4afc5a956d
  - [net,9/9] netfilter: report NLM_F_DUMP_FILTERED when all is filtered out
    https://git.kernel.org/netdev/net/c/7a099b347fef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


