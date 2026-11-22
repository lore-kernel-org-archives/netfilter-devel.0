Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795307121;
	b=d1xtCMqb2nRObTx5d27fk0KPD96ShA72ZZdpw+n8sHQinW86sWwipgd387PkPUvRzFPS
	 d+cn3FKRycK68fLQKbrvxOwagKijfkeQYbxjURo8HlCs8kDmbW8bgrIY3owO6Z8LtmBOX
	 K6E+UuRfKQN+m5k4Q9HOBuqe/CQzsD0l95cehdbP0KdT3vAG9uHGqJOTTtYZ6UXqIXSl6
	 snXOo6yrR7s/NiKqtbP61QFXcoKgPBBlRJpeDEBvJoa1Ac3xiTjcZFQ5NvSxWbGAP19bi
	 12KoubsoEX5jzPSis6kp3P56S9Z8MtF5/ZXlOLKQCv3p6bJnGlPgrJRlBG3qj8nvT+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795307121;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=SiX4JcxZnW41+EeuKOdxLyKKqqijqbX88nwK0mLsnfw=;
	b=GHKu/x+6WZgFwrJD2IWrEc/qwG4cGv8zYDfJNoNnA3bjbQ+U2rSyjF0obhilHWeZBWud
	 cmusaBP24Sq9T+Qziz8mYd8LHLot4gcaqHj6RltyxbV5M4LG5mla7BHEs2Jyv/7oLUTKi
	 ac93eNYks2/MSoNZgvUSzwk9RdDiTPh9F2Z2Ldg+708b5hGqdAelo7MPpWXjxjx0FklRU
	 aT1IrQs3DPXGRULhTp+KQvo7SGRMTfNZinerjv/hru9OAtmII1TWUVW4arWVmvR/BKpJd
	 KouPma54PTKgY4FJdEA9NhFAbe+uGNucJ5ZVKzN6RL9n7DnLNJIupK+APPNVwWjsLgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=KNzzAWBb;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 246E4606A320
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2026 00:25:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 246E4606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=KNzzAWBb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795307118;
	bh=SiX4JcxZnW41+EeuKOdxLyKKqqijqbX88nwK0mLsnfw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KNzzAWBbPJ4V3HvPi3QjR6TBO247Plk0s8wdMYLN0scHkFyXyb4ItHbLLXBq5zosP
	 WhkBHwrqTN3dEPn71Ij4KxxT+8gXlS6gfsQiZ6PycO7M3oXlCp+YTgLYzsqiiS9cIO
	 D3e1567yfqm9T7Fvmx22bm1CCajPlVKHQ0RENi7BiiSciN5hNU+2uwc9aEEEj/mV9A
	 t578ovEWia0e28lypchd+JpOleHXcHzyJnE8UE6mIBpI8iiATZNTOy015kFJ/OhEBu
	 5cysaslapPPo/GQyo9Xj+stQAO6EnIl+xsMHPnvsKlZomoX1DvCFPuDdOv1jlKvhe3
	 mqWZI0Q6EScVg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A88606005C;
	Sun, 22 Nov 2026 01:25:18 +0100 (CET)
Date: Sun, 22 Nov 2026 01:25:16 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v6 2/3] netfilter: flowtable: cache destination hw
 address for XMIT_NEIGH type
Message-ID: <awI2bKH0J7f8xMZZ@chamomile>
References: <20261120225227.3565643-1-pablo@netfilter.org>
 <20261120225227.3565643-2-pablo@netfilter.org>
 <20261121235548.2567423-1-julius@bairaktaris.de>
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
In-Reply-To: <20261121235548.2567423-1-julius@bairaktaris.de>

On Sun, Nov 22, 2026 at 12:55:48AM +0100, Julius Bairaktaris wrote:
> On Fri, Nov 20, 2026 at 11:52:26PM +0100, Pablo Neira Ayuso wrote:
> > @@ -383,6 +400,7 @@ static int ipip_fill_forward_path(struct net_device_path_ctx *ctx,
> >  	path->tun.dst = &rt->dst;
> >  	path->dev = ctx->dev;
> >  
> > +	memcpy(ctx->daddr, ha, ETH_ALEN);
> >  	ctx->dev = rt->dst.dev;
> 
> With this, an ipip or ip6tnl tunnel whose underlay device is a bridge
> gets offloaded: br_fill_forward_path() finds the outer next hop's MAC
> in the fdb and nft_dev_path_info() makes the tuple
> FLOW_OFFLOAD_XMIT_DIRECT. On nf-next without the series such a flow is
> not offloaded.
> 
> > +static inline bool nf_flow_dst_check_gc(struct flow_offload *flow, int dir)
> > +{
> [...]
> > +	if (tuple->xmit_type != FLOW_OFFLOAD_XMIT_NEIGH)
> > +		return true;
> 
> For that direct tuple the gc returns here and never compares out.h_dest
> with the neighbour entry. When the next hop behind the bridge changes its
> MAC and the router's neighbour entry is replaced, the flow keeps sending
> to the old MAC: IPIP and IP6IP6 over a bridge stall, 3 of 3 runs each
> (QEMU, nf-next 994089a3fa38 with this series). IPIP over a plain port is
> neigh xmit, is torn down and offloaded again, 3 of 3. A bridged direct
> flow without a tunnel stalls the same way, here (3 of 3) and on nf-next
> without the series (1 run).

So you're suggesting nf_flow_dst_check_gc() should run for
FLOW_OFFLOAD_XMIT_DIRECT too?
