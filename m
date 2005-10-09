From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2/5] NETFILTER: Add missing PPTP dependency
Date: Mon, 10 Oct 2005 00:13:16 +0200
Message-ID: <20051009221316.GB6493@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Miller <davem@davemloft.net>
Content-Disposition: inline
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


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

please apply this trivial documentation-only update to your tree:

[NETFILTER] ipt_ULOG: Mark ipt_ULOG as OBSOLETE

Similar to nfnetlink_queue and ip_queue, we mark ipt_ULOG as obsolete.
This should have been part of the original nfnetlink_log merge, but
I somehow missed it.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit 2e64e94fe8e7e4630c9d9e66c437f3ba81e99f78
tree b97a83da44063bfdb4b43c4805e15dbfb1a01ecf
parent 1170becbdb829a1e1120d93bc56b3ffe1a8ef22a
author Harald Welte <laforge@netfilter.org> Sat, 08 Oct 2005 01:02:05 +0200
committer Harald Welte <laforge@netfilter.org> Sat, 08 Oct 2005 01:02:05 +0=
200

 net/ipv4/netfilter/Kconfig |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -499,9 +499,14 @@ config IP_NF_TARGET_LOG
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
 config IP_NF_TARGET_ULOG
-	tristate "ULOG target support"
+	tristate "ULOG target support (OBSOLETE)"
 	depends on IP_NF_IPTABLES
 	---help---
+
+	  This option enables the old IPv4-only "ipt_ULOG" implementation
+	  which has been obsoleted by the new "nfnetlink_log" code (see
+	  CONFIG_NETFILTER_NETLINK_LOG).
+
 	  This option adds a `ULOG' target, which allows you to create rules in
 	  any iptables table. The packet is passed to a userspace logging
 	  daemon using netlink multicast sockets; unlike the LOG target
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDSZX8XaXGVTD0i/8RAjKtAJ0QfI17iSgMZOfMUIlZal/t/JPUqwCeKHQc
vMrR0yfUlhcLwLJLilNAtj4=
=9wPv
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
