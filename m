From: Harald Welte <laforge@netfilter.org>
Subject: Re: extensions manpage, howto etc
Date: Wed, 21 Jan 2004 17:02:07 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040121220207.GD1810@obroa-skai.de.gnumonks.org>
References: <20040120130122.GC8642@obroa-skai.de.gnumonks.org> <Pine.LNX.4.44.0401210105020.29594-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CNfT9TXqV7nd4cfk"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <henrik@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0401210105020.29594-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--CNfT9TXqV7nd4cfk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 21, 2004 at 01:17:42AM +0100, Henrik Nordstrom wrote:
> On Tue, 20 Jan 2004, Harald Welte wrote:
>=20
> > However, if somebody wants to take the full job of=20
> > - adding the respective information to the sourcecode
> > - generating the respective manpage snippets
>=20
> These two can relatively easily be done as the man page should essentially
> be a superset of the terse extension help and requires very little markup,
> and having them unified would help greatly in ensuring the reference
> documentation is kept up to date with the extension it documents.
>=20
> > - generating netfilter-extension-HOWTO snippets in docbook XML
>=20
> This I do not think is wise to have derived from the extension source for
> the reasons outlined before. The person writing the HOWTO class material
> is most likely not the same as the extension maintainer as it requires
> somewhat different skills in writing the extension and a howto on how it
> is used (not only syntax), and there is also the question about
> translation.
>=20
> The HOWTO class material is in my opinion better maintained as a separate
> document preferably maintained by a non-programmer with close user
> contact, and should stay on the HOWTO level of things not dive into all
> details about exact syntax etc like the reference man page.

Yes, I agree (in parts).  But still, the HOWTO should include an
auto-generated snippet of the reference, too.

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

--CNfT9TXqV7nd4cfk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFADvbfXaXGVTD0i/8RAofiAJ9DxygPyeyNZWGlmt57C3YXMHg/4QCfbb6Y
lYTBvu9JlDjJtyxg6hZP3LI=
=AShx
-----END PGP SIGNATURE-----

--CNfT9TXqV7nd4cfk--
