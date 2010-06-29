From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: Accessing packet marking functions
Date: Tue, 29 Jun 2010 14:35:29 -0700
Message-ID: <AANLkTimPhd8UTiZiQTTYkMxWOZiFD5jK2iYyzhM9U2d4@mail.gmail.com>
References: <1276965739.1476.35.camel@andybev>
	<alpine.LSU.2.01.1006192200300.21809@obet.zrqbmnf.qr>
	<1277846567.1561.21.camel@andybev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Andrew Beverley <andy@andybev.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52185 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab0F2WBv convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 18:01:51 -0400
Received: by pvc7 with SMTP id 7so71869pvc.19
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Jun 2010 15:01:50 -0700 (PDT)
In-Reply-To: <1277846567.1561.21.camel@andybev>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

That retrieves the socket mark, not the packet mark.
The packet mark on outgoing packets gets initialized to the socket mark=
=2E..

On Tue, Jun 29, 2010 at 14:22, Andrew Beverley <andy@andybev.com> wrote=
:
>> >I am considering patching Squid proxy so that it retains a packet's=
 mark
>> >value if it could not be fetched from the cache. Squid already has
>> >similar functionality for the TOS field, but I would like to extend=
 this
>> >to netfilter's mark feature.
>> >
>> >Can somebody point me in the right direction for the correct way of
>> >setting and accessing the mark value of a packet? The TOS feature i=
n
>> >Squid uses setsockopt(). Is there an equivalent for mark? Should I =
be
>> >using libnetfilter_queue?
>>
>> setsockopt(fd, SOL_SOCKET, SO_MARK, ...)
>
> Thanks for the help so far. To retrieve the mark should I just be usi=
ng:
>
> getsockopt(fd, SOL_SOCKET, SO_MARK, ...) ?
>
> I keep getting a mark of 0 despite setting a mark in PREROUTING. My c=
ode
> is as follows:
>
> int mark =3D 0;
> int marklen =3D sizeof(mark);
> getsockopt(newsocket, SOL_SOCKET, SO_MARK, &mark, &marklen);
>
>
>
> Thanks,
>
> Andy
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
