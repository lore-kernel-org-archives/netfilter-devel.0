From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH]: fix ipt_REJECT broken UDP crc firewall spotting (phrack 60)
Date: Mon, 6 Jan 2003 13:29:09 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030106122909.GC9467@sunbeam.de.gnumonks.org>
References: <3E188A44.4000606@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OQhbRXNHSL5w/5po"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3E188A44.4000606@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--OQhbRXNHSL5w/5po
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 05, 2003 at 08:40:52PM +0100, Patrick McHardy wrote:
> Hi.
>=20
> ipt_REJECT sends unreachables in response to UDP packets with invalid=20
> checksums, thereby exposing the
> existance of a firewall  (as described in phrack #60, "broken crc=20
> firewall spotting" (or something like this), www.phrack.com).

Thanks for fixing this issue.  I will put your patch into the 'pending'
queue of patch-o-matic.

> Regards,
> Patrick
--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--OQhbRXNHSL5w/5po
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+GXaVXaXGVTD0i/8RAsGSAKClsioUPM2Q5QHKjL2sZgPbZlfq3wCgpuY6
jezddxvRIaycb/BKd+71e2U=
=i55o
-----END PGP SIGNATURE-----

--OQhbRXNHSL5w/5po--
