From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] ROUTE target fixes for 2.6.10+
Date: Tue, 15 Feb 2005 00:15:38 +0100
Message-ID: <20050214231538.GG3829@sunbeam.de.gnumonks.org>
References: <20050210182516.GA3903@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MiFvc8Vo6wRSORdP"
Cc: netfilter-devel@lists.netfilter.org
To: Phil Oester <kernel@linuxace.com>
Content-Disposition: inline
In-Reply-To: <20050210182516.GA3903@linuxace.com>
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


--MiFvc8Vo6wRSORdP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 10, 2005 at 10:25:16AM -0800, Phil Oester wrote:
> Since initialized has been removed, the below is needed for 2.6.10+
> kernels.
>=20
> This fixes bugzilla #284

thanks, committed to the http://svn.netfilter.org/cgi-bin/viewcvs.cgi/branc=
hes/patch-o-matic-ng/linux-2.6.11 tree (Rev 3691)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--MiFvc8Vo6wRSORdP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD4DBQFCETEaXaXGVTD0i/8RAgzDAKCEzumgJiU9tfaEzXnatPU/jN4m7ACYziM3
/T98pZuvVRxfTmq5TMF/bQ==
=pnhN
-----END PGP SIGNATURE-----

--MiFvc8Vo6wRSORdP--
