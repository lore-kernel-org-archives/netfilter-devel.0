From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] fix unclean udp checksum check
Date: Thu, 12 Sep 2002 09:13:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020912091352.J3810@sunbeam.de.gnumonks.org>
References: <20020910143343.GA22297@morinfr.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BNd1cQq+8a6XQVk/"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20020910143343.GA22297@morinfr.org>; from guillaume@morinfr.org on Tue, Sep 10, 2002 at 04:33:43PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--BNd1cQq+8a6XQVk/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 10, 2002 at 04:33:43PM +0200, Guillaume Morin wrote:
> Hi folk,
>=20
> unclean does not handle udp packets with a null checksum, altough udp
> checksums are not mandatory.

thanks, fix is now in patch-o-matic (I'm going to submit it to davem soon)

> Guillaume Morin <guillaume@morinfr.org>

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+=
=20
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)

--BNd1cQq+8a6XQVk/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9gD6wXaXGVTD0i/8RAjmGAJ9q9Fe9wb60ewgoo/EBH6TOvI6RtACcCNNh
8b1P8VWh4ddzWenAzwj36o4=
=7wUl
-----END PGP SIGNATURE-----

--BNd1cQq+8a6XQVk/--
