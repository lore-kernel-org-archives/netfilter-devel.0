From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Comments about IPT_ALIGN
Date: Fri, 31 Jan 2003 12:57:58 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030131115758.GX9073@naboo.cybercafe42>
References: <3E335CB1.9070101@hipac.org> <20030126120159.A3045@linux.karinthy.hu> <3E33C665.9080106@fugmann.dhs.org> <20030126152227.A6811@linux.karinthy.hu> <3E342355.1030707@hipac.org> <20030126204358.B9418@linux.karinthy.hu> <3E346A9A.5020305@hipac.org> <20030127014304.A10076@linux.karinthy.hu> <3E350B13.8010502@hipac.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5tINJiUS2/Dn5Rhr"
Cc: Laszlo Valko <valko@linux.karinthy.hu>,
	Anders Fugmann <afu@fugmann.dhs.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Heinz <creatix@hipac.org>
Content-Disposition: inline
In-Reply-To: <3E350B13.8010502@hipac.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--5tINJiUS2/Dn5Rhr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2003 at 11:33:55AM +0100, Thomas Heinz wrote:
> 2) Define the kernel-user communication in terms of a network protocol
>    (anyway, I guess this will be the case if netfilter communication is
>    converted to netlink).

No, not really. The matchinfo / targetinfo structures are just passed
through as opaque data objects, the iptnetlink/pkttnetlink layer doesn't
look inside at all.

> Regards,
> Thomas

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

--5tINJiUS2/Dn5Rhr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+OmTGXaXGVTD0i/8RAglTAJwLwKFPzwjK1fpUGXJskirETMRuYwCgjOti
MnNXziWe+QzEhiQOHtdRUa0=
=qgp8
-----END PGP SIGNATURE-----

--5tINJiUS2/Dn5Rhr--
