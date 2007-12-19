From: Patrick McHardy <kaber@trash.net>
Subject: Re: Possible bug ipsec and SNAT?
Date: Wed, 19 Dec 2007 15:44:13 +0100
Message-ID: <47692E3D.7090008@trash.net>
References: <476903B4.8060303@wlz.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: "Slagter, EM" <eslagter@wlz.nl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53997 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbXLSOoh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Dec 2007 09:44:37 -0500
In-Reply-To: <476903B4.8060303@wlz.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Slagter, EM wrote:
> Hi,
> 
> I don't know whether this netfilter behaviour is a bug or intentional,
> but at least for me it's not what I'd expect (nor want).
> 
> Our system (simplified to significant parts):
> - linux i386 kernel 2.6.21.2 vanilla, almost all netfilter and ipsec
> parts compiled in, no (relevant) modules
> - one vlan interface connected to public internet
> - one vlan interface connected to internal vlan, RFC addresses
> - pluto ("openswan") to manage ISAKMP, appropriate config file
> - some netfilter rules that include -m policy to separate the ipsec
> traffic before and after encapsulation (for instance to prevent traffic
> to be sent over internet without encryption)
> 
> Using this scenario, it works pretty much as documented.
> 
> As soon as I add SNAT to traffic originating from this vlan (as required
> by our supplier), the rules that (properly) used to match on "-m policy
> --pol ipsec --dir out --tunnel-src ... --tunnel-dst ..." no longer
> match. Even if I remove the tunnel-src and --tunnel-dst the rule no
> longer matches. If I change "the --pol ipsec" to "--pol none" the rule
> matches again. This is wrong IMHO as the traffic is still encapsulated
> (checked this with tshark) as expected.
> 
> I've checked the ChangeLogs of the kernel from 2.6.21.2 to current but
> there doesn't seem to have been a relevant patch on this matter.


This is expected behaviour. Before NAT takes place, the packet
doesn't match a policy, it only does after getting mangled by
NAT, but at that point it already passed through your policy
matches.
