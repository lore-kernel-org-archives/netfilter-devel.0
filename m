From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [Fwd: Bug fixed]
Date: Tue, 11 Jun 2002 10:21:31 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020611102131.I11177@sunbeam.de.gnumonks.org>
References: <1023699042.19837.77.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LYw3s/afESlflPpp"
Cc: Netfilter-devel <netfilter-devel@lists.samba.org>,
	zhongyu <zhongyu@ecfounder.com>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1023699042.19837.77.camel@tux>; from gandalf@wlug.westbo.se on Mon, Jun 10, 2002 at 10:50:42AM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--LYw3s/afESlflPpp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> From: zhongyu <zhongyu@ecfounder.com>
> To: netfilter@lists.samba.org
> Subject: Bug fixed
> Date: 10 Jun 2002 16:23:34 +0800
>=20
> Fix iptable_nat's memory leak problem.

ouch. thanks. How can something as obvious as this bug survive for that=20
long time?

I'll pass this on for kernel inclusion immediately.

Could you tell us your real name for the scoreboard? thanks.

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

--LYw3s/afESlflPpp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9BbMKXaXGVTD0i/8RAgXJAJsGfTOLzw5ctx5v3CR1DrUg1rexNQCdEAO8
+i0ZLBEUm+oNC/+HrYx2fDY=
=asC1
-----END PGP SIGNATURE-----

--LYw3s/afESlflPpp--
