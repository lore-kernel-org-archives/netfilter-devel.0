From: Harald Welte <laforge@netfilter.org>
Subject: Re: Call for testing: patch-o-matic-ng
Date: Mon, 22 Dec 2003 13:00:47 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031222120047.GK5058@obroa-skai.de.gnumonks.org>
References: <20031221122445.GC5058@obroa-skai.de.gnumonks.org> <1072086985.1031.7.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nywXBoy70X0GaB8B"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
Content-Disposition: inline
In-Reply-To: <1072086985.1031.7.camel@nienna.balabit>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--nywXBoy70X0GaB8B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 22, 2003 at 10:56:26AM +0100, KOVACS Krisztian wrote:
>   I've tried it, and had some problems with it. Namely, the following
> error message (Debian woody and sid, perl 5.6.1 and 5.8.2):
>=20
> hidden@big:~/patch-o-matic-ng$ ./runme=20
> Examining kernel in /usr/src/linux-2.4.22-tproxy113
> Can't bless non-reference value at /usr/share/perl/5.6.1/Term/Cap.pm line=
 136.

thanks, I'll apply your fix.

>  Regards,
>    Krisztian KOVACS

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--nywXBoy70X0GaB8B
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/5tzvXaXGVTD0i/8RAo10AJwLuEZoeK+G7oR0XUjU20+zLCM8lQCfWoxT
IbWUwPRe2sEJzGLjSdoEkvo=
=a4qt
-----END PGP SIGNATURE-----

--nywXBoy70X0GaB8B--
