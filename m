From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] ipt_hashlimit.c: avoid data corruption on checkentry
Date: Tue, 22 Feb 2005 12:35:34 +0100
Message-ID: <20050222113534.GM29256@sunbeam.de.gnumonks.org>
References: <42005218.5000401@cookinglinux.org>
	<20050215005255.GS3829@sunbeam.de.gnumonks.org>
	<421174C3.8030705@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EcSFpNr6Vcxykj4g"
Cc: netfilter-devel@lists.netfilter.org
To: sjean@cookinglinux.org
Content-Disposition: inline
In-Reply-To: <421174C3.8030705@cookinglinux.org>
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


--EcSFpNr6Vcxykj4g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 14, 2005 at 11:04:19PM -0500, Samuel Jean wrote:

> Incremental (also untested, but compiles) patch to your is attached.

thanks, applied to svn and pending for kernel submission.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--EcSFpNr6Vcxykj4g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCGxkGXaXGVTD0i/8RAmdFAJwM2kGkKBlTsMRPWwsOZDlYoOB/AQCcCHa/
YtcH82xQaECJpQP48OMDHqU=
=/+hG
-----END PGP SIGNATURE-----

--EcSFpNr6Vcxykj4g--
