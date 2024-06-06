Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD6473465;
	Thu,  6 Jun 2024 06:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717654837; cv=none; b=ihKWQHyHYzlp5xh8jgiUq+BSWQHzbFcwdeIzhpQ+L4Lvjaq5hFe4U1aQwBBGP/JzeYLhKo81fb85a5C+hOgjJlVNgmSff2e58AzixgYCbpFbRTQXyl7l9rPyriiI0GRrUtTZ9iWYSv9+y8QRVp1ns1aoHlGfwdHRvxnCyu89y+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717654837; c=relaxed/simple;
	bh=wa/Y5z7S+OxoN3U5U/ujBKeym5MpVXkjvY8FYwuv3Nk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hPE9f2zANPzeAKBHho1JeXoL2iu7Sc3rPPh57C/j571enwj09kJt5P6gm94ERQVB7ojrJp8xoFrpFJqf5kVRHq3sqzCiuKim2gzxiwZIfQrWHD3NLxSi7Or1MTgbP7icd5kFofsMbY+8r+Ve+E/SYnG1pMRFUZ73AtM9kru5wOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [31.221.188.228] (port=12018 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sF6U4-00Bkcr-5B; Thu, 06 Jun 2024 08:20:26 +0200
Date: Thu, 6 Jun 2024 08:20:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Willem de Bruijn <willemb@google.com>
Cc: Florian Westphal <fw@strlen.de>, Christoph Paasch <cpaasch@apple.com>,
	Netfilter <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
	daniel@iogearbox.net, Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH nf] netfilter: nf_reject: init skb->dev for reset packet
Message-ID: <ZmFVJtJqKEyuuvbK@calendula>
References: <20240604120311.27300-1-fw@strlen.de>
 <FF8A506F-6F0F-440E-9F52-B27D05731B77@apple.com>
 <20240605181450.GA7176@breakpoint.cc>
 <ZmCwlbF8BvLGNgRM@calendula>
 <20240605190833.GB7176@breakpoint.cc>
 <ZmDAQ6r49kSgwaMm@calendula>
 <CA+FuTSfAhHDedA68LOiiUpbBtQKV9E-W5o4TJibpCWokYii69A@mail.gmail.com>
 <ZmDjtm27BnxQ0xRX@calendula>
 <CA+FuTScK2cpgRdd5CjgE=z=XbH8Gb45i4kkMNKsCPN9rQa6GpQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+FuTScK2cpgRdd5CjgE=z=XbH8Gb45i4kkMNKsCPN9rQa6GpQ@mail.gmail.com>
X-Spam-Score: -1.7 (-)

Hi Willem,

On Wed, Jun 05, 2024 at 09:54:59PM -0400, Willem de Bruijn wrote:
> On Wed, Jun 5, 2024 at 6:16 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Wed, Jun 05, 2024 at 05:38:00PM -0400, Willem de Bruijn wrote:
> > > On Wed, Jun 5, 2024 at 3:45 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > >
> > > > On Wed, Jun 05, 2024 at 09:08:33PM +0200, Florian Westphal wrote:
> > > > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > >
> > > > > [ CC Willem ]
> > > > >
> > > > > > On Wed, Jun 05, 2024 at 08:14:50PM +0200, Florian Westphal wrote:
> > > > > > > Christoph Paasch <cpaasch@apple.com> wrote:
> > > > > > > > > Reported-by: Christoph Paasch <cpaasch@apple.com>
> > > > > > > > > Suggested-by: Paolo Abeni <pabeni@redhat.com>
> > > > > > > > > Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/494
> > > > > > > > > Signed-off-by: Florian Westphal <fw@strlen.de>
> > > > > > > >
> > > > > > > > I just gave this one a shot in my syzkaller instances and am still hitting the issue.
> > > > > > >
> > > > > > > No, different bug, this patch is correct.
> > > > > > >
> > > > > > > I refuse to touch the flow dissector.
> > > > > >
> > > > > > I see callers of ip_local_out() in the tree which do not set skb->dev.
> > > > > >
> > > > > > I don't understand this:
> > > > > >
> > > > > > bool __skb_flow_dissect(const struct net *net,
> > > > > >                         const struct sk_buff *skb,
> > > > > >                         struct flow_dissector *flow_dissector,
> > > > > >                         void *target_container, const void *data,
> > > > > >                         __be16 proto, int nhoff, int hlen, unsigned int flags)
> > > > > > {
> > > > > > [...]
> > > > > >         WARN_ON_ONCE(!net);
> > > > > >         if (net) {
> > > > > >
> > > > > > it was added by 9b52e3f267a6 ("flow_dissector: handle no-skb use case")
> > > > > >
> > > > > > Is this WARN_ON_ONCE() bogus?
> > > > >
> > > > > When this was added (handle dissection from bpf prog, per netns), the correct
> > > > > solution would have been to pass 'struct net' explicitly via skb_get_hash()
> > > > > and all variants.  As that was likely deemed to be too much code churn it
> > > > > tries to infer struct net via skb->{dev,sk}.
> > >
> > > It has been a while, but I think we just did not anticipate skb's with
> > > neither dev nor sk set.
> > >
> > > Digging through the layers from skb_hash to __skb_flow_dissect
> > > now, it does look impractical to add such an explicit API.
> > >
> > > > > So there are several options here:
> > > > > 1. remove the WARN_ON_ONCE and be done with it
> > > > > 2. remove the WARN_ON_ONCE and pretend net was init_net
> > > > > 3. also look at skb_dst(skb)->dev if skb->dev is unset, then back to 1)
> > > > >    or 2)
> > > > > 4. stop using skb_get_hash() from netfilter (but there are likely other
> > > > >    callers that might hit this).
> > > > > 5. fix up callers, one by one
> > > > > 6. assign skb->dev inside netfilter if its unset
> > >
> > > Is 6 a realistic option?
> >
> > Postrouting path already sets on skb->dev via ip_output(), if callers
> > are "fixed" then skb->dev will get set twice.
> 
> I meant to set it just before calling skb_get_hash and unset
> right after. Just using the skb to piggy back the information.
> 
> > the netfilter tracing infrastructure only needs a hash identifier for
> > this packet to be displayed from userspace when tracing rules, how is
> > the running the custom bpf dissector hook useful in such case?
> 
> The BPF flow dissector is there as much to short circuit the
> hard-coded C protocol dissectors as to expand on the existing
> feature set. I did not want production machines exposed to
> every protocol parser, as that set kept expanding.
> 
> Having different dissection algorithms depending on where the
> packet enters the dissector is also surprising behavior?

I would say: "having different dissection _operation modes_ depending on
where the packets enters the dissector is the expected behaviour", so
the dissector code adapts to the use-case.

> If all that is needed is an opaque ID, and on egress skb->hash
> is derived with skb_set_hash_from_sk from sk_txhash, then
> this can even be pseudo-random from net_tx_rndhash().

I think this will not work for the netfilter use-case, such
pseudo-random number would be then generated in the scope of the chain
and that packet could go over several chains while being processed.
Thus, displaying different IDs for the same packet.

> > the most correct solution is to pass struct net explicitly to the
> > dissector API instead of guessing what net this packet belongs to.
> 
> Unfortunately from skb_get_hash to __skb_flow_dissect is four
> layers of indirections, including one with three underscores already,
> that cannot be easily circumvented.
> 
> Temporarily passing it through skb (and unsetting after) seems
> the simplest fix to me.

it sounds like a temporary workaround. I understand your concern that
it requires a much larger patch to pass net to the flow dissector
infrastructure.

> > Else, remove this WARN_ON_ONCE which is just a oneliner.
> 
> According to the commit that introduced it, this was to sniff out drivers
> that don't set this (via eth_get_headlen).
> 
> The problem is that nothing else warns loudly, so you just quietly
> lose the BPF dissection coverage.
> 
> This is the first time it warned. You point out that the value of BPF
> is limited to you in this case. But that's not true for all such cases.
> I'd rather dissection breaks hard than that it falls back quietly for
> input from an untrusted network.
> 
> Maybe reduce it to DEBUG_NET_WARN_ON_ONCE?

I am afraid syzkaller and such will still hit this for Christoph,
since DEBUG_NET is usually recommended to be turned on in such case.

Another possibility is that netfilter stops using the dissector code
for the tracing infrastructure at the cost of replicating code.

Thanks.
