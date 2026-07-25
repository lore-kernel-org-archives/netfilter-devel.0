Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EE42F5498;
	Sat, 25 Jul 2026 00:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784938857; cv=none; b=d2qiXORHZbK0urQSU1V/3nRVLvEhB2fwDr1ZUF4gcxNUDudHa5qpij7DrzcfiCXKjnqa/eWbSVQfGnNJJ+3Os4FQ2uGJM9lchNSV6KrlORKzRmnXnc5jIbeZN82xM10CgdhyYEp7UYKKEiQ17wF3RUTImUsrJUtii7oG2Aek4EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784938857; c=relaxed/simple;
	bh=gRfnRivjw7jQp6iRrvf2/AOjaGq7gzPrLe70CwWPqmk=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=fM3noOpFrDec85QNIdjqo3E7OmGf5ljaH5MlVJHqkwLx0dHqZUY+OsEgq/evgP2vqIVCaZSETNe5AjK1apkUWeV0EGE3vsPT65hBFrHSJm3XhAnmy87oMNVmd07znyk+gtvVHhn8esopJI7GMR1uVlWyOkNKu2WDCoc9CxVerQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KTLZyj5V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KTLZyj5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD851F000E9;
	Sat, 25 Jul 2026 00:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784938856;
	bh=dcShqlp6nucbCONZtTVl61Us5mg+JuP68W3RHgZBSxw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=KTLZyj5VjmCyls3Bugm9ub3pFXR1cRf8db1Fw8rehLXIRX6G5RdcHRRezsNy/CAPf
	 so5eZECHQMzoPtjtlQKAdoq0bVJUDKrjhd2Iv1u3SVj7lyz7GaNHLGk16IBq1MRoN1
	 olLFmT1ewYRBxANEbFYIXBrEBdXY/RFmC/S5nNRtL911afJIW8MI29ylDE7JiTw6aX
	 8RtezcBF5Zy6zlc+1A6KZyNEmP4tK5BJMTvN4uSkdBWCPFwYoIof0zmGx6MsOaHBvU
	 Z865TOvQkUtGp/IvSs7X5ge5yD2CDL2pxMUPHPJ0y37hPGGqJ+NGsSp/JRtG14rop9
	 5TuB3xop3rDEg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93BC138111D8;
	Sat, 25 Jul 2026 00:20:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/13] netfilter: nf_conntrack_sip: widen NAT rewrite
 delta to s32 in sip_help_tcp()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178493882341.3363307.1970080828146409091.git-patchwork-notify@kernel.org>
Date: Sat, 25 Jul 2026 00:20:23 +0000
References: <20260723163910.274695-2-pablo@netfilter.org>
In-Reply-To: <20260723163910.274695-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 23 Jul 2026 18:38:58 +0200 you wrote:
> From: Xiang Mei <xmei5@asu.edu>
> 
> sip_help_tcp() stores the size change of each NAT-rewritten SIP message
> in s16 diff and accumulates it in s16 tdiff, but a single message can
> grow by more than S16_MAX while the packet stays under the 65535
> enlarge_skb() limit: nf_nat_sip() rewrites every matching URI, and a long
> Contact list expands the message by tens of kilobytes. diff then wraps,
> and "datalen = datalen + diff - msglen" yields a huge unsigned datalen,
> so the next iteration's ct_sip_get_header() reads past the linearized skb
> tail.
> 
> [...]

Here is the summary with links:
  - [net,01/13] netfilter: nf_conntrack_sip: widen NAT rewrite delta to s32 in sip_help_tcp()
    https://git.kernel.org/netdev/net/c/db3d0e0e5d4b
  - [net,02/13] selftests: netfilter: nft_flowtable.sh: fix offload counter verification for tunnel tests
    https://git.kernel.org/netdev/net/c/1d6123f87eeb
  - [net,03/13] netfilter: nf_conntrack_expect: add and use nf_ct_expect_related_pair()
    https://git.kernel.org/netdev/net/c/4aa63842fc92
  - [net,04/13] netfilter: ipset: do not update comments from kernel-side hash adds
    https://git.kernel.org/netdev/net/c/f30415929be8
  - [net,05/13] ipvs: do not propagate one-packet flag to synced conns
    https://git.kernel.org/netdev/net/c/a63d2dbaeb50
  - [net,06/13] ipvs: adjust double hashing when fwd method changes
    https://git.kernel.org/netdev/net/c/712d2993bea5
  - [net,07/13] netfilter: nf_tables: make nft_object rhltable per table
    https://git.kernel.org/netdev/net/c/f4f699790590
  - [net,08/13] netfilter: xt_hashlimit: validate hashtable supports XT_HASHLIMIT_RATE_MATCH
    https://git.kernel.org/netdev/net/c/305b63e14022
  - [net,09/13] ipvs: fix the checksum validations
    https://git.kernel.org/netdev/net/c/e876b75b9020
  - [net,10/13] ipvs: fix places with wrong packet offsets
    https://git.kernel.org/netdev/net/c/15cab31a3730
  - [net,11/13] ipvs: do not mangle ICMP replies for non-first fragments
    https://git.kernel.org/netdev/net/c/342e24a339b9
  - [net,12/13] ipvs: clear the nfct flag under lock
    https://git.kernel.org/netdev/net/c/da7d894c41d5
  - [net,13/13] netfilter: nft_payload: fix mask build for partial field offload
    https://git.kernel.org/netdev/net/c/39e88f28fb32

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


