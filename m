From: Harald Welte <laforge@netfilter.org>
Subject: Re: ctnetlink questions
Date: Tue, 21 Oct 2003 00:59:04 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031020225904.GH20288@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0310201133040.23768-100000@filer.marasystems.com> <3F942CB6.5060005@trash.net> <20031020183741.GB20288@sunbeam.de.gnumonks.org> <20031020194147.GA11786@balabit.hu> <3F944376.6040903@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GBDnBH7+ZvLx8QD4"
Cc: Balazs Scheidler <bazsi@balabit.hu>,
	Henrik Nordstrom <hno@marasystems.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3F944376.6040903@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--GBDnBH7+ZvLx8QD4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2003 at 10:20:06PM +0200, Patrick McHardy wrote:
> >This _might_ be of interest when complete tables are to be dumped, though
> >the ctnetlink based interface is better when the userspace app provides=
=20
> >more
> >specific queries.
> >
>=20
> I believe we should stick to a single consistent interface for user comfo=
rt.

also, if we stick with netlink, we can easily adapt to netlink2... that
gives us the ability to even remotely dump/modify conntrack tables.

> Best regards,
> Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--GBDnBH7+ZvLx8QD4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/lGi4XaXGVTD0i/8RAt5ZAKCXDg6i1DnJsZH+cjqvONi85qgW1QCgj3Yz
tsX04IREplUPbr3YaSBO4SM=
=9GFq
-----END PGP SIGNATURE-----

--GBDnBH7+ZvLx8QD4--
