From: Florian Westphal <fw@strlen.de>
Subject: Re: RFC: bridge netfilter vlan device name resolution
Date: Tue, 27 Mar 2012 22:19:04 +0200
Message-ID: <20120327201904.GC15638@Chamillionaire.breakpoint.cc>
References: <20120326202124.GA15638@Chamillionaire.breakpoint.cc>
 <4F71FA0A.9010503@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45664 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754030Ab2C0UTF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Mar 2012 16:19:05 -0400
Content-Disposition: inline
In-Reply-To: <4F71FA0A.9010503@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer <bdschuym@pandora.be> wrote:
> > Two possible solutions come to mind:
> >
> > - #1, add the vlan tag to nf_bridge info for use with physdev match:
> >    "... -m physdev --vlan-id 42 ..."
> > - #2, change bridge netfilter so that it passes in the vlan instead of
> >    the bridge as input device.
> >
> > Any other ideas on how to handle this?
> 
> I don't like approach #2: it will break existing firewall configurations 
> and I really don't see a reason why we would change the network device 
> to a non-bridge device (br0.1 isn't a bridge). Approach #1 can be 
> achieved without code changes with the nfmark field as shown below.
> 
> You can filter on the vlan id in iptables by using the nfmark field 
> intelligently, see e.g.
> http://ebtables.sourceforge.net/examples/basic.html#ex_network_separation

I see, but this 'do it with nfmark' is really getting out of hand,
because thats what everyone says for everything (be it qos, tproxy/policy
routing, L7/DPI crap, ...).  I only need the vlan identification in nat
PREROUTING so perhaps i can re-use some of that machines QoS nfmarks
here and re-set the nfmarks in the mangle table,
thanks for the hint.

Pablo, please toss the patch --  I'll come up with something else in case the
nfmark solution won't work for me.
