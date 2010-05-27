From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: Help: Cycle through iptables rules
Date: Thu, 27 May 2010 12:35:51 +0200
Message-ID: <AANLkTimdS2i0kPEZZRirMQu7JTUQeL65gH2wSrVkbtc5@mail.gmail.com>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>
	<1274861468.2672.9.camel@edumazet-laptop>
	<alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
	<AANLkTilFXTT5kKPCTD7Re8Xzeg6UoKlDUJJvWPCGJXRd@mail.gmail.com>
	<alpine.LSU.2.01.1005262215010.30857@obet.zrqbmnf.qr>
	<1274905649.2542.1.camel@edumazet-laptop>
	<AANLkTil_CCT7f8-Ih6v55tSf96gRtnRqs_lSuF07AyR4@mail.gmail.com>
	<1274956488.2523.0.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Felipe W Damasio <felipewd@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f176.google.com ([209.85.222.176]:63755 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934044Ab0E0Kfy convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 May 2010 06:35:54 -0400
Received: by pzk6 with SMTP id 6so3314108pzk.1
        for <netfilter-devel@vger.kernel.org>; Thu, 27 May 2010 03:35:53 -0700 (PDT)
In-Reply-To: <1274956488.2523.0.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yeah, I should learn to read through the entire thread before replying =
;-)

2010/5/27 Eric Dumazet <eric.dumazet@gmail.com>:
> Le jeudi 27 mai 2010 =C3=A0 12:30 +0200, Maciej =C5=BBenczykowski a =C3=
=A9crit :
>> > not exactly :)
>> >
>> > It should be --mode nth --every N-I --packet I
>> >
>> > (first rule consume one packet out of 48, then second rule consume=
 one
>> > packet out of 47, ...
>>
>> I thought -j CONNMARK wasn't terminal?
>
> That what Jan said 12 hours ago :)
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
