From: Andrew Beverley <andy@andybev.com>
Subject: Re: Accessing packet marking functions
Date: Sun, 24 Oct 2010 18:30:23 +0100
Message-ID: <1287941423.1550.15.camel@andybev>
References: <1276965739.1476.35.camel@andybev>
	 <alpine.LSU.2.01.1006192200300.21809@obet.zrqbmnf.qr>
	 <1277846567.1561.21.camel@andybev>
	 <AANLkTimPhd8UTiZiQTTYkMxWOZiFD5jK2iYyzhM9U2d4@mail.gmail.com>
	 <1277878469.1561.25.camel@andybev>
	 <alpine.LSU.2.01.1006300815280.30439@obet.zrqbmnf.qr>
	 <1277879533.1561.39.camel@andybev>
	 <alpine.LSU.2.01.1006300844260.2225@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Maciej =?UTF-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from earth.simplelists.com ([89.16.184.171]:43067 "EHLO
	earth.simplelists.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab0JXSDw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 14:03:52 -0400
In-Reply-To: <alpine.LSU.2.01.1006300844260.2225@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> >All I want to do is retain a packet's mark from its arrival into Squid,
> >onto its transmission to the client. Something like this:
> >
> >
> >ppp0 -> PREROUTING -> Squid -> POSTROUTING -> eth0
> >
> >            ^^                      ^^
> >         Set Mark               Read mark
> >
> >If this isn't possible then please tell me.
> 
> Hm, interesting case. I would say you could:
> 
>  - use CONNMARK in PREROUTING/INPUT
>  - use libnetfilter_conntrack to query the connmark from within squid
>    (since squid has address and port, that should identify the 
>    connection within the nfct table)
>  - use the so-obtained ctmark to populate the new socket's skmark

Thanks for this suggestion. Thought I'd drop a quick email (for
completeness) to say that the patch for this has now been included into
Squid. So, it is now possible for Squid to retain the mark on packets
for items that aren't cached, or set a mark on packets when items are
fetched from the cache.

Andy


