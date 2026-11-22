Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795307720;
	b=WH4deKtIh+n3ZrVY5LOWFl0AQh7oh125oimYidd3gplkyYYxbuwosUcXGT6kOjDJHSCD
	 pCvtVsTBUbqLOmY1IFSzls2m/CalgmHaLL3lX/Gkl/yW7Bx5NDc5auu730A5pHBMBQwsU
	 eaLfnSOL9CwTmIKHrSUXe0uZkCzbIeFPvLGuwsHaLRWwDVerJhK6B/r42lth3XaYKMChf
	 Z8nFPlB2ffcE2nB7+HRutRS14vvTfNWfI0wrEVHl1qBRD7SCDWsz/gMQuYr78o1XBeyDp
	 RxFcs0hR/4b1mSAIOFbe1XW71AzdC3JIgMq/610FA3jbZY1qhpF7BJdkOR4jnfQuu+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795307720;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=SKkZhy18ugJq545Tbxhdn2/9vHb/YrSUOoahGsNd6Q8=;
	b=HkqLrAbEsWe6XQFqMDuEm1WvId7F+jvpJtAO0vZ1foELFSXZQnzYcnbshzQcZovSpOrI
	 uWY2luLH1nD59uilpmwqVaELySAAXD24C2uUTvdG9LPld0arUsk4Kdb2PLZOcdq2hCvNQ
	 340R0AjN8M7VLHX+1OxujHtwSGfLck+kNSgSfMemxHEuaru2vkyV/cC0IzJfln9QJprpd
	 SOreM6e0+16edoo2qKtKMDKNoAy9XoHJsNI+GNV2BQPTWrMZNiJcvIY7yceWswVShJu1M
	 +kPM62guj/xGfmbXHJKnOQCPk73P2QOoJBB2Yyl/+VbcB3u2Mpe7eiasOhnQ6uP0Wfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="voG2/i6F";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B4254606A320
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2026 00:35:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4254606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=voG2/i6F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795307717;
	bh=SKkZhy18ugJq545Tbxhdn2/9vHb/YrSUOoahGsNd6Q8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=voG2/i6F6bwdOtK9YU+QpZYuPUnzLHr8D7Prf3Atj3g+KsIWxOiIwl5kdGttPLYKb
	 a0c+B3vwKm60dlD71MTrx9HjDvBTUVvrqcD+Y+j/qaD92NTJbydmqm4YQuDeLlE/e7
	 g8Ha+1iJHaJGz2VVv4TNUasI3hFO9kbewnzAdjc+DSMj+jLzMFQYJeC9KqW/fnS7Kc
	 brlkVioqB/tZHwWbnHuVn4XT3z4xKpavqp7T5lZD9GdbW1bIwHPHHJ03bJAVqhtH2T
	 D5b1uRq46LirXzppc8MaS5njKT3trRqAeJqpgFToV08EOoG7mkj7dh9zK02+jPZyZ/
	 2nPTKC2uu6rDg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id BC73F6005B;
	Sun, 22 Nov 2026 01:35:17 +0100 (CET)
Date: Sun, 22 Nov 2026 01:35:15 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v6 2/3] netfilter: flowtable: cache destination hw
 address for XMIT_NEIGH type
Message-ID: <awI4wyG6RrRE_VV8@chamomile>
References: <20261120225227.3565643-1-pablo@netfilter.org>
 <20261120225227.3565643-2-pablo@netfilter.org>
 <20261121235548.2567423-1-julius@bairaktaris.de>
 <awI2bKH0J7f8xMZZ@chamomile>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <awI2bKH0J7f8xMZZ@chamomile>

On Sun, Nov 22, 2026 at 01:25:19AM +0100, Pablo Neira Ayuso wrote:
> On Sun, Nov 22, 2026 at 12:55:48AM +0100, Julius Bairaktaris wrote:
> > On Fri, Nov 20, 2026 at 11:52:26PM +0100, Pablo Neira Ayuso wrote:
> > > @@ -383,6 +400,7 @@ static int ipip_fill_forward_path(struct net_device_path_ctx *ctx,
> > >  	path->tun.dst = &rt->dst;
> > >  	path->dev = ctx->dev;
> > >  
> > > +	memcpy(ctx->daddr, ha, ETH_ALEN);
> > >  	ctx->dev = rt->dst.dev;
> > 
> > With this, an ipip or ip6tnl tunnel whose underlay device is a bridge
> > gets offloaded: br_fill_forward_path() finds the outer next hop's MAC
> > in the fdb and nft_dev_path_info() makes the tuple
> > FLOW_OFFLOAD_XMIT_DIRECT. On nf-next without the series such a flow is
> > not offloaded.
> > 
> > > +static inline bool nf_flow_dst_check_gc(struct flow_offload *flow, int dir)
> > > +{
> > [...]
> > > +	if (tuple->xmit_type != FLOW_OFFLOAD_XMIT_NEIGH)
> > > +		return true;
> > 
> > For that direct tuple the gc returns here and never compares out.h_dest
> > with the neighbour entry. When the next hop behind the bridge changes its
> > MAC and the router's neighbour entry is replaced, the flow keeps sending
> > to the old MAC: IPIP and IP6IP6 over a bridge stall, 3 of 3 runs each
> > (QEMU, nf-next 994089a3fa38 with this series). IPIP over a plain port is
> > neigh xmit, is torn down and offloaded again, 3 of 3. A bridged direct
> > flow without a tunnel stalls the same way, here (3 of 3) and on nf-next
> > without the series (1 run).
> 
> So you're suggesting nf_flow_dst_check_gc() should run for
> FLOW_OFFLOAD_XMIT_DIRECT too?

This is what this patch does:

  [PATCH nf-next] netfilter: flowtable: teardown flow reaching bridge port on fdb updates

Until that gets merged, stall is expected.
