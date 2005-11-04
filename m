From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2/3] refcount leak of proto when ctnetlink dumping tuple
Date: Fri, 4 Nov 2005 21:42:13 +0100
Message-ID: <20051104204213.GM5594@sunbeam.de.gnumonks.org>
References: <200511041612.jA4GCVLl011680@toshiba.co.jp>
	<436B9D45.5070407@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HLsZ5Z1opAQvdr2J"
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <436B9D45.5070407@eurodev.net>
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


--HLsZ5Z1opAQvdr2J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 04, 2005 at 06:41:25PM +0100, Pablo Neira wrote:

> As I told you during the workshop, I'll send a patch with the ctnetlink
> port for nfnetlink asap.

I guess you meant nf_conntrack?  that's really great.  I fixed one
additional bug in libnetfilter_conntrack with regard to ipv6 earlier, so
there's hope we can keep the userspace library for both
ip_conntrack/nf_conntrack without any changes.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--HLsZ5Z1opAQvdr2J
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDa8elXaXGVTD0i/8RAgJVAJ9lC5z0Z5KLw/Sd1nNVYvfWKBpk3gCfdgEh
q1Bo4ZWXICPmr6Bvp4Ppwr4=
=9b6o
-----END PGP SIGNATURE-----

--HLsZ5Z1opAQvdr2J--
