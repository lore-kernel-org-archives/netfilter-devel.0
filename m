From: Harald Welte <laforge@netfilter.org>
Subject: Re: fixes for ipv6 supported conntrack and libnetfilter_conntrack
Date: Fri, 6 Jan 2006 00:16:25 +0100
Message-ID: <20060105231625.GV4898@sunbeam.de.gnumonks.org>
References: <200512250736.jBP7aL0B014707@toshiba.co.jp>
	<43AF62FE.4050407@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1rohIOZGhsaeEmnk"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <43AF62FE.4050407@eurodev.net>
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


--1rohIOZGhsaeEmnk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 26, 2005 at 04:26:54AM +0100, Pablo Neira Ayuso wrote:

> I just committed the IPv6 support to SVN. Therefore, IMO we are ready
> for the 1.0rc1 of the conntrack-tool, together with the new version
> (0.0.30) of libnetfilter_conntrack. This could speed up the testing
> process. At this point, the tool contains the features that I had in
> mind for the 1.0 release. Harald?

ok, if you don't mind I'll do te libnetfilter_conntrack and conntrack
releases tomorrow.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--1rohIOZGhsaeEmnk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDvajJXaXGVTD0i/8RAtXdAJwMUc2UoxpJ/6ce1cwSycUPFoJzngCaA5nW
bVEN3lyYOUvM90pMszvNFOY=
=fNSL
-----END PGP SIGNATURE-----

--1rohIOZGhsaeEmnk--
