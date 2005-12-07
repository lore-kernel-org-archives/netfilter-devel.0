From: Harald Welte <laforge@netfilter.org>
Subject: Re: nf_conntrack & NAT
Date: Wed, 7 Dec 2005 12:35:17 +0530
Message-ID: <20051207070517.GA4361@rama.exocore.com>
References: <Pine.LNX.4.64.0511231214590.11295@bizon.gios.gov.pl>
	<200511231225.jANCPmYd015427@toshiba.co.jp>
	<20051123132044.GZ3249@eychenne.org>
	<20051123132419.GJ24091@fi.muni.cz>
	<20051206154320.GG4038@rama.exocore.com>
	<20051206173135.GQ5617@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Cc: netfilter-devel@lists.netfilter.org, Jan Kasprzak <kas@fi.muni.cz>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
Content-Disposition: inline
In-Reply-To: <20051206173135.GQ5617@eychenne.org>
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


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 06, 2005 at 06:31:35PM +0100, Herve Eychenne wrote:
> > for stuff like redirecting traffic, all you really need is stateless
> > rewriting of the destination address.  If people want that, the entire
> > implementation fits in a single ip6tables target.  no relation to
> > nf_conntrack at all.
>=20
> Stateless?  And what if you want the response (of the packets which have
> been redirected) to come back with their initial address, as if they
> had not been redirected? (if the client shouldn't know that, if this
> should be transparent to him)

then you need a static snat target that does this for all reply packets.

> This is also known as DNAT, for which the state has be stored, right?

you don't really need state unless you want to do stuff like dynamically
changing port numbers, etc.

> So, in one word: if we definitely need DNAT with IPv4 today, why
> wouldn't we need DNAT with IPv6?

stateful IPv6 NAT only over my dead body.  Do you know that NAT is the
single most destructive way that ever happened to todays internet?  That
it is the number one reason why VoIP doesn't really take off as much as
it could?  The number one reason for various non-deterministic breakage
all over the place?=20

I've participated in the IETF BEHAVE group discussions, and there was
concensus that any BEHAVE compliant NAT must not do NAT for ipv6.
=20
> > also, IPVS doesn't need any ip_conntrack/iptable_nat today,
>=20
> I don't know IPVS implementation, but maybe the IPVS-NAT method could
> theorically share some code with the current NAT code... (they both
> seem to handle the same kind of state table, even if at least the hashing
> algorithm could probably be different, I guess)

*sigh*.  IPVS doesn't use ip_conntrack, so they won't be using
nf_conntrack.  Also, it's their project and their decision.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDlomsXaXGVTD0i/8RAn8kAKCVjmcCSvt8YMCxIbWdzAcyXYB73ACfd6kN
4soXeWLMUU8MjldR+QTAi18=
=qqeZ
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
