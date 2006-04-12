From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 1/3] [kernel patch] fixed duration connection
Date: Wed, 12 Apr 2006 12:48:24 +0200
Message-ID: <20060412104824.GU31616@sunbeam.de.gnumonks.org>
References: <1144139619.5186.24.camel@localhost.localdomain>
	<4433CCBF.6060103@trash.net> <4436DF6B.4060208@inl.fr>
	<4436E03E.9030402@inl.fr> <44381584.4020109@trash.net>
	<20060412083835.GN31616@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jPC/Tkukgh9ZDT79"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>, Eric Leblond <eric@inl.fr>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	nufw-devel@nongnu.org
Content-Disposition: inline
In-Reply-To: <20060412083835.GN31616@sunbeam.de.gnumonks.org>
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


--jPC/Tkukgh9ZDT79
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 12, 2006 at 10:38:36AM +0200, Harald Welte wrote:

> not for the bit, but in general we would need one, otherwise we have an
> (extremely large) timer entry per conntrack...

Sorry, I read the wrong version of the patch.  Ignore that comment ;)

I don't think we need a config option, but actually could enable this
statically.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--jPC/Tkukgh9ZDT79
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEPNr4XaXGVTD0i/8RAjX+AJsESVGu+76a2VjvUaUmKI3AahxpuwCdGqft
5LX8uOPm/H+aMC+bIhrROgA=
=NBye
-----END PGP SIGNATURE-----

--jPC/Tkukgh9ZDT79--
