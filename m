From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3 kernel 19/29] add byte threshold capability to nfacct
Date: Thu, 11 Jul 2013 22:25:47 +0200
Message-ID: <20130711202547.GH27468@breakpoint.cc>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
 <1373480727-11254-20-git-send-email-michael.zintakis@googlemail.com>
 <20130710200053.GC27468@breakpoint.cc>
 <51DEFFE6.5070907@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
To: Michael Zintakis <michael.zintakis@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44953 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174Ab3GKUZu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jul 2013 16:25:50 -0400
Content-Disposition: inline
In-Reply-To: <51DEFFE6.5070907@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Michael Zintakis <michael.zintakis@googlemail.com> wrote:
> Florian Westphal wrote:
> > Michael Zintakis <michael.zintakis@googlemail.com> wrote:
> >> * add a 'bthr' variable to each nfacct object, allowing a bytes 'threshold'
> >> to be stored and then reported if/when traffic breaches it.
> > 
> > Again, why is this needed?
> > Why is it useful?
> This is used for measuring traffic "expectancy", i.e. allows one to be able to register what amount of traffic is "expected" to pass through this accounting object. If that traffic threshold is exceeded, this is properly indicated when the accounting object is listed or any statistics for that object are being collected by the nfacct daemon.
> 
> That traffic "expectancy" can be set/reset depending on the nature of the traffic or its source/destination etc, so it is pretty flexible. Again, there is extensive information on this in the (revised) man page if you decide to look at it.

I still don't understand why this needs to be in the kernel.
nfacct gives you the counters, how these are interpreted (e.g. 'higher
than expected' should be entirely up to userspace).

In case you need some way of reacting to excess counters, then perhaps
it makes sense to change nfacct match to allow "greater/less than"
matching expression instead?

E.g.:
-A bla -m nfacct --nfacct-name bla --nfacct-packets 1000000: -m limit
--limit 1/hour -j NFLOG --nflog-prefix 'bla packet threshold'

or something like that?

There is something similar for the conntrack accounting (-m connbytes).
