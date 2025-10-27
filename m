Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA08E4C9D
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Oct 2025 23:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761608891; cv=none; b=HgEu0bYruq10iE12wnKGijGh7R86tD7lnbnEQt1Urqra/2od330QxHzXv7u447wX26C3d9T0cf/o9xf73e4f0UUr0JJ2nQuY4K0oQusLYr4BQwut/QmliqaP7tPQm4COqFNMdVXZP6X41UqDg/1EBRnlRe29cj5dml6jPNBjcFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761608891; c=relaxed/simple;
	bh=TmMDgAsdS2huEZQH6QVh+UWBgvPjgo9nvjn55d6Bpwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MGSpfcM2cSE5lpy01Uv53VlwqYZmXnBK1AQTzPODb4QNlhpJQlEe7GXIOnsJ3C57POfUMxq1qD5MZgNO8v2W7Vdpwg3lgEqF3jVxWIsUCkWGoQvlZRHtGvh3x7o6WaSmni+QWUKb0srt+Po50KrllFRtWgPiK7MMu4TX6W2jlwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kvgsr8Fi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kvgsr8Fi"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9A1ED60262;
	Tue, 28 Oct 2025 00:48:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1761608885;
	bh=E+bLzwiBuzdcQJ/EWOISnoIpQqU5eqn42MA6VpahgPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kvgsr8FiIDENm6CXq5Eycw7lN4dMRjmmRMzg7GP87pA53wuU9w0vha47ayYvov10s
	 7arQZtS2u/A2rtE8i8uelmqN6NG99QurH2RMzHXLB3coo/Z7fRdUQ1xapYd8yYnPNe
	 7PATe25YM5sRjvcbWFjBqqJp5PNuzE15p7XcOCteAxY4Y4LMoFUWCnFK02KgX53rF4
	 40OoP5AIfvbCLyilZulI3RECOqSZYJ85iyZ0SS1A3IZpBD6KzVMIF0BKM4HGyASMT7
	 0m0shSYONCgxxYbIEHK/blPtKzzrFJQSNxHhXSXxEAmjJWSmFWWEd3SfdvGrdgJaWp
	 6cd3nire326MQ==
Date: Tue, 28 Oct 2025 00:48:02 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 2/5] netfilter: flowtable: consolidate xmit path
Message-ID: <aQAEssvnuJmLLaVb@calendula>
References: <20251010111825.6723-1-pablo@netfilter.org>
 <20251010111825.6723-3-pablo@netfilter.org>
 <aOuebEc_iHm6r3u0@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aOuebEc_iHm6r3u0@strlen.de>

On Sun, Oct 12, 2025 at 02:26:20PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Use dev_queue_xmit() for the XMIT_NEIGH case. Store the interface index
> > of the real device behind the vlan/pppoe device, this introduces  an
> > extra lookup for the real device in the xmit path because rt->dst.dev
> > provides the vlan/pppoe device.
> 
> Will this scale?  netdev_by_index only has a fixed table of 256 slots,
> so with 8k vlans or so this will have a 30-ish netdev list walk.
> 
> [ EDIT: I see now that nf_flow_queue_xmit() already does that.
>   So I guess its either not an issue or not yet and it can be
>   optimized later.  So disregard this ]

Yes, that will need a look closer or later.

> >  	case FLOW_OFFLOAD_XMIT_NEIGH:
> >  		rt = dst_rtable(tuplehash->tuple.dst_cache);
> > -		outdev = rt->dst.dev;
> > -		skb->dev = outdev;
> > -		nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
> > +		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.ifidx);
> 
> Why do this if we already have dst_cache?

This is to skip one level of indirection, ie. dst_cache points to the
vlan device, not the real device. The idea is that the flowtable gains
control on the xmit path so the flowtable pushes l2/l3 headers and
send the packets directly to the "real" netdevice.

> The above explanation (rt->dst.dev could be a tunnel device, whereas
> the latter fetches phyical / lowest device) from the commit message
> makes that clear; but I think a short comment would help.

Yes, I can add a comment on this.

Thanks.
