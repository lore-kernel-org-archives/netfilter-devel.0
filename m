From: Harald Welte <laforge@netfilter.org>
Subject: Re: patch for conntrack expectations
Date: Tue, 17 Feb 2004 22:32:17 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040217213217.GF30968@obroa-skai.de.gnumonks.org>
References: <403014C5.8080102@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NGIwU0kFl1Z1A3An"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <403014C5.8080102@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--NGIwU0kFl1Z1A3An
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 16, 2004 at 01:54:29AM +0100, Pablo Neira wrote:
> Hi harald!
> So I decided to implement the  function:
>=20
> int ip_conntrack_alloc_expect(struct ip_conntrack_expect **new)
>=20
> This function is exported. It's called from the help(...) function when=
=20
> the pattern is found.
> It creates an expectation which will be manipulated by the helper and=20
> which will be inserted by ip_conntrack_expect_related(...).
>=20
> This way we don't need to work with a fake expectation and pass it to=20
> ip_conntrack_expect_related which will copy the information to the real=
=20
> ip_conntrack_expect_related.

This is indeed a true observation and good suggestion.=20

Hoever, I'm not sure whether it would make any measurable difference.
The expect was allocated on the stack [which is cheap], and now we have
one additional (inter-module) function call instead of the allocation of
a couple of bytes on the stack.  I'm not sure which one is really worse.

Also, 2.4.x kernel series are heading for a freeze pretty soon.
So if at all, such a patch would be accepted for 2.6.x.  But then I
would like to ask you to change all the helpers (esp. the ones in
patch-o-matic-ng), too.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--NGIwU0kFl1Z1A3An
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAMohhXaXGVTD0i/8RAo0sAJ0aACxU2/gu3ESavmY4IVQg32TRGQCfcFqG
M+6OZJqryVomJegrSoLSwQk=
=7y6o
-----END PGP SIGNATURE-----

--NGIwU0kFl1Z1A3An--
