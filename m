From: Harald Welte <laforge@netfilter.org>
Subject: Re: GnomeMeeting STUN
Date: Sat, 3 Jan 2004 17:43:14 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040103164313.GA3483@obroa-skai.de.gnumonks.org>
References: <1072260947.722.25.camel@golgoth01> <20031224143851.GD941@obroa-skai.de.gnumonks.org> <200401022037.24303.lists@ohlmeier.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Cc: Damien Sandras <dsandras@seconix.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nils Ohlmeier <lists@ohlmeier.de>
Content-Disposition: inline
In-Reply-To: <200401022037.24303.lists@ohlmeier.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 02, 2004 at 08:37:24PM +0100, Nils Ohlmeier wrote:

> > So it seems like linux is too advanced for the tricks that STUN tries to
> > do.
>=20
> Yes, STUN works well if you are sitting behind one of these small hardwar=
e=20
> boxes, because the experiences shows that most of them are 'full cone=20
> NAT' (which means an IP port combination on the NAT box accepts pakcets f=
rom=20
> any IP or port combination for this destination and delivers it to the=20
> private destination).
> But with netfilter and if i'm not wrong with the BSD's STUN is no help
> (except that you can detect that you are lost :)

fortunately (or unfortunately, depending on your viewpoint) an
increasing number of those 'small hardware boxes' start to use Linux.
If you buy recent 802.11g AP/router combo's with builtin switch and
sometimes even dsl-modem, they are very likely to run linux.
(linksys,belkin,buffalo, ...)
> To be able to live just with STUN you had to change Netfilter back to
> the more "unsecure"  'full cone NAT' as with ipchains. Which will
> probably rejected by the Netfilter team :)

probably ;)

> Greets
>   Nils

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/9vEhXaXGVTD0i/8RAmWvAJ9r+rBoVZIg/1+KObVuqPsmQp2guQCbBQ4+
54BYvsACLgMSWxWOUsZ3CTs=
=OqSX
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
