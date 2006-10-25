From: Oskar Andreasson <oan@frozentux.net>
Subject: RFC1812 and CLUSTERIP
Date: Wed, 25 Oct 2006 14:05:18 +0200
Message-ID: <1161777918.8705.63.camel@LAPTOP4.MSHOME>
Reply-To: oan@frozentux.net
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-8o1C0odqOLItOetGmbJF"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--=-8o1C0odqOLItOetGmbJF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi all again,

I've snowed in on the CLUSTERIP target to some extent, and I am still
figuring it out to some extent.=20

One question that came to mind is its use of multicast MAC addresses. Is
it really allowed to make use of them in the way that it is right now?

=46rom RFC 1812 section 3.3.2:

------
   A router MUST not believe any ARP reply that claims that the Link
   Layer address of another host or router is a broadcast or multicast
   address.
------

As I understand it, this is exactly what the CLUSTERIP target does?=20
Behaves as if a single host has a multicast address?


--=20
Oskar Andreasson <oan@frozentux.net>
www.frozentux.net

--=-8o1C0odqOLItOetGmbJF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBFP1L+GadwPDPpB60RApezAJ4rRYS48EZxK+1bYMEs8HEcKZmVYACeJu7T
ppz9DmtnRhvqDOWcgGP4jeo=
=Qx6a
-----END PGP SIGNATURE-----

--=-8o1C0odqOLItOetGmbJF--
