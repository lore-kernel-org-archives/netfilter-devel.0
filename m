From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6 9/14]: Fix offset calculation in amanda conntrack helper
Date: Mon, 21 Jun 2004 21:44:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621194406.GO24374@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B4kTqtjDNMSIbfiv"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
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


--B4kTqtjDNMSIbfiv
Content-Type: multipart/mixed; boundary="yT5CehYOm/p2z10t"
Content-Disposition: inline


--yT5CehYOm/p2z10t
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

This patch for 2.6 fixes offset calculation in the amanda conntrack
helper, which was broken by the recent changes to the expectation API.
Without this patch, the offset points beyond the port number instead
of to it's beginning.

Author: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Harald Welte <laforge@netfilter.org>

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--yT5CehYOm/p2z10t
Content-Type: text/plain; charset=us-ascii; name="09.diff"
Content-Disposition: inline; filename="09.diff"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/20 22:45:31+02:00 kaber@trash.net=20
#   [NETFILTER]: Fix offset calculation in amanda conntrack helper
#=20
# net/ipv4/netfilter/ip_conntrack_amanda.c
#   2004/06/20 22:45:22+02:00 kaber@trash.net +1 -1
#   [NETFILTER]: Fix offset calculation in amanda conntrack helper
#=20
diff -Nru a/net/ipv4/netfilter/ip_conntrack_amanda.c b/net/ipv4/netfilter/i=
p_conntrack_amanda.c
--- a/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-06-20 23:00:42 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-06-20 23:00:42 +02:00
@@ -107,7 +107,7 @@
 		exp->mask.dst.u.tcp.port =3D 0xFFFF;
=20
 		exp_amanda_info =3D &exp->help.exp_amanda_info;
-		exp_amanda_info->offset =3D data - amanda_buffer;
+		exp_amanda_info->offset =3D tmp - amanda_buffer;
 		exp_amanda_info->port   =3D port;
 		exp_amanda_info->len    =3D len;
=20


--yT5CehYOm/p2z10t--

--B4kTqtjDNMSIbfiv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA1zqGXaXGVTD0i/8RAjTpAKCBIDbD0nZbA78tpanNx1uWRkms3ACffjGN
ajY836e6XqPbqEiBnijmgiQ=
=aLgB
-----END PGP SIGNATURE-----

--B4kTqtjDNMSIbfiv--
