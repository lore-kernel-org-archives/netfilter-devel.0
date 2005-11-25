From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was Re:
	CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Fri, 25 Nov 2005 12:09:18 +0100
Message-ID: <20051125110917.GM31478@sunbeam.de.gnumonks.org>
References: <20051122220606.GC31478@sunbeam.de.gnumonks.org>
	<4383C2C9.8050109@eurodev.net> <43843ACE.4050808@trash.net>
	<Pine.LNX.4.64.0511231128510.9162@bizon.gios.gov.pl>
	<20051124200736.GW31478@sunbeam.de.gnumonks.org>
	<20051124202125.GX31478@sunbeam.de.gnumonks.org>
	<43864DC7.6060109@trash.net>
	<Pine.LNX.4.64.0511250040030.14092@bizon.gios.gov.pl>
	<20051125084427.GL31478@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.64.0511251019330.32144@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b+hWpUHvng4oOSdx"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0511251019330.32144@bizon.gios.gov.pl>
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


--b+hWpUHvng4oOSdx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 25, 2005 at 10:23:54AM +0100, Krzysztof Oledzki wrote:
>=20
>=20
> On Fri, 25 Nov 2005, Harald Welte wrote:
>=20
> >On Fri, Nov 25, 2005 at 12:54:56AM +0100, Krzysztof Oledzki wrote:
> >>On Fri, 25 Nov 2005, Patrick McHardy wrote:
> >><CUT>
> >>>I think just the first patch is fine. I really hope we don't find
> >>>more of these.
> >>It is not. It breaks old binaries:
> >yes.  old libnetfilter_conntrack is broken, because it makes wrong size
> >assumptions.  But if we'd start introdcucing the "new scheme" I
> >proposed, we can guarantee not to run into any of these.
> Only if new libnetfilter_conntrack will send different messages to
> differnet kernels (u_int16_t for 2.6.14 and u_int8_t for 2.6.15+).

That's what I meant with 'old lib is broken' (old kernels, too).

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--b+hWpUHvng4oOSdx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDhvDdXaXGVTD0i/8RAlPIAKC1jl+Zd/JkZNvpqjN0txHaN3V54QCgmddS
zXAgwu9EyTCHpuWGBtGiIAI=
=WRlq
-----END PGP SIGNATURE-----

--b+hWpUHvng4oOSdx--
