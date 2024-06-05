Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4E312F373;
	Wed,  5 Jun 2024 19:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717616717; cv=none; b=T7flflr5XUvGjky0ocYZ9PpdQH1ug2kL2J34hI8+amRL+YbmS0lQTAnO2+BF4hz7W+Xgr57CcaLsacADAZLmC58O1Rs8iqw/GqXld4WbVOmLsq7pTbkUeXQYkVVU+rqhnLvkTyOOoUPZNfQ6/coHYwSSHGc+8CjjW9lepnMXT6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717616717; c=relaxed/simple;
	bh=iw7MWP8NfZ99vapASmUgc+MfuhBAKaNFZejrXEEvg7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IaBBdsa1hddQbPcFiPWV+rFEHwO1AxyTXj1vBEKb2mKouBzj2u1Ei+UwOO4VM0mKbtCkhTwHW/gu6hZN0iBXsd9rY8iFbkI2z8u0UjCBx9/PVgJtDq32WIl7EJSu3QIATbsMU4WdIov7DqAmcNrZE0P488D9osI6wsjTDwubwV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [31.221.188.228] (port=12024 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sEwZJ-00Ayr0-9A; Wed, 05 Jun 2024 21:45:11 +0200
Date: Wed, 5 Jun 2024 21:45:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Christoph Paasch <cpaasch@apple.com>,
	Netfilter <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
	daniel@iogearbox.net, willemb@google.com
Subject: Re: [PATCH nf] netfilter: nf_reject: init skb->dev for reset packet
Message-ID: <ZmDAQ6r49kSgwaMm@calendula>
References: <20240604120311.27300-1-fw@strlen.de>
 <FF8A506F-6F0F-440E-9F52-B27D05731B77@apple.com>
 <20240605181450.GA7176@breakpoint.cc>
 <ZmCwlbF8BvLGNgRM@calendula>
 <20240605190833.GB7176@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240605190833.GB7176@breakpoint.cc>
X-Spam-Score: -1.7 (-)

On Wed, Jun 05, 2024 at 09:08:33PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> [ CC Willem ]
> 
> > On Wed, Jun 05, 2024 at 08:14:50PM +0200, Florian Westphal wrote:
> > > Christoph Paasch <cpaasch@apple.com> wrote:
> > > > > Reported-by: Christoph Paasch <cpaasch@apple.com>
> > > > > Suggested-by: Paolo Abeni <pabeni@redhat.com>
> > > > > Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/494
> > > > > Signed-off-by: Florian Westphal <fw@strlen.de>
> > > >
> > > > I just gave this one a shot in my syzkaller instances and am still hitting the issue.
> > >
> > > No, different bug, this patch is correct.
> > >
> > > I refuse to touch the flow dissector.
> > 
> > I see callers of ip_local_out() in the tree which do not set skb->dev.
> > 
> > I don't understand this:
> > 
> > bool __skb_flow_dissect(const struct net *net,
> >                         const struct sk_buff *skb,
> >                         struct flow_dissector *flow_dissector,
> >                         void *target_container, const void *data,
> >                         __be16 proto, int nhoff, int hlen, unsigned int flags)
> > {
> > [...]
> >         WARN_ON_ONCE(!net);
> >         if (net) {
> > 
> > it was added by 9b52e3f267a6 ("flow_dissector: handle no-skb use case")
> > 
> > Is this WARN_ON_ONCE() bogus?
> 
> When this was added (handle dissection from bpf prog, per netns), the correct
> solution would have been to pass 'struct net' explicitly via skb_get_hash()
> and all variants.  As that was likely deemed to be too much code churn it
> tries to infer struct net via skb->{dev,sk}.
> 
> So there are several options here:
> 1. remove the WARN_ON_ONCE and be done with it
> 2. remove the WARN_ON_ONCE and pretend net was init_net
> 3. also look at skb_dst(skb)->dev if skb->dev is unset, then back to 1)
>    or 2)
> 4. stop using skb_get_hash() from netfilter (but there are likely other
>    callers that might hit this).
> 5. fix up callers, one by one
> 6. assign skb->dev inside netfilter if its unset
> 
> 3 and 2 combined are probably going to be the least invasive.
> 
> 5 might take some time, we now know two, namely tcp resets generated
> from netfilter and igmp_send_report().  No idea if there are more.

Quickly browsing, synproxy and tee also calls ip_local_out() too.

icmp_send() which is used, eg. to send destination unreachable too to
reset.

There is also __skb_get_hash_symmetric() that could hit this from
nft_hash?

No idea what more callers need to be adjusted to remove this splat,
that was a cursory tree review.

And ip_output() sets on skb->dev from postrouting path, then if
callers are fixed, then skb->dev would be once then again from output path?
