From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Help: Cycle through iptables rules
Date: Thu, 27 May 2010 06:03:17 +0200
Message-ID: <1274932997.2542.18.camel@edumazet-laptop>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>
	 <1274861468.2672.9.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
	 <AANLkTilFXTT5kKPCTD7Re8Xzeg6UoKlDUJJvWPCGJXRd@mail.gmail.com>
	 <alpine.LSU.2.01.1005262215010.30857@obet.zrqbmnf.qr>
	 <1274905649.2542.1.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1005270008520.30857@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Felipe W Damasio <felipewd@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54955 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab0E0EDX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 May 2010 00:03:23 -0400
Received: by wyb29 with SMTP id 29so3817630wyb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 26 May 2010 21:03:21 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.01.1005270008520.30857@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 27 mai 2010 =C3=A0 00:09 +0200, Jan Engelhardt a =C3=A9crit :
> On Wednesday 2010-05-26 22:27, Eric Dumazet wrote:
> >> >
> >> >  So we create 48 rules using this setup?
> >>=20
> >> Since there are two loops to be done, it would be 96 rules in tota=
l.
> >>=20
> >> >  I can see why it'll work on the first 48 packets (one for each
> >> >rule), but what happens on the 49th new connection? It'll go on t=
he
> >> >first rule again?
> >>=20
> >> nth uses modulus, otherwise you can't get the "every Nth" semantic=
=2E :-)
> >>=20
> >> (It should have been: --mode nth --every N --packet I)
> >
> >not exactly :)
> >
> >It should be --mode nth --every N-I --packet I
> >
> >(first rule consume one packet out of 48, then second rule consume o=
ne
> >packet out of 47, ...
>=20
> The second rule still consumes 48 packets, because CONNMARK is
> non-terminating. Thus it's --every N.

Ouch, you are right, but this is very expensive then...



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
