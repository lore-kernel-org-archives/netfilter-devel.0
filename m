From: Eric Leblond <eric@inl.fr>
Subject: [Announce] NuFW 0.9.0 available
Date: Thu, 26 Aug 2004 14:54:57 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1093524897.4293.19.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-B/pQpnYhVd8BWygDoifc"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-B/pQpnYhVd8BWygDoifc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

We are pleased to announce the first release of the NuFW development
branch : NuFW 0.9.0.

It features quite a lot of brand new things. The most meaningful are the
protocol version 2 :

* A more evolutive protocol which will be able to support features like
application announcement (and thus per application filtering)
* Authentication is performed via SASL
* Encryption is performed via TLS
* It now uses username and not userid

and the cache system :

* User request is only performed at the authentication stage
* A cache has been added at the acl decision stage. Benches show
dramatically increased performances at no security cost (See
http://www.nufw.org/proto2_and_more.html for results).

You can expect more as next 0.9 releases will follow :

* Encryption of communications between nufw and nuauth. This is very
soon.
* Support for several Nufw gateways on nuauth.
* Application match support for even finer filtering control.
* Full IPv6 support.

0.9.0 should not be considered stable, as many deep rewrites have
occured (and are still to occur) in the code as well as in structures.
However, it is available for testing, benching, etc. As usual,
bugreports, wishes and comments will be welcome!


Happy user filtering,

The NuFW team.


--=-B/pQpnYhVd8BWygDoifc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBBLd2hnxA7CdMWjzIRAgkrAJ9oOHNCKQixHpefwmI0KQZbiASj+ACaAvYQ
2eGC013RX/Ad1z1tf45bRLU=
=Fdcz
-----END PGP SIGNATURE-----

--=-B/pQpnYhVd8BWygDoifc--
