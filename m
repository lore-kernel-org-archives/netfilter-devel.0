From: Harald Welte <laforge@netfilter.org>
Subject: Future of CONNMARK (was Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's brain broke!)
Date: Sat, 17 Jan 2004 12:09:52 +0100
Sender: linux-net-owner@vger.kernel.org
Message-ID: <20040117110952.GI18505@obroa-skai.de.gnumonks.org>
References: <Pine.LNX.4.58.0401111517550.1161@u.domain.uli> <Pine.LNX.4.44.0401112203250.24615-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dMdWWqg3F2Dv/qfw"
Cc: Julian Anastasov <ja@ssi.bg>, linux-net@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-net-owner@vger.kernel.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0401112203250.24615-100000@filer.marasystems.com>
List-Id: netfilter-devel.vger.kernel.org


--dMdWWqg3F2Dv/qfw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Stripped Cc' list since it is not the original subject]

On Sun, Jan 11, 2004 at 10:11:43PM +0100, Henrik Nordstrom wrote:
> On Sun, 11 Jan 2004, Julian Anastasov wrote:
>=20
> > - use CONNMARK or similar functionality to keep the connection
> > bound to its path. As long as CONNMARK is not a standard feature
> > there is no safe way to use multipath routes with MASQUERADE and
> > SNAT in the latest kernels. Even before this change it was risky
> > to rely on the routing cache to keep NAT connections bound to
> > its path in the multipath route - the cache entries expire.
>=20
> As the aurhor of CONNMARK I certainly do not mind having this progress=20
> beyond path-o-matic extras..

I think we could push CONNMARK to the mainstream kernel in the next
couple of weeks. =20

I'd like to discuss one change with you first... that is using the mark
field as a bitmask.

We had that idea for a very long time, and didn't ever change it for the
skb->nfmark field for the sake of compatibility.

But now, when introducing a new mark field (the conntrack->mark field),
I'd rather prefer implement matching/setting individual bitmasks from
the beginning.  What do you think?  Would you be willing to add that
feature, or alternatively don't mind if I'd add the respective changes
myself?

Also, please add a Copyright notice including your name and a reference
to the GPL on top of the .c files.

Another minor cosmetic issue: Could you please update it to use
C99-style structure initializers in the code?

Last, but not least:  We'd need an etry for the iptables(8) manpage.

Thanks.

> Regards
> Henrik

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--dMdWWqg3F2Dv/qfw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFACRf/XaXGVTD0i/8RAuS7AJ478aZSfhYm3lfDYFSemQoLE07tvgCfUBJB
0oQcaNHuD0NFyAjvXukadx8=
=+i3T
-----END PGP SIGNATURE-----

--dMdWWqg3F2Dv/qfw--
