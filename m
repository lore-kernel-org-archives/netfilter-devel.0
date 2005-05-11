From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH pom-ng 0/6] H.323: implement a "real" H.245 parser
Date: Wed, 11 May 2005 10:01:47 +0200
Message-ID: <20050511080147.GT30482@sunbeam.de.gnumonks.org>
References: <20050510225019.GA5102@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ERTmRuwYb9f9/XmE"
Cc: netfilter-devel@lists.netfilter.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
Content-Disposition: inline
In-Reply-To: <20050510225019.GA5102@roonstrasse.net>
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


--ERTmRuwYb9f9/XmE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 11, 2005 at 12:50:19AM +0200, Max Kellermann wrote:
> Hi,
>=20
> the following patchset replaces Jozsef's "brute force" parser with a
> real H.245 parser. It adds a very simple ASN.1/PER parsing library,
> and parses very few H.245 structures (enough for all H.323 software I
> tested).

Thanks, this is great news.  Including the list of tested h.323 software
somwhere in the 'info' or 'help' file would definitely be a good idea.

I'd happily apply your patches but leave it up to Jozsef, since he's
more familiar with the protocol and the helper he wrote.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ERTmRuwYb9f9/XmE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCgbvrXaXGVTD0i/8RApgUAJ9mbq+0CfbK3jgWnECc0u2pNBBtjgCeJiBV
GHCOKcpnD6hVQAE3BY4yWVQ=
=RC2Z
-----END PGP SIGNATURE-----

--ERTmRuwYb9f9/XmE--
