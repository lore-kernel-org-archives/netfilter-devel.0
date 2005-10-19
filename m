From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] ulogd builddir support
Date: Wed, 19 Oct 2005 12:45:34 +0200
Message-ID: <20051019104534.GX20338@sunbeam.de.gnumonks.org>
References: <4355CDBB.30200@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b/3kIrr+SWblMf9a"
Cc: ulogd@lists.gnumonks.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Content-Disposition: inline
In-Reply-To: <4355CDBB.30200@snapgear.com>
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


--b/3kIrr+SWblMf9a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Philip!

On Wed, Oct 19, 2005 at 02:38:19PM +1000, Philip Craig wrote:
=20
> This patch allows ulogd to be built from a directory that is different
> from the source directory.  In addition to this patch, you will also
> need to run a newer version of autoconf to create a configure that
> supports the builddir variables.

thanks for this patch.  However, I think it is unlikely that I add any
new features to ulogd-1.x, now that ulogd-2.x is already in beta stage
(working, but needs more testing and porting of some more plugins).

Please don't take that personally, and thanks for your efforts.

--=20
- Harald Welte <laforge@gnumonks.org>          	        http://gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)

--b/3kIrr+SWblMf9a
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDViPOXaXGVTD0i/8RAhnGAKCemdNWmxxYTjJMmUaiuK5l1RNeDACeNrmA
ThDq3awGvgww+/WLPAqu+xs=
=sL1O
-----END PGP SIGNATURE-----

--b/3kIrr+SWblMf9a--
