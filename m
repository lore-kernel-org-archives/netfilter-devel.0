Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1F831618B;
	Fri, 11 Sep 2026 11:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789126924; cv=none; b=FQzb4t48ohZRGTMmBUp217zPEbD7YNV2BSsY6snYx9Dt5DJcNQqDYOjYLJr/ERL3dHywOcC9VHDcLrsm9J8Xfmdx56cRO6cjvwUzzmS/X6UvygtHWCm1FiZkZDeWhKxgubhZ3kDo3+YtTnaywrbc96Ta47mBHXGG70TRF3J1UzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789126924; c=relaxed/simple;
	bh=AF+8i7K9jVs/jFBF3+QU16ss0LDaOXckx17Deij2NJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gl0PDqY69wmw0dcv+fVbzlqMnRH5xCDLX5ZuCbty+LVhikQslY1p8F8jphAJstNV0AXXuGfE7/+VKXbbLnX8zrPh5BJFrUTpIEg9sr6H0nYfMvDRP71Jl1gkVFlvyWO21lJX2S7Kc/RvRzKeH17BdMSkiMb7U0lTWJgy8KUzmUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rPs1jiCW; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rPs1jiCW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789126919;
	bh=aPDntZ8uc6O32x8vVeROczZEf9uMpg/Vulw+Sgv4Hxs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rPs1jiCWCiXnRR6+L3T/1uv/8QlRMzzhlt3ppZuI/9hayjFinHmBrIntKdQBozwuM
	 fFG6pvftuBQpKOBCgxc99fKjvKOWZ9S7RStAnVC8Kmst6nEvAMqv3YGJXhyD6UZru0
	 Z/aGSaJVGPHqwNVYEdBBMbzoLSvBPAsLqM5E+oa+2m4T5SN6sI1jo/8ihWhXh9DoqJ
	 urK1X/a+6nsEDV9hFWDG6qigfJ7Ia57Q1rLIPtI2mExk8DW2Zflk6+CHdjGYTMR9eO
	 U9sZCadalU9SGcGMheS7AdKEmaUY4Mi79hpGksLdqKuCS64kjRIKZvyyttFZgD8RcB
	 DRzLLsGLayqxg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 366FB6024A;
	Fri, 11 Sep 2026 13:41:59 +0200 (CEST)
Date: Fri, 11 Sep 2026 13:41:56 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	geldot@protonmail.com
Subject: Re: [PATCH nf-next 0/4] netfilter: offload a TCP flow whose reply is
 never seen
Message-ID: <aqPpBJvfTwKrxSGG@chamomile>
References: <20260910090052.2034970-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260910090052.2034970-1-julius@bairaktaris.de>

On Thu, Sep 10, 2026 at 11:00:48AM +0200, Julius Bairaktaris wrote:
> A host that forwards one direction of a TCP connection only sees the
> client's SYN and then an ACK continuing from it; the answer took another
> path. That ACK has no entry in the transition table, so it and every
> packet after it are invalid, the conntrack entry stays in SYN_SENT
> [UNREPLIED] with a single packet, and the connection reaches neither the
> stateful part of a ruleset nor a flowtable.

conntrack needs to see packets in both directions, are you assuming a
packet-based load balancer in front of it?

> Patch 1 takes such a connection over as the mid-stream pickup it is.
> Patch 2 withholds the reply direction of a flow offloaded in one
> direction until conntrack has seen a reply, and offloads it once
> conntrack has. Patch 3 offers a connection whose reply was never seen to
> the flowtable in the original direction. Patch 4 adds a selftest arm for
> the path; without patches 1 to 3 it fails, with the router forwarding the
> SYN of the connection and nothing else.
> 
> Verified on an IPQ8074 router with hardware flow offload, iperf3 -P2
> between two hosts on different subnets of one bridge with the reply
> direction bypassing the router:
> 
>                                   CPU port    switch port   throughput
>   asymmetric, without the series   81k pps       81k pps    944-947 Mbit/s
>   asymmetric, with the series      2-11 pps      81k pps    948-949 Mbit/s
>   symmetric, with the series      11-38 pps      81k pps    926-948 Mbit/s
> 
> I wrote this series with the help of an AI coding assistant, as the
> Assisted-by tags record. I have reviewed and tested it myself.
> 
> Gary Dotzler (2):
>   netfilter: conntrack: pick up a TCP flow whose SYN was never answered
>   netfilter: nft_flow_offload: offload a TCP flow that has no reply
> 
> Julius Bairaktaris (2):
>   netfilter: flowtable: promote a flow offloaded in one direction only
>   selftests: netfilter: cover a TCP flow whose reply is never seen
> 
>  include/net/netfilter/nf_conntrack_l4proto.h  |  7 ++
>  net/netfilter/nf_conntrack_proto_tcp.c        | 19 +++++
>  net/netfilter/nf_flow_table_ip.c              | 26 +++++++
>  net/netfilter/nft_flow_offload.c              |  6 +-
>  .../selftests/net/netfilter/nft_flowtable.sh  | 73 +++++++++++++++++++
>  5 files changed, 129 insertions(+), 2 deletions(-)
> 
> -- 
> 2.53.0
> 
> 
