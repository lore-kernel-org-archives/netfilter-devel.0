From: Alexander Samad <alex@samad.com.au>
Subject: Re: (D)NAT with IPv6 (was "nf_conntrack & NAT")
Date: Tue, 13 Dec 2005 09:56:14 +1100
Message-ID: <20051212225614.GB685@samad.com.au>
References: <20051123132419.GJ24091@fi.muni.cz>
	<20051206154320.GG4038@rama.exocore.com>
	<20051206173135.GQ5617@eychenne.org>
	<Pine.LNX.4.58.0512071201460.17863@blackhole.kfki.hu>
	<20051207145438.GA5617@eychenne.org>
	<Pine.LNX.4.58.0512071603190.17863@blackhole.kfki.hu>
	<20051208114120.GF5617@eychenne.org>
	<20051208115632.GB13067@oknodo.bof.de>
	<20051209045759.GD4244@rama.exocore.com>
	<1134420153.4093.12.camel@bzorp.balabit>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tsOsTdHNUZQcU9Ye"
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
Content-Disposition: inline
In-Reply-To: <1134420153.4093.12.camel@bzorp.balabit>
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


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 12, 2005 at 09:42:33PM +0100, Balazs Scheidler wrote:
> [ trimmed Cc line ]
>=20
> On Fri, 2005-12-09 at 10:27 +0530, Harald Welte wrote:
> > On Thu, Dec 08, 2005 at 12:56:32PM +0100, Patrick Schaaf wrote:
> > > > So each time you add a service on a host, you should assign a new I=
P to it
> > > > (and create the respective DNS name for this IP/service couple!), j=
ust in
> > > > case you may have to redirect its traffic one day? (even if tempora=
ry)
> > >=20
> > > This has proven to be a very valuable strategy, at work, even for nor=
mal
> > > IPv4 operation. Saves headaches every time we want to migrate somethi=
ng.
> > > I can warmly recommend this practise.
> >=20
> > oh btw, this also solves the usual ssl certificate problem, where you
> > for example tell people to use smtp/tls or imap/tls or whatever to
> > "smtp.foo.org" which might be a cname, and thus the certificate name
> > doesn't always match the 'dn' of the cert.
>=20
> Even though this is usually a question of paying for several
> certificates and not being unable to put different certificates to
> different ports.

Has the issue of trying to load balance serveral machine behind a nat
box been brought up for ipv6, if DNAT (and SNAT) are not available for
ipv6 how are you going to hid a farm of servers behind a single (or
multiple addresses), DNS round robin doesn't work because it doesn't
take into account weather the ip is active or not ?


>=20
> --=20
> Bazsi
>=20
>=20
>=20

--tsOsTdHNUZQcU9Ye
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDngAOkZz88chpJ2MRAlEaAJ9V4xx8YIXE6X5OwPmTcHwz6BTLIgCbBhR+
1f3/04oBTxVBej/1qYJoUwA=
=3Y+Z
-----END PGP SIGNATURE-----

--tsOsTdHNUZQcU9Ye--
