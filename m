From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] relax ip_conntrack_[nat_]proto_find_get checkings
Date: Tue, 22 Nov 2005 23:01:51 +0100
Message-ID: <20051122220151.GB31478@sunbeam.de.gnumonks.org>
References: <4381D553.5030906@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NqE6tsP4GBwPxixq"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@netfilter.org>
Content-Disposition: inline
In-Reply-To: <4381D553.5030906@netfilter.org>
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


--NqE6tsP4GBwPxixq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 21, 2005 at 03:10:27PM +0100, Pablo Neira wrote:
> Remove proto =3D=3D NULL checking since ip_conntrack_[nat_]proto_find_get
> always returns a valid pointer. Fix missing ip_conntrack_proto_put in
> some paths as well.

thanks, applied and submitted.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--NqE6tsP4GBwPxixq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDg5VPXaXGVTD0i/8RAiDjAJ9FMc0v2hcLCLXA4gkhii9cm7Y3NgCeKoy6
+zSvEQco8r/1NLMGVij+ekU=
=jhm8
-----END PGP SIGNATURE-----

--NqE6tsP4GBwPxixq--
