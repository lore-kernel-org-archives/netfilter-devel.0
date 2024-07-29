Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA6313BC3F
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jul 2024 15:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722267143; cv=none; b=QKlcN/scOBRS8UiVMtw2s4zsP86QX1b7Fe/+IiDs3nb9G3/Nnq1GMxCxN31CKaHCNVajyN9dyJeRPov6RWzbM0gK6hMLHAqH9v5nM71vBWCv3HJmSD/EyKpfV+n4I91t1hYDvlkJnkw0oBirH4aOD5iQ/xFcjqLlZzFnZHdL3OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722267143; c=relaxed/simple;
	bh=9fqibVk96rIK5Pa4huhuZomoNRY1vDNobo+ap1gG0Xs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kj77ffDpJDo7WjX+fo/olfvAva86xIQUrNayXRlcbyQeK3SWM0s7bCNnZi2bDwFCLEyos6ELRk8HAYFvm14neCZ4f/bLzEANFijrK5YZDdxw041mUyPIiz0DVbZmbMoNwXLbN0+zG2nQtfXGr4jRrWdYM7alHa58nIputkUd5Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sYSM7-0007if-Do; Mon, 29 Jul 2024 17:32:11 +0200
Date: Mon, 29 Jul 2024 17:32:11 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft 1/4] doc: add documentation about list hooks feature
Message-ID: <20240729153211.GA26048@breakpoint.cc>
References: <20240726015837.14572-1-fw@strlen.de>
 <20240726015837.14572-2-fw@strlen.de>
 <ZqNlvkJ2YSc-KIKb@calendula>
 <20240726123152.GA3778@breakpoint.cc>
 <ZqbR0yOY87wI0VoS@calendula>
 <20240728233736.GA31560@breakpoint.cc>
 <ZqbgmMzuOQShJWXK@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqbgmMzuOQShJWXK@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Jul 29, 2024 at 01:37:36AM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > Not really, why would eth0 and eth1 be related here?
> > > 
> > > Note that you can specify:
> > > 
> > >   list hooks ip device enp0s25
> > > 
> > > this shows the hooks that will be exercised for a given packet family,
> > > ie. IPv4 packets will exercise the following hooks.
> > > 
> > > family ip {
> > >         hook ingress {
> > >                  0000000000 chain netdev x y [nf_tables]
> > >         }
> > >         hook prerouting {
> > >                 -0000000400 ipv4_conntrack_defrag [nf_defrag_ipv4]
> > >                 -0000000200 ipv4_conntrack_in [nf_conntrack]
> > >         }
> > >         hook input {
> > >                  0000000000 chain ip filter in [nf_tables]
> > >                 +2147483647 nf_confirm [nf_conntrack]
> > >         }
> > >         hook forward {
> > >                 -0000000225 selinux_ip_forward
> > >         }
> > >         hook output {
> > >                 -0000000400 ipv4_conntrack_defrag [nf_defrag_ipv4]
> > >                 -0000000225 selinux_ip_output
> > >                 -0000000200 ipv4_conntrack_local [nf_conntrack]
> > >         }
> > >         hook postrouting {
> > >                 +0000000225 selinux_ip_postroute
> > >                 +2147483647 nf_confirm [nf_conntrack]
> > >         }
> > > }
> > > 
> > > This is _not_ showing the list of hooks for a given family.
> > 
> > I now realize that whats in the tree today is not what I wrote originally.
> 
> We agreed to change it.

Sorry.  I'm old and do not remember.
TL;DR: I think we should revert to strict behaviour, i.e.
nft list hooks foo

queries hooks registered as NFPROTO_FOO.

NFPROTO_INET expands to shorthand for 'list hooks ip and ip6'.

AFAICS the problem is that ip, ip6 and arp are both NFPROTO_ values
(protocol families), but also l3 protocols, whereas netdev and bridge
are only families.

Hence, what to do on bridge becomes murky, there is just a large number
of possible l3 protocols that can pass through these hooks.

Netdev is simple because its scoped only to one single interface.

Sorry for the wall of text below, but maybe it helps to understand
why i think the above (no-guesses, treat strictly as nfproto) makes sense.

> > So this is neither showing the hooks that will be execrised (packet
> > can't be input and forward...).  But ok.  I don't know what to do now.
> 
> As it is not possible to know where the packet is going (input /
> forward), this listing represents what hooks can be potentially
> exercised for such packet family, hence, netdev hooks are included in
> the ip family view.

I was confused because it lists netdev hooks when asking for
bridge, and when I made this facility my intent was for this to
return hooks that were registered with NFPROTO_$QUERY.

So i did not expect to see netdev hooks.

list hooks arp device eth0
my expectation:
1. no output OR
2. NFPROTO_ARP in and output hooks OR
3. error, e.g. "device not supported for arp family".

But I get this instead:
  family arp {
          hook ingress {
                   0000000000 chain netdev ingress in_public [nf_tables]
          }
  }

Which I considered a bug but if we say that the query should return
hooks that this protocol family is exposed to, then that might be ok.

Should it list bridge hooks too?  Same rationale would apply as to
why it shows the netdev family ingress hook:
ARP packets will be picked up by bridge hooks if they arrive on
interfaces that serve as a bridge port.

I think that original code was simpler, less guesswork on
userspace side, what-you-ask-for-is-what-you-get, i.e. for
"list hooks arp" shows only hooks registered with NFPROTO_ARP on
kernel side, and nothing else.

For "list hooks arp device eth0", we could either return an error,
or pass this to kernel in case we gain arp+device at some point,
even though i don't see why anyone would add that.

inet ingress is already awkward in my opinion, I'm not sure why it
got added.

> If you don't like this behaviour and prefer a strict view per hook
> family it should be possible to revisit. User will have to get all the
> pieces together to understand what the hook pipeline is instead. This
> command has not been documented so far.

Yes.  In theory it should be possible to do this, so to go with arp example:

  nft list hooks arp device foo

would list:

1. netdev ingress and egress hook for the queried device
2. arp in and output hooks (there is no forward for arp)
3. bridge pre,in,forward,output and postrouting

but does that make sense?  I don't think so, because it gets more
complicated for bridge query:

nft list hooks bridge

1. can't show netdev, we lack device to query -> query all interfaces?
   But why would one clutter output with netdev in/egress when bridge
   was asked for?
2. show pre/in/fwd/out/postrouting NFPROTO_BRIDGE hooks
3. should it show ip/ip6 hooks? They could be relevant in case
   of broute expression in nftables.
   ip/ip6 Output+postrouting are travesed in case of local packets.

and it would have to show arp hooks, no?  for arp packet, we might pass
them up to local stack.  Local arp query pass through arp:output.

So I'm just worried that this gets complicated/murky as to what is shown
(and what is omitted).  For bridge, we would have to end up dumping
everything and treat it like 'list hooks'....

I do admit that it would be nice to have something like:

nft list pipeline meta input eth0 ip saddr 1.2.3.4 ip daddr 5.6.7.8

and then have nft:
1. list NFPROTO_NETDEV for eth0 ingress only (no egress)
2. list NFPROTO_INET hooks for ingress eth0
3. list NFPROTO_IPV4 hooks for prerouting
4. query FIB to get output device for 1.2.3.4->5.6.7.8
5. list NFPROTO_IPV4 for EITHER input or forward+postrouting
6. for forward case, list NFPROTO_NETDEV egress hooks for the
fib-derviced output device

But thats hard, because there might be rules in place that
alter ip daddr or ip saddr, or packet mark etc etc so the
pipeline shown can be a wrong.

And bridge needs extra work, we need to figure out if eth0
is a bridge port and then dump NFPROTO_BRIDGE.
And query l2 address of the ip address to query bridge fib to
figure out of this enters local delivery or forwarding case, or
both...

Or, require use of 'ether daddr' for bridge.  But still, its a lot
of work to make this.

> I think patchset looks fine, but documentation update needs a revamp
> if you agree in the existing behaviour.

I agree that we first need to figure out what 'nft list hooks xxxx'
should do.  I would prefer 'no guesses' approach, i.e.

1. nft list hooks
  dump everything EXCEPT netdev families/devices
2. nft list hooks netdev device foo
   dump ingress/egress netdev hooks,
   INCLUDING inet ingress (its scoped to the device).
3. nft list hooks arp
   dump arp input and output, if any
4. nft list hooks bridge
   dump bridge pre/input/forward/out/postrouting
5. nft list hooks ip
   dump ip pre/input/forward/out/postrouting
6. nft list hooks ip6 -> see above
7. nft list hooks inet -> alias for dumping both ip+ip6 hooks.

This also means that i'd make 'inet device foo' return a warning
that the device will be ignored because "inet ingress" is syntactic
frontend sugar similar to inet pseudo-family.

We could try the 'detect pipeline' later.  But, as per example
above, I don't think its easy, unless one omits all packet rewrites
(stateless nat, dnat, redirect) and everything else that causes
re-routing, e.g. policy routing, tproxy, tc(x), etc.

And then there is l3 and l2 multicasting...

But, admittingly, it might be nice to have something and it might be
good enough if pipeline alterations by ruleset and other entities
are omitted.
