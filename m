From: Harald Welte <laforge@netfilter.org>
Subject: Re: Linux 2.6.9-rc1
Date: Thu, 26 Aug 2004 10:02:03 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040826080203.GZ5824@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.58.0408240031560.17766@ppc970.osdl.org>
	<412CDFEE.1010505@triplehelix.org>
	<20040825203206.GS5824@sunbeam.de.gnumonks.org>
	<20040825164401.12259308.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XbHSybK3LHOYQtWI"
Cc: joshk@triplehelix.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20040825164401.12259308.davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--XbHSybK3LHOYQtWI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 25, 2004 at 04:44:01PM -0700, David S. Miller wrote:
> On Wed, 25 Aug 2004 22:32:06 +0200
> Harald Welte <laforge@netfilter.org> wrote:
>=20
> Harald, a question about this fix.

Sorry about not commenting on this initially.

> So we're converting over to using __ip_nat_find_helper().
>
> And adding an export of ip_nat_find_helper (ie. without the two underscore
> prefix).  Why?
>=20
> If we need to export one, then we need to export both.

yes, we're using __ip_nat_find_helper from within the NAT core (which is
one module built from multiple .o files), and we export ip_nat_find_helper
for other kernel modules, such as helpers and ct_sync (none of it is in
mainline kernel yet).

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--XbHSybK3LHOYQtWI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBLZj7XaXGVTD0i/8RAhpWAJ9vSFw+uTnQ4F5X0CGgSNglH/Jz9gCfVCM5
ZBDuiG9BLwtcbYm5shSVIAI=
=j7xt
-----END PGP SIGNATURE-----

--XbHSybK3LHOYQtWI--
