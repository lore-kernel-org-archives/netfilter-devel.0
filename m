From: Harald Welte <laforge@netfilter.org>
Subject: Re: ip_conntrack_pptp control connection direction limitation
Date: Wed, 21 Jul 2004 16:54:42 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040721205442.GP27487@obroa-skai.de.gnumonks.org>
References: <E8A43220CB34D811A81D00508BB9C7DF028721D2@TPMS1>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vJI8q/aziP9idhqk"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "LIGHT.LU ?f?P??" <LIGHT.LU@delta.com.tw>
Content-Disposition: inline
In-Reply-To: <E8A43220CB34D811A81D00508BB9C7DF028721D2@TPMS1>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--vJI8q/aziP9idhqk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 23, 2004 at 11:24:35AM +0800, LIGHT.LU ?f?P?? wrote:
> Hello,
>=20
> =20
>=20
> As the code comment of ip_conntrack_pptp.c Version 1.9 said that the
> direction of control connection is limited to PNS->PAC.  Is there any plan
> to conquer this limitation?  Or any one can describe the difficulties to
> remove it.  Any other information is worthy being noticed?

No, there are no particular difficulties.  It just needs a lot more
abstraction and some more state to be kept.  Patches always welcome, in
case somebody implements it.

> Light lu

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--vJI8q/aziP9idhqk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA/tgRXaXGVTD0i/8RAtpoAJ9wVzZPB4WO9bYPQckQ1z0o5t8jxACfQ+3Z
lznuwKv4/DPVCXfKQcRk7dk=
=E9Sj
-----END PGP SIGNATURE-----

--vJI8q/aziP9idhqk--
