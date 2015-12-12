From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Linux 4.3.1 regression: -m state returns "Protocol wrong type
 for socket"
Date: Sat, 12 Dec 2015 13:04:04 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1512121259340.14295@blackhole.kfki.hu>
References: <n4g4s8$4pr$1@ger.gmane.org> <566BEF33.7090501@gmail.com> <alpine.DEB.2.10.1512121116390.13421@blackhole.kfki.hu> <566C09F5.6080606@gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391812-401793593-1449921844=:14295"
Cc: =?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: =?ISO-8859-15?Q?Remzi_AKY=DCZ?= <linuxliste@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:35570 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbbLLMEI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Dec 2015 07:04:08 -0500
In-Reply-To: <566C09F5.6080606@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391812-401793593-1449921844=:14295
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 12 Dec 2015, Remzi AKY=C3=9CZ wrote:

> "-m state " could not use without protocol. Therefore we must use witch
> -p tcp.

Why should the "state" match be used with protocol? It was never required,=
=20
nowhere described and the match always worked without any other parameters=
=20
in the rule.

Best regards,
Jozsef

> If we have alot of rule we can use additional parameter like as;
>=20
> iptables -A INPUT -p tcp --dport 22 -s 1.2.3.4 -m state --state
> ESTABLISHED,RELATED -j ACCEPT
>=20
> maybe this is better;
>=20
> iptables -A INPUT -p tcp --dport 22 -s 1.2.3.4 -m conntrack --ctstate
> RELATED,ESTABLISHED -j ACCEPT
>=20
> What you need, iptables give it to you. :-)
>=20
> 12-12-2015 12:18 tarihinde Jozsef Kadlecsik yazd?:
> > On Sat, 12 Dec 2015, Remzi AKY=C3=9CZ wrote:
> >
> >> Please use with -p tcp
> >>
> >> iptables -A INPUT -p tcp -m state --state ESTABLISHED,RELATED -j ACCEP=
T
> > That's not a solution at all, this can break a huge number of=20
> > configurations.
> >
> > Best regards,
> > Jozsef=20
> >
> >> 12-12-2015 05:38 tarihinde D=C3=A2niel Fraga yazd?:
> >>> =09After upgrading the kernel from 4.3.0 to 4.3.1 (with the same
> >>> configuration), -m state doesn't work anymore.
> >>>
> >>> iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
> >>>
> >>> =09returns:
> >>>
> >>> iptables: Protocol wrong type for socket.
> >>>
> >>> =09I'm using iptables v1.4.21.
> >>>
> >>> =09Any hints?
> >>>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe netfilter" i=
n
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> > -
> > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> > PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> > Address : Wigner Research Centre for Physics, Hungarian Academy of Scie=
nces
> >           H-1525 Budapest 114, POB. 49, Hungary
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
--110391812-401793593-1449921844=:14295--
