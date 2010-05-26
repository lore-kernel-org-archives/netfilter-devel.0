From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Help: Cycle through iptables rules
Date: Wed, 26 May 2010 22:27:29 +0200
Message-ID: <1274905649.2542.1.camel@edumazet-laptop>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>
	 <1274861468.2672.9.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
	 <AANLkTilFXTT5kKPCTD7Re8Xzeg6UoKlDUJJvWPCGJXRd@mail.gmail.com>
	 <alpine.LSU.2.01.1005262215010.30857@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Felipe W Damasio <felipewd@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60956 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab0EZU1i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 May 2010 16:27:38 -0400
Received: by fxm5 with SMTP id 5so4878394fxm.19
        for <netfilter-devel@vger.kernel.org>; Wed, 26 May 2010 13:27:37 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.01.1005262215010.30857@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 26 mai 2010 =C3=A0 22:18 +0200, Jan Engelhardt a =C3=A9crit=
 :
> On Wednesday 2010-05-26 21:01, Felipe W Damasio wrote:
> >
> >2010/5/26 Jan Engelhardt <jengelh@medozas.de>:
> >> -A PREROUTING -m conntrack --ctstate NEW -j extrachain
> >> for (I =3D 0; I < N; ++I)
> >>        -A extrachain -m statistic --mode nth --every I \
> >>                -j CONNMARK --set-mark I
> >> for (I =3D 0; I < N; ++I)
> >>        -A PREROUTING -m connmark --mark I -j TPROXY \
> >>                --tproxy-mark I/0xff --on-port I+3127
> >
> >  You mean do this using:
> >
> >N=3D48 (or whatever number of http_port we're using)
> >
> >  So we create 48 rules using this setup?
>=20
> Since there are two loops to be done, it would be 96 rules in total.
>=20
> >  I can see why it'll work on the first 48 packets (one for each
> >rule), but what happens on the 49th new connection? It'll go on the
> >first rule again?
>=20
> Oh that reminds me of - "The Bible says we're supposed to work six da=
ys=20
> and rest on the seventh. But where is it written that we should start=
=20
> working again on the eighth?"
>=20
> nth uses modulus, otherwise you can't get the "every Nth" semantic. :=
-)
>=20
> (It should have been: --mode nth --every N --packet I)

not exactly :)

It should be --mode nth --every N-I --packet I

(first rule consume one packet out of 48, then second rule consume one
packet out of 47, ...


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
