From: Patrick McHardy <kaber@trash.net>
Subject: Re: Ebtables hook order anomaly
Date: Wed, 09 Apr 2008 17:04:05 +0200
Message-ID: <47FCDAE5.5050409@trash.net>
References: <925A849792280C4E80C5461017A4B8A226A019@mail733.InfraSupportEtc.com> <alpine.LNX.1.10.0803250301140.9368@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0803250455030.9368@fbirervta.pbzchgretzou.qr> <47E8F6B4.4030800@trash.net> <alpine.LNX.1.10.0804081645450.2229@fbirervta.pbzchgretzou.qr> <47FCD47A.7060600@trash.net> <alpine.LNX.1.10.0804091639210.3866@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Greg Scott <GregScott@InfraSupportEtc.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50045 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbYDIPEK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:04:10 -0400
In-Reply-To: <alpine.LNX.1.10.0804091639210.3866@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-04-09 16:36, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> It explains things, but having the feature removed is not nice.
>>> I cannot deny that the previous code was real a hook spaghetteria,
>>> but how could it be done better?
>> Good question. The order on output is logically correct, so I
>> wouldn't change it. I never liked the invocation of IP hooks
>> from bridging at all, so long-term we could consider making
>> the features people want to bridging available "natively"
>> (like conntrack/NAT/...).
> 
> Can't quite imagine what you mean. Bridging is currently
> implemented using a separate netdevice, much like bonding
> or gre/ipip/tun/tap tunnels.
> 
> Well bridging is essentially a few pieces:
> 
>  - "forward" packets without changing MAC
> 
>  - arpreply engine

A pure bridge doesn't need ARP. I don't get your point,
but my suggestion might not make much sense, I haven't
really thought about this.

> I have often come across needing a bridge device with a single port and
> brouting=drop only because of ebt_arpreply; I have immediate plans
> to remove this limitation.
> 
>  - STP
> 
> I seem to remember ideas about a userspace daemon were floating
> around..
> 
>  - filtering on L2
> 
> there has been a L2-hooks back in the 2.4 days (at least the context
> looks like it), and given that the ebtables targets now use
> xtables, the l2hooks patch would actually be real easy.

They were used for the kernel ct_sync implementation. Why
would you use them for briding, it has its own hooks?

