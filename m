From: Harald Welte <laforge@netfilter.org>
Subject: Re: [Patch 1/2] libnfnetlink, iface conversion to string
Date: Mon, 22 Jan 2007 13:36:18 +0100
Message-ID: <20070122123618.GM9631@prithivi.gnumonks.org>
References: <1167257854.31765.21.camel@localhost>
	<45940145.3020003@netfilter.org>
	<1167349247.15420.13.camel@localhost>
	<20070107142607.GC13543@prithivi.gnumonks.org>
	<1168296086.12298.6.camel@localhost>
	<20070109115120.GX7655@prithivi.gnumonks.org>
	<1169162676.8926.14.camel@localhost>
	<1169163050.8926.16.camel@localhost>
	<45B0E24A.7040906@trash.net> <45B10222.1040806@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pE2VAHO2njSJCslu"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	Vincent Deffontaines <vincent@inl.fr>, Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Content-Disposition: inline
In-Reply-To: <45B10222.1040806@netfilter.org>
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


--pE2VAHO2njSJCslu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 19, 2007 at 06:38:42PM +0100, Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
> > Eric Leblond wrote:
> >>  /* rtnl_receive - receive netlink packets from rtnetlink socket */
> >> -int rtnl_receive()
> >> +int rtnl_receive(int rtnl_fd)
> >=20
> > header file needs to be fixed as well. Is the global rtnl_fd still
> > needed?
>=20
> Indeed. Eric, all this global stuff below must dissapear at all, from
> rtnl.c:

sorry for leaving such a mess of code for you to clean up.  This was
initially from a daemon, nothing that would ever clutter somebody elses'
namespace.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--pE2VAHO2njSJCslu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFFtK/CXaXGVTD0i/8RAuM0AJsGTm0KecuT1NnBTL/DjeEdZzvH/gCfYB7C
nLbjlyF3eVI/P3KOeksayhM=
=705E
-----END PGP SIGNATURE-----

--pE2VAHO2njSJCslu--
