From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH 3/2] Fix compile with NAT but without modules
Date: Sun, 23 Jan 2005 01:38:52 +0100
Message-ID: <1106440732.20995.48.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-ESO4zeyjnQZ2sdj9md33"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
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


--=-ESO4zeyjnQZ2sdj9md33
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Patrick

Here's another patch to fix compile-errors, this time with NAT but
without modules.
There's a missing 'extern' in ip_conntrack_tftp.h

Please submit this patch to davem for inclusion in 2.6.11

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>

diff -X /home/gandalf/dontdiff.ny -urNp linux-2.6.11-rc2.orig/include/linux=
/netfilter_ipv4/ip_conntrack_tftp.h linux-2.6.11-rc2/include/linux/netfilte=
r_ipv4/ip_conntrack_tftp.h
--- linux-2.6.11-rc2.orig/include/linux/netfilter_ipv4/ip_conntrack_tftp.h	=
2005-01-22 15:23:45.000000000 +0100
+++ linux-2.6.11-rc2/include/linux/netfilter_ipv4/ip_conntrack_tftp.h	2005-=
01-23 01:31:25.000000000 +0100
@@ -13,7 +13,7 @@ struct tftphdr {
 #define TFTP_OPCODE_ACK		4
 #define TFTP_OPCODE_ERROR	5
=20
-unsigned int (*ip_nat_tftp_hook)(struct sk_buff **pskb,
+extern unsigned int (*ip_nat_tftp_hook)(struct sk_buff **pskb,
 				 enum ip_conntrack_info ctinfo,
 				 struct ip_conntrack_expect *exp);
=20

--=20
/Martin

--=-ESO4zeyjnQZ2sdj9md33
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBB8vIbWm2vlfa207ERAqtoAJ0cUx2bbX/SiG+g5iUumMe+9xw5qgCfaH+M
t7nFvJ1NhRz7jbEG46jO9KA=
=Gngl
-----END PGP SIGNATURE-----

--=-ESO4zeyjnQZ2sdj9md33--
