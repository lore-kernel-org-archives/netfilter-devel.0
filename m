From: Harald Welte <laforge@netfilter.org>
Subject: Re: match target project
Date: Thu, 19 Aug 2004 13:38:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819113859.GP3921@sunbeam.de.gnumonks.org>
References: <1092154889.4261.436.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rEhM+w5krfX9Wpv9"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
Content-Disposition: inline
In-Reply-To: <1092154889.4261.436.camel@porky>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--rEhM+w5krfX9Wpv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 10, 2004 at 06:21:30PM +0200, Eric Leblond wrote:
> Hi,
>=20
> I was looking for a match that could be able to match one packet per
> connection each N min interval.

It sounds like you're interested in either the dstlimit match (doesn't
use conntrack but it's own hash tables, certainly less accurate.

If you really want to be based on connection as in 'conntrack', you
could base your implementation on top of the counters from the
'conntrack-acct' patch.

> It seems, it does not exist, so the next question is :
> 	Is it possible to develop such a match ?
> 	If yes, is it a huge work ?
>=20
> BR,
> --=20
> Eric Leblond
> Nufw, Now User Filtering Works (http://www.nufw.org)



--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--rEhM+w5krfX9Wpv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBJJFTXaXGVTD0i/8RAss8AJ0SHvLiZck6Vnlud0X3U0NNaAOygACdHqY1
eWz7+kBOK3HA8LFABngRPBk=
=Wg7e
-----END PGP SIGNATURE-----

--rEhM+w5krfX9Wpv9--
