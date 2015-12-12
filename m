From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Linux 4.3.1 regression: -m state returns "Protocol wrong type
 for socket"
Date: Sat, 12 Dec 2015 11:18:23 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1512121116390.13421@blackhole.kfki.hu>
References: <n4g4s8$4pr$1@ger.gmane.org> <566BEF33.7090501@gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391812-354420897-1449915503=:13421"
Cc: =?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: =?ISO-8859-15?Q?Remzi_AKY=DCZ?= <linuxliste@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <566BEF33.7090501@gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391812-354420897-1449915503=:13421
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 12 Dec 2015, Remzi AKY=C3=9CZ wrote:

> Please use with -p tcp
>=20
> iptables -A INPUT -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT

That's not a solution at all, this can break a huge number of=20
configurations.

Best regards,
Jozsef=20

> 12-12-2015 05:38 tarihinde D=C3=A2niel Fraga yazd?:
> > =09After upgrading the kernel from 4.3.0 to 4.3.1 (with the same
> > configuration), -m state doesn't work anymore.
> >
> > iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
> >
> > =09returns:
> >
> > iptables: Protocol wrong type for socket.
> >
> > =09I'm using iptables v1.4.21.
> >
> > =09Any hints?
> >
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
--110391812-354420897-1449915503=:13421--
