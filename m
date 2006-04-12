From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2/4] kill manually comparing protocol name with
	"ipv6-icmp"
Date: Wed, 12 Apr 2006 10:52:33 +0200
Message-ID: <20060412085233.GQ31616@sunbeam.de.gnumonks.org>
References: <200604071131.k37BVY3F025271@toshiba.co.jp>
	<443A493A.5030307@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pleSNuEbvnUYtMxG"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
Content-Disposition: inline
In-Reply-To: <443A493A.5030307@ufomechanic.net>
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


--pleSNuEbvnUYtMxG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 10, 2006 at 01:02:02PM +0100, Amin Azez wrote:
> Yasuyuki KOZAKAI wrote:
> >[IP6TABLES] kill manually comparing protocol name with "ipv6-icmp"
> >This adds "ipv6-icmp" to chain_protos[] and kill manually comparing
> >the argument of '-p' with it.
> >chain_protos[] has the "icmpv6" with the same protocol number, but it's
> >OK because proto_to_name() returns the firstly matched entry "icmpv6"
> >as ever.
>=20
> I'm uncomfortable with having proto names in source code anyway, to me
> it clashes horribly with getprotobyname and friends which for
> historical and bizarre reasons might be looked up centrally (using
> nss) via ldap !!

We're talking about a firewall here.  Decent security practise suggests
that you block all kind of traffic until you've loaded your ruleset.
Retrieving service/protocol information from NIS/LDAP or other network
based services is a conflicht with this practise and prone to fail
sooner or later, since it creates awkward dependencies (can't
restart/reload firewall because other machine not alive, etc.).

Also, any kind of lookup table can probably be compromised, and any
small change in /etc/{protocols,services} has implicit changes in your
packet filter ruleset, so it provides for an interesting 'hidden' path
for attackers.

So I'm very comfortable in having some values hardcoded, and I very much
support any admin who hardcodes port and protocol numbers in their
rulesets. =20

For similar (and even worse) reasons, I'm strictly against host name
lookup support...

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--pleSNuEbvnUYtMxG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEPL/RXaXGVTD0i/8RApEMAJ0faRx/Ug2FaiIKSXsRU8AIX+XxFQCgsJxA
3qifs80cayjHEofdVEKsEhQ=
=ivjQ
-----END PGP SIGNATURE-----

--pleSNuEbvnUYtMxG--
