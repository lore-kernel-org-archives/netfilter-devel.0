From: Andrew Beverley <andy@andybev.com>
Subject: Re: Accessing packet marking functions
Date: Wed, 30 Jun 2010 07:32:13 +0100
Message-ID: <1277879533.1561.39.camel@andybev>
References: <1276965739.1476.35.camel@andybev>
	 <alpine.LSU.2.01.1006192200300.21809@obet.zrqbmnf.qr>
	 <1277846567.1561.21.camel@andybev>
	 <AANLkTimPhd8UTiZiQTTYkMxWOZiFD5jK2iYyzhM9U2d4@mail.gmail.com>
	 <1277878469.1561.25.camel@andybev>
	 <alpine.LSU.2.01.1006300815280.30439@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Maciej =?UTF-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from earth.simplelists.com ([89.16.184.171]:42655 "EHLO
	earth.simplelists.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab0F3Gc1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jun 2010 02:32:27 -0400
In-Reply-To: <alpine.LSU.2.01.1006300815280.30439@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> >> That retrieves the socket mark, not the packet mark.
> >> The packet mark on outgoing packets gets initialized to the socket mark...
> >
> >Hmmm, I understand. So is there any way to retrieve a packet's mark as
> >opposed to a socket's mark?
> 
> And how would you do that with SOCK_STREAM anyway?

I don't know. I'll admit that I don't fully understand what I'm doing
here, which I apologise for, but I'm trying to learn.

All I want to do is retain a packet's mark from its arrival into Squid,
onto its transmission to the client. Something like this:


ppp0 -> PREROUTING -> Squid -> POSTROUTING -> eth0

            ^^                      ^^
         Set Mark               Read mark


If this isn't possible then please tell me.

Thanks,

Andy


