From: Eric Leblond <eric@inl.fr>
Subject: [Patch 0/2] Avoid direct connections between NATed hosts
Date: Fri, 12 Jan 2007 17:59:27 +0100
Message-ID: <1168621167.28615.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-M7xttVDH0eQwgxHWsY3d"
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


--=-M7xttVDH0eQwgxHWsY3d
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

Some algorithms can be used to established direct connections between
NATed hosts. Skype is one of the programs using this kind of "feature".

Some details can be found here :
	http://www.heise-security.co.uk/articles/print/82481

It uses the fact that port is usually sequentially increased and is thus
predictable.

This patches against kernel and iptables add the capability to randomize
the source port used when doing SNAT.

Tests have been done and have show that Skype is no more able to
established a direct connection between NATed hosts.

Randomization of the source port can be activated on a per-rule basis
with the following syntax:

iptables -A POSTROUTING -t nat -o eth0 -j SNAT --to 192.168.1.3:random

or

iptables -A POSTROUTING -t nat -o eth0 -j SNAT --to 192.168.1.3:1234-3456:r=
andom

BR,
--=20
=C9ric Leblond, eleblond@inl.fr
T=E9l=E9phone : 01 44 89 46 39, Fax : 01 44 89 45 01
INL, http://www.inl.fr

--=-M7xttVDH0eQwgxHWsY3d
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBFp75vnxA7CdMWjzIRAkmgAJ9Gww5ihK5jTgTXClo0iwA/o6KjxwCghLWm
Xtd0L+dqZevXM+XRpS7xV6E=
=bvt/
-----END PGP SIGNATURE-----

--=-M7xttVDH0eQwgxHWsY3d--
