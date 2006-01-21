From: Harald Welte <laforge@netfilter.org>
Subject: Re: libnetfilter_conntrack and port of router
Date: Sat, 21 Jan 2006 15:39:14 +0100
Message-ID: <20060121143914.GW4603@sunbeam.de.gnumonks.org>
References: <200601091230.55167.develop@tstd.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3lEnBJ3eT4fJ0mBo"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tomasz =?iso-8859-1?Q?Pr=F3chniak?= <develop@tstd.pl>
Content-Disposition: inline
In-Reply-To: <200601091230.55167.develop@tstd.pl>
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


--3lEnBJ3eT4fJ0mBo
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 09, 2006 at 12:30:55PM +0100, Tomasz Pr=F3chniak wrote:
> Hi
>=20
> First sorry about my English.
>=20
> I have a important (to me) question.
>=20
> I have 2.6.14-5 kernel and libnetfilter_conntrack-0.0.28/ and=20
> libnfnetlink-0.0.13/
>=20
> i do not know how to get info about nat (port and ip, witch it will be se=
en in=20
> net)

you have to look at the original and the reply tupl.

> struct nfct_conntrack {
>         struct nfct_tuple tuple[NFCT_DIR_MAX];

everything is in those two struct nfct_tuple.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--3lEnBJ3eT4fJ0mBo
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD0keSXaXGVTD0i/8RAksrAJkBs2OcxfgSMiL7/eg7VGgDQdEqJgCfXLf9
jVWgewuW5FIQ6Y4dGyDv+Dw=
=nIyV
-----END PGP SIGNATURE-----

--3lEnBJ3eT4fJ0mBo--
