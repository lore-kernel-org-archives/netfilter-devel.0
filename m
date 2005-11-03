From: Harald Welte <laforge@netfilter.org>
Subject: Re: Fix compliation of ipt_ROUTE under 2.6.14
Date: Thu, 3 Nov 2005 19:07:36 +0100
Message-ID: <20051103180736.GH905@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.62.0510311729470.2437@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VACxsDaSTfeluoxK"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0510311729470.2437@bizon.gios.gov.pl>
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


--VACxsDaSTfeluoxK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 31, 2005 at 05:33:11PM +0100, Krzysztof Oledzki wrote:
> Hello,
>=20
> Attached (and inlined) patch fixes ipt_ROUTE compliation under 2.6.14.
> There are two version of this patch - one that fixes patchlets/ROUTE/linux
> and second that adds patchlets/ROUTE/linux-2.6.14.

thanks, applied.

Please use a correct "Signed-off-by" line for your future patches,
thanks.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--VACxsDaSTfeluoxK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDalHoXaXGVTD0i/8RAkjfAJ9IczajZJM18whpMOb1sMtx85Qa5gCgh9J5
kf2eAKnxuCXbWnlle/zNnZA=
=2F6T
-----END PGP SIGNATURE-----

--VACxsDaSTfeluoxK--
