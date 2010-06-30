From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Accessing packet marking functions
Date: Wed, 30 Jun 2010 08:47:13 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006300844260.2225@obet.zrqbmnf.qr>
References: <1276965739.1476.35.camel@andybev>  <alpine.LSU.2.01.1006192200300.21809@obet.zrqbmnf.qr>  <1277846567.1561.21.camel@andybev>  <AANLkTimPhd8UTiZiQTTYkMxWOZiFD5jK2iYyzhM9U2d4@mail.gmail.com>  <1277878469.1561.25.camel@andybev>
 <alpine.LSU.2.01.1006300815280.30439@obet.zrqbmnf.qr> <1277879533.1561.39.camel@andybev>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Andrew Beverley <andy@andybev.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46365 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521Ab0F3GrO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jun 2010 02:47:14 -0400
In-Reply-To: <1277879533.1561.39.camel@andybev>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-06-30 08:32, Andrew Beverley wrote:
>> >> That retrieves the socket mark, not the packet mark.
>> >> The packet mark on outgoing packets gets initialized to the socket mark...
>> >
>> >Hmmm, I understand. So is there any way to retrieve a packet's mark as
>> >opposed to a socket's mark?
>> 
>> And how would you do that with SOCK_STREAM anyway?
>
>I don't know. I'll admit that I don't fully understand what I'm doing
>here, which I apologise for, but I'm trying to learn.
>
>All I want to do is retain a packet's mark from its arrival into Squid,
>onto its transmission to the client. Something like this:
>
>
>ppp0 -> PREROUTING -> Squid -> POSTROUTING -> eth0
>
>            ^^                      ^^
>         Set Mark               Read mark
>
>If this isn't possible then please tell me.

Hm, interesting case. I would say you could:

 - use CONNMARK in PREROUTING/INPUT
 - use libnetfilter_conntrack to query the connmark from within squid
   (since squid has address and port, that should identify the 
   connection within the nfct table)
 - use the so-obtained ctmark to populate the new socket's skmark
