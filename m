From: Eric Leblond <eric@inl.fr>
Subject: [announce] pyctd 0.1, a connection tracking XML-RPC server
Date: Wed, 08 Nov 2006 16:31:23 +0100
Message-ID: <1162999883.8096.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-HBbgKDFgao8W9qTbnO1+"
Cc: pyctd-dev@inl.fr, netfilter@lists.netfilter.org
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


--=-HBbgKDFgao8W9qTbnO1+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

INL devel team is proud to announce the availability of pyctd, PYthon
Conntrack Daemon.

pyctd is a XML-RPC service for monitoring and altering Netfilter
connections tracking for network admins.
It has the following functionnalities :
      * Connection listing (with byterate of each connections)
      * Entries removal
      * Modification of connection mark and timeout

pyctd is a free software released under GNU General Public License.

It is based on pynetfilter_conntrack a python binding for
libnetfilter_conntrack.

By using XML-RPC, frontends can be easily built.

A PHP frontend is already available. It displays information given by
the XMLRPC server but can also enhance display by providing information
given by NuFW (mainly username of the person owning the connection).

Main developer of pyctd is Damien Boucard.

pyctd: http://software.inl.fr/trac/trac.cgi/wiki/pyctd
pyctd php frontend:
http://software.inl.fr/trac/trac.cgi/wiki/pyctd/frontends/php
pynetfilter_conntrack:
http://software.inl.fr/trac/trac.cgi/wiki/pynetfilter_conntrack
NuFW: http://www.nufw.org/

BR,
--=20
Eric Leblond <eric@inl.fr>

--=-HBbgKDFgao8W9qTbnO1+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBFUfhLnxA7CdMWjzIRAkrRAJ0e238paYrozZkpc53bTFUQBrCrNACgjb7b
uyqOczHO5J1nFmXpqCsOWBc=
=/BbF
-----END PGP SIGNATURE-----

--=-HBbgKDFgao8W9qTbnO1+--
