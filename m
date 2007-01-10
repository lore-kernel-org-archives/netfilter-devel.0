From: Harald Welte <laforge@netfilter.org>
Subject: [ADMINISTRATIVE] IPv6 renumbering of netfilter.org servers
Date: Wed, 10 Jan 2007 02:23:29 +0100
Message-ID: <20070110012329.GB23020@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Cc: netfilter-mirrors@lists.netfilter.org,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

This is just a short notice that I've had to renumber our IPv6 addresses
a couple of hours ago.  The prefix for all current machines has changed from

	2001:780:0:1d::/64

to=20

	2001:780:45:1d::/64

The DNS record should all have been updated accordingly.  As an "extra",
we now also finally have valid v6 reverse lookups.

And if you're now asking yourelf, why did we have to do this?  The
allocation for my set of co-located servers (among them *.netfilter.org)
has been enlarged from an initial /64 up to a /48.  And that I need for
"fire+forget" stateless autoconfiguration of my many OpenVZ virtual
hosts, which so far have only been reachable via IPv4.

Cheers,

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFFpEAQXaXGVTD0i/8RAr+DAKC0eMQpEjjVAcmwJYIXDwqGzMX9jACfYyYA
LSrAcW6/zOioDLpsrC4uODM=
=5N93
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
