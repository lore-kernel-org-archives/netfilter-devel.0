Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0268933DED1;
	Fri, 11 Sep 2026 14:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789135798; cv=none; b=IkNTbtrV6+ULd6OLxsOjtV4tLrivg26hMc3RRE4mJ6WT9WLGQtcx9aqaT5zFg0sj1Cyikrqe2P61bAGqkF8oM9kRryc9ppQW/zZlr+nEfwD5+TBklKjBFBNGQjcmTZflcb6zXjXyPnhror4bx5xrbxMI0gA7WuTJbLXv6GgCM2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789135798; c=relaxed/simple;
	bh=3sYlRJsAKYABz8KwzGijN864p5i3Sx5Jcbfu8Ihyh2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q1YSR8ZyRDT5pu9f7ZOpy2kKKNqL+6+qYsHADDU9jgQF6IeFDMPVYMrQr/oL/j1aCYw4mRJkA0/xyVh2nzDbJFDqe5wlC+IA+I/KvXmGo7wcnC+KiOLr26whhIw41w4dAmP2zgm3BivTSaW5KuRoyMN91R15mI/mgc1zWKObH40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lGGlQpJk; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lGGlQpJk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789135790;
	bh=xjzAWSvOKNYO7F0/haarIpqo4xVeO010FNylFglyXMo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lGGlQpJkM45KNVEGKS/o2TwJeU1fORCveV4LOpf8EAsJCqQo8CVCRK8jRcKDrYN/Z
	 iMZEPrpEIWT3HFa8MaQcsMlqj+dkViuZgeUh2VW7R4OexlymZhw4roVGv2AtwkKqYS
	 Sf1cc0jPmxJS5XlKODpQqw8R5poCyccEzYYB9M9O/gGJ4450A2Kvhii8QqEWtOyAgy
	 UTm1q9ITVZGZVi2RQWctrMSut8nfOEBZM8BARnCk89qHudofg6Ldz1WD6qtLcxp63v
	 xGlK4bYbi0aR7OkCMrogBRtQbW7j1vKRaLOJXEgSJc7tpI6o3GXeqO+U5a4RY+mOoL
	 vdKS85B/M/ZRw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 79C4E603D3;
	Fri, 11 Sep 2026 16:09:50 +0200 (CEST)
Date: Fri, 11 Sep 2026 16:09:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	geldot@protonmail.com
Subject: Re: [PATCH nf-next 0/4] netfilter: offload a TCP flow whose reply is
 never seen
Message-ID: <aqQLqwJVRROZ-cvH@chamomile>
References: <20260910090052.2034970-1-julius@bairaktaris.de>
 <aqPpBJvfTwKrxSGG@chamomile>
 <CAC1t37KDNB6+v7Xq51AGrPtYZ4U95kUEQ6HDJSKt5YYE6+0zdA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAC1t37KDNB6+v7Xq51AGrPtYZ4U95kUEQ6HDJSKt5YYE6+0zdA@mail.gmail.com>

Hi Julius,

On Fri, Sep 11, 2026 at 12:10:04PM +0000, Julius Bairaktaris wrote:
> Hi Pablo,
> 
> thanks for taking your time to review.
> 
> > conntrack needs to see packets in both directions, are you assuming a
> > packet-based load balancer in front of it?
> 
> No, an asymmetric route is in front of it, with two subnets sharing one
> L2 segment and the server answering over that link, so the router only
> ever sees one direction.

I see this requirement to support asymmetric path keeps coming, but
how hard is really to maintain this TCP state machine to deal with all
possible scenarios? ie. invalid transitions, retransmissions, etc.
this all without having access to full TCP connection.  Is it that you
need NAT and the stateless NAT in nftables does not fulfill your
requirements?

> Conntrack already picks such a connection up when it misses the
> handshake entirely, and patch 1 routes the SYN-seen case into that same
> path, under the same nf_conntrack_tcp_loose gate.
> 
>   net/netfilter/nf_conntrack_proto_tcp.c, tcp_new():
> 
>     } else if (tn->tcp_loose == 0) {
>         /* Don't try to pick up connections. */
>         return false;
>     } else {
>         ...
>         ct->proto.tcp.seen[0].flags =
>         ct->proto.tcp.seen[1].flags = IP_CT_TCP_FLAG_SACK_PERM |
>                                       IP_CT_TCP_FLAG_BE_LIBERAL;
> 
> Julius
> 
> 
> 
> Am Fr., 11. Sept. 2026 um 11:42 Uhr schrieb Pablo Neira Ayuso
> <pablo@netfilter.org>:
> 
> >
> > On Thu, Sep 10, 2026 at 11:00:48AM +0200, Julius Bairaktaris wrote:
> > > A host that forwards one direction of a TCP connection only sees the
> > > client's SYN and then an ACK continuing from it; the answer took another
> > > path. That ACK has no entry in the transition table, so it and every
> > > packet after it are invalid, the conntrack entry stays in SYN_SENT
> > > [UNREPLIED] with a single packet, and the connection reaches neither the
> > > stateful part of a ruleset nor a flowtable.
> >
> > conntrack needs to see packets in both directions, are you assuming a
> > packet-based load balancer in front of it?
> >
> > > Patch 1 takes such a connection over as the mid-stream pickup it is.
> > > Patch 2 withholds the reply direction of a flow offloaded in one
> > > direction until conntrack has seen a reply, and offloads it once
> > > conntrack has. Patch 3 offers a connection whose reply was never seen to
> > > the flowtable in the original direction. Patch 4 adds a selftest arm for
> > > the path; without patches 1 to 3 it fails, with the router forwarding the
> > > SYN of the connection and nothing else.
> > >
> > > Verified on an IPQ8074 router with hardware flow offload, iperf3 -P2
> > > between two hosts on different subnets of one bridge with the reply
> > > direction bypassing the router:
> > >
> > >                                   CPU port    switch port   throughput
> > >   asymmetric, without the series   81k pps       81k pps    944-947 Mbit/s
> > >   asymmetric, with the series      2-11 pps      81k pps    948-949 Mbit/s
> > >   symmetric, with the series      11-38 pps      81k pps    926-948 Mbit/s
> > >
> > > I wrote this series with the help of an AI coding assistant, as the
> > > Assisted-by tags record. I have reviewed and tested it myself.
> > >
> > > Gary Dotzler (2):
> > >   netfilter: conntrack: pick up a TCP flow whose SYN was never answered
> > >   netfilter: nft_flow_offload: offload a TCP flow that has no reply
> > >
> > > Julius Bairaktaris (2):
> > >   netfilter: flowtable: promote a flow offloaded in one direction only
> > >   selftests: netfilter: cover a TCP flow whose reply is never seen
> > >
> > >  include/net/netfilter/nf_conntrack_l4proto.h  |  7 ++
> > >  net/netfilter/nf_conntrack_proto_tcp.c        | 19 +++++
> > >  net/netfilter/nf_flow_table_ip.c              | 26 +++++++
> > >  net/netfilter/nft_flow_offload.c              |  6 +-
> > >  .../selftests/net/netfilter/nft_flowtable.sh  | 73 +++++++++++++++++++
> > >  5 files changed, 129 insertions(+), 2 deletions(-)
> > >
> > > --
> > > 2.53.0
> > >
> > >
