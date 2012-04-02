From: Florian Westphal <fw@strlen.de>
Subject: Re: RFC: bridge netfilter vlan device name resolution
Date: Mon, 2 Apr 2012 11:25:16 +0200
Message-ID: <20120402092516.GA24416@Chamillionaire.breakpoint.cc>
References: <20120326202124.GA15638@Chamillionaire.breakpoint.cc>
 <4F71FA0A.9010503@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:35988 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056Ab2DBJZR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:25:17 -0400
Content-Disposition: inline
In-Reply-To: <4F71FA0A.9010503@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer <bdschuym@pandora.be> wrote:
> Op 26/03/2012 22:21, Florian Westphal schreef:
> > When using a bridge with a management vlan on top (e.g. br0.1), you
> > cannot use iptables to match the input vlan device, because the vlan
> > device isn't resolved yet, i.e.  "-i br0" matches, while "-i br0.1"
> > does not, unless "net.bridge.bridge-nf-filter-vlan-tagged" (or
> > "net.bridge.bridge-nf-call-iptables") is turned off.
> >
> > This happens because bridge netfilter runs before
> > vlan device lookup, so skb->dev is set to the bridge; not
> > the vlan device on top of the bridge.
> >
> > I'd like to use iptables -t nat ... -j REDIRECT only for one particular vlan.
> >
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

However, the REDIRECT target won't work with vlans on the bridge,
because skb->dev points to the bridge instead of the vlan, and thus
the REDIRECT target fails to get the ip address.

Would at least the PRE_ROUTING part of my patch be acceptable to make
REDIRECT work?

Thanks,
Florian
