From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] remove overzealous checks in REJECT target]
Date: Fri, 17 Dec 2004 08:54:42 +0100
Message-ID: <20041217075442.GB11436@sunbeam.de.gnumonks.org>
References: <20041216133959.GH10165@sunbeam.de.gnumonks.org>
	<41C2720B.7@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <41C2720B.7@trash.net>
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


--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 17, 2004 at 06:43:39AM +0100, Patrick McHardy wrote:
> Harald Welte wrote:
>=20
> >Hi Patrick!
> >
> >I agree with Yasuyuki's proposed changes, do you already have this patch
> >in your pending queue?
>
> I missed it, but the patch is wrong. We must return at least 8 byte of
> protocol header, so the check can't be removed. The skb_header_pointer
> part looks fine, I'm going to apply it after getting some sleep.

> RFC1122: =A73.2.2:

Thanks for pointing this out.  I certainly read it a number of times
before, but it slipped my mind temporarily.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBwpDCXaXGVTD0i/8RAqz9AJ9yfpvh0zJeaxXO9Y+GtPnxPQ8lDACggXXc
Gg3/RtVOe3HMf8CWdbfBbyM=
=HPFh
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
