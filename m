Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBA013C3F2;
	Wed,  5 Jun 2024 22:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717625792; cv=none; b=puWEIvarLKy3M6nXtJrMv0HteqN1/lU+wVJRVMgWE8zzC+/dwHwdRr7oNlm1AIH7SlVKaJZDSwN3QQkd/ewwrgtXmjoBbDKQKP0sgyCLWAT32d/0tNoW+mK/ySX00Nj8qhByChilkMQiStV1WVC0Fvz1P0C5zFNoLmESCwYPIZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717625792; c=relaxed/simple;
	bh=rLsApU6zWmiEjwsiKrRgAGLddwbSgAjSWWKpGuHoS3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Omi5YgNNzvkJcppRFlp/mFeRqHhnuOWduPJ7Ep09dbIMQsdGKgCH93gNGhvxQBHB3/787vIhyjrOlMUqHpqJL1NugRykf999je1BxI7/1LNXvVkyUvccQIDIZseF++NpwjTJlv00mI0/NBf/ixIFXLeUyWtv6IVGgIh9J2vxtY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [31.221.188.228] (port=12056 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sEyvg-00B8Th-0A; Thu, 06 Jun 2024 00:16:26 +0200
Date: Thu, 6 Jun 2024 00:16:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Willem de Bruijn <willemb@google.com>
Cc: Florian Westphal <fw@strlen.de>, Christoph Paasch <cpaasch@apple.com>,
	Netfilter <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
	daniel@iogearbox.net, Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH nf] netfilter: nf_reject: init skb->dev for reset packet
Message-ID: <ZmDjtm27BnxQ0xRX@calendula>
References: <20240604120311.27300-1-fw@strlen.de>
 <FF8A506F-6F0F-440E-9F52-B27D05731B77@apple.com>
 <20240605181450.GA7176@breakpoint.cc>
 <ZmCwlbF8BvLGNgRM@calendula>
 <20240605190833.GB7176@breakpoint.cc>
 <ZmDAQ6r49kSgwaMm@calendula>
 <CA+FuTSfAhHDedA68LOiiUpbBtQKV9E-W5o4TJibpCWokYii69A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+FuTSfAhHDedA68LOiiUpbBtQKV9E-W5o4TJibpCWokYii69A@mail.gmail.com>
X-Spam-Score: -1.7 (-)

On Wed, Jun 05, 2024 at 05:38:00PM -0400, Willem de Bruijn wrote:
> On Wed, Jun 5, 2024 at 3:45 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Wed, Jun 05, 2024 at 09:08:33PM +0200, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >
> > > [ CC Willem ]
> > >
> > > > On Wed, Jun 05, 2024 at 08:14:50PM +0200, Florian Westphal wrote:
> > > > > Christoph Paasch <cpaasch@apple.com> wrote:
> > > > > > > Reported-by: Christoph Paasch <cpaasch@apple.com>
> > > > > > > Suggested-by: Paolo Abeni <pabeni@redhat.com>
> > > > > > > Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/494
> > > > > > > Signed-off-by: Florian Westphal <fw@strlen.de>
> > > > > >
> > > > > > I just gave this one a shot in my syzkaller instances and am still hitting the issue.
> > > > >
> > > > > No, different bug, this patch is correct.
> > > > >
> > > > > I refuse to touch the flow dissector.
> > > >
> > > > I see callers of ip_local_out() in the tree which do not set skb->dev.
> > > >
> > > > I don't understand this:
> > > >
> > > > bool __skb_flow_dissect(const struct net *net,
> > > >                         const struct sk_buff *skb,
> > > >                         struct flow_dissector *flow_dissector,
> > > >                         void *target_container, const void *data,
> > > >                         __be16 proto, int nhoff, int hlen, unsigned int flags)
> > > > {
> > > > [...]
> > > >         WARN_ON_ONCE(!net);
> > > >         if (net) {
> > > >
> > > > it was added by 9b52e3f267a6 ("flow_dissector: handle no-skb use case")
> > > >
> > > > Is this WARN_ON_ONCE() bogus?
> > >
> > > When this was added (handle dissection from bpf prog, per netns), the correct
> > > solution would have been to pass 'struct net' explicitly via skb_get_hash()
> > > and all variants.  As that was likely deemed to be too much code churn it
> > > tries to infer struct net via skb->{dev,sk}.
> 
> It has been a while, but I think we just did not anticipate skb's with
> neither dev nor sk set.
> 
> Digging through the layers from skb_hash to __skb_flow_dissect
> now, it does look impractical to add such an explicit API.
> 
> > > So there are several options here:
> > > 1. remove the WARN_ON_ONCE and be done with it
> > > 2. remove the WARN_ON_ONCE and pretend net was init_net
> > > 3. also look at skb_dst(skb)->dev if skb->dev is unset, then back to 1)
> > >    or 2)
> > > 4. stop using skb_get_hash() from netfilter (but there are likely other
> > >    callers that might hit this).
> > > 5. fix up callers, one by one
> > > 6. assign skb->dev inside netfilter if its unset
> 
> Is 6 a realistic option?

Postrouting path already sets on skb->dev via ip_output(), if callers
are "fixed" then skb->dev will get set twice.

the netfilter tracing infrastructure only needs a hash identifier for
this packet to be displayed from userspace when tracing rules, how is
the running the custom bpf dissector hook useful in such case?

the most correct solution is to pass struct net explicitly to the
dissector API instead of guessing what net this packet belongs to.

Else, remove this WARN_ON_ONCE which is just a oneliner.

> > > 3 and 2 combined are probably going to be the least invasive.
> > >
> > > 5 might take some time, we now know two, namely tcp resets generated
> > > from netfilter and igmp_send_report().  No idea if there are more.
> >
> > Quickly browsing, synproxy and tee also calls ip_local_out() too.
> >
> > icmp_send() which is used, eg. to send destination unreachable too to
> > reset.
> 
> Since this uses ip_append_data the generated response should have
> its skb->sk set.

thanks for explaining.

> > There is also __skb_get_hash_symmetric() that could hit this from
> > nft_hash?
> >
> > No idea what more callers need to be adjusted to remove this splat,
> > that was a cursory tree review.
> >
> > And ip_output() sets on skb->dev from postrouting path, then if
> > callers are fixed, then skb->dev would be once then again from output path?
