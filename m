From: Harald Welte <laforge@netfilter.org>
Subject: Re: Difference between match and target
Date: Tue, 24 Jun 2003 18:08:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624160824.GR2645@sunbeam.de.gnumonks.org>
References: <20030618222710.9325.98884.Mailman@kashyyyk> <009301c3372c$69cc47f0$010f430a@elitecore7>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xku3GkZTJumTa1rO"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sumit Pandya <sumit@elitecore.com>
Content-Disposition: inline
In-Reply-To: <009301c3372c$69cc47f0$010f430a@elitecore7>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--xku3GkZTJumTa1rO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2003 at 06:33:58PM +0530, Sumit Pandya wrote:
> Hi All,
>=20
>     What is difference between writing match and target extension for
> netfilter? Is there something in match which I cannot achieve in target a=
nd
> vice-versa?

=66rom a technical point of view, there is not much differrence.=20
There are no technical restrictions, it's a mere policy:
Matches match against packet data
Targets connect some action with previously matched packets.

>  Someone to throw some light on this design? Mr. Rusty, Mr. Harald?
>=20
> -- Sumit

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--xku3GkZTJumTa1rO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++Hd4XaXGVTD0i/8RAmg/AJwPkpFi3S7bTD75ZAvl2AbpcOfNogCeITiz
SHtehV4C8KM3NyznSA/8TKo=
=FeV7
-----END PGP SIGNATURE-----

--xku3GkZTJumTa1rO--
