Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795309038;
	b=y2lNXZKpizDXBbgopV2DDKEyXuFVbjjTQhVNsjzqXMr2MR59KXf/RZDDzkFYB24Qn7Gk
	 UdJMFGtMdqpNBkRyooBhplRRlX8dQ1t/+QE9smOrJhhgtYJXPddHNXDODQ4NpwY54//3w
	 ihAWvtkhc29nPHUcvgiYpwVPQkEbKvZBMvnqcrZyLlYZy+oR4oKYmyXT1f4uJEe9y/gZ3
	 jWYXRBUB81w8BCjJiPWojSfYauRXQ9qmkxh78nIZm515BIN1dQnANkLZvnVQ43LQfMYMP
	 q+PKjpyWIqOgwCdDCHUwD+ZFtXuGJGL/j/muOULxz/MC4IoFmyuDXSKHlTk1zcJLnsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795309038;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=c0Lt4d7cX8iglgzgnp0dJhFaBdsc+aGhY+IHWyDYi5E=;
	b=DWYC9cpVwB73HlLbntubifPRbsEPVvxueZcAmb0Cog+jT7NyZPOlPxKPqPq680rUxINY
	 y6fQR2N75oZ3JSgcKWb47urJfs3vqcQaIZcUncXtVKe7W1QloOHSztoWLmF5dqPqXDquA
	 LqwnPyNGcua0aTTQtGlqF549raMBCr+kmDW+LbAdLx2ggXiMX6gO6Um//MrjvI+vV7llD
	 C5xbb9vm0qRe3k+ti2NJVhVf658TaceaLiSepn5udbp7a4m64eijj6RjpYFHMPlpYYJ/z
	 Uxv2uAdv0x9AXB/XvQrrQ9YNjqv+eMgNz1k2bWPHRhhoJy2kpLZL1haXs13bAYCWiRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=BJz8q5LY;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id F3A5D606A33A
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2026 00:57:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3A5D606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=BJz8q5LY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795309036;
	bh=c0Lt4d7cX8iglgzgnp0dJhFaBdsc+aGhY+IHWyDYi5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BJz8q5LYSBM+dKYMERGXASp3VLiTG5SRaS2XEVjkcIr88DlKXTk+i3ELvsR9B6CFR
	 EsIF2Yg6a8LIFu4ulHL5b6Tm0U9d8sj1Rw042zdoz3Hl4iLZMB4UztG7os0UU3Vom8
	 yXEYfBZO4NNDOi3H9ndnT5Qwf29juhYlg16gIiF76JmyHRMJKe/gGnFFZARG7zb+Zw
	 p/cqEJ5zokuxYknQorlPRPWm/6QVGqedD1ApcebTyGJxQYac0R+wbeVmAL02xjesfp
	 ADuNawIQeMDqKfDiyV8eZcK/pfgwXX86XPF4pt3W7HZy7xRxi7iReY9uN0YucW+10j
	 moGYT9Bet5lqQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 287DB60058;
	Sun, 22 Nov 2026 01:57:16 +0100 (CET)
Date: Sun, 22 Nov 2026 01:57:13 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v6 2/3] netfilter: flowtable: cache destination hw
 address for XMIT_NEIGH type
Message-ID: <awI96fyKRgs3S0PB@chamomile>
References: <20261120225227.3565643-1-pablo@netfilter.org>
 <20261120225227.3565643-2-pablo@netfilter.org>
 <20261121235548.2567423-1-julius@bairaktaris.de>
 <awI2bKH0J7f8xMZZ@chamomile>
 <awI4wyG6RrRE_VV8@chamomile>
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
In-Reply-To: <awI4wyG6RrRE_VV8@chamomile>

On Sun, Nov 22, 2026 at 01:35:18AM +0100, Pablo Neira Ayuso wrote:
> On Sun, Nov 22, 2026 at 01:25:19AM +0100, Pablo Neira Ayuso wrote:
> > On Sun, Nov 22, 2026 at 12:55:48AM +0100, Julius Bairaktaris wrote:
> > > On Fri, Nov 20, 2026 at 11:52:26PM +0100, Pablo Neira Ayuso wrote:
> > > > @@ -383,6 +400,7 @@ static int ipip_fill_forward_path(struct net_device_path_ctx *ctx,
> > > >  	path->tun.dst = &rt->dst;
> > > >  	path->dev = ctx->dev;
> > > >  
> > > > +	memcpy(ctx->daddr, ha, ETH_ALEN);
> > > >  	ctx->dev = rt->dst.dev;
> > > 
> > > With this, an ipip or ip6tnl tunnel whose underlay device is a bridge
> > > gets offloaded: br_fill_forward_path() finds the outer next hop's MAC
> > > in the fdb and nft_dev_path_info() makes the tuple
> > > FLOW_OFFLOAD_XMIT_DIRECT. On nf-next without the series such a flow is
> > > not offloaded.
> > > 
> > > > +static inline bool nf_flow_dst_check_gc(struct flow_offload *flow, int dir)
> > > > +{
> > > [...]
> > > > +	if (tuple->xmit_type != FLOW_OFFLOAD_XMIT_NEIGH)
> > > > +		return true;
> > > 
> > > For that direct tuple the gc returns here and never compares out.h_dest
> > > with the neighbour entry. When the next hop behind the bridge changes its
> > > MAC and the router's neighbour entry is replaced, the flow keeps sending
> > > to the old MAC: IPIP and IP6IP6 over a bridge stall, 3 of 3 runs each
> > > (QEMU, nf-next 994089a3fa38 with this series). IPIP over a plain port is
> > > neigh xmit, is torn down and offloaded again, 3 of 3. A bridged direct
> > > flow without a tunnel stalls the same way, here (3 of 3) and on nf-next
> > > without the series (1 run).
> > 
> > So you're suggesting nf_flow_dst_check_gc() should run for
> > FLOW_OFFLOAD_XMIT_DIRECT too?
> 
> This is what this patch does:
> 
>   [PATCH nf-next] netfilter: flowtable: teardown flow reaching bridge port on fdb updates
> 
> Until that gets merged, stall is expected.

Ah, I suspect you refer to the XMIT_DIRECT case when hw offload is
enabled, which indeed have dst/neigh entries.
