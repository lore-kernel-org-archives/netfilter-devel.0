From: Harald Welte <laforge@netfilter.org>
Subject: Re: Fix --with-kernel for libnfnetlink
Date: Fri, 21 Apr 2006 17:02:58 -0300
Message-ID: <20060421200258.GD10468@rama>
References: <859616420604200825o71f81878lbbb45251f1e0330d@mail.gmail.com>
	<Pine.LNX.4.64.0604201844440.18935@mercury.sdinet.de>
	<4447D839.804@trash.net> <20060420193858.GA24477@sch.bme.hu>
	<4448109A.7010100@trash.net>
	<20060421152520.GA10829@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ycz6tD7Th1CMF4v7"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Content-Disposition: inline
In-Reply-To: <20060421152520.GA10829@localhost.localdomain>
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


--Ycz6tD7Th1CMF4v7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 21, 2006 at 05:25:20PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Apr 21, 2006 at 12:52:10AM +0200, Patrick McHardy wrote:
> > KOVACS Krisztian wrote:
> > >   Is there any chance of getting the pkg-config related modifications
> > > merged as well?
> > >=20
> > >   http://tinyurl.com/mnw9c
> >=20
> > I saw the patch, but didn't apply it because its mostly Harald and
> > Pablo who work on that code.
> >=20
> > @Harald, Pablo: any objections against applying this?
>=20
> No objections from my part, pkg-config is present in most distros AFAIK,
> and we needed a way to explicitely set the version dependencies between
>  libraries.

I agree. please apply.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Ycz6tD7Th1CMF4v7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFESTpyXaXGVTD0i/8RAu3PAJ9VYvfXPR2RE+m84lKppyo6353TogCfYOE1
m8Hwi6L++gqfFP0f+jD67Ho=
=vk/6
-----END PGP SIGNATURE-----

--Ycz6tD7Th1CMF4v7--
