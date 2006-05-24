From: Eric Leblond <eric@inl.fr>
Subject: [Announce] NuFW 2.0 is available
Date: Wed, 24 May 2006 09:54:58 +0200
Message-ID: <1148457299.31849.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-M93T0DVcM4o9mYQaRCPp"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter@lists.netfilter.org
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


--=-M93T0DVcM4o9mYQaRCPp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hello Netfilter users,

NuFW 2.0 "extatic porcupine" is available. This is the first release of
the new stable branch of the NuFW project (http://www.nufw.org).

NuFW is an authenticating firewall based on Netfilter.

NuFW can :=20
-  Authenticate any connection that goes through your gateway or only
from/to a chosen subset or a specific protocol (iptables is used to
select the connections to authenticate).=20
-  Perform accounting, routing and quality of service based on users and
not simply on IPs.=20
-  Filter packets with criterium such as application and OS used by
distant users.=20
-  Be the key of a secure and simple Single Sign On system.

Main new Netfilter related features of 2.0 are :

   * Libnfnetlink based interaction with kernel:

NuFW 2.0 is able to use libnetfilter_queue and libnetfilter_conntrack to
handle interaction with kernel.

   * Complete period handling:

ACLs can now be linked with a period. The match against the period is
initially done by NuFW (as time match does) but connection is removed
from conntrack automatically at the end of the period.
Removal can be done via a libnetfilter_conntrack call at end of the
period or directly (with a patched kernel) via connection timeout in the
conntrack. The related patch (fixed_timeout) has been queued by Patrick
McHardy for inclusion in 2.6.18.

More information about new features of NuFW are available at:
	http://www.nufw.org/What-s-new-A-comparison-between.html

Happy "user" filtering to all,
--=20
Eric Leblond <eric@inl.fr>

--=-M93T0DVcM4o9mYQaRCPp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBEdBFRnxA7CdMWjzIRAkeSAJ9CulfMRp99BXVc1EAogJ9dyAm4AACfR5sR
o4sOIaUgyDvGI0tNXdSX9ro=
=ARGS
-----END PGP SIGNATURE-----

--=-M93T0DVcM4o9mYQaRCPp--
