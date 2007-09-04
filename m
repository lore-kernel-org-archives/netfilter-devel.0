From: Eric Leblond <eric@inl.fr>
Subject: [iptables] NFLOG-testx is not executable
Date: Tue, 04 Sep 2007 21:37:48 +0200
Message-ID: <1188934668.29347.11.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-0skSRf/oHIqP04GPhhKT"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


--=-0skSRf/oHIqP04GPhhKT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

The test for NFLOG is not executable. This prevents NFLOG from building.

A commiter should run the following command to change executable
property in subversion tree:
svn propset svn:executable "on" extensions/.NFLOG-testx

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-0skSRf/oHIqP04GPhhKT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG3bQMnxA7CdMWjzIRAkalAJ9AtvyCziyabEMMPNvWc240nx3P0wCghMbi
2FaddMiTcRVBL6FgK+q2Em8=
=h6u2
-----END PGP SIGNATURE-----

--=-0skSRf/oHIqP04GPhhKT--
