From: Florian Westphal <fw@strlen.de>
Subject: Re: Fwd: Re: [BUG] Fatal exception in interrupt -
 nf_nat_cleanup_conntrack during IPv6 tests
Date: Wed, 10 Apr 2013 16:56:21 +0200
Message-ID: <20130410145621.GD11266@breakpoint.cc>
References: <20130410090436.GG3013@breakpoint.cc>
 <20130410092347.GA15814@macbook.localnet>
 <20130410093204.GA11266@breakpoint.cc>
 <20130410094113.GA20477@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	caiqian@redhat.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43392 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936837Ab3DJO4X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Apr 2013 10:56:23 -0400
Content-Disposition: inline
In-Reply-To: <20130410094113.GA20477@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> On Wed, Apr 10, 2013 at 11:32:04AM +0200, Florian Westphal wrote:
> > Patrick McHardy <kaber@trash.net> wrote:
> > > On Wed, Apr 10, 2013 at 11:04:36AM +0200, Florian Westphal wrote:
> > > > > [ 3599.241868] Code: 83 ec 08 0f b6 58 11 84 db 74 43 48 01 c3 48 83 7b 20 00 74 39 48 c7 c7 b8 65 32 a0 e8 98 fc 2e e1 48 8b 03 48 8b 53 08 48 85 c0 <48> 89 02 74 04 48 89 50 08 48 ba 00 02 20 00 00 00 ad de 48 c7  
> > > > > [ 3599.337037] RIP  [<ffffffffa03227f2>] nf_nat_cleanup_conntrack+0x42/0x70 [nf_nat] 
> > > > 
> > > > Looks like we tried to remove bysource hash twice (rdx is
> > > > LIST_POISON_2).
> > > > 
> > > > I wonder if this would explain it:
> > > > 
> > > > static void nf_nat_l4proto_clean(u8 l3proto, u8 l4proto)
> > > > {
> > > > [..]
> > > >       /* Step 1 - remove from bysource hash */
> > > >       clean.hash = true;
> > > >       for_each_net(net)
> > > >                 nf_ct_iterate_cleanup(net, nf_nat_proto_clean, &clean);
> > > > 
> > > > A nfct->timer fires and a conntrack is free'd before step 2 memsets the
> > > > nat extension.  In that case, we would try to delete nat->bysource
> > > > again?
> > > 
> > > Not sure I follow, we only invoke nf_nat_l4proto_clean() through
> > > nf_nat_l4proto_unregister(), right?
> > >
> > > Did this happen during module unload?
> > 
> > Looks like it, nf_nat_ipv4 is listed as F- in the oops trace. (afaics,
> > "-" means "module going away").
> 
> Yes, that seems like a real race condition. We probably could extend the
> nf_nat_lock sections to avoid this, but I wonder wether we should just kill
> those conntracks, the connections are not going to work after being
> "de-nated" anymore anyway.

I like it, just killing them would make it a lot more simple.

The clear-nat-extension-on-module-unload dance is getting out of hand,
and, as you point out, the connections are not going to work anyway...
