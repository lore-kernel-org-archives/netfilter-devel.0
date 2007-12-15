From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 4/7] xt_mark match rev 1
Date: Sat, 15 Dec 2007 17:10:50 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712151708380.22877@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0712070341010.1262@fbirervta.pbzchgretzou.qr>
 <475E65AC.9080901@trash.net> <Pine.LNX.4.64.0712151322150.22877@fbirervta.pbzchgretzou.qr>
 <4763F8FE.5040607@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57004 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754AbXLOQKv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Dec 2007 11:10:51 -0500
In-Reply-To: <4763F8FE.5040607@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 15 2007 16:55, Pablo Neira Ayuso wrote:
>
>The revision thing was a hack that I introduced myself to let us add
>several improvements that we really needed at that time, actually it is
>not something we should abuse IMO.
>
But it looks like the cleanest way to do things. If you think it is abuse,
do you have a better way?

>> Old revisions should be purged after a "reasonable time" (whatever
>> that means for everyone), or perhaps whenever there is a Linux kernel
>> version with a trailing .0 (2.7.0, 2.8.0), or when great new things
>> appear (pkttables, or whatever is in the works).
>> 
>> I think the step should better be made now than later, or this cruft
>> will be carried for the next 10 instead of 5 years.
>
>I hope that we'll get that long-awaited netlink interface for iptables
>before those 10 years goes by and we all become museum pieces :)
>
What will netlink bring us, with respect to the two states:
- old iptables, new kernel
- new iptables, old kernel
so matching some UUIDs (and .revision is one, more or less) seems like the way
to go.
