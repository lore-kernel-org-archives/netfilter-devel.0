From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: problem with flowi structure
Date: Thu, 16 Sep 2010 17:26:08 +0200
Message-ID: <1284650768.3352.37.camel@edumazet-laptop>
References: <AANLkTi=bGsvMqnTSanA73FhDH_DashmXTcA1sddtj0P6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	netdev@vger.kernel.org
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=bGsvMqnTSanA73FhDH_DashmXTcA1sddtj0P6@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Le jeudi 16 septembre 2010 =C3=A0 17:14 +0200, Nicola Padovano a =C3=A9=
crit :
> Hi all. I'm "studying" the flowi structure.
> I see some source code:
>=20
> [CODE]
> ...
> fl.nl_u.ip4_u.saddr =3D 0
> ...
> ip_route_output_key(....,&fl,....)
> ...
> (where fl is a flowi struct)
> [/CODE]
>=20
> what is the meaning of saddr =3D 0?
>=20
>=20

This means ip_route_output_key() is allowed to chose whatever source ip
address to reach remote peer.



