From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] realm match inversion fixes
Date: Tue, 15 Feb 2005 00:06:10 +0100
Message-ID: <20050214230610.GD3829@sunbeam.de.gnumonks.org>
References: <20050212223908.GA2960@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a2FkP9tdjPU2nyhF"
Cc: netfilter-devel@lists.netfilter.org
To: Phil Oester <kernel@linuxace.com>
Content-Disposition: inline
In-Reply-To: <20050212223908.GA2960@linuxace.com>
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


--a2FkP9tdjPU2nyhF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 12, 2005 at 02:39:08PM -0800, Phil Oester wrote:
> Below is a combination of Harald's suggested fix for bugzilla
> 297, plus my addition which fixes the case of ! being used
> before the value. =20

thanks, already applied to svn

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--a2FkP9tdjPU2nyhF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCES7iXaXGVTD0i/8RAgt0AJ919SJcTmvHFkudfoahsuaPiVu0UQCfTIN0
p6i26EbH1EegGcfqLExjnrI=
=4nUm
-----END PGP SIGNATURE-----

--a2FkP9tdjPU2nyhF--
