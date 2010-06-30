From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Accessing packet marking functions
Date: Wed, 30 Jun 2010 08:15:42 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006300815280.30439@obet.zrqbmnf.qr>
References: <1276965739.1476.35.camel@andybev>  <alpine.LSU.2.01.1006192200300.21809@obet.zrqbmnf.qr>  <1277846567.1561.21.camel@andybev>  <AANLkTimPhd8UTiZiQTTYkMxWOZiFD5jK2iYyzhM9U2d4@mail.gmail.com> <1277878469.1561.25.camel@andybev>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Andrew Beverley <andy@andybev.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44095 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab0F3GPn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jun 2010 02:15:43 -0400
In-Reply-To: <1277878469.1561.25.camel@andybev>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-06-30 08:14, Andrew Beverley wrote:
>
>On Tue, 2010-06-29 at 14:35 -0700, Maciej =C5=BBenczykowski wrote:
>> That retrieves the socket mark, not the packet mark.
>> The packet mark on outgoing packets gets initialized to the socket m=
ark...
>
>Hmmm, I understand. So is there any way to retrieve a packet's mark as
>opposed to a socket's mark?

And how would you do that with SOCK_STREAM anyway?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
