From: Eric Leblond <eric@inl.fr>
Subject: Re: Fwd: TCP ack in libnetfilter_queue
Date: Mon, 27 Sep 2010 09:41:17 +0200
Message-ID: <1285573277.21274.190.camel@khasse.inl.fr>
References: <AANLkTimxj_yVspgWQB2tHF+=ZGvEh1sdga+RdnD_t_SQ@mail.gmail.com>
	 <AANLkTi=X0E3keLqnedFG7_BWim3fJvqU+O2RaFUv1+MT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JrV2ot+iTEviMfNYHgxQ"
Cc: netfilter-devel@vger.kernel.org
To: Mistick Levi <gmistick@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:35773 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744Ab0I0Hku (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Sep 2010 03:40:50 -0400
In-Reply-To: <AANLkTi=X0E3keLqnedFG7_BWim3fJvqU+O2RaFUv1+MT@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-JrV2ot+iTEviMfNYHgxQ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Le dimanche 26 septembre 2010 =C3=A0 07:53 +0200, Mistick Levi a =C3=A9crit=
 :
> Hi,
> did'nt get any reply on the users list.... Hope anyone here could help ou=
t.
>=20
>=20
> ---------- Forwarded message ----------
> From: Mistick Levi <gmistick@gmail.com>
> Date: Thu, Sep 23, 2010 at 4:12 PM
> Subject: TCP ack in libnetfilter_queue
> To: netfilter@vger.kernel.org
>=20
>=20
> Hey,
>=20
> i wrote a filter using libnetfilter_queue api, and i want to send
> messages to the queue in a specific way...
> I want to get the first packet after the TCP 3-way-handshak is
> finished ( meaning - only data!)..
>=20
> i tried using conntrack with "ESTABLISHED" status, but then i start
> getting messages to the queue from the last message of the
> handshake... ( meaning the last ack )... and i dont want that since it
> contain no data....

What about filtering on PSH, something like:
	iptables XXXXX --tcp-flags PSH, PSH -j NFQUEUE
Not really strict but it should work in most case.
Or you can work on packet length, if it has data it is bigger:
 	iptables XXXXX --length 60:1500 -j NFQUEUE

BR,
--=20
=C3=89ric Leblond <eric@inl.fr>
EdenWall, http://www.edenwall.com/
NuFW, http://www.nufw.org

--=-JrV2ot+iTEviMfNYHgxQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkygSpoACgkQnxA7CdMWjzISHACfWBqLj0JXOBUxJJWvgTLvbb+C
KcsAoIFDxpGYKDyLWFVRcNyVRxvu045L
=5JM9
-----END PGP SIGNATURE-----

--=-JrV2ot+iTEviMfNYHgxQ--

