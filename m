From: Harald Welte <laforge@netfilter.org>
Subject: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's brain broke!)
Date: Sun, 11 Jan 2004 14:01:14 +0100
Sender: linux-net-owner@vger.kernel.org
Message-ID: <20040111130114.GJ20706@sunbeam.de.gnumonks.org>
References: <20030725173900.E6E952C2AE@lists.samba.org> <200307251756.VAA12609@dub.inr.ac.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pMCBjikF2xGw87uL"
Cc: Rusty Russell <rusty@rustcorp.com.au>, fenio@o2.pl,
	davem@redhat.com, linux-net@vger.kernel.org, kaber@trash.net,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>, boris@boris.ca,
	email@cs-ware.de, Jan.Schubert@GMX.li
Return-path: <linux-net-owner@vger.kernel.org>
To: kuznet@ms2.inr.ac.ru
Content-Disposition: inline
In-Reply-To: <200307251756.VAA12609@dub.inr.ac.ru>
List-Id: netfilter-devel.vger.kernel.org


--pMCBjikF2xGw87uL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2003 at 09:56:57PM +0400, kuznet@ms2.inr.ac.ru wrote:

> Hello!

Hi Alexey,  I have to follow-up on this old thraed.

> > Hmm, what's your routing setup?  And what kernel?  It's possible with
> > wierd setups, like source routing.
>=20
> Unlikely, source address is unspecified here. Most likely, it is fwmark.
>=20
> Unrelated: giving out->ifindex is a bug, by the way. It can screw up
> the things a lot. In this context, if you want to be sure that packet
> will go out expected interface you do plain lookup and drop packet
> if it gave you some strange route.

Your proposed change (key.oif =3D 0 instead of out->ifindex) went into
2.4.23, and we've received a number of bug reports like
https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=3D144
http://www.ussg.iu.edu/hypermail/linux/kernel/0312.0/0465.html
http://www.ussg.iu.edu/hypermail/linux/kernel/0312.0/0408.html

This means that ip_route_output_key() returns a route with a different
outgoing interface than the skb->dst->dev of our to-be-masqueraded
packet. =20

Why was it wrong to specify skb->dst->dev->ifindex of the previous
'real' routing decision as key to our current routing decision?

As an example case where I would suspect problems: The packet could be
coming from a local socket, and the socket be bound to a specific
interface (sk->bound_dev_if).

Please comment, thanks.

> Alexey

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--pMCBjikF2xGw87uL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAAUkaXaXGVTD0i/8RAsYUAJ9uv52uqyRqXCciWgEWgmcu5KKmIgCgh2EX
1vVTzro+RT284keszNST/xI=
=zJRE
-----END PGP SIGNATURE-----

--pMCBjikF2xGw87uL--
