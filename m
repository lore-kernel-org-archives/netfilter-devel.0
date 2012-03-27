From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: RFC: bridge netfilter vlan device name resolution
Date: Tue, 27 Mar 2012 19:34:02 +0200
Message-ID: <4F71FA0A.9010503@pandora.be>
References: <20120326202124.GA15638@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:60310 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab2C0ReH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Mar 2012 13:34:07 -0400
In-Reply-To: <20120326202124.GA15638@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op 26/03/2012 22:21, Florian Westphal schreef:
> When using a bridge with a management vlan on top (e.g. br0.1), you
> cannot use iptables to match the input vlan device, because the vlan
> device isn't resolved yet, i.e.  "-i br0" matches, while "-i br0.1"
> does not, unless "net.bridge.bridge-nf-filter-vlan-tagged" (or
> "net.bridge.bridge-nf-call-iptables") is turned off.
>
> This happens because bridge netfilter runs before
> vlan device lookup, so skb->dev is set to the bridge; not
> the vlan device on top of the bridge.
>
> I'd like to use iptables -t nat ... -j REDIRECT only for one particular vlan.
>
> Two possible solutions come to mind:
>
> - #1, add the vlan tag to nf_bridge info for use with physdev match:
>    "... -m physdev --vlan-id 42 ..."
> - #2, change bridge netfilter so that it passes in the vlan instead of
>    the bridge as input device.
>
> Any other ideas on how to handle this?

I don't like approach #2: it will break existing firewall configurations 
and I really don't see a reason why we would change the network device 
to a non-bridge device (br0.1 isn't a bridge). Approach #1 can be 
achieved without code changes with the nfmark field as shown below.

You can filter on the vlan id in iptables by using the nfmark field 
intelligently, see e.g.
http://ebtables.sourceforge.net/examples/basic.html#ex_network_separation

cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be

