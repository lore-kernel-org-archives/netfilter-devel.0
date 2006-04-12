From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 4/4] fix the path to detect esp/connbytes support in
	kernel
Date: Wed, 12 Apr 2006 10:59:26 +0200
Message-ID: <20060412085926.GR31616@sunbeam.de.gnumonks.org>
References: <200604071134.k37BYXMq007297@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kPJUzav3owWaKxsz"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200604071134.k37BYXMq007297@toshiba.co.jp>
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


--kPJUzav3owWaKxsz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 07, 2006 at 08:34:32PM +0900, Yasuyuki KOZAKAI wrote:
> [IPTABLES,IP6TABLES]: fix the path to detect esp/connbytes support in ker=
nel
>=20
> The recent kernels don't have ipt_connbytes.c and ip6t_esp.c.

thanks, applied.  Please commit such changes to svn on your own in the
future.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--kPJUzav3owWaKxsz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEPMFuXaXGVTD0i/8RAhbeAJ9glTuC3hKetjjB2TVPVTz0SAyhZwCffLmx
srBOHN66mwAr1wkoYQGLEMU=
=DYSM
-----END PGP SIGNATURE-----

--kPJUzav3owWaKxsz--
