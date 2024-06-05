Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A779E13B2B9;
	Wed,  5 Jun 2024 19:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717614521; cv=none; b=tmi5XUjNoo/3TpHKeuEGzOxKAzm6mDvy8kiMt1qeoXTjgy4pkthVdvJDecstEMzgUXgNBBYaBG6rCCKU9oxcQIp20YMCy3SJ4m/FTCpW9tsUIQOgjri6aHEeGl3FRV+Vnk30KgQd23ZvwAts+/Zv7zbScSc8Hfd1VRXuqXfxUJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717614521; c=relaxed/simple;
	bh=7EnfzMOiEYBQ7hcFoX27M8Thq/+WVF/h4UrPULuDK7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AqSJiSKR+hLoog/KuVCe7Ug3I4qaQ/ABDgV46xpvViGAe9zd9QuzkEMrTECinzMM8mHJiumZmmuh4oomHtAX5MRF5WXiz9NVM34+WycyRS54Yt/tdEIpb+Wdp9ujsZaMuSnmQq3SVYIhs+g5gbLn+OHtg/h2kBIIXaebnBkT6cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sEvzt-00050l-P8; Wed, 05 Jun 2024 21:08:33 +0200
Date: Wed, 5 Jun 2024 21:08:33 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Christoph Paasch <cpaasch@apple.com>, Florian Westphal <fw@strlen.de>,
	Netfilter <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
	daniel@iogearbox.net, willemb@google.com
Subject: Re: [PATCH nf] netfilter: nf_reject: init skb->dev for reset packet
Message-ID: <20240605190833.GB7176@breakpoint.cc>
References: <20240604120311.27300-1-fw@strlen.de>
 <FF8A506F-6F0F-440E-9F52-B27D05731B77@apple.com>
 <20240605181450.GA7176@breakpoint.cc>
 <ZmCwlbF8BvLGNgRM@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmCwlbF8BvLGNgRM@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:

[ CC Willem ]

> On Wed, Jun 05, 2024 at 08:14:50PM +0200, Florian Westphal wrote:
> > Christoph Paasch <cpaasch@apple.com> wrote:
> > > > Reported-by: Christoph Paasch <cpaasch@apple.com>
> > > > Suggested-by: Paolo Abeni <pabeni@redhat.com>
> > > > Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/494
> > > > Signed-off-by: Florian Westphal <fw@strlen.de>
> > >
> > > I just gave this one a shot in my syzkaller instances and am still hitting the issue.
> >
> > No, different bug, this patch is correct.
> >
> > I refuse to touch the flow dissector.
> 
> I see callers of ip_local_out() in the tree which do not set skb->dev.
> 
> I don't understand this:
> 
> bool __skb_flow_dissect(const struct net *net,
>                         const struct sk_buff *skb,
>                         struct flow_dissector *flow_dissector,
>                         void *target_container, const void *data,
>                         __be16 proto, int nhoff, int hlen, unsigned int flags)
> {
> [...]
>         WARN_ON_ONCE(!net);
>         if (net) {
> 
> it was added by 9b52e3f267a6 ("flow_dissector: handle no-skb use case")
> 
> Is this WARN_ON_ONCE() bogus?

When this was added (handle dissection from bpf prog, per netns), the correct
solution would have been to pass 'struct net' explicitly via skb_get_hash()
and all variants.  As that was likely deemed to be too much code churn it
tries to infer struct net via skb->{dev,sk}.

So there are several options here:
1. remove the WARN_ON_ONCE and be done with it
2. remove the WARN_ON_ONCE and pretend net was init_net
3. also look at skb_dst(skb)->dev if skb->dev is unset, then back to 1)
   or 2)
4. stop using skb_get_hash() from netfilter (but there are likely other
   callers that might hit this).
5. fix up callers, one by one
6. assign skb->dev inside netfilter if its unset

3 and 2 combined are probably going to be the least invasive.

5 might take some time, we now know two, namely tcp resets generated
from netfilter and igmp_send_report().  No idea if there are more.

I dislike 3) mainly because of the 'guess the netns' design, not because it
adds more code to a way too large function however, so maybe its
acceptable?
