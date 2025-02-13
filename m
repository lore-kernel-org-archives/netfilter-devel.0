Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A161E2066C7;
	Thu, 13 Feb 2025 04:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739419811; cv=none; b=Ga+Z7SlTBLKMlxHxpRqX0HuLSFLTQYZfG7KqcbaAJDZjzjTfTqAyRC9AuAPTs5TR2pMzTxAjfu9lw1Q7qGTaaTQiTtjVhZ6lsww1c0Jh+xA7unSRdxBqeA0uu9SKU4kR/jrioPT0WVvFbQvBsaTUloU13fNlaQbHpqGQUNevdlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739419811; c=relaxed/simple;
	bh=vBzPi+le8yHNaQQfyJswqWZw30/rpF7MDxZ2rLyouKg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=W2KzKIejq6dpINyqiwryRMQSXx3Y4tDsAgS5cE0EkmBTuIUV30DvQUrijjvHjjaNPpmA+WViLn4APaWDcVl2997J72doldvE+4HOIegvWh+HkpvIq4za51I3cXDtn1tu5A5mlaoKYd/18Ntnm6FhtHIu9MY+ep6pTqgzP6W84nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V2Ia6qfF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V2Ia6qfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7FEC4CEE6;
	Thu, 13 Feb 2025 04:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739419811;
	bh=vBzPi+le8yHNaQQfyJswqWZw30/rpF7MDxZ2rLyouKg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=V2Ia6qfFgjt36bW7eKuZFf7GO3Eu4tr7mMKngVAf5p74yKD/D+LWTkFTtg3CN70IG
	 q9Pr7QlRJdxb2fnPCbON9f619V4MSPHNd/6aHFCB3xgF7qoVOFAEYzs/h67PR5ogwE
	 f+h54L8zn9UAwjsbWoZksGXTOdXhUW3R9zIZIx9Ht7qHrr+4WUUpv06zAuC3Ub9KuU
	 0ywSSDjYE1JoEBqHjXbWIs0uHXtj7Nhqa2RbR+GiBWusM3KbNfrXRq72cettzRTNFb
	 X/aJqC3QtyWGfnk86iDpvTO6wGwEeuH6Sn1+/4uGWUYPUHKfyg0jf8zqdz/R1rBiPR
	 Qh+11lyGLJPAw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70E89380CEDC;
	Thu, 13 Feb 2025 04:10:41 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] netlink: specs: add conntrack dump and stats dump
 support
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173941983999.756055.3251715310058890855.git-patchwork-notify@kernel.org>
Date: Thu, 13 Feb 2025 04:10:39 +0000
References: <20250210152159.41077-1-fw@strlen.de>
In-Reply-To: <20250210152159.41077-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 donald.hunter@gmail.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 10 Feb 2025 16:21:52 +0100 you wrote:
> This adds support to dump the connection tracking table
> ("conntrack -L") and the conntrack statistics, ("conntrack -S").
> 
> Example conntrack dump:
> tools/net/ynl/pyynl/cli.py --spec Documentation/netlink/specs/conntrack.yaml --dump get
> [{'id': 59489769,
>   'mark': 0,
>   'nfgen-family': 2,
>   'protoinfo': {'protoinfo-tcp': {'tcp-flags-original': {'flags': {'maxack',
>                                                                    'sack-perm',
>                                                                    'window-scale'},
>                                                          'mask': set()},
>                                   'tcp-flags-reply': {'flags': {'maxack',
>                                                                 'sack-perm',
>                                                                 'window-scale'},
>                                                       'mask': set()},
>                                   'tcp-state': 'established',
>                                   'tcp-wscale-original': 7,
>                                   'tcp-wscale-reply': 8}},
>   'res-id': 0,
>   'secctx': {'secctx-name': 'system_u:object_r:unlabeled_t:s0'},
>   'status': {'assured',
>              'confirmed',
>              'dst-nat-done',
>              'seen-reply',
>              'src-nat-done'},
>   'timeout': 431949,
>   'tuple-orig': {'tuple-ip': {'ip-v4-dst': '34.107.243.93',
>                               'ip-v4-src': '192.168.0.114'},
>                  'tuple-proto': {'proto-dst-port': 443,
>                                  'proto-num': 6,
>                                  'proto-src-port': 37104}},
>   'tuple-reply': {'tuple-ip': {'ip-v4-dst': '192.168.0.114',
>                                'ip-v4-src': '34.107.243.93'},
>                   'tuple-proto': {'proto-dst-port': 37104,
>                                   'proto-num': 6,
>                                   'proto-src-port': 443}},
>   'use': 1,
>   'version': 0},
>  {'id': 3402229480,
> 
> [...]

Here is the summary with links:
  - [v2,net-next] netlink: specs: add conntrack dump and stats dump support
    https://git.kernel.org/netdev/net-next/c/23fc9311a526

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


