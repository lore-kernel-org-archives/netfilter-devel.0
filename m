From: Patrick McHardy <kaber@trash.net>
Subject: Re: SNMP conntrack module a la netbios_ns
Date: Sat, 05 Dec 2009 12:17:32 +0100
Message-ID: <4B1A414C.6020303@trash.net>
References: <1259920389.2510.30.camel@localhost.localdomain>	 <4B18E270.8090408@trash.net>  <4B18E2DD.1090405@trash.net> <1259945902.2510.35.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Tim Waugh <twaugh@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41859 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbZLELRa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Dec 2009 06:17:30 -0500
In-Reply-To: <1259945902.2510.35.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tim Waugh wrote:
> On Fri, 2009-12-04 at 11:22 +0100, Patrick McHardy wrote:
>> There is one problem however, we already have the SNMP NAT helper,
>> which also registers for the SNMP port. Those would clash if you
>> add a second registration.
> 
> Does that mean that even a simple copy of nf_conntrack_netbios_ns.c with
> the port changed to 161 wouldn't work, or just that a more general
> solution would be hard to implement?
> 
> What's the solution to that?  Must there be a single conntrack module to
> handle both the SNMP broadcast queries and SNMP NAT?

Correct, its not valid to have two helpers registered for the
same tuple. The SNMP NAT helper is an exception among the helpers
in that it doesn't register any expectations, but only rewrites
packets. What you'd need to do is change it to not register a
helper itself, but have your new module pass packets to the NAT
module in case its loaded, just as the other conntrack helpers do.

But as I said, the better way is to add generic broadcast tracking.
It shouldn't be that much more work and I'm not sure I really want
to add more workarounds like the netbios_ns helper since we'll have
to deal with compatibility problems once we do add broadcast tracking.
