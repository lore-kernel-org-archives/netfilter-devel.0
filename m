From: Harald Welte <laforge@netfilter.org>
Subject: Re: SIP NAT conntracking for kernel 2.4.20
Date: Thu, 14 Apr 2005 21:16:16 +0200
Message-ID: <20050414191615.GL25433@sunbeam.de.gnumonks.org>
References: <AEELJIBEDGDFGELIHALGKEGDCAAA.coroberti@bezeqint.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cBogQDtremapRGMG"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Robert Iakobashvili <coroberti@bezeqint.net>
Content-Disposition: inline
In-Reply-To: <AEELJIBEDGDFGELIHALGKEGDCAAA.coroberti@bezeqint.net>
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


--cBogQDtremapRGMG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 14, 2005 at 09:18:40PM +0200, Robert Iakobashvili wrote:
> Hi Herald and Jozsef,
>=20
> The SIP NAT conntracking patch for kernel 2.4.10 cutted from
> Lynksys and posted earlier:
> http://lists.netfilter.org/pipermail/netfilter-devel/2005-January/018252.=
htm
> l
>=20
> is used by people, addressing to me their questions.
>=20
> Is it worth adding to POM-ng?

It is not licensed under GNU GPL, and we therefore cannot accept it as
contribution.

The header states 'All rights reserved' without any notice about the
rights it grants the users under which license.

In fact, strictly speaking this might be a gpl violation, since I
consider conntrack helpers as derivative work of netfilter/iptables.

Since I'm already in negotiations with Linksys/Cisco in a different
case, I'll try to add this to the list of topics that need to be
discussed.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--cBogQDtremapRGMG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCXsF/XaXGVTD0i/8RAkXXAJ4mrJLA0Ju9Cev3iL7xvPiGbONphACfZV2l
7wP5AnLw9ktdgkoJuKC05gM=
=UxnJ
-----END PGP SIGNATURE-----

--cBogQDtremapRGMG--
