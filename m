From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH NF_CONNTRACK 0/2] fix gcc -Wunder error and revert
	nf_reset
Date: Fri, 5 Aug 2005 14:13:59 +0200
Message-ID: <20050805121359.GB4245@rama.de.gnumonks.org>
References: <200508040829.j748Tdfg011976@toshiba.co.jp>
	<20050804215655.GE4100@rama.de.gnumonks.org>
	<200508050712.j757C0Cj029903@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200508050712.j757C0Cj029903@toshiba.co.jp>
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


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 05, 2005 at 04:11:59PM +0900, Yasuyuki KOZAKAI wrote:
> > Just out of curiosit: 'mainline' refers to what?  the USAGI mainline?
>=20
> No. Linus tree.

yes, I realized.  You mean backport from recent changes in Linus'
mainline.  nevermind ;)

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC81gGXaXGVTD0i/8RAnw6AJ4z6qudG0fKQsQLuSiOeNIEPfmmUwCfbACO
+Z1HejijvtFqJgQbgpVHrsM=
=dTSn
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
