From: Florian Westphal <fw@strlen.de>
Subject: Re: Fwd: Re: [BUG] Fatal exception in interrupt -
 nf_nat_cleanup_conntrack during IPv6 tests
Date: Thu, 11 Apr 2013 11:34:52 +0200
Message-ID: <20130411093452.GA22909@breakpoint.cc>
References: <20130410090436.GG3013@breakpoint.cc>
 <20130410092347.GA15814@macbook.localnet>
 <20130410093204.GA11266@breakpoint.cc>
 <20130410094113.GA20477@macbook.localnet>
 <20130410145621.GD11266@breakpoint.cc>
 <20130410145729.GC23626@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	caiqian@redhat.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49628 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935591Ab3DKJe4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Apr 2013 05:34:56 -0400
Content-Disposition: inline
In-Reply-To: <20130410145729.GC23626@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> > > > Looks like it, nf_nat_ipv4 is listed as F- in the oops trace. (afaics,
> > > > "-" means "module going away").
> > > 
> > > Yes, that seems like a real race condition. We probably could extend the
> > > nf_nat_lock sections to avoid this, but I wonder wether we should just kill
> > > those conntracks, the connections are not going to work after being
> > > "de-nated" anymore anyway.
> > 
> > I like it, just killing them would make it a lot more simple.
> > 
> > The clear-nat-extension-on-module-unload dance is getting out of hand,
> > and, as you point out, the connections are not going to work anyway...
> 
> Yeah, lets just do that. Do you want to take care of this?

I can look into it, sure.
However, i missed one important point: non-NAT'd connections
have a null binding, and there doesn't seem to be a way to differentiate
between real vs. null binding.

Simply returning 1 for conntracks-with-nat-extension will zap every
connection.
