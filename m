From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] x_tables, take 2
Date: Sat, 22 Oct 2005 08:22:20 +0200
Message-ID: <20051022062220.GK27778@sunbeam.de.gnumonks.org>
References: <20051015193249.GA5545@rama.0sec>
	<200510211852.j9LIqgn5012029@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DNkN4mkbZBLvViAv"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200510211852.j9LIqgn5012029@toshiba.co.jp>
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


--DNkN4mkbZBLvViAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 22, 2005 at 03:52:41AM +0900, Yasuyuki KOZAKAI wrote:
>=20
> Hi, Harald,
>=20
> From: Harald Welte <laforge@netfilter.org>
> Date: Sat, 15 Oct 2005 21:32:49 +0200
>=20
> > I've actually managed to get some more unfication done.=20
> >=20
> > There is now no more need to export the xt_mutex[] and xt_tables[] array
> > symbols, one of the main problems that were present with the old 'take =
1'.
> >=20
> > Unification has now also been implemented for layer4 matches such as
> > tcp/udp/dccp/sctp.
>=20
> Great.
>=20
> > This is in no way meant to be applied at this stage.  I just want to get
> > some feedback (and testing).
>=20
> Please apply attached patch to fix holding mutex when registering table.

thanks for sending this fix, but it's already in my tree (maybe I forgot
to commit), I ran into that bug before.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--DNkN4mkbZBLvViAv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDWdqcXaXGVTD0i/8RAqNHAKCcJGT7wjaXtSzaq7xcVitk4E/wWgCeK9XM
rnpmS2ZYJcxodtxsRvBWquU=
=WjZr
-----END PGP SIGNATURE-----

--DNkN4mkbZBLvViAv--
