From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 1/2] ipt_hashlimit.c: use hashlist (hlist_head) instead
	of list_head
Date: Tue, 22 Feb 2005 12:36:44 +0100
Message-ID: <20050222113644.GN29256@sunbeam.de.gnumonks.org>
References: <421428D0.8020907@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="djTb5EnuS5qMpC9h"
Cc: netfilter-devel@lists.netfilter.org
To: sjean@cookinglinux.org
Content-Disposition: inline
In-Reply-To: <421428D0.8020907@cookinglinux.org>
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


--djTb5EnuS5qMpC9h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 17, 2005 at 12:17:04AM -0500, Samuel Jean wrote:
> This patch just replaces list_head with hlist_head/node.

thanks, applied to svn and pending for kernel submission (probably only
after 2.6.11 is out, since it is not a bug fix but merely an
optimization)
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--djTb5EnuS5qMpC9h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCGxlMXaXGVTD0i/8RAsRuAJ0T1UAV1pSGxoIRP2+yRZPCduSodACgqaNb
NAXVme0OTRd9SODr9iz9ONw=
=u/rW
-----END PGP SIGNATURE-----

--djTb5EnuS5qMpC9h--
