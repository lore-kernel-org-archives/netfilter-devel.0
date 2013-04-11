From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fwd: Re: [BUG] Fatal exception in interrupt -
 nf_nat_cleanup_conntrack during IPv6 tests
Date: Thu, 11 Apr 2013 12:40:15 +0200
Message-ID: <20130411104014.GA3091@macbook.localnet>
References: <20130410090436.GG3013@breakpoint.cc>
 <20130410092347.GA15814@macbook.localnet>
 <20130410093204.GA11266@breakpoint.cc>
 <20130410094113.GA20477@macbook.localnet>
 <20130410145621.GD11266@breakpoint.cc>
 <20130410145729.GC23626@macbook.localnet>
 <20130411093452.GA22909@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	caiqian@redhat.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63494 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3DKKkh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Apr 2013 06:40:37 -0400
Content-Disposition: inline
In-Reply-To: <20130411093452.GA22909@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 11, 2013 at 11:34:52AM +0200, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > > > > Looks like it, nf_nat_ipv4 is listed as F- in the oops trace. (afaics,
> > > > > "-" means "module going away").
> > > > 
> > > > Yes, that seems like a real race condition. We probably could extend the
> > > > nf_nat_lock sections to avoid this, but I wonder wether we should just kill
> > > > those conntracks, the connections are not going to work after being
> > > > "de-nated" anymore anyway.
> > > 
> > > I like it, just killing them would make it a lot more simple.
> > > 
> > > The clear-nat-extension-on-module-unload dance is getting out of hand,
> > > and, as you point out, the connections are not going to work anyway...
> > 
> > Yeah, lets just do that. Do you want to take care of this?
> 
> I can look into it, sure.
> However, i missed one important point: non-NAT'd connections
> have a null binding, and there doesn't seem to be a way to differentiate
> between real vs. null binding.
> 
> Simply returning 1 for conntracks-with-nat-extension will zap every
> connection.

We only set the IPS_SRC_NAT/IPS_DST_NAT flags for non-null bindings.
Checking for these should work.
