From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Help: Cycle through iptables rules
Date: Wed, 26 May 2010 22:18:43 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005262215010.30857@obet.zrqbmnf.qr>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com> <1274861468.2672.9.camel@edumazet-laptop> <alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr> <AANLkTilFXTT5kKPCTD7Re8Xzeg6UoKlDUJJvWPCGJXRd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Felipe W Damasio <felipewd@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:34418 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab0EZUSo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 May 2010 16:18:44 -0400
In-Reply-To: <AANLkTilFXTT5kKPCTD7Re8Xzeg6UoKlDUJJvWPCGJXRd@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-05-26 21:01, Felipe W Damasio wrote:
>
>2010/5/26 Jan Engelhardt <jengelh@medozas.de>:
>> -A PREROUTING -m conntrack --ctstate NEW -j extrachain
>> for (I =3D 0; I < N; ++I)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0-A extrachain -m statistic --mode nth --e=
very I \
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-j CONNMARK -=
-set-mark I
>> for (I =3D 0; I < N; ++I)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0-A PREROUTING -m connmark --mark I -j TPR=
OXY \
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0--tproxy-mark=
 I/0xff --on-port I+3127
>
>  You mean do this using:
>
>N=3D48 (or whatever number of http_port we're using)
>
>  So we create 48 rules using this setup?

Since there are two loops to be done, it would be 96 rules in total.

>  I can see why it'll work on the first 48 packets (one for each
>rule), but what happens on the 49th new connection? It'll go on the
>first rule again?

Oh that reminds me of - "The Bible says we're supposed to work six days=
=20
and rest on the seventh. But where is it written that we should start=20
working again on the eighth?"

nth uses modulus, otherwise you can't get the "every Nth" semantic. :-)

(It should have been: --mode nth --every N --packet I)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
