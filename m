From: Harald Welte <laforge@gnumonks.org>
Subject: Re: re &ip_conntrack_lock not readlocked
Date: Thu, 5 Dec 2002 21:28:07 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021205202807.GJ11068@naboo.club.berlin.ccc.de>
References: <013701c28a2c$ef342000$4200000a@simon>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ofZMSlrAVk9bLeVm"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Simon May <simon@imsl.es>
Content-Disposition: inline
In-Reply-To: <013701c28a2c$ef342000$4200000a@simon>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ofZMSlrAVk9bLeVm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2002 at 10:21:51AM +0100, Simon May wrote:
> I have been seeing the message
> Nov 12 09:58:01 clients kernel: ASSERT: ip_nat_core.c:839 &ip_conntrack_l=
ock
> not readlocked
> in the logs and believe it may be related to

> I'm not sure that it's actually doing any harm but
> can not find much about it.
>=20
> any helpful comments would be apreciated

please read the list archives.  It's a problem in the debug statement,
not the code itself.

> Simon May
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

--ofZMSlrAVk9bLeVm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE977bXXaXGVTD0i/8RAsMHAKCUj+l8M4g7wVmkXBqRfYQMBLCfjQCfdTdk
nWYA5py+fd4Rx9tgaKZvarA=
=cuZg
-----END PGP SIGNATURE-----

--ofZMSlrAVk9bLeVm--
