From: Alexander Samad <alex@samad.com.au>
Subject: Re: [PATCH]: latest netfilter+ipsec patches
Date: Wed, 10 Mar 2004 13:45:26 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040310024526.GF1072@samad.com.au>
References: <20040128103000.GP11761@sunbeam.de.gnumonks.org> <401D12B6.5030707@trash.net> <40301AB2.2030103@trash.net> <40337D63.6080602@trash.net> <20040218220337.GA3193@alpha.home.local> <40356624.6050209@trash.net> <4047AE0E.1080003@trash.net> <20040304231141.GA1782@alpha.home.local> <20040304234236.GB4995@samad.com.au> <4047DF27.6090904@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y1L3PTX8QE8cb2T+"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <4047DF27.6090904@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Y1L3PTX8QE8cb2T+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Patrick=20

I seem to have found a bug in your patches, but only when used in
conjuction with Herbert's mangle patch.

It seems like there is a loop caused when the packet traverses the
tablesi, in particular ip_route_me_harder.

I tested this on my laptop with debian 2.6.3-2 source with these patches
that you provided on this thread, as well as the Herbert mangle patch.

It seem like the packet on the way out gets encapsulated and then the
encrypted packets try to get re encrypted.

example ipsec.conf

conn wireless
	left=3D10.0.4.129
	leftsubnet=3D0/0
	authby=3Dsecret
	pfs=3Dno
	auto=3Dadd
	right=3D%defaultroute

By the dump it looks like a loop, I added a printk("%d\n", iph->protocol);=
=20
in ip_route_me_harder just before Herberts fix to test that.

When I changed the config to look like this


conn wireless
	left=3D10.0.4.129
	leftsubnet=3D10.6.0/24
	authby=3Dsecret
	pfs=3Dno
	auto=3Dadd
	right=3D%defaultroute

It worked fine


Any other question ask, I have deb's of the image and headers too if you
want.

Alex


On Fri, Mar 05, 2004 at 03:00:07AM +0100, Patrick McHardy wrote:
> Alexander Samad wrote:
> >Q do I understand right that encrypted packets can or can't be acted
> >upon by the hooks in LOCAL_IN.
> >
> >Or another way of putting it does a packet travel the tables twice once
> >as an encrypted packet and once as a de crypted packet ?
>=20
> Exactly, input looks like this:
>=20
> (encrypted) PRE_ROUTING -> LOCAL_IN ->
> (plain) PRE_ROUTING -> LOCAL_IN/FORWARD
>=20
> output looks like this:
>=20
> (plain) FORWARD/LOCAL_OUT -> POST_ROUTING ->
> (encrypted) LOCAL_OUT -> POST_ROUTING
>=20
> This is the same as with freeswan, only without the ipsec
> devices, the policy match can be used as a easy replacement
> for them (-m policy --pol ipsec).
>=20
> Regards,
> Patrick
>=20
> >
> >Alex
> >
> >

--Y1L3PTX8QE8cb2T+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAToFGkZz88chpJ2MRAsRcAJ99GWUvd1Y2Gm10PFDuX3o+11Z8JwCeKtqJ
A/oVSuOFvoSJJYquHDPUmqM=
=WNk6
-----END PGP SIGNATURE-----

--Y1L3PTX8QE8cb2T+--
