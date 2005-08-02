From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 6/7] Fix expectation creation
Date: Tue, 2 Aug 2005 11:47:22 +0200
Message-ID: <20050802094722.GF4158@rama.de.gnumonks.org>
References: <42EE56AD.40505@eurodev.net>
	<20050802074556.GB4158@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i3lJ51RuaGWuFYNw"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20050802074556.GB4158@rama.de.gnumonks.org>
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


--i3lJ51RuaGWuFYNw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 02, 2005 at 09:45:56AM +0200, Harald Welte wrote:
> On Mon, Aug 01, 2005 at 07:06:53PM +0200, Pablo Neira wrote:
> > Expectation creation is broken, now it works again.
>=20
> well, you also make it a nested attribute now.  I'm not sure whether
> this is the way to go.  And if you do, there are certainly some CTA
> values from nfnetlink_conntrack.h that need to be removed with the same
> patch.

Mh. I'm still somewhat undecided on this issue.  We don't encapsulate
'struct ip_conntrack' in one nested attribute, but with your patch we do
it for 'struct ip_conntrack_expect'.  This sounds a bit inconsistent to
me.

Independent of this discussion, could you please submit two patches:
1) one that just fixes the bug(s) that you currently see with expect_create
2) one patch incremental to '1)' that adds nesting of expectations.

I'm trying to find out pro's and con's of nesting in this particular
case.  Is there any functionality that we gain by nesting it?

I'd rather see a seperate list of CTA_... attributes for CONNTRACK and
EXPET message types. =20

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--i3lJ51RuaGWuFYNw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC70EqXaXGVTD0i/8RAvy+AJ0QrjpIaN2G/zT0Q7cEnELO/E7+bwCgppGv
aalfBIHbohkPOrOh8NIWHYc=
=1WEb
-----END PGP SIGNATURE-----

--i3lJ51RuaGWuFYNw--
