From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH]  ip6tables support for the CONDITION MATCH
Date: Thu, 5 Dec 2002 21:30:49 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021205203049.GK11068@naboo.club.berlin.ccc.de>
References: <3DD6BA62.2040707@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZQs1kEQY307C4ut"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephane Ouellette <ouellettes@videotron.ca>
Content-Disposition: inline
In-Reply-To: <3DD6BA62.2040707@videotron.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--YZQs1kEQY307C4ut
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 16, 2002 at 04:36:34PM -0500, Stephane Ouellette wrote:
> Harald,
>=20
>   here is a patch to the condition match to support ip6tables.  IPv6=20
> support will be compiled only if selected in the kernel configuration.

sorry, but although this is the most efficient way to implement it
(implement ipv4 and ipv6 part in one module), it confuses users (and
iptables itself).

imagine autoloading.  we always try to load ip6t_condition.o, but in
your case everything is in ipt_condition.o :((

I think you can understand that I cannot accept it this way :((

> Regards,
> Stephane Ouellette


--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--YZQs1kEQY307C4ut
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE977d5XaXGVTD0i/8RAtJCAKCravIEV8TR4bjCN+WnkPeyTFv/XgCeKaNt
MlEjpPUnTeXjc/pDXtY9YJ0=
=J/Be
-----END PGP SIGNATURE-----

--YZQs1kEQY307C4ut--
