From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: [PATCH] TPROXY cleanups
Date: Mon, 6 Oct 2008 16:15:59 +0200
Message-ID: <20081006141559.GC18559@sch.bme.hu>
References: <20081006121943.GA13547@x200.localdomain> <20081006122603.GA18559@sch.bme.hu> <20081006123921.GA23796@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, hidden@sch.bme.hu, netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:54539 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbYJFOQD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 10:16:03 -0400
Content-Disposition: inline
In-Reply-To: <20081006123921.GA23796@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On h, okt 06, 2008 at 04:39:21 +0400, Alexey Dobriyan wrote:
> On Mon, Oct 06, 2008 at 02:26:03PM +0200, KOVACS Krisztian wrote:
> > On h, okt 06, 2008 at 04:19:44 +0400, Alexey Dobriyan wrote:
> > > * drop version.h -- unneeded and file will be needlessly rebuilt.
> > > * make tproxy_core unloadable
> > > * use "in" device outright, -- target and match are only in PRE_ROUTING,
> > >   so should avoid dereference.
> 
> > > @@ -89,7 +88,11 @@ static int __init nf_tproxy_init(void)
> > >  	return 0;
> > >  }
> > >  
> > > +static void __exit nf_tproxy_exit(void)
> > > +{
> > > +}
> > >  module_init(nf_tproxy_init);
> > > +module_exit(nf_tproxy_exit);
> > 
> > Please don't do this. The module was made unloadable because it attaches a
> > function pointer to skb's and removing the module while there's an skb in
> > flight would cause a kernel crash.
> 
> Have you actually seen it?

No.

> xt_TPROXY will pin it because it uses a symbol from it, so it won't
> dissapear.

Yeah, that's true, and I think that it's impossible to remove the rule
attaching the socket references while the skb's in flight. Ok, so let's
add module_exit() then.

-- 
KOVACS Krisztian
