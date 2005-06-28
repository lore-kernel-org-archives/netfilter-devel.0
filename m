From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2/2] updates for lib[ct|nf]netlink
Date: Tue, 28 Jun 2005 09:15:43 +0200
Message-ID: <20050628071543.GF13239@sunbeam.de.gnumonks.org>
References: <42C03F39.7000806@eurodev.net>
	<20050627195124.GX19928@sunbeam.de.gnumonks.org>
	<42C0AE9B.9050309@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yia77v5a8fyVHJSl"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <42C0AE9B.9050309@eurodev.net>
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


--Yia77v5a8fyVHJSl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 28, 2005 at 03:57:47AM +0200, Pablo Neira wrote:
> Harald Welte wrote:
> >On Mon, Jun 27, 2005 at 08:02:33PM +0200, Pablo Neira wrote:
> >
> >>This patch attached includes the updates to keep in sync the user space=
=20
> >>libraries with the kernel part.
> >
> >no problem with your patches per se, but
> >please make sure your patches apply with the current code ins svn:
> >
> >patching file libctnetlink/libctnetlink.c
> >Hunk #2 succeeded at 172 (offset -1 lines).
>=20
> Damn, sorry. It seems that I forgot to update my working copy at some=20
> point. I've fixed it. Attached a clean patch. I'll apply if you don't=20
> object.

I'm fine with that, but please don't submit it before patch-o-matic-ng
contains the new kernel code that corresponds to your changes.

--
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Yia77v5a8fyVHJSl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCwPkfXaXGVTD0i/8RAgH7AKC1CPL1yTezcAYfRFQw9yql7Hi60wCfcIWj
DRJYoDp8mf1t7Od9lcHM/TA=
=ZlQ9
-----END PGP SIGNATURE-----

--Yia77v5a8fyVHJSl--
