From: Alexander Samad <alex@samad.com.au>
Subject: Re: [PATCH]: latest netfilter+ipsec patches
Date: Fri, 12 Mar 2004 11:15:09 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040312001509.GF26800@samad.com.au>
References: <40301AB2.2030103@trash.net> <40337D63.6080602@trash.net> <20040218220337.GA3193@alpha.home.local> <40356624.6050209@trash.net> <4047AE0E.1080003@trash.net> <20040304231141.GA1782@alpha.home.local> <20040304234236.GB4995@samad.com.au> <4047DF27.6090904@trash.net> <20040310024526.GF1072@samad.com.au> <4050E3DE.4010801@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CXFpZVxO6m2Ol4tQ"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4050E3DE.4010801@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--CXFpZVxO6m2Ol4tQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 11, 2004 at 11:10:38PM +0100, Patrick McHardy wrote:
> Alexander Samad wrote:
> >Patrick=20
> >
> >I seem to have found a bug in your patches, but only when used in
> >conjuction with Herbert's mangle patch.
> >
> >It seems like there is a loop caused when the packet traverses the
> >tablesi, in particular ip_route_me_harder.
> >
> >I tested this on my laptop with debian 2.6.3-2 source with these patches
> >that you provided on this thread, as well as the Herbert mangle patch.
> >
> >It seem like the packet on the way out gets encapsulated and then the
> >encrypted packets try to get re encrypted.
>=20
> Thanks for the report, for now the easiest solution is to back out
> Herbert's patch.

I have done that in my local build, but I beleive it is in 2.6.4 (the
changelog)



>=20
> Regards
> Patrick
>=20

--CXFpZVxO6m2Ol4tQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD4DBQFAUQENkZz88chpJ2MRAl2AAJoDgBV2Dcf2RyQOhcXxc0eWW7WtkACRAW5/
fz0jz7QteEkYhhbUz+WzmQ==
=yLHQ
-----END PGP SIGNATURE-----

--CXFpZVxO6m2Ol4tQ--
