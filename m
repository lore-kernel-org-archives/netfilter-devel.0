From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] small optimization in __ip_conntrack_find()
Date: Tue, 11 Jun 2002 09:51:35 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020611095135.F11177@sunbeam.de.gnumonks.org>
References: <1023490707.19838.14.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/aVve/J9H4Wl5yVO"
Cc: Netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1023490707.19838.14.camel@tux>; from gandalf@wlug.westbo.se on Sat, Jun 08, 2002 at 01:00:59AM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--/aVve/J9H4Wl5yVO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 08, 2002 at 01:00:59AM +0200, Martin Josefsson wrote:
> Hi,
>=20
> Attached is a small optimization for __ip_conntrack_find().
> The way I read the use of the LIST_FIND macro it seems that we are
> calling hash_conntrack() for each iteration with the same inparameters.

Thanks.  My assumption was that this is actually done by the optimization
code of gcc.  But from looking at the disassembled compiler output, there
is actually quite a difference between the old and the new code.

> My change calls it once before looping.

i'll put this into pending.

> /Martin


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

--/aVve/J9H4Wl5yVO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9BawHXaXGVTD0i/8RAhK0AJ4jCUd4ygO8tYuM8/BJ0YS10q0cRQCgjlaN
mduTpMoTXL4wVf2Ft1GPb1Q=
=cE29
-----END PGP SIGNATURE-----

--/aVve/J9H4Wl5yVO--
