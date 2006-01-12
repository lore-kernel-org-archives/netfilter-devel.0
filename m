From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] nfsim: Support more netfilter modules
Date: Thu, 12 Jan 2006 12:14:07 +0100
Message-ID: <20060112111407.GS4430@sunbeam.de.gnumonks.org>
References: <439ED1C5.7070103@ingate.com>
	<20060106144048.GE4898@sunbeam.de.gnumonks.org>
	<43C62EA7.5020001@ingate.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4KXkm8CArhzjwJ+m"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcus Sundberg <marcus@ingate.com>
Content-Disposition: inline
In-Reply-To: <43C62EA7.5020001@ingate.com>
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


--4KXkm8CArhzjwJ+m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 12, 2006 at 11:25:43AM +0100, Marcus Sundberg wrote:
> the patch contained a bogus msleep() implementation, please accept
> the following correction.

thanks, applied.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4KXkm8CArhzjwJ+m
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDxjn/XaXGVTD0i/8RApd4AJ9Xgqo1QFabDAcnmJhlXgtyWL9N8gCgm4gm
RZUVcFKbu8MrNlswEbCRGUc=
=SMg+
-----END PGP SIGNATURE-----

--4KXkm8CArhzjwJ+m--
