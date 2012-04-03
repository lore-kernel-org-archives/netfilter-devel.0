From: Florian Westphal <fw@strlen.de>
Subject: Re: RFC: bridge netfilter vlan device name resolution
Date: Tue, 3 Apr 2012 22:47:39 +0200
Message-ID: <20120403204739.GA23461@Chamillionaire.breakpoint.cc>
References: <20120326202124.GA15638@Chamillionaire.breakpoint.cc>
 <4F71FA0A.9010503@pandora.be>
 <20120402092516.GA24416@Chamillionaire.breakpoint.cc>
 <4F7AEA84.3070004@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46030 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751552Ab2DCUrk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Apr 2012 16:47:40 -0400
Content-Disposition: inline
In-Reply-To: <4F7AEA84.3070004@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer <bdschuym@pandora.be> wrote:
> >> I don't like approach #2: it will break existing firewall 
> >> configurations and I really don't see a reason why we would change 
> >> the network device to a non-bridge device (br0.1 isn't a bridge). 
> >> Approach #1 can be achieved without code changes with the nfmark 
> >> field as shown below. You can filter on the vlan id in iptables by 
> >> using the nfmark field intelligently, see e.g. 
> >> http://ebtables.sourceforge.net/examples/basic.html#ex_network_separation 
> >
> > However, the REDIRECT target won't work with vlans on the bridge,
> > because skb->dev points to the bridge instead of the vlan, and thus
> > the REDIRECT target fails to get the ip address.
> 
> Can't you use the DNAT target instead? If you have multiple vlan devices 
> on top with multiple IP addresses, you can use the nfmark value to 
> determine the destination IP address.

Right.  But we're low on available nfmarks.

> > Would at least the PRE_ROUTING part of my patch be acceptable to make
> > REDIRECT work?
> 
> No, for the same reasons as stated before... What would be acceptable is 
> an extension that allows to specify which input device to give to 
> iptables. Perhaps for your use case, another flag in 
> |/proc/sys/net/bridge/ |that allows turning this feature on (off by 
> default) would be nice. The behaviour should then be like your original 
> idea and not restricted to only the PREROUTING case described above. A 
> name for the flag that comes to mind is |bridge-nf-pass-vlan-input-device.|

Thanks, this seems to be a good solution.
I'll cook up a patch.

Thanks for your help,
Florian
