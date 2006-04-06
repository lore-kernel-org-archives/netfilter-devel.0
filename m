From: Harald Welte <laforge@netfilter.org>
Subject: Re: The future of patch-o-matic-ng
Date: Thu, 6 Apr 2006 12:53:50 +0200
Message-ID: <20060406105350.GT6887@sunbeam.de.gnumonks.org>
References: <Pine.GSO.4.63.0604040002220.15645@galaxy.agh.edu.pl>
	<20060405152628.GI20558@sunbeam.de.gnumonks.org>
	<Pine.GSO.4.63.0604052144350.1472@galaxy.agh.edu.pl>
	<20060406073514.GE6887@sunbeam.de.gnumonks.org>
	<4434CFBF.7030208@trash.net>
	<Pine.LNX.4.64.0604061219580.18845@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E+IgQzR66AIOcbjA"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>, Grzegorz Janoszka <Grzegorz@Janoszka.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0604061219580.18845@bizon.gios.gov.pl>
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


--E+IgQzR66AIOcbjA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 06, 2006 at 12:34:21PM +0200, Krzysztof Oledzki wrote:
> So, this external repository will be used only by netfilter server to
> download patchlets? People will be still able to download complete
> pom-ng package?=20

No, users will actually only download=20

> How it is better from giving access to the svn server?

for security reasons we only do svn-over-webdav-over-https with client
based certificates.  Therefore, it's not very easy to handle, both on
the 'user/developer' side, as well with regards to maintenance on our
side.

Also, using fine-grained permission control (such as giving some 30+
individual developers access to only their patchlet-subdirectories) is a
configuration nightmare.

Therefore, we prefer not to give svn access to people outside the core
development community, webaster, etc.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--E+IgQzR66AIOcbjA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFENPM+XaXGVTD0i/8RAvh1AJ9eO8+0/5WQBDmzlZm9/Quaw4ztfQCffS0a
MB0KYxdgL3H8MWQ0Bf6vP80=
=HzMp
-----END PGP SIGNATURE-----

--E+IgQzR66AIOcbjA--
