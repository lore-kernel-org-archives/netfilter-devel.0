From: Eric Leblond <eric@inl.fr>
Subject: [ANNOUNCE] mod_auth_nufw, an apache authentication module
Date: Wed, 23 Jun 2004 17:30:04 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1088004603.5595.57.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-X/6ohQgYPlYjMVah3bJf"
Cc: Vincent Deffontaines <vincent@inl.fr>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-X/6ohQgYPlYjMVah3bJf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hello everyone,

NuFW core team and INL are proud to introduce mod_auth_nufw, an SSO
apache authentication module using the NuFW authentication framework, to
you.

You may think "Hey, we're talking about Netfilter here. Not apache !",
but this is indeed about Netfilter :
Let's have first a few word about NuFW. NuFW is a GPL authentication
firewall suite working under Linux, based on Netfilter.
Its main feature is that it can trustfully authenticate connections, and
link them to actual user IDs (stored in an LDAP tree).=20
It also provides other features, such as user id marking of packet,
dynamic acls list, ...

For more information on NuFW see :
        http://www.nufw.org

NuFW 0.7.1, which was released last week, introduces an option that
permits to build a real-time authenticated connection tracking table :
it's a sort of Conntrack table where each entry contains IP parameters
of the connection and the identity of user at the origin of this
connection and the state of the connection. This table is stored in an
SQL database (both MySQL and PostgreSQL are supported).

As a server (like Apache) knows about the IP parameters of the
connections it receives, it can query the SQL database to find the
corresponding entry for each connection. Mod_auth_nufw performs this
exact task for Apache : lookup in the Nufw "conntrack" for the userID,
and let Apache know this user is now identified (and authenticated).
(The authorization task then lays on other Apache modules, and is just
the classical process)

This gives the server the identity of the user who opened the
connection. So the authentication of the user by the server is done and
it's fully transparent to the user. Thus, this principle allows to build
complete Single Sign On systems where the key is a netfilter firewall
using NuFW.

mod_auth_nufw is the first authentication module that uses NuFW
authentication principle. It permits to achieve Single Sign On for a
whole set of apache servers.

mod_auth_nufw is available for download at :
        http://www.inl.fr/article.php3?id_article=3D24

Best regards,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-X/6ohQgYPlYjMVah3bJf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBA2aH6nxA7CdMWjzIRAmG9AJ9i73/XcrQvKBERPD0NuImf/2ri5gCdG1IO
O7FWWXP50I9ihRM9izOP+3E=
=TjFt
-----END PGP SIGNATURE-----

--=-X/6ohQgYPlYjMVah3bJf--
