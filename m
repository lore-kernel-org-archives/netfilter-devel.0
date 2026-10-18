Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5988E347C6;
	Sun, 18 Oct 2026 01:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792287784; cv=none; b=JczqTXFQRUdwQp3PdcafQn4Pu3kShvWcGOZep41Gpqlaw8y30wozjycBlQBwQpBSae3KG8UCTOXqX6OE9DboFvrlzxeQK/Me9kk/gsLiWUixNCZRpvNFlZ43GYmOts2PQIm+sIyRApNxRxyl1++8y0P13dphDaNCOIC9GhdLxTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792287784; c=relaxed/simple;
	bh=r3cHmYfpbWrpcdMvOfVvrr3UoW+YU14sgpM5YYsfIF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sQn4O/pwSRlzowj54lIznfNmrYVGyZtI2u1M7bykx+H1m97+rGPrfqdb3Yz9zrUWlUrvum1MoAyiAu3tL1zS8jFFp1dCHMOfG921yhaHOMg6+iU48lKv/PZOnX54/2OFi6nby/XmPIHcGwENWovXpRa+GH4sGywLcA8xPSKZWTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KegEKRrR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KegEKRrR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792287781;
	bh=nDxJhObvnS2NtSEYLBpWltRDYgX04w6sESavKhX6g9U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KegEKRrRVIVJxfCuRyCzQERcGtjstd4BY6tquhkdv9YBZnWmwbPwuxjmAuJX1uznn
	 W6vR6Qao3mwD2KPaduV5Ui1dWLECFgzrcwDMGU1ppplOf74+6MXhfRhVInnqLOs+Y7
	 0iqP6nmE9aW41Xbv9rCX/HZwUTTCav8pHGP2nJHy+u1QeCxQEqd9Oo3DjoGHNYJzop
	 ANBfPCo75c7JZ1zzB/IM1R6oncrTKc8Sw8byoEkqXvSQfJL1oO7yPgsNuQPm5d/BuB
	 2DWdVe/sS6I4VAsJp5CIC9pX9rZ/WixGTnxGAHXhnEgpJXkwijEoqzS2cwsvZz9SE5
	 m0hvlgGTZgSAA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 4FF556005B;
	Sun, 18 Oct 2026 03:43:01 +0200 (CEST)
Date: Sun, 18 Oct 2026 03:42:58 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	geldot@protonmail.com, shuah@kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH nf-next v2 0/4] netfilter: offload a TCP flow whose reply
 is never seen
Message-ID: <atQkIj262kQ0B0VZ@chamomile>
References: <20261004171628.3544978-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261004171628.3544978-1-julius@bairaktaris.de>

On Sun, Oct 04, 2026 at 07:16:24PM +0200, Julius Bairaktaris wrote:
> A router that sees only one direction of a TCP connection, because the
> reply takes another path, cannot offload it: conntrack marks the
> client's ACK after the SYN invalid, and the flowtable only takes assured
> TCP connections. The setup this comes from is two subnets on one L2
> segment, with the server answering over the shared segment.
> 
> The series adds no TCP state:
> - patch 1 hands that ACK to the existing loose pickup in tcp_new(),
>   gated by nf_conntrack_tcp_loose, as if the SYN had not been seen
> - patch 2 keeps the reply direction of such a flow on the classic path
>   until the connection is assured, as act_ct does for UDP
> - patch 3 offloads the connection in the original direction and caps
>   the timeout handed back to conntrack at UNACK, as
>   nf_conntrack_tcp_packet() does
> - patch 4 adds a selftest, which fails without patches 1 to 3
> 
> Pablo, on v1 you asked how TCP tracking copes without the reply
> direction, and guessed right that the goal is flowtable offload. The
> connection is tracked like a loose mid-stream pickup today: window
> checks are off in both directions, and a FIN or RST still takes the
> flow off the flowtable.

Yes, but posting it again does not get me anywhere.

This series are a no-go in this approach.

LLM is offering a quick-fix/workaround to make things work.

Please, given we are discussing one series of you quite recently...
let's handle one thing at a time. Once that gets merged, let's look at
the next.

> This series was written with the help of an AI coding assistant. I have
> reviewed and tested it.
> 
> Changes in v2:
> - patch 2: the XDP flowtable lookup does not return the held reply tuple
> - patch 3: cap the conntrack timeout at UNACK while no reply was seen
> - rebased onto nf-next
> 
> v1: https://lore.kernel.org/netfilter-devel/20260910090052.2034970-1-julius@bairaktaris.de/
> 
> Gary Dotzler (2):
>   netfilter: conntrack: pick up a TCP flow whose SYN was never answered
>   netfilter: nft_flow_offload: offload a TCP flow that has no reply
> 
> Julius Bairaktaris (2):
>   netfilter: flowtable: promote a flow offloaded in one direction only
>   selftests: netfilter: cover a TCP flow whose reply is never seen
> 
>  include/net/netfilter/nf_conntrack_l4proto.h  |  9 +++
>  net/netfilter/nf_conntrack_proto_tcp.c        | 16 ++++
>  net/netfilter/nf_flow_table_bpf.c             |  4 +
>  net/netfilter/nf_flow_table_core.c            |  5 ++
>  net/netfilter/nf_flow_table_ip.c              | 26 +++++++
>  net/netfilter/nft_flow_offload.c              |  6 +-
>  .../selftests/net/netfilter/nft_flowtable.sh  | 75 +++++++++++++++++++
>  7 files changed, 139 insertions(+), 2 deletions(-)
> 
> 
> base-commit: 87b80c2f6b05cad9f0ff9136709c62a0f59923e3
> -- 
> 2.53.0
> 
> 
