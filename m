From: Lennart Poettering <lennart@poettering.de>
Subject: Announcing SEPPL
Date: Tue, 8 Oct 2002 23:05:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021008210515.GA12996@whiskey.dummy.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, cryptoapi-devel@kerneli.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I want to announce the first alpha release of SEPPL, a new software of
me with relevance for both Netfilter and Cryptoapi. A short
description follows:

<snip>

SEPPL - Simple Encrypting Packet Protocol Layer
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SEPPL is both a protocol definition and a software implementation of a
new encryption layer for IPv4. It makes use of symmetric cryptogrpahy
for encrypting the whole traffic on given networks. Its implementation
is designed around Linux netfilter/iptables.=20

SEPPL introduces two new netfilter targets: CRYPT and DECRYPT. A
firewall rule may thus be used for encrypting/decrypting the incoming
and outgoing network traffic. This makes SEPPL extraordinarily easy to
use, since no running daemons are needed for secure communications.

SEPPL uses the encryption engine of the Linux CryptoAPI
(http://www.kerneli.org).

SEPPL is primarily intended for encrypting wireless LANs (as secure
replacement of the broken WEP encryption) and local ethernet networks
but may be used for large scale VPN solutions as well.

</snip>

More information may be found at http://www.ring2.org/seppl/

It currently works quite fine but is alpha since it is neither well
tested nor feature complete. Please check it out and send me bug
reports and improvement suggestions.

License is GPL.=20

Thank you for your interest,
 Lennart Poettering

--=20
name { Lennart Poettering } mail { lennart@poettering.de }
icq { 11060553 } www { http://www.poettering.de/lennart/ }
loc { hamburg, germany } pgp { 0x1A015CC4 } hack { .phi. }

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.0 (GNU/Linux)

iD8DBQE9o0iLMn8mlRoBXMQRAoIrAJwLNx/9CZq6/j8PH32y7si1ry4gnACgjdSP
dMJCilCCFRPo0Gxwvfrk5Cw=
=nOlT
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
