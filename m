From: Harald Welte <laforge@netfilter.org>
Subject: Re: hashlimit match errors and patches
Date: Mon, 7 Feb 2005 19:37:41 +0100
Message-ID: <20050207183741.GK10011@obroa-skai.de.gnumonks.org>
References: <4203DDC6.6090709@ieee.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KZLWU/9q3evlN4nQ"
Cc: netfilter-devel@lists.netfilter.org
To: Nikolai Malykh <nmalykh@ieee.org>
Content-Disposition: inline
In-Reply-To: <4203DDC6.6090709@ieee.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--KZLWU/9q3evlN4nQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 04, 2005 at 11:40:38PM +0300, Nikolai Malykh wrote:
> 1. Incorrect parameters handling in libipt_hashlimit make impossible to=
=20
> save rule without error because --hashlimit-mode saved as --mode

thanks, applied your patch. =20
Committed revision 3653.

> Patch for this error in attachment
>=20
> 2. Incorrect parameter in jhash_3words() - port numbers not hashed in res=
ult
> 3. Incorrect parameter value in hashlimit_match() - matching packet =3D=
=20
> burst +1 instead burst

Your kernel patches contained other changes than the bugs you mentioned
above.  Please try to separate such changes before submitting a fix.
Thanks.

I'll grab the two hunks that actually fix bugs and hand the result over
to Patrick.

It's good to see hashlimit bugreports and fixes during the last couple
of weeks.  This proves that it has it's applications and people are
actually using it :)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--KZLWU/9q3evlN4nQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFCB7V0XaXGVTD0i/8RAn2iAJ0QQYfCREmWJAxnAUbFR6VaxF9lCACeLOfl
0lFPTK0W86Ts9vREjmeTkjk=
=chIf
-----END PGP SIGNATURE-----

--KZLWU/9q3evlN4nQ--
