From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 6/7] Fix expectation creation
Date: Tue, 2 Aug 2005 17:14:59 +0200
Message-ID: <20050802151459.GA4082@rama.de.gnumonks.org>
References: <42EE56AD.40505@eurodev.net>
	<20050802074556.GB4158@rama.de.gnumonks.org>
	<20050802094722.GF4158@rama.de.gnumonks.org>
	<42EF5990.7010900@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <42EF5990.7010900@eurodev.net>
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


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 02, 2005 at 01:31:28PM +0200, Pablo Neira wrote:
> We could move CTA_EXPECT_[TUPLE|MASK] to ctattr_type, kill
> CTA_EXPECT_[ID|TIMEOUT] and use CTA_[ID|TIMEOUT] but then we'll be in
> trouble.=20

Please look at the current netfilter-2.6.14 tree and tell me if you see
any problems with that.

> See that an expectation doesn't have any meaning by itself without a
> conntrack.  That's why I decided to keep it as a nested attributes
> inside a conntrack.  Because of the implicit relationship that links
> them.

it's merely a pointer to the conntrack that can be identified by a
single tuple.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC743zXaXGVTD0i/8RAqEYAKCdaJ9x2llF+xgGXvDWG3esUhQtHgCeJsol
GXMwfeQkclwDplJ+tWj513I=
=NoH1
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
