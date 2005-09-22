From: Harald Welte <laforge@netfilter.org>
Subject: Re: tcp-window-tracking patch problem!
Date: Thu, 22 Sep 2005 14:37:09 +0200
Message-ID: <20050922123709.GF26520@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uwl7UQhJk99r8jnw"
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: wei shuxi <shuxi_w@seu.edu.cn>
Content-Disposition: inline
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


--Uwl7UQhJk99r8jnw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 21, 2005 at 01:57:43PM +0800, wei shuxi wrote:
> Hi,
>  I failed to apply tcp-window-tracking patch as well as the nf-log patch.
> my kernel is 2.4.20-8 and the patch is 20050913.
>=20
> I have read the nf-log patch file, it seems to be for kernel 2.4.31.

we do not support new features for kernels that are multiple years old,  so=
rry :(

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Uwl7UQhJk99r8jnw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDMqV1XaXGVTD0i/8RAtYLAJ9DYGKuRdm7i9QyvdxcDkj4iT6uhACgsfsI
hQ+bv8GFOSN5aHoMrNDMj0I=
=J/0g
-----END PGP SIGNATURE-----

--Uwl7UQhJk99r8jnw--
