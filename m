From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] p-o-mification of nfnetlink-ctnetlink patch
Date: Sun, 15 Sep 2002 13:33:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020915133348.L3810@sunbeam.de.gnumonks.org>
References: <20020913201706.GE2689@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q935UqjMul3XuJv7"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20020913201706.GE2689@pc.ilinx>; from f292db31bff748d971287c5061481d2e@interlinx.bc.ca on Fri, Sep 13, 2002 at 04:17:06PM -0400
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Q935UqjMul3XuJv7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 13, 2002 at 04:17:06PM -0400, Brian J. Murrell wrote:
> Hi all,
>=20
> I noticed when working on my Amanda conntrack/nat module that the
> nfnetlink-ctnetlink in p-o-m was not quite to p-o-m standards with
> regard to separation of the parts of the patch.  Please find attached
> a patch to p-o-m which "p-o-mifies" the one nfnetlink-ctnetlink patch.

thanks, applied.

> Thanx,
> b.

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

--Q935UqjMul3XuJv7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9hHAcXaXGVTD0i/8RAqtSAJ452wUyHVKLY4PXvIQ8ckmMXn/FggCfaQ99
4kiNzCwj4kfU8DByCMKAHek=
=E641
-----END PGP SIGNATURE-----

--Q935UqjMul3XuJv7--
