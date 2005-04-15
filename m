From: Harald Welte <laforge@netfilter.org>
Subject: Re: [patch] fix ACCOUNT locking
Date: Fri, 15 Apr 2005 17:54:30 +0200
Message-ID: <20050415155430.GG25433@sunbeam.de.gnumonks.org>
References: <200504151024.28858.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O4VoXDY02cEAFJWy"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <200504151024.28858.thomas.jarosch@intra2net.com>
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


--O4VoXDY02cEAFJWy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 15, 2005 at 10:24:28AM +0200, Thomas Jarosch wrote:
> Hi,
>=20
> attached is a patch to fix ipt_ACCOUNT locking. ipt_ACCOUNT now works fin=
ally=20
> for large networks without trouble.

somehow I was neither able to apply this patch to what we had in
patch-o-matic-ng, nor incremental to your last email from April 05.

> The full version can be found here:
> http://www.intra2net.com/opensource/ipt_account/

I've downloaded the latest version from there and merged it into
patch-o-matic.

> Cheers,
> Thomas
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--O4VoXDY02cEAFJWy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCX+O2XaXGVTD0i/8RAuLjAJ44cerMajbPglf+livmDoPSYlEJiwCfUmub
JF5X7E2041qJZd553405Q1w=
=ifn+
-----END PGP SIGNATURE-----

--O4VoXDY02cEAFJWy--
