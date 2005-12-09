From: Harald Welte <laforge@netfilter.org>
Subject: Re: (D)NAT with IPv6 (was "nf_conntrack & NAT")
Date: Fri, 9 Dec 2005 10:27:59 +0530
Message-ID: <20051209045759.GD4244@rama.exocore.com>
References: <200511231225.jANCPmYd015427@toshiba.co.jp>
	<20051123132044.GZ3249@eychenne.org>
	<20051123132419.GJ24091@fi.muni.cz>
	<20051206154320.GG4038@rama.exocore.com>
	<20051206173135.GQ5617@eychenne.org>
	<Pine.LNX.4.58.0512071201460.17863@blackhole.kfki.hu>
	<20051207145438.GA5617@eychenne.org>
	<Pine.LNX.4.58.0512071603190.17863@blackhole.kfki.hu>
	<20051208114120.GF5617@eychenne.org>
	<20051208115632.GB13067@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="48TaNjbzBVislYPb"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@lists.netfilter.org, Herve Eychenne <rv@wallfire.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20051208115632.GB13067@oknodo.bof.de>
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


--48TaNjbzBVislYPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 08, 2005 at 12:56:32PM +0100, Patrick Schaaf wrote:
> > So each time you add a service on a host, you should assign a new IP to=
 it
> > (and create the respective DNS name for this IP/service couple!), just =
in
> > case you may have to redirect its traffic one day? (even if temporary)
>=20
> This has proven to be a very valuable strategy, at work, even for normal
> IPv4 operation. Saves headaches every time we want to migrate something.
> I can warmly recommend this practise.

oh btw, this also solves the usual ssl certificate problem, where you
for example tell people to use smtp/tls or imap/tls or whatever to
"smtp.foo.org" which might be a cname, and thus the certificate name
doesn't always match the 'dn' of the cert.

A very clean solution, indeed.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--48TaNjbzBVislYPb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDmQ7XXaXGVTD0i/8RAhmBAKCo3pM0WHyILv1qZRawjPnwo+B5iACfQbvL
KumuwDMe419CWwmpiAGldGw=
=nehd
-----END PGP SIGNATURE-----

--48TaNjbzBVislYPb--
