From: Harald Welte <laforge@netfilter.org>
Subject: Re: x_tables userspace
Date: Sat, 21 Jan 2006 15:48:32 +0100
Message-ID: <20060121144832.GZ4603@sunbeam.de.gnumonks.org>
References: <333e1ca10601160212g4a9f21e8p78c26fd113197a60@mail.gmail.com>
	<43CB93C4.4060500@eurodev.net>
	<333e1ca10601161201y238a82e5oec6e67c361792f61@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mEvYxaKTQdy27sIr"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Michal Rokos <michal.rokos@gmail.com>
Content-Disposition: inline
In-Reply-To: <333e1ca10601161201y238a82e5oec6e67c361792f61@mail.gmail.com>
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


--mEvYxaKTQdy27sIr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 16, 2006 at 09:01:18PM +0100, Michal Rokos wrote:
> Hello,
>=20
> On 1/16/06, Pablo Neira Ayuso <pablo@eurodev.net> wrote:
> > Michal Rokos wrote:
> > > now when x_tables are merged one question has to come:
> > >
> > > Is there any userspace prog that can manage x_tables? Something like =
ip46tables?
> > No, this does not suppose any change from userspace side. It's just part
> >  of the ipv4-ipv6 code reunification.
>=20
> Well - there should be any userspace that does the same as ipt_match
> or ipt_conntrack.

yes, there should.  However, it's a terrible amount of work.  I'm at it,
and it's already some 5000 line patch, and I'm not even finished with
IPv4 alone.

I don't see any reason to rush this, I'm fine when it is finished when
2.6.16 is released.

We can verify that the kernel code is fine by using existing
ip(6)tables.

Maybe later today I'll start an iptables-1.4.x branch in svn - but don't
expect it to work.

> Sure I have from the very beginning.... I even altered ipt_match to do
> the same for ip6t (it's just a s/ip/ip6/), but I hate it. I'm looking
> for something that can handle ip4 and ip6 without having 2 binaries
> with very common codebase...

yes, it will be available.  Please just wait a bit...

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--mEvYxaKTQdy27sIr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD0knAXaXGVTD0i/8RAgeSAKCnHhZWV6bYVtOddv2AVVy1xxz3wQCgngxg
tFlISZ9luPKjBG2O61NLEtE=
=rDFA
-----END PGP SIGNATURE-----

--mEvYxaKTQdy27sIr--
