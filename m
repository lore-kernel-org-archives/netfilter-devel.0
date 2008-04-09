From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Ebtables hook order anomaly
Date: Wed, 9 Apr 2008 18:11:13 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804091808500.3866@fbirervta.pbzchgretzou.qr>
References: <925A849792280C4E80C5461017A4B8A226A019@mail733.InfraSupportEtc.com> <alpine.LNX.1.10.0803250301140.9368@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0803250455030.9368@fbirervta.pbzchgretzou.qr> <47E8F6B4.4030800@trash.net>
 <alpine.LNX.1.10.0804081645450.2229@fbirervta.pbzchgretzou.qr> <47FCD47A.7060600@trash.net> <alpine.LNX.1.10.0804091639210.3866@fbirervta.pbzchgretzou.qr> <47FCDAE5.5050409@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Greg Scott <GregScott@InfraSupportEtc.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51046 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbYDIQLO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:11:14 -0400
In-Reply-To: <47FCDAE5.5050409@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-04-09 17:04, Patrick McHardy wrote:
>> 
>>  - arpreply engine
>
> A pure bridge doesn't need ARP. I don't get your point,
> but my suggestion might not make much sense, I haven't
> really thought about this.

Well maybe you don't want to use a bridge for simplicity
but still do proxy arp for lots of addresses.

>>  - filtering on L2
>> 
>> there has been a L2-hooks back in the 2.4 days (at least the context
>> looks like it), and given that the ebtables targets now use
>> xtables, the l2hooks patch would actually be real easy.
>
> They were used for the kernel ct_sync implementation. Why
> would you use them for briding, it has its own hooks?
>
If you wanted to filter out non-(arp,ipv4,ipv6) traffic,
you have to set up a bridge and filter it there, as I see it.
So L2 hooks would come in handy since you would not need
to set up a bridge device anymore to do so.
