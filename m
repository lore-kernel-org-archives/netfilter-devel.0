From: Harald Welte <laforge@netfilter.org>
Subject: Re: nf_conntrack [was Re: [PATCH 1/4] RFC: fast string matching
	infrastrure for netfilter]
Date: Fri, 14 Jan 2005 09:37:31 +0100
Message-ID: <20050114083731.GI9070@sunbeam.de.gnumonks.org>
References: <41E1AECD.6020209@eurodev.net> <41E1B9F1.7010106@trash.net>
	<Pine.LNX.4.58.0501102041430.28819@blackhole.kfki.hu>
	<41E2E631.3060102@trash.net>
	<20050110212807.GZ18568@sunbeam.de.gnumonks.org>
	<41E73258.7030002@trash.net>
	<1105686102.7311.101.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Zw+/jwnNHcBRYYu"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <1105686102.7311.101.camel@localhost.localdomain>
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


--/Zw+/jwnNHcBRYYu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 14, 2005 at 06:01:42PM +1100, Rusty Russell wrote:

> It was IRC, and for IPv6 I agree with Harald that it's probably not the
> right mechanism.  I prefer a simple discriminated union and two slab
> caches (IPv4 and IPv6), which is hardcoded, but still fairly easy to
> read.

so what about the nat_info ?  If you load iptable_nat, it will be needed
for all connections...

> > >But, then think of a firewall in front of an FTP (IRC/...) Server, and
> > >your traffic pattern immediately looks like 50% of your connections (n=
ot
> > >talking about traffic) have helper private data... and my argument
> > >becomes stronger again.
>=20
> I don't think so.  While you will have to do an additional allocation on
> connection creation, the only real per-packet cost is the extra
> cacheline (the memchr to find the data in the extend is deliberately
> trivial).   They'll gain more by removing the copying into buffer on
> those helpers, and the lock that goes with it.

ok, convinced for helpers.

> Does that mean I should *not* send the expectation and NAT patches to
> DaveM now?  (Posted before the ct_extend patches):

I was wondering all the time why we keep talking about maintainance mode
for ip_conntrack and the coincidential spike in new development for
ip_conntrack.

I think if we push it into ip_conntrack, we need to make sure
nf_conntrack is in sync at the same time - otherwise poor Yasuyuki has
to (again) sync all the changes... I think he did that often enough...

> Thanks,
> Rusty.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--/Zw+/jwnNHcBRYYu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB54TLXaXGVTD0i/8RAiyyAKCzGoesVMKuMcrIiZl2IOMi+J+6WACfQw8S
+CKHJGQJ+wT5YhPT+/alBRU=
=O3zR
-----END PGP SIGNATURE-----

--/Zw+/jwnNHcBRYYu--
