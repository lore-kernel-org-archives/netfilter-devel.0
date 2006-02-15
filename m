From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 0/3] nf_conntrack: fixes for nf_ct_attach in IPv6 stack
Date: Wed, 15 Feb 2006 08:47:40 +0100
Message-ID: <20060215074740.GE15587@sunbeam.de.gnumonks.org>
References: <43F0B76E.7050007@trash.net>
	<200602140348.k1E3msEc020481@toshiba.co.jp>
	<43F204B8.5060700@trash.net>
	<200602141759.k1EHxfk0009760@toshiba.co.jp>
	<43F21DBC.70506@trash.net>
	<Pine.LNX.4.58.0602142138090.23784@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wTWi5aaYRw9ix9vO"
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	Patrick McHardy <kaber@trash.net>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0602142138090.23784@blackhole.kfki.hu>
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


--wTWi5aaYRw9ix9vO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 14, 2006 at 09:41:59PM +0100, Jozsef Kadlecsik wrote:
> On Tue, 14 Feb 2006, Patrick McHardy wrote:
>=20
> > Yasuyuki KOZAKAI wrote:
> > > IIRC, __{ip,nf}_conntrack_confirm is called at POSTROUTING and INPUT,
> > > after all processing of packet filter. If I do
> > >
> > > 	ip6tables -A FORWARD -p tcp --dport 22 -j REJECT
> > >
> > > on my router, the conntrack of TCP SYN packet of ssh will never confi=
rmed
> > > and then nf_conntrack will create new conntrack for TCP RST at OUTPUT.
> >
> > RSTs and ICMP errors without existing connections should be ignored
> > by conntrack (and marked as INVALID). Are you sure the RSTs create
> > new conntracks?
>=20
> Marking packets created by the REJECT target as INVALID would break
> the functionality of the target itself. Even if there is no real
> "master" connection, RELATED was more appropriate.

I totally agree.  Also, we have to keep 100% semantic compatibility with
the existing ip_conntrack setups, otherwise we'd confuse users and
create lots of broken packet filters.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wTWi5aaYRw9ix9vO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD8tycXaXGVTD0i/8RAkhwAJ9t8OwHHQ9LlgSeDNGAP/HMurZzAQCgkCPi
O3kEHfYsJWBaxcEhvRXmajU=
=PJ3s
-----END PGP SIGNATURE-----

--wTWi5aaYRw9ix9vO--
