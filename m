From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Ebtables hook order anomaly
Date: Wed, 9 Apr 2008 16:54:07 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804091639210.3866@fbirervta.pbzchgretzou.qr>
References: <925A849792280C4E80C5461017A4B8A226A019@mail733.InfraSupportEtc.com> <alpine.LNX.1.10.0803250301140.9368@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0803250455030.9368@fbirervta.pbzchgretzou.qr> <47E8F6B4.4030800@trash.net>
 <alpine.LNX.1.10.0804081645450.2229@fbirervta.pbzchgretzou.qr> <47FCD47A.7060600@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Greg Scott <GregScott@InfraSupportEtc.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45997 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbYDIOyI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 10:54:08 -0400
In-Reply-To: <47FCD47A.7060600@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-04-09 16:36, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> On Tuesday 2008-03-25 13:57, Patrick McHardy wrote:
>> > > > which means ebtables actually comes after iptables, and hence,
>> > > > your mark 3 will not show up as you expected.
>> > Indeed, on output bridge netfilter will run after IPv4 netfilter.
>> > Does that explain things?
>> 
>> It explains things, but having the feature removed is not nice.
>> I cannot deny that the previous code was real a hook spaghetteria,
>> but how could it be done better?
>
> Good question. The order on output is logically correct, so I
> wouldn't change it. I never liked the invocation of IP hooks
> from bridging at all, so long-term we could consider making
> the features people want to bridging available "natively"
> (like conntrack/NAT/...).

Can't quite imagine what you mean. Bridging is currently
implemented using a separate netdevice, much like bonding
or gre/ipip/tun/tap tunnels.

Well bridging is essentially a few pieces:

 - "forward" packets without changing MAC

 - arpreply engine

I have often come across needing a bridge device with a single port and
brouting=drop only because of ebt_arpreply; I have immediate plans
to remove this limitation.

 - STP

I seem to remember ideas about a userspace daemon were floating
around..

 - filtering on L2

there has been a L2-hooks back in the 2.4 days (at least the context
looks like it), and given that the ebtables targets now use
xtables, the l2hooks patch would actually be real easy.
