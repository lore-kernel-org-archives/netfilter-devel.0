From: Harald Welte <laforge@netfilter.org>
Subject: Re: patch for ulogd pgsql output plugin
Date: Sun, 10 Apr 2005 23:02:03 +0200
Message-ID: <20050410210203.GA9155@sunbeam.de.gnumonks.org>
References: <425655C0.1080903@entri.com.ua>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RqQx4rfNhO01Vpv5"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andrew Kozachenko <andrew@entri.com.ua>
Content-Disposition: inline
In-Reply-To: <425655C0.1080903@entri.com.ua>
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


--RqQx4rfNhO01Vpv5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 08, 2005 at 12:58:24PM +0300, Andrew Kozachenko wrote:
> Bug in pgsql/ulogd_PGSQL.c causes ifinite loop on ulogd-1.21 startup.
> Here is the fix.

thanks, already fixed in subversion some time ago.  ulogd-1.22 (March 7)
also contains the fix.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--RqQx4rfNhO01Vpv5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCWZRLXaXGVTD0i/8RAqsmAJ94VG66x5N5YT3qdwkwTEEIlxSmNACfYN+Y
up8Dtvj7N+OfMWtL0VdK4Uc=
=iClI
-----END PGP SIGNATURE-----

--RqQx4rfNhO01Vpv5--
