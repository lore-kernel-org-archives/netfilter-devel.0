From: Harald Welte <laforge@netfilter.org>
Subject: Re: BUG: iptables -j does not work for chains with a length >=28
	(was moe infos...)
Date: Thu, 17 Nov 2005 13:50:56 +0100
Message-ID: <20051117125056.GB14201@sunbeam.de.gnumonks.org>
References: <200511150139.51688.bernd@zeimetz.de>
	<200511151715.32138.bernd@zeimetz.de>
	<437A1F13.5080305@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+pHx0qQiF2pBVqBT"
Cc: Bernd Zeimetz <bernd@zeimetz.de>, 327007@bugs.debian.org,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <437A1F13.5080305@eurodev.net>
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


--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 15, 2005 at 06:46:59PM +0100, Pablo Neira wrote:

> The patch attached fixes the problem that you're reporting here. I tried
> with the shell script attached and seems to work fine. I'll pass it to
> Harald.

already found it.  looks fine, I'll apply it to svn.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--+pHx0qQiF2pBVqBT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDfHywXaXGVTD0i/8RAgSkAJ9vLUa9J8O4rYcmAeLTFN8dQiaqjQCfXTMm
yG6Ra+h5gDwxKLQNZRnVVzY=
=44AF
-----END PGP SIGNATURE-----

--+pHx0qQiF2pBVqBT--
